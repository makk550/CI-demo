@istest

public class Test_Batch_Apex_CI {
    
    static testMethod void myUnitTest() {
        
        list<contact> ctlist= new  list<contact>();
        
        Contact Con = new Contact (Firstname='test_Account1', lastname = 'last1',email='nihalvats@gmail.com');
        
        ctlist.add(Con);
        
        Contact Con1 = new Contact (Firstname='test_Account1', lastname = 'last1233',email='nihalvats@gmail.com');
        
        ctlist.add(Con1); 
        Contact Con2 = new Contact (Firstname='test_Account1', lastname = 'last1',email='nihalvats1@gmail.com');
        
        
        ctlist.add(Con2);
        
        Contact Con3 = new Contact (Firstname='test_Account1', lastname = 'last1233',email='nihalvats1@gmail.com');
        
        ctlist.add(Con3);
        
         Contact Con4 = new Contact (Firstname='test_Account1', lastname = 'last1233',email='nihalvats11@gmail.com');
        
        ctlist.add(Con4);
        
        insert ctlist;
       
        Test.setCreatedDate(ctlist[0].Id,  system.now().addDays(-2));
        Test.setCreatedDate(ctlist[1].Id,  system.now().addDays(3));        
        Test.setCreatedDate(ctlist[2].Id,  system.now().addDays(-2));
        Test.setCreatedDate(ctlist[3].Id,  system.now().addDays(3));
         Test.setCreatedDate(ctlist[4].Id,  system.now().addDays(-2));
        
        list <DuplicateRecordSet> duprecsetlist = new List <DuplicateRecordSet> ();
        DuplicateRecordSet dupe1 = new DuplicateRecordSet (DuplicateRuleId=label.CI_duplicateruleid, DuplicateEmail__c='nihalvats@gmail.com');
        duprecsetlist.add(dupe1);
        
       
        insert duprecsetlist;
        list <DuplicateRecordItem> dupreitem = new List <DuplicateRecordItem> ();
        DuplicateRecordItem dupi1 = new DuplicateRecordItem(DuplicateRecordSetid=duprecsetlist[0].Id, Recordid=ctlist[1].id);
        dupreitem.add(dupi1);
       
        insert dupreitem;
        
        Test.StartTest();
        
        BatchContactUpdateDuprecordset newTopicsUpdate = new BatchContactUpdateDuprecordset();
        
       
        
        Database.executeBatch(newTopicsUpdate);
        
        Test.StopTest();   
        
    }
}