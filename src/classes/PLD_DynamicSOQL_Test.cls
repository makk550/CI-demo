@isTest
public class PLD_DynamicSOQL_Test {
    
    static testMethod void testSoql() 
    {
        
        
         id lrmRectype=Schema.SObjectType.LeadRoutingMatrix__c.getRecordTypeInfosByName().get('Threshold').getRecordTypeId();
     
        LeadRoutingMatrix__c Lrm=new LeadRoutingMatrix__c(Business_Unit__c='API Gateway',GEO__c='NA',LeadScore__c=5,Operating_Area__c='usa',Sales_Region__c='usa',RecordtypeId=lrmRectype);
        insert Lrm;
        
        // 1st method getLRMList
        PartnerLeadDistribution_DynamicSOQL.getLRMList();
        
        Date curdate=Date.today();
        DelegateLeadChampion__c dc=new DelegateLeadChampion__c(StartDate__c=curdate,EndDate__c=curdate );
        
        PartnerLeadDistribution_DynamicSOQL.DeligateList();
        
         Schema.DescribeSObjectResult leadresult = Schema.SObjectType.Lead;        
        Map<String,Schema.RecordTypeInfo> leadRecType = leadresult.getRecordTypeInfosByName(); 
        Id CaIndirectLeadrecType = leadRecType.get('CA Indirect Lead').getRecordTypeId();
        
        RecordTypes_Setting__c rec = new RecordTypes_Setting__c();
        rec.SObject_Name__c = 'Lead';
        rec.RecordType_Id__c = String.valueOf(CaIndirectLeadrecType);
        rec.Name = 'CA Indirect Lead';
        insert rec;
        
        List<Lead> lstLead = new List<Lead>();   
        set<id> leadidset=new set<id>();
        
        for(Integer i = 0 ; i<2 ; i++) {
            lead ld=new Lead(lastName = 'testLName'+1 ,
                             Company = 'Salesforce',
                             RecordTypeId=CaIndirectLeadrecType,
                             EAID__c='L098704', 
                             mkto71_Lead_Score__c=45, 
                             CSU_Driver__c='API Gateway'
                             );
            leadidset.add(ld.id);
            lstLead.add(ld);
         }
        insert lstLead ;
        
        //Leadlist call
        PartnerLeadDistribution_DynamicSOQL.LeadList(leadidset);
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
         Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        // id res = accRecType.get('CA Enterprise Account').getRecordTypeId();
        account a = new account(name ='Test Account', recordtypeid =res);
        
        a.Region_Country__c='xxx';
        
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'USA';
        a.GEO__c='NA';
        a.Sales_Area__c= 'usa';
        a.Sales_Region__c= 'usa';
        a.Segment__c='xxx';
        
        insert a;
        system.assertNotEquals(null, a.id, 'Account not inserted');
        
        list<id> Accidlst=new list<id>();
        Accidlst.add(a.id);
        
        //Account list call
        PartnerLeadDistribution_DynamicSOQL.AccountList(Accidlst);
        
        set<id> Accidset=new set<id>();
        Accidset.add(a.id);
        
        PartnerLeadDistribution_DynamicSOQL.GetAccountListForTieBreakingRules(Accidset);
        
       
         Date lastdate=Date.today();
        set<account> Accset=new set<account>();
        PartnerLeadDistribution_DynamicSOQL.GetOppListForLHScore(Accset,lastdate);
        
        set<string> ca_acc_idset=new set<string>();
        ca_acc_idset.add(a.id);
        PartnerLeadDistribution_DynamicSOQL.GetLeadListForLHScore(lastdate,lastdate,ca_acc_idset);
        PartnerLeadDistribution_DynamicSOQL.GetOppListForTieBreakingRules(lastdate);
        
        Date NullDate;
         PartnerLeadDistribution_DynamicSOQL.GetLeadListForLHScore(NullDate,NullDate,ca_acc_idset);
        PartnerLeadDistribution_DynamicSOQL.GetOppListForTieBreakingRules(NullDate);
        
    }

}