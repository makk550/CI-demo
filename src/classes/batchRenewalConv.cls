/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       16/10/2017       US370555        RevRec: SFDC License Classification generate Opportunity from Renewal
* SAMAP01		6/12/2017		 US423678		 Rev Rec- XXXL Renewals
* SAMAP01       6/12/2017		US424523		RevRec: SFDC Forecasting TARR on Opportunities - Renewal_OpportunityUtilityClass
* ********************************************************************************************/
global class batchRenewalConv implements Database.Batchable<sObject>
{
    string query ;
    string query1 ;
    String Ids ; 
    boolean showPageMessage;
    Boolean flag;
    public Map<String, String> errorLog  = new Map<String, String>();
    public Map<String, String> errorLog1 = new Map<String, String>();
    public Decimal BatchNumber;
  
   
     global batchRenewalConv(Set<Id> selecterenwalIds , Decimal BachNumber){
        system.debug('adfd --> ' + selecterenwalIds);
        BatchNumber = BachNumber;
        errorLog1 = new Map<String, String>();
        errorLog = new Map<String, String>();
        ids = '';
       
        for(Id a : selecterenwalIds)
        {
            ids = ids + '\'' + a+ '\',' ;       
        }
        ids = ids + '\'\'';
        query1  = ids ;
        
        	//US511578 - poras01 - added Renewal_Risk__c field to query. - not done
         query =  'select id, Segmentation__c, name, Account__c, OwnerId, Expected_Close_Date__c, '+
                    'Converted_To_Opportunity__c, Overall_Comments__c, CurrencyIsoCode, Renewal_Risk__c, '+
                    'Projected_Time_Duration_Months__c, OCV__c, Annual_OCV_LC__c,Baseline_ATTRF_LC__c, '+
                    'Sold_to_Ship_to_Party_Site_ID__c, Projected_Renewal__c,owner.isActive,'+
                    'Local_Currency__c, New_Site_Id__c, Territory__c , '+
                    'Reason_duration_is_1_year__c,Status_at_end_of_term__c, (select active_contract__r.header_dismantle_date__c,'+
                                                                          '  active_contract__r.Contract_Term_Months__c from Renewals_Product_Contracts__r)'+
                    'from Renewal__c where Id in (' + ids +')';
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC)
    {   
        system.debug('query --> ' + query)  ;   
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext BC, List<Renewal__c> selectedRenewals)
    {
       
        errorLog  = convRenewals(selectedRenewals);
        system.debug('Errorlog--> ' + errorLog);
        List<Opp_Generation_Error_Log__c> oppGenerationLog = new List<Opp_Generation_Error_Log__c>();
        Set <String> setError = new Set<String>();
        setError = errorLog.keySet();
        system.debug('setError -->' + setError );
        for (String err: setError )
        {
            Opp_Generation_Error_Log__c opGen = new Opp_Generation_Error_Log__c();
            opGen.Error_Message__c = errorLog.get(err);
            opGen.Renewal_Name_Id__c = err;
            opGen.Batch_Number__c = BatchNumber;
            
            oppGenerationLog.add(opGen);
            system.debug('hi -->' + BatchNumber);
        }
        
        if(oppGenerationLog != null && oppGenerationLog.size() > 0)
            insert oppGenerationLog;
        
    } 
    
   
   
    
    global void finish(Database.BatchableContext BC)
    {              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail() };       
            mail.setToAddresses(toAddresses );
        mail.setSubject('Opportunities Generated');
        mail.setPlainTextBody('Batch Job Complete with batch number ' + BatchNumber + '.Refer the report for Error/Success log. ' + Label.Renewal_Report_Link);
        system.debug('hi' + errorlog);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        //emailLogs();      
    }
    
    
    public Map<String, String> convRenewals(List<Renewal__c> selectedRenewals)
    {
        
        List<Renewal__c> ren =new List<Renewal__c>();

        if(selectedRenewals.size() >0)
        {
            for(Renewal__c rnwl :selectedRenewals)
              {
              
                System.debug('Samap01- Renewal Conversion to opportunity started'+rnwl);
               errorLog1 = Renewal_OpportunityUtilityClass.CreateOpportunity(rnwl);       
               System.debug('samap01-error occured '+errorLog1);
        	}
        
        }
      
        return errorLog1;
        
        
    }
    
    public void emailLogs()
    {
        
        
        if(errorLog != null && errorLog.size() > 0)
        {
            String strResult;
            string subject1;
            strResult = strResult + 'Renewal Name' + '~' + 'Message' + '\n';
            Set<String> errorSet= new Set<String>();
            errorSet= errorLog.keySet();
            
            for(String s: errorSet)
                strResult = strResult + s + '~' + errorLog.get(s) +'\n';
            
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            strResult = strResult.replaceAll(',', ' ');          
            strResult = strResult.replaceAll('~', ',');          
            strResult = strResult.replaceAll('TRUE', 'Yes');          
            strResult = strResult.replaceAll('FALSE', 'No');          
            strResult = strResult.replaceAll('null', '');   
            blob csvBlob =   Blob.valueOf(strResult);
            string csvname= 'ErrorLog.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            
            email.setSubject('Error Log');
            
            
            email.setToAddresses(new String[] {UserInfo.getUserEmail() }); 
            // email.setToAddresses(new String[] {'danva01@ca.com' }); 
            
            email.setPlainTextBody('Error Log');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            if (r.get(0).isSuccess())
            {
                //EmailMsg = 'Mail Sent';
                //Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.CONFIRM,'Mail Sent')); 
                showPageMessage = true;
            }
            else
            {
                //Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Mail not sent')); 
                //  EmailMsg = 'Mail not sent';
                showPageMessage = true;
            }
            
        }
        else
        {
            //Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'No Records to Email')); 
            // EmailMsg = 'No Records to Email';
            showPageMessage = true;
        }
    }
    
    
}