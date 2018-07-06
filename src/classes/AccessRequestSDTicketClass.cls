global class AccessRequestSDTicketClass {
    
    public static List<String> reqIdSet;
    
	@Future(callout=true)
    static webservice void createSDTicket(String reqId){
        	String SDTicket;
            Access_Request__c accReq1 = new Access_Request__c();
            accReq1 = [select Description__c,Request_For__r.name,Request_For__r.Email,Request_For__r.Phone,name from Access_Request__c where id =:reqId ];
            system.debug('In createSDTicket accReq'+accReq1);
        	User u = [select Id, phone from User where Id = :UserInfo.getUserId()];
            string details;
            //if(accReq1.Description__c != null)
            // details = accReq1.Description__c + ' ' + approverComment;
            details = accReq1.Description__c; 
            system.debug('details'+details);
        	system.debug('user phone'+u.Phone);
        
        	//Create the ticket.
        	//if(!Test.isRunningTest())
            SDTicket =  NSDIntegrator.createIncident('386', '746', details, accReq1.Request_For__r.name, UserInfo.getName(), 'SFDC Access Request',accReq1.Request_For__r.Email,accReq1.Request_For__r.Phone,accReq1.Id,accReq1.Name, UserInfo.getUserEmail(), u.Phone); 
            system.debug('to accessRequest Again SDTicket>'+SDTicket);
            //ApproveAccessRequestFuture.requestorSDRequest(accReq1.Id,approverComment,SDTicket);
           	accReq1.Comments__c=accReq1.Description__c;
        	accReq1.SD_Ticket__c = SDTicket;
        	accReq1.Source_of_SD_Ticket__c = 'End User';
        	
        	try{
                update accReq1; 
            }   
            catch(Exception e){
                system.debug('Exception'+e);
            }
    }
}