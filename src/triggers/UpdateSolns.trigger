trigger UpdateSolns on Partner_Location__c (before insert) {
/**
  This trigger is to populate Route To Market,CA Solutions,Partner Program Level.
  
  Route To Market: fetch RTM from contact if it is blanlk then fetch from Account where program level is not Trnasacting.
  CA Solutions:    fetch from product alignments where product is Partner approved and Authorized.
  Partner Program Level: fetch from account where program level is not transacting.
**/

   Map<Id,List<Partner_Location__c>> partnLoc = new Map<Id,List<Partner_Location__c>>();
   Set<String> route= new Set<String>();  
   List <Partner_Location__c> updPartnLocations = new List <Partner_Location__c>();
   
   List<Partner_Location__c> partnerLoc = new List <Partner_Location__c>();
   for(Partner_Location__c pl: Trigger.new){
       
       if(! partnLoc.containsKey(pl.Account__c))
          partnLoc.put(pl.Account__c,new List<Partner_Location__c>());                   
          partnLoc.get(pl.Account__c).add(pl);                     
      
   }

    System.debug('-----partnLoc'+partnLoc);
     //get product alignment records assoicated with Partner locator's related accounts.
     
     List <Product_Alignment__c> prodAlignments = [select Related_Account__c,RTM__c,Product_Group__c,JP_Product_Group__c,Country__c
                                                    from Product_Alignment__c where Related_Account__c in: partnLoc.keySet()
                                                    and Partner_Approved__c = True and
                                                    Authorized_Agreement__c = True and Route_To_Market__c != null];
                                                    
     
     system.debug('prodAlignments'+prodAlignments);                                              
     
     List <Contact> ContactLst = [select AccountId,Email,RTM__c from contact where AccountId in:  partnLoc.keySet()];
     
     
     Map<String,String> prodMap= new Map<String,String>();
     
     Map<String,String> contactMap= new Map<String,String>();
    
    Integer k=0;
    List<String> valList = new List<String>();
          
     for(Product_Alignment__c prodAlignment : prodAlignments) {
                                
            String key = prodAlignment.Related_Account__c+'-'+prodAlignment.RTM__c;
            String val = prodMap.get(key);
            String prdGrp ='';
         
            if(prodAlignment.Country__c == 'JP' && prodAlignment.JP_Product_Group__c!=null){
                               
               prdGrp = prodAlignment.JP_Product_Group__c;         
            }
            else if(prodAlignment.Product_Group__c!=null) {          
               
               prdGrp = prodAlignment.Product_Group__c;
            }
            
            if(prdGrp!=''){
             if(val!=null){
                 //if(!val.contains(prdGrp)){
                  val =val+';'+prdGrp;
                 k=k+1;
                 //}
             }                            
                else{
                val=prdGrp;
                k=k+1;}                      
            } 
             
              prodMap.put(key, val);                                               
        
    }
    system.debug('k'+k);
    for(Contact con : ContactLst){
    
      contactMap.put(con.AccountId+'-'+con.Email,con.RTM__c);
    
    }
    
    
/*
    Set <Id> partnLocSet = new Set<Id>();
    partnLocSet = partnLoc.keySet();
  */      
    for(Id accntId: partnLoc.keySet()){
    
      partnerLoc = partnLoc.get(accntId);
      
      for(Partner_Location__c pl : partnerLoc){
      
        //Populate RTM
        if(pl.Route_To_Market__c == null || pl.Route_To_Market__c==''){
           if(pl.Account__c!=null && pl.Point_of_Contact_Email__c!=null && contactMap.get(pl.Account__c+'-'+pl.Point_of_Contact_Email__c)!=null )
              pl.Route_to_market__c = contactMap.get(pl.Account__c+'-'+pl.Point_of_Contact_Email__c);
           else{
                if(pl.CA_RTM__c!=null)
                  pl.Route_To_Market__c = pl.CA_RTM__c;
                else 
                  pl.Route_To_Market__c = 'Data Management';              
           }
                
         }
        // if(pl.Route_to_market__c!=null){
                     
            List<String> lstRTM = new List<String>();
            lstRTM  = pl.Route_to_market__c.split(';');            
            String prodGrp='';
            
          	system.debug('lstRTM'+lstRTM);
          	system.debug('lstRTMsize'+lstRTM.size());
          
            for (integer i=0 ; i < lstRTM.size();i++){  
             if(prodGrp=='' && prodMap.get(pl.Account__c+'-'+lstRTM.get(i))!=null)             
                prodGrp = prodMap.get(pl.Account__c+'-'+lstRTM.get(i));
             else if(prodMap.get(pl.Account__c+'-'+lstRTM.get(i))!=null)
                prodGrp = prodGrp+';'+prodMap.get(pl.Account__c+'-'+lstRTM.get(i));
             
            }
          
          system.debug('prodMap'+prodMap);
          system.debug('prodGrp'+prodGrp);
              //pl.CA_Solutions_List__c = prodGrp; 
              /* This code is to avoid duplicate solutions on partner locations if the 
                locator is belongs to more than one route and have same solutions. 
                */
                
             if(prodGrp!=null && prodGrp!=''){
               List<String> lstprodGrp = new List<String>();
               lstprodGrp  = prodGrp.split(';');
               system.debug('lstprodGrp'+lstprodGrp);  
               system.debug('lstprodGrpsize'+lstprodGrp.size());
                 String productGroup='';
               
               Set<String> uniqPG = new Set<String>();
               for(String s: lstprodGrp )
               uniqPG.add(s);
               
               system.debug('uniqPG'+uniqPG);
               system.debug('uniqPGsize'+uniqPG.size());
                 
               List<String> lstprodGrp1 = new List<String>(uniqPG);
               System.debug('lstprodGrp1 :'+lstprodGrp1 );
               for (integer j=0 ; j < lstprodGrp1.size();j++){
                    if(productGroup !=''){
                       //if(!productGroup.contains(lstprodGrp.get(j)))
                       productGroup = productGroup+';'+lstprodGrp1.get(j);
                    }   
                   else{
                      productGroup=lstprodGrp1.get(j);                                                                    
                   }  
               //system.debug('productGroup'+productGroup);
               }
               System.debug('--productGroup:'+productGroup);
               pl.CA_Solutions_List__c = productGroup; 
                    
             }
              
              
              if(pl.CA_Program_Level__c!=null){
                List<String> lstProgLevel = new List<String>();
                
                System.debug('--------------'+lstProgLevel);  
                lstProgLevel  = pl.CA_Program_Level__c.split(';');  
                String progLevel = '';
                for (integer i=0 ; i < lstProgLevel.size();i++){  
                 if(lstProgLevel.get(i)!=null && lstProgLevel.get(i)!='' && lstProgLevel.get(i) != 'Transacting'){
                    if(progLevel !='' && !progLevel.contains(lstProgLevel.get(i))) 
                     progLevel = progLevel +';'+ lstProgLevel.get(i);
                    else 
                     progLevel = lstProgLevel.get(i);  
                 }                                                         
                }
                  pl.Partner_Program_Level__c = progLevel;                    
              }
            
              System.debug('--------------'+pl.CA_Solutions_List__c);
        // }                          
      }    
    }

}