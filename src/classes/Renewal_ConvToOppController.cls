/**
Cbelss Name: Renewal_ConvToOppController
Author: Sandeep D.S
Description: This class is to convert renewal in to oppertunity.  
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01      23/10/2017       US370555        RevRec: SFDC License Classification generate Opportunity from Renewal
* SAMAP01      29/11/2017       US423678        RevRec: XXXL Line items
* ********************************************************************************************/

public class Renewal_ConvToOppController {
    
          
    string returnurl ='';
    public Boolean showEmailLogButton {get;  set;}
    public List<Active_Contract_Line_Item__c>  AclProduct = new List<Active_Contract_Line_Item__c>(); 
    
    public Map<String, String> errorLog { get; set; }
    public Map<String, String> geterrorLog() {                
        return errorLog;
    }
     public Map<ID, Renewal__c> maprenewalslist{get;set;} //samap01
    Renewal_contracts__c rc;
    public Renewal__c rnwl{get;set;}
    public Account acc{get;set;}
    Boolean flag;
    Set<Id> renwlids = new Set<id>();
        List<String> selectedIds = new List<String>(); 
     public Decimal BatchNumber {get;set;}
    public Renewal_ConvToOppController(ApexPages.StandardController controller) {    
        showEmailLogButton  =false;       
        errorLog = new Map<String, String>();      
        rnwl = (Renewal__c)controller.getRecord();
        if(rnwl.Id!=null){
         /*   rnwl = [select id, Segmentation__c, name, Account__c, OwnerId, Expected_Close_Date__c, 
                    Converted_To_Opportunity__c, Overall_Comments__c, CurrencyIsoCode,
                    Projected_Time_Duration_Months__c, OCV__c, Annual_OCV_LC__c,Baseline_ATTRF_LC__c, 
                    Sold_to_Ship_to_Party_Site_ID__c, Projected_Renewal__c,owner.isActive,
                    Local_Currency__c, New_Site_Id__c, Territory__c , // Changed for FY14 - was Territory_Country__c
                    Reason_duration_is_1_year__c,Status_at_end_of_term__c, (select active_contract__r.header_dismantle_date__c,
                                                                            active_contract__r.Contract_Term_Months__c from Renewals_Product_Contracts__r)
                    from Renewal__c 
                    where Id =:rnwl.Id];   //adding baseline for baseline attrf req
         
            if(rnwl.Renewals_Product_Contracts__r.size()>0)
                rc = rnwl.Renewals_Product_Contracts__r.get(0);
            */
            //samap01 - using common utility file
            System.debug('samap01 renwalid' +rnwl.id);
            renwlids.add(rnwl.id);
            selectedIds.add(rnwl.id)  ; //samap01 -- needed for batchjob
          	maprenewalslist = Renewal_OpportunityUtilityClass.RetrieveRenewals(renwlids);
            rnwl = maprenewalslist.get(rnwl.Id);
               acc = [select id from Account where id=:rnwl.Account__c];
            if(rnwl.Renewals_Product_Contracts__r.size()>0)
                   rc = rnwl.Renewals_Product_Contracts__r.get(0);
            //samap01
            
        }
    }    
    
