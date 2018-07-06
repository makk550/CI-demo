public class modifyresubcontroller {
    public Id opportunityid{get; set;} 
    public Set<Id> keyValues{get;set;}
   
    Set<id>  prodidset=new Set<id>();
   	list<id>  dreligibleproducts = new list<id>();
    list<opportunitylineitem>  opplineitemlist = new list<opportunitylineitem>();
   
    String opplineitemids='';
  
    public modifyresubcontroller(){
        if(opportunityid == null && ApexPages.currentPage().getParameters().get('oppId') != null){
                    opportunityid = ApexPages.currentPage().getParameters().get('oppId');
        }
       }
    
    public list<string> getinternaladdedproduct(){
        Set<id>  prodidset=new Set<id>();
   		list<id>  dreligibleproducts = new list<id>();
   	    list<opportunitylineitem>  opplineitemlist = new list<opportunitylineitem>();
		String opplineitemids='';
        
      	opportunity newopp = [Select DR_Added_Eligible_Products__c from opportunity where id =: opportunityid];  
        if (newopp.DR_Added_Eligible_Products__c.endsWith(','))     
  		  {       
        		opplineitemids = newopp.DR_Added_Eligible_Products__c.SubString(0,newopp.DR_Added_Eligible_Products__c.length()-1);       
    		} 
        for(String key : opplineitemids.split(',') ){
            if(key.contains('|YES') && key != null){
                system.debug('Deal reg ids before |YES'+ key);
            	String temp = key.removeEnd('|YES');	
                system.debug('Deal reg ids after |YES'+ temp);
            	dreligibleproducts.add(temp);
            }
        }
        opplineitemlist = [Select PricebookEntry.Product2.name from opportunitylineitem where id IN:dreligibleproducts AND Partner_Added__c= false ];
        list<string> temps = new list<string>();
        for(opportunitylineitem s : opplineitemlist){
            temps.add(s.PricebookEntry.Product2.name);
        }
      	return temps;
    }
 
}