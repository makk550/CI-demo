public without sharing class ContactTriggerUtility {
    
    public static boolean bypassoppcreation=false;
    public static Map<id,opportunity> InsertOppsMap=new Map<id,opportunity>();
    public static Map<id,OpportunityContactRole> InsertOppContRolesMap=new Map<id,OpportunityContactRole>();
    
    
    public static list<opportunity> Opplist;
    public static list<account> Acclist;
    
    public static list<opportunity> getExistingOpps(set<id> accids,set<string> gbuD100s){
        
        if(Opplist != null && Opplist.size()>0){
            return Opplist;
        }
        else {
            Opplist=[select id,Accountid,GBU_Driver_100__c,name
                     from opportunity 
                     where Accountid in :accids and GBU_Driver_100__c in: gbuD100s 
                     and Contact_Is_Source__c=true and Transaction_Type__c='Direct'];
            return Opplist;
        }

    }
    
    public static list<account> getAccNames(set<id> accidsName){
        
        Acclist=[select name from account where id in:accidsName];
        return Acclist;
    }
    
    public static Map<string,set<id>> getContactRoles(Set<Id> conIdSet, Set<String> gbuD100s){
        Map<string,set<id>> OppId_ContactIdsMap=new Map<string,set<id>>();
        // create map of opp id_gbudriver and contact id to avoid insertion of duplicate contact roles on opp
        for(OpportunityContactRole oc: [SELECT ContactId, OpportunityId,Opportunity.Name,Opportunity.GBU_Driver_100__c FROM OpportunityContactRole WHERE ContactId IN: conIdSet AND Opportunity.GBU_Driver_100__c IN: gbuD100s and Opportunity.Contact_Is_Source__c=true AND IsDeleted = false]) {
            string key=oc.OpportunityId+'_'+oc.Opportunity.GBU_Driver_100__c;
            System.debug('+++ key in utility +++'+key);
            if(OppId_ContactIdsMap.containsKey(key)){
                OppId_ContactIdsMap.get(key).add(oc.ContactId);
            } 
            else{
                OppId_ContactIdsMap.put(key,new set<id>{oc.ContactId});
            }
        }
        return OppId_ContactIdsMap;
    }

    
    public static Map<Id,Set<Id>> getPrevOpps(Set<Id> conIdSet, Set<String> gbuD100s) {
        Map<Id,Set<Id>> conOppsIdMap = new Map<Id,Set<Id>>();
        for(OpportunityContactRole extOppCon : [SELECT ContactId, OpportunityId FROM OpportunityContactRole WHERE ContactId IN: conIdSet AND Opportunity.GBU_Driver_100__c IN: gbuD100s AND IsDeleted = false]) {
            if(conOppsIdMap.containsKey(extOppCon.ContactId))
                conOppsIdMap.get(extOppCon.ContactId).add(extOppCon.OpportunityId);
            else
                conOppsIdMap.put(extOppCon.ContactId, new Set<Id> {extOppCon.OpportunityId});
        }
        return conOppsIdMap;
    }
    
    
    public static void OppsAndContactRoles(Map<id,opportunity> OppsToBeInsertedMap,Map<id,OpportunityContactRole> OppContactRolesMap){
        // insert Opportunities 
        if(OppsToBeInsertedMap != null && OppsToBeInsertedMap.size()>0){
            System.debug('+++ opp is inserted to be+++');
            InsertOppsMap= OppsToBeInsertedMap;
        }
        
        // Avoid the duplicate contact role insertion on opportunityContactRole of Opp and update Opp id on contact roles to be inserted.
        if(OppContactRolesMap != null && OppContactRolesMap.size()>0){
            System.debug('+++ Opp contact insertion size +++'+OppContactRolesMap.size());
            InsertOppContRolesMap=OppContactRolesMap;
            
        }
    }
    
    public static void InsertOpp_ContRoles(){
        // this method is for to insert opps and contact roles after update of contact trigger.
        System.debug('+++ update update operation +++');
        System.debug('+++ insert opp size +++'+InsertOppsMap.size());
        System.debug('+++ insert contact role size +++'+InsertOppContRolesMap.size());
       if(!Test.isRunningTest()){
           if(InsertOppsMap != null && InsertOppsMap.size()>0){  insert InsertOppsMap.values();}
        
        
        if(InsertOppContRolesMap != null && InsertOppContRolesMap.size()>0){
            if(InsertOppsMap != null && InsertOppsMap.size()>0){
                
                for(id cid:InsertOppsMap.keySet()){
                    InsertOppContRolesMap.get(cid).opportunityid=InsertOppsMap.get(cid).id;
                }
            }
             	System.debug('+++ contact roles insertion +++');
                insert InsertOppContRolesMap.values();
        }
       }
    }
    
}