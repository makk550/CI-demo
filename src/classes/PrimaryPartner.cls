public class PrimaryPartner {
    
    
    public static string accountrecordtypename;
    public static string coveragemodel;
    public static string industrydesignation;
    
    public static void updatePrimaryPartner(Set<Id> oppIds)
        
    {
        
        updateOpportunity(oppIds);
        
    }
    public static void updateOpportunity(Set<Id> oppIds){
        
        
        
        List <Opportunity> opplist=new List<Opportunity>{};
            opplist=[SELECT id,Route__c,Type,Contract_Type__c,Partner_Engagement_Phase__c,Partner_Engagement_Phase_2__c,Name,Reseller__c,
                     Distributor_6__c,AccountId,partner_1__c,Alliance_Partner_2__c,Technology_Partner__c,Account.Coverage_Model__c,
                     Account.Account_Type__c,Account.Name,Account.RecordType.Name,Reseller__r.RecordType.Name,Reseller__r.Coverage_Model__c,
                     Reseller__r.Account_Type__c, Distributor_6__r.RecordType.Name, Distributor_6__r.Coverage_Model__c,
                     Distributor_6__r.Account_Type__c,Partner_1__r.RecordType.Name, Partner_1__r.Coverage_Model__c,Partner_1__r.Account_Type__c,
                     Alliance_Partner_2__r.RecordType.Name, Alliance_Partner_2__r.Coverage_Model__c,Alliance_Partner_2__r.Account_Type__c,
                     Technology_Partner__r.RecordType.Name, Technology_Partner__r.Coverage_Model__c,Technology_Partner__r.Account_Type__c
                     from Opportunity where id in: oppIds];
        
        for(Opportunity o1:opplist)    
        {
            System.debug('*****');
            System.debug(o1.id);
            System.debug(o1.Account.id);
            //PrimaryPartner field update starts here
            if(o1.Type=='1 Tier' && o1.Reseller__c!=NULL)
            {
                system.debug('entered 1 tier and reseller not null');
                o1.PrimaryPartner4__c=o1.Reseller__c;
                accountrecordtypename = o1.Reseller__r.RecordType.Name;
                coveragemodel = o1.Reseller__r.Coverage_Model__c;
                industrydesignation = o1.Reseller__r.Account_Type__c;
            }
            else if(o1.Type=='2 Tier' && o1.Distributor_6__c!=NULL)
            {
                system.debug('entered 2 tier and Distributor not null');
                
                o1.PrimaryPartner4__c=o1.Distributor_6__c;
                accountrecordtypename = o1.Distributor_6__r.RecordType.Name;
                coveragemodel = o1.Distributor_6__r.Coverage_Model__c;
                industrydesignation = o1.Distributor_6__r.Account_Type__c;
            }
            else if((o1.Type =='xSP')||(o1.Type =='OEM'))
            {
                if(o1.AccountId!=Null)
                {
                    o1.PrimaryPartner4__c=o1.AccountId;
                    accountrecordtypename = o1.Account.RecordType.Name;
                    coveragemodel = o1.Account.Coverage_Model__c;
                    industrydesignation = o1.Account.Account_Type__c;
                }
                
            }
            
            else if((o1.Type=='Direct')&&(o1.Contract_Type__c=='MSP'))
            {
                System.debug('---entered direct and msp type');
                if(o1.AccountId!=Null)
                {
                    system.debug('--acc id is not null----'+o1.AccountID);
                    o1.PrimaryPartner4__c=o1.AccountId;
                    accountrecordtypename = o1.Account.RecordType.Name;
                    coveragemodel = o1.Account.Coverage_Model__c;
                    industrydesignation = o1.Account.Account_Type__c;
                    
                }
            }
            else if(((o1.Partner_Engagement_Phase__c!='Does not qualify' && o1.Partner_Engagement_Phase__c!='Terminated' && o1.Partner_Engagement_Phase__c!=null)||(String.isEmpty(o1.Partner_Engagement_Phase__c)))&&(o1.Partner_1__c!=null))
            {
                if(o1.Partner_1__c!=NULL)
                {
                    o1.PrimaryPartner4__c=o1.Partner_1__c;
                    accountrecordtypename = o1.Partner_1__r.RecordType.Name;
                    coveragemodel = o1.Partner_1__r.Coverage_Model__c;
                    industrydesignation = o1.Partner_1__r.Account_Type__c;
                }
                
            }
            else if(((o1.Partner_Engagement_Phase_2__c!='Does not qualify' && o1.Partner_Engagement_Phase_2__c!='Terminated' && o1.Partner_Engagement_Phase_2__c!=null)||(String.isEmpty(o1.Partner_Engagement_Phase_2__c)))&&(o1.Alliance_Partner_2__c!=null))
            {
                
                
                if(o1.Alliance_Partner_2__c!=NULL)
                {
                    
                    
                    o1.PrimaryPartner4__c=o1.Alliance_Partner_2__c;
                    accountrecordtypename = o1.Alliance_Partner_2__r.RecordType.Name;
                    coveragemodel = o1.Alliance_Partner_2__r.Coverage_Model__c;
                    industrydesignation = o1.Alliance_Partner_2__r.Account_Type__c;
                    
                }
                
            }
            else if(String.isNotBlank(o1.Technology_Partner__c))
            {
                
                if(o1.Technology_Partner__c!=NULL)
                {
                    
                    o1.PrimaryPartner4__c=o1.Technology_Partner__c;
                    accountrecordtypename = o1.Technology_Partner__r.RecordType.Name;
                    coveragemodel = o1.Technology_Partner__r.Coverage_Model__c;
                    industrydesignation = o1.Technology_Partner__r.Account_Type__c;
                    
                }
                
            }
            else
            {
                system.debug('---entered null----');
                o1.PrimaryPartner4__c=null;
                accountrecordtypename = null;
                coveragemodel = null;
                industrydesignation = null;
                
            }
            
            //Primary Partner field updation ends here
            
            system.debug('---primary partner---'+o1.PrimaryPartner4__c);
            system.debug('---accountrecordtypename---'+accountrecordtypename);
            system.debug('---coveragemodel---'+coveragemodel);
            system.debug('---industrydesignation---'+industrydesignation);
            
            
            //Route updation starts here...
            
            if((o1.Type=='1 Tier')||(o1.Type=='2 Tier')||(o1.Type =='xSP')||(o1.Type =='OEM')||(o1.Type=='Direct' && o1.Contract_Type__c=='MSP'))
            {
                System.debug('+++entered route updation+++');
                System.debug('----------'+accountrecordtypename);
                system.debug('----acc coverage model----'+o1.Account.Coverage_Model__c);
                system.debug('---acc type----'+o1.Account.Account_Type__c);
                System.debug(o1.id);
                if((accountrecordtypename!=null && accountrecordtypename =='Reseller/Distributor Account' && coveragemodel!=null && coveragemodel.endsWith('GSP'))||(accountrecordtypename!=null && accountrecordtypename =='Account Team Covered Account' && industrydesignation!=null && industrydesignation.endsWith('GPP')))
                    //if(o1.Account.Coverage_Model__c=='')
                {
                    //String s='GSP';
                    
                    o1.Route__c='GSP';
                    
                    
                }
                else if((accountrecordtypename!=null && accountrecordtypename =='Reseller/Distributor Account' && coveragemodel!=null && coveragemodel.endsWith('GSI'))||(accountrecordtypename!=null && accountrecordtypename =='Account Team Covered Account' && industrydesignation!=null && industrydesignation.endsWith('GSI'))||(accountrecordtypename!=null && accountrecordtypename =='Account Team Covered Account' && industrydesignation!=null && industrydesignation.endsWith('ISI')))
                {
                    
                    
                    o1.Route__c='GSI';
                    //break;
                    
                }
                else if((o1.Type=='1 Tier')||(o1.Type=='2 Tier'))
                {
                    system.debug('---entered route 1/2 tier-----');
                    o1.Route__c='Resell';
                    
                    
                }
                else
                {
                    
                    o1.Route__c='MSP';
                    
                }
                
            }
            else
            {
                system.debug('---entered direct----');
                o1.Route__c='Direct';
                
            }
            
            
            
            
            
            
            system.debug('Primary Partner-----------'+o1.PrimaryPartner4__c);
            system.debug('Route__c-----------'+o1.Route__c);  
            //Route updation ends here...  
        }
        System.debug('***updation finished****');
        shouldIRun.stopTrigger();
        
        
        
        update opplist;
        //Database.SaveResult[] result = Database.update(opplist, false);
        
        
    }
    
}