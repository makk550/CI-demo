public class newDealDeskAccount {
    public string NDATypeselected
    {
        get
        {
            if(NDATypeselected==null)
                NDATypeselected='';//setting the initial value as null
            return NDATypeselected;
        }
        set;
    }
    public string SalesComment { get;set; }
    String IND_VALUE_OPPORUNITY_RecordTYPEID='01230000000GfiB';
    public List<SelectOption> NDAType { get;set; }
    public String TransactionType {get;set;}
    public boolean renderNDAtype{ get;set; }
    private ApexPages.StandardController controller {get; set;}
    
    public Account Acc;
    
    public integer count;
    
    public void testOutside(){
        System.debug('IN testOutside()');
        System.debug('NDATypeselected:'+NDATypeselected);
        System.debug('TransactionType:'+TransactionType);
        
    }
    
    
    public newDealDeskAccount(ApexPages.StandardController controller) {
        
        //initialize the stanrdard controller
        this.controller = controller;
        renderNDAtype = false;
        Schema.DescribeFieldResult statusFieldDescription = Deal_Desk_Review__c.NDA_Type__c.getDescribe();
        NDAType = new list<SelectOption>();
       
          NDAType.add(new SelectOption('','',true));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            system.debug('inside for'+picklistEntry.getValue());
            NDAType.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        system.debug('In constructor - NDATypeselected:'+NDATypeselected);
        Acc=[Select Id,Name,Type from Account where Id = :ApexPages.currentPage().getParameters().get('id')];
        
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
        if(TransactionType=='NDA' && NDATypeselected=='')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'NDA Type field is required');
            ApexPages.addMessage(myMsg);
            System.debug('myMsg is'+ myMsg);
            return null;
        }   
        Deal_Desk_Review__c dobj = new Deal_Desk_Review__c();
        dobj.Deal_Desk_Request_Type__c = TransactionType;
        if(TransactionType=='NDA')
        {
            dobj.NDA_Type__c=NDATypeselected;
        }
        dobj.Account__c = Acc.Id;
        //dobj.Account_Type__c=Acc.Type;
        dobj.Account_Name3__c=Acc.Name;
        //dobj.Account_Name3__c=Acc.Name;
        
        dobj.Sales_Comments__c=SalesComment;
        try{
            insert dobj;
        }
        catch(Exception e){
            System.debug('exception '+e);
            System.debug('object '+dobj);
        }
        
        PageReference pageRef = new PageReference('/p/attach/NoteAttach?pid='+dobj.id+'&retURL=%2F'+dobj.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference Cancelfunction()
        {
            PageReference pageRefer = new PageReference('/apex/AccountViewOverride?id='+Acc.Id+'&sfdc.override=1');
            pageRefer.setRedirect(true);
            return pageRefer;
        }
    public void testfun(){
        system.debug('In testfun testfun:'+ NDATypeselected);
        
        
    }
    
    
}