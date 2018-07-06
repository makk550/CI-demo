@isTest(SeeAllData=true)
private Class CA_ApproverTriggerHandler_Test{

     private static testMethod void testMethod1(){
     RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c();
        agr.CA_Agreement_Type__c = 'Order Form';
        agr.CA_Agreement_Sub_Type__c = 'CA Support';
        agr.CA_Sales_Type__c = 'Direct';
        agr.CA_Paper__c = 'Yes';
        agr.CA_Geo__c = 'APJ';
        agr.CA_Operating_Area__c = 'ANZ';
        agr.CA_Sales_Region__c = 'AUSTRALIA';
        agr.CA_Sales_Territory__c = 'BRITISH INDIAN OCEAN';
        agr.CA_Language__c = 'English';
        agr.Apttus__Contract_Start_Date__c = System.today();
        agr.RecordTypeId = agrRec.id;
        insert agr;
        
        List<User> listOfuser = [Select id,Name,isActive from User where isActive = true limit 4];
        List<Approver__c> appListToInsert = new List<Approver__c>();
        Approver__c app = new Approver__c ();
        app.CA_Agreement__c = agr.id;
        app.CA_Level__c = '1';
        app.CA_Approver_1__c = listOfuser[0].id;
        app.CA_Approver_1_Comments__c = 'Level 1 App 1 comments';
        app.CA_Approver_2__c = listOfuser[1].id;
        app.CA_Approver_2_Comments__c = 'Level 1 App 2 comments';
        app.CA_Approver_3__c = listOfuser[2].id;
        app.CA_Approver_3_Comments__c ='Level 1 App 3 comments';
        app.CA_Approver_4__c = listOfuser[3].id;
        app.CA_Approver_4_Comments__c = 'Level 1 App 4 comments';
        appListToInsert.add(app);
        
        Approver__c app1 = new Approver__c ();
        app1.CA_Agreement__c = agr.id;
        app1.CA_Level__c = '2';
        app1.CA_Approver_1__c = listOfuser[0].id;
        app1.CA_Approver_1_Comments__c = 'Level 1 App 1 comments';
        app1.CA_Approver_2__c = listOfuser[1].id;
        app1.CA_Approver_2_Comments__c = 'Level 1 App 2 comments';
        app1.CA_Approver_3__c = listOfuser[2].id;
        app1.CA_Approver_3_Comments__c ='Level 1 App 3 comments';
        app1.CA_Approver_4__c = listOfuser[3].id;
        app1.CA_Approver_4_Comments__c = 'Level 1 App 4 comments';
        appListToInsert.add(app1);
        
        Approver__c app2 = new Approver__c ();
        app2.CA_Agreement__c = agr.id;
        app2.CA_Level__c = '3';
        app2.CA_Approver_1__c = listOfuser[0].id;
        app2.CA_Approver_1_Comments__c = 'Level 1 App 1 comments';
        app2.CA_Approver_2__c = listOfuser[1].id;
        app2.CA_Approver_2_Comments__c = 'Level 1 App 2 comments';
        app2.CA_Approver_3__c = listOfuser[2].id;
        app2.CA_Approver_3_Comments__c ='Level 1 App 3 comments';
        app2.CA_Approver_4__c = listOfuser[3].id;
        app2.CA_Approver_4_Comments__c = 'Level 1 App 4 comments';
        appListToInsert.add(app2);
        
        Approver__c app3 = new Approver__c ();
        app3.CA_Agreement__c = agr.id;
        app3.CA_Level__c = '4';
        app3.CA_Approver_1__c = listOfuser[0].id;
        app3.CA_Approver_1_Comments__c = 'Level 1 App 1 comments';
        app3.CA_Approver_2__c = listOfuser[1].id;
        app3.CA_Approver_2_Comments__c = 'Level 1 App 2 comments';
        app3.CA_Approver_3__c = listOfuser[2].id;
        app3.CA_Approver_3_Comments__c ='Level 1 App 3 comments';
        app3.CA_Approver_4__c = listOfuser[3].id;
        app3.CA_Approver_4_Comments__c = 'Level 1 App 4 comments';
        appListToInsert.add(app3);        
        
        insert appListToInsert ;
        
        app.CA_Approver_4__c = null;
        app.CA_Approver_4_Comments__c = '';
        app1.CA_Approver_4__c = null;
        app1.CA_Approver_4_Comments__c = '';
        app2.CA_Approver_4__c = null;
        app2.CA_Approver_4_Comments__c = '';
        app3.CA_Approver_4__c = null;
        app3.CA_Approver_4_Comments__c = '';
        
        update appListToInsert;
        
        delete appListToInsert;
        
        
     }

}