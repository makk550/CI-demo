/**
Class Name: PLM_UpdateScorecard

Date: 5/28/2010

Project/Requirement: CA PRM Phase 1/PLM

Author: Accenture

Description: This class is called from "Refresh Scorecard" button on partner account details page.
This class refreshes/creates the Scorecard for the partner account.
*/


global class PLM_UpdateScorecard{
    
    //variable declarations
    Scorecard__c newSC;
    Scorecard__c oldSC;
    List<Account> accList = new List<Account>();
    
    List<Scorecard__c> scorecardList;
    List<Accreditation__c> certList;

    Map<String,String> accScorecardMap = new Map<String,String>();
    Map<String,List<Accreditation__c>> accCertsMap = new Map<String,List<Accreditation__c>>();

    Integer salesEnable = 0;
    Integer techEnable = 0;
    String partnerId = '';
    String programLevel = '';  
    
    String techAccRecTypeId = '';
    String valAccRecTypeId = '';
    String techSCRecTypeId = '';
    String valSCRecTypeId = '';
    
    /**
     *  webservice method: This method is called from the Refresh Scorecard button.
     *  @param String
     *  return type : void
     */
   webService static void updateScorecard(String accId){
        List<String> accIdNewSCList = new List<String>();
        List<String> accIdOldSCList = new List<String>();
        List<Scorecard__c> exSCList = new List<Scorecard__c>();
        PLM_UpdateScorecard classObj = new PLM_UpdateScorecard();
        for(Scorecard__c sc: [SELECT Id FROM Scorecard__c WHERE Partner__c =: accId]){
            exSCList.add(sc);                 
        }
        if(exSCList.size() == 0)classObj.newScorecard(accId);
        else classObj.oldScorecard(accId);
    }

    /**
     * creation of new scorecard: This method prepares lists and maps of revenues and certifications for the account to map with
     * the scorecard.
     *  @param String
     *  return type : void
     */
   public void newScorecard(String accIdNewSC){
        newSC = new Scorecard__c();

         for(Accreditation__c rev: [SELECT Sales_Course_Technical_Exam__c, Product__c, Partner__c, Id, Date__c, CurrencyIsoCode, Course_Exam_Name__c, Contact_Name__c FROM Accreditation__c WHERE Partner__c =: accIdNewSC]){
            certList = new List<Accreditation__c>();
            if(accCertsMap.containsKey(rev.Partner__c)){
                certList = accCertsMap.get(rev.Partner__c);
                certList.add(rev);
            }else{
                certList.add(rev);
            }
            accCertsMap.put(rev.Partner__c,certList);
        }
        //Query account fields for new scorecard
        for(Account ac: [SELECT Id,Name,Program_Level_techpartner__c,Program_Level__c,Customer_Category__c,RecordTypeId,
            Completion_of_NDA__c,Completion_of_Partner_Agreement__c,Completion_of_DLA__c,BU_Approval__c,
            Completion_of_Product_Integration__c,Partner_BU_Agree_to_proceed_Develop__c,Completion_of_Validation__c,
            Completion_of_a_Self_Running_Demo__c,Completion_of_Partner_Spotlight__c,Completion_of_Solution_Catalog_Submissio__c,
            Completion_of_a_Press_Release__c,Completion_of_Customer_Success_Story__c,Completion_of_Three_References_of_the_In__c,
            Partner_s_Webpage_linked_to_CA_Products__c,Completion_of_Collateral_for_Solution__c,
            Partner_BU_Agree_to_proceed_Validate__c,Provide_Partner_Kit__c,Agreement__c,PDS_Addendum__c,
            Partner_Enablement_Addendum__c,Partner_Agreement_Attached__c,DLA_Attached__c,Agreement_Attached__c,
            Business_Plan_Attached__c,PDS_Addendum_Attached__c,Partner_Enablement_Addendum_Attached__c,Partner_Spotlight_Attached__c,
            Solution_Catalog_Submission_Attached__c,Press_Release_Attached__c,Customer_Success_Story_Attached__c
            FROM Account WHERE Id =: accIdNewSC]){
            processNew(ac,accCertsMap.get(ac.Id));           
        }
    }

    /**
     * update of existing scorecard: This method prepares lists and maps of revenues and certifications for the account to map with
     * the scorecard
     *  @param String
     *  return type : void
     */
   public void oldScorecard(String accIdNewSC){
        oldSC = [SELECT Three_References_of_Integrated_Solution__c, Total_Technical_Exams_Passed__c, Solution_Catalog_Submission_Completed__c, Total_Sales_Course_Completed__c, RecordTypeId, Partner_s_Webpage_linked_to_CA_Products__c, Partner__c, Partner_BU_Agree_to_proceed_Validate__c, Partner_BU_Agree_to_proceed_Develop__c, Id, Current_Program_Level__c, CurrencyIsoCode, Completion_of_a_Self_Running_Demo__c, Completion_of_a_Press_Release__c, Completion_of_Validation__c, Completion_of_Product_Integration__c, Completion_of_Partner_Spotlight__c, Completion_of_Partner_Agreement__c, Completion_of_NDA__c, Completion_of_DLA__c, Completion_of_Customer_Success_Story__c, Completion_of_Collateral_for_Solution__c, BU_Approval__c, Account_Type__c FROM Scorecard__c WHERE Partner__c =: accIdNewSC];

        for(Accreditation__c rev: [SELECT Sales_Course_Technical_Exam__c, Product__c, Partner__c, Id, Date__c, CurrencyIsoCode,     Course_Exam_Name__c, Contact_Name__c FROM Accreditation__c WHERE Partner__c =: accIdNewSC]){
            certList = new List<Accreditation__c>();
            if(accCertsMap.containsKey(rev.Partner__c)){
                certList = accCertsMap.get(rev.Partner__c);
                certList.add(rev);
            }else{
                certList.add(rev);
            }
            accCertsMap.put(rev.Partner__c,certList);
        }

        for(Account ac: [SELECT Id,Name,Program_Level_techpartner__c,Program_Level__c,Customer_Category__c,RecordTypeId,
            Completion_of_NDA__c,Completion_of_Partner_Agreement__c,Completion_of_DLA__c,BU_Approval__c,
            Completion_of_Product_Integration__c,Partner_BU_Agree_to_proceed_Develop__c,Completion_of_Validation__c,
            Completion_of_a_Self_Running_Demo__c,Completion_of_Partner_Spotlight__c,Completion_of_Solution_Catalog_Submissio__c,
            Completion_of_a_Press_Release__c,Completion_of_Customer_Success_Story__c,Completion_of_Three_References_of_the_In__c,
            Partner_s_Webpage_linked_to_CA_Products__c,Completion_of_Collateral_for_Solution__c,
            Partner_BU_Agree_to_proceed_Validate__c,Provide_Partner_Kit__c,Agreement__c,PDS_Addendum__c,
            Partner_Enablement_Addendum__c,Partner_Agreement_Attached__c,DLA_Attached__c,Agreement_Attached__c,
            Business_Plan_Attached__c,PDS_Addendum_Attached__c,Partner_Enablement_Addendum_Attached__c,Partner_Spotlight_Attached__c,
            Solution_Catalog_Submission_Attached__c,Press_Release_Attached__c,Customer_Success_Story_Attached__c
            FROM Account WHERE Id =: accIdNewSC]){
            processOld(oldSC,ac,accCertsMap.get(ac.Id));           
        }
    }
        
        /**
         * process new scorecard and map fields of scorecard to fields of Account, revenue and certification.
         * @param Account
         * @param List<Accreditation__c>
         */
      public void processNew(Account acc,List<Accreditation__c> certs){
            //method call to map account fields
            mapAccountFields(newSC,acc);
            
            if(certs != null && certs.size() > 0){
                for(Accreditation__c c: certs){
                    if(c.Sales_Course_Technical_Exam__c == 'Sales Course')salesEnable++;    
                    else if(c.Sales_Course_Technical_Exam__c == 'Technical Exam')techEnable++;
                }
            }

            newSC.Partner__c = acc.Id;
            
            try{
                //map certifications fields
                newSC.Total_Sales_Course_Completed__c = salesEnable;
                newSC.Total_Technical_Exams_Passed__c = techEnable;
                insert newSC;
            }catch(Exception e){
                System.debug('Something went wrong: '+e);
            }
        }

        /**
        process old scorecard and map fields of scorecard to fields of Account, revenue and certification
        * @param Scorecard__c
        * @param Account
        * @param List<Accreditation__c>
        */
       public void processOld(Scorecard__c sc,Account acc,List<Accreditation__c> certs){
            //method call to map account fields
            mapAccountFields(sc,acc);

            if(certs != null && certs.size() > 0){
                for(Accreditation__c c: certs){
                    if(c.Sales_Course_Technical_Exam__c == 'Sales Course')salesEnable++;    
                    else if(c.Sales_Course_Technical_Exam__c == 'Technical Exam')techEnable++;
                }
            }                        
            
            try{
                //map certifications fields
                sc.Total_Sales_Course_Completed__c = salesEnable;
                sc.Total_Technical_Exams_Passed__c = techEnable;               
                update sc;
            }catch(Exception e){
                System.debug('Something went wrong: '+e);
            }
        }
        
        /**
         *This methods maps Scorecard fields with appropriate Account fields
         * @param Scorecard__c
         * @param Account
        */
        public void mapAccountFields(Scorecard__c sc,Account acc){
    
            try{
                //getting account record types by using schema
                Map<String, Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String, Schema.RecordTypeInfo>();
                //retrive account object record types
                mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
                //get Ids of record type by passing name of record type.
                Schema.RecordTypeInfo recTypeInfoTech = mapRecTypeInfoAcc.get('Technology Partner');
                Schema.RecordTypeInfo recTypeInfoVal = mapRecTypeInfoAcc.get('Reseller/Distributor Account');
                techAccRecTypeId  = recTypeInfoTech.getRecordTypeId();
                valAccRecTypeId  = recTypeInfoVal.getRecordTypeId();
                
                //getting scorecard record types by using schema
                Map<String, Schema.RecordTypeInfo> mapRecTypeInfoSC = new Map<String, Schema.RecordTypeInfo>();
                //retrive scorecard object record types
                mapRecTypeInfoSC = Schema.SObjectType.Scorecard__c.getRecordTypeInfosByName();
                //get Ids of record type by passing name of record type.
                Schema.RecordTypeInfo recTypeInfoSCTech = mapRecTypeInfoSC.get('Technology Partner Scorecard');
                Schema.RecordTypeInfo recTypeInfoSCVal = mapRecTypeInfoSC.get('Value Partner Scorecard');
                techSCRecTypeId  = recTypeInfoSCTech.getRecordTypeId();
                valSCRecTypeId  = recTypeInfoSCVal.getRecordTypeId();

                //map the record type of account and scorecard
                if(acc.RecordTypeId == techAccRecTypeId){
                    sc.RecordTypeId = techSCRecTypeId;
                    sc.Current_Program_Level__c = acc.Program_Level_techpartner__c;
                }else {
                    sc.RecordTypeId = valSCRecTypeId;
                    sc.Current_Program_Level__c = acc.Program_Level__c;
                }

                //partner details mapping
                sc.Account_Type__c = acc.Customer_Category__c;

                //partner checklist fields mapping
                sc.Completion_of_NDA__c = acc.Completion_of_NDA__c;
                sc.Completion_of_Partner_Agreement__c = acc.Completion_of_Partner_Agreement__c;
                sc.Completion_of_DLA__c = acc.Completion_of_DLA__c;
                sc.BU_Approval__c = acc.BU_Approval__c;
                sc.Completion_of_Product_Integration__c = acc.Completion_of_Product_Integration__c;
                sc.Partner_BU_Agree_to_proceed_Develop__c = acc.Partner_BU_Agree_to_proceed_Develop__c;
                sc.Completion_of_Validation__c = acc.Completion_of_Validation__c;
                sc.Completion_of_a_Self_Running_Demo__c = acc.Completion_of_a_Self_Running_Demo__c;
                sc.Completion_of_Partner_Spotlight__c = acc.Completion_of_Partner_Spotlight__c;
                sc.Solution_Catalog_Submission_Completed__c = acc.Completion_of_Solution_Catalog_Submissio__c;
                sc.Completion_of_a_Press_Release__c = acc.Completion_of_a_Press_Release__c;
                sc.Completion_of_Customer_Success_Story__c = acc.Completion_of_Customer_Success_Story__c;
                sc.Three_References_of_Integrated_Solution__c = acc.Completion_of_Three_References_of_the_In__c;
                sc.Partner_s_Webpage_linked_to_CA_Products__c = acc.Partner_s_Webpage_linked_to_CA_Products__c;
                sc.Completion_of_Collateral_for_Solution__c = acc.Completion_of_Collateral_for_Solution__c;
                sc.Partner_BU_Agree_to_proceed_Validate__c = acc.Partner_BU_Agree_to_proceed_Validate__c;
            }catch(Exception ex){
                System.debug('Something went wrong: '+ex);
            }
    }
}