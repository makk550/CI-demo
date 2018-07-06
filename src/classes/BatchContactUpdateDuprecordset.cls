global class BatchContactUpdateDuprecordset implements Database.Batchable<sObject>{

   list <DuplicateRecordSet> duprecsetlist = new List <DuplicateRecordSet> ();
    list <DuplicateRecordSet> dupreclist = new List <DuplicateRecordSet> ();
    
    list <DuplicateRecordItem> duprecitemlist = new List <DuplicateRecordItem> ();
    List <Contact> contactlist1 = new List <Contact> ();
   
    Map<string,list<id>> emailcomap=New Map<string,list<id>>();
    Map<string,DuplicateRecordSet> duprecsetmap=New Map<string,DuplicateRecordSet>();
    
    Map<id,id> duprecitemap=New Map<id,id>();
  datetime dt = System.now()-1;
    public id dupRuleId=system.label.CI_duplicateruleid;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return DataBase.getQueryLocator([SELECT Id, Email
                                         FROM Contact
                                         WHERE createdDate > :dt
                                        ]);
    }
    global void execute(Database.BatchableContext BC , List <Contact> contactlist) {
        system.debug('entered exicute method'+contactlist);
        set<string> emailset=New set<string>();
        set <DuplicateRecordSet> duprecSet = new set <DuplicateRecordSet> ();
        //List <Contact> Historicalcontacts=New List <Contact>();
        
            for(Contact cons:contactlist){
                emailset.add(cons.Email);
                
            }
            
            for(DuplicateRecordSet drss:[SELECT Id,DuplicateEmail__c,(select id,Recordid from DuplicateRecordItems) from DuplicateRecordSet where DuplicateEmail__c IN :emailset]){
                    System.debug('============='+drss);
                    
                   duprecsetmap.put(drss.DuplicateEmail__c, drss); 
                    for(DuplicateRecordItem drm:drss.DuplicateRecordItems){
                        
                        duprecitemap.put(drm.RecordId, drss.Id);
                    }
                    
                }
       
        for(Contact hco:[SELECT Id,Email FROM Contact where createdDate < :dt and Email IN :emailset]){
            for (Contact con : contactList){
                
					if(con.Email==hco.Email && !duprecsetmap.containsKey(con.Email)){
                        system.debug('con.email---'+con.Email+'hco email---'+hco.Email);
                      DuplicateRecordSet drs=New DuplicateRecordSet();  
                      drs.DuplicateRuleId=dupRuleId;
                      drs.Status__c='Inserted through Batch class';
                      drs.DuplicateEmail__c=con.Email;
                      // insert drs;
                        //DuplicateRecordItem drsitm=New DuplicateRecordItem();
                        if(emailcomap.containsKey(con.Email)){
                        List<Id> contactids = emailcomap.get(con.Email);
                            contactids.add(hco.id);
                            contactids.add(con.id);
                            emailcomap.put(con.Email, contactids);


                    }else{
                       emailcomap.put(con.Email,New List<id>{hco.id,con.id}); 
                    }
                     
                     duprecSet.add(drs); 
                        system.debug('in new '+duprecSet);
                    }else{
                        
                         if(emailcomap.containsKey(con.Email)){
                        	List<Id> contactids = emailcomap.get(con.Email);
                            contactids.add(hco.id);
                            contactids.add(con.id);
                            emailcomap.put(con.Email, contactids);


                    	}else{
                       		emailcomap.put(con.Email,New List<id>{hco.id,con.id}); 
                    	}
                        duprecSet.add(duprecsetmap.get(con.Email));
                        system.debug('in existing '+duprecSet);
                    }
            
				}
            }
        system.debug('emailcomap--------'+emailcomap);
        system.debug('emailcomap-----size---'+emailcomap.size());
        if(duprecSet.size()>0){
            for(DuplicateRecordSet dr:duprecSet){
                if(dr!=Null){
                    duprecsetlist.add(dr);
                }
            }
           
            system.debug('in duprecsetlist '+duprecsetlist);
        }
        if(duprecsetlist.size()>0 && duprecsetlist!=null){
            system.debug('in first Upsert');
          upsert duprecsetlist;
            
        }
        system.debug('After first Upsert'+duprecsetlist);
        
        Set<id> conids=new Set<Id>();
        
        
        if(duprecsetlist!=null && !duprecsetlist.isEmpty()){
            system.debug('In child if');
            system.debug('emailmap------'+emailcomap.get('nihalvats@gmail.com'));
            for(DuplicateRecordSet drs:duprecsetlist){
                if(emailcomap.containsKey(drs.DuplicateEmail__c)){
                    conids.addAll(emailcomap.get(drs.DuplicateEmail__c));
                    system.debug('conids set--'+conids);
                    for(contact conid:[select id,email from contact where id IN: conids]){
                        if(!duprecitemap.containsKey(conid.id) && drs.DuplicateEmail__c== conid.Email){
                       DuplicateRecordItem drsitm=New DuplicateRecordItem(); 
                        drsitm.DuplicateRecordSetId=drs.Id;
                        drsitm.RecordId=conid.id;
                        duprecitemlist.add(drsitm);
                        
                        } 
                    }
                }
             }
            system.debug('duprecitemlist list'+duprecitemlist);
             if(duprecitemlist.size()>0 && !duprecitemlist.isEmpty()){
        upsert duprecitemlist;
        }
            
        } 
    } 
    global void finish(Database.BatchableContext BC){
        
    }
}