public class EBCFormExt {

    public Account_Visit__c EBCVisit{get;set;}
    public string ebcID {set; get;}
    public string companyID {set; get;}
    public string contactIds {set; get;}
    public string selectedOpps {set; get;}
    public string selectedAttendees {set; get;}

    public EBCFormExt(ApexPages.StandardController controller) {
        this.EBCVisit = (Account_Visit__c)controller.getRecord();
    }
    
    public PageReference initForm()
    {
        ebcID = ApexPages.currentPage().getParameters().get('id');
        companyID = ApexPages.currentPage().getParameters().get('AccountId');
        selectedOpps = ApexPages.currentPage().getParameters().get('selectedOpps');
        setTheFormValues();
        return null;
    
    }

    public void setTheFormValues(){
        if(ebcID==null){
            EBCVisit = new Account_Visit__c();
            EBCVisit.Requestor_Name__c = userinfo.getUserId();
            EBCVisit.Company_Name__c = companyID;
            EBCVisit.Opp_Ids__c = selectedOpps;
            //EBCVisit.Senior_customer_title__c = 'CEO';
        }else{
            EBCVisit = [select Requestor_Name__c,Company_Name__c,Opp_Ids__c,Customer_Attendees__c,total_attendees__c,Visit_Objective__c,
            Additional_Information__c,Senior_customer_title__c,Other_title__c,Visit1Location__c,Visit2Location__c,Visit1From__c,Visit2From__c,
            Visit1To__c,Visit2To__c,contactIds__c from Account_Visit__c where id=:ebcID];
            
            Schema.DescribeFieldResult F = Account_Visit__c.Senior_customer_title__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();

           System.debug('adsfdsf --> '  + P );

            if(EBCVisit!=null){
                 
                Senior_customer = EBCVisit.Senior_customer_title__c;     
                selectedAttendees = EBCVisit.Customer_Attendees__c;
                companyID = EBCVisit.Company_Name__c;
            } 
        }
    }

    private String Senior_customer = null;
    public String getSenior_customer() {
        return Senior_customer;
    }
    
    public void setSenior_customer(String Senior_customer) {
        this.Senior_customer = Senior_customer;
    }

     public List<SelectOption> getSenior_customers() {
        List<selectOption> options = new List<selectOption>();         
        Schema.DescribeFieldResult field = Schema.sObjectType.Account_Visit__c.fields.Senior_customer_title__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) {
            if(p.isDefaultValue() && getSenior_customer() == null) {
                setSenior_customer(p.getLabel());
            }
            SelectOption so = new Selectoption(p.getLabel(), p.getLabel());
            options.add(so);
        } 
        System.debug('Options size ' +options.size());
        return options;
    }

    public PageReference save(){
        System.debug('EBCVisit.contactIds__c: ' + EBCVisit.contactIds__c);
       try{
            selectedAttendees = EBCVisit.Customer_Attendees__c;
            EBCVisit.Senior_customer_title__c     = Senior_customer; 
            upsert EBCVisit;
            PageReference acctPage = new ApexPages.StandardController(EBCVisit).view();
            acctPage.setRedirect(true);
            return acctPage;
         }
        catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
            // Process exception here
            System.debug(e.getDmlMessage(i));
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(i));
            ApexPages.addMessage(msg);
            return null;
            }
        }    
      return null;
    }

    @isTest(SeeAllData=true)
    static void testEBCForm() {
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        Account acc2 = new Account(Name='Test_Acc1',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert acc2;                
        Opportunity opp = new Opportunity(AccountId=acc2.Id,Reseller__c=acc2.Id,Name='Opp',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);        
        insert opp;        
        Opportunity opp2 = new Opportunity(AccountId=acc2.Id,Reseller__c=acc2.Id,Name='Opp2',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);        
        insert opp2;   
        Account_Visit__c ac = new Account_Visit__c(Visit1From__c = Date.Today(), Customer_Attendees__c = 'testtestsetsetsetse', Company_Name__c = acc2.id,Opp_Ids__c= (opp.id+':' + '12345'+'='+opp2.id+':' + '12345'));
        insert ac;     
     
        Account_Visit__c theAcc = [select Company_Name__c, Requestor_Name__c, Visit_Objective__c, Visit1Location__c, total_attendees__c, Senior_customer_title__c, Opp_Ids__c from Account_Visit__c where Company_Name__c!=null limit 1];
/*      
        Account_Visit__c theAcc = new Account_Visit__c();
        theAcc.Company_Name__c = [select id from account limit 1].id;
        theAcc.Requestor_Name__c = Userinfo.getUserId();
        theAcc.Visit_Objective__c = 'Strengthen partnership';
        theAcc.Visit1Location__c = 'Islandia';
        theAcc.total_attendees__c = 2;
        theAcc.Senior_customer_title__c = 'CTO';
        string strOppId = [select id from opportunity limit 1].id;
        theAcc.Opp_Ids__c = strOppId + ':01234567=';
*/              
       if(theAcc!=null ){  
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = theAcc.Company_Name__c;
        atm.UserId = Userinfo.getUserId();
        atm.TeamMemberRole='CSA';
        insert atm;
                  
        //insert theAcc;
                  
        ApexPages.StandardController QController = new ApexPages.StandardController(theAcc);
        EBCFormExt qe = new EBCFormExt(QController);
        qe.ebcID = theAcc.Id;
        //qe.companyID = theAcc.Company_Name__c;
        qe.selectedOpps = '';
        qe.setTheFormValues();
        qe.initForm();
        qe.save();
       }
    }
}