/************************************************************************************************
* Modified By      Date           User Story      Details
* SAMAP01      03/07/2018    US450556    Account Creation Process Changes
* **********************************************************************************************/
public class DE_AccSearch_CLS {
    
    private PageReference srchResPage1;
    public string accountName{get;set;}
    public string physicalAddress{get;set;}
    public string physicalCity{get;set;}
    public string physicalState{get;set;}
    public string parentPage {get;set;}
    public string Usrtyp{get;set;}
    public string physicalCountry {get;set;}
    public string ZipPostalCode {get;set;} 
    public string countries {set;}
    public string selectedCountry {get;set;}
    public string recId {get;set;}
    public string pgFrom {get;set;}    
    public string selAccId1 {get;set;}    
    public string selAccId {get;set;}
    public string selAccName {get;set;}
    public string selecteDuns = '';
    public string selectedSFDCId = '';
    public string selectedSFDCName = '';
    public string checked {get;set;}
    
    public boolean isTaqProcess {get;set;}  
    public boolean hasBestMatch{get;set;}
    public string pagered{get;set;}  
    //used for setting the selected account name and id i nthe parent window
    public string namefield {get;set;}
    public string idfield {get;set;}
    
    public boolean showhead{get;set;}
    public boolean showsidebar { get; set; }
    public List<DE_AccResWithDuns_CLS> resultSet1 { get; set; }
    public List<DE_AccResWithDuns_CLS> resultSet2 { get; set; }
    public Map<String,DE_AccResWithDuns_CLS> objaccMap {get; set; }
    
    //properties of create screen
    public boolean isReadOnly {get; set; }
    public DE_AccResWithDuns_CLS objacc {get;set;}
    
    //properties of newly created account
    public string accid{get; set;}
    public string accname{get; set;}   
    
    public List<Account> accounts {get;set;} 
    
    
    //for site association
    Site_Association__c saRecord;
    public String strErrMsg {get; set;}
    
    string strAccApprovalStatus = '';  //for setting the approval process status on TAQ creation
    
    Map<String,String> mapStatesForCA;
    Map<string,string> mapStatesForUS;
    Map<String,String> mapStatesForAU;
    Map<String,String> mapStatesForIndia; //SAMAP01
    public string physicalStateIndia{get;set;} //samap01
    public string physicalStateFree{get;set;}
    public string physicalStateUS{get;set;}
    public string physicalStateCA{get;set;}
    public string physicalStateAU{get;set;}
    
    private DE_AccResWithDuns_CLS OrgRecord;
    public boolean hasNoAccess {get;set;}
    public boolean bIsPartner {get;set;}
    
    String strStateCode = '';
    
    Public Boolean hasPrevious {get;set;}
    Public Boolean hasNext {get;set;}
    Public Integer pageno {get;set;}
    Public Integer lastPageno {get;set;}
    public string selectedSize {get;set;}
    
    public List<DE_AccResWithDuns_CLS> lstWSTenSize {get; set;}
    
    
    public boolean pageOne {get;set;}
    public boolean pageTwo {get;set;}
    public boolean pageThree {get;set;}
    public boolean pageFour {get;set;}
    
    public Integer recordCount {get;set;}   //Fix for Defect #74247 
    
    public DE_AccSearch_CLS(){
        
        /*      
System.debug('CurrentPage Url:'+ApexPages.currentPage().getUrl());

if(ApexPages.currentPage().getParameters().get('count') != null && ApexPages.currentPage().getParameters().get('count') == '1')
pageOne = True;
else if(ApexPages.currentPage().getParameters().get('count') != null && ApexPages.currentPage().getParameters().get('count') == '2')
pageTwo = True;
else if(ApexPages.currentPage().getParameters().get('count') != null && ApexPages.currentPage().getParameters().get('count') == '3')
pageThree = True;
else if(ApexPages.currentPage().getParameters().get('count') != null && ApexPages.currentPage().getParameters().get('count') == '4')
pageFour = True;
*/  
        
        if(ApexPages.currentPage() != null)
        {                
            namefield = ApexPages.currentPage().getParameters().get('namefield');  
            idfield = ApexPages.currentPage().getParameters().get('idfield'); 
            parentPage = Apexpages.currentPage().getParameters().get('parentPage');
            Usrtyp=Userinfo.getUserType();
            //Fetch the corresponding record id
            recId = '';
            recId = ApexPages.currentPage().getParameters().get('lid');
            
            //If its a lead page then populate the address details
            if(recId != null)
                populateSearchFieldsFromLead(recId);
            
            recId = '';
            recId = ApexPages.currentPage().getParameters().get('sid');
            
            System.debug('________physicalState'+physicalStateUS);
            
            if(recId != null)
                populateSAForNewAcc(recId);
            
            
            bIsPartner = false;
            //Checking here if the logged in User is a Partner or not need
            List<User> user = [select id,Contactid from User where id = :Userinfo.getUserId()];
            if(user.size() > 0)
                if(user[0].Contactid !=null) bIsPartner = true;
            
            srchResPage1 = Page.DE_AccSearch_VFP;
            srchResPage1.setRedirect(false);
            isReadOnly = true;
            
        }
    }
    
    /*
//MANAR08
public Integer calcPageCount(){
Integer pageCount;
System.debug('srchResPage1 url:'+srchResPage1.getUrl());
System.debug('calcPageCount(),ApexPages.currentPage().getParameters().get(count):'+ApexPages.currentPage().getParameters().get('count'));
System.debuG('calcPageCount(), srchResPage1.getParameters().get(count):'+srchResPage1.getParameters().get('count'));
if(srchResPage1.getParameters().get('count') != null)
pageCount =  Integer.valueOf(srchResPage1.getParameters().get('count')) + 1;
else 
pageCount = 1;

srchResPage1.getParameters().put('count', String.valueOf(pageCount));

System.debug('calcPageCount(),pageCount*****:'+pageCount);
System.debug('calcPageCount() returns,Count Paremeter*****:'+srchResPage1.getParameters().get('count'));


return Integer.valueOf(srchResPage1.getParameters().get('count'));
} */
    
    public void loadheader(){
        pagered= ApexPages.currentPage().getParameters().get('fromPage');  
        loadheadercont();
        
    }
    public void loadheadercont()
    {
        //System.debug('innextscreen');
        if(pagered!=null && pagered.equals('StandNew')) {
            //System.debug('innextscreennew');
            showhead = true;
            showsidebar = true;
            isTaqProcess = false ;
            
        }
        else if(pagered!=null && pagered.equals('TAQButton')) {
            showhead = true;
            showsidebar = true;
            isTaqProcess = true;
        }        
        else {
            showhead = false;
            showsidebar = false;
            isTaqProcess = false ;
            
        }
    }
    
    public List<SelectOption> getRecordssize() {
        List<SelectOption> size = new List<SelectOption>();
        size.add(new SelectOption('10','10'));
        size.add(new SelectOption('25','25'));
        size.add(new SelectOption('50','50'));
        size.add(new SelectOption('100','100'));
        size.add(new SelectOption('200','200'));
        return size;
    }
    
    public PageReference Last1() {
        pageno = lastPageno;
        listToDisplay1();
        return null;
    }
    public PageReference Next1() {
        pageno++;
        listToDisplay1();
        return null;
    }
    public PageReference Previous1() {
        pageno--;
        listToDisplay1();
        return null;
    }
    public PageReference First1() {
        pageno = 1;
        listToDisplay1();
        return null;
    }
    public void displayresults1(){
        pageNo = 1;
        System.debug('_____'+selectedSize);
        lastPageno = resultset1.size()/Integer.valueOf(selectedSize); // Page size 10 rows
        if(lastPageno*Integer.valueOf(selectedSize) < resultset1.size())
            lastPageno++;
        if(pageno < lastPageno )
            hasNext = true;
        else 
            hasNext = false;
        if(pageno > 1 )
            hasPrevious = true;
        else
            hasPrevious = false;
        listToDisplay1();
    }
    
    public void listToDisplay1()
    {
        if(pageno < lastPageno )
            hasNext = true;
        else 
            hasNext = false;
        if(pageno > 1 )
            hasPrevious = true;
        else
            hasPrevious = false;
        lstWSTenSize = new List<DE_AccResWithDuns_CLS>();
        If(pageNo*Integer.valueOf(selectedSize) < resultset1.size())
        {
            for (Integer i = ((pageNo*Integer.valueOf(selectedSize))-Integer.valueOf(selectedSize)); i<pageNo*Integer.valueOf(selectedSize); i++ )
            {
                lstWSTenSize.add(resultset1[i]);
            }
        }
        else If(pageNo*Integer.valueOf(selectedSize)>= resultset1.size())
        {
            for (Integer i = ((pageNo*Integer.valueOf(selectedSize))-Integer.valueOf(selectedSize)); i<resultset1.size(); i++ )
            {
                lstWSTenSize.add(resultset1[i]);
            }
            
        } 
    }
    
    public PageReference Last2() {
        pageno = lastPageno;
        listToDisplay2();
        return null;
    }
    public PageReference Next2() {
        pageno++;
        listToDisplay2();
        return null;
    }
    public PageReference Previous2() {
        pageno--;
        listToDisplay2();
        return null;
    }
    public PageReference First2() {
        pageno = 1;
        listToDisplay2();
        return null;
    }
    
    public void displayresults2(){
        pageNo = 1;
        
        lastPageno = resultset2.size()/Integer.valueOf(selectedSize); // Page size 10 rows
        if(lastPageno*Integer.valueOf(selectedSize) < resultset2.size())
            lastPageno++;
        if(pageno < lastPageno )
            hasNext = true;
        else 
            hasNext = false;
        if(pageno > 1 )
            hasPrevious = true;
        else
            hasPrevious = false;
        listToDisplay2();
    }
    
    public void listToDisplay2()
    {
        if(pageno < lastPageno )
            hasNext = true;
        else 
            hasNext = false;
        if(pageno > 1 )
            hasPrevious = true;
        else
            hasPrevious = false;
        lstWSTenSize = new List<DE_AccResWithDuns_CLS>();
        If(pageNo*Integer.valueOf(selectedSize) < resultset2.size())
        {
            for (Integer i = ((pageNo*Integer.valueOf(selectedSize))-Integer.valueOf(selectedSize)); i<pageNo*Integer.valueOf(selectedSize); i++ )
            {
                lstWSTenSize.add(resultset2[i]);
            }
        }
        else If(pageNo*Integer.valueOf(selectedSize)>= resultset2.size())
        {
            for (Integer i = ((pageNo*Integer.valueOf(selectedSize))-Integer.valueOf(selectedSize)); i<resultset2.size(); i++ )
            {
                lstWSTenSize.add(resultset2[i]);
            }
            
        } 
    }
    
    public integer getTotalrecords() {
        if(resultset2 <> null) return resultset2.size();
        return 0;
    }
    
    
    public List<SelectOption> getCountries()
    {
        
        System.debug('1)physicalCountry'+physicalCountry);
        User usr = [select id,Contact.Country_Picklist__c,ContactID,Country from User where id = :UserInfo.getUserId() limit 1];
        string usrcntry = usr.Country;
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('--Select--','--Select--'));
        Schema.DescribeFieldResult countryFieldDescription = Account.Country_Picklist__c.getDescribe();
        for(Schema.Picklistentry picklistEntry:countryFieldDescription.getPicklistValues()) {
            countryOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            string picklistCountry = pickListEntry.getLabel();
            if(physicalCountry == null){
                if(usr.Contact.Country_Picklist__c != null)
                    physicalCountry = usr.Contact.Country_Picklist__c;
                
                else if(usrcntry!=null&&picklistCountry.startsWith(usrcntry))
                    physicalCountry = picklistCountry;  
                System.debug('2)physicalCountry'+physicalCountry);
                
            }
        }
        
