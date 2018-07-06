public class MassLeadsAssignLookup {

//----------------------------- class parameters ----------------------------------------------//
	private String col1;
	private String col2;
	private String col3;
	private String col4;
	private String col5;
	private String col6;
	private String col7;
	private String col8;
	private String col1Header;
	private String col2Header;
	private String col3Header;
	private String col4Header;
	private String col5Header;
	private String col6Header;
	private String col7Header;
	private String col8Header;
	private boolean col1Visibility = true;
	private boolean col2Visibility = true;
	private boolean col3Visibility = true;
	private boolean col4Visibility = true;
	private boolean col5Visibility = true;
	private boolean col6Visibility = true;
	private boolean col7Visibility = true;
	private boolean col8Visibility = true;
	
	public String objName;
	private String searchAlertStr;
	public String accountId;
	public List<searchResultWrapper> searchResList = new List<searchResultWrapper>(); 
	
	public static String accResellerRecType = 'Reseller/Distributor Account';
	public static String accStatus = 'Approved';
	public static Integer recordLimit = 50; 

    /*
     * Initializes the visualforce pages with data. 
     *
     * @return a page reference
     */    
    public PageReference init() {
    
      	// retrieve the page variables
        objName = ApexPages.currentPage().getParameters().get('obj');
        accountId = ApexPages.currentPage().getParameters().get('acctId');        
        
        // query the objects        
       	searchResList = queryObject('*');
        
        // set the table column header names & columns visibility flags
        setColumnHeaders();  
    	
    	return null;
    }	 
    
    // returns the value of the 1st column header on the search result
    public String getCol1Header(){
    	return col1Header;	
    }
    
    // returns the visibility of the 1st column on the search result
    public boolean getCol1Visibility(){
    	return col1Visibility;	
    }
    
    // returns the value of the 2nd column header on the search result
    public String getCol2Header() {
    	return col2Header;	
    }
    
    // returns the visibility of the 2nd column on the search result
    public boolean getCol2Visibility(){
    	return col2Visibility;	
    }

    // returns the value of the 3rd column header on the search result
    public String getCol3Header() {
    	return col3Header;	
    }	
    
	// returns the visibility of the 3rd column on the search result
    public boolean getCol3Visibility(){
    	return col3Visibility;	
    }

	// returns the value of the 4th column header on the search result
	public String getCol4Header() {
		return col4Header;	
	}

	// returns the visibility of the 4th column on the search result
    public boolean getCol4Visibility(){
    	return col4Visibility;	
    }

    // returns the value of the 5th column header on the search result
    public String getCol5Header() {
    	return col5Header;	
    }

	// returns the visibility of the 5th column on the search result
    public boolean getCol5Visibility(){
    	return col5Visibility;	
    }

	// returns the value of the 6th column header on the search result
    public String getCol6Header() {
    	return col6Header;	
    }
    
    // returns the visibility of the 6th column on the search result
    public boolean getCol6Visibility(){
    	return col6Visibility;	
    }
    
    // returns the visibility of the 7th column on the search result
    public boolean getCol7Visibility(){
    	return col7Visibility;	
    }
    
    // returns the value of the 7th column header on the search result
    public String getCol7Header() {
    	return col7Header;	
    }
    
    // returns the visibility of the 8th column on the search result
    public boolean getCol8Visibility(){
    	return col8Visibility;	
    }
    
    // returns the value of the 8th column header on the search result
    public String getCol8Header() {
    	return col8Header;	
    }
    
    // returns the search alert string when the search results yield more than recordLimit rows
    public String getSearchAlertStr() {
    	return searchAlertStr;	
    }
    
    // returns the search result list
    public List<searchResultWrapper> getSearchResList() {    	
    	return searchResList;		
    }
    
    /*
     * Function that queries Account/Contact object to populate the search result
     *  
     * @param search string
     * 
     * @returns List<searchResultWrapper>
     */    
    public List<searchResultWrapper> queryObject(String pSearchVar) {
    	if(objName == 'Acc')
    	{
	    	List<Account> accs = [Select Id,a.BillingCity, a.BillingState, a.Country_Picklist__c, a.Name, a.Owner.FirstName, a.Owner.LastName,  a.Region_Country__c, 
	    						  a.Sales_Area__c,a.Customer_Category__c from Account a  
	    						  where a.RecordType.Name = : accResellerRecType and a.Account_Status__c = : accStatus 
	    						  and a.Name like : createSearchStr(pSearchVar) order by a.Name
	    						  limit 50];
	    						  
	    	for(integer i=0;i<50;i++)
	    	{    
	    		try
	    		{
	    			searchResList.add(new searchResultWrapper(accs.get(i).Name,accs.get(i).Region_Country__c,accs.get(i).Sales_Area__c,accs.get(i).Country_Picklist__c,accs.get(i).BillingCity,accs.get(i).BillingState,accs.get(i).Owner.LastName,accs.get(i).Owner.FirstName,accs.get(i).Id,'acct',''));
	    		}
	    		catch(Exception e)
	    		{
	    			// catch any exceptions.. 
	    		}
	    	}
	    	if(accs.size() > recordLimit)
	    		searchAlertStr = 'The search returned more than the maximum 50 rows. Please refine your search.';	
    	}
    	else if(objName == 'cont')
    	{
	    	List<Contact> contacts = [Select c.Id,c.Name,c.Account.Name, c.Phone, c.Email,c.Title from Contact c where c.Account.Id = : accountId and (c.LastName like : createSearchStr(pSearchVar) or c.FirstName like:createSearchStr(pSearchVar)) order by c.Name limit 50];
	    	for(integer i=0;i<50;i++)
	    	{    
	    		try
	    		{
	    			searchResList.add(new searchResultWrapper(contacts.get(i).Name,contacts.get(i).Account.Name,contacts.get(i).Phone,contacts.get(i).Email,contacts.get(i).Title,'','','',contacts.get(i).Id,'cont',''));
	    		}
	    		catch(Exception e)
	    		{
	    			// catch any exceptions.. 
	    		}
	    	}
	    	if(contacts.size() > recordLimit)
	    		searchAlertStr = 'The search returned more than the maximum 50 rows. Please refine your search.';	
    	}    	
		return searchResList;    	
    }

    /*
     * Function that creates & returns the search string
     *  
     * @param string
     * 
     * @returns string
     */    
	public String createSearchStr(String searchVar)	{
	    if (searchVar == '*')
    		searchVar = '';
    	else if(searchVar.endsWith('*'))
    		searchVar = searchVar.substring(0,searchVar.length()-1);   		   	
    	searchVar = '%'+searchVar+'%';
    	return searchVar;
	}
	
    /*
     * Function to set the column header names & columns visibilities
     *  
     */    
	public void setColumnHeaders() {
		if(objName == 'Acc')
		{
			col1Header = 'Account Name';
			col2Header = 'Region';
			col3Header = 'Area';
			col4Header = 'Territory/Country';
			col5Header = 'Physical City';
			col6Header = 'Physical State Province';
			col7Header = 'Owner Last Name';
			col8Header = 'Owner First Name';
		}
		else if(objName == 'cont') 
		{
			col1Header = 'Name';
			col2Header = 'Account Name';
			col3Header = 'Phone';
			col4Header = 'Email';
			col5Header = 'Title';
			col6Visibility = false;
			col7Visibility = false;
			col8Visibility = false;							
		}
		else if(objName == 'psite') 
		{
			col1Header = 'Reseller';
			col2Header = 'Address';
			col3Header = 'City';
			col4Header = 'State';
			col5Header = 'Zip';
			col6Visibility = false;
			col7Visibility = false;
			col8Visibility = false;							
		}
	}
    
    /*
     * function to perform the search action on click of the Go button
     *
     * @return a null reference
     */    
    public PageReference searchAction() {
    	resetVariables();
    	String searchText = ApexPages.currentPage().getParameters().get('leadsLookupPgId:lookUpForm:searchTxt');
    	if(searchText == null || searchText == 'null')
    		searchText = '';
    	searchResList = queryObject(searchText);
    	return null;	
    }

    /*
     * function to reset the value of the class variables
     *
     */    
	public void resetVariables() {
			searchAlertStr = '';
			searchResList = null;
    		searchResList = new List<searchResultWrapper>(); 			
		}

    /*
     * a wrapper class to display the search result
     *
     */    
	public class searchResultWrapper {
		private String strCol1;
		private String strCol2;
		private String strCol3;
		private String strCol4;
		private String strCol5;
		private String strCol6;
		private String strCol7;
		private String strCol8;
		private String strObjId;
		private String strObjName;
		private String strDispName;
		
		// returns the value of the 1st column on the search result
		public String getStrCol1(){
			return strCol1;	
		}	
		
		// returns the value of the 2nd column on the search result	
		public String getStrCol2() {
			return (strCol2 != null ? strCol2 : '');			
		}
		
		// returns the value of the 3rd column on the search result
		public String getStrCol3() {
			return (strCol3 != null ? strCol3 : '');
		}		
		
		// returns the value of the 4th column on the search result	
		public String getStrCol4(){
			return (strCol4 != null ? strCol4 : '');
		}

		// returns the value of the 5th column on the search result
		public String getStrCol5(){
			return (strCol5 != null ? strCol5 : '');	
		}	
		
		// returns the value of the 6th column on the search result	
		public String getStrCol6() {
			return (strCol6 != null ? strCol6 : '');			
		}
		
		// returns the value of the 7th column on the search result
		public String getStrCol7() {
			return (strCol7 != null ? strCol7 : '');
		}		
		
		// returns the value of the 8th column on the search result	
		public String getStrCol8(){
			return (strCol8 != null ? strCol8 : '');
		}
		
		// returns the value of the selected record id
		public String getStrObjId() {
			return strObjId;
		}		
		
		// returns the name of the selected record	
		public String getStrObjName(){
			return strObjName;
		}	
		
		public String getStrDispName(){			
			return strDispName;	
		}
		
		// constructor for the wrapper class
		public searchResultWrapper(String column1,String column2,String column3,String column4,String column5,String column6,String column7,String column8,String id,String objName,String dispName){
			strCol1 = column1;
			strCol2 = column2;
			strCol3 = column3;
			strCol4 = column4;
			strCol5 = column5;
			strCol6 = column6;
			strCol7 = column7;
			strCol8 = column8;
			strObjId = id;
			strObjName = objName; 	
			strDispName = dispName;		
		}
	}
	
    /*
     * test method for the searchResultWrapper class
     *
     */    
	static testMethod void testMassLeadsAssignAccLookup() {
		searchResultWrapper srWrapper = new searchResultWrapper('str1','str2','str3','str4','str5','str6','str7','str8','str9','str10','str11');
		srWrapper.getStrCol1();
		srWrapper.getStrCol2();
		srWrapper.getStrCol3();
		srWrapper.getStrCol4();
		srWrapper.getStrCol5();
		srWrapper.getStrCol6();
		srWrapper.getStrCol7();
		srWrapper.getStrCol8();
		srWrapper.getStrObjId();
		srWrapper.getStrDispName();
		srWrapper.getStrObjName();
	}
}