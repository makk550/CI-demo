/*
 * Test Class - sbOppLineItemEditControllerTest 
 * Created by - BAJPI01
 * 
*/ 
public class sbOppLineItemEditController {
    
    @TestVisible
    private ApexPages.Standardcontroller standardController;

    
    @TestVisible
    Private String pageURL;			//URL of the page
    
    @TestVisible
    Private Id oppLineItemId;			//id of oppLineItem tied to the quote
    
    @TestVisible
    Private String Country;				//reporting country of opportunity
    
    @TestVisible
    Private Decimal previousStretchValue;
    
    @TestVisible
    Private Decimal previousStretchDuration;
   
    @TestVisible
    private String maintProd;		//to store if the product is a maintenance product or not.
    								//it drives the license and maintenance fee values
    
    public ID oppId{get;set;}    
    public OpportunityLineItem lineitemrec {get;set;}
    public Boolean isView{get;set;}
    public Boolean isEdit{get;set;}
    public String productName{get;set;}
    public String oppName{get;set;}
    public Boolean arrStretchEditable{get;set;}

    
    public sbOppLineItemEditController(ApexPages.StandardController controller){
        
        standardController = controller;
        this.lineitemrec = (OpportunityLineItem)standardController.getRecord();
        
        pageURL = ApexPages.currentPage().getUrl();

		isEdit = false;
        isView = false;
        
        if(lineitemrec!=null){
           	oppId = lineitemrec.OpportunityId;
            oppLineItemId = lineitemrec.id;
            previousStretchValue = lineitemrec.Stretch__c;
            previousStretchDuration = lineitemrec.Stretch_Duration__c;
            
            if(String.isNotBlank(pageURL)){
                if(pageURL.containsIgnoreCase('retURL')){
                    isEdit = true;
                    isView = false;
                }
                else{
                    isEdit = false;
                    isView = true;
                }
            }
            fetchProductAndOppName();
        }            
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Opportunity Line Item exists.'));
        }
        
    }
    
    @TestVisible
    private void fetchProductAndOppName(){
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        List<Opportunity> oppList = new List<Opportunity>();
        if(oppLineItemId!=null){
            oppLineItemList = [select Product2.Name,Commissionable_BU__c,Product2.Maintenance_Product__c
                               from OpportunityLineItem where Id=:oppLineItemId limit 1];
            if(oppLineItemList!=null && oppLineItemList.size()==1){
                productName = oppLineItemList[0].Product2.Name;
                maintProd = oppLineItemList[0].Product2.Maintenance_Product__c;
                
            }
                
        }
        if(oppId!=null){
            oppList = [select Name,Rpt_Country__c from Opportunity where id=:oppId limit 1];
            if(oppList!=null && oppList.size()==1){
                Country = oppList[0].Rpt_Country__c;
                oppName = oppList[0].Name;
            }
                
        }
    }
    
    public pageReference onCancel(){
        return new PageReference('/'+oppId);
    }
    
    public pageReference onEdit(){
        PageReference pref = new PageReference(oppId);
        pref.setRedirect(true);
        return pref;
    }
    
    public pageReference onSave(){
        Database.SaveResult sr = Database.update(lineitemrec,true);
        if(sr.isSuccess()){
            return new PageReference('/'+oppId);
        }
        else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'There was an error while saving the record. Please try again.');
            ApexPages.addMessage(msg);
            return null;
        }
    }
    
    public void stretchChangeMethod(){
        if(lineitemrec.Stretch__c<lineitemrec.TotalPrice){
            lineitemrec.Stretch__c = previousStretchValue;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Stretch cannot be less than TotalPrice. Stretch Value restored to original value.');
            ApexPages.addMessage(msg);
        }
        else{
            
            if(String.isNotBlank(maintProd) && maintProd=='Yes'){
                lineitemrec.UF_License_Fee__c = 0;
                lineitemrec.Total_Maintenance__c = lineitemrec.TotalPrice; 
                lineitemrec.Stretch_License_Fee__c= 0;
                lineitemrec.Stretch_Total_Maintenance__c= lineitemrec.Stretch__c;   
            }
            else{
                //US461584 -- merha02
                     if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription'){
                        lineitemrec.UF_License_Fee__c=0;
                        lineitemrec.Stretch_License_Fee__c=0;
                    }else{
                         lineitemrec.UF_License_Fee__c = lineitemrec.TotalPrice;
                        lineitemrec.Stretch_License_Fee__c= lineitemrec.Stretch__c;
                    }
               
                lineitemrec.Total_Maintenance__c = 0; 
                
                lineitemrec.Stretch_Total_Maintenance__c= 0;   
            }            
        }
    }
    
     public void stretchDurationChangeMethod(){
        if(lineitemrec.Stretch_Duration__c<lineitemrec.Term_Month__c){
            lineitemrec.Stretch_Duration__c = previousStretchDuration;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Stretch Duration cannot be less than Term Months. Stretch Duration restored to original value.');
            ApexPages.addMessage(msg);
        }
        else{
            
            if(String.isNotBlank(maintProd) && maintProd=='Yes'){
                lineitemrec.UF_License_Fee__c = 0;
                lineitemrec.Total_Maintenance__c = lineitemrec.TotalPrice; 
                lineitemrec.Stretch_License_Fee__c= 0;
                lineitemrec.Stretch_Total_Maintenance__c= lineitemrec.Stretch__c;   
            }
            else{
                 //US461584 -- merha02
                     if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription'){
                        lineitemrec.UF_License_Fee__c=0;
                        lineitemrec.Stretch_License_Fee__c=0;
                    }else{
                         lineitemrec.UF_License_Fee__c = lineitemrec.TotalPrice;
                        lineitemrec.Stretch_License_Fee__c= lineitemrec.Stretch__c;
                    }
                
               
                lineitemrec.Total_Maintenance__c = 0; 
                
                lineitemrec.Stretch_Total_Maintenance__c= 0;   
            } 
            
        }
    }



}