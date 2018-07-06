/*
	Author : Asit Porwal
	Company : Deloitte
	Description : Extension for LeadViewOverride Page.
	UserStory : US480729
*/

public class LeadViewOverride_extension {
    public Lead leadRec {get;set;}
    public Id LeadId {get;set;}
    public String selectedStatusReason{get;set;}
    public boolean partnerProfile{get;set;}
    // fedresults role -amili01
    public boolean fedResultsRole{get;set;}
    Public boolean PartnerLeadProcess{get;set;}
    
    public boolean displayPopup {get; set;} 
    public boolean ispowerpartner {get; set;}    
    
    public LeadViewOverride_extension(ApexPages.StandardController stdController){
        displayPopup = false;     
        PartnerLeadProcess=false;
        LeadId =  ApexPages.currentPage().getParameters().get('id');
        if(LeadId !=null){
            
            leadRec = [SELECT Id, Status,AcceptReject__c,Rejection_Reason__c, Partnerleadprocessed__c FROM Lead WHERE Id =: LeadId limit 1];
            System.debug('---lead processed ---'+leadRec.Partnerleadprocessed__c);
            if(leadRec.Partnerleadprocessed__c == true){
                PartnerLeadProcess=true;
            }
            partnerProfile = false;
            fedResultsRole=false;
            chkPartnerProfile();
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No Lead Found'));
        }
        
        
    }
    
       
    public void chkPartnerProfile(){
        List<User> pList = [SELECT Id,userrole.id FROM User WHERE Is_Partner_User__c = true and IsActive = true];
        if(pList.size()>0 && pList !=null){
            for(User p : pList){
                if(p.Id == userInfo.getUserId()){
                    partnerProfile = true;  
                    if(partnerProfile){
                    	if( p.userrole.id == '00E30000001ZPQ3'){
                        fedResultsRole=true;
                    	}
                    }
                    break;
                }
            }    
        }
        
        System.debug('partnerProfile ' + partnerProfile);
    }
    
    public PageReference covertIndirect(){
        PageReference url = new PageReference('/apex/Convert_Lead?id=' + LeadId);
        if(partnerProfile){            
            url.setRedirect(true);
            return url;
        }
        else{
            return null;
        }
    }
    
    public PageReference Marketing_Nurture(){
        //displayPopup = false;
        System.debug('leadRec'+leadRec);
        String reqStatus = 'Marketing Nurture';
        try{
            if(leadRec.Partnerleadprocessed__c){
                List<Group> queue = [SELECT Id FROM Group WHERE Name = :System.Label.Marketing_Nurture_Queue AND Type = 'Queue' limit 1];
                if(queue !=null && queue.size()>0){
                    leadRec.OwnerId = queue[0].Id;            
                    leadRec.Status = reqStatus;            
                    update leadRec;
                    PageReference LeadPage = new  PageReference('/partner/00Q/o');
                    
                    LeadPage.setRedirect(true);
                    
                    return LeadPage;    
                }
                else{
                    return null;
                }            
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Lead is not processed by Partner'));
                
            }
            return null;    
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
            ApexPages.addMessage(msg);
            return null;
        }
        
    }
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
}