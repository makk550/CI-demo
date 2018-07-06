global class PendingRequestCtrl{

global static String Region {get;set;}
global static Integer pendingRequestCount {get;set;}
public List<Access_Request__c> pendingARs {get;set;}
public String Approver{get;set;}
public String baseURl{get;set;}

public PendingRequestCtrl(){

pendingRequestCount = 0;
pendingARs = [Select Id, Name, Approver__c,Request_For__r.Name from Access_Request__c where Status__c = 'Pending for Approval' and Region__c =: Region];
baseURl = URL.getsalesforceBaseURL().toExternalform();

    pendingRequestCount = pendingARs.size();

if(Region == 'NA')
    Approver = [Select Name from User where Id =:label.Access_Approver_NA].Name;
//sunji03 - FY19 PS/CAN GEO is added
else if(Region == 'PS/CAN')
    Approver = [Select Name from User where Id =:label.Access_Approver_PSCAN].Name;
else if(Region == 'LA')
    Approver = [Select Name from User where Id =:label.Access_Approver_LA].Name;
else if(Region == 'APJ')
    Approver = [Select Name from User where Id =:label.Access_Approver_APJ].Name;
else if(Region == 'EMEA')
    Approver = [Select Name from User where Id =:label.Access_Approver_EMEA].Name;
else if(Region == 'Global')
    Approver = [Select Name from User where Id =:label.Access_Approver_GLOBAL].Name;


}


}