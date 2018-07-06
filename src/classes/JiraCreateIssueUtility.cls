public with sharing class JiraCreateIssueUtility{
    
    public boolean isError{get; set;}
    public boolean requestTypeInvisible{get; set;}
    public string initialComponent{get; set;}
    public string comment{get; set;}
    public string caseId{get; set;}
    public string casetype{get; set;}
    public string requestType{get; set;}
    Public Case c{get; set;}
    public String status='';

    public JiraCreateIssueUtility(ApexPages.StandardController controller){
        caseId = controller.getId();
        system.debug('case id..!!'+caseId);
        requestTypeInvisible = true;
        if(caseId != null && caseId != ''){
            c = [select Id,casenumber,BusinessHoursId,Severity__c,Component_Release_Only_Selection__c,JIRA_Issue_Key__c,Component_Name__c,Next_Action__c,Next_Action_Due_Date__c,Case_Type__c,Request_Type__c,CA_Product_Controller__r.Name,CA_Product_Component__r.component_text__c,CA_Product_Component__r.CA_Product_Text__c,Jira_Issue_API_link__c,JIRA_Status__c from case where id=: controller.getId()];
            system.debug('case record..!!'+c);
            //system.debug('case component is..!!'+c.CA_Product_Component__r.Name);
            system.debug('Jira status..!!'+c.jira_status__c);        
        } 
        initialComponent = c.CA_Product_Component__r.CA_Product_Text__c;
        requestType = c.Request_Type__c;
        if(c.Jira_Issue_API_link__c != null || c.Case_Type__c == 'Standard'){
            requestTypeInvisible = false;
        }
    }   
    
    public pagereference sendInfoToJira(){
         try{ 
            
            requestType=c.Request_Type__c;
            system.debug('requestType is..!!!!'+requestType);
            if(comment != null){
                isError = false;

                if(c.Jira_Issue_API_link__c != null){                    
                   status = JiraIntegration.addComment(caseId,comment);
                  /* if(c.jira_status__c == 'Info Needed' || c.jira_status__c == 'Closed'){
                        JiraIntegrationHelper.updateJiraTicketState(c.id,'Jira ticket reopend');
                   } */
                   
                   if((c.jira_status__c == 'Info Needed') || (c.jira_status__c.startsWith('Closed') && !c.jira_status__c.contains('Fixed'))) {
                        system.debug('Jira status is..!!'+c.jira_status__c);
                        //check in custom Label has the jira_status then call updateStatusToOpen  
                        Set<String>  resolutionStatusExcludeList = new Set<String>();                          
                        if(String.isNotBlank(label.Jira_status_not_to_reopen)) {
                            for(String val:label.Jira_status_not_to_reopen.split(',')){
                                resolutionStatusExcludeList.add(val.trim());                            
                            }
                        }                          
                        if(!resolutionStatusExcludeList.isEmpty() && !resolutionStatusExcludeList.contains(c.jira_status__c)){                          
                            JiraIntegrationHelper.updateJiraTicketState(c.id,'Jira ticket reopend');
                                  
                        } 
                    }
                    if (!Test.isRunningTest()){
                        JiraIntegrationHelper.createTask(c);
                    }
                    c = JiraIntegrationHelper.updateNextActionOwnerAndTime(c);
                    update c;
                    system.debug('************ Success : '+status.contains('successfully'));
                }
                else{
                    if (!Test.isRunningTest()){
                        status = JiraIntegration.createJiraTicket(caseId,comment,requestType,initialComponent);
                    }else{
                        status='failed';
                    }
                    system.debug('return status is..!!'+status);
                }           
                
                if(status.contains('successfully')){
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,status));
                }
                else{
                    isError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,status));
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            isError = true;
            return null;
        }    
      return null;  
    } 
}