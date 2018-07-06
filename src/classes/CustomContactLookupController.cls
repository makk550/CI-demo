public with sharing class CustomContactLookupController {

  public List<Contact> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string accountId{get;set;} 
  public String key; 

  public CustomContactLookupController() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    accountId = System.currentPageReference().getParameters().get('accId');
    System.debug('accountID:'+accountId);  
    if(accountId == null || String.isEmpty(accountId))
        key  = 'Search all Accounts';
    else
        key = 'Search by Account';
    System.debug('key:'+key);  
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<Contact> performSearch(string searchString) {
      String soql;
      String tempSearch = searchString;
      if(tempSearch.contains('*'))
          searchString = tempSearch.remove('*');
          
      System.debug('key:'+key);
      if(key == 'Search all Accounts') { 
        soql = 'select id, Name, Account.Name from Contact';
        if(searchString != '' && searchString != null){
              if(tempSearch.startsWith('*')&&tempSearch.endsWith('*')){  
            soql = soql +  ' where Name LIKE \'%' + searchString +'%\'';
              }else if(tempSearch.startsWith('*')){
               soql = soql +  ' where Name LIKE \'%' + searchString+'\'';   
              }else if(tempSearch.endsWith('*')){
               soql = soql +  ' where Name LIKE \'' + searchString +'%\'';   
              }else{
               soql = soql +  ' where Name LIKE \'%' + searchString +'%\'';  
              }
          }
        soql = soql + ' limit 75';
        System.debug(soql);
      }
      else if(key == 'Search by Account'){
        soql = 'select id, name, Account.Name from Contact where Contact.AccountId=\''+accountId+'\'';
        if(searchString != '' && searchString != null){
              if(tempSearch.startsWith('*')&&tempSearch.endsWith('*')){  
            soql = soql +  ' and Name LIKE \'%' + searchString +'%\'';
              }else if(tempSearch.startsWith('*')){
               soql = soql +  ' and Name LIKE \'%' + searchString+'\'';   
              }else if(tempSearch.endsWith('*')){
               soql = soql +  ' and Name LIKE \'' + searchString +'%\'';   
              }else{
               soql = soql +  ' and Name LIKE \'%' + searchString +'%\'';  
              }
          }
        soql = soql + ' limit 1000';
        System.debug(soql); 
      }
    return database.query(soql);
  }
    
  public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('Search by Account','Search by Account'));
    options.add(new SelectOption('Search all Accounts','Search all Accounts'));
  return options;
  }  

  public String getKey() {
        return key;
  }
  public void setKey(String key) { this.key = key; }
  
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}