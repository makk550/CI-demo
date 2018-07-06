/**
    This class is controller class to Renewals_CustomChangeOwner page.
    Its functionality is to execute the custom chane owner functionality.
*/

public class Renewal_ActiveCon_ChangeFinanceOwner{
    List<Active_Contract__c> selectedContracts;
    public Active_Contract__c newOwner{get;set;}
    List<String> selectedIds = new List<String>();
    String viewId;
    String prefix;
    Boolean financeOwnerPageCall{get;set;}
    public Renewal_ActiveCon_ChangeFinanceOwner(ApexPages.StandardController controller) {
        Schema.DescribeSObjectResult result = Active_Contract__c.sObjectType.getDescribe();
        prefix = result.getKeyPrefix();
        if(ApexPages.currentPage().getParameters().get('records')!=null){
            selectedIds = ApexPages.currentPage().getParameters().get('records').split(',');
            selectedContracts = [SELECT Id, Finance_Owner__c,account__c FROM Active_Contract__c WHERE account__c IN: selectedIds];
            financeOwnerPageCall = true;
        }    
        else if (ApexPages.currentPage().getParameters().get('values')!=null){    
            selectedIds = ApexPages.currentPage().getParameters().get('values').split(',');
            selectedContracts = [SELECT Id, Finance_Owner__c,account__c FROM Active_Contract__c WHERE id IN: selectedIds];
            financeOwnerPageCall = false;
        }    
        System.debug('selectedIds## '+selectedIds);
        viewId = ApexPages.currentPage().getParameters().get('view');        
        newOwner =[Select id, Finance_Owner__c from Active_Contract__c limit 1]; //new Active_Contract__c();
        newOwner.Finance_Owner__c  = null;
    }
                
    public PageReference savenew(){
        //Set<Id> accIds = new Set<Id>();
        List<account> accList = new List<Account>();
        for(Active_Contract__c ren: selectedContracts){
            //accIds.add(ren.account__c);
            ren.Finance_Owner__c = newOwner.Finance_Owner__c;
        }
        if(financeOwnerPageCall){
            for(String id: selectedIds){
                Account ac = new Account(
                id= id,
                Finance_Owner__c = newOwner.Finance_Owner__c
                );
             accList.add(ac);
            }
        }
        
        try{
            if(accList.size()>0 && financeOwnerPageCall)
                update accList;
            if(selectedContracts.size()>0)    
                update selectedContracts;
        }catch(System.DmlException e){
            if((e.getMessage().contains('INSUFFICIENT')) || (e.getMessage().contains('TRANSFER_REQUIRES_READ'))){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have insufficient privilege on at least one of the selected contracts');
                ApexPages.addMessage(myMsg);
            }
            return null;
        }
        if(viewId == null)
             return (new PageReference('/apex/Ren_viewAccount?succes=true'));
        else     
            return (new PageReference('/' + prefix + '?fcf=' + viewId));
    }
    
    public PageReference cancel(){
        if(viewId == null)
             return (new PageReference('/apex/Ren_viewAccount?succes=true'));
        else     
            return (new PageReference('/' + prefix + '?fcf=' + viewId));    
    } 
    
    //test method
    public static testMethod void testMassOwnerChange(){
                
        Account ac = new Account();
            ac.Name = 'Test Account';
            ac.BillingState = 'NY';   
            ac.Customer_Category__c = 'Enterprise';
            //ac.Account_Status__c = 'Approved';        
            ac.GEO__c='NA';
            
            ac.Enterprise_ID__c = '1234te';
            
            
            ac.Enterprise_Account_Name__c = 'rdName';
            ac.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();
            ac.Commercial_ID__c = 'asdf';
            insert ac;

        Active_Contract__c ren = new Active_Contract__c(Name='test',Account__c=ac.id );
        insert ren;         
        ApexPages.currentPage().getParameters().put('view', '00BQ0000000QVqI');
        ApexPages.currentPage().getParameters().put('records', '0013000000ngAlq');
        
        ApexPages.StandardController testPage = new ApexPages.StandardController(ren);
        Renewals_CustomChangeOwner ctrl = new Renewals_CustomChangeOwner(testPage);        
        PageReference pageRef = new PageReference('Renewals_CustomChangeOwner');
        Test.setCurrentPage(pageRef);
        
        

        Test.startTest();
        ctrl.newOwner.OwnerId = Userinfo.getUserId();
        ctrl.save();
        ctrl.cancel();
        Active_Contract__c ren1 = new Active_Contract__c(Name='test1',Account__c=ac.id );
        insert ren1;         
        ApexPages.currentPage().getParameters().put('view', '00BQ0000000QVqI');
        ApexPages.currentPage().getParameters().put('records', '0013000000ngAlq');
     ApexPages.StandardController testPage1 = new ApexPages.StandardController(ren1);
        
     Renewal_ActiveCon_ChangeFinanceOwner  obj = new Renewal_ActiveCon_ChangeFinanceOwner(testPage1);
   
    
        obj.savenew();
        obj.cancel();
        ApexPages.currentPage().getParameters().put('values',ren1.Id);
        ApexPages.currentPage().getParameters().put('records',null);
        Renewal_ActiveCon_ChangeFinanceOwner  obj1 = new Renewal_ActiveCon_ChangeFinanceOwner(testPage1);
   
        Test.stopTest();
        
  }
  }