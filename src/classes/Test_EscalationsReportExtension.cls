@isTest
public class Test_EscalationsReportExtension {
    public static List<Escalation__c> esc {get;set;}
    private static testmethod void escalationReport(){
        
        createdata();
        System.debug('Id : '+ esc);
        Test.startTest();
        apexpages.currentpage().getparameters().put('Id',esc[0].id );
        Escalation__c objEsc = esc[0];
        ApexPages.Standardcontroller standcontoller = new ApexPages.Standardcontroller(objEsc);
        EscalationsReportExtension escObj = new EscalationsReportExtension(standcontoller);
        escObj.returnToEscalation();
        Test.stopTest();
    }
    
    public static void createdata(){
        
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Escalation' limit 1];
        List<Site_Association__c> listOfSite = [Select id, name,SAP_Site_ID__c from Site_Association__c where Name='CA TECHNOLOGIES' and SAP_Site_ID__c='105246' limit 1];
        List<user> lisofUser = [select id , name from user where name like 'amar pal' limit 1];
        esc = new list<Escalation__c>();
        Escalation__c escObj = new Escalation__c();
        escObj.Name ='Test Escalation';
        escObj.Escalation_Status__c='Triage In Progress';
      //  escObj.Site_Association_Name__c =listOfSite[0].id;
       // escObj.RecordTypeid=listOfRecord[0].id;
        escObj.Requestor__c=lisofUser[0].id;
        escObj.Requestor_Org__c='services';
       // esc.Owner='palam03@ca.com';
        escObj.Action_Owner__c=lisofUser[0].id;
        escObj.Escalation_Type__c='Early Warning';
        escObj.Escalation_Driver__c='Product Defect';
        escObj.Executive_Summary1__c ='Test Summary';
        escObj.Business_Impact__c='Test';
        escObj.Current_Status_and_Next_Action__c='Test';
        escObj.Resolution_Criteria__c='Test';
        esc.add(escObj);
        insert esc;
        
    }
}