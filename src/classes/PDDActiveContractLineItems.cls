public class PDDActiveContractLineItems {
       Public String pddEnhID {get;set;}
	   public String activeContractLineItem{get;set;}
       Public Integer noOfRecords{get; set;}
       Public Integer size{get;set;}
       public Boolean showButtons{get;set;}
       public String[] contractItemStrArr {get;set;}
    	
 public PDDActiveContractLineItems(){
       pddEnhID = ApexPages.currentPage().getParameters().get('id');
        size=50;
 }
  
    public List<Active_Contract_Line_Item__c> getActiveContractLineItems(){
        
         if(pddEnhID != null){
           try{
                activeContractLineItem = [SELECT Associated_Contracts__c  FROM PDD_Enhanced__c where id = :pddEnhID limit 1].Associated_Contracts__c;
                contractItemStrArr =  activeContractLineItem.split(';');
                System.debug('%%%%%'+contractItemStrArr);
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Active ContractLine Items for this Product can be found.');
                ApexPages.addMessage(myMsg);
            }
        }
        return setCon.getRecords();
    }
    
     public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                string mymainquery ='SELECT id, Contract_Item__c, Installation_Date__c ,Licensed_Quantity__c ,Dismantling_Date__c ,Ship_To_ID__c , Contract_Product__r.Active_Contract__r.Account__r.Name,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.City__c,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.State__c,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.Country_Picklist__c,Calculated_Orig_ATTRF_USD__c,Orig_ATTRF_LC__c  FROM Active_Contract_Line_Item__c'; 
                String whereClause = ' where Contract_Item__c IN :contractItemStrArr';  
                string orderBy = ' order BY id';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(mymainquery+whereClause+orderBy));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    
       // Indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    
    // Indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    // Returns the page number of the current page set
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    // Returns the first page of records
    public void first() {
        setCon.first();
    }
    
    // Returns the last page of records
    public void last() {
        setCon.last();
    }
    
    // Returns the previous page of records
    public void previous() {
        setCon.previous();
    }
    
    // Returns the next page of records
    public void next() {
        setCon.next();
    }
    
    // Returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        setCon.cancel();
    }
    //Changes the size of pagination
   public pageReference refresh() {
         setCon.setPageNumber(1);
         setCon.setPageSize(size);
         return null;
    }
}