@isTest(SeeAllData=true)
private Class CA_ApprovalRequestHistoryTrigger_Test{

    private static testMethod void testMethod1(){
         RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        List<User> listOfuser = [Select id,Name,isActive from User where isActive = true limit 4];
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.CA_Agreement_Type__c = 'Order Form' ;
        agr1.RecordTypeId = agrRec.id;    
        //agr1.Sterling_Quote__c = listOfquote[0].id;
        agr1.CA_Geo__c = 'NA';
        agr1.CA_Sales_Territory__c = 'AUSTRALIA';
        agr1.CA_Language__c = 'English';
        agr1.CA_Operating_Area__c = 'Public Sector/Canada';
        agr1.CA_Sales_Region__c = 'AUSTRALIA';
        agr1.CA_Classified_Contract__c = 'Yes';
        //agr1.Agreement_Approver__c = listOfuser[0].id;
        agr1.Apttus__Status_Category__c = 'In Approval';
        agr1.Apttus__Status__c = 'Pending Approval';        
        //agr1.Agreement_Approver2__c = listOfuser[1].id;
        //agr1.Agreement_Approver4__c = listOfuser[2].id;
        //agr1.Agreement_Approver3__c = listOfuser[3].id;
        insert agr1;    
        
        
        
        Apttus_Approval__Approval_Request__c appreq= new Apttus_Approval__Approval_Request__c ();
        appreq.Apttus_Approval__Related_Agreement__c = agr1.id;
        appreq.Apttus_Approval__StepLabel__c = 'Contract Manager Approval';
        appreq.Apttus_Approval__Assigned_To_Id__c = listOfuser[0].id;
        insert appreq;
        
        Apttus_Approval__Approval_Request_History__c appreqhis = new Apttus_Approval__Approval_Request_History__c ();
        appreqhis.Apttus_Approval__Related_Agreement__c = agr1.id;
        appreqhis.Apttus_Approval__StepLabel__c = 'Contract Manager Approval';
        appreqhis.Apttus_Approval__Assigned_To_Id__c =listOfuser[0].id;
        insert appreqhis;
    }
}