        return countryOptions;
    }
    public List<SelectOption> getStateRegionsForCANADA() {
        List<SelectOption> StateRegionOptions = new List<SelectOption>();
        mapStatesForCA = prepareStatesForCanada();
        
        StateRegionOptions.add(new SelectOption('--Select--','--Select--'));
        List<String> statesList = new List<String>();
        statesList.addAll(mapStatesForCA.keySet());
        statesList.sort();
        for (string statekey:statesList)
            StateRegionOptions.add(new SelectOption(statekey,mapStatesForCA.get(statekey)));
        return StateRegionOptions;   
    }
    public List<SelectOption> getStateRegionsFor_US() {
        List<SelectOption> StateRegionOptions = new List<SelectOption>();
        mapStatesForUS = prepareStatesForUS();
        StateRegionOptions.add(new SelectOption('--Select--','--Select--'));
        List<String> statesListUs = new List<String>();
        statesListUs.addAll(mapStatesForUS.keySet());
        statesListUs.sort();
        
        for (string statekey:statesListUs)
            StateRegionOptions.add(new SelectOption(statekey,mapStatesForUS.get(statekey)));
        
        return StateRegionOptions;
    }
    
    public List<SelectOption> getStateRegionsForAustralia(){
        List<SelectOption> StateRegionOptions = new List<SelectOption>();
        mapStatesForAU = prepareStatesForAustralia();
        StateRegionOptions.add(new SelectOption('--Select--','--Select--'));
        List<String> statesList = new List<String>();
        statesList.addAll(mapStatesForAU.keySet());
        statesList.sort();
        
        for(String statekey:statesList){
            StateRegionOptions.add(new SelectOption(statekey, mapStatesForAU.get(statekey)));
        }
        
        return StateRegionOptions; 
    }
    
    //samap01 -US465954
    public List<SelectOption> getStateRegionsForINDIA() {
        List<SelectOption> StateRegionOptions = new List<SelectOption>();
        mapStatesForIndia = prepareStatesForIndia();
        
        StateRegionOptions.add(new SelectOption('--Select--','--Select--'));
        List<String> statesList = new List<String>();
        statesList.addAll(mapStatesForIndia.keySet());
        statesList.sort();
        for (string statekey:statesList)
            StateRegionOptions.add(new SelectOption(statekey,mapStatesForIndia.get(statekey)));
        return StateRegionOptions;   
    }
    //SAMAP01
    
    public List<Opportunity> getrecentlyAccounts() {
        
        //AR 3300-Added Account.Segment__c field to the below query
        List<Opportunity> recentAccounts = new List<Opportunity>();
        Set<id> uniqueAccounts = new Set<Id>();
        if(parentPage == 'Dealxsp'){
            //jianwen: temporitly comment out to show recent accounts
            // List<Opportunity> oppsList = [Select Service_Provider_Client__c, Service_Provider_Client__r.Name,Service_Provider_Client__r.Enterprise_ID__c,Service_Provider_Client__r.Country_Picklist__c,Service_Provider_Client__r.Segment__c from Opportunity Where Service_Provider_Client__r.Enterprise_ID__c != null AND Service_Provider_Client__r.IsPartner != true Order By Createddate DESC];
            List<Opportunity> oppsList = [Select Service_Provider_Client__c, Service_Provider_Client__r.Name,Service_Provider_Client__r.Enterprise_ID__c,Service_Provider_Client__r.Country_Picklist__c,Service_Provider_Client__r.Segment__c from Opportunity Where Service_Provider_Client__r.Enterprise_ID__c != null AND Service_Provider_Client__r.IsPartner != true AND (CreatedByid =: UserInfo.getUserId() OR OwnerId =: UserInfo.getUserId()) Order By Createddate DESC];
            for(Opportunity opp : oppsList){
                if(!(uniqueAccounts.contains(opp.Service_Provider_Client__c))){
                    recentAccounts.add(opp);
                    uniqueAccounts.add(opp.Service_Provider_Client__c);
                }
            }
        }else{
            //jianwen: temporitly comment out to show recent accounts
            List<Opportunity> oppsList = [Select AccountId, Account.Name,Account.Enterprise_ID__c,Account.Country_Picklist__c,Account.Segment__c from Opportunity Where Account.Enterprise_ID__c != null AND Account.IsPartner != true AND (CreatedByid =: UserInfo.getUserId() OR OwnerId =: UserInfo.getUserId()) Order By Createddate DESC];
            //List<Opportunity> oppsList = [Select AccountId, Account.Name,Account.Enterprise_ID__c,Account.Country_Picklist__c,Account.Segment__c from Opportunity Where Account.Enterprise_ID__c != null AND Account.IsPartner != true  Order By Createddate DESC Limit 50000];
            
            for(Opportunity opp : oppsList){
                if(!(uniqueAccounts.contains(opp.AccountId))){
                    recentAccounts.add(opp);
                    uniqueAccounts.add(opp.AccountId);
                }
            }
        }
        
        
        return recentAccounts;
    }
    
    public PageReference SearchAcc() {
        //System.debug('_____Debug___1');
        if (accountName == '') {
            Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Please enter the account name.');
            Apexpages.addMessage(error);
            return null;
        } 
        if (physicalCountry == '--Select--') {
            Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Please select the country.');
            Apexpages.addMessage(error);
            return null;
        }
        
        String strCountryCode = ''; 
        
        if(physicalAddress == null) physicalAddress = '';
        if(physicalCity == null) physicalCity = '';
        //if(physicalState == null) physicalState = '';
        if(ZipPostalCode == null) ZipPostalCode = '';
        
         /*
        if(physicalStateUS != '--Select--'&& Usrtyp!='PowerPartner') physicalState = physicalStateUS;
        else if(physicalStateCA != '--Select--' && Usrtyp!='PowerPartner') physicalState = physicalStateCA;
        else if(physicalStateAU != '--Select--' && Usrtyp!='PowerPartner') physicalState = physicalStateAU;
        else if(physicalStateIndia != '--Select--' && Usrtyp!='PowerPartner') physicalState = physicalStateIndia; //samap01
        else if(physicalStateFree != '' && Usrtyp!='PowerPartner') physicalState = physicalStateFree;
        else physicalState = '';
        */
        //samap01
        if(physicalStateUS != '--Select--') physicalState = physicalStateUS;
        else if(physicalStateCA != '--Select--' ) physicalState = physicalStateCA;
        else if(physicalStateAU != '--Select--' ) physicalState = physicalStateAU;
        else if(physicalStateIndia != '--Select--' ) physicalState = physicalStateIndia; //samap01
        else if(physicalStateFree != '' ) physicalState = physicalStateFree;
        else physicalState = '';
        
        system.debug('physical state to xml: '+physicalState);
        strCountryCode = physicalCountry.substring(0, 2);
        if(strCountryCode == 'US' && Usrtyp!='PowerPartner')
        {
            if(mapStatesForUS != null)
            {
                strStateCode = mapStatesForUS.get(physicalStateUS);
                strStateCode = strStateCode.substring(0, 2);
            }
        }
        else if(strCountryCode == 'CA' && Usrtyp!='PowerPartner')
        {
            if(mapStatesForCA != null)
            {
                strStateCode = mapStatesForCA.get(physicalStateCA);
                strStateCode = strStateCode.substring(0, 2);
            }
        }
        //samap01 -US465954
        else if(strCountryCode == 'IN' && Usrtyp!='PowerPartner')
        {
            if(mapStatesForIndia != null) //samap01
            {
                strStateCode = mapStatesForIndia.get(physicalStateIndia);
                strStateCode = strStateCode.substring(0, 2);
            }
              System.debug('samap01 -strStateCode' +strStateCode);
        }
      
      //samap01 -US465954
        
        else if(strCountryCode == 'AU' && Usrtyp!='PowerPartner'){
            if(mapStatesForAU != null){
                strStateCode = physicalStateAU;
            }
        }
        else
        {
            if(physicalState != '--Select--' && Usrtyp!='PowerPartner') strStateCode = physicalStateFree;
        }
        system.debug(strCountryCode+'physical state to xml after map check: '+strStateCode);
           System.debug('samap01 -strStateCode' +strStateCode);
        
        //EAI Service Call SearchType = InitialAccSearch
        //System.debug('_____Debug___2'+physicalState);
        //IsFirstSearch = true;
        srchResPage1 = CallEAIServiceForAccountSearch(true);
        System.debug('_____Debug___3'+srchResPage1 );
        return srchResPage1;
    }
    
    public void selectAccId() { 
        selectedSFDCId = selAccId1;
    }
    
    public PageReference SearchNext() {
        
        return CallEAIServiceForAccountSearch(false);
        
    }
    
    public PageReference gotoPrevAccSrch() {
        PageReference srchPrevPage = Page.DE_Accsearch_VFP;
        srchPrevPage.setRedirect(false);
        return srchPrevPage;
    }
    
    public PageReference gotoPrevScreen() {
        PageReference srchPrevPage;
        if(resultSet1!=null){
            selectedSize = Label.DE_PaginationSize;
            displayresults1();
            srchPrevPage = Page.DE_AccSrchResDuns_VFP;
        }
        else{
            srchPrevPage = Page.DE_Accsearch_VFP;
        }
        srchPrevPage.setRedirect(false);
        return srchPrevPage;
    }
    
    void populateSearchFieldsFromLead(string LeadId) {
        
        String strCountry = '';
        List<Lead> existLead = [Select Company,Street,State, SPP__c, PostalCode, Country_Picklist__c, City from Lead where id =: LeadId ];
        if (existLead.size() == 0) return;
        accountName = existLead[0].Company;
        physicalAddress = existLead[0].Street;
        physicalCity =  existLead[0].City;
        physicalCountry = existLead[0].Country_Picklist__c;
        ZipPostalCode = existLead[0].PostalCode;
        if(physicalCountry <> null && physicalCountry <> '')
            strCountry = physicalCountry.substring(0, 2);
        if(strCountry == 'US')
            physicalStateUS = existLead[0].SPP__c;
        else if(strCountry == 'CA')
            physicalStateCA = existLead[0].SPP__c;
        else if(strCountry == 'IN')  //samap01 -US465954
            physicalStateIndia = existLead[0].SPP__c; //samap01 -US465954
        else if(strCountry == 'AU')
            physicalStateAU = existLead[0].SPP__c;
        else
            physicalStateFree = existLead[0].State;
    }
    
    public void selectAccDuns() { 
        selecteDuns = selAccId;
        
        //return null;
    }
    
    String prepareSearchXmlString(boolean IsFirstSearch) {
        String strReturn = '';
        String strCountryCode = physicalCountry.substring(0, 2);
        //String strStateCode = '';
        
        DE_AccResWithDuns_CLS selectedRecord;
        
        XmlStreamWriter writer = new XmlStreamWriter();
        
        if(!IsFirstSearch)
            if(objaccMap <> null && selecteDuns <> null)
            if(objaccMap.get(selecteDuns) <> null)
            selectedRecord = objaccMap.get(selecteDuns);
        
        system.debug(selecteDuns+'----Data fro sec payload---------'+selectedRecord);
        
        writer.writeStartDocument('UTF-8', '1.0');
        writer.writeStartElement(null, 'accountRequest', null);
        writer.writeStartElement(null, 'source', null);
        
        //Second Search performed with Best Match
        if(!IsFirstSearch && selectedRecord <> null) {
            if(selectedRecord.accName != null){
                writer.writeStartElement(null, 'name', null);
                writer.writeCharacters(selectedRecord.accName);
                writer.writeEndElement();
            }
        }   
        else {//First Search or Second Search with No Match
            writer.writeStartElement(null, 'name', null);
            writer.writeCharacters(accountName);
            writer.writeEndElement();
        }
        
        
        if(!IsFirstSearch && selectedRecord <> null) {
            //if(selectedRecord.address <> ''){// && selectedRecord.address <> null) {
            if(selectedRecord.address != null){
                writer.writeStartElement(null, 'street', null);
                writer.writeCharacters(selectedRecord.address);
                writer.writeEndElement();
            }
        }   
        else {
            writer.writeStartElement(null, 'street', null);
            writer.writeCharacters(physicalAddress);
            writer.writeEndElement();
        }
        
        if(!IsFirstSearch && selectedRecord <> null) {
            //if(selectedRecord.city <> ''){// && selectedRecord.city <> null) {
            if(selectedRecord.city != null){
                writer.writeStartElement(null, 'city', null);
                writer.writeCharacters(selectedRecord.city);
                writer.writeEndElement();
            }
        }   
        else {
            writer.writeStartElement(null, 'city', null);
            writer.writeCharacters(physicalCity);
            writer.writeEndElement();
        }
        
        if(!IsFirstSearch) {
            //if(selectedRecord.state <> ''){// && selectedRecord.state <> null) {
            if(selectedRecord <> null) {
                if(selectedRecord.state != null && (selectedRecord.country == 'US' || selectedRecord.country == 'CA' || selectedRecord.country == 'AU' || selectedRecord.country == 'IN')){  //SAMAP01
                    writer.writeStartElement(null, 'region', null);
                    writer.writeCharacters(selectedRecord.state);
                    writer.writeEndElement();
                }
            }
            else if(strCountryCode == 'US' || strCountryCode == 'CA' || strCountryCode == 'AU' || strCountryCode == 'IN') { //samap01 -US465954
                writer.writeStartElement(null, 'region', null); 
                writer.writeCharacters(strStateCode);
                writer.writeEndElement();
            }
        }
        else {
            writer.writeStartElement(null, 'region', null);
            writer.writeCharacters(strStateCode);
            writer.writeEndElement();
        }
        
        if(!IsFirstSearch) {
            //if(selectedRecord.country <> ''){// && selectedRecord.country <> null) {
            if(selectedRecord <> null) {
                if(selectedRecord.country != null){
                    writer.writeStartElement(null, 'country', null);
                    writer.writeCharacters(getSFDCountryFrmCountryCode(selectedRecord.country));
                    writer.writeEndElement();
                }
            }
            else {
                writer.writeStartElement(null, 'country', null);
                writer.writeCharacters(getSFDCountryFrmCountryCode(strCountryCode));
                writer.writeEndElement();
            }
        }
        else {    
            writer.writeStartElement(null, 'country', null);
            writer.writeCharacters(strCountryCode);
            writer.writeEndElement();
        }
        
        if(!IsFirstSearch && selectedRecord <> null) {
            // if(selectedRecord.zipCode <> ''){// && selectedRecord.zipCode <> null) {
            if(selectedRecord.zipCode != null){
                writer.writeStartElement(null, 'postalCode', null);
                writer.writeCharacters(selectedRecord.zipCode);
                writer.writeEndElement();
            }
        }
        else {    
            writer.writeStartElement(null, 'postalCode', null);
            writer.writeCharacters(ZipPostalCode);
            writer.writeEndElement();
        }
        
        if(!IsFirstSearch) {//Add DUNS Info in search Request - 2nd Search
            //System.debug('selecteDuns_____'+selecteDuns);
            if(selecteDuns <> '' && selecteDuns <> null) { 
                writer.writeStartElement(null, 'dunsNumber', null);
                writer.writeCharacters(selecteDuns);
                writer.writeEndElement();
            }
            
        }
        
        writer.writeEndElement(); //ending source
        
        writer.writeStartElement(null, 'strategies', null);
        
        writer.writeStartElement(null, 'strategy', null);
        
        if(IsFirstSearch)        
            //writer.writeAttribute(null, null, 'name', 'SAP-Name-Address');
            writer.writeAttribute(null, null, 'name', 'DUNS_Get-Cleanse-Match');
        else
            //writer.writeAttribute(null, null, 'name', 'DUNS_Get-Cleanse-Match');
            writer.writeAttribute(null, null, 'name', 'MDM-Account-Search');
        
        writer.writeEndElement();
        
        writer.writeEndElement(); //strategies
        
        writer.writeEndElement(); //searchRequest or accountRequest
        
        
        strReturn = writer.getXmlString();
        system.debug('XML created : '+strReturn);
        
        //strReturn = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><accountRequest><source><name>Dell</name><street>10120 W 76th St</street><city>Eden Prairie</city><region>MN</region><country>US</country><postalCode>55344-3728</postalCode></source><strategies><strategy name="DUNS_Get-Cleanse-Match"/></strategies></accountRequest>';
        
        writer.close();
        
        return strReturn;
    }
    
    
    pagereference CallEAIServiceForAccountSearch(boolean IsFirstSearch) {
        
        Integer pagecount;
        
        System.debug('_____Debug___2_1'+IsFirstSearch);
        String body = '';
        String SearchURLToHit;
        
        HTTPResponse response = new HTTPResponse();
        HttpRequest request = new HttpRequest();
        
        request.setHeader('consumerUsername', Label.EAIConsumerUsername);
        
        SearchURLToHit = Label.EAIURL;
        
        body = prepareSearchXmlString(IsFirstSearch);
        
        request.setEndpoint(SearchURLToHit);
        request.setHeader('Content-Type','text/xml');
        request.setMethod('POST');
        request.setTimeout(60000);
        request.setBody(body);
        System.debug('samap01 -request ' +body);
        Http http = new Http();
        
        if(!Test.isRunningTest()) 
        {
            try {
                response = http.send(request);
            }
            catch(CalloutException ex) {
                //if(ex.getMessage().equals('Read timed out')) {
                //Apexpages.Message ReadTimedOutWarning = new Apexpages.Message(ApexPages.Severity.Warning, 'Account Web Search Service Call Failed. Read timed out error exception, displaying SFDC Accounts.'); 
                Apexpages.Message ReadTimedOutWarning = new Apexpages.Message(ApexPages.Severity.Warning, 'The system was unable to process your request, please try again.'); 
                Apexpages.addmessage(ReadTimedOutWarning);
                if(IsFirstSearch) { 
                    srchResPage1 = Page.DE_AccSrchResDuns_VFP; 
                    resultSet1 = bindLocalSearchREsults();
                }
                else { 
                    srchResPage1 = Page.DE_AccSrchRes2_VFP; 
                    resultSet2 = bindLocalSearchREsults();
                }
                return srchResPage1; 
                
                //}    
                //else System.debug('ERROR:' + ex);
            }
        }
        else
        {
            response.setStatusCode(200);
            response.setBody(getSampleTestXML(IsFirstSearch));
        }
        
        System.debug('Search Results response code'+response.getStatusCode());
        System.debug('Search Results response body'+response.getBody());    
        
        if(response.getStatusCode() == 200) { 
            srchResPage1 = parseAccSrchResponse(response, IsFirstSearch);
        }
        else {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.Warning, 'Account Search Web Service Call responded with the StatusCode '+response.getStatusCode()+'. No results found in MDM for the selected Duns. '); 
            Apexpages.addmessage(errMsg);
            //if(accountResults.size() > 0) {
            if(IsFirstSearch) {
                srchResPage1 = Page.DE_AccSrchResDuns_VFP;
                resultSet1 = bindLocalSearchREsults();
                //System.debug('____resultSet1'+ resultSet1);
            }    
            else {
                srchResPage1 = Page.DE_AccSrchRes2_VFP;
                resultSet2 = bindLocalSearchREsults();
                //System.debug('____resultSet2'+ resultSet2);
            }
            //}
            
            //else { //Navigate to Account Create Page with Search Data filled
            if(resultSet1.size() == 0 || resultSet2.size() == 0 ) {
                objacc = new DE_AccResWithDuns_CLS();
                objacc.accName = accountName;
                objacc.city = physicalCity;
                objacc.country = physicalCountry;
                objacc.state = physicalState;  //physicalState;//strStateCode
                objacc.street = physicalAddress;
                objacc.zipCode = ZipPostalCode;
                if(isTaqProcess)
                    //srchResPage1 = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street);
                    srchResPage1 = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street+'%2600N30000004yn2b%3D'+objacc.geo+'%2600N30000004yn1a%3D'+objacc.opparea+'%2600N30000004yn3K%3D'+objacc.salReg+'%2600N30000004yn1k%3D'+objacc.territory+'%2600N300000074BLj%3D'+objacc.GPAccName+'%2600N300000074BLl%3D'+ objacc.GPAccNo+'%2600N30000004yn1p%3D'+objacc.accName+'%2600N300000074BLk%3D'+objacc.geo+'%2600Na000000Allhe%3D'+'Other'+'%2600Na000000Allhd%3D'+'Territory'+'%2600Na000000Allhg%3D'+Label.SegmentVal3);
                else
                    srchResPage1 = Page.DE_AccCreate_VFP;
                //System.debug('____objacc'+ objacc);
            }    
        }
        
        if(ApexPages.currentPage().getParameters().get('count') != null)
            pageCount =  Integer.valueOf(ApexPages.currentPage().getParameters().get('count')) + 1;
        else 
            pageCount = 1;
        
        srchResPage1.getParameters().put('count', String.valueOf(pageCount));
        
        return srchResPage1;
    }
    @TestVisible
    List<DE_AccResWithDuns_CLS> bindLocalSearchREsults() {
        //perform local search
        string strTemp = accountName.replace('\'','\\\'');
        String queryString = 'Select id, Name, DUNS__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, Country_Picklist__c, Coverage_Model__c, Segment__c,Enterprise_ID__c,Tradestyle from Account where Coverage_Model__c != \'\' and Segment__c != \'\' and Enterprise_ID__c != \'\' and name like \'%'+strTemp+'%\' ';
        if( physicalCountry <> '--Select--') queryString += ' and Country_Picklist__c  = \'' + physicalCountry + '\'';
        if( physicalCity <> '') queryString += ' and BillingCity like \'%' + physicalCity + '\'';
        if( physicalState <> '' && physicalState <> '--Select--') queryString += ' and BillingState like \'%' + physicalState + '\''; 
        if( ZipPostalCode <> '') queryString += ' and BillingPostalCode like \'%' + ZipPostalCode + '\'';
        
        //CR 200-79095: suppress the Partner Accounts from appearing in the Account search in SFDC for all entry points in the DE search & create account tool.
        //Dan 8/5/14
        if( UserInfo.getUserType() == 'PowerPartner' ) queryString += ' and RecordTypeId != \'' + SystemIdUtility.getResellerDistRecordTypeId() + '\'';
        
        queryString += ' Limit 5';
        
        System.debug('____Local Search Query  '+ queryString);
        List<sObject> accountResults = Database.query(queryString);
        
        Account accRec = new Account();
        List<DE_AccResWithDuns_CLS> searchresultset = new List<DE_AccResWithDuns_CLS>();
        
        if(accountResults.size() == 0) return searchresultset; 
        
        for(SObject accountRec : accountResults) {
            DE_AccResWithDuns_CLS objRec = new DE_AccResWithDuns_CLS();
            accRec = (Account)accountRec;
            //objRec.accDunsNo = accRec.DUNS__c;
            objRec.accId = accRec.id;
            objRec.accName = accRec.name;
            objRec.street = accRec.BillingStreet;
            objRec.state = accRec.BillingState;
            objRec.city = accRec.BillingCity;
            objRec.country = accRec.Country_Picklist__c;
            objRec.coverMod = accRec.Coverage_Model__c;
            objRec.segment = accRec.Segment__c;
            objRec.caAccountId = accRec.Enterprise_ID__c;
            
            searchresultset.add(objRec);
        }
        return searchresultset;
    }
    
    PageReference parseAccSrchResponse(HTTPResponse response, boolean IsFirstSearch) {
        integer rowcount = 0;
        selecteDuns = null;
        Integer ccodevalLocal;
        Integer nHasAccCount = 0;
        Map<Integer,List<DE_AccResWithDuns_CLS>> mapAccountsWithConfidenceCodeId = new Map<Integer,List<DE_AccResWithDuns_CLS>>();
        List<DE_AccResWithDuns_CLS> temp;
        DE_AccResWithDuns_CLS objaccRes;
        hasBestMatch = false;
        Dom.Document doc = response.getBodyDocument();
        //Retrieve the root element for this document.
        Dom.XMLNode xmlOut = doc.getRootElement();
        
        if(IsFirstSearch) { //EAI Service call strategy "DUNS_Get-Cleanse-Match"
            Dom.XMLNode xmlGetCleanse = xmlOut.getChildElement('GetCleanseMatchResponseDetail',null);
            if(xmlOut.getChildElement('GetCleanseMatchResponseDetail',null) != null) {
                if(xmlGetCleanse.getChildElement('MatchResponseDetail',null) != null) {
                    Dom.XMLNode xmlMatchDetail = xmlGetCleanse.getChildElement('MatchResponseDetail',null);
                    Dom.XMLNode xmlMatches = xmlMatchDetail.getChildElement('MatchCandidate',null);
                    if(xmlMatchDetail <> null) {
                        objaccMap = new Map<String,DE_AccResWithDuns_CLS>();
                        resultSet1 = new List<DE_AccResWithDuns_CLS>();
                        for(Dom.XMLNode child : xmlMatchDetail.getChildElements()) {
                            if(child.getName() == 'MatchCandidate') {
                                objaccRes = new DE_AccResWithDuns_CLS();
                                //objaccRes.hasBestMatch = false;
                                if(rowcount == 0) {
                                    //Assumption Top Record has high CCCodeAttached to it.
                                    if(child.getChildElement('MatchQualityInformation', null) != null)
                                        if(child.getChildElement('MatchQualityInformation', null).getChildElement('ConfidenceCodeValue', null) != null)
                                        ccodevalLocal = integer.valueof(child.getChildElement('MatchQualityInformation', null).getChildElement('ConfidenceCodeValue', null).getText());
                                    //check confidence code is greater than 7
                                    if(ccodevalLocal > 7) {
                                        hasBestMatch = true;
                                        objaccres.hasBestMatch = true;
                                    }   
                                    else
                                        objaccRes.hasBestMatch = false; 
                                    objaccres.IsFirstRow = true;
                                }  
                                
                                else {
                                    //hasBestMatch = false;
                                    objaccres.hasBestMatch = false;
                                    objaccres.IsFirstRow = false;
                                }     
                                rowcount++;
                                objaccres.strChecked = '';
                                //get child tags and bind data to wrapper class
                                if(child.getChildElement('DisplaySequence', null) != null) objaccRes.displayseq = child.getChildElement('DisplaySequence', null).getText();
                                if(child.getChildElement('DUNSNumber', null) != null) objaccRes.accDunsNo = child.getChildElement('DUNSNumber', null).getText();
                                if(child.getChildElement('OrganizationPrimaryName', null) != null)
                                    if(child.getChildElement('OrganizationPrimaryName', null).getChildElement('OrganizationName', null) != null) objaccRes.accName = child.getChildElement('OrganizationPrimaryName', null).getChildElement('OrganizationName', null).getText();
                                if(child.getChildElement('PrimaryAddress', null) != null)
                                    if(child.getChildElement('PrimaryAddress', null).getChildElement('StreetAddressLine', null) != null)
                                    if(child.getChildElement('PrimaryAddress', null).getChildElement('StreetAddressLine', null).getChildElement('LineText', null) != null) objaccRes.address = child.getChildElement('PrimaryAddress', null).getChildElement('StreetAddressLine', null).getChildElement('LineText', null).getText(); 
                                if(child.getChildElement('PrimaryAddress', null) != null)
                                    if(child.getChildElement('PrimaryAddress', null).getChildElement('PrimaryTownName', null) != null) objaccRes.city = child.getChildElement('PrimaryAddress', null).getChildElement('PrimaryTownName', null).getText();
                                if(child.getChildElement('PrimaryAddress', null) != null)
                                    if(child.getChildElement('PrimaryAddress', null).getChildElement('TerritoryAbbreviatedName', null) != null) objaccRes.state = child.getChildElement('PrimaryAddress', null).getChildElement('TerritoryAbbreviatedName', null).getText();
                                if(child.getChildElement('PrimaryAddress', null) != null)
                                    if(child.getChildElement('PrimaryAddress', null).getChildElement('CountryISOAlpha2Code', null) != null) objaccRes.country = child.getChildElement('PrimaryAddress', null).getChildElement('CountryISOAlpha2Code', null).getText();
                                if(child.getChildElement('TradeStyleName', null) != null)
                                    if(child.getChildElement('TradeStyleName', null).getChildElement('OrganizationName', null) != null) objaccRes.tradeStyle = child.getChildElement('TradeStyleName', null).getChildElement('OrganizationName', null).getText();
                                
                                if(objaccres.IsFirstRow){
                                    selecteDuns = objaccRes.accDunsNo;
                                    objaccres.strChecked = 'checked';
                                }
                                //Commented as this was not fetching in the input payload
                                objaccMap.put(objaccRes.accDunsNo,objaccRes);
                                //objaccMap.put(objaccRes.displayseq,objaccRes);
                                resultSet1.add(objaccRes);
                                //resultSet1.sort();
                            }//if MatchCandidate
                        }//for Loop
                        System.debug('________________'+resultSet1[0]);
                        //resultSet1.addAll(objaccMap.Values());
                        system.debug('**** resultset1.size ***** '+resultset1.size());
                        recordCount = resultset1.size();
                        
                        //if it has best match 
                        if(hasBestMatch) {//bind NoMatchRec with Best Match rec
                            //resultSet1.add(createNoMatchRec(objaccMap.get('1')));
                            
                            //as now the new map is formed with the duns no as key not the sequence ID
                            resultSet1.add(createNoMatchRec(resultSet1[0]));
                            System.debug('________________'+resultSet1);
                        }
                        else resultSet1.add(createNoMatchRec(null));
                        
                        if(resultset1 <> null) {
                            selectedSize = Label.DE_PaginationSize;
                            displayresults1();
                        }
                        
                        //resultSet1.add(createNoMatchRec());
                        srchResPage1 = Page.DE_AccSrchResDuns_VFP;
                    }//if xmlMatchDetail
                }//if MatchResponseDetail
            }// if GetCleanseMatchResponseDetail
            else {
                //do second search
                CallEAIServiceForAccountSearch(false);
            }
        }//if FirstSearch
        else { //EAI Service call strategy "MDM-Account-Search"
            objacc = new DE_AccResWithDuns_CLS();
            rowcount = 0;
            List<String> lstAccSFDCIds = new List<String>();
            Dom.XMLNode xmlMatches = xmlOut.getChildElement('matches',null);
            objaccMap = new Map<String,DE_AccResWithDuns_CLS>();
            resultSet2 = new List<DE_AccResWithDuns_CLS>();
            if(xmlMatches <> null) {
                if(xmlMatches.getChildElements().size() > 0) {
                    for(Dom.XMLNode child : xmlMatches.getChildElements()) {
                        if(child.getChildElement('matchType', null) != null) {
                            if(child.getChildElement('matchType', null).getText() <> 'ORIGINAL') { 
                                OrgRecord = new DE_AccResWithDuns_CLS();
                                System.debug(rowcount+'____xmlMatches.getChildElements()'+xmlMatches.getChildElements().size());
                                objaccRes = new DE_AccResWithDuns_CLS();
                                //if(rowcount < 999) { 
                                if(rowcount == 0)  
                                    objaccres.IsFirstRow = true;
                                else 
                                    objaccres.IsFirstRow = false; 
                                rowcount++;
                                if (child.getChildElement('segment', null) != null) objaccRes.segment = child.getChildElement('segment', null).getText();
                                if (child.getChildElement('geo', null) != null) objaccRes.geo = child.getChildElement('geo', null).getText();
                                if (child.getChildElement('operatingArea', null) != null)  objaccRes.opparea = child.getChildElement('operatingArea', null).getText();
                                if (child.getChildElement('salesRegion', null) != null)  objaccRes.salReg = child.getChildElement('salesRegion', null).getText();
                                if (child.getChildElement('territory', null) != null)  objaccRes.territory = child.getChildElement('territory', null).getText();
                                if (child.getChildElement('caAccountId', null) != null)  objaccRes.caAccountId = child.getChildElement('caAccountId', null).getText();
                                if (child.getChildElement('accountStatus', null) != null)  objaccRes.accStatus = child.getChildElement('accountStatus', null).getText();
                                if (child.getChildElement('coverageModel', null) != null)  objaccRes.coverMod = child.getChildElement('coverageModel', null).getText();
                                //if (child.getChildElement('salesVolume', null) != null)  objaccRes.caAccountId = child.getChildElement('salesVolume', null).getText();
                                if (child.getChildElement('sicCode', null) != null)  objaccRes.sicCode = child.getChildElement('sicCode', null).getText();
                                if (child.getChildElement('sicDesc', null) != null)  objaccRes.sicDesc = child.getChildElement('sicDesc', null).getText();
                                //if (child.getChildElement('isDeleted', null) != null)  objaccRes.caAccountId = child.getChildElement('isDeleted', null).getText();
                                //if (child.getChildElement('recordTypeId', null) != null)  objaccRes.caAccountId = child.getChildElement('recordTypeId', null).getText();
                                if (child.getChildElement('sfdcAccountId', null) != null)  objaccRes.accId = child.getChildElement('sfdcAccountId', null).getText();
                                if (child.getChildElement('globalParentSegment', null) != null)  objaccRes.GPSeg = child.getChildElement('globalParentSegment', null).getText();
                                if (child.getChildElement('physicalState', null) != null)  objaccRes.state = child.getChildElement('physicalState', null).getText();
                                if (child.getChildElement('physicalStreet', null) != null)  objaccRes.address = child.getChildElement('physicalStreet', null).getText();
                                if (child.getChildElement('physicalZip', null) != null)  objaccRes.zipCode = child.getChildElement('physicalZip', null).getText();
                                //if (child.getChildElement('physicalCountry', null) != null)  objaccRes.country = child.getChildElement('physicalCountry', null).getText();
                                if (child.getChildElement('countryPickList', null) != null)  objaccRes.country = child.getChildElement('countryPickList', null).getText();
                                if (child.getChildElement('accountName', null) != null)  objaccRes.accName = child.getChildElement('accountName', null).getText();
                                if (child.getChildElement('countryPickList', null) != null)  objaccRes.country = child.getChildElement('countryPickList', null).getText();
                                if (child.getChildElement('physicalCity', null) != null)  objaccRes.city= child.getChildElement('physicalCity', null).getText();
                                if (child.getChildElement('globalParentSIC2Digit', null) != null)  objaccRes.GPSIC2Digit = child.getChildElement('globalParentSIC2Digit', null).getText();
                                if (child.getChildElement('globalParentSIC4Digit', null) != null)  objaccRes.GPSIC4Digit = child.getChildElement('globalParentSIC4Digit', null).getText();
                                if (child.getChildElement('globalParentIndustry', null) != null)  objaccRes.GPIndustry = child.getChildElement('globalParentIndustry', null).getText();
                                //if (child.getChildElement('accountType', null) != null)  objaccRes.caAccountId = child.getChildElement('accountType', null).getText();
                                
                                objaccMap.put(objaccRes.accId,objaccRes);
                                lstAccSFDCIds.add(objaccRes.accId);
                                //}//Check Limit Exceeds 1000
                            }//if Not ORIGINAL
                            else { //if ORIGINAL Matchtypeexists 
                                OrgRecord = new DE_AccResWithDuns_CLS();
                                system.debug(objAcc+'OrgRecord'+OrgRecord); 
                                //following are the set of values to be set irrespective of the GP number 
                                if (child.getChildElement('geo', null) != null) OrgRecord.geo = child.getChildElement('geo', null).getText();
                                OrgRecord.GobUltReg = OrgRecord.geo;
                                if (child.getChildElement('operatingArea', null) != null)  OrgRecord.opparea = child.getChildElement('operatingArea', null).getText();
                                if (child.getChildElement('salesRegion', null) != null)  OrgRecord.salReg = child.getChildElement('salesRegion', null).getText();
                                if (child.getChildElement('territory', null) != null)  OrgRecord.territory = child.getChildElement('territory', null).getText();
                                if (child.getChildElement('globalParentNumber', null) != null) OrgRecord.GPAccNo = child.getChildElement('globalParentNumber', null).getText();
                                if (OrgRecord.GPAccNo != '' && OrgRecord.GPAccNo != null)
                                {
                                    //Assign this set if the GP no is found
                                    if (child.getChildElement('globalParentName', null) != null) OrgRecord.GPAccName = child.getChildElement('globalParentName', null).getText();
                                    if (child.getChildElement('globalParentSIC4Digit', null) != null)  OrgRecord.GPSIC4Digit = child.getChildElement('globalParentSIC4Digit', null).getText();
                                    //OrgRecord.accName = OrgRecord.GPAccName;
                                    OrgRecord.accName = accountName;
                                    OrgRecord.CAAccountName = OrgRecord.GPAccName;
                                }
                                else
                                {
                                    //Assign this set if the GP no is not found
                                    OrgRecord.accName = accountName;
                                    OrgRecord.CAAccountName = accountName;
                                }
                                OrgRecord.street = physicalAddress;
                                OrgRecord.city = physicalCity;
                                OrgRecord.state = strStateCode;  //physicalState;
                                OrgRecord.country = physicalCountry;
                                OrgRecord.zipCode = ZipPostalCode;
                                OrgRecord.segment = Label.SegmentVal3;
                                OrgRecord.coverMod = 'Territory';
                                OrgRecord.GPSeg = 'Other';
                                //Commented as this has to be done i nthe next button so that if user navigates from Previous should reflect
                                objacc = OrgRecord;
                                System.debug(objacc+'_______________'+OrgRecord);
                            }//else ORIGNIAL Match Type
                        }//if matchType <> null
                    } //for
                }// if xml match
            }//if xml matches
            else { // Navigate to Account Create Screen with Search Data if there are no matches
                objacc.accName = accountName;
                objacc.city = physicalCity;
                objacc.country = physicalCountry;
                objacc.state = strStateCode;  //physicalState;
                objacc.street = physicalAddress;
                objacc.zipCode = ZipPostalCode;
                if(isTaqProcess)
                    //srchResPage1 = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street);
                    srchResPage1 = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street+'%2600N30000004yn2b%3D'+objacc.geo+'%2600N30000004yn1a%3D'+objacc.opparea+'%2600N30000004yn3K%3D'+objacc.salReg+'%2600N30000004yn1k%3D'+objacc.territory+'%2600N300000074BLj%3D'+objacc.GPAccName+'%2600N300000074BLl%3D'+ objacc.GPAccNo+'%2600N30000004yn1p%3D'+objacc.accName+'%2600N300000074BLk%3D'+objacc.geo+'%2600Na000000Allhe%3D'+'Other'+'%2600Na000000Allhd%3D'+'Territory'+'%2600Na000000Allhg%3D'+Label.SegmentVal3);
                else
                    srchResPage1 = Page.DE_AccCreate_VFP;
            }
            
            List<String> lid = new List<String>();
            lid.addAll(objaccMap.keyset());
            
            List<UserRecordAccess> lura = [SELECT RecordId, HasReadAccess, HasEditAccess, HasTransferAccess, MaxAccessLevel FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId =:lid];
            system.debug('Lis of user access : '+lura);
            
            DE_AccResWithDuns_CLS tempObj = new DE_AccResWithDuns_CLS();
            //Also Check SFDC IDs flows from MDM is valid in SFDC or not
            for(UserRecordAccess ura : lura){
                tempObj = objaccMap.get(ura.recordId);
                tempObj.hasAccess = ura.HasReadAccess;
                //searchresultset.add(objaccMap.get(ura.recordId));
                //bypassing the access if its a Partner user searching for the accounts 
                if(!tempObj.hasAccess && bIsPartner) {
                    tempObj.hasAccess = true;
                }
                else {
                    nHasAccCount += 1;
                    
                }
                //added this to make the first row by default selected
                if(ura.HasReadAccess && tempObj.IsFirstRow)
                    tempObj.IsFirstRow = true;
                else
                    tempObj.IsFirstRow = false;
            }
            if(nHasAccCount > 0) hasNoAccess = true;
            
            //CR 300-163533: adding the check for the SFDC Id sent from MDM is whether a deleted Account Id or not
            //Anitha modified 02-May
            Map<String,DE_AccResWithDuns_CLS> tempMap = new Map<String,DE_AccResWithDuns_CLS>();
            
            List<Account> validSFDCAccs = [Select id, RecordTypeId from Account where id =: lid];
            
            System.debug(validSFDCAccs.size()+'___before removal of invalid accounts'+objaccMap);
            if(validSFDCAccs.size() == 0)
                objaccMap.clear();//No records are valid    
            else if(validSFDCAccs.size() <> objaccMap.size())
                for(Account validacc: validSFDCAccs)
                if(objaccMap.get(validacc.id) <> null)
                tempMap.put(validacc.id, objaccMap.get(validacc.id));   
            
            if(tempMap.size() > 0) {
                objaccMap.clear();  
                objaccMap.putAll(tempMap);       
            }
            
            System.debug('___after removal of invalid accounts'+objaccMap);
            
            //CR 200-79095: suppress the Partner Accounts from appearing in the Account search in SFDC for all entry points in the DE search & create account tool.
            //Dan 8/5/14
            System.debug('CR 200-79095 pre suppression:: UserType=' + UserInfo.getUserType()  + '; size=' + objaccmap.size() + '; ' + validSFDCAccs ); 
            if(UserInfo.getUserType() == 'PowerPartner' && !objaccMap.isEmpty())
            {
                tempMap.clear();
                Map<String,Account> accMap = new Map<String,Account>(validSFDCAccs);
                for(String strId : objaccMap.keySet())
                {
                    Account acc = accMap.get(strId);
                    if(acc.RecordTypeId != SystemIdUtility.getResellerDistRecordTypeId())
                        tempMap.put(acc.Id, objaccMap.get(acc.Id)); 
                }
                
                objaccMap = tempMap.clone();
            }
            
            System.debug('CR 200-79095 post suppression:: UserType=' + UserInfo.getUserType() + '; size=' + objaccmap.size() + '; ' + validSFDCAccs ); 
            
            if(objaccMap.size() > 0) {
                //iterate through the list so that its in aligned sorted with the MDM response output
                for(String recId:lstAccSFDCIds)
                    resultSet2.add(objaccMap.get(recId));
                //resultSet2.addAll(objaccMap.Values());
                //assign this here as now the defult selection would go to the Create New Record
                resultSet2.add(createNewRecord());
                System.debug('__________ResultSet2'+resultSet2);
                if(resultset2 <> null) {
                    selectedSize = Label.DE_PaginationSize;
                    displayresults2();
                }
                
                srchResPage1 = Page.DE_AccSrchRes2_VFP;
            }
            else if(OrgRecord <> null) { //Response has only OrgRecord navigate to Create Screen with this data
                if(isTaqProcess)
                    //srchResPage1 = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street);
                    srchResPage1 = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street+'%2600N30000004yn2b%3D'+objacc.geo+'%2600N30000004yn1a%3D'+objacc.opparea+'%2600N30000004yn3K%3D'+objacc.salReg+'%2600N30000004yn1k%3D'+objacc.territory+'%2600N300000074BLj%3D'+objacc.GPAccName+'%2600N300000074BLl%3D'+ objacc.GPAccNo+'%2600N30000004yn1p%3D'+objacc.accName+'%2600N300000074BLk%3D'+objacc.geo+'%2600Na000000Allhe%3D'+'Other'+'%2600Na000000Allhd%3D'+'Territory'+'%2600Na000000Allhg%3D'+Label.SegmentVal3);
                else
                    srchResPage1 = Page.DE_AccCreate_VFP;
            }
        } //second serach
        
        /*  //MANAR08
calcPageCount(); */        
        return srchResPage1;
    }
    
    //This is the next button from the second result screen
    public PageReference nextPage() {
        
        
        if(selectedSFDCId != '') return null;
        //Boolean bIsPartner = false;
        PageReference newPage = ApexPages.currentPage();      
        newPage.setRedirect(false);
        
        //check for business rules here if passed navigate the user else not 
        if(resultset2.size() > 0 )
            if(isBRMatchRecFound(bIsPartner, resultset2, OrgRecord))
        {
            ApexPages.Message error = new Apexpages.Message(ApexPages.Severity.Error,strErrMsg);
            Apexpages.addMessage(error);
            return newPage;
        }
        
        
        for (DE_AccResWithDuns_CLS obj : resultSet2) {
            if(resultSet2.size() < 0 && OrgRecord == null) {
                objacc = new DE_AccResWithDuns_CLS();
                objacc.accName = accountName;
                objacc.city = physicalCity;
                objacc.country = physicalCountry;
                objacc.state = strStateCode; //physicalState;//strStateCode
                objacc.street = physicalAddress;
                objacc.zipCode = ZipPostalCode;
            }
            
            else {//Result Set 2 Has some data and user go with Create Original Account data has to be filled
                //this part is also called if the user hits the previous button so need to assign here itself only
                objacc = new DE_AccResWithDuns_CLS();
                objacc = OrgRecord;
            }
            
        }
        system.debug('Assigned the objacc-----'+objacc);
        // changes made by mrudula
        if(isTaqProcess)
        {
            //newPage = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street);
            newPage  = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01I300000016GJh&retURL=%2Fa15%2Fo&save_new_url=%2Fa15%2Fe%3FretURL%3D%252Fa15%252Fo%26Name%3D'+objacc.accName+'%2600N30000004yn2M%3D'+objacc.city+'%2600N30000004yn2Q%3D'+objacc.zipCode+'%2600N30000004yn2O%3D'+objacc.state+'%2600Na000000Allhc%3D'+objacc.country+'%2600N30000004yn2P%3D'+objacc.street+'%2600N30000004yn2b%3D'+objacc.geo+'%2600N30000004yn1a%3D'+objacc.opparea+'%2600N30000004yn3K%3D'+objacc.salReg+'%2600N30000004yn1k%3D'+objacc.territory+'%2600N300000074BLj%3D'+objacc.GPAccName+'%2600N300000074BLl%3D'+ objacc.GPAccNo+'%2600N30000004yn1p%3D'+objacc.accName+'%2600N300000074BLk%3D'+objacc.geo+'%2600Na000000Allhe%3D'+'Other'+'%2600Na000000Allhd%3D'+'Territory'+'%2600Na000000Allhg%3D'+Label.SegmentVal3);
        }
        else
        {
            newPage  = Page.DE_AccCreate_VFP;
        }
        //newPage.setRedirect(false);
        return newPage; 
    }
    
    public Void createTaqAccount()
    {
        List<Account> lstExistingAccs ;
        string taqSelectedRecType = '';
        string strAccCountry = '';
        system.debug('Testing objacc-----'+objacc);
        
        if (objacc.accName == '' || objacc.country == null || objacc.city == null || ((objacc.country == 'US - UNITED STATES' ||  objacc.country == 'CA - CANADA' ||  objacc.country == 'IN - INDIA' ||  objacc.country == 'AU - AUSTRALIA') && objacc.state == null)) {
            strErrMsg = 'Please enter all the mandatory fields.';
            if(ApexPages.currentPage() != null)
            {
                Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error,'Please enter all the mandatory fields.');
                Apexpages.addMessage(error);
            }
            else
                System.debug('Error from Site Association : '+strErrMsg);
            //return null;
        }
        
        RecordType TaqRT = [SELECT Id,Name FROM RecordType WHERE SobjectType='TAQ_Account__c' and Name = 'Regional Account' ];
        //CR 300-163533: Commented for this CR
        //User TaqOwner = [select id,username from User where Username like 'taqprovisioning@ca.com%' ];
        
        List<SIC__C> siccode;
        if(objacc.GPSIC4Digit <> null) {
            siccode = [select id from SIC__c where SIC_Code__c =: integer.valueof(objacc.GPSIC4Digit) LIMIT 1];
            System.debug(objacc.GPSIC4Digit+'________________integer.valueof(objacc.GPSIC4Digit)'+integer.valueof(objacc.GPSIC4Digit));
        }
        
        TAQ_Account__c objTAQAcc = new TAQ_Account__c();
        //objTAQAcc.Name = accountName;
        objTAQAcc.Name = objacc.accName;
        //Set the TAQ owner
        //CR 300-163533: adding this condition as for Pending Review the owner must be in the TAQ Add Account Approver queue
        //objTAQAcc.OwnerId = TaqOwner.id;
        objTAQAcc.OwnerId = QueueCust__c.getInstance('TAQ Add Account Approver').Queue_ID__c;
        objTAQAcc.RecordTypeId = TaqRT.id;
        objTAQAcc.Physical_City__c = objacc.city;
        objTAQAcc.Country_Picklist__c = objacc.country;
        objTAQAcc.Physical_State_Province__c = objacc.state;
        objTAQAcc.Physical_State_Prov_Local__c = objacc.state;
        objTAQAcc.Physical_Street__c = objacc.street;
        objTAQAcc.Physical_Zip_Postal_Code__c = objacc.zipCode;
        objTAQAcc.Region__c = objacc.geo; 
        objTAQAcc.Area__c = objacc.opparea;
        objTAQAcc.Territory__c = objacc.salReg;
        objTAQAcc.Country__c = objacc.territory;
        objTAQAcc.Global_Ultimate_Name__c = objacc.GPAccName;
        objTAQAcc.Global_Ultimate__c = objacc.GPAccNo;
        objTAQAcc.Global_Ultimate_Region__c = objacc.geo;
        
        if(siccode <> null && siccode.size() > 0)
            objTAQAcc.GP_SIC__c = siccode[0].id;
        
        //if(siccode <> null)
        //objTAQAcc.GP_SIC__c = siccode[0].id;
        
        if(saRecord != null)
        {
            objTAQAcc.GP_SIC__c = objacc.GPSIC;
        }       
        
        //Following values will be hardcoded here as no user selection    
        objTAQAcc.Segment__c = Label.SegmentVal3;            
        objTAQAcc.Coverage_Model__c = Label.CovModelVal2;
        objTAQAcc.Global_Parent_Segment__c = 'Other';
        objTAQAcc.Is_Admin_Approved__c = true;
        
        //Initially the status will be empty as insert of TAQ account should happen.
        objTAQAcc.Approval_Process_Status__c = '';//strAccApprovalStatus;
        objTAQAcc.Process_Step__c='Account Add';
        if(saRecord != null)
            objTAQAcc.FromSARecord__c = true;
        
        insert(objTAQAcc);
        
        TAQ_Account_Team__c tt = new TAQ_Account_Team__c();
        tt.Is_Account_Owner__c = true;
        
        if(objacc.GPAccNo == null) {
            if (strAccApprovalStatus == '') strAccApprovalStatus = 'Pending Review';
            //objTAQAcc.chkPendingReview__c = true;
            objTAQAcc.Is_Error_in_Rule__c = false;        
            objTAQAcc.Process_Step__c='Account Add';
        }
        else {
            if (strAccApprovalStatus == '') strAccApprovalStatus = 'Approved';  
            objTAQAcc.Is_Admin_Approved__c= true;
            //need to reassign here as in  the code this value is made to empty again.
            objTAQAcc.Is_Error_in_Rule__c = false;
            objTAQAcc.Process_Step__c='Account Add';
            objTAQAcc.Is_Primary_Account__c = true;
        }
        system.debug('+++++++++++++++strAccApprovalStatus +++++++'+strAccApprovalStatus );
        objTAQAcc.Approval_Process_Status__c = strAccApprovalStatus;  //'Pending Review';
        
        
        update(objTAQAcc);
        
        system.debug('---------------objtaqacc.id----------------------'+objtaqacc.id);
        
        //Added by Vikas
        List<TAQ_Account__c> t = [select view_Acc_record__c,Enterprise_Id__c,Approval_Status__c from taq_Account__c where id=:objtaqacc.id];
        system.debug('Taq list---'+t);
        if (t.size() > 0)
        {
            List<Account> acc = [select id,name,Enterprise_Id__c,account_status__c  from Account where id=:t[0].View_Acc_Record__c];
            system.debug('printing account name'+acc[0].name );
            system.debug('acc list-----'+acc);
            if (acc.size() > 0)
            {
                User genericOwner = new User();               
                genericOwner = [SELECT Id from User where Name = 'Generic Owner' and isActive = true];                
                acc[0].ownerid = genericOwner.Id;              
                if(acc[0].account_status__c != 'Pending Review')
                {
                    acc[0].Enterprise_Id__c = t[0].Enterprise_ID__c;
                    update(acc);
                } 
                
                accid = acc[0].id;
                system.debug('accid-------'+accid);
                accname = acc[0].name;
                system.debug('accname---1----'+accname);
                accname = accname.replace('\'','\\\'');
                system.debug('accname---2----'+accname);
                if(pagered!=null && pagered.equals('StandNew'))
                {
                    system.debug('In Page Refrence');
                    // PageReference pageEdit = new PageReference('/'+accid);
                    //pageEdit.setRedirect(true);
                    // return pageEdit;
                }
                
                if(saRecord != null)
                {
                    sarecord.Site_Status__c = 'Approved';
                    sarecord.Enterprise_ID__c = accid;
                    update(sarecord);
                }
            }
        }
        // return null;
    }
    
    public void populateSAForNewAcc(string SAID) {
        
        //Country not there
        List<Site_Association__c> existSA = [Select GP_SIC__c, Country_Picklist__c, Street__c, State__c, Postal_Code__c, City__c,Country__c,Region__c,DUNS_Number__c,DUNS_Name__c,Area__c,
                                             Territory_Country__c,GP_DUNS_NUMBER__c,GP_NAME__c from Site_Association__c where id =: SAID ];
        system.debug('samap01 SAID'+SAID);
        if (existSA.size() == 0) 
        {
            System.debug('Error in populateSAForNewAcc : Site association details could not be populated.');
            return;
        }
        saRecord = existSA[0];
        system.debug('SA details + '+saRecord );
        //Coming from site association screen hence will be read only screen as thee duns info is available
        objacc = new DE_AccResWithDuns_CLS();
        objacc.GPSIC = saRecord.GP_SIC__c;
        objacc.accName = saRecord.GP_NAME__c;  //saRecord.DUNS_Name__c; //saRecord.GU_NAME__c; // saRecord.GP_NAME__c;
        objacc.street=saRecord.Street__c;
        objacc.city =saRecord.City__c;
        objacc.state =saRecord.State__c;
        objacc.country =saRecord.Country_Picklist__c;
        objacc.zipCode=saRecord.Postal_Code__c;
        objacc.geo=saRecord.Region__c;
        objacc.GPAccNo=saRecord.GP_DUNS_NUMBER__c;
        objacc.GPAccName=saRecord.GP_NAME__c;
        objacc.opparea=saRecord.Area__c;
        objacc.salReg=saRecord.Territory_Country__c;
        objacc.GPSeg='Other';
        objacc.territory=saRecord.Country__c;
        objacc.segment=Label.SegmentVal3;
        objacc.coverMod='Territory';    
        objacc.accDunsNo =  saRecord.DUNS_Number__c;
        
    }
    
    DE_AccResWithDuns_CLS createNewRecord() {
        DE_AccResWithDuns_CLS objNewRec = new DE_AccResWithDuns_CLS();
        //objNewRec = objaccRes;
        objNewRec.accDunsNo = selecteDuns;
        objNewRec.accId = '';
        objNewRec.accName = 'Create New Record';
        objNewRec.hasAccess = true;
        objNewRec.IsFirstRow = false;
        
        return  objNewRec;
    }
    
    string getSFDCountryFrmCountryCode(string strCountryCode)
    {
        string strReturn = '';
        if(strCountryCode == 'AD') { strReturn = 'AD - ANDORRA'; }
        else if(strCountryCode == 'AE') { strReturn = 'AE - UNITED ARAB EMIRATES'; }
        else if(strCountryCode == 'AF') { strReturn = 'AF - AFGHANISTAN'; }
        else if(strCountryCode == 'AG') { strReturn = 'AG - ANTIGUA AND BARBUDA'; }
        else if(strCountryCode == 'AI') { strReturn = 'AI - ANGUILLA'; }
        else if(strCountryCode == 'AL') { strReturn = 'AL - ALBANIA'; }
        else if(strCountryCode == 'AM') { strReturn = 'AM - ARMENIA'; }
        else if(strCountryCode == 'AN') { strReturn = 'AN - NETHERLANDS ANTILLES'; }
        else if(strCountryCode == 'AO') { strReturn = 'AO - ANGOLA'; }
        else if(strCountryCode == 'AQ') { strReturn = 'AQ - ANTARCTICA'; }
        else if(strCountryCode == 'AR') { strReturn = 'AR - ARGENTINA'; }
        else if(strCountryCode == 'AS') { strReturn = 'AS - AMERICAN SAMOA'; }
        else if(strCountryCode == 'AT') { strReturn = 'AT - AUSTRIA'; }
        else if(strCountryCode == 'AU') { strReturn = 'AU - AUSTRALIA'; }
        else if(strCountryCode == 'AW') { strReturn = 'AW - ARUBA'; }
        else if(strCountryCode == 'AX') { strReturn = 'AX - ÅLAND ISLANDS'; }
        else if(strCountryCode == 'AZ') { strReturn = 'AZ - AZERBAIJAN'; }
        else if(strCountryCode == 'BA') { strReturn = 'BA - BOSNIA AND HERZEGOVINA'; }
        else if(strCountryCode == 'BB') { strReturn = 'BB - BARBADOS'; }
        else if(strCountryCode == 'BD') { strReturn = 'BD - BANGLADESH'; }
        else if(strCountryCode == 'BE') { strReturn = 'BE - BELGIUM'; }
        else if(strCountryCode == 'BF') { strReturn = 'BF - BURKINA FASO'; }
        else if(strCountryCode == 'BG') { strReturn = 'BG - BULGARIA'; }
        else if(strCountryCode == 'BH') { strReturn = 'BH - BAHRAIN'; }
        else if(strCountryCode == 'BI') { strReturn = 'BI - BURUNDI'; }
        else if(strCountryCode == 'BJ') { strReturn = 'BJ - BENIN'; }
        else if(strCountryCode == 'BL') { strReturn = 'BL - SAINT BARTHÉLEMY'; }
        else if(strCountryCode == 'BM') { strReturn = 'BM - BERMUDA'; }
        else if(strCountryCode == 'BN') { strReturn = 'BN - BRUNEI DARUSSALAM'; }
        else if(strCountryCode == 'BO') { strReturn = 'BO - BOLIVIA'; }
        else if(strCountryCode == 'BR') { strReturn = 'BR - BRAZIL'; }
        else if(strCountryCode == 'BS') { strReturn = 'BS - BAHAMAS'; }
        else if(strCountryCode == 'BT') { strReturn = 'BT - BHUTAN'; }
        else if(strCountryCode == 'BV') { strReturn = 'BV - BOUVET ISLAND'; }
        else if(strCountryCode == 'BW') { strReturn = 'BW - BOTSWANA'; }
        else if(strCountryCode == 'BY') { strReturn = 'BY - BELARUS'; }
        else if(strCountryCode == 'BZ') { strReturn = 'BZ - BELIZE'; }
        else if(strCountryCode == 'CA') { strReturn = 'CA - CANADA'; }
        else if(strCountryCode == 'CC') { strReturn = 'CC - COCOS (KEELING) ISLANDS'; }
        else if(strCountryCode == 'CD') { strReturn = 'CD - CONGO, THE DEMOCRATIC REPUBLIC OF THE'; }
        else if(strCountryCode == 'CF') { strReturn = 'CF - CENTRAL AFRICAN REPUBLIC'; }
        else if(strCountryCode == 'CG') { strReturn = 'CG - CONGO'; }
        else if(strCountryCode == 'CH') { strReturn = 'CH - SWITZERLAND'; }
        else if(strCountryCode == 'CI') { strReturn = 'CI - CÔTE D\'IVOIRE'; }
        else if(strCountryCode == 'CK') { strReturn = 'CK - COOK ISLANDS'; }
        else if(strCountryCode == 'CL') { strReturn = 'CL - CHILE'; }
        else if(strCountryCode == 'CM') { strReturn = 'CM - CAMEROON'; }
        else if(strCountryCode == 'CN') { strReturn = 'CN - CHINA'; }
        else if(strCountryCode == 'CO') { strReturn = 'CO - COLOMBIA'; }
        else if(strCountryCode == 'CR') { strReturn = 'CR - COSTA RICA'; }
        else if(strCountryCode == 'CU') { strReturn = 'CU - CUBA'; }
        else if(strCountryCode == 'CV') { strReturn = 'CV - CAPE VERDE'; }
        else if(strCountryCode == 'CW') { strReturn = 'CW - COURACAO'; }
        else if(strCountryCode == 'CX') { strReturn = 'CX - CHRISTMAS ISLAND'; }
        else if(strCountryCode == 'CY') { strReturn = 'CY - CYPRUS'; }
        else if(strCountryCode == 'CZ') { strReturn = 'CZ - CZECH REPUBLIC'; }
        else if(strCountryCode == 'DE') { strReturn = 'DE - GERMANY'; }
        else if(strCountryCode == 'DJ') { strReturn = 'DJ - DJIBOUTI'; }
        else if(strCountryCode == 'DK') { strReturn = 'DK - DENMARK'; }
        else if(strCountryCode == 'DM') { strReturn = 'DM - DOMINICA'; }
        else if(strCountryCode == 'DO') { strReturn = 'DO - DOMINICAN REPUBLIC'; }
        else if(strCountryCode == 'DZ') { strReturn = 'DZ - ALGERIA'; }
        else if(strCountryCode == 'EC') { strReturn = 'EC - ECUADOR'; }
        else if(strCountryCode == 'EE') { strReturn = 'EE - ESTONIA'; }
        else if(strCountryCode == 'EG') { strReturn = 'EG - EGYPT'; }
        else if(strCountryCode == 'EH') { strReturn = 'EH - WESTERN SAHARA'; }
        else if(strCountryCode == 'ER') { strReturn = 'ER - ERITREA'; }
        else if(strCountryCode == 'ES') { strReturn = 'ES - SPAIN'; }
        else if(strCountryCode == 'ET') { strReturn = 'ET - ETHIOPIA'; }
        else if(strCountryCode == 'FI') { strReturn = 'FI - FINLAND'; }
        else if(strCountryCode == 'FJ') { strReturn = 'FJ - FIJI'; }
        else if(strCountryCode == 'FK') { strReturn = 'FK - FALKLAND ISLANDS (MALVINAS)'; }
        else if(strCountryCode == 'FM') { strReturn = 'FM - MICRONESIA, FEDERATED STATES OF'; }
        else if(strCountryCode == 'FO') { strReturn = 'FO - FAROE ISLANDS'; }
        else if(strCountryCode == 'FR') { strReturn = 'FR - FRANCE'; }
        else if(strCountryCode == 'GA') { strReturn = 'GA - GABON'; }
        else if(strCountryCode == 'GB') { strReturn = 'GB - UNITED KINGDOM'; }
        else if(strCountryCode == 'GD') { strReturn = 'GD - GRENADA'; }
        else if(strCountryCode == 'GE') { strReturn = 'GE - GEORGIA'; }
        else if(strCountryCode == 'GF') { strReturn = 'GF - FRENCH GUIANA'; }
        else if(strCountryCode == 'GG') { strReturn = 'GG - GUERNSEY'; }
        else if(strCountryCode == 'GH') { strReturn = 'GH - GHANA'; }
        else if(strCountryCode == 'GI') { strReturn = 'GI - GIBRALTAR'; }
        else if(strCountryCode == 'GL') { strReturn = 'GL - GREENLAND'; }
        else if(strCountryCode == 'GM') { strReturn = 'GM - GAMBIA'; }
        else if(strCountryCode == 'GN') { strReturn = 'GN - GUINEA'; }
        else if(strCountryCode == 'GP') { strReturn = 'GP - GUADELOUPE'; }
        else if(strCountryCode == 'GQ') { strReturn = 'GQ - EQUATORIAL GUINEA'; }
        else if(strCountryCode == 'GR') { strReturn = 'GR - GREECE'; }
        else if(strCountryCode == 'GS') { strReturn = 'GS - SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS'; }
        else if(strCountryCode == 'GT') { strReturn = 'GT - GUATEMALA'; }
        else if(strCountryCode == 'GU') { strReturn = 'GU - GUAM'; }
        else if(strCountryCode == 'GW') { strReturn = 'GW - GUINEA-BISSAU'; }
        else if(strCountryCode == 'GY') { strReturn = 'GY - GUYANA'; }
        else if(strCountryCode == 'HK') { strReturn = 'HK - HONG KONG'; }
        else if(strCountryCode == 'HM') { strReturn = 'HM - HEARD ISLAND AND MCDONALD ISLANDS'; }
        else if(strCountryCode == 'HN') { strReturn = 'HN - HONDURAS'; }
        else if(strCountryCode == 'HR') { strReturn = 'HR - CROATIA'; }
        else if(strCountryCode == 'HT') { strReturn = 'HT - HAITI'; }
        else if(strCountryCode == 'HU') { strReturn = 'HU - HUNGARY'; }
        else if(strCountryCode == 'ID') { strReturn = 'ID - INDONESIA'; }
        else if(strCountryCode == 'IE') { strReturn = 'IE - IRELAND'; }
        else if(strCountryCode == 'IL') { strReturn = 'IL - ISRAEL'; }
        else if(strCountryCode == 'IM') { strReturn = 'IM - ISLE OF MAN'; }
        else if(strCountryCode == 'IN') { strReturn = 'IN - INDIA'; }
        else if(strCountryCode == 'IO') { strReturn = 'IO - BRITISH INDIAN OCEAN TERRITORY'; }
        else if(strCountryCode == 'IQ') { strReturn = 'IQ - IRAQ'; }
        else if(strCountryCode == 'IR') { strReturn = 'IR - IRAN, ISLAMIC REPUBLIC OF'; }
        else if(strCountryCode == 'IS') { strReturn = 'IS - ICELAND'; }
        else if(strCountryCode == 'IT') { strReturn = 'IT - ITALY'; }
        else if(strCountryCode == 'JE') { strReturn = 'JE - JERSEY'; }
        else if(strCountryCode == 'JM') { strReturn = 'JM - JAMAICA'; }
        else if(strCountryCode == 'JO') { strReturn = 'JO - JORDAN'; }
        else if(strCountryCode == 'JP') { strReturn = 'JP - JAPAN'; }
        else if(strCountryCode == 'KE') { strReturn = 'KE - KENYA'; }
        else if(strCountryCode == 'KG') { strReturn = 'KG - KYRGYZSTAN'; }
        else if(strCountryCode == 'KH') { strReturn = 'KH - CAMBODIA'; }
        else if(strCountryCode == 'KI') { strReturn = 'KI - KIRIBATI'; }
        else if(strCountryCode == 'KM') { strReturn = 'KM - COMOROS'; }
        else if(strCountryCode == 'KN') { strReturn = 'KN - SAINT KITTS AND NEVIS'; }
        else if(strCountryCode == 'KR') { strReturn = 'KR - KOREA, REPUBLIC OF'; }
        else if(strCountryCode == 'KW') { strReturn = 'KW - KUWAIT'; }
        else if(strCountryCode == 'KY') { strReturn = 'KY - CAYMAN ISLANDS'; }
        else if(strCountryCode == 'KZ') { strReturn = 'KZ - KAZAKHSTAN'; }
        else if(strCountryCode == 'LA') { strReturn = 'LA - LAO PEOPLE\'S DEMOCRATIC REPUBLIC'; }
        else if(strCountryCode == 'LB') { strReturn = 'LB - LEBANON'; }
        else if(strCountryCode == 'LC') { strReturn = 'LC - SAINT LUCIA'; }
        else if(strCountryCode == 'LI') { strReturn = 'LI - LIECHTENSTEIN'; }
        else if(strCountryCode == 'LK') { strReturn = 'LK - SRI LANKA'; }
        else if(strCountryCode == 'LR') { strReturn = 'LR - LIBERIA'; }
        else if(strCountryCode == 'LS') { strReturn = 'LS - LESOTHO'; }
        else if(strCountryCode == 'LT') { strReturn = 'LT - LITHUANIA'; }
        else if(strCountryCode == 'LU') { strReturn = 'LU - LUXEMBOURG'; }
        else if(strCountryCode == 'LV') { strReturn = 'LV - LATVIA'; }
        else if(strCountryCode == 'LY') { strReturn = 'LY - LIBYAN ARAB JAMAHIRIYA'; }
        else if(strCountryCode == 'MA') { strReturn = 'MA - MOROCCO'; }
        else if(strCountryCode == 'MC') { strReturn = 'MC - MONACO'; }
        else if(strCountryCode == 'MD') { strReturn = 'MD - MOLDOVA'; }
        else if(strCountryCode == 'ME') { strReturn = 'ME - MONTENEGRO'; }
        else if(strCountryCode == 'MF') { strReturn = 'MF - SAINT MARTIN'; }
        else if(strCountryCode == 'MG') { strReturn = 'MG - MADAGASCAR'; }
        else if(strCountryCode == 'MH') { strReturn = 'MH - MARSHALL ISLANDS'; }
        else if(strCountryCode == 'MK') { strReturn = 'MK - MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF'; }
        else if(strCountryCode == 'ML') { strReturn = 'ML - MALI'; }
        else if(strCountryCode == 'MM') { strReturn = 'MM - MYANMAR'; }
        else if(strCountryCode == 'MN') { strReturn = 'MN - MONGOLIA'; }
        else if(strCountryCode == 'MO') { strReturn = 'MO - MACAO'; }
        else if(strCountryCode == 'MP') { strReturn = 'MP - NORTHERN MARIANA ISLANDS'; }
        else if(strCountryCode == 'MQ') { strReturn = 'MQ - MARTINIQUE'; }
        else if(strCountryCode == 'MR') { strReturn = 'MR - MAURITANIA'; }
        else if(strCountryCode == 'MS') { strReturn = 'MS - MONTSERRAT'; }
        else if(strCountryCode == 'MT') { strReturn = 'MT - MALTA'; }
        else if(strCountryCode == 'MU') { strReturn = 'MU - MAURITIUS'; }
        else if(strCountryCode == 'MV') { strReturn = 'MV - MALDIVES'; }
        else if(strCountryCode == 'MW') { strReturn = 'MW - MALAWI'; }
        else if(strCountryCode == 'MX') { strReturn = 'MX - MEXICO'; }
        else if(strCountryCode == 'MY') { strReturn = 'MY - MALAYSIA'; }
        else if(strCountryCode == 'MZ') { strReturn = 'MZ - MOZAMBIQUE'; }
        else if(strCountryCode == 'NA') { strReturn = 'NA - NAMIBIA'; }
        else if(strCountryCode == 'NC') { strReturn = 'NC - NEW CALEDONIA'; }
        else if(strCountryCode == 'NE') { strReturn = 'NE - NIGER'; }
        else if(strCountryCode == 'NF') { strReturn = 'NF - NORFOLK ISLAND'; }
        else if(strCountryCode == 'NG') { strReturn = 'NG - NIGERIA'; }
        else if(strCountryCode == 'NI') { strReturn = 'NI - NICARAGUA'; }
        else if(strCountryCode == 'NL') { strReturn = 'NL - NETHERLANDS'; }
        else if(strCountryCode == 'NO') { strReturn = 'NO - NORWAY'; }
        else if(strCountryCode == 'NP') { strReturn = 'NP - NEPAL'; }
        else if(strCountryCode == 'NR') { strReturn = 'NR - NAURU'; }
        else if(strCountryCode == 'NU') { strReturn = 'NU - NIUE'; }
        else if(strCountryCode == 'NZ') { strReturn = 'NZ - NEW ZEALAND'; }
        else if(strCountryCode == 'OM') { strReturn = 'OM - OMAN'; }
        else if(strCountryCode == 'PA') { strReturn = 'PA - PANAMA'; }
        else if(strCountryCode == 'PE') { strReturn = 'PE - PERU'; }
        else if(strCountryCode == 'PF') { strReturn = 'PF - FRENCH POLYNESIA'; }
        else if(strCountryCode == 'PG') { strReturn = 'PG - PAPUA NEW GUINEA'; }
        else if(strCountryCode == 'PH') { strReturn = 'PH - PHILIPPINES'; }
        else if(strCountryCode == 'PK') { strReturn = 'PK - PAKISTAN'; }
        else if(strCountryCode == 'PL') { strReturn = 'PL - POLAND'; }
        else if(strCountryCode == 'PM') { strReturn = 'PM - SAINT PIERRE AND MIQUELON'; }
        else if(strCountryCode == 'PN') { strReturn = 'PN - PITCAIRN'; }
        else if(strCountryCode == 'PR') { strReturn = 'PR - PUERTO RICO'; }
        else if(strCountryCode == 'PS') { strReturn = 'PS - PALESTINIAN TERRITORY, OCCUPIED'; }
        else if(strCountryCode == 'PT') { strReturn = 'PT - PORTUGAL'; }
        else if(strCountryCode == 'PW') { strReturn = 'PW - PALAU'; }
        else if(strCountryCode == 'PY') { strReturn = 'PY - PARAGUAY'; }
        else if(strCountryCode == 'QA') { strReturn = 'QA - QATAR'; }
        else if(strCountryCode == 'RE') { strReturn = 'RE - RÉUNION'; }
        else if(strCountryCode == 'RO') { strReturn = 'RO - ROMANIA'; }
        else if(strCountryCode == 'RS') { strReturn = 'RS - SERBIA'; }
        else if(strCountryCode == 'RU') { strReturn = 'RU - RUSSIAN FEDERATION'; }
        else if(strCountryCode == 'RW') { strReturn = 'RW - RWANDA'; }
        else if(strCountryCode == 'SA') { strReturn = 'SA - SAUDI ARABIA'; }
        else if(strCountryCode == 'SB') { strReturn = 'SB - SOLOMON ISLANDS'; }
        else if(strCountryCode == 'SC') { strReturn = 'SC - SEYCHELLES'; }
        else if(strCountryCode == 'SD') { strReturn = 'SD - SUDAN'; }
        else if(strCountryCode == 'SE') { strReturn = 'SE - SWEDEN'; }
        else if(strCountryCode == 'SG') { strReturn = 'SG - SINGAPORE'; }
        else if(strCountryCode == 'SH') { strReturn = 'SH - SAINT HELENA'; }
        else if(strCountryCode == 'SI') { strReturn = 'SI - SLOVENIA'; }
        else if(strCountryCode == 'SJ') { strReturn = 'SJ - SVALBARD AND JAN MAYEN'; }
        else if(strCountryCode == 'SK') { strReturn = 'SK - SLOVAKIA'; }
        else if(strCountryCode == 'SL') { strReturn = 'SL - SIERRA LEONE'; }
        else if(strCountryCode == 'SM') { strReturn = 'SM - SAN MARINO'; }
        else if(strCountryCode == 'SN') { strReturn = 'SN - SENEGAL'; }
        else if(strCountryCode == 'SO') { strReturn = 'SO - SOMALIA'; }
        else if(strCountryCode == 'SR') { strReturn = 'SR - SURINAME'; }
        else if(strCountryCode == 'ST') { strReturn = 'ST - SAO TOME AND PRINCIPE'; }
        else if(strCountryCode == 'SV') { strReturn = 'SV - EL SALVADOR'; }
        else if(strCountryCode == 'SY') { strReturn = 'SY - SYRIAN ARAB REPUBLIC'; }
        else if(strCountryCode == 'SZ') { strReturn = 'SZ - SWAZILAND'; }
        else if(strCountryCode == 'TC') { strReturn = 'TC - TURKS AND CAICOS ISLANDS'; }
        else if(strCountryCode == 'TD') { strReturn = 'TD - CHAD'; }
        else if(strCountryCode == 'TF') { strReturn = 'TF - FRENCH SOUTHERN TERRITORIES'; }
        else if(strCountryCode == 'TG') { strReturn = 'TG - TOGO'; }
        else if(strCountryCode == 'TH') { strReturn = 'TH - THAILAND'; }
        else if(strCountryCode == 'TJ') { strReturn = 'TJ - TAJIKISTAN'; }
        else if(strCountryCode == 'TK') { strReturn = 'TK - TOKELAU'; }
        else if(strCountryCode == 'TL') { strReturn = 'TL - TIMOR-LESTE'; }
        else if(strCountryCode == 'TM') { strReturn = 'TM - TURKMENISTAN'; }
        else if(strCountryCode == 'TN') { strReturn = 'TN - TUNISIA'; }
        else if(strCountryCode == 'TO') { strReturn = 'TO - TONGA'; }
        else if(strCountryCode == 'TR') { strReturn = 'TR - TURKEY'; }
        else if(strCountryCode == 'TT') { strReturn = 'TT - TRINIDAD AND TOBAGO'; }
        else if(strCountryCode == 'TV') { strReturn = 'TV - TUVALU'; }
        else if(strCountryCode == 'TW') { strReturn = 'TW - TAIWAN, PROVINCE OF CHINA'; }
        else if(strCountryCode == 'TZ') { strReturn = 'TZ - TANZANIA, UNITED REPUBLIC OF'; }
        else if(strCountryCode == 'UA') { strReturn = 'UA - UKRAINE'; }
        else if(strCountryCode == 'UG') { strReturn = 'UG - UGANDA'; }
        else if(strCountryCode == 'UM') { strReturn = 'UM - UNITED STATES MINOR OUTLYING ISLANDS'; }
        else if(strCountryCode == 'US') { strReturn = 'US - UNITED STATES'; }
        else if(strCountryCode == 'UY') { strReturn = 'UY - URUGUAY'; }
        else if(strCountryCode == 'UZ') { strReturn = 'UZ - UZBEKISTAN'; }
        else if(strCountryCode == 'VA') { strReturn = 'VA - HOLY SEE (VATICAN CITY STATE)'; }
        else if(strCountryCode == 'VC') { strReturn = 'VC - SAINT VINCENT AND THE GRENADINES'; }
        else if(strCountryCode == 'VE') { strReturn = 'VE - VENEZUELA'; }
        else if(strCountryCode == 'VG') { strReturn = 'VG - VIRGIN ISLANDS, BRITISH'; }
        else if(strCountryCode == 'VI') { strReturn = 'VI - VIRGIN ISLANDS, U.S.'; }
        else if(strCountryCode == 'VN') { strReturn = 'VN - VIET NAM'; }
        else if(strCountryCode == 'VU') { strReturn = 'VU - VANUATU'; }
        else if(strCountryCode == 'WF') { strReturn = 'WF - WALLIS AND FUTUNA'; }
        else if(strCountryCode == 'WS') { strReturn = 'WS - SAMOA'; }
        else if(strCountryCode == 'WW') { strReturn = 'WW - WORLDWIDE'; }
        else if(strCountryCode == 'YE') { strReturn = 'YE - YEMEN'; }
        else if(strCountryCode == 'YT') { strReturn = 'YT - MAYOTTE'; }
        else if(strCountryCode == 'ZA') { strReturn = 'ZA - SOUTH AFRICA'; }
        else if(strCountryCode == 'ZM') { strReturn = 'ZM - ZAMBIA'; }
        else if(strCountryCode == 'ZW') { strReturn = 'ZW - ZIMBABWE'; }
        return strReturn;
    }

    //sunji03- FY19 , need to add PS/CAN GEO to this method, but this method is not referenced anywhere, so comment out the method.
    //boolean isBusinessRulesPassed (boolean bIsPartner,string strAccCountry, string strAccGeo, string strAccSegment, string strAccCovModel, string strAccTerritory, string strSalesRegion)
    //{
    //    boolean bReturn = false;
    //    List<Account> lstExistingAccs = new List<Account>();
    //        //string dbQuery = 'select id, name, BillingCountry, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c from account where ';
    //        //string dbQuery = 'select id, name, Country_Picklist__c, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c from account where ';
    //        string dbQuery = 'select id, name from account where '; 
            
    //        if(bIsPartner)    
    //        {
    //            dbQuery += ' Country_Picklist__c = \''+strAccCountry+'\'';
    //            system.debug('------------------'+dbQuery);
    //            lstExistingAccs = Database.query(dbQuery);
    //            if(lstExistingAccs.size() > 0) {
    //                strErrMsg = 'The Account already exist in the same country.';
    //                return bReturn;
    //            }
    //        }
    //        else 
    //        {
    //            if(strAccGeo == 'NA' || strAccGeo == 'LA') {
    //           dbQuery += ' GEO__c = \''+strAccGeo+'\'';
    //            if(strSalesRegion != null)
    //            dbQuery += ' and Sales_Region__c = \''+strSalesRegion+'\'';
    //            if(strAccCovModel != null)
    //            dbQuery += ' and Coverage_Model__c = \''+strAccCovModel+'\'';
    //            if(strAccSegment!= null)
    //            dbQuery += ' and Segment__c = \''+ strAccSegment +'\''; 
    //            system.debug(strAccGeo+'------------------'+dbQuery);
    //                lstExistingAccs = Database.query(dbQuery);
    //                if(lstExistingAccs.size() > 0 && bIsPartner)    {
    //                    strAccApprovalStatus = 'Pending Review';    
    //                }
    //                else if(lstExistingAccs.size() > 0) {
    //                    strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the “'+strAccCovModel+'” Coverage Model and is in the same Sales Region. No new CA Account may be created.';
    //                    return bReturn;
    //                }
    //            }
    //            if((strAccGeo == 'EMEA' || strAccGeo == 'APJ'))
    //            {
    //                dbQuery += ' GEO__c = \''+strAccGeo+'\'';
    //                if(strAccTerritory != null)
    //                dbQuery += ' and Region_Country__c = \''+strAccTerritory+'\'';
    //                if(strAccCovModel != null)
    //                dbQuery += ' and Coverage_Model__c = \''+strAccCovModel+'\'';
    //                if(strAccSegment!= null)
    //                dbQuery += ' and Segment__c = \''+ strAccSegment +'\'';
    //                 system.debug(strAccGeo+'------------------'+dbQuery);

    //                lstExistingAccs = Database.query(dbQuery);
    //                if(lstExistingAccs.size() > 0 && bIsPartner) 
    //                {
    //                    strAccApprovalStatus = 'Pending Review';    
    //                }
    //                else if(lstExistingAccs.size() > 0)
    //                {
    //                    strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the “'+strAccCovModel+'” Coverage Model and is in the same Territory. No new CA Account may be created.';
    //                    return bReturn;    
    //                }
    //            }
    //        }

    //    return true;
    //}

    private Map<String,String> prepareStatesForCanada()
    {
        Map<String,String> mapCAStates = new Map<String, String>();
        mapCAStates.put('Alberta','AB - Alberta');
        mapCAStates.put('British','BC - British ');
        mapCAStates.put('Manitoba','MB - Manitoba');
        mapCAStates.put('New Brunswick','NB - New Brunswick');
        mapCAStates.put('Newfoundland and Labrador','NL - Newfoundland and Labrador');
        mapCAStates.put('Nova Scotia','NS - Nova Scotia');
        mapCAStates.put('Ontario','ON - Ontario');
        mapCAStates.put('Prince Edward Island','PE - Prince Edward Island');
        mapCAStates.put('Quebec','QC - Quebec');
        mapCAStates.put('Saskatchewan','SK - Saskatchewan');
        mapCAStates.put('Northwest Territories','NT - Northwest Territories');
        mapCAStates.put('Nunavut','NU - Nunavut');
        mapCAStates.put('Yukon','YT - Yukon');
        return mapCAStates;
    }
    //samap01 -US465954
    private Map<String,String> prepareStatesForIndia()
    {
        Map<String,String> mapIndiaStates = new Map<String, String>();
        for(India_States__C instates: India_States__C.getAll().values())
            {
                mapIndiaStates.put(instates.name , instates.state_code__C);
            }
       
        return mapIndiaStates;
    }
    //samap01 -US465954
    
    private Map<String,String> prepareStatesForUS()
    {
        Map<String,String> mapUSStates = new Map<String, String>();
        mapUSStates.put('Alabama','AL - Alabama');
        mapUSStates.put('Alaska','AK - Alaska');
        mapUSStates.put('Arkansas','AR - Arkansas');
        mapUSStates.put('Arizona','AZ - Arizona');
        mapUSStates.put('California','CA - California');
        mapUSStates.put('Colorado','CO - Colorado');
        mapUSStates.put('Connecticut','CT - Connecticut');
        mapUSStates.put('Delaware','DE - Delaware');
        mapUSStates.put('District Of Columbia','DC - District Of Columbia');
        mapUSStates.put('Florida','FL - Florida');
        mapUSStates.put('Georgia','GA - Georgia');
        mapUSStates.put('Hawaii','HI - Hawaii');
        mapUSStates.put('Idaho','ID - Idaho');
        mapUSStates.put('Illinois','IL - Illinois');
        mapUSStates.put('Indiana','IN - Indiana');
        mapUSStates.put('Iowa','IA - Iowa');
        mapUSStates.put('Kansas','KS - Kansas');
        mapUSStates.put('Kentucky','KY - Kentucky');
        mapUSStates.put('Louisiana','LA - Louisiana');
        mapUSStates.put('Maine','ME - Maine');
        mapUSStates.put('Maryland','MD - Maryland');
        mapUSStates.put('Massachusetts','MA - Massachusetts');
        mapUSStates.put('Michigan','MI - Michigan');
        mapUSStates.put('Minnesota','MN - Minnesota');
        mapUSStates.put('Mississippi','MS - Mississippi');
        mapUSStates.put('Missouri','MO - Missouri');
        mapUSStates.put('Montana','MT - Montana');
        mapUSStates.put('Nebraska','NE - Nebraska');
        mapUSStates.put('Nevada','NV - Nevada');
        mapUSStates.put('New Hampshire','NH - New Hampshire');
        mapUSStates.put('New Jersey','NJ - New Jersey');
        mapUSStates.put('New Mexico','NM - New Mexico');
        mapUSStates.put('New York','NY - New York');
        mapUSStates.put('North Carolina','NC - North Carolina');
        mapUSStates.put('North Dakota','ND - North Dakota');
        mapUSStates.put('Ohio','OH - Ohio');
        mapUSStates.put('Oklahoma','OK - Oklahoma');
        mapUSStates.put('Oregon','OR - Oregon');
        mapUSStates.put('Pennsylvania','PA - Pennsylvania');
        mapUSStates.put('Rhode Island','RI - Rhode Island');
        mapUSStates.put('South Carolina','SC - South Carolina');
        mapUSStates.put('South Dakota','SD - South Dakota');
        mapUSStates.put('Tennessee','TN - Tennessee');
        mapUSStates.put('Texas','TX - Texas');
        mapUSStates.put('Utah','UT - Utah');
        mapUSStates.put('Vermont','VT - Vermont');
        mapUSStates.put('Virginia','VA - Virginia');
        mapUSStates.put('Washington','WA - Washington');
        mapUSStates.put('West Virginia','WV - West Virginia');
        mapUSStates.put('Wisconsin','WI - Wisconsin');
        mapUSStates.put('Wyoming','WY - Wyoming');
        return mapUSStates;
    }
    
    private Map<String,String> prepareStatesForAustralia(){
        Map<String,String> australiaTerritoriesMap = new Map<String, String>();
        australiaTerritoriesMap.put('ACT','ACT - Australian Capital Territory');
        australiaTerritoriesMap.put('NSW','NSW - New South Wales');
        australiaTerritoriesMap.put('NT','NT - Northern Territory');
        australiaTerritoriesMap.put('QLD','QLD - Queensland');
        australiaTerritoriesMap.put('SA','SA - South Australia');
        australiaTerritoriesMap.put('TAS','TAS - Tasmania');
        australiaTerritoriesMap.put('VIC','VIC - Victoria');
        australiaTerritoriesMap.put('WA','WA - Western Australia');
        return australiaTerritoriesMap;
    }
    
    
    public PageReference gotoPrevRes2() {
        PageReference srchPrevPage;
        if(resultSet2.size()>0){
            selectedSize = Label.DE_PaginationSize;
            displayresults2();   
            srchPrevPage = Page.DE_AccSrchRes2_VFP;
        }
        else
        {
            if(resultSet1!=null){ 
                srchPrevPage = Page.DE_AccSrchResDuns_VFP;
            }
            else{
                srchPrevPage = Page.DE_Accsearch_VFP;
            }
        }
        srchPrevPage.setRedirect(false);
        return srchPrevPage;
    }
    
    DE_AccResWithDuns_CLS createNoMatchRec(DE_AccResWithDuns_CLS bestmatchrec) {//DE_AccResWithDuns_CLS bestmatchrec TBD
        DE_AccResWithDuns_CLS objNoMatch = new DE_AccResWithDuns_CLS();
        if(bestmatchrec <> null) {
            objNoMatch.accDunsNo = bestmatchrec.accDunsNo;
            objNoMatch.accId = bestmatchrec.accId;
            objNoMatch.accName = 'No Match'; 
        }
        else {    
            objNoMatch.accDunsNo = '';//bestmatchrec.accDunsNo;
            objNoMatch.accId = '';//bestmatchrec.accId;
            objNoMatch.accName = 'No Match';
        }    
        return  objNoMatch;
    }
    
    boolean isBRMatchRecFound (boolean bIsPartner, List<DE_AccResWithDuns_CLS> lstSecondRS, DE_AccResWithDuns_CLS objOrgMatch)
    {
        boolean recordFoundinSet = false;
        system.debug('bIsPartner-------'+bIsPartner);
        for(DE_AccResWithDuns_CLS secResult: lstSecondRS)
        {
            if(secResult <> null) {
                /*if(secResult.country == objOrgMatch.country && bIsPartner) 
{
recordFoundinSet = true;
strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The CA Account is covered in the same Country. No new CA Account may be created.';
break;
}
//else if(secResult.country == objOrgMatch.country && secResult.coverMod == 'Partner')
else if(secResult.country == objOrgMatch.country && secResult.coverMod == 'Partner' && objOrgMatch.geo != 'NA')
{
if(bIsPartner)          
strAccApprovalStatus = 'Pending Review';
else{                                       
recordFoundinSet = true;
strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The CA Account is covered in the same Country. No new CA Account may be created.';
break;
}
}
//break;
else */if(secResult.geo == 'NA' && objOrgMatch.geo == 'NA' && (secResult.coverMod == 'Named' || (secResult.coverMod == 'Territory' && secResult.salReg == objOrgMatch.salReg)))
{
    if(bIsPartner && secResult.country <> objOrgMatch.country)
        strAccApprovalStatus = 'Pending Review';
    else{
        recordFoundinSet = true;
        if(secResult.coverMod == 'Territory')
            strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the "'+secResult.coverMod+'" Account and in the same Sales Region. No new CA Account may be created.';                              
        else
            strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the "'+secResult.coverMod+'" Account and in the same Geo. No new CA Account may be created.';
    }
    break;
                       }
                       //sunji03 - FY19, PS/CAN GEO is added.
                       if(secResult.geo == 'PS/CAN' && objOrgMatch.geo == 'PS/CAN' && (secResult.coverMod == 'Named' || (secResult.coverMod == 'Territory' && secResult.salReg == objOrgMatch.salReg)))
                      {
                            if(bIsPartner && secResult.country <> objOrgMatch.country)
                                strAccApprovalStatus = 'Pending Review';
                            else{
                              recordFoundinSet = true;
                              if(secResult.coverMod == 'Territory')
                                  strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the "'+secResult.coverMod+'" Account and in the same Sales Region. No new CA Account may be created.';                              
                              else
                                  strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the "'+secResult.coverMod+'" Account and in the same Geo. No new CA Account may be created.';
                             }
                            break;
}
                else if(((secResult.geo == 'EMEA' && objOrgMatch.geo == 'EMEA') || (secResult.geo == 'APJ' && objOrgMatch.geo == 'APJ')) && (secResult.coverMod == 'Named' || secResult.coverMod == 'Territory') && secResult.territory == objOrgMatch.territory){
                    if(bIsPartner && secResult.country <> objOrgMatch.country)
                        strAccApprovalStatus = 'Pending Review';
                    else{
                        recordFoundinSet = true;
                        strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the "'+secResult.coverMod+'" Account and is in the same Territory. No new CA Account may be created.';
                    }
                    break;
                }
                else if((secResult.geo == 'LA' && objOrgMatch.geo == 'LA') && (secResult.coverMod == 'Named' || secResult.coverMod == 'Territory') && objOrgMatch.salReg == secResult.salReg)
                {
                    if(bIsPartner && secResult.country <> objOrgMatch.country)
                        strAccApprovalStatus = 'Pending Review';
                    else{
                        recordFoundinSet = true;
                        strErrMsg = 'These search results are based upon your selection and/or CA Account hierarchy. The best matched CA Account is covered by the "'+secResult.coverMod+'" Account and in the same Sales Region. No new CA Account may be created.';
                    }
                    break;
                }
            }      
            
        }
        return recordFoundinSet;
    }
    
    String getSampleTestXML(boolean bIsFirstSearch)                
    {
        
        String strReturn = '';
        strReturn += '<?xml version="1.0" encoding="utf-8"?>';
        if(bIsFirstSearch)
        {
            strReturn += '<GetCleanseMatchResponseDetail><MatchResponseDetail><MatchDataCriteriaText>Name and Address Lookup</MatchDataCriteriaText><CandidateMatchedQuantity>6</CandidateMatchedQuantity>';
            strReturn += '<MatchCandidate><DUNSNumber>808998355</DUNSNumber><OrganizationPrimaryName><OrganizationName>1-800-FLOWERS.COM, INC.</OrganizationName></OrganizationPrimaryName>';
            strReturn += '<PrimaryAddress><StreetAddressLine><LineText>1 OLD COUNTRY RD STE 500</LineText></StreetAddressLine><PrimaryTownName>CARLE PLACE</PrimaryTownName><CountryISOAlpha2Code>US</CountryISOAlpha2Code><PostalCode>11514</PostalCode><PostalCodeExtensionCode>1847</PostalCodeExtensionCode><TerritoryAbbreviatedName>NY</TerritoryAbbreviatedName><UndeliverableIndicator>false</UndeliverableIndicator></PrimaryAddress>';
            strReturn += '<MatchQualityInformation><ConfidenceCodeValue>10</ConfidenceCodeValue></MatchQualityInformation><DisplaySequence>1</DisplaySequence></MatchCandidate></MatchResponseDetail></GetCleanseMatchResponseDetail>';
        }
        else
        {
            strReturn += '<accountResponse><subsidiaryResponses><status>OK</status><errordetail/></subsidiaryResponses><matches><match><matchType>NAME_GEO</matchType><caAccountId>N097648</caAccountId><segment>Growth</segment><geo>NA</geo><operatingArea>Named/Growth</operatingArea><salesRegion>NG_NE</salesRegion><territory>NG_NE_GROWTH</territory>';
            strReturn += '<accountStatus>Approved</accountStatus><coverageModel>Territory</coverageModel><sfdcAccountId>0013000000HQXcHAAX</sfdcAccountId><globalParentSegment>Growth</globalParentSegment><physicalState>NY</physicalState><physicalStreet>1 Old Country Rd., Ste. 500</physicalStreet><physicalZip>11514</physicalZip><accountName>1-800-Flowers.com, Inc.</accountName><countryPickList>US - UNITED STATES</countryPickList><physicalCity>Carle Place</physicalCity></match>';
            strReturn += '<match><matchType>ORIGINAL</matchType><caAccountName>1-800-Flowers.com, Inc.</caAccountName><globalParentNumber>808998355</globalParentNumber><globalParentName>1-800-FLOWERS.COM, Inc.</globalParentName><geo>NA</geo><operatingArea>Named/Growth</operatingArea><salesRegion>NG_NE</salesRegion><territory>NG_NE_GROWTH</territory><physicalState>NY</physicalState><physicalStreet>1 Old Country Rd.</physicalStreet><physicalCountry>US - UNITED STATES</physicalCountry><physicalCity>Carle Place</physicalCity><globalParentSIC2Digit>59</globalParentSIC2Digit><globalParentSIC4Digit>5992</globalParentSIC4Digit><globalParentIndustry>RETAIL TRADE</globalParentIndustry></match></matches></accountResponse>';
        }
        return strReturn;
    }
    
}