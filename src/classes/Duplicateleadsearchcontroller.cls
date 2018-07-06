public class Duplicateleadsearchcontroller {

    public static Lead currentRecord{get; set;}
    public static List<Lead> Oldleadlist{get;set;}
    public static List<Opportunity> OldOpportunitylist{get;set;}
    public static id CAaccountid{get;set;}
    public static string cbudriver{get;set;}
    public static List<DuplicateWrapper> dupeleadlist{get;set;}
    public static List<DuplicateWrapper2> dupeopplist{get;set;}
    public  List<DuplicateWrapper> finaldupeleadlist{get;set;}
   
    public Duplicateleadsearchcontroller(){

        Set<String> oppStageNames = new Set<String>{'Deal Reg - Pending',Label.Opp_Stage_10_Percent,Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,
                                                    Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent};
        
        dupeleadlist= New List<DuplicateWrapper>();
        dupeopplist= New List<DuplicateWrapper2>();
    	 currentRecord = [SELECT Id, Name,CSU_Driver__c,Commercial_Account__c,EAID__c FROM lead WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        system.debug('---currentRecord----'+currentRecord);
        CAaccountid=currentRecord.Commercial_Account__c;
        cbudriver=currentRecord.CSU_Driver__c;
        system.debug('---CAaccountid----'+CAaccountid+'  ----cbudriver----'+cbudriver);
        if(CAaccountid!=Null && cbudriver!=''){
         Oldleadlist=[select id,Name,CSU_Driver__c,Commercial_Account__c,EAID__c from Lead where Commercial_Account__c=:currentRecord.Commercial_Account__c And CSU_Driver__c=:currentRecord.CSU_Driver__c and Id != :ApexPages.currentPage().getParameters().get('id')];
        system.debug('----Oldleadlist----'+Oldleadlist);
            if(Oldleadlist.size()>0){
                for(Lead ld:Oldleadlist){
                    if(ld.Commercial_Account__c==currentRecord.Commercial_Account__c && ld.CSU_Driver__c==currentRecord.CSU_Driver__c){
                        DuplicateWrapper  dupleads= new DuplicateWrapper();
                        dupleads.lds=ld;
                        dupeleadlist.add(dupleads);
                    }
                }
                 system.debug('dupeleadlist---'+dupeleadlist);
            }
        OldOpportunitylist=[select id,name,Sales_Milestone_Search__c,Type,Service_Provider_Client__c,Accountid,Account.name,(select Product2id,Product2.Name,Product2.CSU_Driver__c from Opportunitylineitems where Product2.CSU_Driver__c=:currentRecord.CSU_Driver__c) from opportunity where StageName IN: oppStageNames and (Accountid=:currentRecord.Commercial_Account__c OR Service_Provider_Client__c=:currentRecord.Commercial_Account__c)];
        system.debug('----OldOpportunitylist----'+OldOpportunitylist);
             if(OldOpportunitylist.size()>0){
                for(Opportunity opt:OldOpportunitylist){
                    if(opt.Type=='xSP' && opt.Service_Provider_Client__c==currentRecord.Commercial_Account__c){
                       for(Opportunitylineitem opli:opt.Opportunitylineitems){
                        if(opli.product2.CSU_Driver__c==currentRecord.CSU_Driver__c){
                         DuplicateWrapper2  dupoppss= new DuplicateWrapper2();
                        dupoppss.opty=opt;
                        dupeopplist.add(dupoppss);
                        }
                    } 
                    }else if(opt.Type!='xSP' && opt.Accountid==currentRecord.Commercial_Account__c){
                         for(Opportunitylineitem opli:opt.Opportunitylineitems){
                        if(opli.product2.CSU_Driver__c==currentRecord.CSU_Driver__c){
                         DuplicateWrapper2  dupopps= new DuplicateWrapper2();
                        dupopps.opty=opt;
                        dupeopplist.add(dupopps);
                        }
                    } 
                        
                    }
                    
                    
                }
                 system.debug('dupeleadlist---'+dupeleadlist);
            }
        }
    }
  
    public class DuplicateWrapper{
        public Lead lds{get;set;}
       
        Public DuplicateWrapper(){
            
        }
        
    }
     public class DuplicateWrapper2{
        
       public Opportunity opty{get;set;}
        Public DuplicateWrapper2(){
            
        }
        
    }

  
}