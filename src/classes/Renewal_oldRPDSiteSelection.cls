/**
Class Name: Renewal_oldRPDSiteSelection
Author: GODNA01
Description: This class is to used for old RPD functionality to get the sites and contracts from 
             Hoskey database for the account specified and persist in SFDC
*/

public class Renewal_oldRPDSiteSelection {
    
    
    public boolean ContractsNotAvailable{set;get;}//---***---
    public boolean showCAAccountId{set;get;}//---***---
     public boolean showSiteId{set;get;}//---***---
   public boolean isDealModelling {get;set;}
    public boolean isDealModellingEdit {get;set;}

    public String comments {get;set;}
    public Account account {get;private set;}
    public String accName {set;get;}
    public List<ContractSelection> contracts {set;get;}
    public List<SiteSelection> sites {set;get;}
    public List<SiteSelection> newSites {set;get;}
    public Boolean viewContracts {get;set;}
    public Id opporunityId {get;private set;}
   // public Set<String> productCodes {get;set;}
    public Set<String> caRnwlConts {get;set;}
    Set<String> contrReslts {get;set;}
    public boolean testMeth =false;
    public List<String> con {set;get;}

    public class SiteSelection {
        public String siteNumber {get;set;}
        public Boolean selected {get;set;}
        public Boolean defaultSelected {get;set;}
        public SiteSelection(String siteNum) {
        siteNumber = siteNum;
        selected = false;
        defaultSelected = false;
                                    
            }
    }
    
    
    
    public class ContractSelection {
        public String contractNumber {get;set;}
        public String siteNumber {get;set;}
        public Boolean selected {get;set;}
        public Boolean defaultSelected {get;set;}
        public ContractSelection(String contNum,String siteNum) {
            contractNumber = contNum;
            siteNumber = siteNum;
        }
        public String curr {get;set;}
        public String salesDocItem {get;set;}
      //  public String productCode {get;set;}
      //  public Product2 product {get;set;}
        public Decimal balDefferedRevenue {get;set;}
        public Decimal balUnbilledRecievables {get;set;}
        public Date lastBillDate {get;set;}
        public Decimal realizedRevenue {get;set;}
        public Decimal notRealizedRevenue {get;set;}
        public Decimal totalBilledLC {get;set;}
        public Date lastRevenuePostDate {get;set;}
        public Date contractEndDate {get;set;}
        public Decimal daysRemaining {get;set;}
        public Decimal dailyRevenue {get;set;}
        public String contEndDate {get;set;}
        
    }
       
    public PageReference getContracts() {
      //  productCodes = new Set<String>();
        List<string> sitesSelectedArr = new List<string>();
        Integer count = 0;
        set<String> defaultSitesSelected = new set<String>();
        set<String> sitesSelected = new set<String>();
        for(SiteSelection siteSelection : sites) {
            //sitesSelectedArr.add(siteSelection.siteNumber);
            //count = count + 1;
            if(siteSelection.selected) {
                sitesSelectedArr.add(siteSelection.siteNumber);               
                sitesSelected.add(siteSelection.siteNumber);
                if(siteSelection.defaultSelected != null && siteSelection.defaultSelected)
                    defaultSitesSelected.add(siteSelection.siteNumber);
                    count = count + 1;
            }
        }
        if(sitesSelectedArr.isEmpty()){            
           Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select the sites for this account'));           
           return null;        
         }
         
         soapSforceComSchemasClassRevenueper.RevenuePerDay obj = new soapSforceComSchemasClassRevenueper.RevenuePerDay();
         obj.inputHttpHeaders_x = new Map<String, String>();         
         obj.inputHttpHeaders_x.put('Authorization', 'Basic '+ label.WebServicesEncryptedPassword);
         obj.timeout_x = 60000;
         soapSforceComSchemasClassSite.Site[] result=null;
        try{ 
           if(!testMeth){

               System.debug('Input:::::'+sitesSelectedArr);
              result=obj.getRevenuePerDayData(sitesSelectedArr);
            }else{
              result = new soapSforceComSchemasClassSite.Site[1];
              result[0] = new soapSforceComSchemasClassSite.Site();
            }
            
        }
        catch(System.CalloutException e){
            System.debug('Firstt:::::');
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Web Service Response got delayed,Please try after Sometime.'+e));           
           return null;   
        }
        catch(Exception e){
            System.debug('Seconddd:::::');
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,''+e));           
           return null;   
        }

