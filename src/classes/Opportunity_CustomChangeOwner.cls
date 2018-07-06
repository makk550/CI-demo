public with sharing class Opportunity_CustomChangeOwner{

    List<Opportunity> selectedOpportunities;
    public Opportunity newOwner{get;set;}
    List<String> selectedIds = new List<String>();
    String viewId;
    String prefix;
    
    public Opportunity_CustomChangeOwner(ApexPages.StandardController controller) {
        Schema.DescribeSObjectResult result = Opportunity.sObjectType.getDescribe();
        prefix = result.getKeyPrefix();
        selectedIds = ApexPages.currentPage().getParameters().get('records').split(',');
        viewId = ApexPages.currentPage().getParameters().get('view');
        selectedOpportunities = [SELECT Id, OwnerId FROM opportunity WHERE Id IN: selectedIds];
        newOwner = new Opportunity();
    }

    public pageReference save(){
        
        for(Opportunity opp: selectedOpportunities){
            opp.OwnerId = newOwner.OwnerId;
        }
        
        try{
            update selectedOpportunities;
        }catch(System.DmlException e){
            if(e.getMessage().contains('INSUFFICIENT')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have insufficient privilege on at least one of the selected opportunities');
                ApexPages.addMessage(myMsg);
        }
            return null;
        }
        return (new PageReference('/' + prefix + '?fcf=' + viewId));
    }
    
    public pageReference cancel(){
        return (new PageReference('/' + prefix + '?fcf=' + viewId));
    }
    
    //test method
    @isTest(SeeAllData=true)
    public static void testMassOwnerChange(){
        Id recId = SystemIdUtility.getResellerDistRecordTypeId();
        account acc = new account(name = 'wells', recordtypeid = recId);
        insert acc;
        
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();

        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    

        Opportunity oppty = new Opportunity(AccountId=smbAcct.Id,Reseller__c=acc.Id,Name='test',StageName='Identification & Qualification',CloseDate = System.Today()+5);
        insert oppty;         
        ApexPages.currentPage().getParameters().put('view', '00B30000007guQf');
        ApexPages.currentPage().getParameters().put('records', oppty.Id);
        
        ApexPages.StandardController testPage = new ApexPages.StandardController(oppty);
        Opportunity_CustomChangeOwner ctrl = new Opportunity_CustomChangeOwner(testPage);        
        PageReference pageRef = new PageReference('Opportunity_CustomChangeOwner');
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ctrl.newOwner.OwnerId = Userinfo.getUserId();
        ctrl.save();
        ctrl.cancel();
        Test.stopTest();
     }   
}