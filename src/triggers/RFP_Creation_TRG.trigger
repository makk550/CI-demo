trigger RFP_Creation_TRG on RFP_Qualification__c (before insert) {
    
 //Decimal oppNumber = trigger.new[0].Opportunity_Number__c;
 //Opportunity oppObj = [Select Id from opportunity where Opportunity_Number__c =: 'oppNumber' ];
 List<RFP__c> lst = new List<RFP__c>();
  RFP__c rfpObj ;
 For( RFP_Qualification__c rfpQual: Trigger.New)
 {
     rfpObj = new RFP__c();
     rfpObj.Opportunity__c = rfpQual.Opportunity__c;
     rfpObj.Due_Date__c = rfpQual.RFx_Due_Date__c;
     rfpObj.Name=rfpQual.RFx_Name__c;
     rfpObj.Type__c = rfpQual.Type__c;
     lst.add(rfpObj);
}

Database.insert(lst, false);

integer index_temp =0;
For( RFP_Qualification__c rfpQual: Trigger.New)
{
    rfpQual.rfp__c = lst[index_temp].id;    
    index_temp ++;    
}

}