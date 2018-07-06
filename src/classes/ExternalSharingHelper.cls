public class ExternalSharingHelper {
@future
    public static void touchCases(Set<Id> OppIds) {

       try
       {
        List<Opportunity> oppD= [SELECT Id,Layer_7_Opportunity_GUID__c FROM Opportunity Where id in :OppIds];                  
        oppD[0].Layer_7_Opportunity_GUID__c = oppD[0].Id;
           update oppD;        
           
                                 system.debug('adsfda');
                      Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();                
                      String[] toAddresses = new list<string> {'danva01@ca.com'};
                      email.setToAddresses(toAddresses);
                      //email.setTargetObjectId(opp.OwnerId);                
                      email.setSenderDisplayName('Salesforce');
                      email.setUseSignature(false);
                      email.setBccSender(false);
                      //email.setWhatId(opp.Id); 
                      email.setSaveAsActivity(false);
                    email.setSubject( 'Success 3333: CA Opportunity Creation');
                    
                    email.setPlainTextBody('adfadfd'  );
                    //EmailTemplate et=[Select id from EmailTemplate where DeveloperName='L7_Integration_Email'];
                    //email.setTemplateId(et.id);
                    system.debug('***4*****');
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
            catch(Exception e)
           {
                                   system.debug('***ex2*****');
                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();                
                    email.setSubject( 'Error : CA Opportunity Creation');
                    String[] toAddresses = new list<string> {'danva01@ca.com'};
                                                                    system.debug('***ex3*****');
                    email.setToAddresses(toAddresses);
                    email.setPlainTextBody(e.getMessage());
                                                                    system.debug('***ex4*****');
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                                                                    system.debug('***ex5*****');
           }  
    }
}