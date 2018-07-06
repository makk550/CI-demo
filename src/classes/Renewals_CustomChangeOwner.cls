/**
    This class is controller class to Renewals_CustomChangeOwner page.
    Its functionality is to execute the custom chane owner functionality.
*/

public with sharing class Renewals_CustomChangeOwner{
    List<Renewal__c> selectedRenewals;
    public Renewal__c newOwner{get;set;}
    List<String> selectedIds = new List<String>();
    String viewId;
    String prefix;
    
    public Renewals_CustomChangeOwner(ApexPages.StandardController controller) {
        Schema.DescribeSObjectResult result = Renewal__c.sObjectType.getDescribe();
        prefix = result.getKeyPrefix();
        selectedIds = ApexPages.currentPage().getParameters().get('records').split(',');
        viewId = ApexPages.currentPage().getParameters().get('view');
        selectedRenewals = [SELECT Id, OwnerId FROM Renewal__c WHERE Id IN: selectedIds];
        newOwner = new Renewal__c();
    }
                
    public PageReference save(){
        
        for(Renewal__c ren: selectedRenewals){
            ren.OwnerId = newOwner.OwnerId;
        }
        
        try{
            update selectedRenewals;
        }catch(System.DmlException e){
            if(e.getMessage().contains('INSUFFICIENT')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have insufficient privilege on at least one of the selected renewals');
                ApexPages.addMessage(myMsg);
            }
            return null;
        }
        return (new PageReference('/' + prefix + '?fcf=' + viewId));
    }
    
    public PageReference cancel(){
        return (new PageReference('/' + prefix + '?fcf=' + viewId));    
    } 
    
    //test method
    public static testMethod void testMassOwnerChange(){
        
        Renewal__c ren = new Renewal__c(Name='test');
        insert ren;         
        ApexPages.currentPage().getParameters().put('view', '00BQ0000000QVqI');
        ApexPages.currentPage().getParameters().put('records', ren.Id);
        
        ApexPages.StandardController testPage = new ApexPages.StandardController(ren);
        Renewals_CustomChangeOwner ctrl = new Renewals_CustomChangeOwner(testPage);        
        PageReference pageRef = new PageReference('Renewals_CustomChangeOwner');
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ctrl.newOwner.OwnerId = Userinfo.getUserId();
        ctrl.save();
        ctrl.cancel();
        Test.stopTest();
     }   
}