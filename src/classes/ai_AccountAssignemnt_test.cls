@istest
public class ai_AccountAssignemnt_test {

    @istest
     static void testtrailupdate()
     {
        Trial_Request__c pocreq = createTrialRequest();
         pocreq.Request_Status__c ='Cancelled';
         update pocreq;
         
     }
    
     // test helpers
    static Trial_Request__c createTrialRequest(){
        Account createacc = CC_TestUtils.buildAccount('This test account');
        insert createacc;

        SystemIdUtility.skipOpportunityTriggers = true;
        Opportunity opp = new Opportunity(
            Name = 'test opp', 
            StageName = '10% - Discovery & Assessment', 
            AccountId = createacc.Id, 
            CloseDate = date.today()
        );
        insert opp;
		 Site_Association__c sc = new Site_Association__c(
            SAP_Site_ID__c='1212',
            Name ='ABC',
            Country_Picklist__c ='IND'
        );        
        insert sc;
        Trial_Request__c trial =  new Trial_Request__c(
            Request_Status__c = 'New',
            Account_Name__c = createacc.Id,
            Opp_Name__c = opp.Id,
            Site_Association__c = SC.iD,
            OwnerId=UserInfo.getUserId()
        );
        insert trial;
      
  
        Product2 product= new Product2(Name='Prd1',SKU__c = 'CAAAVM1600W00C6', Family='Product',Market_Focus_Area__c='Test1',IsActive=true);
        insert product;
      
  
        PriceBookEntry pbe = new PriceBookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.id,
            UnitPrice = 222,
            IsActive = true
        );
        insert pbe;
   		 Product_Material__c productMaterial = new Product_Material__c(
            Name='p123', 
            Product__c=product.Id, 
            Material_Text__c='test material text',
            SAP_Product_Mapping__c = 'product mapping',
            Source_System__c = 'SAP',
            POC_Eligible__c = true
        );
        insert productMaterial;
        
        pocMaterial__c pocMaterial = new pocMaterial__c(
            //quantity__c = 2,
            POC_Request__c = trial.Id,
            Product__c = product.Id,
            Product_Material__c = productMaterial.Id
        );
        insert pocMaterial;
     
       // select SAP_Site_ID__c,Name,Street__c,City__c,Region__c,Country_Picklist__c from Site_Association__c where Id= :poc.Site_Association__c
        return trial;
    }
}