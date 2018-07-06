/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class HVNTestClass {

    static testMethod void myUnitTest() {

        User currentUser = [select Id, HVN_Exception__c from User where id=:Userinfo.getUserId()];
        currentUser.HVN_Exception__c = false;
        currentUser.Email = 'testuser@ca.com';
        currentUser.Preferred_Contact_Method__c='Email';
        update currentUser;
        
        Contact newCnt1 = new Contact();
        newCnt1.LastName = 'Sam';
        newCnt1.Country_Picklist__c = 'India';
        try{
            insert newCnt1;
        }catch(Exception e){}

        Attachment att = new Attachment();
        att.Name = 'sample';
        att.ParentId = newCnt1.Id;
        att.Body = Blob.valueOf('12345Testing'); 
        insert att;
        RecordType rr = [Select Name, Id From RecordType where SobjectType='Account' and Name='SMB'];
        Account acc = new Account();
       
        acc.RecordTypeId  =rr.Id; //SMB Account
        acc.Name = 'sample';
        acc.Customer_Category__c = 'Commercial';
        acc.Account_Status__c = 'Submitted';
        acc.GEO__c = 'NA';
        acc.Company_Logo_ID__c = att.Id;
        insert acc; 
        
        Date myDate = date.newinstance(2010, 09, 13);
        HVN__c newHVN = new HVN__c();
        newHVN.Relationship_Date__c = myDate;
        newHVN.Relationship_Status__c = 'New Relationship/No Previous Contact';
        newHVN.Contact__c = newCnt1.Id;
        insert newHVN;
        
        //HVN__c existingHVN = [SELECT ID,Name,Contact__c FROM HVN__c WHERE ID NOT IN (SELECT HVN_Contact__c FROM HVN_Touchpoint__c) LIMIT 1];
        //Contact existingCNT = [SELECT ID,Name,HVN_ID__c FROM Contact WHERE HVN_ID__c=:existingHVN.Id];
        //System.debug('existingHVN is------------------: ' + existingHVN.Id);
        
        HVN_Touchpoint__c  tp = new HVN_Touchpoint__c();
        tp.HVN_Contact__c = newHVN.id;
        tp.Date__c = Date.today();
        tp.Contacted_by__c = currentUser.Id;
        insert tp;
        delete tp;

        
        tp = new HVN_Touchpoint__c();
        tp.HVN_Contact__c = null;
        tp.Date__c = Date.today();
        tp.Contacted_by__c = currentUser.Id;
        insert tp;
        
        Contact newCnt = new Contact();
        newCnt.LastName = 'Sam';
        newCnt.Country_Picklist__c = 'India';
        newCnt.AccountId = acc.Id;
        //newCnt.HVN_ID__c = existingHVN.ID;
        insert newCnt;
        update newCnt;
        
/*        AccountTeamMember atm = new AccountTeamMember();
        //atm.AccountAccessLevel = 'Edit';
        atm.AccountId = acc.Id;
        atm.UserId = currentUser.Id;
        atm.TeamMemberRole='HVN Owner1';
        insert atm;
*/        
        HVN__c hvn = new HVN__c();
        hvn.Contact__c = newCnt.Id;
        hvn.Name = 'Sam';
        hvn.Primary_HVN_Owner__c = currentUser.Id;
        hvn.Secondary_HVN_Contact_Owner_1__c = currentUser.Id;
        hvn.Secondary_HVN_Contact_Owner_2__c = currentUser.Id;
        hvn.Secondary_HVN_Contact_Owner_3__c = currentUser.Id;
        hvn.HVN_Contact_Photo_ID__c = att.Id;
        insert hvn;

        try{        
        delete att;
        }catch(Exception e){}
        //
    }
}