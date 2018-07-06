@istest
public class TestCommitApexSharingHelper 
{
    
    public static testMethod void testInsertRevenueRecord()
    {
        Commit_Org__c cmorg=new Commit_Org__c(Name='Major Markets Judgment',Org_Level__c='Judgment');
        insert cmorg;
        Commit_Org__c commitOrgCanada =[Select Id from Commit_Org__c LIMIT 1];
        Commit_Org__c commitOrgWest =[Select Id from Commit_Org__c LIMIT 1];
        User userRecord = [Select u.Name, u.Id From User u where u.isActive = true LIMIT 1];
        Test.startTest();
        Commit_Revenue__c objRevenue  = new Commit_Revenue__c();
        objRevenue.Name = 'TestRevenueRecord';
        objRevenue.Commit_Org__c = commitOrgCanada.Id;
        insert objRevenue;
        Test.stopTest();
    }
    public static testMethod void testUpdateRevenueRecord()
    {
        Commit_Org__c cmorg=new Commit_Org__c(Name='Major Markets Judgment',Org_Level__c='Judgment');
        insert cmorg;
        Commit_Org__c commitOrgCanada =[Select Id from Commit_Org__c LIMIT 1];
        Commit_Org__c commitOrgWest =[Select Id from Commit_Org__c LIMIT 1];
        User userRecord = [Select u.Name, u.Id From User u where u.isActive = true LIMIT 1];
        Commit_Revenue__c objRevenue  = new Commit_Revenue__c();
        objRevenue.Name = 'TestRevenueRecord';
        objRevenue.Commit_Org__c = commitOrgCanada.Id;
        insert objRevenue;
        Test.startTest();
        Commit_Revenue__c insertedRecord = [Select Id from Commit_Revenue__c limit 1];
        Id updateRevId = insertedRecord.Id ; 
        Commit_Revenue__c updateTestRev = new Commit_Revenue__c(Id=updateRevId);
        insertedRecord.Commit_Org__c = commitOrgWest.Id;
        update updateTestRev ;
        Test.stopTest();
    }
    public static testMethod void testInsertOrgUserRecord()
    {
        Commit_Org__c cmorg=new Commit_Org__c(Name='Major Markets Judgment',Org_Level__c='Judgment');
        insert cmorg;
        Commit_Org__c commitOrgCanada =[Select Id from Commit_Org__c LIMIT 1];
        Commit_Org__c commitOrgWest =[Select Id from Commit_Org__c LIMIT 1];
        User userRecord = [Select u.Name, u.Id From User u where u.isActive = true LIMIT 1];
        Test.startTest();
        Commit_Org_User__c userOrg = new Commit_Org_User__c();
        userOrg.Commit_Org__c = commitOrgCanada.Id;
        Id user1 = userRecord.Id;
        userOrg.User__c = user1 ;
        insert userOrg;
        Test.stopTest();
    }
    public static testMethod void testUpdateOrgUserRecord()
    {   
        Commit_Org__c cmorg=new Commit_Org__c(Name='Major Markets Judgment',Org_Level__c='Judgment');
        insert cmorg;
        Commit_Org__c commitOrgCanada =[Select Id from Commit_Org__c LIMIT 1];
        Commit_Org__c commitOrgWest =[Select Id from Commit_Org__c LIMIT 1];
        User userRecord = [Select u.Name, u.Id From User u where u.isActive = true LIMIT 1];
        Test.startTest();
        //User userRecord = [Select u.Name, u.Id From User u where u.Name = 'Kunal Sharma'];
        //Id user1 = userRecord.Id;
        Commit_Org_User__c userOrg = new Commit_Org_User__c();
        userOrg.Commit_Org__c = commitOrgCanada.Id;
        Id user1 = userRecord.Id;
        userOrg.User__c = user1 ;
        insert userOrg;
        Commit_Org_User__c insertedOrgUser = [Select Id From Commit_Org_User__c limit 1];
        Id commitOrgUserId = insertedOrgUser.Id;
        Commit_Org_User__c updateOrgUser = new Commit_Org_User__c(Id = commitOrgUserId);
        //updateOrgUser.Id = insertedOrgUser.Id ; 
       
        update insertedOrgUser;
        Test.stopTest();
    }
    public static testMethod void testDeleteOrgUserRecord()
    {
        Commit_Org__c cmorg=new Commit_Org__c(Name='Major Markets Judgment',Org_Level__c='Judgment');
        insert cmorg;
        Commit_Org__c commitOrgCanada =[Select Id from Commit_Org__c LIMIT 1];
        Commit_Org__c commitOrgWest =[Select Id from Commit_Org__c LIMIT 1];
        User userRecord = [Select u.Name, u.Id From User u where u.isActive = true LIMIT 1];
        Test.startTest();
        //deleting user
        Commit_Org_User__c userOrg = new Commit_Org_User__c();
        userOrg.Commit_Org__c = commitOrgCanada.Id;
        Id user1 = userRecord.Id;
        userOrg.User__c = user1 ;
        insert userOrg;
        Commit_Org_User__c insertedOrgUser1 = [Select Id From Commit_Org_User__c limit 1];
        delete insertedOrgUser1;
        Test.stopTest();
    }
}