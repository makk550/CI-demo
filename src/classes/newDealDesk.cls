public class newDealDesk {
    public List<scpq__SciQuote__c> QuoteIds;
    public scpq__SciQuote__c QuoteId;
    public SBQQ__Quote__c SFQuoteId;

   //  public string NDATypeselected { get;set; }
    public string NDATypeselected
    {
        get
        {
            if(NDATypeselected==null)
                NDATypeselected='';
            return NDATypeselected;
        }
        set;
    }
    //chajo30 changes
    public string Quoteselected{ 
        get
        {
            if(Quoteselected==null)
                Quoteselected='';
            return Quoteselected;
        }
        set; 
    }       
    public string SFQuoteselected{ 
       get
        {
            if(SFQuoteselected==null)
                SFQuoteselected='';
            return SFQuoteselected;
        }
        set;
    }    
    public string SalesComment { get;set; }
    public List<SelectOption> QouteOptions { get;set; }//sterling quote options 
    public List<SelectOption> SFQouteOptions { get;set; }
    //end chajo30
    
    String IND_VALUE_OPPORUNITY_RecordTYPEID='01230000000GfiB';
    public List<SelectOption> NDAType { get;set; }
     public String TransactionType {get;set;}
    public boolean renderNDAtype{ get;set; }
    private ApexPages.StandardController controller {get; set;}
    public Opportunity opp;
   // public scpq__SciQuote__c quote;
    public integer count;
  
    public void testOutside(){
        System.debug('IN testOutside()');
        System.debug('NDATypeselected:'+NDATypeselected);
        System.debug('TransactionType:'+TransactionType);
        
    }
    
    
    public newDealDesk(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        renderNDAtype = false;
        Schema.DescribeFieldResult statusFieldDescription = Deal_Desk_Review__c.NDA_Type__c.getDescribe();
        NDAType = new list<SelectOption>();
        QouteOptions= new list<SelectOption>();
        SFQouteOptions = new list<SelectOption>();
        //change
        NDAType.add(new SelectOption('','',true));
        QouteOptions.add(new SelectOption('',''));
        SFQouteOptions.add(new SelectOption('',''));
        //end
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            system.debug('inside for'+picklistEntry.getValue());
            NDAType.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        system.debug('In constructor - NDATypeselected:'+NDATypeselected);
        
        opp = [Select Id,Amount,RecordTypeId,CurrencyIsoCode,CloseDate,StageName,OwnerId,Ent_Comm_Account__c,AccountId,Opportunity_Number__c,Type,Rpt_Area__c,Rpt_Territory_Country__c,Rpt_Country__c,Rpt_Region__c from Opportunity where Id = :ApexPages.currentPage().getParameters().get('id')];
      
       
        for( scpq__SciQuote__c quote: [SELECT Id, CA_CPQ_Quote_Number__c, Name FROM scpq__SciQuote__c WHERE scpq__OpportunityId__c = :ApexPages.currentPage().getParameters().get('id')])
        {
            if(quote.CA_CPQ_Quote_Number__c != null){
               QouteOptions.add(new SelectOption(quote.CA_CPQ_Quote_Number__c,quote.CA_CPQ_Quote_Number__c)); 
            }
        }  

        //chajo30
        for(SBQQ__Quote__c sfQuote: [SELECT Id, Name FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :ApexPages.currentPage().getParameters().get('id')]) {
            if(sfQuote.Name != null){
                SFQouteOptions.add(new SelectOption(sfQuote.Name, sfQuote.Name));
            }
        }
        //end chajo30

        
    }
    public void enableNDAtypefun(){
        System.debug('calling enableNDAtypefun' + TransactionType + 'bool' + renderNDAtype);
        if(TransactionType == 'NDA'){
            renderNDAtype = true;
        }
        else{
            renderNDAtype = false;
        }
        }
    public PageReference ApplySelectionfunction(){
        //chajo30
            String dmUserIds = System.Label.DataMigration_Users;
            String[] users = dmUserIds.split(';');
            Set<String> dmUsersSet = new Set<String>();
            for(String userId : users) {
                dmUsersSet.add(userId);
            }

            if(Quoteselected=='' && SFQuoteselected=='' && (TransactionType != 'Master - Standalone' && TransactionType != 'Master - with Transaction' && TransactionType != 'NDA' && 
                                                            TransactionType != 'Product-0 Dollar ' && TransactionType != 'Product-Other' && TransactionType != 'Product-Non-Std Trial' &&!dmUsersSet.contains(UserInfo.getUserId()))){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select a Sterling Quote or Salesforce Quote');
                ApexPages.addMessage(myMsg);
                System.debug('myMsg is'+ myMsg);
                return null;
            }
            if(Quoteselected!='' && SFQuoteselected!='' ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You may only select either a Sterling Quote or a Salesforce Quote ');
                ApexPages.addMessage(myMsg);
                System.debug('myMsg is'+ myMsg);
                return null;
            }
        //End chajo30    


        if(TransactionType=='NDA' && NDATypeselected=='')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'NDA Type field is required');
            ApexPages.addMessage(myMsg);
            System.debug('myMsg is'+ myMsg);
                return null;
        }   
        Deal_Desk_Review__c dobj = new Deal_Desk_Review__c();
         if(TransactionType=='NDA')
        {
            dobj.NDA_Type__c=NDATypeselected;
        }
        System.debug('NDATypeselected:'+NDATypeselected);
        dobj.Opportunity_Name__c=opp.Id;
        dobj.Area__c=opp.Rpt_Area__c;
        dobj.Oppty_Close_Date__c=opp.CloseDate;
        dobj.Sales_Milestone__c=opp.StageName;
        dobj.Opportunity_Owner__c=opp.OwnerId;
        if(opp.RecordTypeId == IND_VALUE_OPPORUNITY_RecordTYPEID) 
            dobj.Account_Name__c = Opp.Ent_Comm_Account__c; 
        else
        dobj.Account_Name__c = Opp.AccountId; 
        dobj.Oppty_Number__c =Opp.Opportunity_Number__c; 
       // dobj.Sterling_Quote__c = Quoteselected;
        
        //chajo30 changes
        if(Quoteselected!=null && Quoteselected != '')
        {
            QuoteId=[Select Id from scpq__SciQuote__c where CA_CPQ_Quote_Number__c= :Quoteselected];
            if(QuoteId!=null)
            {
                dobj.Sterling_Quote__c= QuoteId.Id;
            }
        }
    
        if(SFQuoteselected!=null && SFQuoteselected != '')
        {
            SFQuoteId=[Select Id from SBQQ__Quote__c where Name= :SFQuoteselected];
            if(SFQuoteId!=null)
            {
                dobj.Salesforce_Quote__c= SFQuoteId.Id;
            }
        }
        //end chajo30
        dobj.Oppty_Amount__c = opp.Amount; 
        
        
        dobj.Deal_Desk_Request_Type__c = TransactionType;
        
        dobj.CurrencyIsoCode = opp.CurrencyIsoCode; //Srini CURRENCY TEST 

        dobj.Territory__c = opp.Rpt_Territory_Country__c;
        dobj.Type__c = Opp.Type; 

        dobj.Area02__c = opp.Rpt_Country__c; //Srini 

        dobj.Region__c = opp.Rpt_Region__c; 
        dobj.Sales_Comments__c=SalesComment;
        try{
            insert dobj;
        }
        catch(Exception e){
            System.debug('exception '+e);
            System.debug('object '+dobj);
        }
        
        PageReference pageRef = new PageReference('/p/attach/NoteAttach?pid='+dobj.Id+'&retURL=%2F'+dobj.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
     
    public PageReference Cancelfunction()
        {
            PageReference pageRefer = new PageReference('/apex/OpportunityViewOverride?id='+opp.id+'&sfdc.override=1');
            pageRefer.setRedirect(true);
            return pageRefer;
        }
        
    
    
    public void testfun(){
        system.debug('In testfun testfun:'+ NDATypeselected);
        
        
    }

}