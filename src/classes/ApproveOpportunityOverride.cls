public without sharing class ApproveOpportunityOverride {
    
private final Opportunity dealRegOppT;
public opportunity dealregopp{get;set;}
    
    public ApproveOpportunityOverride(){}
    
  public ApproveOpportunityOverride(ApexPages.StandardController controller) {
    this.dealRegOppT = (Opportunity)controller.getrecord();
    this.dealRegOpp = this.dealRegOppT;
    system.debug('dealRegOpp '+dealRegOpp );
    dealRegOpp = [select MinMaxError__c,id,name,Deal_Registration_Status__c,New_Opportunity_Status__c,isClosedDateFireDealReg__c from opportunity where id=:dealRegOpp.id];
    system.debug('after query dealRegOpp '+dealRegOpp );            
  }
    
    public pageReference ApproveOpp(){        
        pagereference redirect = new PageReference('/006/o'); 
        pagereference redirect1 =new PageReference('/'+dealRegOpp.id);
        redirect.setRedirect(true);        
        if(dealRegOpp.Deal_Registration_Status__c=='Sale Approved' || dealRegOpp.New_Opportunity_Status__c == 'New Opportunity Approved')
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to Submit for Approval, This record does not meet the entry criteria or initial submitters of any active approval processes. Please contact your administrator for assistance.');
           ApexPages.addMessage(myMsg); 
            return null;
        }
        else{
            
          try{
            if(!dealRegOpp.MinMaxError__c && !dealRegOpp.isClosedDateFireDealReg__c){
          Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(dealRegOpp.Id);
                system.debug('approval process'+req );
                Approval.ProcessResult result = Approval.process(req);
                system.debug('Approve Yes'+dealRegOpp );            
            }
            else{
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to Submit for Approval, This record does not meet the entry criteria or initial submitters of any active approval processes. Please contact your administrator for assistance.');
                 ApexPages.addMessage(myMsg);
              System.debug('MinMaxError__c is set to true.Cant submit');
            }          
          }
          catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
          }
              return redirect1;
        }
    }
    
    public pageReference ReturntoOpp(){  
         pagereference redirect1 =new PageReference('/'+dealRegOpp.id);
         return redirect1;
    }
    
}