    public Pagereference creatOppRecord(){  
        SystemIdUtility.skipTrigger  = true;   
        System.debug('samap01 creatOppRecord rnwl' + rnwl);
        if(rnwl.owner.isActive ==false)
        {
            errorLog.put(rnwl.name,'The Owner of the renewal is inactive and the renewal cannot be converted to Opportunity');
            showEmailLogButton = true;
            return null;    
        }
        
        if(rnwl.Converted_To_Opportunity__c==true){
            errorLog.put(rnwl.name,'The selected Renewal already been Converted into an Opportunity.');
            showEmailLogButton = true;
            return null;    
        }
        // based on Req. 10.09 LT option is addded by subsa03
        
        if(rnwl.Segmentation__c != 'HT' && rnwl.Segmentation__c  != 'MT' && rnwl.Segmentation__c  != 'LT'){
            errorLog.put(rnwl.name,'This Renewal has the Segmentation ' + rnwl.Segmentation__c  + ', so it cannot be Converted into an Opportunity.');
            showEmailLogButton = true;
            return null;    
        }
        
        // Check all ACP associated with the Renewal. If there are no ACP with Converted_to_Opportunity = false, 
        // do not create oppty (because ACPs are already on another oppty. - lfc - 03Mar2012
        Integer howManyACP = [Select COUNT() From Active_Contract_Product__c
                              Where Converted_To_Opportunity__c <> true and
                              Renewal_Product__r.Renewal__c = :rnwl.Id];
        
        if(howManyACP == 0){
            errorLog.put(rnwl.name,'All Active Contract Products are already associated to Opportunities.');
            showEmailLogButton = true;
            return null;    
        }
        
         Integer howManyACL = [Select COUNT() From Active_Contract_Line_Item__c
                              Where Contract_Product__r.Converted_To_Opportunity__c <> true and
                              Contract_Product__r.Renewal_Product__r.Renewal__c = :rnwl.Id];
        System.debug('samap01 howManyACL'+howManyACL + '--batch size' +System.Label.Opportunity_BatchSize);
        if(howManyACL > Integer.Valueof(System.Label.Opportunity_BatchSize) )
        {
            
            RenewalConv();
              returnurl = '/apex/Renewal_MassOpportunityConv';  
             PageReference    pg =new PageReference(returnurl);
            System.debug('samap01 calling batch job');
                    return pg;
        }
        else
        {
            
        
        //samap01 -- calling from utility
         errorLog = Renewal_OpportunityUtilityClass.CreateOpportunity(rnwl);
         Id id = Renewal_OpportunityUtilityClass.NewOpportunityId;
          if(errorLog.size()>0 ) //samap01 -29/11            
        {
            for (String key : errorLog.keySet()) 
            {
               
                String errormsg = errorLog.get(key);
                if(errormsg.containsAny('Generated'))
                {                    
                     //redirect the page to the RPD Review for opportunity page.
                    SystemIdUtility.skipTrigger  = false;  
                    PageReference pg =new PageReference('/'+id);
                    
                    if(errorLog.size() > 0 )
                        showEmailLogButton  = true;
                    else
                        showEmailLogButton = false;
                    
                    pg.setRedirect(true);   
                    
                    if(returnurl != '')
                        pg =new PageReference(returnurl);
                    return pg;
                }
                else
                {
                    errorLog.put('Error','Error Occured while creating the Opportunity' ); //Pricebook Entry is not active for selected Renewal product(s)!');            
            		return null;  
                }
                    
            }
           return null;
        }
        else
        {
          
             //redirect the page to the RPD Review for opportunity page.
            SystemIdUtility.skipTrigger  = false;  
            PageReference pg =new PageReference('/'+id);
            
            if(errorLog.size() > 0 )
                showEmailLogButton  = true;
            else
                showEmailLogButton = false;
            
            pg.setRedirect(true);   
            
            if(returnurl != '')
                pg =new PageReference(returnurl);
            return pg;
        }
        }
   
    }
   
    //calling batch job to avoid the apex cou limit errors
    //samap01 -- jan 8th 2018 -US423678
 
       public string RenewalConv(){
        
        Renewal_MassOpportunityConv rc = new Renewal_MassOpportunityConv();
        Date dt1;
        Date dt2;
        
        SystemIdUtility.skipTrigger  = true;
        //errorlog = rc.Renewal_ConvertRenewalsMain('listView',dt1,dt2,'');
        //errorlog = convRenewals();
        
         List<Renewal__c> selRenewalIds = [select id from Renewal__c where Id in :selectedIds];    //samap01 - modified 12/20       
		Set<Id> selIds = (new Map<Id,Renewal__c>(selRenewalIds)).keySet();
      	// List<Renewal__c> selRenewallist = Renewal_OpportunityUtilityClass.RetrieveRenewals(selectedIds) ;
        
        List<Opp_Generation_Error_Log__c> genError = new List<Opp_Generation_Error_Log__c>(); 
        genError  = [Select Batch_Number__c From Opp_Generation_Error_Log__c where Batch_Number__c != null order by Batch_Number__c desc];
        
        if(genError != null && genError.size() > 0)
        {
            if(genError[0].Batch_Number__c != null)
                BatchNumber =  genError[0].Batch_Number__c; 
            else
                BatchNumber =-1; 
            
        }     
        else
            BatchNumber = -1;  
        /* To check number of batch jobs currently running */
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
            System.debug('samap01 -- batch job is getting called with ids '+selIds);
            BatchNumber  = BatchNumber + 1 ;
            batchRenewalConv btRenewalConv = new batchRenewalConv(selIds , BatchNumber);   //samap01 
            
            ID batchprocessid  = database.executeBatch(btRenewalConv,1);
            
            
        }
        else
        {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Records cannot be processed now .Please try after somtime.'));
        }
        
        
        return null;   
        
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
            
            email.setPlainTextBody('Error Log');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            if (r.get(0).isSuccess())
            {
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.CONFIRM,'Mail Sent')); 
            }
            else
            {
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Mail not sent')); 
            }
            
        }
        else
        {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'No Records to Email')); 
        }
    }
   
}