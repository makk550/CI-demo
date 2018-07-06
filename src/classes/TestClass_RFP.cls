@istest
public class TestClass_RFP{

 static testMethod void testMethod_RFP_RedirectToAttachment()
 {
 
     RFP_Qualification__c rfpQ = new RFP_Qualification__c(Date_RFx_Received_by_CA_Inc__c = date.today(),
              Estimated_Customer_Award_Date__c=date.today(), RFx_Name__c='test RFx');
     insert rfpQ;
     ApexPages.CurrentPage().getParameters().put('newid', rfpQ.id);
     RFP_RedirectToAttachment cls = new RFP_RedirectToAttachment();
     cls.redirectURL();
     
 }   

 @isTest(SeeAllData=true)   
 public static void TestMethodForEXT_RFP_OppLineItem(){
        RFP__c rfx = new RFP__c();
        Date d=system.today();
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
        Id oppRecId = oppRecType.get('Deal Registration').getRecordTypeId();
        
        /*Account acc = new Account(Name='Test_Acc1',RecordTypeId=SystemIdUtility.getResellerDistRecordTypeId(),Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');
        acc.Solution_Provider__c = true;
        insert acc; */
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                        
Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
        
        
        Contact testContact = new Contact();
        testContact.FirstName = 'test';
        testContact.LastName = 'contact';
        testContact.AccountId = smbAcct.Id;
        insert testContact;
        Opportunity opp1 = new Opportunity(AccountId=smbAcct.Id,Name='Opp1',Reseller__c=resellerAcct.Id,Business_Unit__c='Data Management',RecordTypeId=oppRecId,CloseDate=System.today()+3,StageName=Label.Opp_Stage_10_Percent,Initial_Billing__c=2,Ent_Comm_Account__c=smbAcct.Id,type='Direct',Partner_Engagement__c='None');
        opp1.End_User_Contact__c = testContact.Id;
        insert opp1;
        rfx.Due_Date__c = d;
        rfx.Name = 'Test123' ;
        rfx.Opportunity__c = opp1.Id ;
        insert rfx;
        
         
        ApexPages.StandardController c=new ApexPages.StandardController(rfx);
        EXT_RFP_OppLineItem ext = new EXT_RFP_OppLineItem(c);
        ext.fetchSetRFPLinkedOppLineItems();
        
        List<EXT_RFP_OppLineItem.OppLineItm> lst_opli = new List<EXT_RFP_OppLineItem.OppLineItm>();
        List<OpportunityLineItem> lst_oppli = new List<OpportunityLineItem>();
        
                 
       
        lst_oppli  = [Select Id,Business_Unit__c,PricebookEntry.Product2.name,PricebookEntry.Product2.Family from OpportunityLineItem where OpportunityId != null and Business_Unit__c!=null limit 10];
         if(lst_oppli.size()>0)
          {
             
             EXT_RFP_OppLineItem.OppLineItm oppline = null ;
              for(Integer k=0;k<lst_oppli.size();k++)
              {
                   oppline = new EXT_RFP_OppLineItem.OppLineItm();
                   oppline.Id = lst_oppli[k].Id;
                   oppline.productName = lst_oppli[k].PricebookEntry.Product2.name;
                   oppline.busUnit = lst_oppli[k].Business_Unit__c;
                   oppline.productFamily = lst_oppli[k].PricebookEntry.Product2.Family;
                   lst_opli.add(oppline);
              }
         } 
         
       }
      
@isTest(SeeAllData=true)
 static void testUpdateLineitemsTriggers () {
       SystemIdUtility.skipOpportunityLineItemTriggers = true;
       RFP__c rfx = new RFP__c();
       Date d=system.today();
       Set<id> setOppsClosed = new Set<id>();
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        //Account acc = new Account(Name='Test_Acc1',RecordTypeId=SystemIdUtility.getResellerDistRecordTypeId(),Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');
        //insert acc;
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
            insert resellerAcct;                        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
            insert smbAcct;
        
        Opportunity opp1 = new Opportunity(AccountId = smbAcct.Id,Reseller__c= resellerAcct.Id, Name='Opp1',StageName = Label.Opp_Stage_Closed_Lost,RecordTypeId=oppRecId,CloseDate=System.today()+3,Initial_Billing__c=2,Ent_Comm_Account__c=smbAcct.Id,type='Direct',Partner_Engagement__c='None');
        insert opp1;
        
        setOppsClosed.add(opp1.id);   
        rfx.Due_Date__c = d;
        rfx.Name = 'Test123' ;
        rfx.Opportunity__c = opp1.Id ;
        insert rfx;
         contact con = new contact (firstname = 'testconname', lastname = 'lastname', AccountId = smbAcct.id);
         insert con;
            
         OpportunityContactRole oppcon = new OpportunityContactRole(IsPrimary = true, OpportunityId = opp1.id, contactId = con.id);
         insert oppcon ;
         opp1.StageName = Label.Opp_Stage_Closed_Won;
         
         update opp1;
        
         test.starttest();
         List<RFP__c> lstRFP = [Select id, Opp_Status__c, Opportunity__c From RFP__c where Opportunity__c =: opp1.Id];
              if(lstRFP.size() > 0)
              {
              
                      for(RFP__C rfp: lstRFP)
                      {
                          if(setOppsClosed.contains(rfp.Opportunity__c))
                              rfp.Opp_Status__c = 'Lost';
                          else
                              rfp.Opp_Status__c = 'Won';
                      } 
                  update lstRFP;
              }  
              
        Product2 prd1 = new Product2(Name='Prd1', Family='Product',Market_Focus_Area__c='SECURITY',IsActive=true);
        Product2 prd2 = new Product2(Name='Prd2', Family='Time',Market_Focus_Area__c='OTHER',IsActive=true);
        Product2 prd3 = new Product2(Name='Prd3', Family='Mainframe Capacity',Market_Focus_Area__c='OTHER',IsActive=true);
        Product2 prd4 = new Product2(Name='Prd4', Family='Services',Market_Focus_Area__c='MAINFRAME',IsActive=true);
        Product2 prd5 = new Product2(Name='Prd5', Family='Support',Market_Focus_Area__c='OTHER',IsActive=true);
        Product2 prd6 = new Product2(Name='Prd6', Family='Education',Market_Focus_Area__c='OTHER',IsActive=true);
        Product2[] prd = new Product2[]{prd1,prd2,prd3,prd4,prd5,prd6};
        insert prd;    
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id=prd[0].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true); 
        PricebookEntry pbe2 = new PricebookEntry(Product2Id=prd[1].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe3 = new PricebookEntry(Product2Id=prd[2].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe4 = new PricebookEntry(Product2Id=prd[3].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe5 = new PricebookEntry(Product2Id=prd[4].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe6 = new PricebookEntry(Product2Id=prd[5].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry[] pbe = new PricebookEntry[]{pbe1,pbe2,pbe3,pbe4,pbe5,pbe6};
        insert pbe; 
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[0].Id);
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[1].Id);
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[2].Id);
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[3].Id);
        OpportunityLineItem oli5 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[4].Id);
        OpportunityLineItem oli6 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[5].Id);
        OpportunityLineItem oli7 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[4].Id);
        OpportunityLineItem oli8 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[5].Id);
        OpportunityLineItem oli9 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[3].Id);
        OpportunityLineItem oli10 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[0].Id);
        OpportunityLineItem oli11 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[1].Id);
        OpportunityLineItem oli12 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[2].Id);
        OpportunityLineItem oli13 = new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = pbe[0].Id);
        OpportunityLineItem[] oli = new OpportunityLineItem[]{oli1,oli2,oli3,oli4,oli5,oli6,oli7,oli8,oli9,oli10,oli11,oli12,oli13};
       
        insert oli;
        test.stoptest();
    //   lst_oppli  = [Select Id,Business_Unit__c,PricebookEntry.Product2.name,PricebookEntry.Product2.Family from OpportunityLineItem where OpportunityId != null limit 6];
        
 
 }
 @isTest(SeeAllData=true)
 static void test_RFP_Creation_TRG () {
        Set<id> setOppsClosed = new Set<id>();
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        //Account acc = new Account(Name='Test_Acc1',RecordTypeId=SystemIdUtility.getResellerDistRecordTypeId(),Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='EMEA');
        //insert acc;

ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;

        Opportunity opp1 = new Opportunity(AccountId = smbAcct.Id,reseller__c= resellerAcct.Id, Name='Opp1',StageName = Label.Opp_Stage_Closed_Lost,RecordTypeId=oppRecId,CloseDate=System.today()+3,Initial_Billing__c=2,Ent_Comm_Account__c=smbAcct.Id,type='Direct',Partner_Engagement__c='None');
        insert opp1;
        
        RFP_Qualification__c  Rfp = new RFP_Qualification__c ();
        
        Rfp.Opportunity__c = opp1.Id ;
        Rfp.RFx_Due_Date__c = System.today(); 
        Rfp.RFx_Name__c = 'Test'; 
        Rfp.Type__c = 'RFP'; 
        Rfp.Date_RFx_Received_by_CA_Inc__c = System.today();
        Rfp.Estimated_Customer_Award_Date__c = System.today();
       
        insert Rfp;
        
        RFP__c rf = new RFP__c();
         rf.Opportunity__c = Rfp.Opportunity__c;
         rf.Due_Date__c = Rfp.RFx_Due_Date__c;
         rf.Name = Rfp.RFx_Name__c;
         rf.Type__c = Rfp.Type__c;
         insert rf;
      
 }
 
 
