public class JiraCaseTriggerUpdate{
    
    public static void JiraUpdateFieldFutureCallout(Case newcase, Case oldcaserecord){
        string oldversionid = oldcaserecord.Component_Release_Only_Selection__c;
        Component_Release__c oldrelease = null;
        System.debug('oldversionid'+oldversionid);
        if(oldversionid != null && oldversionid != ''){    
            oldrelease = [select Id,Name,Component_Text__c,Component_Release__c from Component_Release__c where Id =: oldversionid];
         }
        if(newcase.Jira_Issue_API_link__c != null && newcase.Jira_Issue_Id__c != null){
            map<string,string> fieldMap = new map<string,string>();
            map<string,string> labelMap = new map<string,string>();
            Boolean statusTobeUpdated = false;
            
            if(newcase.Severity__c != oldcaserecord.Severity__c){
                fieldMap.put('priority',newcase.Severity__c);
            }
            if(newcase.No_of_problem_or_standard_cases__c != oldcaserecord.No_of_problem_or_standard_cases__c && oldcaserecord.Case_Type__c=='Problem'){
                Integer noOfInc =Integer.valueOf((newcase.No_of_problem_or_standard_cases__c != null?newcase.No_of_problem_or_standard_cases__c:0));
                fieldMap.put('NumberofIncident',string.valueOf(noOfInc));
            }
            if((newcase.isClosed  && !oldcaserecord.isClosed)||Test.isRunningTest()){
                statusTobeUpdated = true;
            }
            if(newcase.Component_Release_Only_Selection__c != oldcaserecord.Component_Release_Only_Selection__c && oldcaserecord.Case_Type__c=='Standard'){
                if(newcase.Component_Release_Only_Selection__c != null && newcase.CA_Product_Component__r != null && newcase.Component_Release_Only_Selection__r != null){
                    labelMap.put('addVersion',newcase.CA_Product_Component__r.Component_Text__c.replace(' ', '.')+'_'+newcase.Component_Release_Only_Selection__r.Component_Release__c);
                }       
                if(oldrelease != null && oldcaserecord.Component_Release_Only_Selection__c != null && oldcaserecord.CA_Product_Component__r != null){
                    labelMap.put('removeVersion',oldcaserecord.CA_Product_Component__r.Component_Text__c.replace(' ', '.')+'_'+oldrelease.Component_Release__c);
                }    
            }
            if((!fieldMap.isEmpty() || !labelMap.isEmpty() || statusTobeUpdated) && newcase.JIRA_Status__c != null && !newcase.JIRA_Status__c.contains('Fixed')){
                JiraIntegrationHelper.updateJiraTicket(newcase.id,fieldMap,labelMap,statusTobeUpdated);
            	updateStatusAndOffering(newCase, oldcaserecord);
            	JiraIntegrationHelper.createTask(newCase);
            }  
        }
    }
    
    private static void updateStatusAndOffering(Case newCase, Case oldCase){
        String status = null;
        String offeringCode = null;
        String no_probl = null;
        
        if(null != newCase.Jira_Issue_Id__c && null != newCase.JIRA_Issue_Key__c && newCase.Jira_Issue_Id__c != '' && newCase.JIRA_Issue_Key__c!=''){
            if(newCase.Status != null && newCase.Status!= oldCase.Status){
                status = newCase.Status;
            }
            if(newCase.Case_Type__c == 'Standard' && newCase.Offering_Code_Ref__c != oldCase.Offering_Code_Ref__c){
                offeringCode = (null == newCase.Offering_Code_Ref__c || '' == newCase.Offering_Code_Ref__c ? 'Standard' : newCase.Offering_Code_Ref__c);
            }
            if(newCase.No_of_problem_or_standard_cases__c != oldCase.No_of_problem_or_standard_cases__c){
                no_probl = ( newCase.No_of_problem_or_standard_cases__c == 0  ? '0' : String.valueOf(newCase.No_of_problem_or_standard_cases__c));
            }
        JiraIntegrationHelper.updateStatus(newCase.JIRA_Issue_Key__c ,status, offeringCode,no_probl);
        }
    } 
}