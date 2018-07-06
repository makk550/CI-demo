public with sharing class Opportunity_CustomChangeCPMOwner {
    
    List<Opportunity> selectedOpportunities;
    public Opportunity newCPMOwner{get;set;}
    List<String> selectedIds = new List<String>();
    String viewId;
    String prefix;
    
    public Opportunity_CustomChangeCPMOwner(ApexPages.StandardController controller) {
        Schema.DescribeSObjectResult result = Opportunity.sObjectType.getDescribe();
        prefix = result.getKeyPrefix();
        selectedIds = ApexPages.currentPage().getParameters().get('records').split(',');
        viewId = ApexPages.currentPage().getParameters().get('view');
        if(selectedIds.size()>0)
        selectedOpportunities = [SELECT Id, CPM_Owner__c, RecordTypeId FROM opportunity WHERE Id IN: selectedIds];
        newCPMOwner = new Opportunity();
    }

    public pageReference save(){
        if(selectedOpportunities!=null)
        {
        
                 for(Opportunity opp: selectedOpportunities){
                                         
                    //01230000000cohDAAQ
                    Id recordid = RecordTypes_Setting__c.getvalues('Deal Registration').RecordType_Id__c;
                     System.debug('recordid'+recordid);
                     System.debug('---opp.RecordTypeId---' + opp.RecordTypeId);
                     if(opp.RecordTypeId==recordid )
                    { ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot select Deal Reg opportunities for CPM Owner change');
                     ApexPages.addMessage(myMsg);return null;}
                   // opp.addError('You cannot select Deal Reg opportunities for CPM Owner change');
                    else
                     opp.CPM_Owner__c = newCPMOwner.CPM_Owner__c;
                     
                                     
                    }
        
                try{    
                        
                            if(selectedOpportunities.size()>0)
                            update selectedOpportunities;
                         
                }catch(System.DmlException e){
                    if(e.getMessage().contains('INSUFFICIENT'))
                    {ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have insufficient privilege on at least one of the selected opportunities');
                                                                ApexPages.addMessage(myMsg);}return null;}
                return (new PageReference('/' + prefix + '?fcf=' + viewId));
        }
       
            return null;
    }
    
    public pageReference cancel(){
        return (new PageReference('/' + prefix + '?fcf=' + viewId));
    }
    
    

}