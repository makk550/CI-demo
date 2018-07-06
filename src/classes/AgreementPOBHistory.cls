public class AgreementPOBHistory {
    public string PobName{get;set;}
    public boolean display{get;set;}
    public List<Agreement_POB__c> PobList=new List<Agreement_POB__c>();
    public List<Exercised_POB__c> exPobList=new List<Exercised_POB__c>();
    public SET<ID> PobIDList=new SET<ID>(); 
    public List<Agreement_POB__History> pobHistoryList= new List<Agreement_POB__History>();
    public List<Exercised_POB__History> expobHistoryList= new List<Exercised_POB__History>();
    public Map<ID,Agreement_POB__History> pobIdAndHistoryMap= new Map<ID,Agreement_POB__History>();
    public List<pobHistoryWrapperClass> pobwrapper{get;set;}
   // public Map<string,Agreement_POB__History> pobNameAndHistoryMap= new Map<string,Agreement_POB__History>();
     private ApexPages.StandardController controller {get; set;}
   
    public AgreementPOBHistory(ApexPages.StandardController controller) {
        this.controller=controller;
        display=true;
       
        for(Agreement_POB__c pob:[SELECT id,name from Agreement_POB__c where Agreement__c= :ApexPages.currentPage().getParameters().get('id')])
        {
            PobList.add(pob);
            PobIDList.add(pob.id);
        }
        for(Agreement_POB__History PobHistory:[SELECT Id,NewValue,OldValue,createddate,parentId,parent.name,parent.Agreement_POB_ID__c,parent.POB_Category__r.Name,field,createdBy.Name
                                               FROM Agreement_POB__History where ParentId IN: PobIDList order by createddate desc ])
        {
            pobIdAndHistoryMap.put(PobHistory.parentId, PobHistory);
            pobHistoryList.add(PobHistory);
            system.debug('PobHistory: '+PobHistory);
            //pobNameAndHistoryMap.put()
        }
        for(Exercised_POB__c expob:[SELECT id,name from Exercised_POB__c where CA_Agreement_Name__c= :ApexPages.currentPage().getParameters().get('id')])
        {
            exPobList.add(expob);
            //PobIDList.add(pob.id);
        }
        for(Exercised_POB__History exPobHistory:[SELECT Id,NewValue,OldValue,createddate,parentId,parent.name,parent.CA_Exercised_POB_Unique_ID__c,parent.CA_Agreement_POB_Name__r.Agreement_POB_ID__c,parent.CA_Agreement_POB_Name__r.Name,field,createdBy.Name
                                               FROM Exercised_POB__History where ParentId IN: exPobList order by createddate desc ])
        {
            expobHistoryList.add(exPobHistory);
            system.debug('PobHistory: '+exPobHistory);
          }
       }
    
    public List<Agreement_POB__History> getreturnPOBHistoryRecords()
    {     
        display=true;
        return pobHistoryList;
    }
    
    public List<Exercised_POB__History> getReturnExPobHistoryRecords()
        {
          return expobHistoryList;
        }
    
    
    public PageReference ExportData()
    {
       // PageReference pageRef = new PageReference('/p/attach/NoteAttach?pid='+dobj.Id+'&retURL=%2F'+dobj.id);
        return Page.ExportDataToExcel;
    }
    
    public class pobHistoryWrapperClass{
        public String pobName{get;set;}
        public String displayValue{get;set;}
        public String createddate{get;set;}
        public String user{get;set;}
    }
        }