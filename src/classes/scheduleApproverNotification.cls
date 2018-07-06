global class scheduleApproverNotification implements Schedulable{
List<String> emailAddress = new List<String>();

public List<Access_Request__c> pendingARs {get;set;}

global void execute(SchedulableContext sch){

PendingRequestCtrl.Region = 'NA';
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: PendingRequestCtrl.Region];


Messaging.singleEmailMessage emailRequestNA = new Messaging.singleEmailMessage();
emailAddress.add([Select Email from User where Id =:label.Access_Approver_NA].Email);
//emailRequestNA.settoAddresses(emailAddress);
emailRequestNA.setTemplateId(Label.Pending_Request_Template);
emailRequestNA.setTargetObjectId(Label.Access_Approver_NA);
emailRequestNA.saveAsActivity = false;

if(pendingARs.size() > 0)

Messaging.SendEmailResult [] emailResultNA = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestNA});
System.debug('1'+pendingARs.size());

//sunji03 - FY19 PS/CAN GEO
PendingRequestCtrl.Region = 'PS/CAN';
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: PendingRequestCtrl.Region];


Messaging.singleEmailMessage emailRequestPSCAN = new Messaging.singleEmailMessage();
emailAddress.add([Select Email from User where Id =:label.Access_Approver_PSCAN].Email);
//emailRequestNA.settoAddresses(emailAddress);
emailRequestPSCAN.setTemplateId(Label.Pending_Request_Template);
emailRequestPSCAN.setTargetObjectId(Label.Access_Approver_PSCAN);
emailRequestPSCAN.saveAsActivity = false;

if(pendingARs.size() > 0)

Messaging.SendEmailResult [] emailResultPSCAN = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestPSCAN});
System.debug('1'+pendingARs.size());

PendingRequestCtrl.Region = 'LA';
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: PendingRequestCtrl.Region];
emailAddress.clear();
Messaging.singleEmailMessage emailRequestLA = new Messaging.singleEmailMessage();
emailAddress.add([Select Email from User where Id =:label.Access_Approver_LA].Email);
//emailRequestLA.settoAddresses(emailAddress);
emailRequestLA.setTemplateId(Label.Pending_Request_Template);
emailRequestLA.setTargetObjectId(Label.Access_Approver_LA);
emailRequestLA.saveAsActivity = false;

if(pendingARs.size() > 0)
       Messaging.SendEmailResult []  emailResultLA = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestLA});
System.debug('4'+pendingARs.size());

PendingRequestCtrl.Region = 'APJ';
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: PendingRequestCtrl.Region];
emailAddress.clear();
Messaging.singleEmailMessage emailRequestAPJ = new Messaging.singleEmailMessage();
emailAddress.add([Select Email from User where Id =:label.Access_Approver_APJ].Email);
//emailRequestAPJ.settoAddresses(emailAddress);
emailRequestAPJ.setTemplateId(Label.Pending_Request_Template);
emailRequestAPJ.setTargetObjectId(Label.Access_Approver_APJ);
emailRequestAPJ.saveAsActivity = false;

if(pendingARs.size() > 0)
        Messaging.SendEmailResult [] emailResultAPJ = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestAPJ});

System.debug('2'+pendingARs.size());
PendingRequestCtrl.Region = 'EMEA';
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: PendingRequestCtrl.Region];
emailAddress.clear();
Messaging.singleEmailMessage emailRequestEMEA = new Messaging.singleEmailMessage();
emailAddress.add([Select Email from User where Id =:label.Access_Approver_EMEA].Email);
//emailRequestEMEA.settoAddresses(emailAddress);
emailRequestEMEA.setTemplateId(Label.Pending_Request_Template);
emailRequestEMEA.setTargetObjectId(Label.Access_Approver_EMEA);
emailRequestEMEA.saveAsActivity = false;

if(pendingARs.size() > 0)
        Messaging.SendEmailResult []  emailResultEMEA = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestEMEA});

System.debug('3'+pendingARs.size());
    
PendingRequestCtrl.Region = 'Global';
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: PendingRequestCtrl.Region];
emailAddress.clear();
Messaging.singleEmailMessage emailRequestGLOBAL = new Messaging.singleEmailMessage();
emailAddress.add([Select Email from User where Id =:label.Access_Approver_Global].Email);
//emailRequestGLOBAL.settoAddresses(emailAddress);
emailRequestGLOBAL.setTemplateId(Label.Pending_Request_Template);
emailRequestGLOBAL.setTargetObjectId(Label.Access_Approver_Global);
emailRequestGLOBAL.saveAsActivity = false;

if(pendingARs.size() > 0)
        Messaging.SendEmailResult []  emailResultGLOBAL = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestGLOBAL});

System.debug('5'+pendingARs.size());    
    
    
}

}