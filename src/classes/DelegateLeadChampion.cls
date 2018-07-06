public class DelegateLeadChampion {

    public  DelegateLeadChampion__c DlcRecord{get;set;}
    //public id usrid{get;set;}
    public id Accid{get;set;}
      
    User u=new User();
      
   public DelegateLeadChampion(ApexPages.StandardController controller) {
       DlcRecord=New DelegateLeadChampion__c();
	//Leadid=ApexPages.CurrentPage().getParameters().get('id');
       system.debug(''+UserInfo.getUserId());
         system.debug('StartDate__c--'+DlcRecord.StartDate__c+'EndDate__c'+DlcRecord.EndDate__c);
        //usrid=UserInfo.getUserId();
    u = [select Id, username,Related_Partner_Account__c from User where Id = :UserInfo.getUserId()];
       if(u.Related_Partner_Account__c!=Null){
           Accid=id.valueof(u.Related_Partner_Account__c);
          
       }
       
       system.debug('--Accid--'+Accid);
      // DlcRecord.DelegateLeadChampion__c=UserInfo.getUserId();UseDelegateLeadChampion__c
      // DlcRecord.StartDate__c=system.today();
       system.debug('StartDate__c--'+DlcRecord.StartDate__c+'EndDate__c'+DlcRecord.EndDate__c);
    }  
  
    
    
    public PageReference saveDR() 
    {
    
       
            system.debug('StartDate__c--'+DlcRecord.StartDate__c+'EndDate__c'+DlcRecord.EndDate__c);
            if(DlcRecord.StartDate__c<system.today() || DlcRecord.EndDate__c < system.today() ){
                if(DlcRecord.StartDate__c<system.today()){
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Start Date: Start date should be greater than or Equal to Today.');
                   ApexPages.addMessage(myMsg); 
                }
                 else if( DlcRecord.EndDate__c < system.today()){
                    ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Appropriate End date ! ');
                      ApexPages.addMessage(myMsg2); 
                }
                    
                
                 return null;
            }
            if(Accid!=null){
               
               DlcRecord.PartnerAccount__c=Accid; 
                DlcRecord.UseDelegateLeadChampion__c=True;
                insert DlcRecord;
               
                //PageReference pageRef = new PageReference('/apex/LeadViewOverride?id='+Leadid);
                //pageRef.setRedirect(true);
        		//return pageRef;
        	  return new PageReference('/'+this.DlcRecord.Id);

            }
          
        
        
       
        return null;
    }
 

}