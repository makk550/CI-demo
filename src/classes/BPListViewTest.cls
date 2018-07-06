@isTest(SeeAllData=true)
public with sharing class BPListViewTest {
    
	static Set<Integer> fyears = new Set<Integer>();
	static Set<Integer> validfyears = new Set<Integer>();
	static BPListViewController controllerObj = new BPListViewController();
	    
	static testMethod void runTestCase(){	
        
		Integer fyear = (controllerObj.curFYear);			     
		validfyears.add(fyear-1);
		validfyears.add(fyear);
		validfyears.add(fyear+1);	
      
		User user = [select id from User where is_Partner_User__c = true limit 1];	    	
    	System.runAs(user){
    		System.debug('userId:'+user.Id);    		
	    	List<Business_Plan_New__c> BPlist = controllerObj.getRelatedBPs();
	    	String bpFiscalYear;
	    	for(Business_Plan_New__c bp:BPlist){
	    		bpFiscalYear = bp.Plan_Fiscal_Year__c;
	            bpFiscalYear = bpFiscalYear.removeStart('FY ');          
	            Integer bpFYear = integer.valueof(bpFiscalYear);
	    		fyears.add(bpFYear);    		
	    	}
            System.debug('fyears:'+fyears);
            System.debug('validfyears:'+validfyears);
	    	System.assertEquals(true,validfyears.containsAll(fyears));	
    	}    	
	}
}