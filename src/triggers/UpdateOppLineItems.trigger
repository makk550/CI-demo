trigger UpdateOppLineItems on Product2 (after insert,after update,after delete) {

  if(SystemIdUtility.skipProductTriggers)
            return;


Set<ID> prdids = new Set<ID>();
Set<ID> OppIds = new Set<ID>();
//Set<String> Milestone = new Set<String>();

        RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('New Opportunity');
        Id oppRecId = rec.RecordType_Id__c;
        RecordTypes_Setting__c rec2 = RecordTypes_Setting__c.getValues('Acquisition');
        Id oppRecId2 = rec2.RecordType_Id__c;
        

        if(Trigger.isInsert)
        {
            for(Product2 prd : Trigger.new)
            {      
              if(prd.Upfront_Revenue_Eligible__c == 'Yes')
                {                    
                    prdids.add(prd.id);
                }
            }
        }
        else if(Trigger.isUpdate)
        {
            for(Product2 prd : Trigger.new)
            {
                if(prd.Upfront_Revenue_Eligible__c != Trigger.oldmap.get(prd.id).Upfront_Revenue_Eligible__c)
                {
                  prdids.add(prd.id);
                }
            }
        }
        else if(Trigger.isDelete)
        {
            for(Product2 prd : Trigger.old)
            {
                if(prd.Upfront_Revenue_Eligible__c == 'Yes')
                    prdids.add(prd.id);
            }                
        }

        if(prdids.size() > 0)
        {
            Map<id,Product2> productsUpdated= new Map<id,Product2>([select id,Upfront_Revenue_Eligible__c from product2 where id in:prdids and Salesforce_CPQ_Product__c=false ]); // and  IsActive = true]);
            Map<id,Opportunity> mOpp = new Map<id, Opportunity>();
            Map<Id,Integer> mapOpptyUpfrontProdCount = new Map<Id,Integer>();
              
            List<OpportunityLineItem> oppline =([select Id,Opportunity.Opportunity_Number__c, Opportunity.Upfront_Product_Count__c, OpportunityId,Stretch__c,Term_Month__c,X1st_Year_Maintenance__c,UF_License_Fee__c,New_Deal_Term_Months__c,Original_Deal_Term_Months__c,UnitPrice,PricebookEntry.Product2Id  from OpportunityLineItem 
            where PricebookEntry.Product2Id in:productsUpdated.keyset() //prdids 
            and Business_Type__c != 'Renewal'and Business_Type__c != 'MF Capacity' 
            AND Opportunity.recordTypeid in (:oppRecId ,: oppRecId2) AND Opportunity.isClosed = false
            ORDER by Opportunity.createddate ASC, Createddate asc]);                       
            
                
                
            for(OpportunityLineItem o: oppline){
                System.debug('____Prod____'+o.PricebookEntry.product2Id+'______opp___'+o.opportunity.id);
            }    
                
            for(OpportunityLineItem oli: oppline)            
            {
              Opportunity opp  = mOpp.get(Oli.OpportunityId);
              if(Opp == null) opp = oli.Opportunity;
            
              system.debug('opp.Upfront_Product_Count__c before = '+ opp.id);
              system.debug('opp.Opportunity_Number__c before = '+ opp.Opportunity_Number__c);
              system.debug('opp.Upfront_Product_Count__c before = '+ opp.Upfront_Product_Count__c);

              if(productsUpdated <> null && productsUpdated.get(oli.PricebookEntry.Product2Id) <> null && productsUpdated.get(oli.PricebookEntry.Product2Id).Upfront_Revenue_Eligible__c  == 'Yes')
              {                
                Decimal totMaint;   
                Decimal totSalesPrice = (oli.UnitPrice <> null? oli.UnitPrice : 0);
                Decimal termInYears =   (oli.Term_Month__c <> null? oli.Term_Month__c /12 : 0);     
            
                Decimal UFLicenseFee = 0;
                if(termInYears <> 0)
                    UFLicenseFee  = (10 *  totSalesPrice ) /  (10 + 2 * termInYears);      
                totMaint  =  0.2 * UFLicenseFee * termInYears ;
                Decimal FirstYearMaint = 0;
                if(termInYears <> 0)
                    FirstYearMaint = totMaint / termInYears;
                     
                oli.UF_License_Fee__c = UFLicenseFee;
                oli.X1st_Year_Maintenance__c = FirstYearMaint;
                oli.Upfront_Revenue_Eligible__c = true;
              
                if(opp.Upfront_Product_Count__c != null)
    opp.Upfront_Product_Count__c =  opp.Upfront_Product_Count__c+1;
else
    opp.Upfront_Product_Count__c  = 1;
              }
              else 
              {
                oli.UF_License_Fee__c = null;
                oli.X1st_Year_Maintenance__c = null;
                oli.Upfront_Revenue_Eligible__c = false; 
                if(opp.Upfront_Product_Count__c != null)
                        opp.Upfront_Product_Count__c =  opp.Upfront_Product_Count__c -1;
                    else
                        opp.Upfront_Product_Count__c  = 0;
              }
                system.debug('opp.Upfront_Product_Count__c after = ' + opp.Upfront_Product_Count__c);
                
              mOpp.put(opp.id, opp);
            }

            if(oppline.size() > 0 )
            {
                
          SystemIdUtility.skipOpportunityLineItemTriggers = true;
          SystemIdUtility.skipOpportunityTriggers = true;
          
              Database.update(oppline, false);
              Database.update(mOpp.values(),false);
            }
            for(Opportunity opp: mOpp.values()){
                System.debug('____OPP____'+opp.Id);
            }
            
        }
}