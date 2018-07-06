@isTest
public class PDDHistoryController_Test{

    
    public static testMethod void testData(){
    
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers=true;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName(); 
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='Generic Support Account 1234we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        insert a;
       
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook inserted');
        
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
       
        
         Product_Material__c productMaterial = new Product_Material__c(
            Name='p123', 
            Product__c=prod.Id, 
            Material_Text__c='test material text',
            SAP_Product_Mapping__c = 'product mapping',
            Source_System__c = 'SAP',
            POC_Eligible__c = true
        );
        insert productMaterial;
        
        
        
        InstancePDD__c zInt = new InstancePDD__c();
          zInt.Name='Test Instance';
          zInt.Is_Deleted__c = false;
          zInt.Product_Detail__c='Test Product';
          zInt.Release_Version__c='1';
          zInt.Capacity_Used__c=100;
          zInt.Environment_Type__c='Testing';
          zInt.Software_Type__c='OnPremise';
          zInt.Account_ID__c =a.Id;
          zInt.Product_Material__c=productMaterial.id;
      
          Database.SaveResult sr1 =  Database.insert(ZInt); 
      
             PDD__c zPDD = new PDD__c();
             zPDD.name = 'Test';
             zPDD.Barriers_to_Adoption__c = 'Unknown';
             zPDD.Business_Alignment__c = 'Test';
             zPDD.Business_Impact__c = 'High';
             zPDD.Capacity_Used__c = 0;
            
             zPDD.Comments__c = 'High';
             zPDD.Competitive_Technology__c = 'No';
             zPDD.CSP_Candidate__c = 'Not Needed';
             zPDD.Production_Status__c = 'Unknown';
             zPDD.Renewal_Risk__c = 'Unknown';
             zPDD.Scale_of_Adoption__c = 'Unknown';
             zPDD.Upgrade_Planned__c = 'No';
             zPDD.Instance__c = sr1.getId();
             Database.SaveResult sr2 =  Database.insert(ZPDD);
             
           
             Database.SaveResult sr3 =  Database.update(ZPDD);
             
             PDD__History hist = new PDD__History();
             hist.ParentId =sr2.getId();
             //hist.Field='Release_Version__c';
             //hist.NewValue='8.7';
             insert hist;
             
             PDDHistoryController pddObj = new PDDHistoryController();
             pddObj.PDDIds = new List<String>();
             pddObj.PDDIds.add(sr2.getId());
             pddObj.getPDDHistory(pddObj.PDDIds);
             pddObj.showMore();
             PDDHistoryController.PDDHistory pddWrap =new PDDHistoryController.PDDHistory();
             pddWrap.getActionFormat();
             
              
             
              
    }
}