public class TPC_SearchController{

  public List<List<SObject>> searchList{get;set;}
  public String searchquery{get;set;}
  public List<Contact> contactResult{get;set;}
  public List<Case> caseResult{get;set;}
  public List<Site_Association__c> siteResult{get;set;}
  public List<CA_Product_Controller__c> productResult{get;set;}
  public List<CA_Product_Component__c> componentResult{get;set;}
  public String searchTerm{get;set;}
  
  //Define which fields of which Object your want to display
  private String contactFields = 'Id,Name,Account.Name,TPC_Team__r.Name,email,MobilePhone';
  private String caseFields = 'Id,caseNumber,status,subject,priority,Site_Association__r.Name';
  private String siteFields = 'Id,Name,SC_TOPS_ID__c,Site_Status__c,Territory_Country__c,Country__c';
  private String productFields = 'Id,Name';
  private String componentFields = 'Id,Name,CA_Product_Controller__r.Name,CA_Product_Text__c,Component_Code__c,Component_Text__c';  
  private String siteFilter = '';
  private String caseFilter = '';
  private String contactFilter = '';
  private List<String> siteIds ;
  private String componentFilter = '';
  private String productFilter = '';
  private List<Id> siteContactIds ;
  private List<Id> componentIds;
  private List<Id> controllerIds;
    
  User communityUser ;
  TPC_Team__c  tpcteam;
    
  public TPC_SearchController(){
     
    siteContactIds = new List<Id>();
    componentIds = new List<Id>();
    controllerIds = new List<Id>();
      
    if(ApexPages.currentPage().getParameters().get('searchTerm') != NULL && ApexPages.currentPage().getParameters().get('searchTerm').trim() != ''){
          searchTerm = ApexPages.currentPage().getParameters().get('searchTerm');
    }
    
    communityUser = [select id,contact.TPC_Team__c,firstName,LastName from user where id=: UserInfo.getUserId()];
    if(communityUser.contact.TPC_Team__c != NULL){
        String teamName = communityUser.contact.TPC_Team__c;
    	caseFilter = ' RETURNING Case('+caseFields+' where TPC_Team__c = \''+teamName+'\')';
        
        tpcteam= [select id,Name,Tops_Site_Id__c from TPC_Team__C where id=: communityUser.contact.TPC_Team__c];
        
        if(tpcteam.Tops_Site_Id__c != NULL && tpcteam.Tops_Site_Id__c.trim() != ''){
            siteIds = tpcteam.Tops_Site_Id__c.split(';');
            siteFilter = ',Site_Association__c('+siteFields+' where SC_TOPS_ID__c IN : siteIds)';
            
            for(Contacts_Site_Association__c siteAss :[select id,SC_CSA_SITE__c,SC_CSA_CONTACTS__r.Id,SC_CSA_CONTACTS__c from Contacts_Site_Association__c  where SC_CSA_SITE__r.SC_TOPS_ID__c IN : siteIds]){
                siteContactIds.add(siteAss.SC_CSA_CONTACTS__r.Id);
            }
            contactFilter = ',Contact('+contactFields+' where Id IN : siteContactIds)';
            
            for(TPCTeamProductCodeAssociation__c productAssociation : [select id,CA_Product_Component__c,CA_Product_Component__r.CA_Product_Controller__c from TPCTeamProductCodeAssociation__c where TPC_Team__c =: communityUser.contact.TPC_Team__c]){
            	componentIds.add(productAssociation.CA_Product_Component__c);
                controllerIds.add(productAssociation.CA_Product_Component__r.CA_Product_Controller__c);
            }
            componentFilter = ',CA_Product_Component__c('+componentFields+' where Id IN : componentIds)';
            productFilter = ',CA_Product_Controller__c('+productFields+' where Id IN : controllerIds)';
            
        }
    }
    
    searchRecords(); 
  }
    
    public void searchRecords(){
        
        searchQuery = 'FIND \''+searchTerm+'\' IN ALL FIELDS';
        searchQuery += caseFilter;
        searchQuery += contactFilter;
        searchQuery += siteFilter;
        searchQuery += componentFilter;
        searchQuery += productFilter;
        searchQuery += ' LIMIT 200';
        System.debug(searchquery);
        //searchList=search.query(searchquery);
        searchList=System.search.query(searchquery);
    
        contactResult = ((List<Contact>)searchList[1]);
        caseResult    = ((List<Case>)searchList[0]);
        siteResult    = ((List<Site_Association__c>)searchList[2]);
        componentResult    = ((List<CA_Product_Component__c>)searchList[3]);
        ProductResult    = ((List<CA_Product_Controller__c>)searchList[4]);
        System.debug(searchList);
    } 
}