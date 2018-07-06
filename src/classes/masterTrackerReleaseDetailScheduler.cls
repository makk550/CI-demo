/*
 * Test Class = masterTrackerTestClass
 * Updated by - BAJPI01
 * Coverage = 88%
*/

global class masterTrackerReleaseDetailScheduler Implements Schedulable{
    
    global void execute(SchedulableContext sc){
        updateReleaseDetails();
    }
    
    public void updateReleaseDetails(){
        List<ReleaseDetails__c> oldActiveReleases = new List<ReleaseDetails__c>();
        List<ReleaseDetails__c> newToBeActiveReleases = new List<ReleaseDetails__c>();
        List<ReleaseDetails__c> toBeUpdatedReleases = new List<ReleaseDetails__c>();
        
        oldActiveReleases = [select id,isActive__c,ReleaseDate__c from ReleaseDetails__c where ReleaseDate__c<:system.today() and isActive__c=true];
        
        if(oldActiveReleases!=null && oldActiveReleases.size()>0){
            newToBeActiveReleases = [select id,isActive__c,ReleaseDate__c from ReleaseDetails__c where ReleaseDate__c>:system.today() and
                                     isActive__c=false ORDER BY ReleaseDate__c ASC limit 1 ];
            
            for(ReleaseDetails__c rd:oldActiveReleases){
                rd.isActive__c=false;
            }
            toBeUpdatedReleases.addAll(oldActiveReleases);
            if(newToBeActiveReleases!=null && newToBeActiveReleases.size()>0){
                newToBeActiveReleases[0].isActive__c = true;
                toBeUpdatedReleases.addAll(newToBeActiveReleases);
            }
                
        }
        if(toBeUpdatedReleases!=null && toBeUpdatedReleases.size()>0)
        	update toBeUpdatedReleases;
    }

}