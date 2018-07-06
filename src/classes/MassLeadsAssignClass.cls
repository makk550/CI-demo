public class MassLeadsAssignClass {

//----------------------------- class parameters ----------------------------------------------//
    private Id[] leadIdList = null;
    private PageReference returnRef = null;
        
    public String accName;
    public String partnerContact;
    public String partnerSite;
    public String returnURL;
    public String userProfId;
    public boolean userEligible;
    public List<ErrorTableWrapper> updateFailedLeads = new List<ErrorTableWrapper>();
    public boolean errTableDisplayFlag = false;
    
    // return the list of failed or error leads
    public List<ErrorTableWrapper> getErrorLeads() {
    	 return updateFailedLeads;	    	
    }

	public boolean getErrorTableDisplay() {
		return errTableDisplayFlag; 			
	}
    
    /*
     * this method initializes the page with data 
     * 
     */   
    public PageReference init() {
        userEligible = identifyPageVisibility(); 
        if(userEligible)
        {       
            Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Lead;
            stringToIdArray(ApexPages.currentPage().getParameters().get('leads'));
            accName = ApexPages.currentPage().getParameters().get('accName');
            returnURL = '/'+describeResult.getKeyPrefix()+'?fcf='+ApexPages.currentPage().getParameters().get('fcf');
            returnRef = new PageReference(returnURL);           
        }
        return null;
    }
    
    // return the visibility flag for the panel
    public boolean getRenderPanel() {
        return userEligible;    
    }
    
    // return the message for direct users 
    public String getAccessErrStyle() {
        if(userEligible == false)
            return 'display:block'; 
        else
            return 'display:none';
    }
    
    // return the list of leads ids
    public Id[] getLeadIds() {
        return leadIdList;  
    }
    
    // Action to return to the leads list page    
    public PageReference returnToLeadsList() {
    	return returnRef;
    }

    /*
     * Action to update the leads object with partner details 
     * 
     * @ return pageReference
     */            
    public PageReference saveAction() {
        String accId = ApexPages.currentPage().getParameters().get('popUpPage2:mlaForm:accId');
        String contactId = ApexPages.currentPage().getParameters().get('popUpPage2:mlaForm:contactId');
        String partnerSiteId = ApexPages.currentPage().getParameters().get('popUpPage2:mlaForm:pSiteId');       

        System.debug(logginglevel.Debug,'printing my acc id : '+accId); 
		errTableDisplayFlag = false;

        if(accId != '' && (contactId != '' || partnerSiteId != ''))
        {
            if(upsertLeads(accId,contactId,partnerSiteId))                 
            	return returnRef;
            else
            {
            	errTableDisplayFlag = true;
            	return null;	
            }
        }
        else
            return null;    
    } 
 
    /*
     * function to upsert the selected leads with the partner assignment details 
     * 
     * @ param accId,contactId,partnerSiteId
     * @ return upsert status flag
     */            
    public boolean upsertLeads(String accId,String contactId,String partnerSiteId) {
    	Database.SaveResult[] leadUpdateResult;
        Lead[] leadsList = [Select Id,FirstName,LastName from Lead where Id in : leadIdList];
        for(Lead ld: leadsList)
        {           
            ld.Reseller__c = accId; 
            if(contactId !=null && contactId != '')
                ld.Reseller_Contact_Name__c = contactId;
            ld.Reseller_Assignment__c = 'Manual';   
        }       
    
        // upsert all the leads
	    try
	    {    
			//setting the opt_allOrNoneparameter to false because even if 1 record update fails, 
			//the remainder of the DML operation need to succeed
	        leadUpdateResult = Database.update(leadsList,false); 
	    }
	    catch(DmlException dmlEx) {
	    	System.debug(logginglevel.Debug,'DmlException is : '+dmlEx);
	        // catch any DML exception during the upsert call   
	    }    
		
		for(integer j = 0;j<leadUpdateResult.size();j++)
		{
			if(!leadUpdateResult[j].success) 
			{	
				// capture the details about failure records			
				updateFailedLeads.add(new ErrorTableWrapper(leadsList.get(j).FirstName,leadsList.get(j).LastName,leadUpdateResult[j].errors[0].message));	
			}
		}
		
		if(updateFailedLeads.size() > 0)
			return false;
		else
			return true;	    
    }
 
    /*
     * utility method to construct an array from the comma separated Ids 
     * 
     * @ param a list of clients
     * @ return an array of IDs
     */            
    public Id[] stringToIdArray(String clientList) {
        if(clientList != null)
        {
            String[] clientListArr =  clientList.split(',',0);      
            leadIdList = new Id[clientListArr.size()];
            leadIdList = clientListArr;
        }
        return leadIdList;      
    }
    
    /*
     * function containing the logic for user/role visibility calculation 
     * 
     * @ return a boolean indicating the page visibility
     */            
    public boolean identifyPageVisibility()
    {
    	set<String> dirProfileIds = SystemIdUtility.getDirectProfileIds();
        userProfId = UserInfo.getProfileId();
        // identify the user type               
        if(dirProfileIds.contains(userProfId))
            return false;
        else
            return true;
    }
    
    /*
     * Wrapper class to wrap up the error table data 
     */            
    public class ErrorTableWrapper
    {
        private String firstName;
        private String lastName;
        private String errMessage;
        
        // return the firstName
        public String getFirstName()
        {
            return firstName;
        }   
        
        // return the lastName
        public String getLastName()
        {
            return lastName;   
        }
        
        // return the errorMessage
        public String getErrorMessage()
        {
            return errMessage;    
        }   
        
        // constructor for ErrorTableWrapper class          
        public ErrorTableWrapper(String firstName,String lastName,String errMsg)
        {
            this.firstName = firstName;
            this.lastName = lastName;
            this.errMessage = errMsg;   
        }   
    }

    /*
     * test method for the ErrorTableWrapper class 
     */                
	static testMethod void testErrorTableWrapper() {
		ErrorTableWrapper srWrapper = new ErrorTableWrapper('str1','str2','str3');
		srWrapper.getFirstName();
		srWrapper.getLastName();
		srWrapper.getErrorMessage();
	}    
}