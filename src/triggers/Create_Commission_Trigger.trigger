trigger Create_Commission_Trigger on Presales_Request__c (Before Insert) {
    if(Label.Adding_To_OppTeam!='true')
    return;

    Map<id,Presales_Request__c> preSalesmap=new Map<id,Presales_Request__c>();
    set<id> preSalesId=new Set<id>();
       Map<id,string> presalMap=new Map<id,string>();   
   
 
     if(Trigger.isBefore&&Trigger.isInsert){
        for(Presales_Request__c presal:trigger.new){
            
            presalMap.put(presal.opportunity__c, presal.Commission_BU__c);
            
        }
        
         Map<id,PreSales_Comm__c> preSalCom= new Map<id,PreSales_Comm__c>([select id,Presales_Resource1__c,Presales_Resource2__c,Presales_Resource3__c,Commission_Split1__c,Commission_Split2__c,Commission_Split3__c from PreSales_Comm__c where OpportunityId__c=:presalMap.keySet() and Commission_BU__c=:presalMap.values()]);
         
        
        System.debug('----------------------'+preSalCom);

        if(preSalCom.size()==0){
            System.debug('----------------------'+preSalCom);
            List<PreSales_Comm__c> listCom=new List<PreSales_Comm__c>();
            for(Presales_Request__c preRec:trigger.new){
                PreSales_Comm__c comm=new PreSales_Comm__c();
                  comm.OpportunityId__c=preRec.Opportunity__c;
                  comm.Commission_BU__c=preRec.Commission_BU__c;
                   listCom.add(comm);
                
                
            }
            if(listCom.size()>0){
                 insert listCom;
                Map<id,Presales_Request__c> presaleMap=new Map<id,Presales_Request__c>();
                for(Presales_Request__c pre:trigger.new){
                      pre.PreSales_Commission__c = listCom[0].id;
                     
                }             
                
            }
                        
        }else if(preSalCom.size()>0){
                Map<id,Presales_Request__c> preMap=new Map<id,Presales_Request__c>();
                for(Presales_Request__c pre:trigger.new){
                      pre.PreSales_Commission__c = preSalCom.values()[0].id;  

                }
                                 
            }
    }

}