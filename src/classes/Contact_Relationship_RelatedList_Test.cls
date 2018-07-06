/*
 * Test Class for Contact_Relationship_RelatedList
 * Coverage = 92%
 * Test Class for Update_Contact Trigger.
 * Coverage = 95%
 * Updated by - PATSA27
*/ 


@isTest
public class Contact_Relationship_RelatedList_Test{

public static testMethod void testContactRelationshipData(){
ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
 ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();

    List<Account> acclist = new List<Account>();
    Id accid;
    Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');
    acclist.add(smbAcct);  
    //SystemIdUtility.skipAccount = true ; 
    //SystemIdUtility.isneeded=true;    
        //insert smbAcct; 
    Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.isneeded=true;
        acclist.add(resellerAcct);
        insert acclist; 
        
        if(acclist!=null && acclist.size()>0)
            accid = acclist[0].id;
        
        Contact con=new Contact(LastName='test Contact',Email='Dut10@ca.com',AccountId=accid);
        
        insert con;
    	Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%'];
    	User uObj = new User(alias = 'utest', email='test@ca.com',contactId=con.id,
                              emailencodingkey='UTF-8', lastname='Unit Test', 
                              languagelocalekey='en_US',
                              localesidkey='en_GB', profileid = profiles[0].id,
                              timezonesidkey='Europe/London', 
                              username='untest@ca.com',PMFKey__c='UTEST01');
    	insert uObj;
    	
        
        Contact_Relationship__c  contactReal=new Contact_Relationship__c (Contact__c =con.id,CA_User__c=uObj.id,StrengthOfRelationship__c='0 - Non scored',active__c=true);
        
            insert contactReal;
            
            ApexPages.StandardController ScReal=new ApexPages.StandardController(con);
            
            Contact_Relationship_RelatedList  contaReal=new Contact_Relationship_RelatedList (ScReal);
             List<Contact_Relationship__c>  listScr =contaReal.getCR();
            
            contactReal.Active__c=false;
    		update contactReal;
    
    	Contact_Relationship__c  contactReal2=new Contact_Relationship__c (Contact__c =con.id,CA_User__c=UserInfo.getUserId(),StrengthOfRelationship__c='0 - Non scored',active__c=true);
        
            insert contactReal2;
      

   }
   
   public static testMethod void testContactRelationshipData1(){
   
    ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
     ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();

    List<Account> acclist = new List<Account>();
    Id accid;
    Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');
    acclist.add(smbAcct);  
    //SystemIdUtility.skipAccount = true ; 
    //SystemIdUtility.isneeded=true;    
        //insert smbAcct; 
    Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.isneeded=true;
        acclist.add(resellerAcct);
        insert acclist; 
        
        if(acclist!=null && acclist.size()>0)
            accid = acclist[0].id;
        
        Contact con=new Contact(LastName='test Contact',Email='Dut10@ca.com',AccountId=accid);
        
        insert con;
        
            
       Contact_Relationship__c  contactReal1=new Contact_Relationship__c (Contact__c =con.id,StrengthOfRelationship__c='0 - Non scored');

            insert  contactReal1;
            
            delete [select name,id from Contact_Relationship__c where id=:contactReal1.id];

   }
}