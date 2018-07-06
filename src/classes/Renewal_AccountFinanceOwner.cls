public class Renewal_AccountFinanceOwner{

    List<Active_Contract__c> selectedRenewals;
    public Active_Contract__c newOwner{get;set;}
    List<String> selectedIds = new List<String>();
    String viewId;
    String prefix;
    
   public Renewal_AccountFinanceOwner(ApexPages.StandardController controller) {
        Schema.DescribeSObjectResult result = Account.sObjectType.getDescribe();
        prefix = result.getKeyPrefix();
        selectedIds = ApexPages.currentPage().getParameters().get('records').split(',');
        viewId = ApexPages.currentPage().getParameters().get('view');
        //selectedRenewals = [SELECT Id, OwnerId FROM Active_Contract__c WHERE Id IN: selectedIds];
        newOwner = new Active_Contract__c();
    }
                
    public PageReference save(){
        List<active_contract__c> actList = new List<active_contract__c>();
        for(Active_Contract__c ren: [select Finance_Owner__c from Active_Contract__c
                                     where account__c in:selectedIds] ){
            ren.Finance_Owner__c = newOwner.Finance_Owner__c;
            actList.add(ren);
        }
        
        try{
            update actList;
        }catch(System.DmlException e){
            if((e.getMessage().contains('INSUFFICIENT')) || (e.getMessage().contains('TRANSFER_REQUIRES_READ'))){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have insufficient privilege on at least one of the selected contracts');
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
        
        Active_Contract__c ren = new Active_Contract__c(Name='test');
        insert ren;         
        ApexPages.currentPage().getParameters().put('view', '00BQ0000000QVqI');
        ApexPages.currentPage().getParameters().put('records', ren.Id);
        Test.startTest();
        ApexPages.StandardController testPage = new ApexPages.StandardController(ren);
        Renewal_AccountFinanceOwner ctrl = new Renewal_AccountFinanceOwner(testPage);        
        PageReference pageRef = new PageReference('Ren_viewAccount');
        Test.setCurrentPage(pageRef);
        
        
        ctrl.newOwner.Finance_Owner__c= Userinfo.getUserId();
        ctrl.save();
        ctrl.cancel();
        Test.stopTest();
  }
  }