public class Renewals_Scenario {
   public List<Renewal_Scenario__c> lst {get;set;}
   public List<Renewal_Scenario__c> lstAnalyze {get;set;} 
   public boolean isAnalysed {get;set;}
   public boolean testMeth =false; 
   Id oppId; 
   public pageReference returnToOpp()
   {
       getAnalysedResults();
         system.debug('chksize******'+ lstAnalyze.size() );       
      if(lstAnalyze != null && lstAnalyze.size() > 0){
              upsert lstanalyze;
        return new pagereference('/' + System.currentPageReference().getParameters().get('Id')) ;
       }else{
           return null;
       }
   }
    public  Renewals_Scenario()
    {
      isAnalysed  = false;  
       oppId = System.currentPageReference().getParameters().get('Id');
      Opportunity opp=new opportunity(id=oppId); //006Q0000006XFm7
         lst = [Select r.LastModifiedBy.Name, r.Will_Existing_Contracts_be_Respread__c, r.SystemModstamp, r.Scenario_Approved__c,r.Revenue_Neutral_with_Time_only_GAP__c, 
         r.Remaining_Billing_To_Be_Cancelled_Cred__c,r.Proposed_Deal_Time_Only__c,r.Pro_Rated_Credit__c,
         r.New_Time_MFC_Rev_Str_Avg_Mth__c,r.New_Time_MFC_Rev_Str_Avg_Day__c,r.Proposed_Deal_Time_MFC__c,
         r.Revenue_Neutral_w_MFC_GAP__c,r.New_Time_MFC_NCV_Svcs_Rev_Str_Avg_Mth__c,r.New_Time_MFC_NCV_Svcs_Rev_Str_Avg_Day__c,
         r.Proposed_Deal_Time_MFC_NCV_Svcs__c,r.Revenue_Neutral_w_MFC_NCV_Svcs_GAP__c,r.Gross_Deal_Should_Be_Rev_Neutral_at__c, 
         r.Pro_Rated_Credit_Note_Amount__c, r.Opportunity__c, r.Old_Rev_Stream_Avg_Month__c, r.Old_Rev_Stream_Avg_Day__c, 
         r.New_Time_Rev_Stream_Avg_Month__c, r.New_Time_Rev_Stream_Avg_Day__c,r.Months__c,          
         r.New_Deal_Time_Amount__c, r.New_Deal_Services_Educ_Amount__c, r.New_Deal_Revenue_Date__c, r.New_Deal_NCV_MF_Capacity_Amount__c, 
         r.New_Deal_NCV_Amount__c, r.New_Deal_End_Date__c, r.Name,  r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, 
         r.Finance_Approval__c, r.FY_Start_for_Old_Rev_Stream_Avg__c, r.FM_Start_for_Old_Rev_Stream_Avg__c, 
         r.Difference_for_Whole_Deal__c, r.Difference_Per_Year__c, r.Difference_Per_Month__c, r.CurrencyIsoCode, r.CreatedDate, 
         r.CreatedById, r.Comments__c, r.Analyze_Scenario__c, r.Additional_Committed_Billing__c 
        ,r.New_Time_MFC_NCV_Rev_Str_Avg_Mth__c, r.New_Time_MFC_NCV_Rev_Str_Avg_Day__c, r.Proposed_Deal_Time_MFC_NCV__c, r.Revenue_Neutral_w_MFC_NCV_GAP__c,r.Override_Actual_New_RPD__c,r.Override_Actual_Old_RPD__c
        From Renewal_Scenario__c r where Opportunity__c = : opp.id order by name limit 5]; 
    
      if(lst == null || lst.size() < 5)
          {
          integer count = 0;
          if(lst!=null)
              count = lst.size();
          else
              lst = new List<Renewal_Scenario__c>();   
          for(integer i=count +1;i <=5; i++)
              lst.add(new Renewal_Scenario__c(name=string.valueof(i), opportunity__c= opp.id));
           }   
    }
    
    public pagereference submit()
    {
        getAnalysedResults();
        isAnalysed  = lstAnalyze.size() > 0;  
         system.debug('chk1****'+ isAnalysed);
        return null;//new pagereference('/apex/Renewals_scenario_newRPD?id='+System.currentPageReference().getParameters().get('Id')) ;
    }
    
