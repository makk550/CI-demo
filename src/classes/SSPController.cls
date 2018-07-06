public class SSPController {

    public List<Opportunity> allOpps = new List<Opportunity>();
    public List<Opportunity> top5Opps {set; get;}
    private List<OpportunityLineItem> lineItems  {set; get;}
    List<Account> allAccounts = new List<Account>();
    public List<SSPBean> sspData;
    public set<String> dirProfileIds = new set<String>();
    public set<String> indirProfileIds = new set<String>();    
//    public set<ID> oppRecTypeIds = new set<ID>();    
    public set<ID> accIds = new set<ID>();    
    private Date fiscalYrStartDt;
    private Date fiscalYrEndDt;
    private Date QtrStartDt;
    private Date QtrEndDt;
    public String userType = 'direct';
    public String userRegion;
    public String userProfId;
    public String userRoleName {get; set;}
    public Double totalPWL {set; get;}
    public Double totalWonOpps {set; get;}
    public Double totalLostOpps {set; get;}
    public Double totalOpenOpps {set; get;}
    public Double totalSuccessRate {set; get;}
    public Double totaliPNCV {set; get;}
    public Double totaliOffering {set; get;}
    public Double totaliRenewal {set; get;}
    public Double totaloPNCV {set; get;}
    public Double totaloOffering {set; get;}
    public Double totaloRenewal {set; get;}
    public Double totalwPNCV {set; get;}
    public Double totalwOffering {set; get;}
    public Double totalwRenewal {set; get;}
    public integer maxAmt {set; get;}
    public Boolean hasData {set; get;}
    public string userCurrency {set; get;}


    //**** Visibility parameters ****//
    public boolean clInsiVisibleFlag {set; get;}
    public boolean targetVisibleFlag  {set; get;}
    public boolean sapImageVisibility  {set; get;}
    public boolean salesWBenchVisibility  {set; get;}
    public boolean pricingPortalVisility  {set; get;}
    public boolean perfMgmtVisibility  {set; get;}
    public boolean serviceDeskVisibility  {set; get;}
    public boolean leaderBoardVisibility  {set; get;}
    public boolean cpmsVisibility  {set; get;}
    public boolean custFeedbackVisibility  {set; get;}
    public boolean openOppAlertFlag  {set; get;}
    public boolean amtBelow5AlertFlag  {set; get;}

    public List<Opportunity> getallOpps(){
        return allOpps;
    }
    
    public List<SSPBean> getsspData(){
            return sspData;
    }
    
    public SSPController(){
    }

    /*static testmethod void test(){
        SSPController objSSPController = new SSPController();
        objSSPController.initSSP();
        objSSPController.getallOpps();
        objSSPController.getsspData();
    }*/

    private void initAllLists(){
        initUserType();
        initAccounts();
        retrieveDates();

        for(Account acc:allAccounts){
            accIds.add(acc.Id);
        }
        
//        lineItems = [Select convertCurrency(UnitPrice),OpportunityId,PricebookEntry.Product2.Solution_Sets__c,PricebookEntry.Product2.Family,
//                    Inside_Outside__c From OpportunityLineItem where Opportunity.AccountId in : accIds];

        lineItems = [Select convertCurrency(UnitPrice),OpportunityId,Opportunity.Name,Opportunity.CloseDate,PricebookEntry.Product2.Solution_Sets__c,PricebookEntry.Product2.Family,PricebookEntry.Product2.Name
                     From OpportunityLineItem where OpportunityId in (select id from opportunity where (Account.OwnerId=: UserInfo.getUserId() or Reseller__r.OwnerId=: UserInfo.getUserId()) and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt)];
                    
                    
//        oppRecTypeIds = SystemIdUtility.getOppsRecTypeIds(userType,userRegion);
        

        //including reseller opps related to cr # 189370663
        allOpps = [Select Reseller__c,StageName,Name,convertCurrency(Amount),Id,closeDate,AccountId,IsClosed,IsWon,ReasonField__c from Opportunity where (Account.OwnerId=: UserInfo.getUserId() or Reseller__r.OwnerId=: UserInfo.getUserId()) and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and Amount != null order by Amount desc limit 1000];
        top5Opps = [Select Reseller__c,Id,Name,convertCurrency(Amount) from Opportunity where (Account.OwnerId=: UserInfo.getUserId() or Reseller__r.OwnerId=: UserInfo.getUserId()) and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed=false and Amount != null order by Amount desc limit 5];

        //allOpps = [Select Inside_Outside__c,StageName,Name,convertCurrency(Amount),Id,closeDate,AccountId,IsClosed,IsWon,ReasonField__c from Opportunity where AccountId in : accIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and Amount != null order by Amount desc limit 1000];
        //top5Opps = [Select Id,Name,convertCurrency(Amount) from Opportunity where AccountId in : accIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed=false and Amount != null order by Amount desc limit 5];
        //allOpps = [Select Inside_Outside__c,StageName,Name,convertCurrency(Amount),Id,closeDate,AccountId,IsClosed,IsWon,ReasonField__c from Opportunity where AccountId in : accIds and RecordTypeId in : oppRecTypeIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and Amount != null order by Amount desc limit 1000];
    }   

    public PageReference initSSP(){
        initAllLists();
        System.debug('accIds : ' + accIds);
        System.debug('lineItems : ' + lineItems.size());
        System.debug('allOpps : ' + allOpps.size());
        sspData = new List<SSPBean>();
        totalOpenOpps = 0;
        totalLostOpps = 0;
        totalWonOpps = 0;
        totaliPNCV = 0;
        totaliOffering = 0;
        totaliRenewal = 0;
        totaloPNCV = 0;
        totaloOffering = 0;
        totaloRenewal = 0;
        totalwPNCV = 0;
        totalwOffering = 0;
        totalwRenewal = 0;
        maxAmt = 2500;
        userCurrency = Userinfo.getDefaultCurrency();
        totalSuccessRate = 0;
        totalPWL = 0;
        hasData = false;
        for(Account acc:allAccounts){
            hasData = true;
            SSPBean bean = new SSPBean(acc,allOpps,lineItems,QtrStartDt,QtrEndDt);
            sspData.add(bean);
            if(bean!=null){
                if(bean.OpenOpps!=null)
                    totalOpenOpps = totalOpenOpps + bean.OpenOpps;                                
                if(bean.LostOpps!=null)
                    totalLostOpps = totalLostOpps + bean.LostOpps;
                if(bean.WonOpps!=null)
                    totalWonOpps = totalWonOpps + bean.WonOpps;
                //if(bean.SuccessRate!=null)
                    //totalSuccessRate = totalSuccessRate + bean.SuccessRate;

                if(bean.iPNCV!=null)
                    totaliPNCV = totaliPNCV + bean.iPNCV;
                if(bean.iOffering!=null)
                    totaliOffering = totaliOffering + bean.iOffering;
                if(bean.iRenewal!=null)
                    totaliRenewal = totaliRenewal + bean.iRenewal;

                if(bean.oPNCV!=null)
                    totaloPNCV = totaloPNCV + bean.oPNCV;
                if(bean.oOffering!=null)
                    totaloOffering = totaloOffering + bean.oOffering;
                if(bean.oRenewal!=null)
                    totaloRenewal = totaloRenewal + bean.oRenewal;

                if(bean.wPNCV!=null)
                    totalwPNCV = totalwPNCV + bean.wPNCV;
                if(bean.wOffering!=null)
                    totalwOffering = totalwOffering + bean.wOffering;
                if(bean.wRenewal!=null)
                    totalwRenewal = totalwRenewal + bean.wRenewal;
            }
        }
        totalPWL = totalOpenOpps + totalWonOpps + totalLostOpps;
//        if(totalSuccessRate>0)
//            totalSuccessRate = totalSuccessRate/allAccounts.size();

        if(totalPWL>0)
            totalSuccessRate = Math.round(totalWonOpps/totalPWL * 100);
        
        return null;
    }

    private void initUserType(){
        // identify the user type            
        dirProfileIds = SystemIdUtility.getDirectProfileIds();
        indirProfileIds = SystemIdUtility.getInDirectProfileIds();
        
        // retrieve the user role
        userRoleName = [Select UserRole.Name from User where Id = : UserInfo.getUserId()].UserRole.Name;        
        
        userProfId = UserInfo.getProfileId();
        
        if(dirProfileIds.contains(userProfId))
            userType = 'direct';
        else if(indirProfileIds.contains(userProfId))
            userType = 'indirect';
                
        // identify the user role
        if(userRoleName.startsWith('APJ_'))
            userRegion = 'APJ';
        else if(userRoleName.startsWith('EMEA_'))
            userRegion = 'EMEA';
        else if(userRoleName.startsWith('LA_'))
            userRegion = 'LA';
             //sunji03 - FY19 PS/CAN is added
        else if (userRoleName.startsWith('PSCAN_'))
            userRegion = 'PS/CAN';
        else
            userRegion = 'NA';
            

        clInsiVisibleFlag = true;
        targetVisibleFlag  = true;
        sapImageVisibility  = true;
        salesWBenchVisibility  = true;
        pricingPortalVisility  = true;
        perfMgmtVisibility  = true;
        serviceDeskVisibility  = true;
        leaderBoardVisibility  = true;
        cpmsVisibility  = true;
        custFeedbackVisibility  = true;
        openOppAlertFlag  = false;
        amtBelow5AlertFlag  = false;

        // identify the visibility for the columns
        if(userType == 'direct' && (userRegion == 'NA' || userRegion == 'PS/CAN')) //sunji03 - FY19 PS/CAN is added
        {
            clInsiVisibleFlag = false;
        }
        else if(userType == 'direct' && userRegion == 'LA')
        {
            clInsiVisibleFlag = false;
        }
         else if(userType == 'indirect' && (userRegion == 'NA' || userRegion == 'PS/CAN'))//sunji03 - FY19 PS/CAN is added
        {
            clInsiVisibleFlag = false;
            targetVisibleFlag = false;  
        }
        else if(userType == 'indirect' && userRegion == 'LA')
        {
            clInsiVisibleFlag = false;
            targetVisibleFlag = false;                  
        }
            else if(userType == 'indirect' && userRegion == 'APJ')              
        {
            targetVisibleFlag = false;                  
        }
        else if(userType == 'indirect' && userRegion == 'EMEA')             
        {
            targetVisibleFlag = false;                  
        }
            
        // Include the logic for image visibility check here ..  
        if(userType == 'direct')
        {
            cpmsVisibility = false; 
        }           
            
        // New Open opportunities alert visibility
         if(userType == 'indirect' && (userRegion == 'NA' || userRegion == 'PS/CAN'))//sunji03 - FY19 PS/CAN is added
        {
            openOppAlertFlag = true;
        }

        // Amount less than 5 alert visibility
        if(userRegion == 'NA' || userRegion == 'PS/CAN')//sunji03 - FY19 PS/CAN is added
        {
            amtBelow5AlertFlag = true;
        }
            
    }
    
    private void initAccounts(){
         allAccounts = [Select a.RecordtypeId,a.Name,a.Id,a.Phone,a.Type,a.NCV_Target_Products__c, a.NCV_Target_Services_Education__c from Account a
        where a.OwnerId = : UserInfo.getUserId() and a.ParentId=null order by a.Name limit 1000];
        /*if(userType == 'direct')
        {
             allAccounts = [Select a.RecordtypeId,a.Name,a.Id,a.Phone,a.Type,a.NCV_Target_Products__c, a.NCV_Target_Services_Education__c from Account a
            where a.OwnerId = : UserInfo.getUserId() and RecordtypeId in: SystemIdUtility.getHomePageAccountRecordTypes(userType)         
            order by createddate limit 1000];    
        }
        else
        {
             allAccounts = [Select  a.RecordtypeId,a.Name,a.Id,a.Phone,a.Type,a.NCV_Target_Products__c, a.NCV_Target_Services_Education__c from Account a
            where a.OwnerId = : UserInfo.getUserId() and RecordtypeId in: SystemIdUtility.getHomePageAccountRecordTypes(userType)         
            and Customer_Category__c= 'Reseller' and Reseller_Type__c='Value' order by createddate limit 1000];    
        }*/
    }

    /*
     * function to retrieve the quarterly & yearly dates from the PERIOD table  
     *
     */            
    private void retrieveDates()
    {
        try {
            List<Period> yearlyDates = [Select StartDate, EndDate,Type From Period p where Type = 'Year' and StartDate <=TODAY and EndDate >= TODAY];
            fiscalYrStartDt = yearlyDates.get(0).StartDate;
            fiscalYrEndDt = yearlyDates.get(0).EndDate;
            List<Period> qtrlyDates = [Select StartDate, EndDate,Type From Period p where Type = 'Quarter' and StartDate <= TODAY and EndDate >= TODAY];
            QtrStartDt = qtrlyDates.get(0).StartDate;
            QtrEndDt = qtrlyDates.get(0).EndDate;
        }
        catch(Exception ex) {       
            System.debug(logginglevel.Debug,ex);
        }   
    }   

}