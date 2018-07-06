@isTest
public class opplineitemhistorycontroller_Test {
    
    static testmethod void validateStandardController(){
         contact c=new contact();
        c.FirstName='Sesidhar';
        c.LastName='Ponnada';
        c.Email='ponse01@ca.com';
        insert c;
          lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
            RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Commercial Account');
            lstrec.add(rec1);
            RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFP', Name='CA Enterprise Account');
            lstrec.add(rec2);
            RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Account Team Covered Account');
            lstrec.add(rec3);
            RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFR', Name='Reseller/Distributor Account');
            lstrec.add(rec4);
          RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55o', Name='Territory Covered Account');
            lstrec.add(rec5);
              RecordTypes_Setting__c rec7 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFD', Name='SMB');
            lstrec.add(rec7);
                    RecordTypes_Setting__c rec8 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFD', Name='Deal Registration');
            lstrec.add(rec8); 
            RecordTypes_Setting__c rec9 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFP', Name='Partner Opportunity');
            lstrec.add(rec9); 
              RecordTypes_Setting__c rec19 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFN', Name='New Opportunity');
            lstrec.add(rec19); 
            insert lstrec;
        
        
       
            Account a = new Account(Name='TestAccount',BillingState = 'NY',Customer_Category__c = 'Enterprise',GEO__c='NA',
                                        Enterprise_ID__c = '1234te',Enterprise_Account_Name__c = 'rdName',RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId(),
                                            Commercial_ID__c = 'asdf');
        	insert a;
            
     opportunity opp=   new Opportunity(Name=a.Name + ' Opportunity ',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=a.Id);
        insert opp;


          
           // opp.Reseller_Contact__c=c.Id;
        
        DealRegistrationApproved__c dra=new DealRegistrationApproved__c();
        dra.Opportunity_Name__c=opp.Id;
        dra.IsLatest__c=true;
        insert dra;
        Attachment attach=new Attachment(); 
    attach.Name='Unit Test Attachment';
        attach.body=Blob.valueOf('Unit Test Attachment Body'); 
        attach.parentId=dra.id;
            insert attach;
        dra.AttachmentID__c=string.valueOf(attach.Id);
        update dra;
        //opp.IsLatestAttachmentid__c=string.valueOf(attach.Id);
       // update opp;
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        opplineitemhistorycontroller opc=new opplineitemhistorycontroller(sc);


        
    }
}