trigger Renewal_UpdateOpportunityType on CA_Product_Renewal__c (After Insert,After Delete,After Update) 
{
  List<CA_Product_Renewal__c> listcontCAPR =New List<CA_Product_Renewal__c>();
  RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('New Opportunity');
  String recId =rec.RecordType_Id__c;   
  Map<String,String> oppTypeMapValues = new Map<String,String>();
  oppTypeMapValues.put('Product','PNCV');
  oppTypeMapValues.put('Renewal','Renewal');
  oppTypeMapValues.put('Services','Services');
  oppTypeMapValues.put('Support','Support');
  oppTypeMapValues.put('Education','Standalone Education');
  oppTypeMapValues.put('Product,Renewal','Renewal w/Products');
  oppTypeMapValues.put('Product,Services','PNCV w/Services');
  oppTypeMapValues.put('Product,Support','PNCV w/Support');
  oppTypeMapValues.put('Product,Education','PNCV w/Education');
  oppTypeMapValues.put('Renewal,Services','Renewal w/Services');
    oppTypeMapValues.put('Support,Renewal','Renewal w/Support');
    oppTypeMapValues.put('Education,Renewal','Renewal w/Education');
    oppTypeMapValues.put('Services,Education','Services w/Education');
    oppTypeMapValues.put('Support,Education','Education w/Support');
    oppTypeMapValues.put('Services,Support','Services w/Support');
    oppTypeMapValues.put('Product,Services,Renewal','Renewal w/Products & Services');
    oppTypeMapValues.put('Product,Support,Renewal','Renewal w/Products & Support');
    oppTypeMapValues.put('Product,Education,Renewal','Renewal w/Products & Education');
    oppTypeMapValues.put('Product,Services,Support','PNCV w/Services & Support');
    oppTypeMapValues.put('Product,Services,Education','PNCV w/Services & Education');
    oppTypeMapValues.put('Product,Support,Education','PNCV w/Education & Support');
    oppTypeMapValues.put('Services,Support,Renewal','Renewal w/Services & Support');
    oppTypeMapValues.put('Services,Education,Renewal','Renewal w/Services & Education');
    oppTypeMapValues.put('Support,Education,Renewal','Renewal w/Education & Support');
    oppTypeMapValues.put('Services,Support,Education','Services w/Education & Support');
    oppTypeMapValues.put('Product,Services,Support,Education','PNCV w/Services, Education & Support');
    oppTypeMapValues.put('Services,Support,Education,Renewal','Renewal w/Services, Education & Support');
    oppTypeMapValues.put('Product,Services,Education,Renewal','Renewal w/Products, Services & Education');
    oppTypeMapValues.put('Product,Support,Education,Renewal','Renewal w/Products, Education & Support');
    oppTypeMapValues.put('Product,Support,Services,Renewal','Renewal w/Products, Services & Support');    
    oppTypeMapValues.put('Product,Services,Support,Education,Renewal','Renewal w/Products, Services, Education & Support');
      
 Set<Id> AcIds =New Set<Id>();    
 Set<Id> prdoductids =New Set<Id>();
 Set<Id> oppIds=New Set<Id>();
 List<Active_Contract_Product__c> lst_ACP =new List<Active_Contract_Product__c>();
 //try{
 
     
     
     
       // List<Active_Contract_Product__c> lst_ACP =new List<Active_Contract_Product__c>();
    
        
             if(Trigger.isInsert)
             {  for(CA_Product_Renewal__c lineItem_ACP :Trigger.new)
                {
                  if(lineItem_ACP.Renewal_Opportunity__c<>null)
                  oppIds.add(lineItem_ACP.Renewal_Opportunity__c);      
                  Active_Contract_Product__c acp =new  Active_Contract_Product__c(Id=lineItem_ACP.Active_Contract_Product__c,Converted_To_Opportunity__c =true);
                  lst_ACP.add(acp);
                  
                }  
             } //update lst_ACP; 
             if(Trigger.isUpdate)
             {
                 for(CA_Product_Renewal__c lineItem_ACP :Trigger.new)
                {
                 oppIds.add(lineItem_ACP.Renewal_Opportunity__c);
                }
             }      
         
     if(Trigger.isDelete)
     {
        
        for(CA_Product_Renewal__c lineItem_ACP :Trigger.old)
        {
          oppIds.add(lineItem_ACP.Renewal_Opportunity__c);
          Active_Contract_Product__c acp =new  Active_Contract_Product__c(Id=lineItem_ACP.Active_Contract_Product__c,Converted_To_Opportunity__c =false);
          lst_ACP.add(acp);                
        }        
     }
     if(lst_ACP.size()>0)
        update lst_ACP;
    /*}catch(Exception e){
        Opportunity opp = new Opportunity(Id = lineItem_ACP.Renewal_Opportunity__c);
        opp.addError('Error '+e);
    }*/
    //System.debug('oppIds
     if(oppIds.Size()>0){
        String set_type='';
        Integer caProdCount =0;
        List<Opportunity> oppListValues = [select Id,Opportunity_Type__c,
                                        Projected_Renewal__c,Total_Raw_Maintenance_Cacl__c,
                                        (Select Name, Active_Contract_Product__c,Projected_Renewal__c,
                                        Raw_Maintenance__c From CA_Product_Renewals__r)
                                         from Opportunity where Id in:oppids and RecordTypeId=:recId];
        for(Opportunity opp1: oppListValues){
            Set<String> setOfOppType = oppTypeMapValues.keyset();
            String keyrequired='';
            for(String s: setOfOppType){
                String strVal=oppTypeMapValues.get(s);
                System.debug('strVal ##'+strVal);
                System.debug('opp1.Opportunity_Type__c ##'+opp1.Opportunity_Type__c);
                if(strVal == opp1.Opportunity_Type__c)
                    keyrequired = s;
            }
            caProdCount = opp1.CA_Product_Renewals__r.size();
            
            // added for updating projected renewal at Opportunity level
            if(!Renewals_Util.Renewal_updateProjectedRenewalOnOpp){
                List<CA_Product_Renewal__c> caProductList = opp1.CA_Product_Renewals__r;
                if(Trigger.isInsert || Trigger.isUpdate){
                Decimal projRenewal = 0;
                for(CA_Product_Renewal__c ca:caProductList){
                        // added for adding  
                        projRenewal += (ca.Projected_Renewal__c==null?0:ca.Projected_Renewal__c);                                            
                     }
                  opp1.Projected_Renewal__c =  projRenewal;  
                 }  
             }  
            
        if(Trigger.isInsert){ 
                if(opp1.Opportunity_Type__c == null || opp1.Opportunity_Type__c==''){
                    opp1.Opportunity_Type__c = 'Renewal';
                    
                }
                else {
                         
                    
                        if(keyrequired.contains('Renewal') )
                         {
                             set_type = keyrequired ;
                             
                            opp1.Opportunity_Type__c = oppTypeMapValues.get(set_type);
                         }
        
                        if(keyrequired.contains(',Renewal'))
                        {
                            set_type = keyrequired + ',Renewal';
                            
                            opp1.Opportunity_Type__c = oppTypeMapValues.get(set_type);
                        }else
                        {
                            opp1.Opportunity_Type__c = 'Renewal';
                        }
            }
        }
        if(Trigger.isDelete){

                System.debug('DDDDDDDDDDDDDDDDDDDDDDD'+caProdCount);
                String OppType1;
                String OppType2;
                caProdCount = [Select Count() from CA_Product_Renewal__c where  Renewal_Opportunity__c in: oppIds ];
                if(opp1.Opportunity_Type__c == null && caProdCount > 0)
                    opp1.Opportunity_Type__c ='Renewal';
                if(opp1.Opportunity_Type__c != null && caProdCount == 0){
                    
                        
                       /// opp1.Opportunity_Type__c = 'aaaaxxxx';
                         
                    /*if(keyrequired.contains('Renewal,')){
                        OppType1 = keyrequired.substring(0,keyrequired.indexOf('Renewal,'));
                        OppType2 = keyrequired.substring(keyrequired.indexOf('Renewal,')+8,keyrequired.length());
                        System.debug('OppType1 '+OppType1 +'OppType2 '+OppType2);
                        set_type = OppType1 + OppType2;
                        opp1.Opportunity_Type__c = oppTypeMapValues.get(tempOppType);
                    }else*/
                     if(keyrequired.contains(',Renewal') && caProdCount  > 0  ){
                        OppType1 = keyrequired.substring(0,keyrequired.indexOf(',Renewal'));
                        set_type = OppType1.trim();
                        
                        opp1.Opportunity_Type__c = oppTypeMapValues.get(set_type);
                    }else{
                        
                        
                          if (caProdCount==0)
                          {
                          List<OpportunityLineItem> lst_oppli = new List<OpportunityLineItem>();
                           lst_oppli = [select Id,PricebookEntry.product2Id,OpportunityId from OpportunityLineItem where OpportunityId in: oppids];
      
            
                             if( lst_oppli.size() >0){
                                    opp1.Opportunity_Type__c = 'PNCV';
                                     
                             }
                             else{
                               opp1.Opportunity_Type__c = '';
                                
                             }
                          }// end ifif (caProdCount==0)
                    }
                }   
            }                
        }
        
        update oppListValues;     
 }
  //modified by subsa03 
          Set<Id> OppLineIds =New Set<Id>();   
          List<Opportunity> UpdateOpp= new List<Opportunity>();
                                 
          if(Trigger.isInsert)             
          {           
              for(CA_Product_Renewal__c lineItem_ACP :Trigger.new)
                {
                  if(lineItem_ACP.Renewal_Opportunity__c<>null)
                   {
                       OppLineIds.add(lineItem_ACP.Renewal_Opportunity__c);                                                                                         
                   }
                }  
                
                
          }

          if(Trigger.isdelete)             
          {
              for(CA_Product_Renewal__c lineItem_ACP :Trigger.old)
                {
                  if(lineItem_ACP.Renewal_Opportunity__c<>null)
                   {
                     OppLineIds.add(lineItem_ACP.Renewal_Opportunity__c);                       
                   }
                }               
         }

        if(Trigger.isUpdate)             
          {
              for(CA_Product_Renewal__c lineItem_ACP :Trigger.new)
                {
                  if(lineItem_ACP.Renewal_Opportunity__c<>null)
                   {
                    OppLineIds.add(lineItem_ACP.Renewal_Opportunity__c);                      
                   }
                }
         }
     
       
         if(OppLineIds.Size()>0){
          List<Opportunity> oppUpdate = [Select o.Id From Opportunity o where o.Id in: OppLineIds];   
          List<CA_Product_Renewal__c> maxDate = [select Original_Expiration_Date__c,Original_Deal_Term__c  from CA_Product_Renewal__c c  where  Renewal_Opportunity__c in: OppLineIds];
          List<CA_Product_Renewal__c> lstAC =[select Contract__r.Status_Formula__c from CA_Product_Renewal__c  where  Renewal_Opportunity__c in: OppLineIds   and  Contract__r.Status_Formula__c  != 'Validated' ];
          
           if(Trigger.isInsert)             
          {
           for(Opportunity Op:oppUpdate){
            if(maxDate.size()>0){
                for(CA_Product_Renewal__c cadate: maxDate){
                     Op.Original_Expiration_Date__c = cadate.Original_Expiration_Date__c;
                     Op.Original_Deal_Term_Months__c = cadate.Original_Deal_Term__c;
                   }
                }
           if(lstAC.Size()>0){
                    Op.Finance_Valuation_Status__c ='Not Validated';          
                }else{Op.Finance_Valuation_Status__c ='Validated';}
                UpdateOpp.add(op);
               }
              }
           if(Trigger.isUpdate)
           {
           for(Opportunity Op:oppUpdate){
            if(maxDate.size()>0){
                for(CA_Product_Renewal__c cadate: maxDate){
                     Op.Original_Expiration_Date__c = cadate.Original_Expiration_Date__c;
                     Op.Original_Deal_Term_Months__c = cadate.Original_Deal_Term__c;
                   }
                }
           if(lstAC.Size()>0){
                    Op.Finance_Valuation_Status__c ='Not Validated';          
                }else{Op.Finance_Valuation_Status__c ='Validated';}
                UpdateOpp.add(op);
               }
           }
           if(Trigger.isDelete)
           {
           for(Opportunity Op:oppUpdate){
            if(maxDate.size()>0){
                for(CA_Product_Renewal__c cadate: maxDate){
                     Op.Original_Expiration_Date__c = cadate.Original_Expiration_Date__c;
                     Op.Original_Deal_Term_Months__c = cadate.Original_Deal_Term__c;
                   }
                }
           if(lstAC.Size()>0){
                    Op.Finance_Valuation_Status__c ='Not Validated';          
                }else{Op.Finance_Valuation_Status__c ='Validated';}
                UpdateOpp.add(op);
               }
           }
           update UpdateOpp;
          }                                      
}