global class Lead_Unread_Batch_Mailer implements Database.Batchable<sObject>{
    public String query;

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,
        List<sObject> scope){
        Map<Id, String> processOwners = new Map<Id, String>();
        Map<String, String> mapMessages = new Map<String, String>();
        string strEmail = '';
        string strMailMessage = '';
        string strKey = '';
        for(Sobject s : scope){
            Lead lead = (Lead)s;
            strEmail = lead.Owner.Email;

            if(!processOwners.containsKey(lead.OwnerId)){
                processOwners.put(lead.OwnerId,strEmail);
                strMailMessage = '';
            }

            strMailMessage+= '<br><br><a href="https://na1.salesforce.com/' + lead.Id + '">https://na1.salesforce.com/' + lead.Id + '</a><br>';
            strMailMessage+= '<br>Lead details:<br>Lead Name:  ' + lead.FirstName + ' ' + lead.LastName;

            if(lead.Title!=null)
	            strMailMessage+= '<br>Title:  ' + lead.Title;

            strMailMessage+= '<br>Company:  ' + lead.Company;

            if(lead.MKT_BU_Category__c!=null)
            	strMailMessage+= '<br>BU: ' + lead.MKT_BU_Category__c;
            	
			if(lead.MKT_Solution_Set__c!=null)
            	strMailMessage+= '<br>NCV Driver: ' + lead.MKT_Solution_Set__c;

            if(lead.CIDB_Campaign_Name__c!=null)
	            strMailMessage+= '<br>MKTDB Campaign Name:  ' + lead.CIDB_Campaign_Name__c;
            	
/*			if(lead.Description!=null)
            	strMailMessage+= '<br>Description: ' + lead.Description;
*/
			strKey = strEmail + ',' + lead.Owner.Name; 
            mapMessages.put(strKey,strMailMessage);
        } 
        
        for(String strMailAddress:mapMessages.keySet()){
            sendMails(strMailAddress,mapMessages.get(strMailAddress));    
            //sendMails('mohammad.afzal@ca.com,' + strMailAddress.split(',')[1],mapMessages.get(strMailAddress));    
        }        
    }

    private void sendMails(string sKey, string strMessage){
    	string strToEmail = sKey.split(',')[0];
    	string strOwnerName = sKey.split(',')[1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {strToEmail};
        mail.setToAddresses(toAddresses);
        mail.setBccSender(false);
        mail.setSubject('14 days Untouched Lead notification');
        string strbody = '<img src="https://na1.salesforce.com/resource/1266901241000/CA_Logo" /><br><br>';
        strbody += 'Dear ' + strOwnerName + ',';
        strbody += '<br><br>This is a reminder notifying you that your Leads shown below are untouched for the past 14 days. Please review and action these Leads as appropriate. If these Leads remains untouched for 30 days, they will be moved to the Enterprise Untouched Queue.';
        strbody += strMessage;
        strbody += '<br><br>If you need any assistance with the above, please reach out to your local Sales Operations contact.<br><br>Thank You';
        mail.setHTMLBody(strbody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
    }
    
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        try{
	        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
	        TotalJobItems, CreatedBy.Email
	        from AsyncApexJob where Id =:BC.getJobId()];
	        // Send an email to the Apex job's submitter notifying of job completion.
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {a.CreatedBy.Email};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject('14 days unread leads, batch mailer - ' + a.Status);
	        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){}
    }   
}