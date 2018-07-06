/*
* Account After Delete trigger 
* Used to update the Site Association records under Losing account in Merge 
* Created By: GODVA01
*/
trigger updateSiteAssociationOnAccountMerge on Account (after Delete) {

    try{
        List<Site_Association__c> templist= new List<Site_Association__c>();
        Map<Id, List<Site_Association__c>> mapSA = new Map<Id, List<Site_Association__c>>();
        Map<Id, Site_Association__c> mapSAtoSend = new Map<Id, Site_Association__c>();
        
        if (trigger.isAfter && trigger.isDelete)
        {
            System.debug('After Delete');       
            Set<Id> accid = new Set<Id>();
            for(Account a : Trigger.old)
            {
                if(a.masterRecordId <> null)
                    accid.add(a.masterRecordId);
                System.debug('Before delete: a.masterrecordid: '+a.masterrecordid );
            }
            System.debug('AccountId Set: '+accid);
            List<Site_Association__c> listSA;
            List<Site_Association__c> listSASend;
            if(accid.size() > 0) {
                listSA = [Select Id, Enterprise_ID__c, Site_Status__c,Enterprise_ID_F__c, LastModifiedById, LastModifiedDate from Site_Association__c where Enterprise_ID__c in: accid];
                listSASend = new List<Site_Association__c>();
                System.debug('SA List: '+listSA);
                if(listSA != null && listSA.size()>0)
                for(Site_Association__c sa : listSA)
                {            
                    List<Site_Association__c> listnewsa = mapSA.get(sa.Enterprise_ID__c);
                    if(listnewsa==null)    
                    {
                        listnewsa = new List<Site_Association__c>();           
                        mapSA.put(sa.Enterprise_ID__c, listnewsa);
                    }
                    listnewsa.add(sa);
                }
                System.debug('mapSA : '+mapSA);
            }      
            for(Account a : trigger.old)
            {
                if(mapSA.get(a.masterrecordid) != null && mapSA.get(a.masterrecordid).size()>0)
                for(Site_Association__c sa : mapSA.get(a.masterrecordid))
                {
                    if(Date.valueof(sa.lastmodifieddate+'') == system.today())
                    listSASend.add(sa);
                }
            }        
            System.debug('List SA Send: '+listSASend);
            System.debug('listSASend.size(): '+listSASend.size());
            
            if(listSASend != null && listSASend.size()>0)
            for(Site_Association__c sa : listSASend)
                mapSAtoSend.put(sa.id,sa);
                
            System.debug('Map to Send: '+mapSAtoSend);
             
            if(mapSAtoSend != null)
            {
                SiteAssociationChangesPushToMDM obj = new SiteAssociationChangesPushToMDM();
                obj.pushSiteAssociationChangesToMDM(mapSAtoSend);
            }
         }
     }
     Catch(Exception e)
     {
         System.debug('Exception in updateSiteAssociationOnAccountMerge: '+ e );
     }     
}