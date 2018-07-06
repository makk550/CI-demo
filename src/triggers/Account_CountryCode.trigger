trigger Account_CountryCode on Account (before insert, before update) {
     
      if(SystemIdUtility.isneeded)
        return;
      if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
    //added by Siddharth (PRM R2)- class to populate partenr ratings for PLM_R2
    PLM_AccountPercentCompleteForPartner classVar=new PLM_AccountPercentCompleteForPartner();
    
    for (Account a : Trigger.new) {
        if (a.Country_Picklist__c != null)
        {
            a.BillingCountry = a.Country_Picklist__c.substring(0,2);
        }   
        //update account Region, Area and Territory text fields with picklist counter parts
        a.Region_Text__c=a.Geo__c;      
        a.Area_Text__c=a.Sales_Area__c;     
        a.Territory_Country_Text__c=a.Sales_Region__c;      
    }   
    
    //added by Siddharth (PRM R2)- to call class to ppulate the rating based on the given conditions
    if(SystemIdUtility.hasPopulatedPartnerRating==false)
    {
        List<Account> populateAccounts = new List<Account>();
        for(Account a:Trigger.new){
            if(SystemIdUtility.getResellerDistRecordTypeId()==a.recordtypeid || SystemIdUtility.getTechPartnerRecordTypeId()==a.recordtypeid)
            populateAccounts.add(a);
        }
        if(populateAccounts.size()>0)
            classVar.populatePartnerRating(populateAccounts); 
        SystemIdUtility.hasPopulatedPartnerRating =true;
    }
}