/***************************************************************************************************
* Test Class - Renewal_ConvToOppController_Test
* Apex class -Renewal_ConvToOppController
* Modified by SAMAP01
* Coverage - 73%
* ********************************************************************************************/
@isTest
private class Renewal_ConvToOppController_Test {
    
    public static testmethod void testMoveRenewals(){
        
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        
        Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');       
        insert ac;   
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='USD');        
        insert renCurrency;
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);       
        insert activeContract;     
        //User u = [select id from user where IsActive=:true limit 1];
        Profile prf = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
        User u = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                          lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                          profileid = prf.Id, country='United States',IsActive =true,
                          timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        insert u;
        
          User u2 = new User(alias = 'test122', email='test122@gmail.com',emailencodingkey='UTF-8',
                          lastname='Testing2', languagelocalekey='en_US',localesidkey='en_US',
                          profileid = prf.Id, country='United States',IsActive =false,
                          timezonesidkey='America/Los_Angeles', username='tester12234@noemail.com',firstName= 'test2');
        insert u2;
        Territory terr = [Select Territory_Country__c from Territory where Territory_Country__c != null LIMIT 1];
        
        Renewal__c renewal = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,Segmentation__c='HT');
        renewal.Expected_Close_Date__c=Date.valueOf('2011-05-05');
        renewal.Reason_duration_is_1_year__c = 'Bridge Contract';
        renewal.Status_at_end_of_term__c = 'Re-Renew';
        renewal.Converted_To_Opportunity__c=false;
        renewal.Overall_Comments__c='Test';
        renewal.CurrencyIsoCode='USD';
        renewal.Projected_Time_Duration_Months__c=6;
        renewal.OwnerId=u.Id;
        renewal.OCV__c=100000;
        renewal.Annual_OCV_LC__c=200000;
        renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
        renewal.Projected_Renewal__c=50000;
        renewal.Territory_Country__c = terr.Territory_Country__c;
        insert renewal;
        
        Product2 prod = new Product2(Name = 'TestProd', Family='Renewal',IsActive=true);        
        insert prod;
        
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);       
        insert rnwlProdct;    
        
        Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();     
        
        String BusinessType;
        if(renewal.Segmentation__c == 'HT')
            BusinessType = 'High Touch';
        else if(renewal.Segmentation__c == 'MT')
            BusinessType = 'Medium Touch';
        else if(renewal.Segmentation__c == 'LT')
            BusinessType = 'Low Touch';
        else if(renewal.Segmentation__c == 'NT')
            BusinessType = 'No Touch'; 
        
        Opportunity opp = new Opportunity(name=renewal.name,AccountId=renewal.Account__c,
                                          CloseDate=System.today(),Description=renewal.Overall_Comments__c,
                                          StageName=Label.Opp_Stage_10_Percent,
                                          New_Deal_Term_months__c=renewal.Projected_Time_Duration_Months__c,OwnerId=renewal.OwnerId,
                                          Original_CV__c=renewal.OCV__c,Site_ID__c=renewal.Sold_to_Ship_to_Party_Site_ID__c,Type='Direct',RPD_Status__c='Requested',
                                          Renewal__c=renewal.id,RecordTypeId = recId,
                                          Business_Type__c = BusinessType);
        insert opp;
        
        
        List<Active_Contract_Product__c> actvContPrd = new List<Active_Contract_Product__c>();       
        for(integer i=0;i<15;i++)
        {
            Active_Contract_Product__c actvContPrd1= new Active_Contract_Product__c(name='TestACP'+i,Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
            if(i == 2 || i == 4 || i == 6) {
                actvContPrd1.Converted_To_Opportunity__c = false;            
            } else {
                actvContPrd1.Converted_To_Opportunity__c = true;
            }
            actvContPrd.add(actvContPrd1);
            i=i++;
        }
        insert actvContPrd;
        
        Active_Contract_Product__c acp =[select Converted_To_Opportunity__c from Active_Contract_Product__c where id=:actvContPrd[0].id];    
        acp.Converted_To_Opportunity__c = true;
        update acp;    
        
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry p = new PricebookEntry(Product2Id=prod.Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        insert p;
        
        
        List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
        for(integer i=0;i<15;i++)
        {
            CA_Product_Renewal__c ca = new CA_Product_Renewal__c(name= 'Rnwaltest'+i,Active_Contract_Product__c=actvContPrd[i].Id,Renewal_Opportunity__c=opp.id);
            caProdRnwl.add(ca);
            i=i++;
        }
        insert caProdRnwl;
        
        List<OpportunityLineItem> oppitmlist =new List<OpportunityLineItem>();
        for(integer i=0;i<15;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId =p.id,CA_Contract_Product_Name__c = 'Test'+ i,Opportunityid = opp.id,Active_Contract_Product__c= actvContPrd[i].id);
            oppitmlist.add(oli);
            i=i++;
        }
        insert oppitmlist;
        
        ApexPages.StandardController convcont = new ApexPages.StandardController(renewal);
        Renewal_ConvToOppController cntrl = new Renewal_ConvToOppController(convcont);
        Test.startTest();
        Renewal__c rnwl = [select id, Segmentation__c, name, Account__c, OwnerId, Expected_Close_Date__c, 
                           Converted_To_Opportunity__c, Overall_Comments__c, CurrencyIsoCode,
                           Projected_Time_Duration_Months__c, OCV__c, Annual_OCV_LC__c,Baseline_ATTRF_LC__c, 
                           Sold_to_Ship_to_Party_Site_ID__c, Projected_Renewal__c,owner.isActive,
                           Local_Currency__c, New_Site_Id__c, Territory__c , // Changed for FY14 - was Territory_Country__c
                           Reason_duration_is_1_year__c,Status_at_end_of_term__c, (select active_contract__r.header_dismantle_date__c,
                                                                                   active_contract__r.Contract_Term_Months__c from Renewals_Product_Contracts__r)
                           from Renewal__c where id =:renewal.id
                          ];   //adding baseline for baseline attrf req
        
        if(cntrl.rnwl.id <> null){
            cntrl.acc = ac;
            cntrl.rnwl = rnwl;
            cntrl.creatOppRecord();    
            Map<String, String>  errlog =   cntrl.geterrorLog();
            cntrl.emaillogs();
            rnwl.Converted_To_Opportunity__c=true;
            cntrl.rnwl = rnwl;
            cntrl.creatOppRecord(); 
            rnwl.Segmentation__c ='KT';
            cntrl.rnwl = rnwl;
            cntrl.creatOppRecord();
            rnwl.OwnerId =u2.id;
            cntrl.rnwl = rnwl;
            cntrl.creatOppRecord();
        }
        Test.stopTest();    
        
    }
    
    
    
}