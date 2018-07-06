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
 
@isTest(SeeAllData=true)
private class LeadDeleteNotification_Test {

static testmethod void runTestCases() 
{
    List<Lead> LstAllLead = new list<Lead>();
    string[] EmailList = new List<string>{'test@email.com', 'test1@email.com', 'test2@email.com'};
    String Name ='TestLead';
    
    LeadDeleteNotification LeadNot = new LeadDeleteNotification();
    Lead Lstld = new Lead(Email='Test@mail.com');
    LstAllLead.add(Lstld);
    
    User u = [select Name,email,Managerid from user where id=:userinfo.getuserid()];
    system.debug('Result@'+u);
    
    User m=[select Name,email from user where id=:u.id ];
    system.debug('Result2@'+m);

    string username = u.name;
    string[] email= new String[]{u.email,m.email};
    
    List<lead> leadLst = new List<Lead>();
    leadLst =[select id,Name,FirstName,LastName from lead where name!=null limit 50];
    system.debug('ResultLead@'+leadLst);
    //commenting for SingleEmailLimit issue - to be uncommented with fix. 
    //LeadDeleteNotification.readrecord(leadLst,username,email);
    //commenting for SingleEmailLimit issue - to be uncommented with fix.
    delete leadLst;
    LeadDeleteNotification.readrecord(leadLst,username,email);
}
/*    
public static readrecord(List<lead> leadLst,String Name,string[] EmailList);
{
List<Lead> LstAllLead = new list<Lead>();
string[] EmailList = new List<string>{'test@email.com', 'test1@email.com', 'test2@email.com'};
String Name ='TestLead';
LeadDeleteNotification LeadNot = new LeadDeleteNotification();
LeadNot.readrecord();
Lead Lstld = new Lead(Name ='TestLead',Email='Test@mail.com');
leadLst.add(Lstld);
}    */
}