System.debug('Here at this place :::::');

        viewContracts = true;
        contracts = new List<ContractSelection>();
        ContractSelection contractSelection = null;
        
        Map<string,soapSforceComSchemasClassSite.Site> mapCon = new Map<string,soapSforceComSchemasClassSite.Site>();
        for(soapSforceComSchemasClassSite.Site site : result) {
        system.debug('Inside for loop--->');
             contractSelection = new ContractSelection(site.salesDocNumber,site.soldToSite);
             try{
                  if(site.ContractEndDate!=null){
                     contractSelection.contEndDate=Date.valueOf(site.ContractEndDate).Month()  + '/' + Date.valueOf(site.ContractEndDate).day() + '/' + Date.valueOf(site.ContractEndDate).Year();
                  }
                                       
             }
             catch (Exception e) {
            
             }
             if(caRnwlConts!=null&&caRnwlConts.contains(site.salesDocNumber)){
                contractSelection.defaultSelected = true;
                contractSelection.selected = true;
             } 
             if(contrReslts.contains(site.salesDocNumber)){
                 contractSelection.selected = true;
             }
                                                    
            contracts.add(contractSelection);
            
            system.debug('complete--->'+ contracts);
        }
        //sans test
        
      
         List<string> contractno = new List<string>();
        for(integer i=0;i<contracts.size();i++){
       
        system.debug('complete'+ contracts);
        system.debug('sans'+contracts[i].contractNumber);
        contractno.add(contracts[i].contractNumber);
        contractno.add(contracts[i].siteNumber);  
        contractno.add(contracts[i].contEndDate);      
        }
        System.debug('Before Sort' + contractno);
           list<string> con = new list<string>();
           con.addAll(contractno);
           con.sort();  
        system.debug('After Sort' + con);
        
        //return new PageReference('/apex/Renewal_SiteAndContractsSelection?id='+opporunityId);   
        return null;
         }
         
    
    
    public Pagereference Scenarios()
    {
        return new pagereference('/apex/Renewals_scenario?id='+opporunityId);
    }
    
    public Renewal_oldRPDSiteSelection() {
        
       isDealModelling = (System.currentPageReference().getParameters().get('dealM') == '1'); 
       
       isDealModellingEdit = (System.currentPageReference().getParameters().get('editMode') == '1');
       if(isDealModellingEdit)
           isDealModelling =false;
       List<SiteSelection> siteSelectionsFromDB = new List<SiteSelection>();       
       List<ContractSelection> contractSelectionsFromDB = new List<ContractSelection>();
       Set<String> sitesFromDB = new Set<String>();

       viewContracts = true;
       Id oppId = System.currentPageReference().getParameters().get('Id');
       opporunityId = oppId;

       contrReslts = new Set<String>();
       caRnwlConts =new Set<String>();
       set<String> sitesFromRenewals = new set<String>();
       
       List<CA_Product_Renewal__c> caRnwlPrdLst=[ select Site_ID__c,Active_Contract_Product__r.Active_Contract__r.Name  from CA_Product_Renewal__c where Renewal_Opportunity__c=:oppId];
       for(CA_Product_Renewal__c caRnwlPrd:caRnwlPrdLst){     
             caRnwlConts.add(caRnwlPrd.Active_Contract_Product__r.Active_Contract__r.Name);
             sitesFromRenewals.add(caRnwlPrd.Site_ID__c);
       }
      
       List<RPD_Contract__c> rpdContracts = [Select r.Sold_to_Site_ID__c, r.Opportunity__c, r.Contract_Sales_Document_No__c From RPD_Contract__c r where r.Opportunity__c = :oppId];
       if(rpdContracts.size() > 0) {
 //           viewContracts = true;
            SiteSelection siteSelectionFromDB = null;
            ContractSelection contractSelectionFromDB = null;
            for(RPD_Contract__c rpdContract : rpdContracts) {
                contractSelectionFromDB = new ContractSelection(rpdContract.Contract_Sales_Document_No__c,rpdContract.Sold_to_Site_ID__c);
                contractSelectionFromDB.selected = true;
                sitesFromDB.add(rpdContract.Sold_to_Site_ID__c);
                contractSelectionsFromDB.add(contractSelectionFromDB);
                contrReslts.add(rpdContract.Contract_Sales_Document_No__c);
            }
            for(String siteFromDB : sitesFromDB) {
                siteSelectionFromDB = new SiteSelection(siteFromDB);
                siteSelectionsFromDB.add(siteSelectionFromDB);
            }
       }
       
       Opportunity opp = [select AccountId,RPD_Comments__c from Opportunity where id = :oppId limit 1];
       Id accountId = opp.AccountId;
       account = [select Name, AccountNumber,RecordType.Name,Enterprise_ID__c,Commercial_ID__c from account where id = :accountId];//---***---
       
       if(account.RecordType.Name.containsIgnoreCase('Account Team Covered Account') || account.RecordType.Name.containsIgnoreCase('Territory Covered Account') || account.RecordType.Name.containsIgnoreCase('Reseller/Distributor Account')){//---***---
           showCAAccountId = true;
           showSiteId = false;
       }else if(account.RecordType.Name.containsIgnoreCase('SMB')){
           showSiteId = true;
           showCAAccountId = false;
       }
       
       if(opp.RPD_Comments__c!=null){
           comments=opp.RPD_Comments__c;
       }       
       sites = new List<SiteSelection>();       
       
       List<String> defaultSelectedSites = new List<String>();
       Account acc = [Select id, Coverage_Model__c, Commercial_id__c, SAP_TOPS_Site__c,Enterprise_ID__c From Account where id = :accountId limit 1];

       System.debug('Coverage Model:::::'+acc.Coverage_Model__c);

//CR:193833792 - Added "AND" condition to check for site status.
/* CR:193833792 Start*/      
        List<Site_Association__c> sitesAssociated = null;
        if('SMB' != (acc.Coverage_Model__c))
        {
        sitesAssociated = [Select s.SAP_Site_ID__c, s.Enterprise_ID__c, s.System__c From Site_Association__c s where Enterprise_ID__c = :accountId and Site_Status__c = 'Approved' order by s.SAP_Site_ID__c];
        }
  
       System.debug('sitesAssociated:::::'+sitesAssociated);
       System.debug('accountId:::::'+accountId);
       System.debug('acc.Enterprise_ID__c:::::'+acc.Enterprise_ID__c);
       System.debug('Commercial_ID__c:::::'+acc.Commercial_ID__c);
       
       SiteSelection siteSelection = null;
 // CR:193833792 
 /*      if(acc.Commercial_ID__c <> null && acc.Commercial_ID__c <> '')
       {
           siteSelection = new SiteSelection(acc.SAP_TOPS_Site__c+' '+acc.Commercial_ID__c);
           if(sitesFromRenewals.contains(acc.Commercial_ID__c))
           {
             defaultSelectedSites.add(acc.Commercial_ID__c);
             siteSelection.defaultSelected = true;
             siteSelection.selected = true;
           }
           
           if(viewContracts) {
                if(sitesFromDB.contains(acc.SAP_TOPS_Site__c+' '+acc.Commercial_ID__c))
                    siteSelection.selected = true;
           }
           sites.add(siteSelection);
      } /*
      
     /*   if(acc.Enterprise_ID__c <> null && acc.Enterprise_ID__c <> '')
       {
           siteSelection = new SiteSelection(acc.Enterprise_ID__c);
           //if(sitesFromRenewals.contains(acc.Enterprise_ID__c))
           //{
             defaultSelectedSites.add(acc.Enterprise_ID__c);
             siteSelection.defaultSelected = true;
             siteSelection.selected = true;
           //}
           */
           
         /*  if(viewContracts) {
                if(sitesFromDB.contains(acc.Enterprise_ID__c))
                    siteSelection.selected = true;
           }*/
 /*          sites.add(siteSelection);
      }
*/


//CR:193833792
        sites = new List<SiteSelection>();  

        if('SMB' != (acc.Coverage_Model__c))
        {

            for (Site_Association__c siteAssoc : sitesAssociated ) {
               siteSelection = new SiteSelection(siteAssoc.System__c+' '+siteAssoc.SAP_Site_ID__c);
    //CR:193833792          if(sitesFromRenewals.contains(siteAssoc.SAP_Site_ID__c))
    //CR:193833792           {
                 defaultSelectedSites.add(siteAssoc.SAP_Site_ID__c);
                 siteSelection.defaultSelected = true;
                 siteSelection.selected = true;
    //CR:193833792           }
      
               if(viewContracts) {
                   if(sitesFromDB.contains(siteAssoc.System__c+' '+siteAssoc.SAP_Site_ID__c))
                        siteSelection.selected = true;
               }
               sites.add(siteSelection);
            }
        }
                  
       if(viewContracts) {
          // productCodes = new Set<String>();
           List<String> sitesSelectedArr = new List<string>();
           Integer count = 0;
           for(SiteSelection siteSel : sites) {
  
//CR:193833792           if(siteSel.selected)
//CR:193833792               {
                       sitesSelectedArr.add(siteSel.siteNumber);
                       count = count + 1;
//CR:193833792                 }
           }
 
 // CR:193833792
        
        
 
        if('SMB' == (acc.Coverage_Model__c))
        {
            sitesSelectedArr.add(acc.SAP_TOPS_Site__c+' '+acc.Commercial_ID__c);
        }
  
        if(sitesSelectedArr.size() != 0)
        {
  
        soapSforceComSchemasClassRevenueper.RevenuePerDay obj = new soapSforceComSchemasClassRevenueper.RevenuePerDay();
        obj.inputHttpHeaders_x = new Map<String, String>();
        obj.inputHttpHeaders_x.put('Authorization', 'Basic '+ label.WebServicesEncryptedPassword);
        obj.timeout_x = 60000;
        soapSforceComSchemasClassSite.Site[] result=null;
    
        try{    
            System.debug('Input:::::22'+sitesSelectedArr);    
            result=obj.getRevenuePerDayData(sitesSelectedArr);
            System.debug('result:::::'+result.size());
        }
        catch(System.CalloutException e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Web Service Response got delayed,Please try after Sometime.'+e));
         return;
        }
        catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,''+e));   
            return;          
        }
   
        contracts = new List<ContractSelection>();
        ContractSelection contractSelection = null;
        
       for(soapSforceComSchemasClassSite.Site site : result) {
                        
           contractSelection = new ContractSelection(site.salesDocNumber,site.soldToSite);
           try{
                if(site.ContractEndDate!=null)                  
                 contractSelection.contEndDate=Date.valueOf(site.ContractEndDate).Month()  + '/' + Date.valueOf(site.ContractEndDate).day() + '/' + Date.valueOf(site.ContractEndDate).Year();                
             }
             catch (Exception e) {
             }                           
            if(caRnwlConts!=null && caRnwlConts.contains(site.salesDocNumber)){       
                contractSelection.defaultSelected = true;
                contractSelection.selected = true;
              }
              if(contrReslts.contains(site.salesDocNumber)){
                contractSelection.selected = true;
              }                
               contracts.add(contractSelection); 
                     
        }
        }  
                          
       } 
           if(contracts == null){//---***---
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'No contracts available for the account'));      
                //return null;
                    ContractsNotAvailable = true;          
                }else
                    ContractsNotAvailable = false;       
               System.debug('+++++++contracts++++++++'+contracts); 
         
       }

       
    /*      
        public ContractSelection setContractData(soapSforceComSchemasClassSite.Site site) {
               
            ContractSelection contractSelection = new ContractSelection(site.salesDocNumber,site.soldToSite);          
            if(caRnwlConts!=null&&caRnwlConts.contains(site.salesDocNumber)){
               contractSelection.defaultSelected = true;
               contractSelection.selected = true;
            }       
            contractSelection.balDefferedRevenue = site.balanceOfDeferredRevenue;
            contractSelection.balUnbilledRecievables = site.balanceOfUnbilledReceivables;
            try {
                if(site.contractEndDate!=null)
                contractSelection.contractEndDate = Date.valueOf(site.contractEndDate);
            } catch (Exception e) {          
            }
            if(site.dailyRevenue != null)
                contractSelection.dailyRevenue = Decimal.valueOf(site.dailyRevenue);
            else
                contractSelection.dailyRevenue = null;  
            contractSelection.daysRemaining = site.daysRemaining;
            try {
                if(site.billDate!=null)
                contractSelection.lastBillDate = Date.valueOf(site.billDate);
            } catch (Exception e) {
                
            }
            try {
                if(site.lastRevenuePost!=null)
                contractSelection.lastRevenuePostDate = Date.valueOf(site.lastRevenuePost);
            } catch (Exception e) {
            }
            contractSelection.curr = site.revCurrency;
            contractSelection.notRealizedRevenue = site.notRealizedRevenue;
            contractSelection.productCode = site.productCD;
            productCodes.add(site.productCD);
            contractSelection.realizedRevenue = site.realizedRevenue;
            contractSelection.salesDocItem = site.salesdocItem+'';
            contractSelection.totalBilledLC = site.billingsLocalCurrency;
            return contractSelection;    
        } 
   */
    public pagereference editContracts()
    {
            //    return new pagereference('/apex/Renewals_scenario?id='+opporunityId);
         return new pagereference('/apex/Renewal_SiteAndContractsSelection?id='+opporunityId + '&editMode=1');       
    }  
    
    /*
       This method is to fetch the associatd records for the selected sites from webservice..
       As sales force has limitation on Resulteset size(3 mb) first fetching calling the webservice method getAnalysisResults which
       fetches 1000 records.
       getAnalysisResults webservice also returns total number of records, if this size is greater than 1000 then calling  
       webservice getMoreAnalysisResults to fetch other set.   
       Currently fetching 1900 records only as salesforce has heap size limitations.
       
    */
    
    public PageReference getReportData() {
    

        List<soapSforceComSchemasClassSite.Site[]> TotalSites = new List<soapSforceComSchemasClassSite.Site[]>();
        Integer size=0;
        
        string totBalofDefRevenue='0';
        string totBalofUnbilRec='0';
        string totRealizedRevenue='0';
        string totNotRealizedRevenue='0';
        string totalBillLC='0';
        string totDailyRevenue='0';
        
        List<string> selContctsArr = new List<string>();
        Map<String,Id> productCdToProduct = new Map<String,Id>(); 
        
      //  List<Product2> products = [Select p.ProductCode, p.Id From Product2 p where p.ProductCode in :productCodes];
       // for(Product2 product : products) {
      //      productCdToProduct.put(product.ProductCode,product.Id);
       // }
            
        Set<String> distinctContratsSelected  = new Set<String>();
        List<RPD_Contract__c> rpdContracts = new List<RPD_Contract__c>();
        List<OLD_RPD_Result__c> oldRPDResults = new List<OLD_RPD_Result__c>();
        RPD_Contract__c rpdContract = null;
        OLD_RPD_Result__c oldRPDResult = null;
        for(ContractSelection contractSelection : contracts) {
            if(contractSelection.selected) {
                selContctsArr.add(contractSelection.contractNumber);
            }
        }      
        if(selContctsArr.size()==0){//---***---
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'No Contracts Selected'));
            return null;
        }else{
                soapSforceComSchemasClassRevenueper.RevenuePerDay obj = new soapSforceComSchemasClassRevenueper.RevenuePerDay();
                obj.inputHttpHeaders_x = new Map<String, String>();
                obj.inputHttpHeaders_x.put('Authorization', 'Basic '+ label.WebServicesEncryptedPassword);
                obj.timeout_x = 60000;
                soapSforceComSchemasClassSite.Site[] result=null;
            
                try{  
                  if(!testMeth){
                    result=obj.getAnalysisResults(selContctsArr);
                    TotalSites.add(result);
                    
                    if(result!=null && result.size()>0){
                        size= result[0].count;
                        totBalofDefRevenue = result[0].totBalofDefRevenue;
                        totBalofUnbilRec = result[0].totBalofUnbilRec;
                        totRealizedRevenue = result[0].totRealizedRevenue;
                        totNotRealizedRevenue = result[0].totnotRealizedRevenue;
                        totalBillLC = result[0].totalBillLC;
                        totDailyRevenue = result[0].totDailyRevenue;
                    }       
                   
                   
                     if(size>1000){ 
                        result=obj.getMoreAnalysisResults(selContctsArr,'1001','1900');               
                        TotalSites.add(result);                 
                     }
                   /*for(Integer i=1001; i<size && i<2000;i++){                
                        Integer j=i+999;               
                        result=obj.getMoreAnalysisResults(selContctsArr,string.valueof(i),string.valueof(j));               
                        TotalSites.add(result);
                        i=j+1;
                    }*/
                   }
                  else{
                        result = new soapSforceComSchemasClassSite.Site[1];
                        result[0] = new soapSforceComSchemasClassSite.Site();
                        TotalSites.add(result);
                        
                    }   
                }
                catch(System.CalloutException e){
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Problem in retriving the results through web sevice,Please try after Sometime.'+e));
                 return null;
                }
                catch(Exception e){
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,''+e));   
                    return null;          
                }
                
                for(Integer k=0; k< TotalSites.size();k++){ 
                 for(soapSforceComSchemasClassSite.Site site : TotalSites[k]) {
                    
                   String currencyCode=site.revCurrency;
                    if(currencyCode=='USA'){ 
                       currencyCode='USD';
                    }
                    if(currencyCode=='CAN'){ 
                       currencyCode='CAD';
                    }
         
                   rpdContract = new RPD_Contract__c(Contract_Sales_Document_No__c = site.salesDocNumber,Sold_to_Site_ID__c = site.soldToSite, Opportunity__c = opporunityId, CurrencyIsoCode=currencyCode);
                    
                                
                    oldRPDResult = new OLD_RPD_Result__c(Sold_To_Site__c = site.soldToSite,Sales_Doc_Number__c = site.salesDocNumber, Sales_Doc_Item__c = site.salesdocItem+'', Currency_Code__c = currencyCode, Product_Code__c = site.productCD, product_text__c= site.productNew, Balance_of_Deferred_Revenue__c = site.balanceOfDeferredRevenue, Balance_of_Unbilled_Receivables__c = site.balanceOfUnbilledReceivables,Realized_Revenue__c = site.realizedRevenue, Not_Realized_Revenue__c = site.notRealizedRevenue, Total_Billed_in_LC__c = site.billingsLocalCurrency, Days_Remaining__c = site.daysRemaining,Opportunity__c = opporunityId);
                   try{
                      oldRPDResult.CurrencyIsoCode = currencyCode;
                       } 
                   catch(exception e)
                    {}                   
                    rpdContracts.add(rpdContract);           
                    
                    try{
                        if(site.billDate!=null)
                        oldRPDResult.Last_Bill_Date__c = Date.valueOf(site.billDate); 
                        if(site.lastRevenuePost!=null)  
                        oldRPDResult.Last_Revenue_Post_Date__c = Date.valueOf(site.lastRevenuePost);
                        if(site.contractEndDate!=null)
                        oldRPDResult.Contract_End_Date__c = Date.valueOf(site.contractEndDate);
                        if(site.dailyRevenue!=null)
                        oldRPDResult.Daily_Revenue__c =Decimal.valueOf(site.dailyRevenue);
                        oldRPDResult.Total_Balance_of_Deferred_Revenue__c = Decimal.valueOf(totBalofDefRevenue);
                        oldRPDResult.Total_Balance_of_Unbilled_Receivables__c = Decimal.valueOf(totBalofUnbilRec);
                        oldRPDResult.Total_Bill_LC__c = Decimal.valueOf(totalBillLC); 
                        oldRPDResult.Total_Daily_Revenue__c = Decimal.valueOf(totDailyRevenue);
                        oldRPDResult.Total_Not_Realized_Revenue__c = Decimal.valueOf(totNotRealizedRevenue);
                        oldRPDResult.Total_Realized_Revenue__c = Decimal.valueOf(totRealizedRevenue);
                    }
                    catch (Exception e) {
                    
                    }           
                    //oldRPDResult.Realized_Revenue__c = site.realizedRevenue;
                    //oldRPDResult.Not_Realized_Revenue__c = site.notRealizedRevenue;
                    //oldRPDResult.Total_Billed_in_LC__c = site.billingsLocalCurrency;         
                  //  oldRPDResult.Days_Remaining__c = site.daysRemaining;
                    //oldRPDResult.Opportunity__c = opporunityId;
                    oldRPDResults.add(oldRPDResult);
                }
                
               }
                
                    if(rpdContracts.size() > 0) {
                        Opportunity updateOpp = new Opportunity(id=opporunityId);
                        //added by rao CR:191731768
                        if(comments != null || comments != '')
                        {
                            updateOpp.RPD_Comments__c = comments;
                            update updateOpp;
                            SystemIdUtility.isAfter_UpdateLineitems_Fire = true; 
                        }
                        
                        List<RPD_Contract__c> rpdContractIds = [Select r.Id From RPD_Contract__c r where r.Opportunity__c = :opporunityId];
                        if(rpdContractIds.size() > 0)
                            Database.delete(rpdContractIds);
                        insert rpdContracts;
                        
                        List<OLD_RPD_Result__c> oldRPDResultIds = [Select o.Id From OLD_RPD_Result__c o where o.Opportunity__c = :opporunityId];
                        if(oldRPDResultIds.size() > 0)
                            Database.delete(oldRPDResultIds);
                        insert oldRPDResults;
                }
                PageReference pageRef; 
                if(isDealModellingEdit <> true)
                   pageRef = new Pagereference('/apex/Renewal_RPDResults?id='+opporunityId);
                else
                   pageRef = new Pagereference('/'+opporunityId);
                return pageRef;
        }
    }   
       
}