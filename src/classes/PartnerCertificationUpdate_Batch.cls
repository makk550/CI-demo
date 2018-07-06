global class PartnerCertificationUpdate_Batch implements Database.Batchable<sObject>, Database.Stateful
{
    public string query;
    list<BPWrapper> wraplist = new  List<BPWrapper>();
    list<BPWrapper> Finalwraplist = new  List<BPWrapper>();
    // this method is used to get all records that will be processed by execute method
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        query = 'SELECT Id, BP_Solutions__c, Contact__c, Resource_Type__c, Contact_Email__c, Certification_Level__c, Approved__c, Product_Group__c FROM BP_Training_Contact__c';
        // Return all the records from BP_Training_Contact__c - query is set in the calling method
        return Database.getQueryLocator(query);
    }
    // start
    // execute Method 
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        set<id> BP_SolutionsIdSet = new  set<id>();
        set<id> setBPAccountIds = new  set<id>();
        set<string> Fysicalyear = new  set<string>();
        set<string> resourcetyp = new  set<string>();
        list<BP_Training_Contact__c> bptclist = new  list<BP_Training_Contact__c>();
        Map<string, string> LPACProductMAP = new  Map<string, string>();
        List<LPACCertificateData__c> LPACProductData = LPACCertificateData__c.getall().values();
        if(LPACProductData.size() > 0)
        {
            for(LPACCertificateData__c Pro: LPACProductData)
            {
                if(!LPACProductMAP.containsKey(Pro.SFDC_Product_Group__c))
                {
                    LPACProductMAP.put(Pro.SFDC_Product_Group__c, Pro.LPAC_Focus_Product__c);
                }
            }
        }
        system.debug('LPACProductMAP---------' + LPACProductMAP);
        for(Sobject s: scope)
        {
            BP_Training_Contact__c bpo = (BP_Training_Contact__c)s;
            BP_SolutionsIdSet.add(bpo.BP_Solutions__c);
            BPWrapper bp = new  BPWrapper();
            bp.BP_TrainingContactId = bpo.id;
            bp.BP_SolutionsId = bpo.BP_Solutions__c;
            bp.ResourceType = bpo.Resource_Type__c;
            bp.Productgroup = bpo.Product_Group__c;
            bp.ContactID_Bptc = bpo.Contact__c;
            resourcetyp.add(bp.ResourceType);
            wraplist.add(bp);
        }
        system.debug('BP_SolutionsIdSet==========' + BP_SolutionsIdSet);
        system.debug('wraplist===initial=====' + wraplist);
        system.debug('BP_SolutionsIdSet===============' + BP_SolutionsIdSet);
        Map<id, BP_Solutions__c> BpsolutionMap = new  Map<id, BP_Solutions__c>();
        Map<string, string> FysicalyearMap = new  Map<string, string>();
        for(BP_Solutions__c Bs: [SELECT
            id, 
            Business_Plan__c, 
            Business_Plan__r.Account__c, 
            Business_Plan__r.Plan_Fiscal_Year__c
        FROM
            BP_Solutions__c
        WHERE
            id  in: BP_SolutionsIdSet])
        {
            BpsolutionMap.put(Bs.id, Bs);
        }
        system.debug('BpsolutionMap===========' + BpsolutionMap);
        if(wraplist.size() > 0)
        {
            for(BPWrapper bw: wraplist)
            {
                if(BpsolutionMap.ContainsKey(bw.BP_SolutionsId))
                {
                    bw.Plan_FiscalYearBP = BpsolutionMap.get(bw.BP_SolutionsId).Business_Plan__r.Plan_Fiscal_Year__c.removeStart('FY ');
                    bw.BpAccountid = BpsolutionMap.get(bw.BP_SolutionsId).Business_Plan__r.Account__c;
                    setBPAccountIds.add(bw.BpAccountid);
                    Fysicalyear.add(bw.Plan_FiscalYearBP.removeStart('FY '));
                    Finalwraplist.add(bw);
                }
            }
        }
        system.debug('Finalwraplist=====' + Finalwraplist);
        boolean bNeedsSave = false;
        Map<id, BP_Training_Contact__c> NewBPTCMap = new  Map<id, BP_Training_Contact__c>();
        for(pp_calculated_certification__x ppCalCertObject: [SELECT
            Id, 
            badge__c, 
            fiscal_year__c, 
            product_name__c, 
            resource_type__c, 
            account_id__c, 
            IdContact__c
        FROM
            pp_calculated_certification__x
        WHERE
            account_id__c  in: setBPAccountIds  AND  fiscal_year__c  in: Fysicalyear])
        {
            system.debug('fiscal_year__c------------' + ppCalCertObject.fiscal_year__c);
            system.debug('In External Object For Loop 1');
            for(BPWrapper bw: Finalwraplist)
            {
                if(!NewBPTCMap.ContainsKey(bw.BP_TrainingContactId))
                {
                    system.debug('In External Object For Loop 2');
                    if(ppCalCertObject.account_id__c == bw.BpAccountid)
                    {
                        system.debug('In External Object IF 1');
                        if(ppCalCertObject.fiscal_year__c == bw.Plan_FiscalYearBP                                       && 
                           (LPACProductMAP.containsKey(ppCalCertObject.product_name__c) && 
                            (LPACProductMAP.get(ppCalCertObject.product_name__c) == ppCalCertObject.product_name__c || 
                             ppCalCertObject.product_name__c == bw.Productgroup))                                       && 
                           ppCalCertObject.resource_type__c == bw.ResourceType                                          && 
                           ppCalCertObject.IdContact__c == bw.ContactID_Bptc)
                        {
                            system.debug('In External Object IF 2');
                            BP_Training_Contact__c bptco = new  BP_Training_Contact__c();
                            bptco.Id = (Id)bw.BP_TrainingContactId;
                            bptco.Certification_Level__c = ppCalCertObject.badge__c;
                            bNeedsSave = true;
                            bptclist.add(bptco);
                            NewBPTCMap.put(bptco.id, bptco);
                            break;
                        }
                    }
                }
            }
        }
        system.debug('bptclist-------------' + bptclist);
        if(bNeedsSave == true && bptclist.size() > 0)
        {
            system.debug('Saving bptclist');
            try
            {
                Database.upsert(bptclist);
            }
            catch (System.DmlException e)
            {
                System.debug('Fail to save the updated BP Training Contacts in PartnerCertificationUpdate_Batch. ' + e.getMessage());
            }
        }
    }
    //Execute Method End
    global void finish(Database.BatchableContext info)
    {
    }
    // finish
    public class BPWrapper
    {
        public id BP_TrainingContactId{get;set;}
        public id BP_SolutionsId {get;set;}
        public string Plan_FiscalYearBP{get;set;}
        public string ResourceType{get;set;}
        public string Productgroup{get;set;}
        public id BpAccountid{get;set;}
        public id ContactID_Bptc{get;set;}
        public BPWrapper()
        {
        }
    }
}