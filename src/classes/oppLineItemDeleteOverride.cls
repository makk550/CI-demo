/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       11/2/2017       US370555        RevRec: SFDC License Classification generate Opportunity from Renewal

*Coverage: 92%
Test Class - oppLineItemDeleteOverrideTest
* ********************************************************************************************/
public class oppLineItemDeleteOverride {
    
    @TestVisible
    private ApexPages.Standardcontroller standardController;
    
    @TestVisible  
    RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');	//to get details from custom setting for SB Record Type
    @TestVisible
    private string steelBrickRecType;	//stores the SB Record Type ID.
    @TestVisible
    private RecordTypes_Setting__c entlSync = RecordTypes_Setting__c.getValues('Entitlement_Sync');	//to get details from custom setting for Entl Sync Rec Type   
    @TestVisible
    private string entlSyncRecType;		//stores the Entitlement Rec Type ID.

    
    public Opportunity opp{get;set;}
    public OpportunityLineItem lineitemrec {get;set;}
    
    public oppLineItemDeleteOverride(ApexPages.StandardController controller){
        
        standardController = controller;
        lineitemrec = [SELECT Id,Business_Type__c,OpportunityId,Active_Contract_Line_Item__c FROM OpportunityLineItem WHERE Id =:standardController.getId()]; //samap01
          System.debug('samap01 oppLineItemDeleteOverride' +lineitemrec.Business_Type__c + '--' +lineitemrec.Active_Contract_Line_Item__c );
        if(sbRecType!=null)
            steelBrickRecType = sbRecType.RecordType_Id__c;		//assign new SB record type to the variable
        
        if(entlSync!=null)
            entlSyncRecType = entlSync.RecordType_Id__c;		//assign entitlement sync rec type to the variable
        
        opp = [SELECT Id,RecordTypeId,RecordType.Name FROM Opportunity WHERE Id =:lineitemrec.OpportunityId];
    }
    
    public pageReference doDelete(){
        
        String opprecid = String.Valueof(opp.RecordTypeId);
        opprecid = opprecid.substring(0,15);
          System.debug('samap01 renewal type lineitemrec.Business_Type__c' +lineitemrec.Business_Type__c + '--' +lineitemrec.Active_Contract_Line_Item__c );
        if((String.isNotBlank(steelBrickRecType) && opp.RecordTypeId==steelBrickRecType)||(String.isNotBlank(entlSyncRecType) && opp.RecordTypeId==entlSyncRecType)){
             ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'In order to delete this line item, go to the primary quote and delete the line item from there.'));
            return null;
        }
        else{ 
            
             //samap01 -revrec- do not allow to delete renewal items
             if(lineitemrec.Business_Type__c =='Renewal' && lineitemrec.Active_Contract_Line_Item__c != null )
             {
                 System.debug('samap01 renewal type lineitemrec.Business_Type__c' +lineitemrec.Business_Type__c + '--' +lineitemrec.Active_Contract_Line_Item__c );
                     ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'A product line item for a Renewal Material cannot be deleted.  Use the Detach Contracts button to delete Renewal Material products from the Opportunity'));
           			 return null;  
             }
            	else
                {
                      delete lineitemrec;
           			 return new PageReference('/'+opp.Id);
                }
          
        }       
    }
    
    public pageReference backtoOpp(){
        return new PageReference('/'+opp.Id);
    }

}