static testMethod void testExt_RFP(){

Ext_RFP rfp= new Ext_RFP ();
rfp.getListBU();
rfp.getProdList();
List<SelectOption> opp = rfp.getListBU_Answer();
rfp.getProdList_Answer();
User u = [SELECT Id, Name FROM User WHERE Profile.Name != 'System Administrator' LIMIT 1];
ApexPages.StandardController sc = new ApexPages.standardController(u);
Ext_RFP myPageCon = new Ext_RFP(sc);

        
}



 static testMethod void testMethod_RFP_AJAXInterface()
  {    
    Product2 prod = [Select name, id, Market_Focus_Area__c from Product2 where Family ='Product' Limit 1];
    if(prod == null)
    {
            prod = new Product2(name='test prod', family='Product',Market_Focus_Area__c='RMDM');
            insert prod;
    }
    Stop_Word__c sw = new Stop_Word__c();
    insert sw;    
       
    RFP_Qualification__c rfpQ = new RFP_Qualification__c(Date_RFx_Received_by_CA_Inc__c = date.today(),
              Estimated_Customer_Award_Date__c=date.today(), RFx_Name__c='test RFx');
    insert rfpQ;
   
    RFP__c rfp = new RFP__c(Due_Date__c= datetime.now());
    insert rfp;

  
    Response__C resp = new Response__C(Product_Search__c=prod.name,BU_Search__c = prod.Market_Focus_Area__c); 
    insert resp;
    
    // Trigger Test: Create a duplicate usage entry
    Question__c u = new Question__c();
    u.Question__c = 'Test Question';
    u.Original_Response__c = false;
    u.Response__c =resp.id ;
    u.RFP__c = rfp.id;
    insert u;
    
   
    PorterStemmer.testPorterStemmer();
    
    PageReference pg = Page.RFP_GetResponses; 
    pg.getParameters().put('question', 'Test Question');    
    pg.getParameters().put('search', 'Questions');   
    pg.getParameters().put('busUnit', prod.Market_Focus_Area__c);   
    pg.getParameters().put('prod', prod.name);   
    pg.getParameters().put('fnct', 'SRCH');   

    Test.setCurrentPage(pg); 

    
    RFP_AJAXInterface cls = new RFP_AJAXInterface();
    test.startTest();
    RFP_AJAXInterface.Response res = new RFP_AJAXInterface.Response();
    test.stopTest();
    
    PageReference pg2 = Page.RFP_GetResponses; 
    pg2.getParameters().put('question', 'Test Question');    
    pg2.getParameters().put('search', 'Answers');   
    pg2.getParameters().put('busUnit', prod.Market_Focus_Area__c);   
    pg2.getParameters().put('prod', prod.name);   
    pg2.getParameters().put('fnct', 'SRCH');   
    Test.setCurrentPage(pg);
    
    RFP_AJAXInterface.Response res2 = new RFP_AJAXInterface.Response();
    
    RFP_AJAXInterface.RFP_Document rpf = new RFP_AJAXInterface.RFP_Document();
    RFP_AJAXInterface.getStopWordCount();
    RFP_AJAXInterface.scrubAndStemQuestion('Test Question for You You');
    cls.getResponseText();
    
    
    cls.deleteStopWords();
    cls.getResponses();
    
  }
 
}