trigger updateDMValues on Account (before insert,before update) {

    Map<String,DM_Territory__c> dmMap = new Map<String,DM_Territory__c>();
    Set<String> cpSet = new Set<String>();
    List<DM_Territory__c> dmList = new List<DM_Territory__c>();
    for(Account account : trigger.new)
    {
        cpSet.add(account.Country_Picklist__c);
    }
    if(cpSet!=null && cpSet.size()>0)
    dmList = [Select DM_Sales_Region__c, DM_Territory__c, Country_Picklist__c from DM_Territory__c where Country_Picklist__c in: cpSet];
    if(dmList!=null && dmList.size()>0)
    for(DM_Territory__c dm : dmList)
    {
        dmMap.put(dm.Country_Picklist__c, dm);
    } 
    if(trigger.isupdate && trigger.isbefore)
    {
        for(Account newAccount : trigger.new)
        {
            Account oldAccount = trigger.oldMap.get(newAccount.Id);
            if(newAccount.Country_Picklist__c != oldAccount.Country_Picklist__c)
            {
                if(dmMap.get(newAccount.Country_Picklist__c)!=null)
                {
                    DM_Territory__c dm = dmMap.get(newAccount.Country_Picklist__c);
                    newAccount.DM_Sales_Region__c = dm.DM_Sales_Region__c;
                    newAccount.DM_Territory__c = dm.DM_Territory__c;
                }
            } 
            
            if(newAccount.Service_Provider_Type__c != oldAccount.Service_Provider_Type__c || newAccount.Account_Type__c != oldAccount.Account_Type__c)
            {
                if(newAccount.Service_Provider_Type__c != null && newAccount.Account_Type__c!=null)
                newAccount.MSP_Check__c = newAccount.Service_Provider_Type__c +':'+ newAccount.Account_Type__c;
                else if(newAccount.Account_Type__c==null)
                newAccount.MSP_Check__c = newAccount.Service_Provider_Type__c ; 
                else if(newAccount.Service_Provider_Type__c == null )
                newAccount.MSP_Check__c = newAccount.Account_Type__c;
            }           
        }
    }
    if(trigger.isinsert && trigger.isbefore)
    {
        for(Account newAccount : trigger.new)
        {            
            if(dmMap.get(newAccount.Country_Picklist__c)!=null)
            {
                DM_Territory__c dm = dmMap.get(newAccount.Country_Picklist__c);
                newAccount.DM_Sales_Region__c = dm.DM_Sales_Region__c;
                newAccount.DM_Territory__c = dm.DM_Territory__c;  
            } 
            if(newAccount.Service_Provider_Type__c != null && newAccount.Account_Type__c!=null)
            newAccount.MSP_Check__c = newAccount.Service_Provider_Type__c +':'+ newAccount.Account_Type__c;
            else if(newAccount.Account_Type__c==null)
            newAccount.MSP_Check__c = newAccount.Service_Provider_Type__c ; 
            else if(newAccount.Service_Provider_Type__c == null )
            newAccount.MSP_Check__c = newAccount.Account_Type__c;          
        }   
    }
}