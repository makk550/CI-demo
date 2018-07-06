public class JustInTimeController {
    public boolean ShowErrorMessage {get; set;}  
    public string errorMessage{get; set;}
    public PageReference init() { 
        //inititialize class variables
        ShowErrorMessage=false;     
        errorMessage=null; 
        
        //get the line item  id from the query string           
        string lineItemId=ApexPages.currentPage().getParameters().get('LineItemId'); 
        
        //check if the user has supplied a line item id 
        if(lineItemId==null)
        {
            errorMessage='No Opportunity Line Item Information Found!';
            ShowErrorMessage=true;
        }        
        //get line item from database 
        else
        {
            List<OpportunityLineItem> lineItems=[Select Id,Opportunity.StageName,OpportunityId, PriceBookEntry.Product2.Solution_Sets__c 
            from OpportunityLineItem where Id=:lineItemId];
            if(lineItems.size()>0)
            {
                if(lineItems[0].PriceBookEntry.Product2.Solution_Sets__c!=null)
                {
                    System.debug('Stage: '+lineItems[0].Opportunity.StageName);
                    System.debug('product group: '+lineItems[0].PriceBookEntry.Product2.Solution_Sets__c);
                    List<Product_Milestone_Reference_Map__c> links=[Select Id,Milestone__c,Product_Group_Name__c,Reference_Link__c 
                    from Product_Milestone_Reference_Map__c
                    where Is_Active__c=true and Reference_Link__c!=null and Milestone__c =:lineItems[0].Opportunity.StageName
                    and Product_Group_Name__c =:lineItems[0].PriceBookEntry.Product2.Solution_Sets__c];
                    if(links.size()>0)
                    {
                        PageReference referencePage = new PageReference('https://'+links[0].Reference_Link__c);
                        referencePage.setRedirect(true);
                        return referencePage;
                    }
                    else 
                    {
                        errorMessage='No Reference Material available!';
                        ShowErrorMessage=true;
                    }
                }
                else
                {
                    errorMessage='Opportunity Line Item does not have a solution set!';
                    ShowErrorMessage=true;
                }
            }
            else
            {
                errorMessage='Invalid Opportunity Id Supplied!';
                ShowErrorMessage=true;
            }
        }
        return null;
    }
    //**************************** test methods start here **************************************//
    @isTest(SeeAllData=true)
    static void testJustInTime() { 
        SystemIdUtility.skipOpportunityTriggers = true;
SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        //get a sample product with NCV Driver from the system
        List<PriceBookEntry> prList=[select Id,Product2.Solution_Sets__c,Product2Id  from PriceBookEntry 
        where IsActive=true and Product2.IsActive=true and Product2.Solution_Sets__c!=null  and CurrencyIsoCode='USD' Limit 1];
        
        //create product milestone reference
        Product_Milestone_Reference_Map__c pmMap=new Product_Milestone_Reference_Map__c();
        pmMap.Is_Active__c=true;
        pmMap.Milestone__c=Label.Opp_Stage_10_Percent;
        pmMap.Product_Group_Name__c=prList[0].Product2.Solution_Sets__c;  
        pmMap.Reference_Link__c='yahoo.com';
        insert pmMap;
        
        //create a reseller account
        Account reseller=new Account();
        reseller.Name='Test Reseller';
        reseller.RecordTypeId=SystemIdUtility.getResellerDistRecordTypeId();
        reseller.Customer_Category__c='Reseller';
        reseller.Geo__c='NA';
        reseller.Program_Level__c='Platinum (ISBU)';
        reseller.Reseller_Type__c='ISBU';
        reseller.Account_Status__c='Approved';
        reseller.Country_Picklist__c='US - UNITED STATES';
        reseller.Reseller_Disti_Regional_ID__c='test-XXXX';
        reseller.Reseller_Distributor_Name__c='Test Reseller';
        reseller.BillingState='TX';
        insert reseller;
        
        //create commericial account
        Account comm=new Account();
        comm.Name='Test Comm';
        comm.RecordTypeId=SystemIdUtility.getSMBAcctRecordTypeId();
        comm.Customer_Category__c='Commercial';
        comm.Aggregate_Account__c='No';
        comm.Geo__c='NA';       
        comm.Account_Status__c='Approved';
        comm.Country_Picklist__c='US - UNITED STATES';
        comm.Global_ID__c='test-YYY';
        comm.Global_Name__c='Test Comm';
        comm.Commercial_ID__c='test-ZZZ';
        comm.Commercial_Account_Name__c='Test Comm';
        comm.BillingState='TX';
        insert comm;
        
        RecordType rt = [select id from RecordType where sObjectType = 'Opportunity' and name = 'New Opportunity' limit 1];
        
        RecordType rt1 = [select id from RecordType where sObjectType = 'Account' and name = 'SMB' limit 1];
        
        //create a reseller account
        Account smb_acc=new Account();
        smb_acc.Name='Test Reseller';
        smb_acc.RecordTypeId=rt1.Id;
        smb_acc.Customer_Category__c='Reseller';
        smb_acc.Geo__c='NA';
        smb_acc.Program_Level__c='Platinum (ISBU)';
        smb_acc.Reseller_Type__c='ISBU';
        smb_acc.Account_Status__c='Approved';
        smb_acc.Country_Picklist__c='US - UNITED STATES';
        smb_acc.Reseller_Disti_Regional_ID__c='test-XXXX';
        smb_acc.Reseller_Distributor_Name__c='Test Reseller';
        smb_acc.BillingState='TX';
        insert smb_acc;
        
        //create oppotunity
        Opportunity opp=new Opportunity();
        opp.AccountId=smb_acc.Id;
        opp.Ent_Comm_Account__c=comm.Id;
        opp.RecordTypeId=rt.id;          
        opp.Name='Test Opp';
        opp.CurrencyIsoCode='USD';
        Opp.CloseDate=Date.today();
        Opp.StageName=Label.Opp_Stage_10_Percent;      
        Opp.Lead_to_Oppty__c=true;
        insert Opp;
        
        //create Opportunity Line Item
        OpportunityLineItem li=new OpportunityLineItem();
        li.OpportunityId=opp.Id;
        li.Quantity=1;
        li.PriceBookEntryId=prList[0].Id;
        insert li;
        
        //initialize controller
        JustInTimeController jitController=new JustInTimeController();
        
        //test a page with out parameters       
        PageReference page = new PageReference('/apex/JustInTime');
        Test.setCurrentPage(page);
        jitController.init();
        
        //test a page with invalid parameters
        PageReference page2 = new PageReference('/apex/JustInTime?lineItemId=invalid');
        Test.setCurrentPage(page2);
        jitController.init();
        
        
        //test a page with line item id parameter
        PageReference page3 = new PageReference('/apex/JustInTime?lineItemId='+li.Id);
        Test.setCurrentPage(page3);
        System.assert(jitController.init()!=null);  
        
        //clear the solution set from the product       
        Product2 product=new Product2(Id=prList[0].Product2Id); 
        product.Solution_Sets__c=null;
        update product;
        
        //test a page with line item with no Ncv Driver
        PageReference page4 = new PageReference('/apex/JustInTime?lineItemId='+li.Id);
        Test.setCurrentPage(page4);
        jitController.init();   
        
    }   
}