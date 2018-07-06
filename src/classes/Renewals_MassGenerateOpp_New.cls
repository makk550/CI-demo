public class Renewals_MassGenerateOpp_New {
  
    public String segmentation {get;set;}
    public Renewal__c ac{get;set;}
    public integer countRenewals;
    public integer countOpps;
    string currencycode;
    boolean flag;
   
    
        List<String> selectedIds = new List<String>();    

     public Decimal BatchNumber {get;set;}
     
     

    public string showErrorlogButton {get; set;}
    public Map<String, String> errorLog { get; set; }    
    public Map<String, String> geterrorLog() {

        return errorLog;
    }
    
     public String backToTab {get;set;}

    
 public Renewals_MassGenerateOpp_New ()
    {
        showErrorlogButton = 'hidden';
        errorLog = new Map<String, String>();      
          backToTab  = '/a1z/o';
         ac = new Renewal__c();
     
    }   
    
 public List<SelectOption> getItems() {
     // Based on Req. 10.09, LT Option is added by santhanam
        List<SelectOption> options = new List<SelectOption>();
     
        options.add(new SelectOption('HT,MT,LT','ALL'));
        options.add(new SelectOption('HT','HT'));
        options.add(new SelectOption('MT','MT'));
        options.add(new SelectOption('LT','LT'));
        return options;
    
    }
    
    //added by Vasantha
    public void RenewalConv(){
        
        List<string> segmen = segmentation.split(',');
        Renewal_MassOpportunityConv rc = new Renewal_MassOpportunityConv();
        Date dt1;
        Date dt2;
        
        SystemIdUtility.skipTrigger  = true;
        //errorlog = rc.Renewal_ConvertRenewalsMain('listView',dt1,dt2,'');
        //errorlog = convRenewals();
                                  
        
        Renewal__c[] rnwls_orig =[
            select id , 
                   Segmentation__c,
                   name,
                   Account__c,
                   OwnerId,
                   Expected_Close_Date__c,
                   Converted_To_Opportunity__c,
                   Overall_Comments__c,
                   CurrencyIsoCode,
                   Projected_Time_Duration_Months__c,
                   OCV__c,
                   Annual_OCV_LC__c,
                   Sold_to_Ship_to_Party_Site_ID__c,
                   Projected_Renewal__c,
                   Local_Currency__c, Territory__c, // FY14 - was Territory_Country__c
                   New_Site_Id__c,Owner.id ,
                   Reason_duration_is_1_year__c,Status_at_end_of_term__c // AR 3051
              from Renewal__c 
             where segmentation__c in:segmen 
               and Expected_Close_Date__c >=: ac.ChangeDate__c 
               and Expected_Close_Date__c <=: ac.Expected_Close_Date__c 
               and Converted_To_Opportunity__c = false 
             limit 1000];
             
       if(rnwls_orig <> null && rnwls_orig.size() > 0)
        for(Renewal__c r: rnwls_orig)
        {
          selectedIds.add(r.id);
        }
        
        List<Renewal__c> selIds = [select id from Renewal__c where Id in :selectedIds];
                 	Set<Id> selectdIds = (new Map<Id,Renewal__c>(selIds)).keySet(); //samap01                                            
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
        
                    BatchNumber  = BatchNumber + 1 ;
                    batchRenewalConv btRenewalConv = new batchRenewalConv(selectdIds , BatchNumber);
                    
                    ID batchprocessid  = database.executeBatch(btRenewalConv,1);
                    
                    showErrorlogButton = 'inline'; 
             }
             else
             {
                 Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Records cannot be processed now .Please try after somtime.'));
             }
                              
        
        //return null;   
        
    }   
    
    
 public PageReference Convert() {
    
    
      errorLog.clear();
        if(ac.ChangeDate__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select start date.'));

        if(ac.Expected_Close_Date__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select end date.'));

        countRenewals = 0;
        countOpps = 0;

        ////massgenerate(ac.ChangeDate__c,ac.Expected_Close_Date__c,segmentation);
        
        RenewalConv();
        
        ///ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Completed Execution. Renewals Processed: ' + countRenewals + ', Opportunities Created: ' + countOpps ));
        
        //// showErrorlogButton = 'inline';
        
        return null;
    }
    
 public void MassGenerate(date startDate , date endDate , string seg){
showErrorlogButton = 'hidden';
    List<string> segmen = seg.split(',');
    
    Renewal__c[] rnwls_orig =[
            select id , 
                   Segmentation__c,
                   name,
                   Account__c,
                   OwnerId,
                   Expected_Close_Date__c,
                   Converted_To_Opportunity__c,
                   Overall_Comments__c,
                   CurrencyIsoCode,
                   Projected_Time_Duration_Months__c,
                   OCV__c,
                   Annual_OCV_LC__c,
                   Sold_to_Ship_to_Party_Site_ID__c,
                   Projected_Renewal__c,
                   Local_Currency__c, Territory__c, // FY14 - was Territory_Country__c
                   New_Site_Id__c,Owner.id, 
                   Reason_duration_is_1_year__c,Status_at_end_of_term__c // AR 3051
              from Renewal__c 
             where segmentation__c in:segmen 
               and Expected_Close_Date__c >=: startDate 
               and Expected_Close_Date__c <=: endDate 
               and Converted_To_Opportunity__c = false 
             limit 1000];
    
    //FY13 start - retrieve the territory id from the standard territory object
    Set<string> setTerritory = new Set<String>();

    if(rnwls_orig <> null && rnwls_orig.size() > 0)
        for(Renewal__c r: rnwls_orig)
        {
//FY14     setTerritory.add(r.Territory_country__c);
            setTerritory.add(r.Territory__c); //FY14
        }

    Map<string,Id>  mapTerr = new Map<String,Id>();

//FY14    for(Territory t:[Select id,Territory_Country__c from Territory where Territory_Country__c in: setTerritory])
    for(Territory t:[Select id, Country__c from Territory where Country__c in: setTerritory]) //FY14
    {
//FY14  mapTerr.put(t.Territory_Country__c, t.Id);
        mapTerr.put(t.Country__c, t.Id); //FY14

    }     
    
    //FY13 end

    countRenewals = rnwls_orig.size();

    if(countRenewals >= 1000)
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Opportunity generation is limited to 1,000 Renewals per execution. This limit was reached, so another execution with these parameters may be necessary.'));
                  
    Account acc;
    List<Renewal__c> rnwls = new List<Renewal__c>();
    Map<Id, Renewal__c> rnwlsMap = new Map<Id, Renewal__c>();
    
    if(rnwls_orig <> null && rnwls_orig.size() > 0)
    {
        Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        List<Opportunity> lstOpp = new List<Opportunity>();
        integer count = 0;

        // Define an opportunity for each Renewal
        for(Renewal__c rnwl :rnwls_orig){

            acc=new Account(id=rnwl.Account__c);

             // Based on Req. 10.09, LT Option is added by subsa03
            if(rnwl.Converted_To_Opportunity__c == true ||
               (rnwl.Segmentation__c != 'HT' && 
                rnwl.Segmentation__c != 'MT' && 
                rnwl.Segmentation__c != 'LT'))
                continue;

            rnwls.add(rnwl);
            rnwlsMap.put(rnwl.Id, rnwl);

            // Based on Req. 10.09, LT Option is added by subsa03
            String BusinessType;
            currencycode = rnwl.Local_Currency__c;
            if(rnwl.Segmentation__c == 'HT')
                BusinessType = 'High Touch';
            else if(rnwl.Segmentation__c == 'MT')
                BusinessType = 'Medium Touch';
            else if(rnwl.Segmentation__c == 'LT')
                BusinessType = 'Low Touch';
            else if(rnwl.Segmentation__c == 'NT')
                BusinessType = 'No Touch';
            else 
                BusinessType = 'Unknown';    

            // FY13 - Set oppty close date to a date >= current date
            Date expCloseDate;
            if(rnwl.Expected_Close_Date__c >= date.today())
                expCloseDate = rnwl.Expected_Close_Date__c;
            else
                expCloseDate = date.today();
    
//            System.debug('DEBUG_RMGO: rnwl.Projected_Renewal__c' +rnwl.Projected_Renewal__c);
                    
            Opportunity opp = 
                          new Opportunity(name = rnwl.name, 
                                          AccountId = rnwl.Account__c, 
                                          CloseDate = rnwl.Expected_Close_Date__c,
                                          Description = rnwl.Overall_Comments__c, 
                                          New_Site_Id__c = rnwl.New_Site_Id__c, 
                                          CurrencyIsoCode = rnwl.Local_Currency__c, 
                                          StageName=Label.Opp_Stage_20_Percent, //US149780 BY SAMTU01
                                          New_Deal_Term_months__c = rnwl.Projected_Time_Duration_Months__c,
                                          Stretch_Deal_Term_Months__c=rnwl.Projected_Time_Duration_Months__c,
                                          OwnerId = rnwl.OwnerId,
                                          Original_CV__c = rnwl.OCV__c, 
                                          Site_ID__c = rnwl.Sold_to_Ship_to_Party_Site_ID__c,
                                          Type = 'Direct', 
                                          RPD_Status__c = 'Requested',
                                          RecordTypeId = recId,
                                          Renewal__c = rnwl.id,
                                          Business_Type__c = BusinessType,
                                          Projected_Renewal__c = rnwl.Projected_Renewal__c,
                                           //likely flag set to true on opportunity
                                          RoadmapToPlan__c=true //US421493 - MERHA02


// FY13                                          ,Comfort__c = rnwl.Projected_Renewal__c
                                          );


         //AR 3051
                   If(rnwl.Reason_duration_is_1_year__c!=null && rnwl.Status_at_end_of_term__c!=null)
                   {
                         opp.Reason_duration_is_1_year__c = rnwl.Reason_duration_is_1_year__c ;
                         opp.Status_at_end_of_term__c = rnwl.Status_at_end_of_term__c ;
                           
                    }

            //FY13 - Get the Territory Id based on Territory Name and assign it to Opp - start 
            Territory terr;
            //FY14      if(rnwl.Territory_Country__c <> null && mapTerr.get(rnwl.Territory_Country__c) <> null)
//FY14          opp.TerritoryId = mapTerr.get(rnwl.Territory_Country__c);
            if(rnwl.Territory__c <> null && mapTerr.get(rnwl.Territory__c) <> null) //FY14
                opp.TerritoryId = mapTerr.get(rnwl.Territory__c); //FY14

            //FY13 - end

            lstOpp.add(Opp);
            }
        countRenewals = rnwls.size();

        // Insert opportunities
        Map<id,Opportunity> mapOppRen = new Map<id,Opportunity>();
        if(lstOpp.size() > 0){
            SystemIdUtility.skipTrigger  = true; 
           
            updateRnwlFields_Mass(lstOpp,rnwlsMap,mapOppRen);  
         
            // SystemIdUtility.skipTrigger  = false;
            }
        }
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

 public void updateRnwlFields_Mass(List<Opportunity> lstO, Map<Id, Renewal__c> lstrnwlMap, Map<id,Opportunity> mO) {
       
    set<id> setRen = new Set<id>();
     showErrorlogButton = 'hidden';   
    for(renewal__c rnwl:lstrnwlMap.values())
        setRen.add(rnwl.id); 
        
    try{ 

        // Code added to perform one-time lookup of PriceBook Entries (avoid 100 query SOQL limit)
        Map<Id,Id> validRenewalLookup = new Map<Id,Id>();
        Map<Id,PricebookEntry> acpToPriceBookEntryMap = new Map<Id,PricebookEntry>();
        Map<Id,Id> prodPBELookup = new Map<Id,Id>();
        Map<String,String> currPBELookup = new Map<String,String>();
        Set<String> prodCurrPBELookup = new Set<String>();
        Map<String,Id> prodCurrPBEItem = new Map<String,Id>();

        List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
        List<OpportunityLineItem> RnwlOppLnItm = new List<OpportunityLineItem>(); // Based on Renewals ph 3 req 1.06 this has been added by subsa03
              
        //get all ACPs associated with the renewal and change the status of the field Converted To Opportunity to true;     
        // Check all ACP associated with the Renewal. If there are no ACP with Converted_to_Opportunity = false, 
        // do not create oppty (because ACPs are already on another oppty. - lfc - 03Mar2012
        List <Active_Contract_Product__c> ACP =
             [Select Id, 
                     name, 
                     Active_Contract_Number__c, 
                     Dismantle_Date__c, 
                     ATTRF_CRV__c, 
                     AOCV__c, OCV__c, 
                     Sales_Price__c,
                     Raw_Maint_Calc_LC__c, 
                     Projected_Renewal_Calc__c,
                     Segmentation__c,
                     Pre_Segmentation__c,
                     Converted_To_Opportunity__c, 
                     Product__c, 
                     Product__r.Name, 
                     Renewal_Product__r.Projected_Renewal_LC__c, 
                     Renewal_Product__r.Projected_Time_Duration_Months__c, 
                     Renewal_Product__r.Renewal__c, 
                     Renewal_Product__r.Renewal__r.Name, 
                     Renewal_Product__r.Renewal__r.Renewal_Number__c, 
                     Renewal_Product__r.Renewal__r.Local_Currency__c, 
                     Renewal_Product__r.Renewal__r.Owner.isActive,
                     Active_Contract__c, 
                     Active_Contract__r.Name, 
                     Active_Contract__r.Contract_Term_Months__c 
                From Active_Contract_Product__c 
               where Renewal_Product__r.Renewal__c IN: setRen
                 and Converted_To_Opportunity__c <> true]; // exclude ACPs already converted to Opptys - lfc - 06Mar2012
         
        // Populate the characteristics for the one-time PBE lookup.
        // These maps will be used to select and then filter all potential related PBEs.
        for(Active_Contract_Product__c actvCP_PBE:ACP){ 

            if(currPBELookup.isEmpty() || !currPBELookup.containsKey(actvCP_PBE.Renewal_Product__r.Renewal__r.Local_Currency__c))
                currPBELookup.put(actvCP_PBE.Renewal_Product__r.Renewal__r.Local_Currency__c,actvCP_PBE.Renewal_Product__r.Renewal__r.Local_Currency__c);

            if(prodPBELookup.isEmpty() || !prodPBELookup.containsKey(actvCP_PBE.Product__c))
                prodPBELookup.put(actvCP_PBE.Product__c,actvCP_PBE.Product__c);

            if(prodCurrPBELookup.isEmpty() || !prodCurrPBELookup.contains(actvCP_PBE.Product__c+'!'+actvCP_PBE.Renewal_Product__r.Renewal__r.Local_Currency__c))
                prodCurrPBELookup.add(actvCP_PBE.Product__c+'!'+actvCP_PBE.Renewal_Product__r.Renewal__r.Local_Currency__c);

            // Authorize opportunity to be written
            if(validRenewalLookup.isEmpty() || !validRenewalLookup.containsKey(actvCP_PBE.Renewal_Product__r.Renewal__c))
                validRenewalLookup.put(actvCP_PBE.Renewal_Product__r.Renewal__c, actvCP_PBE.Id);

            System.debug('DEBUG_RMGO: Processed ACP ' + actvCP_PBE);
            if(actvCP_PBE.Renewal_Product__r.Renewal__r.Owner.isActive == false)
            {
               errorLog.put(actvCP_PBE.Renewal_Product__r.Renewal__r.Name,'Renewal Owner is inactive.');
               showErrorlogButton = 'inline';
             }
            } // for actvCP_PBE

        // If there are no eligible ACPs found, drop a message to inform user
        if(ACP.isEmpty())
        {
           errorLog.put('','No eligible Active Contract Products found for Renewals meeting the selection criteria.');
                          showErrorlogButton = 'inline';
        }
        // Not likely that we will not find a single PBE, but drop a message if it happens
        else if(prodCurrPBELookup.isEmpty())
        {
              errorLog.put('','No active Pricebook Entries found for the products on the selected Renewals');
                             showErrorlogButton = 'inline';
         }
//        System.debug('DEBUG_RMGO: currPBELookup ' + currPBELookup);
//        System.debug('DEBUG_RMGO: prodPBELookup ' + prodPBELookup);
//        System.debug('DEBUG_RMGO: prodCurrPBELookup ' + prodCurrPBELookup);

        // Retrieve all PriceBook Entries for the selected Active Contract Products
        // This is based on Renewals Phase 3 req 1.06
        for(PricebookEntry pbe:
            [Select Id, Name, Product2Id, CurrencyIsoCode
               From PricebookEntry
              where Product2Id in :prodPBELookup.values()
                and CurrencyIsoCode in :currPBELookup.values()
                and Pricebook2.Name='CA Product List' 
                and IsActive =:true]){

            // If this PBE matches on product and currency, store it in the map
            if(!prodCurrPBELookup.isEmpty())
                if(prodCurrPBELookup.contains(pbe.Product2Id+'!'+pbe.CurrencyIsoCode))
                    if(prodCurrPBEItem.isEmpty())
                        prodCurrPBEItem.put(pbe.Product2Id+'!'+pbe.CurrencyIsoCode,pbe.Id);
                    else if(!prodCurrPBEItem.containsKey(pbe.Product2Id+'!'+pbe.CurrencyIsoCode))
                            prodCurrPBEItem.put(pbe.Product2Id+'!'+pbe.CurrencyIsoCode,pbe.Id);
            } // for pbe

        System.debug('DEBUG_RMGO: prodCurrPBEItem ' + prodCurrPBEItem);

        // Ignore Renewals with no eligible ACPs
        List <Opportunity> insertOppList = new List<Opportunity>();
        for(Opportunity candidateOpp:lstO){
            if(validRenewalLookup.containsKey(candidateOpp.Renewal__c))
                insertOppList.add(candidateOpp);
            }

        // Insert ONLY verified Opportunities, so that we ignore Renewals with no eligible ACPs
        if(insertOppList.size() > 0){

            countOpps = 0;
            SystemIdUtility.skipTrigger  = true; 

            //try
             {
                database.insert(insertOppList, false);
                
                OpportunityHandler.renewalToOppConversion = true; //chajo30 - US368497
                } 
           /*    catch(System.DmlException e){
                     for (Integer index = 0; index < e.getNumDml(); index++){
                            errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                                           showErrorlogButton = 'inline';
                      }
                }   */

            for(Opportunity oppty :insertOppList){
                if(oppty.Id != null && lstrnwlMap.containsKey(oppty.Renewal__c)){
                    Renewal__c updRen = lstrnwlMap.get(oppty.Renewal__c);

                    mO.put(oppty.Renewal__c,oppty);
                    updRen.Opportunity__c=oppty.id;
                    updRen.Converted_To_Opportunity__c=true;
                    lstrnwlMap.put(oppty.Renewal__c, updRen);
                    
                    }
                } // for
            }

        for(Active_Contract_Product__c actvCP:ACP){ 
            Opportunity opp = mO.get(actvCP.Renewal_Product__r.Renewal__c);
            
            // if the renewal was not successfully converted to an opportunity, skip ACP
            if(opp==null || opp.id ==null) 
                continue;

            // if there are no pricebook entries, skip ACP
            if(prodCurrPBEItem.isEmpty())
                continue;

            if(prodCurrPBEItem.containsKey(actvCP.Product__c+'!'+actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c)){

                String RenewalName=actvCP.Name;
                String RenewalproductName=actvCP.Active_Contract__r.Name;
                String segment;
                
                System.debug('DEBUG_RMGO: PBE found for' + actvCP.Product__c+'!'+actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c);

                actvCP.Converted_To_Opportunity__c=true;
                actvCP.Opportunity__c = opp.id; 

                // avoid issue where null value causes OpportunityLiItm.UnitPrice to default to 1.0
                if(actvCP.Projected_Renewal_Calc__c != null)
                    actvCP.Sales_Price__c = actvCP.Projected_Renewal_Calc__c;
                else 
                    actvCP.Sales_Price__c = 0;
            
                If(actvCP.Segmentation__c =='HT'||actvCP.Segmentation__c =='MT'||actvCP.Segmentation__c =='LT'||actvCP.Segmentation__c =='NT')
                    segment=actvCP.Segmentation__c;  
                else segment = actvCP.Pre_Segmentation__c;
            
                if(RenewalName!=null && RenewalName.length()>30)
                   RenewalName =RenewalName.Substring(0,30);
                   
                if(RenewalproductName !=null && RenewalproductName.length()>50)
                   RenewalproductName =RenewalproductName.Substring(0,50);
            
                caProdRnwl.add(new CA_Product_Renewal__c(
                                   name = RenewalproductName +'-'+RenewalName,
                                   Active_Contract_Product__c = actvCP.Id,
                                   Contract__c = actvCP.Active_Contract__c,
                                   CAProductRenewal_Amount__c = actvCP.AOCV__c,
                                   Renewal_Opportunity__c = opp.id,
                                   Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                                   ATTRF__c = actvCP.ATTRF_CRV__c,
                                   trr__C = actvCP.AOCV__c, 
                                   currencyIsoCode = opp.currencyIsOcode,
                                   Projected_Renewal__c = actvCP.Sales_Price__c
// FY13                                   ,Inside_Outside__c ='Outside'
                                   ));  
          
                RnwlOppLnItm.add(new OpportunityLineItem(
                                     PricebookEntryId = prodCurrPBEItem.get(actvCP.Product__c+'!'+actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c),
                                     CA_Contract_Product_Name__c = RenewalproductName +'-'+RenewalName,
                                     Active_Contract_Product__c = actvCP.Id,
                                     Active_Contract__c = actvCP.Active_Contract__c,
                                     Opportunityid = opp.id,
                                     Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                                     ATTRF__c = actvCP.ATTRF_CRV__c,
                                     Old_TRR__c = actvCP.AOCV__c,
                                     Stretch__c = actvCP.Sales_Price__c,
                                     UnitPrice = actvCP.Sales_Price__c,
// FY13                                     Comfort__c = actvCP.Sales_Price__c,
                                     Business_Type__c = 'Renewal',
                                     Segmentation__c = segment ,
                                     Original_Expiration_Date__c = actvCP.Dismantle_Date__c,
                                     Original_Deal_Term_Months__c = actvCP.Active_Contract__r.Contract_Term_Months__c,
                                     New_Deal_Term_Months__c = actvCP.Renewal_Product__r.Projected_Time_Duration_Months__c,
                                     Original_CV__c = actvCP.OCV__c,
                                     Original_Contract_IDs__c = actvCP.Active_Contract_Number__c
// FY13                                     ,Inside_Outside__c = 'Outside'
                                     )); 
                                     System.debug('actvCP.Sales_Price__c ' + actvCP.Sales_Price__c);
                }
            else{                                                          
                    errorLog.put(actvCP.Renewal_Product__r.Renewal__r.name , 'No active Pricebook Entry found for product: ' + actvCP.Product__r.Name + ' with currency ' + actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c + ' on Renewal ' + actvCP.Renewal_Product__r.Renewal__r.Renewal_Number__c); 
                                   showErrorlogButton = 'inline';
                }
        } // for actvCP
        
        // finalize database: inserts and updates
       // try
             {
               update lstrnwlMap.values();
             }
             /*catch(System.DmlException e){
                     for (Integer index = 0; index < e.getNumDml(); index++){
                            errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                                           showErrorlogButton = 'inline';
                      }
                }*/
        
        
        //FY13 start
        Map<id,id> mOLIACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Opplineitem
        Map<id,id> mRCPACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Renewal Contract Product
        //FY13 end

        if(caProdRnwl.size()>0){
            insert caProdRnwl;

            //FY13 - storing the ids of Active Contract Product, Opplineitem in map
            for(CA_Product_Renewal__c cpr: caProdRnwl){
                mRCPACP.put(cpr.Active_Contract_Product__c, cpr.id);    //FY13
                }
            }

        if(RnwlOppLnItm.size() >0){
            insert RnwlOppLnItm; 
            
            //FY13 - storing the ids of Active Contract Product, Renewal Contract Product in map
            for(OpportunityLineItem oli: RnwlOppLnItm){ 
                mOLIACP.put(oli.Active_Contract_Product__c,oli.id);    //FY13
                }
            }

        //FY13 - Updating the ids of Renewal Contract Product, Opplineitem on Active Contract Product from the maps
        for(Active_Contract_Product__c a:ACP){
            a.Opportunity_Product__c =mOLIACP.get(a.id);        //FY13
            a.Renewal_Contract_Product__c =mRCPACP.get(a.id);   //FY13
            }

        if(ACP.size()>0)
        {
        //try
             {
               update ACP;
             }
            /* catch(System.DmlException e){
                     for (Integer index = 0; index < e.getNumDml(); index++){
                            errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                                           showErrorlogButton = 'inline';
                      }
                }*/            
        }
        
        
                    for(Opportunity oppty :insertOppList){
                        if(oppty.Id != null && lstrnwlMap.containsKey(oppty.Renewal__c)){
                            Renewal__c updRen = lstrnwlMap.get(oppty.Renewal__c);
                                    errorLog.put(updRen.Name,'Generated Opportunity ' +
                                    //                                  oppty.Opportunity_Number__c +
                                    oppty.Name +
                                    ' for Renewal ' +
                                    updRen.Name);
                                    countOpps++;
                               
                            }
                }
        
        
       }
       catch(System.DmlException e){
                     for (Integer index = 0; index < e.getNumDml(); index++){
                            errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                                           showErrorlogButton = 'inline';
                      }
                }
        catch(Exception e)
       { 
        ////////ApexPages.addMessages(e);
        errorLog.put('Error',e.getMessage());
                       showErrorlogButton = 'inline';
       }     
    }

@isTest(SeeAllData=true)
public static void testMoveRenewals(){
SystemIdUtility.skipOpportunityTriggers = true;
SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        
    Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');       
    insert ac;   
    Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');        
    insert renCurrency;
    Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);       
    insert activeContract;     
    User u = [select id from user where IsActive=:true limit 1];
    
    Renewal__c renewal = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,Segmentation__c='HT');
    renewal.Expected_Close_Date__c=Date.valueOf('2013-05-05');
    renewal.Converted_To_Opportunity__c=false;
    renewal.Overall_Comments__c='Test';
    renewal.CurrencyIsoCode='USD';
    renewal.Projected_Time_Duration_Months__c=16;
    renewal.OwnerId=u.Id;
    renewal.OCV__c=100000;
    renewal.Annual_OCV_LC__c=200000;
    renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
    renewal.Projected_Renewal__c=50000;
    insert renewal;
    
    Product2 prod = new Product2(Name = 'TestProd');        
    insert prod;
    
    Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);       
    insert rnwlProdct;   
     
    
     
    Active_Contract_Product__c acp = new Active_Contract_Product__c();
    acp.name='Test';
    acp.Converted_To_Opportunity__c=false;
    acp.Active_Contract__c=activeContract.Id;
    acp.Renewal_Product__c=rnwlProdct.ID;
    insert acp;
        
    ApexPages.StandardController convcont = new ApexPages.StandardController(renewal);
    Renewals_MassGenerateOpp_New   cntrl = new Renewals_MassGenerateOpp_New();
    Test.startTest();

    cntrl.getItems();
    
    cntrl.segmentation = 'HT,MT,LT';
    cntrl.ac.ChangeDate__c = Date.valueOf('2011-05-05');
    cntrl.ac.Expected_Close_Date__c  = Date.valueOf('2011-05-05');
    
    //cntrl.Convert();
    Test.stopTest();    
    
}
    
}