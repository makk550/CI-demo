/* SFDC CRM 7.1 Req#495
Create a Create/Update Trigger to monitor if there is a change to the original Business Relationship Status field and translate this update along with the date to the new object 
*/
trigger businessRelStatHistory on HVN__c (before update, after insert) {
    List<HVN__C> newHVN = Trigger.New;
    List<HVN__C> oldHVN = Trigger.old;
    
    businessRelStatHistory obj = new businessRelStatHistory();
    obj.setStatus(newHVN, oldHVN );
}