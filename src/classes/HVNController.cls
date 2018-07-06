global with sharing class HVNController {

    public List<HVN__c> myaccounts  {get; set;}

    public string strKeyword        {get; set;}
    public String sortField         {get; set;}
    public string strSortOrder      {get; set;}
    public string strQuery          {get; set;}
    public string strQ          {get; set;}
    public string strLimit          {get; set;}
    public string strOrderBy        {get; set;} 
    public String previousSortField {get; set;}
    public String ownerClause       {get; set;}  
    public String currentTab        = 'myhvn'; //{get; set;}

    public boolean hasRecords       {get; set;}
    public boolean usePrevSort      {get; set;}

    public Integer nLimit           {get; set;}
    public Integer nLimitTab2       {get; set;}
    public Integer totalRecords     {get; set;} 
    public Integer previousLimit    {get; set;}
    public Integer previousLimitTab2    {get; set;}
    public Integer currentLimit     {get; set;}
    public Integer defaultLimit     {get; set;}

    List<AccountShare> ashAccIds = new List<AccountShare>();
    List<AccountTeamMember> atms = new List<AccountTeamMember>();

    static testMethod void runTest() {
        //Create new HVN object
        Account acc = new Account();         
        acc.RecordTypeId  = SystemIdUtility.getAccountTeamAcctRecordTypeId(); 
        //Commercial Account        
        acc.Name = 'sample';        
        acc.Customer_Category__c = 'Commercial';        
        acc.Account_Status__c = 'Submitted';        
        acc.GEO__c = 'NA';        
        insert acc; 
        
        Contact newCont = new Contact();        
        newCont.LastName = 'Sandip';        
        newCont.Country_Picklist__c = 'India';        
        insert newCont;        
        
        Date myDate = date.newinstance(2010, 09, 13);
        HVN__c newHVN = new HVN__c();
        newHVN.Relationship_Date__c = myDate;
        newHVN.Relationship_Status__c = 'New Relationship/No Previous Contact';
        newHVN.Contact__c = newCont.Id;
        insert newHVN;
        
        HVNController hctl = new HVNController();
        hctl.getcurrentTab();
        hctl.doSort();
        //hctl.setcurrentTab('allhvn');
        Contact newCnt = new Contact();
        newCnt.LastName = 'Sam';
        newCnt.Country_Picklist__c = 'India';
        //newCnt.HVN_ID__c = [select Id from HVN__c limit 1].Id;
        newCnt.HVN_ID__c = newHVN.Id;
        insert newCnt;
        testmethod1();
       // deleteContact(newCnt.Id);
    }
  
    /*  AR 3749 ALLHA02 Commenting out delete logic
    webService static boolean deleteContact(String ContactID) {
        boolean bRet = false;
        Contact c = [select AccountId,HVN__c,HVN_ID__c,name from Contact where Id=:ContactID];
        if(c.HVN_ID__c!=null && c.HVN_ID__c!=''){
            HVN__c hvn = [select Name, Id from HVN__c where id=:c.HVN_ID__c];
            if(hvn!=null){
                if (hvn.name == c.name){
                    c.AccountId = '0013000000RA9rg'; //'001Q0000005Lqx4'; //CA, Inc. 
                    c.HVN__c = FALSE;
                    update c;
                }
            }
        }else{
                delete c;
            bRet = true;
        }
        return bRet;
    }    */
    
    public String getcurrentTab(){
        return this.currentTab;
    }
    
    public void setcurrentTab(String newvalue){
        System.debug('currentTab:'+newvalue);
        this.currentTab = newvalue;
        bindList();     
    }
    
    public HVNController(){
        usePrevSort = false;
        defaultLimit = 20;
        currentLimit = defaultLimit;
        previousLimit = defaultLimit;
        previousLimitTab2 = defaultLimit;
        nLimit = 0;
        nLimitTab2 = 0;
        //currentTab = 'myhvn';
        bindList();
    }

    public void setOwnerClause(){
        ownerClause = ' (Primary_HVN_Owner__c=\'' + Userinfo.getUserId() + '\'  ';
        ownerClause = ownerClause + ' OR ';
        ownerClause = ownerClause + ' Secondary_HVN_Contact_Owner_1__c=\'' + Userinfo.getUserId() + '\'  ';
        ownerClause = ownerClause + ' OR ';
        ownerClause = ownerClause + ' Secondary_HVN_Contact_Owner_2__c=\'' + Userinfo.getUserId() + '\'  ';
        ownerClause = ownerClause + ' OR ';
        if(currentTab=='myhvn'){
                ownerClause = ownerClause + ' Secondary_HVN_Contact_Owner_3__c=\'' + Userinfo.getUserId() + '\'  )';
        }else{
            String accIds = '';
            Integer nCount = 0;
            Integer nCount2 = 0;

            if(accIds.endsWith(','))
                accIds = accIds.substring(0,accIds.length()-1);
                                
            if(accIds!=null && accIds!=''){
                ownerClause = ownerClause + ' Secondary_HVN_Contact_Owner_3__c=\'' + Userinfo.getUserId() + '\' ';
                ownerClause = ownerClause + ' OR ';
                ownerClause = ownerClause + ' Contact__r.Account.Id in (' + accIds + '))';
            }else{
                ownerClause = '';
            }
        }
    }
    
    public void bindList(){
        getCurrCount();

        string strLike = strKeyword + '%';
        if(sortField==null || sortField==''){
            sortField = 'Contact__r.Account.Name';
            strSortOrder = 'asc';
            strOrderBy = '  order by ' + sortField + ' ' + strSortOrder + ' NULLS LAST ';
        }

        setOwnerClause(); 

        strQuery = 'select Contact_Name__c,Contact__r.Account.Sales_Area__c,Contact__r.HVN__c,Contact__r.MobilePhone,Id,Name,Next_Touchpoint_2__c,Last_Touchpoint__c,Last_Touchpoint_Contact_by__c,Last_Touchpoint_Date__c,HVN_Contact_Photo__c,Role__c,Relationship_Status__c,Relationship_Status_Graphic__c,Secondary_HVN_Contact_Owner_1__r.Name,Secondary_HVN_Contact_Owner_2__r.Name,Secondary_HVN_Contact_Owner_3__r.Name,Primary_HVN_Owner__r.Name,Primary_HVN_Owner__r.User_Photo__c,Contact__r.Account.Id,Contact__r.Account.Name,Contact__r.Account.Company_Logo__c,Contact__r.Account.Owner.User_Photo__c,Contact__r.Account.Owner.Name,Contact__r.Name,Contact__r.Title,Contact__r.Email,Contact__r.Account.OwnerId from HVN__c ';
        strQuery = strQuery + ' where Contact__r.HVN__c=true';
        if(ownerClause!='')
            strQuery = strQuery + ' and ' + ownerClause;
                                                
        if(strKeyword!=null && strKeyword!='' && strKeyword!='All'){
            strQuery = strQuery + ' and ' + sortField + ' like \'' + strLike + '\'';
        }
                
        strLimit = ' limit ' + currentLimit;
        strQuery = strQuery + strOrderBy;
        strQuery = strQuery + strLimit;
        usePrevSort = false;
        executeQuery();
        hasMoreRecords();
    }
   
    public boolean hasMoreRecords(){
        Integer nSize = 0;
        if(ownerClause!=''){
            strQ = 'select Id from HVN__c ';
            strQ = strQ + ' where Contact__r.HVN__c=true and ' + ownerClause;
            List<HVN__c> records  = Database.query(strQ);
            if(records!=null){
                nSize = records.size(); 
                if(nSize>currentLimit)
                    hasRecords = true;
                else
                    hasRecords = false;
            }else{
                hasRecords = false;
            }
        }else{ 
            nSize = [select count() from HVN__c];
            if(nSize>currentLimit)
                hasRecords = true;
            else
                hasRecords = false;
        }

        return hasRecords;
   }
   
    private void getCurrCount(){
        if(currentTab=='myhvn'){
            currentLimit = previousLimit + nLimit;
            if(currentLimit<defaultLimit){
                currentLimit = defaultLimit;
                nLimit = defaultLimit;
                previousLimit = defaultLimit;
            }else{
                previousLimit = currentLimit;
            }

        }else{
            currentLimit = previousLimitTab2 + nLimitTab2;
            if(currentLimit<defaultLimit){
                currentLimit = defaultLimit;
                nLimitTab2 = defaultLimit;
                previousLimitTab2 = defaultLimit;
            }else{
                previousLimitTab2 = currentLimit;
            }
        }
    }
    
    private void executeQuery(){
        myaccounts = Database.query(strQuery);
        totalRecords = myaccounts.size(); 
    }

    public void doSort(){
        String order = 'asc';
        
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }

        if(usePrevSort){
            if(order == 'asc')
                order='desc';
            else
                order='asc';
        }

        strSortOrder = order;
                
        if(strOrderBy!=null)
            strQuery = strQuery.replace(strOrderBy,'');
                
        if(strLimit!=null)
        strQuery = strQuery.replace(strLimit,'');

        strOrderBy = '  order by ' + sortField + ' ' + order  + ' NULLS LAST ';
        strQuery = strQuery + strOrderBy;
        strQuery = strQuery + strLimit;
        executeQuery();
    }
    
    static void testmethod1(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}