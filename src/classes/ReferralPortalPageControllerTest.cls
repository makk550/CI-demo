@isTest(SeeAllData=true)
public class ReferralPortalPageControllerTest {
    static testMethod void testReferralPortalLeadPageController(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Referral Partner Profile' limit 1];
        Account acc = new Account();
            acc.Name = 'test CAAcc';
            acc.Country_Picklist__c = 'AL - ALBANIA';
            acc.Account_Status__c = 'New';
            acc.Geo__c = 'EMEA';
            acc.BillingStreet='Arlington';
            acc.BillingCity='NY';
            acc.BillingCountry='US';
            insert acc;
      Contact c = new Contact();
              c.FirstName = 'test contact';
              c.LastName = 'test contact';      
              c.AccountId = acc.Id;
              c.email = 'testgys@test.com';
        insert c;
        user u;
        if(p <> null){
            u =new user( FirstName=c.FirstName,ContactId=c.id,LastName=c.LastName, ProfileId = p.Id,Username =c.email,Is_Admin_for_Partner_Finder_Profile__c=true,PortalRole='Executive',Email='testtsd@jsd.com',Alias='testi01',  EmailEncodingKey='UTF-8',TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', LanguageLocaleKey='en_US');
        }   
        User u2= new User(id=UserInfo.getUserId());
        if(u <> null){
            System.runAs(u) {
                    PageReference ref = new PageReference('/apex/ReferralPortalLeadPage');
                    Test.setCurrentPage(ref);
                    Lead newlead = new Lead();
                    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newlead);
                    ReferralPortalLeadPageController controller = new ReferralPortalLeadPageController(sc);
                    controller.physicalCountry ='CA - CANADA';
                    Pagereference popupstate = controller.popupthestates();
                    controller.physicalCountry = 'US - UNITED STATES';
                    Pagereference popupUSstate = controller.popupthestates();
                    controller.ReferralLead.FirstName = 'TestReferral';
                    controller.ReferralLead.LastName = 'lastReferral';
                    controller.ReferralLead.email = 'Test@jshd.com';
                    controller.ReferralLead.phone='9999999999';
                    controller.ReferralLead.Comments_Field__c='testing Comment';
                    controller.ReferralLead.Company='TEST TEST';
                    controller.ReferralLead.Street='TEST STREET';
                    controller.ReferralLead.City='CITY TEST';
                    controller.ReferralLead.PostalCode='763636';
                    controller.ReferralLead.Website='www.cddkdsssk.com';
                    PageReference temppageref;
                    controller.physicalCountry = '--Select--';
                    temppageref=controller.save();
                    controller.physicalCountry = 'US - UNITED STATES' ;
                    controller.physicalStateCAUS ='--Select--';
                    temppageref=controller.save();
                    controller.physicalCountry = 'CA - CANADA' ;
                    controller.physicalStateCAUS ='--Select--';
                    temppageref=controller.save();
                    controller.physicalCountry = 'IN - INDIA' ;
                    temppageref=controller.save();
                    controller.ReferralLead.LastName = null;
                    temppageref=controller.save();
                
                    Map<String,String> mapcanada = controller.prepareStatesForCanada();  
                    Map<String,String> mapUS = controller.prepareStatesForUS();
                    Pagereference viewpending = controller.viewpendingLeads();
                    pagereference redirectpage = controller.redirecttoLeads();
                
                
                    ReferralPortalPaginationController obj = new ReferralPortalPaginationController();
                    list<Lead> Leadlist= obj.getCurrentLeadList();
                    System.debug('Leadlist----->'+Leadlist);
                    //System.assert(Leadlist.size() > 0, 'Lead is not inserted');
                    obj.SearchName='lead-test';
                     obj.topDateFiltervalue='LastModifiedDate';
                     obj.topdaysFiltervalue='YESTERDAY';
                     Pagereference pageref;
                     pageref= obj.SearchLeadName();
                     pageref= obj.SearchLastModifiedAndCreated();
                     pageref =obj.exportData();
                    obj.SortToggle();
                
                  
                
            }

        }
        
    }
    
    static testMethod void testReferralPortalPageController(){
        ReferralPortalPageController obj = new ReferralPortalPageController();
        Pagereference pagref = obj.redirectpage();
    }
    /*static testMethod void testReferralPortalPaginationController(){
        ReferralPortalPaginationController obj = new ReferralPortalPaginationController();
        obj.SearchName='lead-test';
         obj.topDateFiltervalue='LastModifiedDate';
         obj.topdaysFiltervalue='YESTERDAY';
         Pagereference pageref;
         pageref= obj.SearchLeadName();
         pageref= obj.SearchLastModifiedAndCreated();
         pageref =obj.exportData();
         obj.SortToggle();
        list<Lead> Leadlist= obj.getCurrentLeadList();
    }*/
     static testMethod void testReferralPortalOppPaginationController(){
        ReferralPortalOppPaginationController obj = new ReferralPortalOppPaginationController();
         obj.SearchName='opp-test';
         obj.topDateFiltervalue='LastModifiedDate';
         obj.topdaysFiltervalue='YESTERDAY';
         Pagereference pageref;
         pageref= obj.SearchLeadName();
         pageref= obj.SearchLastModifiedAndCreated();
         pageref =obj.exportData();
         obj.SortToggle();
        List<opportunity> opplist = obj.getCurrentOppList();
    }
    
}