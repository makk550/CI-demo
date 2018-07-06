public class printOpportunityGridController {

        public string planId {set; get;}
        public string selectedIds {set; get;}
        public string incOverview {set; get;}
        public string AccountId {set; get;}
        public List<OpportunityGridBean> lstOpportunityGrid;
        private List<Opportunity> openOpps {set; get;}
        private List<OpportunityLineItem> lineItems  {set; get;}
        private List<CA_License__c> caLicenses  {set; get;}
        private Opportunity_Plan__c plan;
        public list<Opportunity_Plan_Detail__c> upcomingOpps {set; get;}
        public string EntId;
        
        public printOpportunityGridController(){
                planId = ApexPages.currentPage().getParameters().get('planId');
                selectedIds = ApexPages.currentPage().getParameters().get('selectedIds');
                incOverview = ApexPages.currentPage().getParameters().get('incOverview');
                AccountId = ApexPages.currentPage().getParameters().get('AccountId');
                EntId = [Select Enterprise_id__c from Account where id = : accountid].Enterprise_id__c;
                initOppGrid();
                
        }

        public List<OpportunityGridBean> getlstOpportunityGrid(){
                return lstOpportunityGrid;
        }

        private void initAllLists(){
                
               string lim = '';
               if(SystemIdUtility.isTest ==true) lim = 'limit 10';
                
                openOpps = Database.query('Select Id from Opportunity where ( AccountId=\'' + AccountId + '\' or Account.parentId=\'' + AccountId + '\' or  Account.Enterprise_id__c=\'' + EntId + '\' ) and IsClosed=false ' + lim );
                

                lineItems = Database.query('Select Opportunity.AccountId,PricebookEntry.Product2.Solution_Sets__c      From OpportunityLineItem ' +
                                       ' where ( Opportunity.AccountId=\'' + AccountId + '\' or Opportunity.Account.parentId=\'' + AccountId + '\' or  Opportunity.Account.Enterprise_id__c=\'' + EntId + '\' ) and Opportunity.IsClosed=false ' + lim );
                caLicenses = Database.query('Select Site_ID__c, Material_Code__c, Contract_Number__c, Contract_Version__c, ' +
                   ' Support_Version__c, Contract_Start__c, Contract_End__c, ' +
                   ' License_Type__c,Renewal_Date__c, Quantity__c, Purchase_Price__c, Purchase_Date__c, Product_Version__c, Product_Name__c, ' +
                                       ' Opportunity_Plan_Detail__r.Opportunity_Plan__c, Opportunity_Plan_Detail__c, Operation_System__c, Name, NCV_Driver__c, '+
                                       ' Material_ID__c, Latest_Version__c, Latest_Product_Version__c,Opportunity_Plan_Detail__r.Opportunity_Plan__r.Account__c ' +
                                       ' From CA_License__c where Opportunity_Plan_Detail__r.Opportunity_Plan__r.Account__c=\'' + AccountId + '\' ' + lim );
               
            initOpenOppsCount();
        }
        
        public void initOppGrid(){

                //String[] arrSelectedIds = selectedIds.split(':');

                upcomingOpps = [Select Opportunity_Plan__r.Account__c, Supporter_Contact2__c, Supporter_Contact2__r.Name, Supporter_Contact1__c, 
                Supporter_Contact1__r.Name,     Renewal_Date_2__c, Renewal_Date_1__c, Opportunity__c, Opportunity_Question_1__c, Opportunity_Plan__c, Name, 
                NCV_Driver_Info__r.NCV_Driver__c, NCV_Driver_Info__c, NCV_Driver_Info__r.Business_Unit__c, Id, Detractor_Contact2__c, 
                Detractor_Contact2__r.Name,Detractor_Contact1__c,Detractor_Contact1__r.Name, Competitor__c, Competitor_Question_2__c, 
                Competitor_Question_1__c, Competitor_Name_2__c, Competitor_Name_1__c, Competitor_License2__c, Competitor_License1__c, 
                CA_License_Question_3__c, CA_License_Question_2__c, CA_License_Question_1__c, CA_License_Key_Contact__c,CA_License_Key_Contact__r.Name,
                Competitor_Product1__c, Competitor_Product2__c 
                From Opportunity_Plan_Detail__c where Opportunity_Plan__c=:planId and isdeleted=false and NCV_Driver_Info__r.Is_Active__c = true 
                order by NCV_Driver_Info__r.BU_Sort_Order__c];

                initAllLists();

                lstOpportunityGrid = new List<OpportunityGridBean>();
                integer OpenOppsCount = 0;
                for(Opportunity_Plan_Detail__c pd:upcomingOpps){
                        OpportunityGridBean bean =  new OpportunityGridBean(pd,openOpps,lineItems,caLicenses);

                        if(uniqueOpps.containsKey(pd.NCV_Driver_Info__r.NCV_Driver__c.toUpperCase())){
                            String oppIdstmp = uniqueOpps.get(pd.NCV_Driver_Info__r.NCV_Driver__c.toUpperCase());
                            if(oppIdstmp!=null){
                                String[] oppIds = oppIdstmp.split(',');
                                if(oppIds!=null){
                                    bean.OpenOppsCount = oppIds.size();
                                }
                            }
                        }else{
                            bean.OpenOppsCount = 0;
                        }
            
                        if(bean.OpenOppsCount>0)
                            bean.Opportunity = 'Yes';
                        else
                            bean.Opportunity = 'No';

                        lstOpportunityGrid.add(bean);
                }               
        }

    Map<String,String> uniqueOpps = new Map<String,String>();
    private void initOpenOppsCount(){
        string NCVDriver = '';
        Integer OpenOppsCount = 0;
        string strOppId = '';
        string strKey = '';
        string strValue = '';
        string strValueTmp = '';
        for(OpportunityLineItem LineItem:lineItems){
            NCVDriver  = LineItem.PricebookEntry.Product2.Solution_Sets__c;
            strOppId = LineItem.OpportunityId;
            strKey = NCVDriver.toUpperCase();
            strValue = strOppId;
            if(!uniqueOpps.containsKey(strKey)){
                uniqueOpps.put(strKey, strValue);
            }else{
                strValueTmp = uniqueOpps.get(strKey);
                if(!strValueTmp.contains(strValue)){
                    strValue = strValue + ', ' + strValueTmp;
                    uniqueOpps.put(strKey, strValue);
                }
            }
        }
    }
    

    static testMethod void testprintOpportunityGridController() {
        SystemIdUtility.isTest = true;
        
        //Account acc = [select id,Name from account limit 1];
        RecordType[] recacc = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name in ('Account Team Covered Account')];//('Reseller/Distributor Account','CA Enterprise Account')];
        Account acc = new Account(Name='TestAcc1',Geo__c='NA',RecordTypeId=recacc[0].Id,Enterprise_Id__c='NAACC001',Enterprise_Account_Name__c='EAcc',Customer_Category__c='Reseller',Commercial_ID__c =   '12',Commercial_Account_Name__c = 'caName');
        
        insert acc;
         ApexPages.currentPage().getParameters().put('AccountId', acc.id);
        Opportunity_Plan__c newPlan = new Opportunity_Plan__c();
        newPlan.Account__c = acc.Id;
        newPlan.Name = acc.Name;
        insert newPlan;
        
        NCV_Driver_Info__c driver  =  new NCV_Driver_Info__c();
        driver.NCV_Driver__c = 'Autosystest';
        driver.Business_Unit__c = 'Automation';
        insert driver;
                
        Opportunity_Plan_Detail__c opd = new Opportunity_Plan_Detail__c();
        opd.NCV_Driver_Info__c = driver.id;
        opd.Opportunity_Plan__c = newPlan.Id;
        opd.Competitor_Question_1__c = '1';
        opd.Competitor_Name_1__c = 'sample';
        insert opd;
        
        printOpportunityGridController qe = new printOpportunityGridController();
        qe.planId = newPlan.Id;
        qe.AccountId = acc.Id;
        //qe.selectedIds = '000000000000000000:000000000000000000';
        qe.initOppGrid();
        
        qe.getlstOpportunityGrid();
    }

}