global class ScheduledPartnerValidationReport_Daily implements System.Schedulable{
    
    global void execute(SchedulableContext sc) {    	
    	try{
            List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'salesforceatca@ca.com'];
	    	EmailTemplate template = [select id from EmailTemplate where name = :System.label.PartnerValidationReport_Daily_EmailTemplate limit 1];
			User userRec;
	    	
	    	List<User> userList = [select id from User where name =: System.label.PartnerValidtionReport_Daily_To limit 1 ];
	    	if(userList.size() == 0 && System.label.PartnerValidtionReport_Daily_To == 'PartnerRegistration User')
	    	{
    		    userRec = new User(LastName= 'PartnerRegistration User', Username='partnerregistrations@ca.com',
    		    Alias='preg', CommunityNickname='partnervalidation', TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
    		    EmailEncodingKey='ISO-8859-1',ProfileId='00ea000000224gw', LanguageLocaleKey='en_US',
    			email = 'partnerregistrations@ca.com');
    			
			    insert userRec;
			    System.debug(userRec.id);	    		
	    	}
	    	else{
	    		userRec = userList[0];
	    	}
	    	System.debug('userRec:'+userRec);
	    	if(template!= null && userRec != null){
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
    		System.debug('Exception occured:'+e.getMessage());
    	}            
   }
      
}