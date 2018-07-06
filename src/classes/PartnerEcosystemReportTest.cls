@isTest(seeAllData = true)
private class PartnerEcosystemReportTest
{ 
       public static testmethod void methodforPRM_Test(){
        
        Product_Alignment__c pao = new Product_Alignment__c();
        Product_Alignment__c pao1 = new Product_Alignment__c();
        recordtype r = [select id from recordtype where name=:'Technology Partner'];
        pao1.Related_Account__c = [select id from account where recordtypeid =: r.id and ispartner =: true and Technology_Partner_Effective_Date__c !=null  limit 1].id;
       // pao1.Product__c = [select id from product2 limit 1].id;
        insert pao1;
          Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(pao1);
             PRM_PartnerEcosystemReport MP = new PRM_PartnerEcosystemReport(sc);
             mp.SearchAccountStatus = '-- None ---';
             mp.SearchSecondaryAccountType = '-- None ---';             
             mp.SearchTechnologyPartnerEffectiveDateFrom = system.today()-200;              
           mp.SearchTechnologyPartnerEffectiveDate = system.today();
            MP.Go();
            PRM_PartnerEcosystemReport MP1 = new PRM_PartnerEcosystemReport(sc);
            //mp1.SearchAccountStatus = 'Terminated';
            mp1.SearchTechnologyPartnerEffectiveDateFrom = null;
            mp1.SearchTechnologyPartnerEffectiveDate = system.today();
             
             MP1.Go();
            PRM_PartnerEcosystemReport MP2 = new PRM_PartnerEcosystemReport(sc);
             mp2.SearchAccountStatus = 'Terminated';
             mp2.SearchSecondaryAccountType = 'test';
              mp2.SearchTechnologyPartnerEffectiveDate = system.today();
              mp2.SearchTechnologyPartnerEffectiveDateFrom = system.today()-200;
             mp2.go();
             PRM_PartnerEcosystemReport MP3 = new PRM_PartnerEcosystemReport(sc);
             mp3.SearchAccountStatus = 'test';
             mp3.SearchSecondaryAccountType = 'test';
              mp3.SearchTechnologyPartnerEffectiveDate = system.today();
              mp3.SearchTechnologyPartnerEffectiveDateFrom = system.today()-200;
             mp3.go();
             
              
             
            //List<SelectOption> p1 = MP.getSecondaryAccountType();
            //List<SelectOption> p = MP.getAccountStatusList(); 
        
        }
        }