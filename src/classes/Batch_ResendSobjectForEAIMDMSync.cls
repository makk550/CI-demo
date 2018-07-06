/**************************************************************************************************
* 
* 
*Version Date         Owner                         Description
****************************************************************************************************
* 1.0    13/03/2015   Deepa Raman                   Class created 
**************************************************************************************************/
/*
    1. Call the batch from TAQ Account and Account Trigger. AsyncApexjob... 
    
    2. Don't put limit in clause
    
    3. Execute batch for every 200 records
    
    4. Data Not populated for passedSobject = 'TAQ_Account__c'
        Account information, TAQ Account Team approved information
*/
global class Batch_ResendSobjectForEAIMDMSync implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global string passedSobject='' ;
    String query = '';
    String wherecaluse = '';
    
   
    global Batch_ResendSobjectForEAIMDMSync (string passedSobject)
    {
        if(passedSobject == 'Account'){
            query = 'SELECT ID, Name, Enterprise_ID__c, Enterprise_Account_Name__c, Agreement_Number__c,Service_Provider_Type__c, Contract_Start_Date__c, Contract_End_Date__c, Service_Provider_Program_level__c, Region_Country__c, Account_18_digit_ID__c,'+
                        +'BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, GU_DUNS_NUMBER__c, GU_NAME__c, Segment__c, GEO__c, Sales_Area__c, Sales_Region__c, OwnerId, Account_Type1__c, Account_Type__c, Account_Status__c, Coverage_Model__c, Sales_Volume__c, NumberOfEmployees, '+
                        +'Sic, SicDesc, CreatedDate, CreatedBy.pmfkey__c, LastModifiedDate, LastModifiedBy.pmfkey__c, IsDeleted, RecordTypeId, Global_Parent_Segment__c, Country_Picklist__c, Is_Primary_Account__c, Global_Parent_SIC_2_digit__c, Global_Parent_SIC_4_digit__c, Global_Parent_Industry__c, RecordType.Name, Customer_Category__c,'+
                        +'Website, Alliance__c, Alliance_Type__c, Alliance_Program_Level__c, CPMS_ID__c, Velocity_Seller__c, Velocity_Seller_Type__c, Velocity_Seller_Program_Level__c, rtm__c, Service_Provider__c, Solution_Provider__c,Solution_Provider_Type__c, Solution_Provider_Program_Level__c, '+
                        +'Alliance_CAM_PMFKey__c, Velocity_Seller_CAM_PMFKey__c, Service_Provider_CAM_PMFKey__c, Solution_Provider_CAM_PMFKey__c, Owner.pmfkey__c, Phone '+
                        +' FROM Account WHERE Error_Sending_To_EAI__c = True  AND Error_Code_MDM__c = null ' ; 
        }           

        if(passedSobject == 'TAQ_Account__c'){
            
            query = 'SELECT id,View_Acc_Record__c,Error_Sending_To_EAI__c FROM TAQ_Account__c WHERE Error_Sending_To_EAI__c = True AND Error_Code_MDM__c = null ';
        }
        
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return DataBase.getQueryLocator(query);
        //return MainAcounts;
    }
    
    global void execute(Database.BatchableContext BC,List<sObject> scopeObj)
    {

        Map<Id, List<sObject>> accountIdTosObjectListMap = new Map<Id, List<sObject>> ();

        for (sObject s : scopeObj){
            //When batch apex is executed from Account/TAQ Approved account scope object will be of type Account
            if(s.getsObjectType()  == Account.sObjectType){
                Account acc = (Account)s;
                if(accountIdTosObjectListMap.containsKey(acc.Id))
                {                
                    accountIdTosObjectListMap.get(acc.Id).add(acc);
                }else{
                    accountIdTosObjectListMap.put(acc.Id,new List<Account>{acc});
                }
            }
            
            //When batch apex is executed from TAQ Approved account,collect standard account Ids to get initial contact
            if(s.getsObjectType() == TAQ_Account__c.sObjectType)
            {
                TAQ_Account__c ta = (TAQ_Account__c)s;

                if(accountIdTosObjectListMap.containsKey(ta.View_Acc_Record__c))
                {
                    accountIdTosObjectListMap.get(ta.View_Acc_Record__c).add(s);
                }else{
                    accountIdTosObjectListMap.put(ta.View_Acc_Record__c ,new List<sObject>{s});
                }
            }           
        }
        
            
        WebServiceUtilityClass.callEAIWebserviceBulkRequest(accountIdTosObjectListMap);
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }

}