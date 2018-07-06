public without sharing class OpportunityDeleteOverride {

private final Opportunity dealRegOppT;
public opportunity dealregopp{get;set;}
     public OpportunityDeleteOverride(){}
    public OpportunityDeleteOverride(ApexPages.StandardController controller) {
            this.dealRegOppT = (Opportunity)controller.getrecord();
            this.dealRegOpp = this.dealRegOppT;
            system.debug('dealRegOpp '+dealRegOpp );
            dealRegOpp = [select Deal_Registration_Status__c,New_Opportunity_Status__c,isdeletePartner__c from opportunity where id=:dealRegOpp .id];
            system.debug('after query dealRegOpp '+dealRegOpp );
            
    
    }
    
    public pageReference deleteThisOpp(){
            
            pagereference redirect = new PageReference('/006/o'); 
            redirect.setRedirect(true);
            
            try{
            if(dealRegOpp.Deal_Registration_Status__c == null ||dealRegOpp.Deal_Registration_Status__c == '' || dealRegOpp.Deal_Registration_Status__c == 'New' || dealRegOpp.Deal_Registration_Status__c == 'Deal Rejected'
              || dealRegOpp.New_Opportunity_Status__c == 'New' || dealRegOpp.New_Opportunity_Status__c == 'New Opportunity Rejected'){
                  //delete dealRegOpp;
                  dealRegOpp.isdeletePartner__c = true;
                  system.debug('deleted before:-) dealRegOpp '+dealRegOpp);
                  update dealRegOpp ;
                  system.debug('deleted :-) dealRegOpp '+dealRegOpp);
              }
              
              system.debug('Did not delete :-(');
            }
            catch(exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
            }
            /*
            try{
            if(dealRegOpp.Deal_Registration_Status__c == 'New' || dealRegOpp.Deal_Registration_Status__c == 'Deal Rejected'){
                  delete dealRegOpp;
                  system.debug('deleted :-)');
              }
              
              system.debug('Did not delete :-(');
            }
            catch(exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
            }*/
            return redirect;
    
    }
    
    public void deleteOpp(ID oppid){
    
    opportunity opp= [select id from opportunity where id=: oppid];
    system.debug('before delete');
    try{
     delete opp;
     }
    catch(exception e){
     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
    }
    
    }


}