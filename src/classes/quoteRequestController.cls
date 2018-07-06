/*
 * Test class - quoteRequestControllerTest
 * Coverage - 96%
*/
public class quoteRequestController {
	
    @TestVisible
    Id opportunityId;					//opportunity ID
    
    @TestVisible
    Private String pageURL;				//URL of the page
    
    @TestVisible
    Private Account acc;				//variable to get the account details
    
    public Boolean renderForm{get;set;}		//to render the form or not, if no opportunity exists, then form is not rendered.
    public List<SelectOption> quoteTypeValues {get;set;}	//picklist for quote request type field
    public Opportunity opp{get;set;}		//to get opportunity details
    public string selectedQuoteType{get;set;}		//selected value from picklst
    public Quote_Request__c quoteRequest;		//to insert quote request
    
    public quoteRequestController(){
        renderForm = false;
        pageURL = ApexPages.currentPage().getUrl();
        quoteRequest = new Quote_Request__c();
        if(pageURL.containsIgnoreCase('oppId') && (String.isNotBlank(ApexPages.currentPage().getParameters().get('oppId')))){
            opportunityId = ApexPages.currentPage().getParameters().get('oppId');
        }
        if(opportunityId!=null){
            printLineItems();
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Opportunity exists.'));
        }
        
    }
    
    //this method queries opportunity and account for details and populates the picklist.
    public void printLineItems(){
		renderForm = true;
        opp = [select Id,Name,RecordType.Name,AccountID,Amount,CloseDate,StageName,Owner.Name,
               Opportunity_Number__c, CurrencyIsoCode,Type from Opportunity where id=:opportunityId];
        acc = [SELECT Sales_Region__c,Region_Text__c,Sales_Area__c,Region_Country__c FROM Account WHERE Id=:opp.AccountId];
        quoteTypeValues = new List<SelectOption>();
        quoteTypeValues.add(new SelectOption('--Select--','--Select--'));
        quoteTypeValues.add(new SelectOption('NCV Quote','NCV Quote'));
        //sunji03 - FY19 PS/CAN is added
        if(acc!=null & (acc.Region_Text__c!='NA' && acc.Region_Text__c!='PS/CAN')){
            quoteTypeValues.add(new SelectOption('Renewal','Renewal'));
            quoteTypeValues.add(new SelectOption('Renewal with NCV','Renewal with NCV'));
            quoteTypeValues.add(new SelectOption('Trial Quote','Trial Quote'));
            
        }
        quoteTypeValues.add(new SelectOption('Education-Standalone','Education-Standalone'));
        //sunji03 - FY19 PS/CAN is added
        if(acc!=null & (acc.Region_Text__c=='NA' || acc.Region_Text__c == 'PS/CAN')){
            quoteTypeValues.add(new SelectOption('Indirect - NFR/Demo/Trial','Indirect - NFR/Demo/Trial'));   
        }
        quoteTypeValues.add(new SelectOption('Zero Dollar Quote','Zero Dollar Quote'));
    }
    
    //this method saves the values of the picklist and creates a quote request, and redirects to the
    //record created.
    public pageReference applySelection(){
        PageReference pg;
        
        if(selectedQuoteType=='--Select--'||String.isBlank(selectedQuoteType)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select a value for Quote Request Type.'));
            return null;
        }
        else{
            quoteRequest.Opportunity_Name__c = opp.Id; 
            quoteRequest.Opportunity_Close_Date__c = opp.CloseDate; 
            quoteRequest.Sales_Milestone__c = opp.StageName; 
            quoteRequest.Opportunity_Owner__c = opp.Owner.Name; 
            quoteRequest.Opportunity_Number__c = opp.Opportunity_Number__c; 
            quoteRequest.Opportunity_Amount__c = opp.Amount; 
            quoteRequest.CurrencyIsoCode = opp.CurrencyIsoCode;
            quoteRequest.Type__c = opp.Type;
            quoteRequest.Request_Type__c = selectedQuoteType;
            
            insert quoteRequest;
            
            pg = new PageReference('/'+quoteRequest.id);
            pg.setRedirect(true);
            return pg;
        }
        
        
    }
    
    
    //this method redirects to the opportunity
     public pageReference Cancel(){
        PageReference pg;

        pg = new PageReference('/'+opportunityId);
        pg.setRedirect(true);
        return pg;
    }
}