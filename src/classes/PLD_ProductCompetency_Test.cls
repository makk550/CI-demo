@isTest
public class PLD_ProductCompetency_Test {
    
     
    static testMethod void ProductCompetencytest() {
        
        Schema.DescribeSObjectResult leadresult = Schema.SObjectType.Lead;        
        Map<String,Schema.RecordTypeInfo> leadRecType = leadresult.getRecordTypeInfosByName(); 
        Id CaIndirectLeadrecType = leadRecType.get('CA Indirect Lead').getRecordTypeId();
        
        RecordTypes_Setting__c rec = new RecordTypes_Setting__c();
        rec.SObject_Name__c = 'Lead';
        rec.RecordType_Id__c = String.valueOf(CaIndirectLeadrecType);
        rec.Name = 'CA Indirect Lead';
        insert rec;
        
        lead ld=new Lead(lastName = 'testLName'+1 ,
                             Company = 'Salesforce',
                             RecordTypeId=CaIndirectLeadrecType,
                             EAID__c='L098704', 
                             mkto71_Lead_Score__c=45, 
                             CSU_Driver__c='API Gateway'
                             );
        lead ld1=new Lead(lastName = 'testLName'+2 ,
                             Company = 'Salesforce',
                             RecordTypeId=CaIndirectLeadrecType,
                             EAID__c='L098704', 
                             mkto71_Lead_Score__c=45, 
                             CSU_Driver__c='API Gateway'
                             );
        
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
        
        account a1 = new account(name ='Test Account', recordtypeid =res);
        
        a1.Region_Country__c='xxx';
        
        a1.customer_Category__c= 'Reseller';
        a1.hq__c= true;
        a1.Commercial_Account_Name__c='test 11111114'  ;
        a1.Commercial_ID__c= 'test 11111115';
        a1.Country_Picklist__c= 'USA';
        a1.GEO__c='NA';
        a1.Sales_Area__c= 'usa';
        a1.Sales_Region__c= 'usa';
        a1.Segment__c='xxx';
        
         account a2 = new account(name ='Test Account', recordtypeid =res);
        
        a2.Region_Country__c='xxx';
        
        a2.customer_Category__c= 'Reseller';
        a2.hq__c= true;
        a2.Commercial_Account_Name__c='test 11111114'  ;
        a2.Commercial_ID__c= 'test 11111115';
        a2.Country_Picklist__c= 'USA';
        a2.GEO__c='NA';
        a2.Sales_Area__c= 'usa';
        a2.Sales_Region__c= 'usa';
        a2.Segment__c='xxx';
        
         account a3 = new account(name ='Test Account', recordtypeid =res);
        
        a3.Region_Country__c='xxx';
        
        a3.customer_Category__c= 'Reseller';
        a3.hq__c= true;
        a3.Commercial_Account_Name__c='test 11111114'  ;
        a3.Commercial_ID__c= 'test 11111115';
        a3.Country_Picklist__c= 'USA';
        a3.GEO__c='NA';
        a3.Sales_Area__c= 'usa';
        a3.Sales_Region__c= 'usa';
        a3.Segment__c='xxx';
        
        account a4 = new account(name ='Test Account', recordtypeid =res);
        
        a4.Region_Country__c='xxx';
        
        a4.customer_Category__c= 'Reseller';
        a4.hq__c= true;
        a4.Commercial_Account_Name__c='test 11111114'  ;
        a4.Commercial_ID__c= 'test 11111115';
        a4.Country_Picklist__c= 'USA';
        a4.GEO__c='NA';
        a4.Sales_Area__c= 'usa';
        a4.Sales_Region__c= 'usa';
        a4.Segment__c='xxx';
        
        list<account> acclist=new list<account>();
        acclist.add(a);
        acclist.add(a1);
        acclist.add(a2);
        acclist.add(a3);
        acclist.add(a4);
        
        insert acclist;
        //insert a;
        //system.assertNotEquals(null, a.id, 'Account not inserted');
        
        
        a=[select name,recordtypeid,Region_Country__c,hq__c,Commercial_Account_Name__c,Commercial_ID__c,Country_Picklist__c,GEO__c,Sales_Area__c,Sales_Region__c,Segment__c from account where id=: a.id];
        a1=[select name,recordtypeid,Region_Country__c,hq__c,Commercial_Account_Name__c,Commercial_ID__c,Country_Picklist__c,GEO__c,Sales_Area__c,Sales_Region__c,Segment__c from account where id=: a1.id];
        a2=[select name,recordtypeid,Region_Country__c,hq__c,Commercial_Account_Name__c,Commercial_ID__c,Country_Picklist__c,GEO__c,Sales_Area__c,Sales_Region__c,Segment__c from account where id=: a2.id];
        a3=[select name,recordtypeid,Region_Country__c,hq__c,Commercial_Account_Name__c,Commercial_ID__c,Country_Picklist__c,GEO__c,Sales_Area__c,Sales_Region__c,Segment__c from account where id=: a3.id];
        a4=[select name,recordtypeid,Region_Country__c,hq__c,Commercial_Account_Name__c,Commercial_ID__c,Country_Picklist__c,GEO__c,Sales_Area__c,Sales_Region__c,Segment__c from account where id=: a4.id];
        
        list<account> acclsdt=new list<account>();
        acclsdt.add(a);
        acclsdt.add(a1);
        acclsdt.add(a3);
        list<account> acclsdt1=new list<account>();
        acclsdt1.add(a1);
        acclsdt1.add(a2);
        acclsdt1.add(a4);
        
        pp_calculated_certification__x pp=new pp_calculated_certification__x(account_id__c=a.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Sales');
        pp_calculated_certification__x pp0=new pp_calculated_certification__x(account_id__c=a.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Sales');
       // pp_calculated_certification__x pp1=new pp_calculated_certification__x(account_id__c=a.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Sales');
        pp_calculated_certification__x pp2=new pp_calculated_certification__x(account_id__c=a1.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Pre-Sales');
        pp_calculated_certification__x pp3=new pp_calculated_certification__x(account_id__c=a1.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Implementation');
         pp_calculated_certification__x pp4=new pp_calculated_certification__x(account_id__c=a2.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Pre-Sales');
        pp_calculated_certification__x pp5=new pp_calculated_certification__x(account_id__c=a2.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Implementation');
        pp_calculated_certification__x pp6=new pp_calculated_certification__x(account_id__c=a2.id,badge__c='Proven Professional',product_name__c='API Gateway',resource_type__c='Sales');
        pp_calculated_certification__x pp7=new pp_calculated_certification__x(account_id__c=a3.id,badge__c='Certified Professional',product_name__c='API Gateway',resource_type__c='Sales');
        pp_calculated_certification__x pp8=new pp_calculated_certification__x(account_id__c=a3.id,badge__c='Certified Professional',product_name__c='API Gateway',resource_type__c='Implementation');
        pp_calculated_certification__x pp9=new pp_calculated_certification__x(account_id__c=a4.id,badge__c='Certified Professional',product_name__c='API Gateway',resource_type__c='Implementation');
 
        Database.insertAsync(pp); 
		
       // String loc=database.getAsyncLocator(pp);
       // pp=Database.getAsyncSaveResult(loc); 
 		//pp=[select account_id__c,badge__c,product_name__c,resource_type__c  from pp_calculated_certification__x];
        //insert pp;
        list<pp_calculated_certification__x> jjlst=new list<pp_calculated_certification__x>();
        jjlst.add(pp);
        jjlst.add(pp0);
       // jjlst.add(pp1);
        jjlst.add(pp2);
        jjlst.add(pp3);
        jjlst.add(pp4);
        jjlst.add(pp5);
        jjlst.add(pp6);
        jjlst.add(pp7);
        jjlst.add(pp8);
        jjlst.add(pp9);
        
        map<lead,list<account>> inputmap=new map<lead,list<account>>();
        inputmap.put(ld,acclsdt);
        inputmap.put(ld1,acclsdt1);
        map<lead,list<account>> inputmap1=new map<lead,list<account>>();
        
        PLD_ProductCompetency pldpc=new PLD_ProductCompetency();
        pldpc.Productcompetencyscoring(inputmap);
        pldpc.setpplst(jjlst); 
        pldpc.Productcompetencyscoring(inputmap);
        pldpc.Productcompetencyscoring(inputmap1);
    }
}