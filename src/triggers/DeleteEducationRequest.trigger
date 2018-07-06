trigger DeleteEducationRequest on Quote_Product_Report__c (before delete) 
{
    delete [SELECT Id FROM Education_Request__c WHERE Quote_Product_Line_Item__c IN :Trigger.old];
       
    //start  As part of US456229 

    
    Set<Id> oppidset=new Set<Id>();
    Set<Id> qliset=new Set<Id>();
    Map<id,string> phaseMap=new Map<id,string>();
    Map<Id,List<Quote_Product_Report__c>> oppQLIMap = new Map<Id,List<Quote_Product_Report__c>>();
    Map<String,Quote_Product_Report__c> quotelineMap=new Map<String,Quote_Product_Report__c>();
    
    for(Quote_Product_Report__c QLI1:trigger.old){
        qliset.add(QLI1.id);
    }
    System.debug('-----QLI id----'+qliset);
    for(Quote_Product_Report__c quoteline:[select id,Phase_In_Out__c,Sterling_Quote__r.scpq__OpportunityId__c,Project_Number__c from Quote_Product_Report__c where id in :qliset]){
        oppidset.add(quoteline.Sterling_Quote__r.scpq__OpportunityId__c);
    }       
    
    System.debug('-----Opportunity Id----'+oppidset);
    
    
        for(Quote_Product_Report__c QLI : [select id,Phase_In_Out__c,Sterling_Quote__r.scpq__OpportunityId__c,Project_Number__c from  Quote_Product_Report__c where Sterling_Quote__r.scpq__OpportunityId__c in :oppidset and id not in: qliset and Sterling_Quote__r.CA_Primary_Flag__c=true]){
            if(oppQLIMap.containsKey(QLI.Sterling_Quote__r.scpq__OpportunityId__c)){    
                oppQLIMap.get(QLI.Sterling_Quote__r.scpq__OpportunityId__c).add(QLI);                        
            } else{    
                
                oppQLIMap.put(QLI.Sterling_Quote__r.scpq__OpportunityId__c,new List<Quote_Product_Report__c>{QLI});     
            }
            phaseMap.put(QLI.id,QLI.Phase_In_Out__c);
        }
    
  
    System.debug('------QLI phase values------'+phaseMap);
    Boolean Phase_flag;
    
    List<opportunity> listopp=[select id,Phase_In_out__c from Opportunity  where id=:oppidset];
    Set<Id> updatOpp=new Set<Id>();
    
    if(listopp!=null && listopp.size()>0){
        for(opportunity oppt:listopp){
            Phase_flag=false;
            if(oppQLIMap.containsKey(oppt.id)){
                for(Quote_Product_Report__c qpl : oppQLIMap.get(oppt.id)){
                    if(phaseMap.containskey(qpl.id)){
                        if(phaseMap.get(qpl.id)=='Phase In'||phaseMap.get(qpl.id)=='Phase Out' || phaseMap.get(qpl.id)=='Both'){
                            Phase_flag=true;
                            break;
                        }
                            
                    }
                }
            }
            if(oppt.Phase_In_out__c==true&&Phase_flag==false){
               oppt.Phase_In_out__c=Phase_flag;
              updatOpp.add(oppt.id); 
            }else if(oppt.Phase_In_out__c==false&&Phase_flag==true){
              oppt.Phase_In_out__c=Phase_flag;
               updatOpp.add(oppt.id);   
                
            }
           
        }
        System.debug('----Opportunities-----'+listopp);
     if(updatOpp.size()>0)
          update listopp;
        System.debug('----Opportunities updated-----'+listopp);
    }
    //End  As part of US456229 
}