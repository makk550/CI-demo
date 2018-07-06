/**
*Description :Class to populate the approvers from MDF Program admin object to Fund Request 
*Methods PopulateApproversOnMDFRequest  , with List of SFDC_MDF__c as input
*SOQl: 1 
*Client: CA technologies
*Developed By:  Accenture
*/
public with sharing class MDF_PopulateApproversForRequest {
    // Populate the approvers from MDF Program Object to MDF Requests
    Set<id> ListOfRequestJuncObjIds=new Set<Id>();
    Map<Id,Fund_Participant__c> MapOfJuncObjs=new Map<Id,Fund_Participant__c>();
    Fund_Participant__c ThisProgramAssociation=new Fund_Participant__c();
    
    //Added as a part of R2.1 to populate currency.
    Set<Id> listOfBudgetIds = new Set<Id>();
    Map<Id,SFDC_Budget__c> mapOfBudget=new Map<Id,SFDC_Budget__c>();
    
    //Method to populate the approvers      
    public void PopulateApproversOnMDFRequest(List<SFDC_MDF__c> ThisRequest){

        //get the list of request ids
        for(SFDC_MDF__c p: ThisRequest){
            ListOfRequestJuncObjIds.add(p.MDF_Program__c);
            listOfBudgetIds.add(p.Budget__c);
        }
        
        mapOfBudget= new Map<Id,SFDC_Budget__c>([select Id,CurrencyIsoCode from SFDC_Budget__c where Id in: listOfBudgetIds]);

        //Map of request and its Id
        MapOfJuncObjs=new Map<Id,Fund_Participant__c>([Select MDF_Program__r.Fund_Request_Level_1_Approver__c,
            MDF_Program__r.Fund_Request_Level_2_Approver__c, MDF_Program__r.Fund_Request_Level_3_Approver__c,
            MDF_Program__r.Approval_Funds_Expiry_Days__c, MDF_Program__r.CA_Share__c,
            MDF_Program__r.Program_Owner_for_questions__r.Email, MDF_Program__r.Program_Owner_for_questions__r.LastName, 
            MDF_Program__r.Program_Owner_for_questions__r.FirstName,MDF_Program__r.Finance_Fund_Approver__c From Fund_Participant__c where id in: ListOfRequestJuncObjIds]);

        //Get the program and populate the approvers on request.
        if(MapOfJuncObjs!=null || MapOfJuncObjs.size()>0)
        {                  
            for(SFDC_MDF__c p: ThisRequest)
            {
                ThisProgramAssociation=MapOfJuncObjs.get(p.MDF_Program__c); 
                if(ThisProgramAssociation!=null)
                {
                    p.CurrencyIsoCode=(mapOfBudget.get(p.Budget__c)).CurrencyIsoCode;
                    p.Approver_1__c=ThisProgramAssociation.MDF_Program__r.Fund_Request_Level_1_Approver__c;
                if(ThisProgramAssociation.MDF_Program__r.Fund_Request_Level_2_Approver__c!=null)
                    p.Approver_2__c=ThisProgramAssociation.MDF_Program__r.Fund_Request_Level_2_Approver__c;
                if(ThisProgramAssociation.MDF_Program__r.Fund_Request_Level_3_Approver__c!=null)
                    p.Approver_3__c=ThisProgramAssociation.MDF_Program__r.Fund_Request_Level_3_Approver__c;
                if(ThisProgramAssociation.MDF_Program__r.Approval_Funds_Expiry_Days__c!=null)
                    p.Approval_Funds_Expiry_Days__c=ThisProgramAssociation.MDF_Program__r.Approval_Funds_Expiry_Days__c;
                if(ThisProgramAssociation.MDF_Program__r.CA_Share__c!=null)
                    p.CA_Share__c=ThisProgramAssociation.MDF_Program__r.CA_Share__c;
                     if(ThisProgramAssociation.MDF_Program__r.Finance_Fund_Approver__c!=null)// nihal added
                    p.Finance_Approver__c=ThisProgramAssociation.MDF_Program__r.Finance_Fund_Approver__c;//nihal added
                if(ThisProgramAssociation.MDF_Program__r.Program_Owner_for_questions__r.Email!=null){
                    p.Program_Owner_Email__c=ThisProgramAssociation.MDF_Program__r.Program_Owner_for_questions__r.Email;
                    p.Program_Owner_Name_For_Email__c=ThisProgramAssociation.MDF_Program__r.Program_Owner_for_questions__r.FirstName+' '+ThisProgramAssociation.MDF_Program__r.Program_Owner_for_questions__r.LastName;
                    }        
                }
            }
       }              
    }
}