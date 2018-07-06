global class CPMSIntegartionUtility {
    webservice static string sendLeadToCpms(string leadId)
    {
        String callStatus='Lead Sent To CPMS';
        List<Lead> lead=[Select Id,Last_Submission_Date__c,Show_In_CPMS_Error_Report__c,Last_Processed_Date__c,Attempt_Count__c
         from Lead where Id=:leadId and IsConverted=False];
        if(lead.size()>0) 
        {
            if(lead[0].Show_In_CPMS_Error_Report__c==1)
            {
                Decimal timeDiff=getDateTimeDiffInHours(lead[0].Last_Submission_Date__c,Datetime.now());
                if(timeDiff>24)
                {
                    if(lead[0].Attempt_Count__c!=null)
                    {
                        lead[0].Attempt_Count__c=lead[0].Attempt_Count__c+1;
                    }
                    Database.SaveResult res=Database.update(lead[0]);
                    if(res.isSuccess()==false)
                    {
                        callStatus='Failed to send lead to CPMS: ' +res.getErrors().get(0).getMessage();
                    }
                }
                else
                {
                    callStatus='Salesforce is Still trying to send this Lead to CPMS. Please try Later.'; 
                }                       
            }
            else
            {
                callStatus='Lead is not in Valid State to be sent manually!'; 
            }           
        }
        else
        {
            callStatus='No Lead Found!';
        }
        return callStatus;  
    }
    webservice static string sendAccountToCpms(string accountId)
    {
        String callStatus='Account Sent To CPMS';
        List<Account> acct=[Select Id,Last_Submission_Date__c,Show_In_CPMS_Error_Report__c,Last_Processed_Date__c,Attempt_Count__c
         from Account where Id=:accountId];
        if(acct.size()>0) 
        {
            if(acct[0].Show_In_CPMS_Error_Report__c==1)
            {
                Decimal timeDiff=getDateTimeDiffInHours(acct[0].Last_Submission_Date__c,Datetime.now());
                if(timeDiff>24)
                {
                    if(acct[0].Attempt_Count__c!=null)
                    {
                        acct[0].Attempt_Count__c=acct[0].Attempt_Count__c+1;
                    }
                    Database.SaveResult res=Database.update(acct[0]);
                    if(res.isSuccess()==false)
                    {
                        callStatus='Failed to send Account to CPMS: ' +res.getErrors().get(0).getMessage();
                    }
                }
                else
                {
                    callStatus='Salesforce is Still trying to send this Account to CPMS. Please try Later.'; 
                }                       
            }
            else
            {
                callStatus='Account is not in Valid State to be sent manually!'; 
            }           
        }
        else
        {
            callStatus='No Account Found!';
        }
        return callStatus;  
    }
    webservice static string sendOpportunityToCpms(string opportunityId)
    {
        String callStatus='Opportunity Sent To CPMS';
        List<Opportunity> oppt=[Select Id,Show_In_CPMS_Error_Report__c,Attempt_Count__c
         from Opportunity where Id=:opportunityId];
        if(oppt.size()>0) 
        {
            if(oppt[0].Show_In_CPMS_Error_Report__c==1)
            {
                Decimal timeDiff=getDateTimeDiffInHours(Datetime.now(),Datetime.now());
                if(timeDiff>24)
                {
                    if(oppt[0].Attempt_Count__c!=null)
                    {
                        oppt[0].Attempt_Count__c=oppt[0].Attempt_Count__c+1;
                    }
                    Database.SaveResult res=Database.update(oppt[0]);
                    if(res.isSuccess()==false)
                    {
                        callStatus='Failed to send Opportunity to CPMS: ' +res.getErrors().get(0).getMessage();
                    }
                }
                else
                {
                    callStatus='Salesforce is Still trying to send this Opportunity to CPMS. Please try Later.'; 
                }                       
            }
            else
            {
                callStatus='Opportunity is not in Valid State to be sent manually!'; 
            }           
        }
        else
        {
            callStatus='No Opportunity Found!';
        }
        return callStatus;  
    }
    webservice static string sendAssociatedSiteToCpms(string siteId)
    {
        String callStatus='Associated Site Sent To CPMS';
        List<Associated_Site__c> associatedSite=[Select Id,Last_Submission_Date__c,Show_In_CPMS_Error_Report__c,Last_Processed_Date__c,Attempt_Count__c
         from Associated_Site__c where Id=:siteId];
        if(associatedSite.size()>0) 
        {
            if(associatedSite[0].Show_In_CPMS_Error_Report__c==1)
            {
                Decimal timeDiff=getDateTimeDiffInHours(associatedSite[0].Last_Submission_Date__c,Datetime.now());
                if(timeDiff>24) 
                {
                    if(associatedSite[0].Attempt_Count__c!=null)
                    {
                        associatedSite[0].Attempt_Count__c=associatedSite[0].Attempt_Count__c+1;
                    }
                    Database.SaveResult res=Database.update(associatedSite[0]);
                    if(res.isSuccess()==false)
                    {
                        callStatus='Failed to send Associated Site to CPMS: ' +res.getErrors().get(0).getMessage();
                    }
                }
                else
                {
                    callStatus='Salesforce is Still trying to send this Associated Site to CPMS. Please try Later.'; 
                }                       
            }
            else
            {
                callStatus='Associated Site is not in Valid State to be sent manually!'; 
            }           
        }
        else
        {
            callStatus='No Associated Site Found!';
        }
        return callStatus;  
    }
    /*
     * funcion that calculates & returns the difference in hours between the 2 dateTime values 
     *
     * @param dateTime,dateTime
     * 
     * @return decimal 
     */     
    public static Decimal getDateTimeDiffInHours(datetime dt1,datetime dt2) {
        
        Decimal diff = 0.0;
        // if either of the datetime values are null
        if(dt1 == null ||dt2 == null)
        {
            return 0;   
        }  
        else
        {
            if(dt1 > dt2)
                diff = ((dt1.getTime() - dt2.getTime())/3600000.00);
            else
                diff = ((dt2.getTime() - dt1.getTime())/3600000.00);
        }                       
        return diff; 
    }   
    static testMethod void testCpmsUtility()     
    {
        //test send to CPMS methods with invalid Id
        CPMSIntegartionUtility.sendLeadToCpms('InvalidId');
        CPMSIntegartionUtility.sendAccountToCpms('InvalidId');
        CPMSIntegartionUtility.sendOpportunityToCpms('InvalidId');
        CPMSIntegartionUtility.sendAssociatedSiteToCpms('InvalidId');
        
        //test send to CPMS methods with records in invalid state
        List<Lead> invalidLeads=[Select Id from Lead where Show_In_CPMS_Error_Report__c=0 Limit 1]; 
        if(invalidLeads.size()>0)
        {
            CPMSIntegartionUtility.sendLeadToCpms(invalidLeads[0].Id);
        }   
        List<Account> invalidAccounts=[Select Id from Account where Show_In_CPMS_Error_Report__c=0 Limit 1]; 
        if(invalidAccounts.size()>0)
        {
            CPMSIntegartionUtility.sendAccountToCpms(invalidAccounts[0].Id);
        }   
        List<Opportunity> invalidOpps=[Select Id from Opportunity where Show_In_CPMS_Error_Report__c=0 Limit 1]; 
        if(invalidOpps.size()>0)
        {
            CPMSIntegartionUtility.sendOpportunityToCpms(invalidOpps[0].Id);
        } 
        List<Associated_Site__c> invalidSites=[Select Id from Associated_Site__c where Show_In_CPMS_Error_Report__c=0 Limit 1]; 
        if(invalidSites.size()>0)
        {
            CPMSIntegartionUtility.sendAssociatedSiteToCpms(invalidSites[0].Id);
        } 
        
        //test send to CPMS methods with possibly valid records
        List<Lead> validLeads=[Select Id from Lead 
        where Show_In_CPMS_Error_Report__c=1 order by Last_Submission_Date__c asc Limit 1]; 
        if(validLeads.size()>0)
        {
            try
            {
                CPMSIntegartionUtility.sendLeadToCpms(validLeads[0].Id);
            }catch(Exception ex){}
        }   
        List<Account> validAccounts=[Select Id from Account 
        where Show_In_CPMS_Error_Report__c=1 order by Last_Submission_Date__c asc Limit 1]; 
        if(validAccounts.size()>0)
        {
            try
            {
                CPMSIntegartionUtility.sendAccountToCpms(validAccounts[0].Id);
            }catch(Exception ex){}
        }   
        List<Opportunity> validOpps=[Select Id from Opportunity 
        where Show_In_CPMS_Error_Report__c=1 Limit 1]; 
        if(validOpps.size()>0)
        {
            try
            {
                CPMSIntegartionUtility.sendOpportunityToCpms(validOpps[0].Id);
            }catch(Exception ex){}
        } 
        List<Associated_Site__c> validSites=[Select Id from Associated_Site__c 
        where Show_In_CPMS_Error_Report__c=1 order by Last_Submission_Date__c asc Limit 1]; 
        if(validSites.size()>0)
        {
            try
            {
                CPMSIntegartionUtility.sendAssociatedSiteToCpms(validSites[0].Id);
            }catch(Exception ex){}
        } 
        
        //test getDateTimeDiffInHours method
        //call method with null value
        CPMSIntegartionUtility.getDateTimeDiffInHours(null,null);
        //call method with first value less than second value
        CPMSIntegartionUtility.getDateTimeDiffInHours(DateTime.now(),DateTime.now().addDays(1));
        //call method with first value greater than second value
        CPMSIntegartionUtility.getDateTimeDiffInHours(DateTime.now(),DateTime.now().addDays(-1));
        
    }
}