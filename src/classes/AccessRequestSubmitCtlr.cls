/*
AccessRequestSubmitCtlr - is the controller for AccessRequestSubmit VF and AccessRequestType VF
Used to render the correct section, based on type selected.
Based on the type selected, it saves the AR and auto submits it for approval.
Added by BAJPI01 on 26/6/2016
*/

public class AccessRequestSubmitCtlr {
    
    Public boolean inEdit{get;set;}
    //Public boolean isSDticket{get;set;}
    Public boolean isCreateSDticket{get;set;}
    public string approverComment{get;set;}
    public boolean createAR{get;set;} 		//boolean variable set to true when AR type = Create Access Request
    public boolean mirrorUser{get;set;} 	//boolean variable set to true when AR type = Mirror a User
    public boolean createSD{get;set;} 		//boolean variable set to true when AR type = Create Service Desk Ticket
    Private final Access_Request__c accReqT;
    public Access_Request__c accReq{get;set;}
    ApexPages.StandardController stdCtrl;
    public AccessRequestSubmitCtlr(ApexPages.StandardController stdController) {
        
        this.accReqT = (Access_Request__c)stdController.getRecord();
        this.accReq = this.accReqT;
        stdCtrl = stdController;
        //pURL = new processURL(accReq.Access_for_URL__c);
        //ShowButtons = FALSE;
        inEdit = true;
        isCreateSDticket = false;
        accReq.Request_For__c = Userinfo.getuserId();	//default to loggedin user.
        accReq.Status__c = 'Draft'; //status is set to draft by default as AR is auto submitted for approval
    }

    /*
    public PageReference onCheckSD(){
        //isSDticket = true;
        return null;
        //save();
        
    }
    
    public PageReference onUnCheckSD(){
        isSDticket = false;
        return null;
        //save();
        
    }
*/    
    /*
     This method Redirects to access request tab.
     */
    
    public PageReference toRequestPage(){
        
        system.debug('Inside redirect');
        return new PageReference('/'+Label.Access_Request_Redirect); //the label stores the access request tab key.
    }
    
    
    /*
     This method is used to create an AR where the type is Mirror a User. No URL is populated in this.
	The method saves the AR, auto submits it for approval. Auto submission happens in trigger, after insert.
     */ 
    
    public PageReference SaveSubmitMirror() {
        
           		//accReq.Access_for_URL__c = 'na';
                //stdCtrl.save();
                system.debug('accReq>'+accReq);
                try{
                insert accReq;
                return new PageReference('/'+Label.Access_Request_Redirect);
                }
                catch(Exception e)
                {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
                 return null;
                }
            
            
       
        
    }
    


    /*
     This method is used to create an AR where the type is Create a Mirror. URL & Mirror, both are populated in this.
	The method saves the AR, auto submits it for approval. Auto submission happens in trigger, after insert.
     */ 
    
     public PageReference SaveSubmitAR() {
       
            
            
                //stdCtrl.save();
                system.debug('accReq>'+accReq);
                try{
                insert accReq;
                return new PageReference('/'+Label.Access_Request_Redirect);
                }
                catch(Exception e)
                {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
                 return null;
                }
            
            
        
        
    }
    
        /*
     This method is used to create an AR where the type is Create A SD Ticket. No URL nor mirroe is populated in this.
	The method saves the AR, auto submits it for approval. Auto submission happens in trigger, after insert.
     */ 

    
        public PageReference saveAR(){
        system.debug('accReq>...'+accReq);
        //system.debug('isSDticket>>>'+isSDticket);
        if(accReq.SD_Ticket__c == null) //if user provides a SD ticket number, they are not allowed to create a SD ticket, otherwise they are.
        {
               try{
                insert accReq; 
                accReq = (Access_Request__c)stdCtrl.getRecord();
                system.debug('accReq>'+accReq);
                //isCreateSDticket = true;
            }   
            catch(Exception e){
                system.debug('Exception'+e);
            }
            //isCreateSDticket=true;
            return toRequestPage();
      
        }
        else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You cannot create a service desk ticket as you already have one');
            ApexPages.addMessage(myMsg);
        
        return null;
        }
    }
    
        /*
     This method is used to create an SD ticket.
	Ticket is created and the AR created in the method SaveAR, is updated with the ticket number.
     */ 

    /*
    public PageReference createSDTicket(){   
        system.debug('approverComment'+approverComment);
        if(approverComment =='' || approverComment ==null )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'SD Comments is required.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        else{
            String SDTicket;
            Access_Request__c accReq1 = new Access_Request__c();
            accReq1 = [select Description__c,Request_For__r.name,Request_For__r.Email,Request_For__r.Phone,name from Access_Request__c where id =:accReq.id ];
            system.debug('In createSDTicket accReq'+accReq1);
        	User u = [select Id, phone from User where Id = :UserInfo.getUserId()];
            string details;
            if(accReq1.Description__c != null)
             details = accReq1.Description__c + ' ' + approverComment;
            else details = approverComment; 
            system.debug('details'+details);
        	system.debug('user phone'+u.Phone);
        
        	//Create the ticket.
        	//if(!Test.isRunningTest())
            SDTicket =  NSDIntegrator.createIncident('386', '746', details, accReq1.Request_For__r.name, UserInfo.getName(), 'SFDC Access Request',accReq1.Request_For__r.Email,accReq1.Request_For__r.Phone,accReq1.Id,accReq1.Name, UserInfo.getUserEmail(), u.Phone); 
            system.debug('to accessRequest Again SDTicket>'+SDTicket);
            //ApproveAccessRequestFuture.requestorSDRequest(accReq1.Id,approverComment,SDTicket);
           	accReq1.Comments__c=approverComment;
        	accReq1.SD_Ticket__c = SDTicket;
        	accReq1.Source_of_SD_Ticket__c = 'End User';
        	
        	try{
                update accReq1; 
            }   
            catch(Exception e){
                system.debug('Exception'+e);
            }
            return toRequestPage();
                
    //} 
     
    }
    */
    
    /*
	This method sets the appropriate boolean variable to true depending on the type
	selected from AccessRequestType VF page.
	*/
    public PageReference ContinueAR(){
        
        if(accReq.Type__c=='Create Access Request'){
            createAR=true;
        }
        else if(accReq.Type__c=='Mirror a User'){
            mirrorUser=true;
        }
        else{
            createSD=true;
        }
        
            
            return new PageReference('/apex/AccessRequestSubmit');
       
        
    }
    
  
}