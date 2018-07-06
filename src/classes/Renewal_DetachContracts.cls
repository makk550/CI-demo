/***************************************************************************************************
* This was created to allow the users to detach contracts for a given opportunity. This is created
* as part of the user story : US370555 : RevRec: SFDC License Classification generate Opportunity from Renewal
* Apex class -Renewal_DetachContracts
* Created by SAMAP01
* Test Class : Renewal_DetachContracts_Test
* Coverage - 80%
* ********************************************************************************************/
public class Renewal_DetachContracts {
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    private String sortDirection = 'ASC'; 
    private String sortExp = 'name';  
    public String SortFieldSave;
    public string Contract_No_Filter{get;set;}
    public string Contract_Name_Filter{get;set;}
    public  string  Dismantle_Date_Filter{get;set;}
    public string MainQuery;
    public boolean allchecked{get;set;}
    public Id oppid{get ;set;}
    Opportunity opp;
    public String strOppId;   
    public String strAccountId;
    public  String WhereCond;
    public String strAccName;
    public string strpricebookid;
    private String returnurl;
    private boolean pricebkmsg {get;set;}
    public List<RenewalProductDetails> RenewalProductList = new List<RenewalProductDetails>();
    public List<RenewalProductDetails> ACPList = new List<RenewalProductDetails>();
    public List<Active_Contract_Product__c>  ActProduct = new List<Active_Contract_Product__c>();
    public List<Active_Contract_Product__c>  ActPdtlst = new List<Active_Contract_Product__c>();
    public List<Active_Contract_Product__c>  SelectedACPlst = new List<Active_Contract_Product__c>();
    public Map <Id,Active_Contract_Product__c> ActProductMap =   new Map<Id,Active_Contract_Product__c>();
    public boolean hasprimarycontact ; //samap01
    public Renewal_DetachContracts(){
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
        //Instance_Id__c,a.Product__r.CSU2__c,
        Pricebook2 pbe = new Pricebook2();
        pbe = [select Id from Pricebook2 where Name='CA Product List' and IsActive=true];
        if(pbe!=null)
            strpricebookid = pbe.Id;        
        pricebkmsg = false;
        
        strOppId=System.currentPageReference().getParameters().get('Id'); 
        
        //if there is no product, there will be no opp id, and user will be asked to enter a product first to use the 
        //mass update feature.
        if(ApexPages.currentPage().getParameters().get('id')!=null)
            oppId=ApexPages.currentPage().getParameters().get('id');
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Attach a Contract first to the opportunity.'));
        
        if(ApexPages.currentPage().getParameters().get('retURL')!=null)
            returnurl = ApexPages.currentPage().getParameters().get('retURL');
        /*
        opp = [Select o.Name,o.Id,o.Account.Name,o.CurrencyIsoCode, o.AccountId,CloseDate,StageName,o.Start_Date__c,o.End_Date__c,o.Attach_Contracts_Batch_Id__c,
               o.Probability,Reason_duration_is_1_year__c,Status_at_end_of_term__c    //samap01 -11/20 
               From Opportunity o where o.Id =: strOppId];
        */
        opp = Renewal_OpportunityUtilityClass.getOpportunitydetails(strOppId);
        strAccountId = opp.AccountId ;   
        BuildQuery();
        ActPdtlst = Database.query(MainQuery); //get full list
        for(Active_Contract_Product__c ac : ActPdtlst )
            ACPList.add(new RenewalProductDetails(ac,false)); 
        System.debug('samap01 MainQuery'+MainQuery);
        hasprimarycontact = Renewal_OpportunityUtilityClass.Primarycontactexists(opp);
        if( !hasprimarycontact)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
            ApexPages.addMessage(myMsg);   
            System.debug('samap01 myMsg'+myMsg);            
        }
         
     
    }
    
    
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {   
                BuildQuery();
                System.debug('samap01 MainQuery in setcon'+MainQuery);
                // setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                //    [select id,Name,AccountId,Account.name,Amount,StageName,CloseDate,LastModifiedDate from Opportunity limit 500]));
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(MainQuery));
                
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
    
    //Changes the size of pagination
    public PageReference refreshPageSize() {
        setCon.setPageSize(size);
        return null;
    }
    
    // Initialize setCon and return a list of record    
    
    public list<RenewalProductDetails> getRenewalProductList() {
        
        getSelectedRenewalProductList();
        RenewalProductList = new List <RenewalProductDetails>();
        for (Active_Contract_Product__c ac : (list<Active_Contract_Product__c>)Setcon.getRecords()) {
            //if(opp.CurrencyIsoCode == ac.Renewal_Currency_Name__c)
            {
                if(allchecked==true)
                {
                    if( !ActProductMap.containsKey(ac.id))
                        ActProductMap.put(ac.id,ac);  
                    RenewalProductList.add (new RenewalProductDetails(ac,true));  
                }
                else
                {
                    if(ActProductMap.ContainsKey(ac.id))
                    {                    
                        RenewalProductList.add (new RenewalProductDetails(ac,true));                    
                    }                    
                    else
                    {                    
                        RenewalProductList.add(new RenewalProductDetails(ac,false));
                        
                    }
                }
                // RenewalProductList.add(new RenewalProductDetails(ac)); 
                // ActProductMap.put(String.ValueOf(ac.id),ac);
            }
        }
        System.debug('samap01 -getrenewalllist' +RenewalProductList.size());
        return RenewalProductList;
    }
    
    
    public void getSelectedRenewalProductList(){      
        if(RenewalProductList!=null)           
        {            
            for(RenewalProductDetails rpd:RenewalProductList)               
            {  
                if(allchecked==true)
                {
                    if( !ActProductMap.containsKey(rpd.activeContractProd.id))
                        ActProductMap.put(rpd.activeContractProd.id,rpd.activeContractProd); // Add the selected contact id in to the ActProductMap.
                    
                    rpd.selected =true;
                    
                }
                else
                {
                    if(rpd.selected == true)                    
                    {  
                        if( !ActProductMap.containsKey(rpd.activeContractProd.id))
                            ActProductMap.put(rpd.activeContractProd.id,rpd.activeContractProd); // Add the selected contact id in to the ActProductMap.                    
                    }                
                    else                    
                    {                    
                        ActProductMap.remove(rpd.activeContractProd.id); // If you uncheck the contact, remove it from the ActProductMap                    
                    } 
                }
            }            
        }        
    }
    
    public pagereference detachProduct()
    {
        string returnurl = '/'+opp.Id;
        if( !hasprimarycontact)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot proceed as no Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
            ApexPages.addMessage(myMsg);   
            System.debug('samap01 myMsg'+myMsg);
            return null;
        }

        Map<id, PricebookEntry> mapPE = new Map<id,PricebookEntry>();
        Set<id> prodIds = new Set<id>();
        getSelectedRenewalProductList();
        if (ActProductMap.size() == 0) 
        { 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select atleast one contract to delete.'));
            return null;                
        }
        else
        {
            //get the selected list of active contract ids
           /* for(RenewalProductDetails lstVal:RenewalProductList)
            {                   
                if(lstVal.selected)
                {   
                    prodIds.add(lstVal.activeContractProd.Id);
                }
            }*/              
            //get all the opp line items with the Active contract ids
        
            System.debug('samap01 prodIds'+ ActProductMap.size());
            prodIds = new Set<Id>(ActProductMap.keySet());
                System.debug('samap01 prodids' +prodIds.size());
            if(prodIds.size() >0)
            {
                System.debug('samap01 prodIds'+prodIds);
                Set<id> aclids = new Set<id>();
                List<OpportunityLineItem> opplist  = NEW  List<OpportunityLineItem>();
                opplist = [Select Id,Active_Contract_Line_Item__c,Active_Contract_Product__c from OpportunityLineItem where 
                           Active_Contract_Product__c IN :prodIds ]; 
                System.debug('samap01 opplist'+opplist);
                if(opplist.size() > Integer.Valueof(System.Label.Opportunity_BatchSize))
                {
                    
                    returnurl = '/apex/showACLIbatchProgress?rtype=Detach&id='+opp.Id;                     
                    System.debug('samap01- calling batch job prodIds'+ prodIds);
                    Batch_RenewalDetachContracts bcn = new Batch_RenewalDetachContracts(prodIds,opp.Id) ;
                    ID batchprocessid = Database.executeBatch(bcn,Integer.Valueof(System.Label.Opportunity_BatchSize));
                    opp.Detach_Contracts_Batch_Id__c = batchprocessid;                        
                    update opp;
                    
                    System.debug('samap01- end batch job');
                }
                else
                {
                    try
                    {
                        delete opplist;
                        System.debug('samap01 -detach oli'+opplist );
                        List<Active_Contract_Line_Item__c> acllist = [Select Id,Opportunity_Product__c from Active_Contract_Line_Item__c
                                                                      where  Contract_Product__c in : prodIds ] ;
                        if(acllist.size()>0)
                        {
                            for( Active_Contract_Line_Item__c  acli : acllist)
                            {
                                acli.Opportunity_Product__c='';                                    
                            }                                
                            update acllist;
                            System.debug('samap01 -acllist updated '+acllist);
                        }
                        
                        if(opplist.size()>0 && prodIds.size()>0)
                        {
                            List<CA_Product_Renewal__c> prodRenewalList = [Select id,name from CA_Product_Renewal__c where Active_Contract_Product__c
                                                                           IN :prodIds and Renewal_Opportunity__c =:opp.Id];
                            if(prodRenewalList.size()>0) 
                                delete prodRenewalList;
                            System.debug('samap01 -prodRenewalList delete '+prodRenewalList);
                        }
                        List<Active_Contract_Product__c> acpList = new List<Active_Contract_Product__c>();
                        for(Id acpId : prodIds){                       
                            acpList.add(new Active_Contract_Product__c(id=acpId,Opportunity_Product__c = null,Opportunity__c = null,Renewal_Contract_Product__c = null,Converted_to_Opportunity__c = false));
                            //   acpIds.add(acpId);                      
                        }
                        
                        System.debug('samap01 the acp is updated: ' + acpList);      
                        update acpList;     
                    }
                    Catch(exception e)
                    {
                        if(e.getDmlType(0)==StatusCode.REQUIRED_FIELD_MISSING)
                        {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Pricebook is not active for selected product(s)!');    
                            ApexPages.addMessage(myMsg);
                            return null;
                        } 
                        else
                        { 
                            system.assert(false,e.GetMessage()+'---->'+e.getCause()+'---->'+e.getLineNumber()+'---->'+e.getStackTraceString());
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.GetMessage()+'---->'+e.getCause()+'---->'+e.getLineNumber()+'---->'+e.getStackTraceString());
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                        
                    }
                }
            }
            else
            {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select atleast one contract to delete.'));
            return null; 
                
            }
            
        }
        PageReference pageRef = new PageReference(returnurl);
        pageRef.setRedirect(true);
        return pageRef;
    }
    //this method checks all the line items.
    public void checkalllineitems(){
        if(ACPList.size() >0)
            RenewalProductList = ACPList ;  //setting the complete list so that the select all can function
        if(allchecked==true){
            System.debug('samap01 RenewalProductList '+RenewalProductList.size());
            for(RenewalProductDetails oliwrap:RenewalProductList){
                 if(ActProductMap.get(oliwrap.activeContractProd.id) == null)
                 {
                      ActProductMap.put(oliwrap.activeContractProd.id,oliwrap.activeContractProd);
                 }
                
                oliwrap.selected = true;
                System.debug('samap01 true'+ oliwrap );
            }
        }
        else
        {
            for(RenewalProductDetails oliwrap:RenewalProductList){
                oliwrap.selected = false;
                ActProductMap.remove(oliwrap.activeContractProd.id);
                System.debug('samap01 false'+ oliwrap );
            }  
        }
    }
    public String sortExpression  
    {     get 
    { 
        return sortExp;    
    }  
     set   
     {
         if (value == sortExp)   
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
         else         sortDirection = 'ASC';       sortExp = value;     
     }
    }
    public String SortField {
        get { if (SortField == null) {SortField = 'a.Active_Contract__r.name'; } return SortField;  }
        set; 
    }
    
    public String getSortDirection() 
    {  
        if (sortExpression == null || sortExpression == '')      
            return 'ASC';  
        else   
            return sortDirection; 
    } 
    
    public void setSortDirection(String value) 
    {  
        sortDirection = value;
    }
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
        }
        // run the query again
        BuildQuery();
    }
    public pagereference applyFilter()
    {                     
        BuildQuery();
        return null;            
    }
    public pagereference clearFilter()
    {
        
        Contract_No_Filter = '';
        Contract_Name_Filter='';
        Dismantle_Date_Filter='';       
        
        RenewalProductList.clear();
        ActProductMap.clear();
        BuildQuery();     
        
        return null;
    }
    public string  BuildQuery() {
        try
        {
            Setcon= null;
            System.debug('samap01 buildquery called');
            String QueryWhere='';
            String WhereDatefilter = '';
            oppId= opp.Id;
            if(Contract_No_Filter != null)
            {
                Contract_No_Filter = Contract_No_Filter.replaceAll(',','');
            }
            if(Contract_Name_Filter != null)
            {
                Contract_Name_Filter = Contract_Name_Filter.replaceAll(',','');
            }
            
            MainQuery = 'Select Instance_Id__c,a.Product__r.CSU2__c,Projected_Renewal_Calc__c, ATTRF_CRV__c,dismantle_date__c,'+
                'Opportunity__r.Opportunity_Number__c,Opportunity__r.Name,a.Renewal_Currency_Name__c,a.Renewal_Product__r.Renewal__r.name,'+
                ' a.Product_Baseline_ATTRF_LC__c,a.Renewal_Product__c,a.Active_Contract__r.name,a.Name,a.Product__r.Name, a.Id,'+
                ' a.Converted_To_Opportunity__c, a.Active_Contract__r.Renewal_Currency__c,a.Active_Contract__c,a.AOCV__c,a.OCV__c,'+
                'a.Active_Contract_Number__c,a.Sales_Price__c,a.Segmentation__c,a.Pre_Segmentation__c, '+
                'a.Active_Contract__r.Account__r.name,a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,'+
                'a.Renewal_Product__r.Projected_Renewal_LC__c,a.Renewal_Product__r.Projected_Time_Duration_Months__c,'+
                'a.Active_Contract__r.Contract_Term_Months__c,a.Raw_Maint_Calc_LC__c,a.Product__r.Family '+
                ' From Active_Contract_Product__c a ';
            System.debug('samap01 -MainQuery'+MainQuery);
            System.debug('samap01 -strAccountId'+strAccountId);
            System.debug('samap01 -oppId'+oppId);
            QueryWhere = ' Where a.Active_Contract__r.Account__c  = \''+ strAccountId +'\' and a.Opportunity__c =\''+ opp.Id +'\' and (a.Converted_To_Opportunity__c = true )';
            System.debug('samap01 -MainQuery'+MainQuery);
            System.debug('samap01 QueryWhere'+QueryWhere);
            WhereCond = '';  
            if(Contract_No_Filter!='' &&  Contract_No_Filter != null){
                if(WhereCond==''){
                    WhereCond = 'and a.Active_Contract__r.name = \'' + Contract_No_Filter  + '\''; 
                }else{
                    WhereCond = WhereCond+'and a.Active_Contract__r.name = \'' + Contract_No_Filter  + '\'';  
                }
            }
            if(Contract_Name_Filter != '' && Contract_No_Filter!= null){
                if(WhereCond!=''){
                    WhereCond = WhereCond +'and a.Name = \'' + Contract_Name_Filter + '\''; 
                }else{
                    WhereCond = 'and a.Name = \'' + Contract_Name_Filter + '\'';   
                    
                }
            }
            
            if(Dismantle_Date_Filter != '' &&  Dismantle_Date_Filter !=null){
                Dismantle_Date_Filter += ' 01:00 AM';
                if(WhereCond!=''){
                    WhereCond = WhereCond + 'and dismantle_date__c = '+ dateTime.parse(Dismantle_Date_Filter).format('YYYY-MM-dd');
                }else{
                    WhereCond = 'and dismantle_date__c = ' +dateTime.parse(Dismantle_Date_Filter).format('YYYY-MM-dd');
                    
                }
                Dismantle_Date_Filter=Dismantle_Date_Filter.remove(' 01:00 AM');
            }
            
            // WhereCond = '\'' + strAccountId + '\'' + WhereCond ;
            //whereCond='\'' + strAccountId + '\''+ WhereCond;
            
            
            string sortFullExp = sortExpression  + ' ' + sortDirection;        
            
            MainQuery += QueryWhere + WhereCond;
            MainQuery += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';
            system.debug('samap01  final MainQuery:' + MainQuery);
            return MainQuery;
            
        }
        catch(exception e)
        {
            System.debug('samap01 error framing query'+e.getMessage()          );
            return MainQuery;
        }
    }
    
   
    
    public class RenewalProductDetails{
        public Active_Contract_Product__c activeContractProd{get; set;}
        public Boolean selected {get; set;}
        
        public RenewalProductDetails(Active_Contract_Product__c a ,boolean boolVal){
            activeContractProd= a;
            selected = boolVal;
        }
    }
}