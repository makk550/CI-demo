@isTest(SeeAllData=true) 
public class TestHandler 
{
   
public static void testTermHandler()
{
    Account acc =new Account(Name='Test method account', Account_Status__c='Approved');
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    acc.IsPartner=true;
    update acc;
    Contact ct=new Contact(LastName='test last Name ',AccountId=acc.Id,Email='testmethod@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    insert ct;
    User p=new User();
    p.ContactId=ct.Id;
    p.FirstName='last Name';
    p.LastName='last Name';
    p.Alias='testca';
    p.Username='testmethod@ca.com.test';
    p.Email='testmethod@ca.com.test';
    p.LocaleSidKey='ar';
    p.ProfileId=[Select Id from Profile where Name like 'GEM Partner%' limit 1].Id;
    p.EmailEncodingKey='UTF-8';
    p.TimeZoneSidKey='Pacific/Fiji';
    p.LanguageLocaleKey='en_US';
    p.TermsAccepted__c=false;
    insert p;
    acc.Eligible_for_MDF__c=true;
    acc.Portal_Champion__c=p.Id;
    update acc;
    /*Add unaccepted MDF programs admin records*/
    //Select f.TCAcceptedOn__c,f.TCAccepted__c,f.Partner__r.Id, f.Partner__c, f.Name, f.MDF_Program__r.Name,f.MDF_Program__r.Terms_and_Conditions__c, f.MDF_Program__r.Id, f.MDF_Program__c, f.Id From Fund_Participant__c f where f.Partner__r.Id =:u.Contact.AccountId and f.TCAccepted__c= false
    Fund_Programs_Admin__c fpa=new Fund_Programs_Admin__c();
    fpa.Name='test Fund Program admin record';
    fpa.Terms_and_Conditions__c='test html area';
    fpa.Approval_Funds_Expiry_Days__c=25;
    fpa.CA_Share__c=50;
    insert fpa;
    Fund_Programs_Admin__c fpa2=new Fund_Programs_Admin__c();
    fpa2.Name='test Fund Program admin record2';
    fpa2.Terms_and_Conditions__c='test html area2';
    fpa2.Approval_Funds_Expiry_Days__c=25;
    fpa2.CA_Share__c=50;
    insert fpa2;
    Fund_Participant__c pf=new Fund_Participant__c();
    pf.TCAccepted__c=false;
    pf.Partner__c=acc.id;
    pf.MDF_Program__c=fpa.Id;
    insert pf;
    Fund_Participant__c pf1=new Fund_Participant__c();
    pf1.TCAccepted__c=false;
    pf1.Partner__c=acc.id;
    pf1.MDF_Program__c=fpa2.Id;
    insert pf1;
    List<Attachment> lstA=new List<Attachment>();
    List<Attachment> lstAtt=[Select Parentid,Id,Name,Body from Attachment where Name like 'MDF_Terms_Conditions%'];
    if(lstAtt !=null && lstAtt.size()>1  )
    {
        Attachment at1=new Attachment();
        at1.ParentId=fpa.Id;
        at1.Name=lstAtt[0].Name;
        at1.Body=lstAtt[0].Body;
        lstA.add(at1);
        Attachment at2=new Attachment();
        at2.Name=lstAtt[1].Name;
        at2.Body=lstAtt[1].Body;
        at2.ParentId=fpa2.Id;
        lstA.add(at2);
        insert lstA;
    }
    update lstAtt;
    System.runAs(p)
    {
    PageReference pageRef = Page.partnerterms;
    Test.setCurrentPage(pageRef);
    TermsHandler objTerm=new TermsHandler();
    objTerm.strErrorMessage='NO Error';
    objTerm.CheckForFirstHit();   
    objTerm.getUser();  
    objTerm.Register();
    objTerm.LogoutUser();
    objTerm.RegisterAndMDFHandler();
    objTerm.MDFHandlerOnly();
    objTerm.AddPageErrorMessage('SOME ERROR','SOME EROOR');
    }
    
}
//@isTest(SeeAllData=true)
public static void testPartnerHome()
{
    Account acc =new Account(Name='Test method account', Account_Status__c='Approved');
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    acc.IsPartner=true;
    update acc;
    Contact ct=new Contact(LastName='test last Name ',AccountId=acc.Id,Email='testmethod@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    insert ct;
    User p=new User();
    p.ContactId=ct.Id;
    p.FirstName='last Name';
    p.LastName='last Name';
    p.Alias='testca';
    p.Username='testmethod@ca.com.test';
    p.Email='testmethod@ca.com.test';
    p.LocaleSidKey='ar';
    p.ProfileId=[Select Id from Profile where Name like 'GEM Partner%' limit 1].Id;
    p.EmailEncodingKey='UTF-8';
    p.TimeZoneSidKey='Pacific/Fiji';
    p.LanguageLocaleKey='en_US';
    p.TermsAccepted__c=false;
    insert p;
    acc.Eligible_for_MDF__c=true;
    acc.Portal_Champion__c=p.Id;
    update acc;
    /*Add unaccepted MDF programs admin records*/
    Fund_Programs_Admin__c fpa=new Fund_Programs_Admin__c();
    fpa.Name='test Fund Program admin record';
    fpa.Terms_and_Conditions__c='test html area';
    fpa.Approval_Funds_Expiry_Days__c=25;
    fpa.CA_Share__c=50;
    insert fpa;
    Fund_Programs_Admin__c fpa2=new Fund_Programs_Admin__c();
    fpa2.Name='test Fund Program admin record2';
    fpa2.Terms_and_Conditions__c='test html area2';
    fpa2.Approval_Funds_Expiry_Days__c=25;
    fpa2.CA_Share__c=50;
    insert fpa2;
    Fund_Participant__c pf=new Fund_Participant__c();
    pf.TCAccepted__c=false;
    pf.Partner__c=acc.id;
    pf.MDF_Program__c=fpa.Id;
    insert pf;
    Fund_Participant__c pf1=new Fund_Participant__c();
    pf1.TCAccepted__c=false;
    pf1.Partner__c=acc.id;
    pf1.MDF_Program__c=fpa2.Id;
    insert pf1;
    List<Attachment> lstA=new List<Attachment>();
    List<Attachment> lstAtt=[Select Parentid,Id,Name,Body from Attachment where Name like 'MDF_Terms_Conditions%'];
    if(lstAtt !=null && lstAtt.size() > 1 )
    {
        Attachment at1=new Attachment();
        at1.ParentId=fpa.Id;
        at1.Name=lstAtt[0].Name;
        at1.Body=lstAtt[0].Body;
        lstA.add(at1);
        Attachment at2=new Attachment();
        at2.Name=lstAtt[1].Name;
        at2.Body=lstAtt[1].Body;
        at2.ParentId=fpa2.Id;
        lstA.add(at2);
        insert lstA;
    }
    update lstAtt;
    System.runAs(p)
    {
    PageReference pageRef = Page.PartnerHome;
    pageRef.getParameters().put('CPMS_TO_SF','/home/home.jsp');
    Test.setCurrentPage(pageRef);
    PartnerHome objTerm=new PartnerHome();
    objTerm.strErrorMessage='NO Error';
    objTerm.getUser();  
    objTerm.Register();
    objTerm.LogoutUser();
    objTerm.RegisterAndMDFHandler();
    objTerm.MDFHandlerOnly();
    objTerm.AddPageErrorMessage('SOME ERROR','SOME EROOR');
    PageReference pageRef2 = Page.PartnerHome;
    Test.setCurrentPage(pageRef2);
    }
}
//@isTest(SeeAllData=true)
public static void testViewTech()
{
    Account acc =new Account(Name='Test method account', Account_Status__c='Approved');
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    ViewTech vt=new ViewTech();
    Pagereference pg=Page.ViewTechPartner;
    Apexpages.currentPage().getParameters().put('id',acc.Id);
    vt.getAccount();
    vt.redirect();
    Test.setCurrentPage(pg);
}
//@isTest(SeeAllData=true)
public static void testCA_TAQ_EnablePartner()
{
    //insert a TAQ account and Update it
    Account acc =new Account(Name='Test method account', Account_Status__c='Approved');
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    Account acc2 =new Account(Name='Test method account', Account_Status__c='Approved');
    acc2.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc2.Reseller_Disti_Regional_ID__c='testId 2';
    acc2.Reseller_Distributor_Name__c='test Dist name 2';
    insert acc2;
    List<User> lstUser=[Select id,pmfkey__c from user where PMFKey__c != null and isActive = true limit 3];
        user u1= lstUser[0];
        user u2= lstUser[1];
        user u3= lstUser[2];
    List<TAQ_Organization__c> uList = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 20];
    TAQ_Account__c objTaq=new TAQ_Account__c();
     Date d = date.today();
            objTaq.name='test acc';
            objTaq.Enterprise_Id__c='EA0520';
            objTaq.Enterprise_Account_Name__c='idc test acc';
    //FY13        objTaq.Market__c='testm';
            objTaq.Region__c='EMEA';
            objTaq.Area__c='testa';
            objTaq.Territory__c='testt';
            objTaq.Country__c='testc';
            objTaq.Account_Type__c='test type';
    //FY13        objTaq.Account_Class__c='Class 4';
            objTaq.Alliance__c = True ;
            objTaq.Alliance_Designation__c = 'ISV' ;
            objTaq.Alliance_CAM_PMFKey__c = u1.pmfkey__c ;
            objTaq.Alliance_Program_Level__c ='Platinum';
            objTaq.Alliance_Type__c = 'Global Systems Integrator';
            objTaq.Industry_Vertical__c='test ind';
            objTaq.Stock_Ticker__c='test tick';
            objTaq.Comments__c='testcom';
   
            objTaq.Area_for_Data_Load__c='testa';
            objTaq.Territory_For_Data_Load__c='nordics';
            objTaq.Country_for_Data_Load__c='United States';
     //FY13       objTaq.Market_for_Data_Load__c='test';
            objTaq.Approval_Process_Status__c='Migrated';
            
            insert objTaq;
            
            objTaq.recordtypeid=Label.TAQ_Partner_Recordtype;
            objTaq.Process_Step__c='Account Add';
            objTaq.Approval_Status__c='Approved';
            objTaq.Approval_Process_Status__c='Approved';
            objTaq.Approval_Process_Status__c='Approved-Updated';
            objTaq.View_Acc_Record__c=acc2.id;
            update objTaq;
}
//@isTest(SeeAllData=true)
public static void test_auai_SalesTeamForEA()
{
    //inserting partner user
    Account acc =new Account(Name='Test method account', Account_Status__c='Approved');
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    acc.IsPartner=true;
    update acc;
    Contact ct=new Contact(FirstName='test last Name ',LastName='test last Name ',AccountId=acc.Id,Email='testmethod@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    insert ct;
    User p=new User();
    p.ContactId=ct.Id;
    p.FirstName='last Name';
    p.LastName='last Name';
    p.Alias='testca';
    p.Username='testmethod@ca.com.test';
    p.Email='testmethod@ca.com.test';
    p.LocaleSidKey='ar';
    p.ProfileId=[Select Id from Profile where Name like 'GEM Partner%' limit 1].Id;
    p.EmailEncodingKey='UTF-8';
    p.TimeZoneSidKey='Pacific/Fiji';
    p.LanguageLocaleKey='en_US';
    p.TermsAccepted__c=false;
    insert p;
    
    /******/
    Contact ct2=new Contact(LastName='test last Name 2',AccountId=acc.Id,Email='testmethod2@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    insert ct2;
    User p1=new User();
    p1.ContactId=ct2.Id;
    p1.FirstName='last Name';
    p1.LastName='last Name';
    p1.Alias='testca1';
    p1.Username='testmethod2@ca.com.test';
    p1.Email='testmethod2@ca.com.test';
    p1.LocaleSidKey='ar';
    p1.ProfileId=[Select Id from Profile where Name like 'GEM Partner%' limit 1].Id;
    p1.EmailEncodingKey='UTF-8';
    p1.TimeZoneSidKey='Pacific/Fiji';
    p1.LanguageLocaleKey='en_US';
    p1.TermsAccepted__c=false;
    insert p1;
    
    /*********/
List<AccountTeamMember> accountTeamMemberList = new List<AccountTeamMember>();
        List<Id> userIdList = new List<Id>();
        List<Opportunity> opportunityList= new List<Opportunity>();
        User[] u = new List<User>();
    // insert and update Opportunity record
    Account distributorAccount = new Account();
        distributorAccount = [Select Id from Account where Customer_Category__c ='Distributor' limit 1];
        Account resellerAccount = new Account();
        resellerAccount = [Select Id from Account where Customer_Category__c ='Reseller' limit 1];
        Account partnerAccount = new Account();
        partnerAccount.Name='test Partner account';
        partnerAccount.Customer_Category__c='Alliance - Influence';
        insert partnerAccount;
        System.debug('-----------------'+partnerAccount);
        
        if(distributorAccount != null || resellerAccount != null || partnerAccount != null)
        {
            u = [SELECT Id FROM User WHERE IsActive =: true AND contactId =: null limit 10];
            for(Integer s=0; s<u.size(); s++)
            {
                accountTeamMemberList.add(new AccountTeamMember(
                                                      AccountId = distributorAccount.Id,
                                                      TeamMemberRole = 'AD/AM/GAD',
                                                      UserId = u[s].Id
                                                      ));
            }
            for(Integer s=0; s<u.size(); s++)
            {
                accountTeamMemberList.add(new AccountTeamMember(
                                                      AccountId = resellerAccount.Id,
                                                      TeamMemberRole = 'AD/AM/GAD',
                                                      UserId = u[s].Id
                                                      ));
            }
            for(Integer s=0; s<u.size(); s++)
            {
                accountTeamMemberList.add(new AccountTeamMember(
                                                      AccountId = partnerAccount.Id,
                                                      TeamMemberRole = 'AD/AM/GAD',
                                                      UserId = u[s].Id
                                                      ));
            }
            insert accountTeamMemberList;
            
            Id recId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
            account tempAcc = new account(name = 'wells', recordtypeid = recid);
            insert tempAcc; 
            RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('New Opportunity');
            Id newOpportunityRecordTypeId = rec.RecordType_Id__c;
   
            Opportunity opty1 = new Opportunity();
            opty1.AccountId = tempAcc.Id;
            opty1.Reseller__c = tempAcc.Id;
            opty1.RecordTypeId = newOpportunityRecordTypeId;
            opty1.Name = 'Test Oppty';
            opty1.StageName =Label.Opp_Stage_10_Percent;
            opty1.CloseDate = System.today();
           // if(distributorAccount != null)
           // opty1.Distributor_6__c = distributorAccount.Id;
            opty1.Ent_Comm_Account__c=distributorAccount.Id;
            opty1.Requestor_Information__c=p1.Id;
            insert opty1;
            
            Opportunity opty2 = new Opportunity();
            opty2.RecordTypeId = newOpportunityRecordTypeId;
            opty2.AccountId = tempAcc.Id;
            opty2.Reseller__c= tempAcc.Id;
            opty2.Name = 'Test Oppty';
            opty2.StageName =Label.Opp_Stage_10_Percent;
            opty2.Requestor_Information__c=p.Id;
            opty2.CloseDate = System.today();
          //  if(distributorAccount != null)
          //  opty2.Distributor_6__c = distributorAccount.Id;
            opty2.Ent_Comm_Account__c=distributorAccount.Id;
            opportunityList.add(opty2);
            
            Opportunity opty3 = new Opportunity();
            opty3.Requestor_Information__c=p.Id;
            opty3.RecordTypeId = newOpportunityRecordTypeId;
            opty3.AccountId = tempAcc.Id;
             opty3.Reseller__c= tempAcc.Id;
            opty3.Name = 'Test Oppty';
            opty3.StageName =Label.Opp_Stage_10_Percent;
            opty3.CloseDate = System.today();
        //    if(distributorAccount != null)
          //  opty3.Distributor_6__c = distributorAccount.Id;
            opty3.Ent_Comm_Account__c= distributorAccount.Id;
            
            opportunityList.add(opty3);
            
            insert opportunityList;
            
        }

    /***********/
}
@isTest(SeeAllData=true)
public static void testTriggeruserUA()
{
    User portalAccountOwner1 = [select id from user where UserRole.PortalType =:'None' and isactive=:true limit 1];
    //Create a list of Partner users
    String stePId=[Select Id from Profile where Name like '%Partner%' limit 1].Id;
    //string strRole=[Select u.id, u.Name From UserRole u where Name like '%Partner User%' limit 1].Id;
    Account acc =new Account(Name='Test method account', Account_Status__c='Approved',OwnerId=portalAccountOwner1.Id);
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    acc.IsPartner=true;
    update acc;
    Contact ct=new Contact(FirstName='test last Name ',LastName='test last Name ',AccountId=acc.Id,Email='testmethod@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    Contact ct1=new Contact(FirstName='test last Name ',LastName='test last Name ',AccountId=acc.Id,Email='testmethod1@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    Contact ct2=new Contact(FirstName='test last Name ',LastName='test last Name ',AccountId=acc.Id,Email='testmethod2@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    List<Contact> lstC=new List<Contact>();
    lstC.add(ct); 
    lstC.add(ct1);
    lstC.add(ct2);
    insert lstC;
    
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
    List<User> lstPartnerUser=New List<User>();
    User p=new User();
    p.ContactId=ct.Id;
    p.LastName='last Name';
    p.FirstName='test first Name';
    p.Alias='testca';
    p.Username='testmethod@ca.com.test';
    p.Email='testmethod@ca.com.test';
    p.LocaleSidKey='ar';
    p.ProfileId=portalProfile.Id;  //stePId;
    p.EmailEncodingKey='UTF-8';
    p.TimeZoneSidKey='Pacific/Fiji';
    p.LanguageLocaleKey='en_US';
    p.TermsAccepted__c=false;
    //p.UserRoleId=strRole;
    p.LDAP_Id__c='XYZ1_TE';
    p.Education_Access__c=true;
    p.IsActive=true;
    lstPartnerUser.add(p);
    
    User p1=new User();
    p1.FirstName='second Name';
    p1.LDAP_Id__c='XYZ2_YX';
    p1.ContactId=ct1.Id;
    p1.FirstName='last Name';
    p1.LastName='last Name';
    p1.Alias='testca1';
    p1.Username='testmethod1@ca.com.test';
    p1.Email='testmethod1@ca.com.test';
    p1.LocaleSidKey='ar';
    p1.ProfileId=portalProfile.Id; //stePId;
    p1.EmailEncodingKey='UTF-8';
    p1.TimeZoneSidKey='Pacific/Fiji';
    p1.LanguageLocaleKey='en_US';
    p1.TermsAccepted__c=false;
    //p1.UserRoleId=strRole;
    p1.IsActive=false;
    lstPartnerUser.add(p1);
    
    User p2=new User();
    p2.IsActive=true;
    p2.FirstName='second last Name';
    p2.LDAP_Id__c='XYZ_Test2';
    p2.ContactId=ct2.Id;
    p2.LastName='last Name';
    p2.Alias='testca1';
    p2.Username='testmethod2@ca.com.test';
    p2.Email='testmethod2@ca.com.test';
    p2.LocaleSidKey='ar';
    p2.ProfileId=portalProfile.Id; //stePId;
    p2.EmailEncodingKey='UTF-8';
    p2.TimeZoneSidKey='Pacific/Fiji';
    p2.LanguageLocaleKey='en_US';
    p2.TermsAccepted__c=false;
    //p2.UserRoleId=strRole;
    lstPartnerUser.add(p2);
    
    System.runAs(new User(Id = Userinfo.getUserId())) {    
    insert lstPartnerUser;
    }
    /*
    List<User> pUser=new List<User>();
    p.LastName='Last Name change';
    p1.LastName='Last Name change';
    p2.LastName='Last Name change';
    pUser.add(p);
    pUser.add(p1);
    pUser.add(p2);*/
    Set<Id> setId=new Set<Id>();
     ct.Portal_Champion__c = true;
     update ct;
      ct2.Portal_Champion__c = false;
     update ct2;
     
    setId.add(p.id);setId.add(p1.id);setId.add(p1.id);
    
    
     Map<Id,Id> conMap = new Map<Id,Id>();
    List<Account> accList = [select id from account limit 5];
    conMap.put(ct.Id,accList[0].Id);
    conMap.put(ct1.Id,accList[1].Id);
    conMap.put(ct2.Id,accList[2].Id);
    
    set<String> emailList = new set<String>();
    emailList.add(p1.email);
    emailList.add(p2.email);
    
    
    CreatePartnerUserDataOnUserUpdate.createPartnerUserData(setId);
    CreatePartnerUserDataOnUserUpdate.updatePartnerUserData(setId);
   // CreatePartnerUserDataOnUserUpdate.unCheckPortalChampion(setId);
    //CreatePartnerUserDataOnUserUpdate.createPartnerLocations(conMap,emailList);
    
}
@isTest(seealldata = true)
public static void testAccountUpdateCountryPicklist()
{
    List<Account> lst =new List<Account>();
    string strLst='AD__AE__AF__AG__AI__AL__AM__AN__AO__AQ__AR__AS__AT__AU__AW__AX__AZ__BA__BB__BD__BE__BF__BG__BH__BI__BJ__BL__BM__BN__BO__BR__BS__BT__BV__BW__BY__BZ__CA__CC__CD__CF__CG__CH__CI__CK__CL__CM__CN__CO__CR__CU__CV__CX__CY__CZ__DE__DJ__DK__DM__DO__DZ__EC__EE__EG__EH__ER__ES__ET__FI__FJ__FK__FM__FO__FR__GA__GB__GD__GE__GF__GG__GH__GI__GL__GM__GN__GP__GQ__GR__GS__GT__GU__GW__GY__HK__HM__HN__HR__HT__HU__ID__IE__IL__IM__IN__IO__IQ__IR__IS__IT__JE__JM__JO__JP__KE__KG__KH__KI__KM__KN__KR__KW__KY__KZ__LA__LB__LC__LI__LK__LR__LS__LT__LU__LV__LY__MA__MC__MD__ME__MF__MG__MH__MK__ML__MM__MN__MO__MP__MQ__MR__MS__MT__MU__MV__MW__MX__MY__MZ__NA__NC__NE__NF__NG__NI__NL__NO__NP__NR__NU__NZ__OM__PA__PE__PF__PG__PH__PK__PL__PM__PN__PR__PS__PT__PW__PY__QA__RE__RO__RS__RU__RW__SA__SB__SC__SD__SE__SG__SH__SI__SJ__SK__SL__SM__SN__SO__SR__ST__SV__SY__SZ__TC__TD__TF__TG__TH__TJ__TK__TL__TM__TN__TO__TR__TT__TV__TW__TZ__UA__UG__UM__US__UY__UZ__VA__VC__VE__VG__VI__VN__VU__WF__WS__WW__YE__YT__ZA__ZM__ZW';
    integer i=0;
    for(string strPick : strLst.split('__'))
    {
        Account acc=new Account();
        acc.Name='acc test'+i;
        acc.Country_ISO_code__c=strPick;
        acc.BillingStreet = 'Arlington';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'VA';
        lst.add(acc);
        i++;
    }
    insert lst;
    
    
    
    
    
}  
}