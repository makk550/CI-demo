trigger UpdateAccountProducts on Product_Alignment__c (after insert,after update,after delete) {
/*
Map <Id,String> prodMap = new Map <Id,String>();
Set <Id> prodIds = new Set <Id>();
Set <Id> delProdIds = new Set <Id>();
Set <Id> accnts = new Set <Id>();
List <Account> updateAccounts = new List <Account>();
Map <Id,String> prodMapForMod = new Map <Id,String>();


 if(Trigger.isInsert || Trigger.isUpdate){
  for(Integer i=0; i<trigger.new.size(); i++){
  
  if(Trigger.isInsert){
   if(Trigger.new[i].Product_Group__c!= null || Trigger.new[i].Product_Group_MPL__c!=null){ 
      prodIds.add(Trigger.new[i].Id);
    }
   }
   else if(Trigger.isUpdate){  
   
   if(Trigger.new[i].Product_Group__c<>Trigger.old[i].Product_Group__c || 
      Trigger.new[i].Product_Group_MPL__c <> Trigger.old[i].Product_Group_MPL__c){
       
      accnts.add(Trigger.new[i].Related_Account__c);
   
   }         
  }       
 }
 }
 
 
 if(Trigger.isDelete){
   for(Integer j=0; j<trigger.old.size(); j++){
    if(Trigger.old[j].Product_Group__c!= null || Trigger.old[j].Product_Group_MPL__c!=null){ 
      delProdIds.add(Trigger.old[j].Id);
      accnts.add(Trigger.old[j].Related_Account__c);
    }
  } 
 }
 
 System.debug('Sizeeee&&&&&&&&&&&&&&&&&'+prodIds.size());
 
 if(prodIds.size()>0){
   List <Product_Alignment__c> prodAlignment = [select Id,Product_Group__c,Product_Group_MPL__c,Related_Account__r.Region_Country__c, 
                                                Related_Account__c from Product_Alignment__c where Id in : prodIds];
                    
                                             
 
 for(Product_Alignment__c prodAlnmnt : prodAlignment){ 
 
   string country = prodAlnmnt.Related_Account__r.Region_Country__c;
   string prodGrp ='';
   
   if(country=='JP')
      prodGrp = prodAlnmnt.Product_Group__c;
   else
      prodGrp = prodAlnmnt.Product_Group_MPL__c;
   
 
 if(prodGrp !=null){
   if(prodMap.containsKey(prodAlnmnt.Related_Account__c)){
    
       String prodFamily=prodMap.get(prodAlnmnt.Related_Account__c);
       if(ProdFamily <> null && !ProdFamily.contains(prodGrp)){       
        prodFamily = ProdFamily + ';' + prodGrp;   
        prodMap.put(prodAlnmnt.Related_Account__c,prodFamily);      
       }             
     }
   else     
      prodMap.put(prodAlnmnt.Related_Account__c,prodGrp); 
  }    
 }
 System.debug('prodMap --------------'+prodMap);
 
 }
 
 if(accnts.size()>0){
   List <Product_Alignment__c> prodAlignment = [select Id,Related_Account__c,Product_Group__c,Product_Group_MPL__c,Related_Account__r.Region_Country__c 
                                                from Product_Alignment__c where Related_Account__c in : accnts and Id not in : delProdIds];
   
   for(Product_Alignment__c prodAlnmnt : prodAlignment){
   
    string country = prodAlnmnt.Related_Account__r.Region_Country__c;
    string prodGrp ='';
    
      if(country=='JP')
         prodGrp = prodAlnmnt.Product_Group__c;
      else
         prodGrp = prodAlnmnt.Product_Group_MPL__c;
      
      if(prodGrp ==null)
         prodGrp='';
   
     if(prodMapForMod.containsKey(prodAlnmnt.Related_Account__c)){ 
      
       String prodFamily=prodMapForMod.get(prodAlnmnt.Related_Account__c);
       if(ProdFamily <> null && !ProdFamily.contains(prodGrp)){
          if(prodFamily=='')
             prodFamily = prodGrp;
          else    
          prodFamily = ProdFamily + ';' + prodGrp;  
          
          prodMapForMod.put(prodAlnmnt.Related_Account__c,prodFamily);    
          System.debug('----'+prodMapForMod);  
       }             
     }
    else     
      prodMapForMod.put(prodAlnmnt.Related_Account__c,prodGrp);    
   } 
   
    if(prodAlignment!=null){       
       for(ID id:accnts){
          if(!prodMapForMod.containsKey(id))
              prodMapForMod.put(id,'');
       }         
    }       
 }
 
 
 if(prodMap.size()>0){  
    List <Account> acc = [select Product_Family__c,Id from Account
                                              where Id in : prodMap.keySet()];
                                              
                                              
  for(Account partnAccnt : acc){
  
   if(partnAccnt.Product_Family__c != null ){    
    
     list<String> listStr = new list<String>();       
     String strGrouplist  = prodMap.get(partnAccnt.Id); 
   
     if(strGrouplist!=null)
        listStr  = strGrouplist.split(';');
     
     string prodFamily='';
     for (integer i=0 ; i < listStr.size();i++)
     {
      if (!partnAccnt.Product_Family__c.Contains(listStr.get(i) )){
          if(prodFamily=='')
            prodFamily=listStr.get(i);     
          else
            prodFamily = prodFamily+';'+listStr.get(i);
      }
                          
     }
      if(prodFamily!=''){ 
         partnAccnt.Product_Family__c = partnAccnt.Product_Family__c+';'+prodFamily;
         updateAccounts.add(partnAccnt); 
      }   
  }else {
      partnAccnt.Product_Family__c = prodMap.get(partnAccnt.Id);
      updateAccounts.add(partnAccnt); 
  }   
    
  }
  
 }
 
 
 if(prodMapForMod.size()>0){  
  
  List <Account> acc = [select Product_Family__c,Id from Account
                                              where Id in : prodMapForMod.keySet()];
                                              
                                              
  for(Account partnAccnt : acc){
      
     if(prodMapForMod.get(partnAccnt.Id)!=null) 
       partnAccnt.Product_Family__c = prodMapForMod.get(partnAccnt.Id);
     else
       partnAccnt.Product_Family__c = '';
       System.debug('************'+partnAccnt.Product_Family__c);
    updateAccounts.add(partnAccnt); 
  }
  
 }
 
 
 if(updateAccounts.size()>0){
  
   Update updateAccounts; 
 }
 */
}