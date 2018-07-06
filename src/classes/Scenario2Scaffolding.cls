public class Scenario2Scaffolding {
	
	public Account account {get;private set;}
    
    public List<Partner_Location__c> locations {get;private set;}
        
    public Scenario2Scaffolding(Account account, List<Partner_Location__c> locations){
    	this.account = account;
        this.locations = locations;
	}
        
}