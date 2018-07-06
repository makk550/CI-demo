/**
* Description :  This trigger is to update Queue Id field of TAQ Rules object when ever
*                a TAQ Rule record is created with Queue name entered.
*               
* Author       : Jagan Babu Gorre
* Company      : Accenture
* Client       : Computer Associates
* Last Update  : March 2010
**/

trigger CA_TAQ_UpdateQueueId on TAQ_Rules__c (before insert,before update) {

    Set<String> stQueNames=new Set<String>();
    Map<String,String> MpGrp = new Map<String,String>(); 
    Map<String,String> MpRecTyp = new Map<String,String>(); 
    
    //Run loop over query and put all the values in Map.
    for(RecordType recTyp:[SELECT name, id FROM RecordType 
                            WHERE SobjectType in ('TAQ_Account__c','TAQ_Organization__c')])
        MpRecTyp.put(recTyp.name, recTyp.id);
    
    //Extract all the queue names and collect in set.
    for(TAQ_Rules__c tr:trigger.new)
        stQueNames.add(tr.Queue_Name__c);
    
    //Run loop over query and put all the values in Map.
    for(Group g:[SELECT name,id FROM group WHERE name  in :stQueNames and type='Queue'])
        MpGrp.put(g.name,g.id);
        
    for(TAQ_Rules__c tr:trigger.new){
    
        if(tr.Queue_Name__c<>null){
            
                //Get the value from map and assign it to the queue id field.
                if(stQueNames.contains(tr.Queue_Name__c)) {
                    tr.Owner_Name_Id__c=MpGrp.get(tr.Queue_Name__c);
                } else {
                    tr.Owner_Name_Id__c=null;
                }
         } else {
             tr.Owner_Name_Id__c=null;
         }
         
        if(tr.Record_Type_Name__c<>null){
            tr.Record_Type_Id__c=MpRecTyp.get(tr.Record_Type_Name__c);
        } else {
            tr.Record_Type_Id__c=null;
        }
        
       
    }
}