    public PageReference ExportOLDRPDResult() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        Report report =[Select r.Name,r.Id From Report r where DeveloperName=:'Old_RPD_Result'];
        PageReference ref = new PageReference('/'+report.Id+'?pv0='+String.ValueOf(oppId).Substring(0,15));
        return ref;
    }
    
     public PageReference ExportRenewalScenario() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        Report report =[Select r.Name,r.Id, r.DeveloperName  From Report r where r.DeveloperName=:'Renewal_Scenario_Result' ];
        PageReference ref = new PageReference('/'+report.Id+'?pv0='+String.ValueOf(oppId).Substring(0,15));
        return ref;
    }
    
    public void getAnalysedResults()
    {
        string oppId = System.currentPageReference().getParameters().get('Id');
        
        integer count = 0;
        CurrencyType[] currs = [Select  c.IsoCode, c.Id, c.DecimalPlaces, c.ConversionRate From CurrencyType c where IsActive = true];
       
        RPD_Contract__c[] cons = [Select r.Sold_to_Site_ID__c, r.Opportunity__c, r.CurrencyIsoCode, r.Contract_Sales_Document_No__c From RPD_Contract__c r where r.Opportunity__c = : oppId];
        
        Map<string,decimal> mapCodeRates = new Map<string,decimal>();
        for(currencytype c:currs)
            mapCodeRates.put(c.isocode, c.ConversionRate );   
            
        set<string> contracts = new Set<string>();
        Decimal convrate;
        set<string> addedContracts = new set<string>(); 
        for(RPD_Contract__c r: cons)
        {   
          if(addedContracts.contains(r.Contract_Sales_Document_No__c) == false)
           {
            convrate = mapCodeRates.get(r.currencyIsoCode);
            if(convrate == null)
                convrate = 1; 
            contracts.add((r.Sold_to_Site_ID__c.indexOf('S')>-1?'S':'T') + '*' + r.Contract_Sales_Document_No__c  + '*' + string.valueOf(convrate));
            addedContracts.add(r.Contract_Sales_Document_No__c);
           }
       }
        
        List<CA_Product_Renewal__c> caProdRenewals = [Select c.Sold_to_Site_ID__c, c.Active_Contract_Product__r.Active_Contract__r.SAP_TOPS__c,   c.Active_Contract_Product__r.Active_Contract__r.Local_Currency__c, c.Active_Contract_Product__r.Active_Contract_Number__c, c.Renewal_Opportunity__r.Id From CA_Product_Renewal__c c where c.Renewal_Opportunity__r.Id = :oppId];
        for(CA_Product_Renewal__c c: caProdRenewals )
        {
        if(c.Active_Contract_Product__r.Active_Contract__r.SAP_TOPS__c!=null && c.Active_Contract_Product__r.Active_Contract_Number__c!=null )
        {
         if(addedContracts.contains(c.Active_Contract_Product__r.Active_Contract_Number__c)== false)
           {
            convrate = null;
            if( c.Active_Contract_Product__r.Active_Contract__r.Local_Currency__c != null &&  c.Active_Contract_Product__r.Active_Contract__r.Local_Currency__c != '')
                convrate = mapCodeRates.get(c.Active_Contract_Product__r.Active_Contract__r.Local_Currency__c);
             
              if(convrate == null)
                  convrate = 1; 
                 
            contracts.add(c.Active_Contract_Product__r.Active_Contract__r.SAP_TOPS__c + '*'+ c.Active_Contract_Product__r.Active_Contract_Number__c + '*' + string.valueOf(convrate));
            addedContracts.add(c.Active_Contract_Product__r.Active_Contract_Number__c);
            }
         }
        }
        
        List<string> analysisContracts = new List<string>();
        lstAnalyze = new List<Renewal_Scenario__c>();
        
        for(Renewal_Scenario__c r:lst)
        {
            count ++;
                
           if(r.Analyze_Scenario__c)
           { 
            convrate = null;
            convrate = mapCodeRates.get(r.CurrencyIsoCode);
            System.debug('cuurency iso code RS'+r.currencyIsoCode);
            System.debug('Map code RS'+mapCodeRates.get(r.currencyIsoCode));


            if(convrate == null) 
            convrate =1;
            
            analysisContracts = new List<string>();
             
            for(string s:contracts)
            {
                analysisContracts.add(s+'*' + string.valueOf(convrate));
            }
            
       
            soapSforceComSchemasClassRenewaldea.RenewalDealBean  bean = new soapSforceComSchemasClassRenewaldea.RenewalDealBean();
            bean.scenario=string.valueOf(count);
            bean.analysisCurrency=r.currencyIsoCode;
            bean.oldDealIncTopsContracts='YES'; //always yes
            bean.oldDealIncSapContracts='YES'; //always yes
            bean.existContBeRepresead= (r.Will_Existing_Contracts_be_Respread__c?'YES':'NO');
            if(r.Remaining_Billing_To_Be_Cancelled_Cred__c != null)
                bean.remBillToBeCancelled=r.Remaining_Billing_To_Be_Cancelled_Cred__c;
            else { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'All fields are mandatory for analysis. Please fill all fields in Scenario ' + r.name)); lstAnalyze.clear(); return;}    
            if(r.FY_Start_for_Old_Rev_Stream_Avg__c != null && r.FM_Start_for_Old_Rev_Stream_Avg__c != null && r.New_Deal_Time_Amount__c != null
                && r.New_Deal_NCV_MF_Capacity_Amount__c != null && r.New_Deal_NCV_Amount__c != null && r.New_Deal_Services_Educ_Amount__c != null 
                && r.Pro_Rated_Credit_Note_Amount__c != null && r.New_Deal_Revenue_Date__c != null && r.New_Deal_End_Date__c != null
             )
            {
            bean.fyYFMStartforOldRevStream= r.FY_Start_for_Old_Rev_Stream_Avg__c +'-'+r.FM_Start_for_Old_Rev_Stream_Avg__c+'-01';
            bean.newDealTimeAmnt=r.New_Deal_Time_Amount__c;
            bean.newDealMFCapAmnt=r.New_Deal_NCV_MF_Capacity_Amount__c;
            bean.newDealNCVAmnt=r.New_Deal_NCV_Amount__c;
            bean.newDealServOrEdcAmnt=r.New_Deal_Services_Educ_Amount__c;
            bean.proRatedCredit=r.Pro_Rated_Credit_Note_Amount__c;
            bean.contracts= analysisContracts; //new String[]{'S*40131772*2.6525*1.351'};
            bean.newDealRevDate= r.New_Deal_Revenue_Date__c;//date.newinstance(2010, 10, 30);
            bean.newDealEndDate= r.New_Deal_End_Date__c;//date.newinstance(2011, 2, 30);
            }
            else { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'All fields are mandatory for analysis. Please fill all fields in Scenario ' + r.name)); lstAnalyze.clear(); return;}    
 
            
            soapSforceComSchemasClassRenewaldea.RenewalDeal  obj = new soapSforceComSchemasClassRenewaldea.RenewalDeal();
            obj.inputHttpHeaders_x = new Map<String, String>();
            obj.inputHttpHeaders_x.put('Authorization', 'Basic '+ label.WebServicesEncryptedPassword);
            obj.timeout_x = 60000;            
            soapSforceComSchemasClassRenewaldea.RenewalDealBean[]  resltBean =null;

            if(!testMeth)
             resltBean =obj.getRenewalDealAnalysis(bean);
            else{
                resltBean = new soapSforceComSchemasClassRenewaldea.RenewalDealBean[1];
                resltBean[0] = new soapSforceComSchemasClassRenewaldea.RenewalDealBean();
            }
        if(resltBean !=null && resltBean.size()>0){
          r.months__c = resltBean[0].months;
            if(resltBean[0].oldRevStreamAvgMnth != null)
            r.Old_Rev_Stream_Avg_Month__c = double.valueOf(resltBean[0].oldRevStreamAvgMnth);
             
            if(resltBean[0].oldRevStreamAvgDay != null)        
                r.Old_Rev_Stream_Avg_Day__c = double.valueOf(resltBean[0].oldRevStreamAvgDay);
            if(resltBean[0].newTimeRevStreamAvgMnth != null)    
                r.New_Time_Rev_Stream_Avg_Month__c = double.valueOf(resltBean[0].newTimeRevStreamAvgMnth);
            if(resltBean[0].newTimeRevStreamAvgDay != null)    
                r.New_Time_Rev_Stream_Avg_Day__c = double.valueOf(resltBean[0].newTimeRevStreamAvgDay);
            if(resltBean[0].difPerMonth != null)
                r.Difference_Per_Month__c = double.valueOf(resltBean[0].difPerMonth);
            if(resltBean[0].difPerYear != null)    
                r.Difference_Per_Year__c = double.valueOf(resltBean[0].difPerYear);
            if(resltBean[0].difForWholeDeal != null)
                r.Difference_for_Whole_Deal__c = double.valueOf(resltBean[0].difForWholeDeal);
            if(resltBean[0].proposedDealTimeOnly != null)    
                r.Proposed_Deal_Time_Only__c = double.valueOf(resltBean[0].proposedDealTimeOnly);
            r.Revenue_Neutral_with_Time_only_GAP__c = resltBean[0].revNeutralWithTimeOnlyGAP;
            if(resltBean[0].newTimeMFCRevStrAvgMnth != null)
                r.New_Time_MFC_Rev_Str_Avg_Mth__c = double.valueOf(resltBean[0].newTimeMFCRevStrAvgMnth);
            if(resltBean[0].newTimeMFCRevStrAvgDay != null)    
                r.New_Time_MFC_Rev_Str_Avg_Day__c = double.valueOf(resltBean[0].newTimeMFCRevStrAvgDay);
            if(resltBean[0].propDealTimeMFC != null)
            r.Proposed_Deal_Time_MFC__c = double.valueOf(resltBean[0].propDealTimeMFC);
            r.Revenue_Neutral_w_MFC_GAP__c = resltBean[0].revNeutralwMFCGAP;
            if(resltBean[0].newTimeMFCNCVRevStrAvgMth != null)
            r.New_Time_MFC_NCV_Rev_Str_Avg_Mth__c = double.valueOf(resltBean[0].newTimeMFCNCVRevStrAvgMth);
            if(resltBean[0].newTimeMFCNCVRevStrAvgDay != null)
            r.New_Time_MFC_NCV_Rev_Str_Avg_Day__c = double.valueOf(resltBean[0].newTimeMFCNCVRevStrAvgDay);
            if(resltBean[0].propDealTimeMFCNCV != null)
            r.Proposed_Deal_Time_MFC_NCV__c = double.valueOf(resltBean[0].propDealTimeMFCNCV);
            r.Revenue_Neutral_w_MFC_NCV_GAP__c = resltBean[0].revNeutralwMFCNCVGAP;
            if(resltBean[0].newTimeMFCNCVSycsRevStrAvgMth != null)
            r.New_Time_MFC_NCV_Svcs_Rev_Str_Avg_Mth__c = double.valueOf(resltBean[0].newTimeMFCNCVSycsRevStrAvgMth);
            if(resltBean[0].newTimeMFCNCVSycsRevStrAvgDay != null)
            r.New_Time_MFC_NCV_Svcs_Rev_Str_Avg_Day__c = double.valueOf(resltBean[0].newTimeMFCNCVSycsRevStrAvgDay);
            if(resltBean[0].propDealTimeMFCNCVSvcs != null)
            r.Proposed_Deal_Time_MFC_NCV_Svcs__c = double.valueOf(resltBean[0].propDealTimeMFCNCVSvcs);
            if(resltBean[0].revNeutralwMFCNCVSvcsGAP != null)
            r.Revenue_Neutral_w_MFC_NCV_Svcs_GAP__c = resltBean[0].revNeutralwMFCNCVSvcsGAP;
            if(resltBean[0].proRatedCredit != null)
            r.Pro_Rated_Credit__c = double.valueOf(resltBean[0].proRatedCredit);
            if(resltBean[0].addCommittedBilling != null)
            r.Additional_Committed_Billing__c = double.valueOf(resltBean[0].addCommittedBilling);
            if(resltBean[0].grossDealShdbRevNeutralat != null)
            r.Gross_Deal_Should_Be_Rev_Neutral_at__c = double.valueOf(resltBean[0].grossDealShdbRevNeutralat);
                                        
            lstAnalyze.add(r);
           }            
          }
        }
        
       // upsert lstAnalyze;
    }
    
    public pagereference submitFinance()
    {
        if(lstAnalyze != null && lstAnalyze.size() > 0)
            upsert lstAnalyze;
    
        Opportunity opp = new Opportunity(id=System.currentPageReference().getParameters().get('Id'));
        opp.Rpd_Status__c = 'Pending Finance Approval';
        update opp;
        return new pagereference('/' + System.currentPageReference().getParameters().get('Id')) ;
    }
    

    
}