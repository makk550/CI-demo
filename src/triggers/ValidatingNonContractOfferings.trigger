trigger ValidatingNonContractOfferings on Non_Contract_Offering_Business_Rules__c (before insert,before update) {

    List <Non_Contract_Offering_Business_Rules__c> rulesList = new List<Non_Contract_Offering_Business_Rules__c>();
    for(Non_Contract_Offering_Business_Rules__c aFeatures:Trigger.New)
    {
        if(Trigger.isInsert || Trigger.isUpdate){
            Integer totalSize=[SELECT count() FROM Non_Contract_Offering_Business_Rules__c WHERE Offering_Business_Rules__c=:aFeatures.Offering_Business_Rules__c
                               AND CA_Product_Controller__c=:aFeatures.CA_Product_Controller__c AND Site_Association__c=:aFeatures.Site_Association__c AND Start_Date__c=:aFeatures.Start_Date__c AND End_Date__c=:aFeatures.End_Date__c];
            if( totalSize>0 )
            {
                aFeatures.addError('There is a Non Contract Offering already with this combination');
            }  
        }
    }
}