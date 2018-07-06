global class ScheduledPartnerValidationReport_Weekly implements System.Schedulable{
	
    global void execute(SchedulableContext sc) {    	
    	try{
	    	User userRec;
            List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'salesforceatca@ca.com'];
            EmailTemplate template = [select id from EmailTemplate where name = :System.label.PartnerValidationReport_Weekly_EmailTemplate limit 1];
	    	List<User> userList = [select id from User where name =: System.label.PartnerValidtionReport_Weekly_To limit 1];
	    	if(userList.size() != 0)
	    	{
				userRec = userList[0];
	    	}
	    		    	
	    	if(template!= null && userRec!= null){
		    	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		        message.setTemplateId(template.Id);
		        message.setTargetObjectId(userRec.Id);
		        message.setSaveAsActivity(false); 
                if ( owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }                
		        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );
	    	}    		

        }
    	catch(Exception e){
    		System.debug('Exception occured:'+e.getCause());
    	}            
   }
    
}