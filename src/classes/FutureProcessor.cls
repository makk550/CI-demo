/*
* This class has been written to perform some tasks in future so that the DML and SOQL queries may be reduced
* Author : Saba    
*/ 
public class FutureProcessor
{
    
    public static void UpdateOpportunity_OnLeadConversion(List<string> lstLead, Set<string> convertedOppIds)
    {        
        if(SystemIdUtility.isFutureUpdate) //Call futuremethod only if the call is not from future
            UpdateOpportunityOnLeadConversion(lstLead,convertedOppIds);
         else
            UpdateOpportunityOnLeadConversion_Future(lstLead,convertedOppIds);
    }    
    
    
    @future 
    public static void UpdateOpportunityOnLeadConversion_Future(List<string> lstLead, Set<string> convertedOppIds)
    {
       SystemIdUtility.isFutureUpdate = true;
       FutureProcessor.UpdateOpportunityOnLeadConversion(lstLead,convertedOppIds);
    }    
    
    
    public static void UpdateOpportunityOnLeadConversion(List<string> lstLead, Set<string> convertedOppIds)
    {   
        System.debug('coming inside of future processor');
        if(convertedOppIds.size()>0)
            {
                 AutoLeadConversion alConversion = new AutoLeadConversion(); 
                 
                 Lead[] leadList = [Select l.of_Reseller_Rejects__c, l.Commercial_Account__r.OwnerId, l.of_Auto_Pulled_Backs__c, l.d_White_Paper__c, l.d_Webinar__c, 
                l.d_EG__c, l.d_Download__c, l.d_Demo__c, l.Your_Involvement_in_IT_Purchasing__c, l.Working_with_Partner__c, 
                l.What_other_information_can_we_provide__c, l.What_is_your_interest_in_this_topic__c, 
                l.Website, l.Volume_Customer__c, l.Transfer_to_CPMS__c, l.Title_Local__c, l.Title, l.Timing__c, 
                l.Teleprospecting_Team__c, l.Teleprospecting_Rep__c, l.Teleprospecting_Manager__c, l.Technical_Requirement__c, 
                l.Target_Account__c, l.TOPS_Site_ID__c, l.SystemModstamp, l.Street_Local__c, l.Street, 
                l.Status, l.State_Province_Local__c, l.State, l.Show_In_CPMS_Error_Report__c, l.Search_Engine__c, l.Salutation, 
                l.Sales_Territory__c, l.Sales_Logix_Notes__c, l.SPP__c, l.SFGA__Web_Source__c, l.SFGA__Correlation_Data__c, 
                l.SFGA__CorrelationID__c, l.SAP_Site_ID__c, l.SAP_Campaign_Element__c, l.RouteLeads__c, l.Reseller__c, 
                l.Reseller_Status__c, l.Reseller_Reject_Reasons__c, l.Reseller_Qualified__c, l.Reseller_Notes__c, 
                l.Reseller_Milestone__c, l.Reseller_Led__c, l.Reseller_Initiated__c, l.Reseller_Estimated_Value__c, l.Distributor__c,
                l.Reseller_Deal_Reg_IQ_Name__c, l.Reseller_Contact_Phone__c, l.Reseller_Contact_Name__c, l.Reseller_Contact_Name_CPMS__c, 
                l.Reseller_Contact_Last_Name__c, l.Reseller_Contact_First_Name__c, l.Reseller_Contact_Email__c, l.Deal_Registration_Name__c,
                l.Reseller_Contact_Email_CPMS__c, l.Reseller_Contact_CPMS_ID__c, l.Reseller_Close_Date__c, l.Reseller_CPMS_ID__c, 
                l.Reseller_Assignment__c, l.Referring_Page__c, l.Referred_Lead_to_Partner__c, l.Referred_Lead_to_Partner_DATE__c, 
                l.RecordTypeId, l.Rating, l.Purchase_Time_Frame__c, l.Promotional_Code__c, l.Product__c, 
                l.Product_Type__c, l.Product_Sales_Executive_Name__c, l.Preferred_Reseller__c, l.Amount__c,
                l.Preferred_Reseller_Name__c, l.PostalCode, l.Expected_Close_Date__c,
                l.Phone, l.Partner__c, l.Partner_Contact__c, l.Partner_Contact_Phone__c, l.Partner_Contact_Email__c, 
                l.OwnerId,l.Opportunity_Deal_Type__c, 
                l.Old_Lead_ID__c, l.Old_Lead_ID_Trimmed__c, l.NumberOfEmployees, l.No_Interest_Reason__c, 
                l.No_Interest_Check_In__c, l.Need_Project__c, l.Name, l.MobilePhone, l.Meeting_Request__c, 
                l.Meeting_Rating__c, l.MasterRecordId, l.Market__c, l.Manager_Approval__c, l.MKT_Territory__c, l.MKT_Solution_Set__c, 
                l.MKT_BU_Category__c, l.Lostunqualified_Lead_Reason__c, l.Legacy_Create_Date__c, l.Lead_to_Oppty__c, 
                l.Lead_Status_Date__c, l.Lead_Source_3__c, l.Lead_Source_2__c, l.Lead_Score__c, 
                l.Lead_Score2__c, l.Lead_Rating__c, l.Lead_Owner_s_Manager__c, l.Lead_Owner_PMF__c, l.LeadSource, 
                l.Last_Submission_Date__c, l.Last_Processed_Date__c, l.Last_Name_Phonetic__c, l.LastTransferDate, 
                l.LastNameLocal, l.LastName, l.LastModifiedDate, l.LastModifiedById, l.LastActivityDate, l.Keyword_Search_Term__c, 
                l.IsUnreadByOwner, l.IsDeleted, l.IsConverted, l.Industry, l.Id, l.HasOptedOutOfFax, l.HasOptedOutOfEmail, 
                l.Global_Campaign__c, l.GEO__c, l.GEO_Campaign__c, l.Form_ID__c, l.First_Name_Phonetic__c, l.FirstNameLocal, 
                l.FirstName, l.Fax, l.Existing_CA_Customer__c, l.Ent_Matching_Conf_Code__c, l.End_User_Name__c, 
                l.End_User_Id__c, l.Email_Opt_in__c, l.EmailBouncedReason, l.EmailBouncedDate, l.Email, l.EAID__c, l.DoNotCall, 
                l.Description_of_Opportunity__c, l.Description, l.Department_Local__c, l.Deal_Registration__c, l.Deal_Program__c, l.Database_Size__c, l.Customer_Call_Requested__c,               l.CurrencyIsoCode, l.CreatedDate, l.CreatedById, l.Country_Picklist__c, l.Country, l.ConvertedOpportunityId,
                 l.ConvertedDate, l.ConvertedContactId, l.ConvertedAccountId, l.Lead_Record_Type__c,
                 l.Contact_Title__c, l.Contact_Role__c, l.Competitor_Product__c, l.Company_Name_Phonetic__c, 
                 l.CompanyLocal, l.Company, l.Commercial_MQL_Stage__c, l.Commercial_Account__c, l.Comments_Field__c, 
                 l.Clarity_Territory__c, l.City_Local__c, l.City, l.CPMS_Reseller_Contact_ID__c, l.CPMS_Lead_Oppt_ID__c, 
                 l.CPMS_Error_Message__c, l.CPMS_Comm_Account_ID__c, l.CIDB_Site_ID__c, l.CIDB_Inquiry_Create_Date__c, 
                 l.CIDB_FLOW_KEY__c, l.CIDB_Contact_ID__c, l.CIDB_Campaign_Name__c, l.Buyers_Journey__c, l.Business_Unit__c, l.Reseller__r.OwnerId,
                 l.Business_Source__c, l.Budget_Identified__c, l.BU__c, l.Auto_Lead_Conversion_Status__c, 
                 l.Attendance_Status__c, l.Attempt_Count__c, l.Approver_Notes__c, l.AnnualRevenue, 
                 l.Allow_Manual_Convert__c, l.Age__c, l.Additional_Information__c, l.Action__c, l.Account_Tier__c, l.Account_Territory__c,
                  l.Account_Contact__c, l.Account_Class__c, l.AD_AM_Name__c From Lead l where id in : lstLead];
                 
                 
                //SOQL #1,#2 : retrieve the list of opportunities and the associated account details
                Opportunity[] oppsList = [Select Id,AccountId,Account_Contact__c,Account.Aggregate_Account__c,reseller__c,  Deal_Expiration_Date__c,
                Account.Account_Status__c,RecordTypeId,StageName,Reseller_Contact__c,Ent_Comm_Account__c,source__c,
                type,ownerid from Opportunity where Id in :convertedOppIds];
                System.debug(logginglevel.Debug,'0 : The oppList is :'+oppsList);
                
                // update the opp List with Volume Account, Commercial Account & Account Contact details
                    
                oppsList = alConversion.updateAccountDetails(oppsList,leadList);
                System.debug(logginglevel.Debug,'0 : The oppList is :'+oppsList);
                for(integer i = 0;i < leadList.size();i++) 
                {
                    for(integer j = 0;j<oppsList.size();j++) 
                    {
                        System.debug(logginglevel.Debug,'01 : The oppList is :'+oppsList);
                        if(oppsList.get(j).Id == leadList.get(i).ConvertedOpportunityId)
                        {
                            // update the opp. record type, Deal type
                            if(leadList.get(i).BU__c != null)
                            {
                                
                                if(leadList.get(i).BU__c.equalsIgnoreCase('RMDM'))
                                {                   
                                    oppsList.get(j).RecordTypeId = SystemIdUtility.getIndirectRMDMRecordTypeId();
                                    oppsList.get(j).Deal_Type__c=SystemIdUtility.getRmdmDealType(); 
                                    oppsList.get(j).Type=System.Label.RMDM_and_ISBU;
                                }
                                else if(leadList.get(i).BU__c.equalsIgnoreCase('ISBU'))
                                {
                                    oppsList.get(j).RecordTypeId = SystemIdUtility.getIndirectISBURecordTypeId();
                                    oppsList.get(j).Deal_Type__c=SystemIdUtility.getIsbuDealType(); 
                                    oppsList.get(j).Type=System.Label.RMDM_and_ISBU;
                                }
                                else if(leadList.get(i).BU__c.equalsIgnoreCase('Value'))
                                {
                                   // oppsList.get(j).RecordTypeId = SystemIdUtility.getIndirectVALUERecordTypeId(); 
                                   // commented by Heena as part of PRM R2 defect 48552 as IND Value recordtype is inactive.
                                    oppsList.get(j).Deal_Type__c=SystemIdUtility.getValueDealType();
                                }
                            }
                            System.debug('oppsList.get(j).RecordTypeId=='+oppsList.get(j).RecordTypeId); 
                            //HEENA CHANGES BEGIN  for lead conversion req prm 2
                                if(SystemIdUtility.IsDeal_RegistrationRecordType(leadList.get(i).RecordTypeId))
                                {System.debug('coming inside if==');
                                        oppsList.get(j).RecordTypeId = SystemIdUtility.getDealRegistrationOpportunityRecordTypeId();                                        
                                        if(leadList.get(i).Commercial_Account__c != null)
                                            oppsList.get(j).OwnerId=leadList.get(i).Reseller__r.OwnerId;
                                            // oppsList.get(j).OwnerId=leadList.get(i).Commercial_Account__r.OwnerId 
                                        if(leadList.get(i).Amount__c!=null) 
                                            oppsList.get(j).Reseller_Estimated_Value__c=leadList.get(i).Amount__c;    
                                        /*if(leadList.get(i).Expected_Close_Date__c!=null) 
                                            oppsList.get(j).Reseller_Close_Date__c=leadList.get(i).Expected_Close_Date__c; */
                                        if(leadList.get(i).Product__c!=null) 
                                            oppsList.get(j).Reseller_Product_Name__c=leadList.get(i).Product__c; 
                                        oppsList.get(j).Deal_Expiration_Date__c=Date.Today()+120;
                                        if(leadList.get(i).Lead_Record_Type__c!=null) 
                                            oppsList.get(j).source__c=leadList.get(i).Lead_Record_Type__c;
                                        system.debug('oppsList.get(j).source__c'+oppsList.get(j).source__c);
                                        system.debug('oppsList.get(j).Lead_Record_Type__c'+leadList.get(i).Lead_Record_Type__c);
                                        oppsList.get(j).DealIsConverted__c =true;

                                        if(leadList.get(i).Deal_Registration_Name__c!=null) 
                                            oppsList.get(j).name=leadList.get(i).Deal_Registration_Name__c;  

                                }
                                
                            System.debug('oppsList.get(j).RecordTypeId after =='+oppsList.get(j).RecordTypeId);
                            System.debug('oppsList.get(j).Deal_Type__c after =='+oppsList.get(j).Deal_Type__c);
                            if(!leadList.get(i).BU__c.equalsIgnoreCase('RMDM') && !leadList.get(i).BU__c.equalsIgnoreCase('ISBU'))
                            {
                            if(leadList.get(i).Distributor__c != null) 
                                  oppsList.get(j).type = SystemIdUtility.getValueDealTypeWithDistributor();
                            else
                                  oppsList.get(j).type = SystemIdUtility.getValueDealType();  
                                  System.debug('oppsList.get(j).type after =='+oppsList.get(j).type);
                            }
                           //HEENA CHANGES ends for lead conversion req prm 2
                            // update the opp. Milestone
                            if(leadList.get(i).BU__c == 'RMDM' || leadList.get(i).BU__c == 'ISBU')
                                oppsList.get(j).StageName = SystemIdUtility.getVolOppMilestone();
                            else if(leadList.get(i).BU__c == 'Value')
                                oppsList.get(j).StageName = SystemIdUtility.getValueOppMilestone();
                        
                            // update the opp. Account
                            //Heena Added condition to bypass New Opportunity record type in PRM R2 for Defect 48522
                            //if(!SystemIdUtility.IsDeal_RegistrationRecordType(leadList.get(i).RecordTypeId)&&(!SystemIdUtility.IsNew_OpportunityRecordType(oppsList.get(j).RecordTypeId))) 
                            if(!SystemIdUtility.IsDeal_RegistrationRecordType(leadList.get(i).RecordTypeId)&& oppsList.get(j).RecordTypeId!=SystemIdUtility.getDealRegistrationOpportunityRecordTypeId()
                                 &&(!SystemIdUtility.IsNew_OpportunityRecordType(oppsList.get(j).RecordTypeId)))
                                oppsList.get(j).AccountId = leadList.get(i).Reseller__c;
                             
                             // map the ISOCurrencyCode    
                             if(leadList.get(i).CurrencyIsoCode != null) 
                                oppsList.get(j).CurrencyIsoCode = leadList.get(i).CurrencyIsoCode;      
                            
                            // map the Reseller_Estimated_Value__c on the lead to opp. amount and opp. reseller est. amount
                            if(leadList.get(i).Reseller_Estimated_Value__c != null)
                            {
                                oppsList.get(j).Amount = leadList.get(i).Reseller_Estimated_Value__c;
                                oppsList.get(j).Reseller_Estimated_Value__c = leadList.get(i).Reseller_Estimated_Value__c;
                            }
                            
                            // map the reseller close date to opp. close date & opp. reseller close date
                            if(leadList.get(i).Reseller_Close_Date__c != null && leadList.get(i).Reseller_Close_Date__c > Date.today())
                            {
                                oppsList.get(j).CloseDate = leadList.get(i).Reseller_Close_Date__c;                 
                                oppsList.get(j).Reseller_Close_Date__c = leadList.get(i).Reseller_Close_Date__c;                    
                            }
                            // update the opportunity success flag
                            oppsList.get(j).Auto_Lead_Conversion_Status__c = 'Success';                
        
                            //Related to CR:13865765
                            //update the opportunity's Lead id field (added by Afzal on 9th June 2009)
                            //BEGIN
                            oppsList.get(j).Lead_ID__c = leadList.get(i).Id;
                            //END 
        
                            break;  
                        }
                    }
                }
            
                System.debug(logginglevel.Debug,'3 : The oppList is :'+oppsList);
                
                // upsert all the opportunity records
                try
                {    
                    //setting the opt_allOrNoneparameter to false because even if 1 record update fails, 
                    //the remainder of the DML operation need to succeed
                    System.debug('oppsList after =='+oppsList);
                    Database.SaveResult[] oppUpdateResult = Database.update(oppsList,false); 
                    for(Database.SaveResult res:oppUpdateResult)
                    {
                        if(res.IsSuccess()==false)
                        {
                            System.debug(logginglevel.Debug,'Failed to Update Opportunity: '+res.errors[0].Message);
                        }
                    }
                }
                catch(DmlException dmlEx) {
                    System.debug(logginglevel.Debug,'DmlException is : '+dmlEx);
                    // catch any DML exception during the upsert call   
                }    
                // process the oppUpdateResult here ....
                
        //Req 537 copying Lead Product information to Opportunity Line Item Information
        //Accenture IDC Balasaheb Wani 24 Aug,2010
        //Functionality Description It will extract data from Lead Product fields and Create corresponding Opportunity Line Item entries after Lead Conversion
        //Price Book Used is CA Product List
        //Total # of SOQL 2
        //Total # of DML 1
        //***************Starts ********
        //System.debug('--------Lead LIST -----' + leadList);
        //System.debug('--------OPPORTUNITY LIST ---' +oppsList);
        //System.debug('--------OPPORTUNITY LIST ---SIZE ' +oppsList.size() + '-----------LEAD SIZE-------' + leadList.size());
        List<OpportunityLineItem> lstOplineItems=new List<OpportunityLineItem>();
        String strCAPriceBookId=[Select p.Name, p.IsActive, p.Id From Pricebook2 p where p.Name ='CA Product List' limit 1].Id;
        for(integer i = 0;i < leadList.size();i++) 
        {
            for(integer j = 0;j<oppsList.size();j++) 
            {
                if(oppsList.get(j).Id == leadList.get(i).ConvertedOpportunityId)
                {
                   //System.Debug('-----------INSIDE INNER LOOOP -------------');
                   //System.Debug('-------------Products STRING-----------'+leadList.get(i).Product__c);
                   //Check for Product string , If product String is Null
                   // Then Skip OPL creation
                    if(leadList.get(i).Product__c != null )
                    {
                        String arrProdsLines=leadList.get(i).Product__c;
                        // Extract Products ID from Product string and Put them into Set , It will used for querying Pricbook entry 
                        // 1 SOQL 
                        set<Id> prdIds = new set<Id>();
                        for(string strPrdIdPair : arrProdsLines.split('='))
                        {
                            if(strPrdIdPair.split(':')[0].toLowerCase().startsWith('01t3')) // Check if it is a valid product
                                    prdIds.add(strPrdIdPair.split(':')[0]);
                        }
                     //  System.Debug('Set off products Id---------------------' + prdIds);
                     // System.debug('Opporunity fields--------------Price Book===='+oppsList.get(j).Pricebook2Id+'=====CURRENCY CODE======'+oppsList.get(j).CurrencyIsoCode);
                       string strPriceBookId='';
                       //If PriceBook Entry in Opportunity is Blank , Then use 'CA Product List' as price book 
                       if(oppsList.get(j).Pricebook2Id== null)
                       {
                          //strPriceBookId=[Select p.Name, p.IsActive, p.Id From Pricebook2 p where p.Name ='CA Product List' limit 1].Id;
                          strPriceBookId=strCAPriceBookId;
                       }
                        // Adding pricebooks and Respective ProductId in Map 
                        Map<Id,PricebookEntry> mapPbe=new Map<Id,PricebookEntry>();
                        for(PricebookEntry pbe :[Select p.Id,p.Product2Id, p.Pricebook2Id, p.Name From PricebookEntry p where p.Product2Id in : prdIds and p.Pricebook2Id=: strPriceBookId  and p.CurrencyIsoCode=:oppsList.get(j).CurrencyIsoCode and p.IsActive = true])
                            {
                                mapPbe.put(pbe.Product2Id,pbe);
                            }
                     //   System.debug('Map of Price Book Entries------------------' + mapPbe);
                        // mapPbe Contains products Id and Corresponding PriceBookEntries
                        //Opporunity Line Item for each Products Id 
                        for(string strPrdIdPair : arrProdsLines.split('='))
                        {
                          if(strPrdIdPair.split(':')[0].toLowerCase().startsWith('01t3')) // Check if it is a valid product
                            if(mapPbe.containsKey(strPrdIdPair.split(':')[0]))
                            {
                       //       System.Debug('----------Inside OPL BLOCK---------------------');
                                OpportunityLineItem objOpl=new OpportunityLineItem();
                                //added as per CR:189787411 by Saba
                                if ( leadList[i].Deal_Registration__c != Null && leadList[i].Deal_Registration__c ==true )
                                    objOpl.Business_Type__c  = 'NCV';
                                
                                objOpl.OpportunityId=oppsList.get(j).Id;
                                objOpl.PricebookEntryId=mapPbe.get(strPrdIdPair.split(':')[0]).Id;
                                objOpl.UnitPrice=decimal.valueOf(strPrdIdPair.split(':')[1]);       
                                lstOplineItems.add(objOpl);
                            }
                        }
                    }
                }
            }
        }
        //System.debug('List off Opportunity Line Items----------------To Insert -----'+lstOplineItems);
        //Adding to Database
        //If Op Line Item List contains some data , pushed to database
        if(lstOplineItems.size() > 0)
        {
            try
            {    
                    Database.SaveResult[] oppLineItemtResult =Database.insert(lstOplineItems); 
                for(Database.SaveResult res:oppLineItemtResult)
                {
                    if(res.IsSuccess()==false)
                    {
                        System.debug(logginglevel.Debug,'Failed to Update Opportunity Line Items: '+res.errors[0].Message);
                    }
                }
            }
            catch(DmlException dmlEx)
            {
                System.debug(logginglevel.Debug,'DmlException is : '+dmlEx);
                // catch any DML exception during the upsert call   
            }
        }   
         //**********Req 537Ends here *******
            }
            System.debug('coming outside of future processor');
    }
    
    
    static testMethod void testFutureProcessor() {
    SystemIdUtility.skipOpportunityTriggers = true;
SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        FutureProcessor fp = new FutureProcessor();

           Account acc1 = new Account();
            acc1.Name = 'idc test acc';
            acc1.BillingState = 'NY';
            acc1.BillingStreet = 'Arlington';
            acc1.BillingCountry = 'US';
            acc1.BillingCity = 'VA';
            acc1.Aggregate_Account__c = 'Yes';
            insert acc1;
       Date d = date.today();
        
       TAQ_Account__c newacc5=new TAQ_Account__c();
            
            newacc5.name='test acc';
            newacc5.View_Acc_Record__c=acc1.id;
            newacc5.Enterprise_Id__c='EA0520';
            newacc5.Enterprise_Account_Name__c='idc test acc';
     //FY 13       newacc5.Market__c='testm';
            newacc5.Region__c='EMEA';
            newacc5.Area__c='testa';
            newacc5.Territory__c='testt';
            newacc5.Country__c='testc';
            newacc5.Account_Type__c='test type';
    //FY 13        newacc5.Account_Class__c='Class 4';
            
            newacc5.Industry_Vertical__c='test ind';
            newacc5.Stock_Ticker__c='test tick';
            newacc5.Comments__c='testcom';
       
            newacc5.Area_for_Data_Load__c='testa';
            newacc5.Territory_For_Data_Load__c='nordics';
            newacc5.Country_for_Data_Load__c='United States';
     // FY 13        newacc5.Market_for_Data_Load__c='test';
            newacc5.Approval_Process_Status__c='Migrated';
            
            insert newacc5;
           // User u = [select id from user where isactive = true limit 1];
           // futureprocessor.AccTriggerActionsInFuture(newacc5.id,u.id);
            Lead leadrec = new Lead(LastName = 'TestLead', Company = 'Test_CA_ITC', MKT_BU_Category__c = 'N/A', MKT_Solution_Set__c = 'Clarity',Opportunity_Deal_Type__c='IND-ISBU', GEO__c = 'NA', MKT_Territory__c= 'EAST', Sales_Territory__c = 'EA_CANADA', Country__c= 'EA_CANADA', Country_Picklist__c = 'CA - CANADA', Preferred_Reseller__c='Test Reseller');
            insert leadrec;
    
            Lead leadrec1 = new Lead(LastName = 'TestLead', Company = 'Test_CA_ITC', MKT_BU_Category__c = 'Other', MKT_Solution_Set__c = 'N/A',Opportunity_Deal_Type__c='IND-RMDM', GEO__c = 'NA', MKT_Territory__c= 'EAST', Sales_Territory__c = 'EA_CANADA', Country__c= 'EA_CANADA', Country_Picklist__c = 'CA - CANADA', Preferred_Reseller__c='Test Reseller');
            insert leadrec1;
        
            List<lead> lstld = [Select id, ConvertedOpportunityId from lead where BU__c in ('RMDM','ISBU') and isconverted = true and product__c like '%01t3%' limit 10];
            List<string> lstLead = new List<string>();
            Set<string> convertedOppIds = new Set<string>();
            
            for(lead l: lstld)
                {
                lstLead.add(l.id);
                convertedOppIds.add(l.ConvertedOpportunityId);
                }
                
            futureprocessor.UpdateOpportunity_OnLeadConversion(lstLead, convertedOppIds);
            futureprocessor.UpdateOpportunityOnLeadConversion_Future(lstLead, convertedOppIds);
            futureprocessor.UpdateOpportunityOnLeadConversion(lstLead, convertedOppIds);

        
    }
}