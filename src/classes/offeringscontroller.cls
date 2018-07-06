public class offeringscontroller
{
    public List<support_class> lst_supp {get;set;}
    public List<education_class> lst_edu {get;set;}
    public List<service_class> lst_serv {get;set;}
    public List<SelectOption> selproduct {get;set;}
    public List<SelectOption> selproductedu {get;set;}
    public List<SelectOption> selbu {get;set;}
    public List<SelectOption> selbu_services {get;set;}
    public List<SelectOption> selbu_Education {get;set;}
    public List<SelectOption> selbu_Support {get;set;}
    //public List<SelectOption> selserviceproducts {get;set;}
    
    private List<OpportunityLineItem> lstoppoli = new List<OpportunityLineItem>();
    private Map<Id,Product2> prdmap;
    
    //US432559 - BAJPI01 - remove JS Button functionality to VF pages.
    @TestVisible Private Boolean showNoTerritoryMessage;
    
    public Boolean renderPageBlock{get;set;}
    //US432559 - BAJPI01 - remove JS Button functionality to VF pages.
     
    public String currdate {get;set;}
    public Id oppId {get;set;}       // fy13
    public String oppName {get;set;} // fy13
    
    private String strOppId = '';
    private String strpricebookid = '';
    private String strcurrencyisocode = '';
    private Opportunity opp = new Opportunity();
    private RecordType rec = new RecordType();
    public List<SelectOption> selbustype {get;set;}
    public Boolean showsupportwinloss {get;set;}
    public Integer edusize {get;set;}
    public Integer servsize {get;set;}
    public Boolean alert {get;set;} //allha02 3576
    
    public offeringscontroller(ApexPages.Standardcontroller stdcontroller)
    {
        //get opportunity id
        alert=false; // allha02 3576
        showsupportwinloss = false;
        renderPageBlock = true;
        showNoTerritoryMessage =false;
        strOppId = ApexPages.currentPage().getParameters().get('oppid');
        lstoppoli = [select Contract_Length__c,Id,OpportunityId,Business_Type__c,Offerings_Family__c,Stretch__c,partner_sales_price__c,Drawdown_from_Prepaid_Funds__c,UnitPrice,PricebookEntry.Product2Id from OpportunityLineItem where OpportunityId=:strOppId order by createddate asc];
        opp = [select Name,StageName,CurrencyISOCode,Probability,ForecastCategory,Rpt_Territory_Country__c,RecordType.Name from Opportunity where Id =: strOppId];
        String[] stroppmilestonesplit = opp.StageName.split('%');
        oppId = opp.Id;     // fy13
        oppName = opp.Name; // fy13
        
	//US432559 - BAJPI01 - remove JS Button functionality to VF pages.
         if(opp.RecordType.Name=='New Opportunity' && String.isBlank(opp.Rpt_Territory_Country__c)){
            renderPageBlock = false;
            showNoTerritoryMessage = true;
        }
        if(showNoTerritoryMessage==true){
             ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Offerings cannot be added until a Territory is assigned.'));
        }
        //US432559 - BAJPI01 - remove JS Button functionality to VF pages.
	
        
        if((opp.StageName.indexOf('%')>0 && Decimal.valueOf(stroppmilestonesplit[0])==100) || opp.StageName == Label.Opp_Stage_Closed_Lost)
            showsupportwinloss = true;
            
        lst_supp = new List<support_class>();
        lst_edu = new List<education_class>();
        lst_serv = new List<service_class>();
        fetchBU();
        fetchbusinesstype();
        if(lstoppoli.size()>0)
        {
            Set<ID> prdids = new Set<ID>();
            for(Integer i=0;i<lstoppoli.size();i++)
            {
                prdids.add(lstoppoli[i].PricebookEntry.Product2Id);
            }
            if(prdids.size()>0)
            {
                //get the product details
                prdmap = new Map<Id,Product2>([select Id,Family,Market_Focus_Area__c from Product2 where Salesforce_CPQ_Product__c=false and Id in:prdids and Family in ('Services','Education','Support') and Market_Focus_Area__c != null]);
                if(prdmap != null)
                {
                    Integer servicecount = 0;
                    Integer educationcount = 0;
                    Integer supportcount = 0;
                    //show existing services/education/support lineitem details
                    for(Integer k=0;k<lstoppoli.size();k++)
                    {
                        if(prdmap.containsKey(lstoppoli[k].PricebookEntry.Product2Id))
                        {
                            Product2 p = prdmap.get(lstoppoli[k].PricebookEntry.Product2Id);
                            
                            if(p.Family == 'Services')
                            {
                                service_class serv = new service_class();
                                serv.opplineitem = lstoppoli[k];
                                serv.position = servicecount;
                                serv.strbu = p.Market_Focus_Area__c;
                                serv.strproduct = lstoppoli[k].PricebookEntry.Product2Id;
                                serv.isBUDisabled = true;
                                serv.isPrdDisabled = true;
                                lst_serv.add(serv);
                                
                                prdbu = p.Market_Focus_Area__c;
                                prdpos = servicecount;
                                prdfamily = p.Family;
                                //fetchserviceproducts();
                                fetchproducts();
                                servicecount += 1;
                            }
                            if(p.Family == 'Education')
                            {
                                education_class edu = new education_class();
                                edu.oppline = lstoppoli[k];
                                edu.position = educationcount;
                                edu.strbu = p.Market_Focus_Area__c;
                                edu.strproduct = lstoppoli[k].PricebookEntry.Product2Id;
                                edu.isBUDisabled = true;
                                edu.isPrdDisabled = true;
                                lst_edu.add(edu);
                                
                                prdbu = p.Market_Focus_Area__c;
                                prdpos = educationcount;
                                prdfamily = p.Family;
                                //fetchserviceproducts();
                                fetchproducts();
                                educationcount += 1;
                            }
                            if(p.Family == 'Support')
                            {
                                support_class supp = new support_class();
                                supp.oppli = lstoppoli[k];
                                supp.position = supportcount;
                                supp.strbu = p.Market_Focus_Area__c;
                                supp.strproduct = lstoppoli[k].PricebookEntry.Product2Id;
                                supp.isBUDisabled = true;
                                supp.isPrdDisabled = true;
                                supp.strbustype = lstoppoli[k].Business_Type__c;
                                lst_supp.add(supp);
                                
                                prdbu = p.Market_Focus_Area__c;
                                prdpos = supportcount;
                                prdfamily = p.Family;
                                //fetchserviceproducts();
                                fetchproducts();
                                supportcount += 1;
                            }
                        }
                    }
                }
            }
        }
        
        //fetchSupportProducts();
        //fetchEducationProducts();
        //fetchBU();
        
        //need to show 3 rows by default for each offering type.
        //incase existing lineitems are less than 3, append the remaining rows.
        if(lst_serv.size()<3)
        {
            Integer cnt = lst_serv.size();
            Integer linespadding = 3 - cnt;
            for(Integer i=0;i<linespadding;i++)
            {
                service_class serv = new service_class();
                OpportunityLineItem tempolineitem = new OpportunityLineItem();
                serv.opplineitem = tempolineitem;
                serv.position = cnt+i;
                serv.isBUDisabled = false;
                serv.isPrdDisabled = false;
                lst_serv.add(serv);
             
            }
        }
        else
        {// incase the existing lineitem count is equal or greater than 3, just append an addition blank row
            service_class serv = new service_class();
            OpportunityLineItem tempolineitem = new OpportunityLineItem();
            serv.opplineitem = tempolineitem;
            serv.position = lst_serv.size();
            serv.isBUDisabled = false;
            serv.isPrdDisabled = false;
            lst_serv.add(serv);
        }
        //same as above
        if(lst_edu.size()<3)
        {
            Integer cnt = lst_edu.size();
            Integer linespadding = 3 - cnt;
            for(Integer i=0;i<linespadding;i++)
            {
                education_class edu = new education_class();
                OpportunityLineItem tempolineitem = new OpportunityLineItem();
                edu.oppline = tempolineitem;
                edu.position = cnt+i;
                edu.isBUDisabled = false;
                edu.isPrdDisabled = false;
                lst_edu.add(edu);
             
            }
        }
        else
        {
            education_class edu = new education_class();
            OpportunityLineItem tempolineitem = new OpportunityLineItem();
            edu.oppline = tempolineitem;
            edu.position = lst_edu.size();
            edu.isBUDisabled = false;
            edu.isPrdDisabled = false;
            lst_edu.add(edu);
        }
        //same as for services
        if(lst_supp.size()<3)
        {
            Integer cnt = lst_supp.size();
            Integer linespadding = 3 - cnt;
            for(Integer i=0;i<linespadding;i++)
            {
                support_class supp = new support_class();
                OpportunityLineItem tempolineitem = new OpportunityLineItem();
                
                supp.oppli = tempolineitem;
                supp.position = cnt+i;
                supp.isBUDisabled = false;
                supp.isPrdDisabled = false;
                lst_supp.add(supp);
             
            }
        }
        else
        {
            support_class supp = new support_class();
            OpportunityLineItem tempolineitem = new OpportunityLineItem();
            
            supp.oppli = tempolineitem;
            supp.position = lst_supp.size();
            supp.isBUDisabled = false;
            supp.isPrdDisabled = false;
            lst_supp.add(supp);
        }
        
        currdate = System.today().format();
        
        strcurrencyisocode = opp.CurrencyIsoCode;
        //strpricebookid = opp.Pricebook2Id;
        try{
        Pricebook2 pbe = new Pricebook2();
        pbe = [select Id from Pricebook2 where Name='CA Product List' and IsActive=true];
        if(pbe!=null)
            strpricebookid = pbe.Id;
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        rec = [select Id from RecordType where SObjectType='Opportunity' and IsActive=true and Name='New Opportunity'];
        edusize = lst_edu.size();
        servsize = lst_serv.size();
    } 
    public void fetchbusinesstype()
    {
        selbustype = new List<SelectOption>();
        selbustype.add(new SelectOption('--Select--','--Select--'));
        
        Schema.DescribeFieldResult bustypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
        for(Schema.PicklistEntry entry : bustypevalues.getPicklistValues())
        {
            if(entry.getValue() == 'New' || entry.getValue() == 'Time' || entry.getValue() == 'Capacity' || entry.getValue() == 'Maintenance')
                selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
            
        }
        
    }
    //create wrapper class for support/education and services
    public class support_class
    {
        public String strproduct {get;set;}
        public String strbustype {get;set;}
        public OpportunityLineItem oppli {get;set;}
        public String strbu {get;set;}
        public List<SelectOption> selproductsupp {get;set;}
        public Boolean isBUDisabled {get;set;}
        public Boolean isPrdDisabled {get;set;}
        public Integer position {get;set;}
        
    }
    public class education_class
    {
        public String strproduct {get;set;}
        public OpportunityLineItem oppline {get;set;}
        public String strbu {get;set;}
        public List<SelectOption> selproductedu {get;set;}
        public Boolean isBUDisabled {get;set;}
        public Boolean isPrdDisabled {get;set;}
        public Integer position {get;set;}
        //public Boolean showwinloss {get;set;}
    }
    public class service_class
    {
        public String strbu {get;set;}
        public Integer position {get;set;}
        public List<SelectOption> selproductserv {get;set;}
        public String strproduct {get;set;}
        public OpportunityLineItem opplineitem {get;set;}
        public Boolean isBUDisabled {get;set;}
        public Boolean isPrdDisabled {get;set;}
        
    }
    
    public void fetchBU()
    {
        List<Product2> lstprd = new List<Product2>();
        //lstprd = [select Id,Name from Product2 where Family='Education' and isDeleted = false and isActive = true order by name];
        lstprd = [select Market_Focus_Area__c,Family from Product2 where Salesforce_CPQ_Product__c=false and Family in('Services','Education','Support') and Market_Focus_Area__c != null  and isDeleted = false and isActive = true order by Market_Focus_Area__c];
        selbu = new List<SelectOption>();
        selbu.add(new SelectOption('--Select--','--Select--'));
        selbu_services = new List<SelectOption>();
        selbu_services.add(new SelectOption('--Select--','--Select--'));
        selbu_Education = new List<SelectOption>();
        selbu_Education.add(new SelectOption('--Select--','--Select--'));
        selbu_Support = new List<SelectOption>();
        selbu_Support.add(new SelectOption('--Select--','--Select--'));

        Set<String> setcheckbu = new Set<String>();
        Set<String> setcheckbu_Services = new Set<String>();
        Set<String> setcheckbu_Education = new Set<String>();
        Set<String> setcheckbu_Support = new Set<String>();
        for(Product2 prd : lstprd){
            if(prd.Market_Focus_Area__c != 'ISBU' && prd.Market_Focus_Area__c != 'RMDM')
            {
                if(!setcheckbu_Services.contains(prd.Market_Focus_Area__c) && prd.Family == 'Services')
                {
                    selbu_services.add(new SelectOption(prd.Market_Focus_Area__c,prd.Market_Focus_Area__c));
                    setcheckbu_Services.add(prd.Market_Focus_Area__c);
                }
                if(!setcheckbu_Education.contains(prd.Market_Focus_Area__c)  && prd.Family == 'Education')
                {
                    selbu_Education.add(new SelectOption(prd.Market_Focus_Area__c,prd.Market_Focus_Area__c));
                    setcheckbu_Education.add(prd.Market_Focus_Area__c);
                }
                if(!setcheckbu_Support.contains(prd.Market_Focus_Area__c)   && prd.Family == 'Support')
                {
                    selbu_Support.add(new SelectOption(prd.Market_Focus_Area__c,prd.Market_Focus_Area__c));
                    setcheckbu_Support.add(prd.Market_Focus_Area__c);
                }
            }
             
        }
    }
    //add an additional blank row to the table
    public PageReference addmore_supp()
    {
        support_class supp = new support_class();
        OpportunityLineItem tempoli = new OpportunityLineItem(); 
        
        supp.oppli = tempoli;
        supp.position = lst_supp.size();
        lst_supp.add(supp);
        return null; 
    }
    //add an additional blank row to the table
    public PageReference addmore_edu()
    {
        education_class edu = new education_class();
        OpportunityLineItem tempoline = new OpportunityLineItem(); 
        edu.oppline = tempoline;
        edu.position = lst_edu.size();
        lst_edu.add(edu);
        edusize = lst_edu.size();
        return null; 
    }
    //add an additional blank row to the table
    public PageReference addmore_serv()
    {
        service_class serv = new service_class();
        OpportunityLineItem tempolineitem = new OpportunityLineItem(); 
        serv.opplineitem = tempolineitem;
        serv.position = lst_serv.size();
        lst_serv.add(serv);
        servsize = lst_serv.size();
        return null; 
    }
    public PageReference saveproducts()
    {
         alert = false ; //allha02 
        List<OpportunityLineItem> ins_lineitem = new list<OpportunityLineItem>();
        Set<String> prdid = new Set<String>();
        for(Integer j=0;j<lst_supp.size();j++)
        {
            if(lst_supp[j].strproduct!='--Select--' && lst_supp[j].strproduct!=null)
                prdid.add(lst_supp[j].strproduct);
        }
        for(Integer k=0;k<lst_edu.size();k++)
        {
            if(lst_edu[k].strproduct!='--Select--' && lst_edu[k].strproduct!=null)
                prdid.add(lst_edu[k].strproduct);
        }
        for(Integer l=0;l<lst_serv.size();l++)
        {
            if(lst_serv[l].strproduct!='--Select--' && lst_serv[l].strproduct!=null)
                prdid.add(lst_serv[l].strproduct);
        }
        //get the pricebookentry details for each offering
        List<PricebookEntry> pbe = new List<PricebookEntry>(); 
        pbe = [Select Id,Product2Id from PricebookEntry Where IsActive=true and Pricebook2Id=: strpricebookid and Product2Id in: prdid and CurrencyISOCode =:strcurrencyisocode];
        
        //map the data for saving
        for(Integer i=0;i<lst_supp.size();i++)
        {
            //proceed to save only if the BU is selected
            if(lst_supp[i].strbu!='--Select--' && lst_supp[i].strbu!=null)
            {
                //If BU is selected, then all other line item details need to be completed.
                if(lst_supp[i].strproduct != '--Select--' && lst_supp[i].strbustype != '--Select--' && lst_supp[i].oppli.UnitPrice != null && lst_supp[i].oppli.Contract_Length__c !=null )
                {
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli = lst_supp[i].oppli;
                    
                    //oli.Probability__c = opp.Probability;
                    //oli.Forecast_Category__c = opp.ForecastCategory;
                    
                    //UPDATING FORECAST CATEGORY
                    //ADDED BY AFZAL FOR CR # 189381545 
                    /*if(oli.Probability__c!=null){ 
                        if(oli.Probability__c<=50)
                            oli.Forecast_Category__c = 'Pipeline';
                        else if(oli.Probability__c ==70)
                            oli.Forecast_Category__c = 'Best Case';
                        else if(oli.Probability__c==90)
                            oli.Forecast_Category__c = 'Commit';
                        else if(oli.Probability__c==100)
                            oli.Forecast_Category__c = 'Closed';
                        else
                            oli.Forecast_Category__c = 'Closed';
                    }*/
                    //
                    
                        //oli.Won_line_item__c = false;
                        //oli.Closed_line_item__c = false;
                    
                    oli.Business_Type__c = lst_supp[i].strbustype;
          oli.Offerings_Family__c = 'Support';      //AR3640
                    if(lst_supp[i].oppli.Id==null)
                        {
                            oli.OpportunityId = strOppId;
                            for(Integer prdcnt=0;prdcnt<pbe.size();prdcnt++)
                            {
                                if(lst_supp[i].strproduct == pbe[prdcnt].Product2ID)
                                {
                                    oli.PricebookEntryId = pbe[prdcnt].Id;
                                    break;
                                }
                            }
                        }
                    if(oli.Stretch__c == null || oli.Stretch__c < oli.UnitPrice){ //allha02 3576
                        oli.Stretch__c = oli.UnitPrice ;
                        alert= true;
                    }
                    
                    ins_lineitem.add(oli); 
                         
                    //add the below data only for new line items                    
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the Support Details.');// +' Product ::' +lst_supp[i].strproduct + ', Bus Type :: ' + lst_supp[i].strbustype + 'Unit Price ::' + lst_supp[i].oppli.UnitPrice + ', Contract Length :: ' + lst_supp[i].oppli.Contract_Length__c + ', In/Out ::' + lst_supp[i].oppli.Inside_Outside__c + ', Close Date ::' + lst_supp[i].oppli.Close_Date__c );
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        //map the data for saving
        for(Integer m=0;m<lst_edu.size();m++)
        {
            //proceed to save only if the BU is selected
            if(lst_edu[m].strbu!='--Select--' && lst_edu[m].strbu!=null)
            {
                //If BU is selected, then all other line item details need to be completed.
                if(lst_edu[m].strproduct != '--Select--' && lst_edu[m].oppline.UnitPrice != null )
                {                      
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli = lst_edu[m].oppline;
                    oli.Business_Type__c = 'Education';
          oli.Offerings_Family__c = 'Education';      //AR3640

                        if(lst_edu[m].oppline.Id==null)
                        {
                            oli.OpportunityId = strOppId;
                            for(Integer prdcnt=0;prdcnt<pbe.size();prdcnt++)
                            {
                                if(lst_edu[m].strproduct == pbe[prdcnt].Product2ID)
                                {
                                    oli.PricebookEntryId = pbe[prdcnt].Id;
                                    break;
                                }
                            }
                        }
                    if(oli.Stretch__c == null || oli.Stretch__c < oli.UnitPrice){ //allha02 3576
                        oli.Stretch__c = oli.UnitPrice ;
                        alert= true;
                    }
                    ins_lineitem.add(oli);
                    //add the below data only for new line items                    
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the Education Details.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            
        }
        //map the data for saving
        for(Integer n=0;n<lst_serv.size();n++)
        {
            //proceed to save only if the BU is selected
            if(lst_serv[n].strbu!='--Select--' && lst_serv[n].strbu!=null)
            {
                //If BU is selected, then all other line item details need to be completed.
                if(lst_serv[n].strproduct != '--Select--' && lst_serv[n].opplineitem.UnitPrice != null)
                {
                        
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli = lst_serv[n].opplineitem;
                    oli.Business_Type__c = 'Services';
          oli.Offerings_Family__c = 'Services';    //AR3640
                    if(lst_serv[n].opplineitem.Id==null)
                        {
                            oli.OpportunityId = strOppId;
                            for(Integer prdcnt=0;prdcnt<pbe.size();prdcnt++)
                            {
                                if(lst_serv[n].strproduct == pbe[prdcnt].Product2ID)
                                {
                                    oli.PricebookEntryId = pbe[prdcnt].Id;
                                    break;
                                } 
                            }
                        }
                    if(oli.Stretch__c == null || oli.Stretch__c < oli.UnitPrice){ //allha02 3576
                        oli.Stretch__c = oli.UnitPrice ;
                        alert= true;
                    }
                    ins_lineitem.add(oli);
                    //add the below data only for new line items
                    
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the Services Details.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            
        }
        System.debug('ins='+ins_lineitem);
        if(alert){ //allha02 3576
           ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info,'Stretch is required and must be greater than or equal to Sales Price.  Stretch value adjusted.');
                   ApexPages.addMessage(msg); 
            return null;
        } 
        
        if(ins_lineitem.size()>0)
        {
            try{
            upsert ins_lineitem;
            }catch(Exception ex){                
                if (ex.getMessage().contains('Stretch should be greater than or equal to Sales price')) {
                   ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Stretch should be greater than or equal to Sales price.');
                   ApexPages.addMessage(msg);
                   
                }else{
                   ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,ex.getMessage());
                   ApexPages.addMessage(msg);
                }               
                return null;
                //System.debug(ex.getMessage());
            }
        }
        else
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please add either Support or Education or Services.');
            ApexPages.addMessage(msg);
            return null;
        }
        
        System.debug('ins='+ins_lineitem);
        PageReference pref = new PageReference('/'+strOppId);
        pref.setRedirect(true);
        return pref;
    }
    
    public String prdbu {get;set;}
    public Integer prdpos {get;set;}
    public String prdfamily {get;set;}
    public void fetchproducts()
    {
        System.debug('bu_val='+prdbu);
        System.debug('pos='+prdpos);
        
        
        List<SelectOption> selproducts = new List<SelectOption>();
        

        List<Product2> lstprd = new List<Product2>();
        
        lstprd = [select Id,Name from Product2 where Salesforce_CPQ_Product__c=false and Family=:prdfamily and Market_Focus_Area__c=:prdbu and isDeleted = false and Market_Focus_Area__c != null and isActive = true Order by Name];
        
        Set<String> setcheck = new Set<String>();
        
        Map<string,string> m = new Map<string,string>();
        Set<string> s= new Set<string>();
        List<string> sortedList = new List<string>();
        
        s.add('BCS Plus'.toUpperCase().trim());
        s.add('BCS Premier'.toUpperCase().trim());
        s.add('Support Availability Manager (SAM)'.toUpperCase().trim());
        s.add('High Security Support (HSS)'.toUpperCase().trim());
        s.add('Extended Support Basic'.toUpperCase().trim());
        s.add('Extended Support Plus'.toUpperCase().trim());

        //Sorted in the reverse order as expected as we are adding all elements at position 1 from this list later
        sortedList.add('Extended Support Plus');
        sortedList.add('Extended Support Basic');
        sortedList.add('High Security Support (HSS)');
        sortedList.add('Support Availability Manager (SAM)');
        sortedList.add('BCS Premier');
        sortedList.add('BCS Plus');
        

        for(Product2 prd : lstprd){
            if(s.contains(prd.Name.toUpperCase().trim()))
                    m.put(prd.Name.toUpperCase().trim(),prd.Id);
            else
                selproducts.add(new SelectOption(prd.Id,prd.Name));    
        }
   
        selproducts.add(new SelectOption('--Select--','--Select--'));
        for(string strprod: sortedList)
        {
               if(m.get(strprod.toUpperCase().trim()) != null)
                   selproducts.add(0, new SelectOption(m.get(strprod.toUpperCase().trim()),strprod));
        }
        selproducts.add(0, new SelectOption('--Select--','--Select--'));
        selproducts.remove(selproducts.size() -1);


        if(prdfamily == 'Services')
        {
            service_class servclass = lst_serv[prdpos];
            servclass.selproductserv = new List<SelectOption>();
            servclass.selproductserv = selproducts;
        }
        if(prdfamily == 'Education')
        {
            education_class educlass = lst_edu[prdpos];
            educlass.selproductedu = new List<SelectOption>();
            educlass.selproductedu = selproducts;
        }
        if(prdfamily == 'Support')
        {
            support_class suppclass = lst_supp[prdpos];
            suppclass.selproductsupp = new List<SelectOption>();
            suppclass.selproductsupp = selproducts;
        }
    }
    
    @isTest(SeeAllData=true)
    static void testVF()
    {
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        //SystemIdUtility.skipOpportunityTriggers = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
        //Get the opportunity recordtype id
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        
        Product2 prd1 = new Product2(Name='Prd1', Family='Product',Market_Focus_Area__c='Test1',IsActive=true);
        Product2 prd2 = new Product2(Name='Prd2', Family='Time',Market_Focus_Area__c='Test2',IsActive=true);
        Product2 prd3 = new Product2(Name='Prd3', Family='Mainframe Capacity',Market_Focus_Area__c='Test1',IsActive=true);
        Product2 prd4 = new Product2(Name='Prd4', Family='Services',Market_Focus_Area__c='Test2',IsActive=true);
        Product2 prd5 = new Product2(Name='Prd5', Family='Support',Market_Focus_Area__c='Test1',IsActive=true);
        Product2 prd6 = new Product2(Name='Prd6', Family='Education',Market_Focus_Area__c='Test1',IsActive=true);
        Product2[] prd = new Product2[]{prd1,prd2,prd3,prd4,prd5,prd6};
        insert prd;
        
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id=prd[0].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true); 
        PricebookEntry pbe2 = new PricebookEntry(Product2Id=prd[1].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe3 = new PricebookEntry(Product2Id=prd[2].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe4 = new PricebookEntry(Product2Id=prd[3].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe5 = new PricebookEntry(Product2Id=prd[4].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry pbe6 = new PricebookEntry(Product2Id=prd[5].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        PricebookEntry[] pbe = new PricebookEntry[]{pbe1,pbe2,pbe3,pbe4,pbe5,pbe6};
        insert pbe; 
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    

        Opportunity opp = new Opportunity(AccountId=smbAcct.Id,Reseller__c=resellerAcct.Id,Name='Opp1',RecordTypeId=oppRecId,CloseDate=System.today()+3,StageName=Label.Opp_Stage_Closed_Won,Initial_Billing__c=2);
        insert opp; 
        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[3].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Services');
        OpportunityLineItem oli5 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[3].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Services');
        OpportunityLineItem oli6 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[3].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Services');
        OpportunityLineItem oli7 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[4].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Support');
        OpportunityLineItem oli10 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[4].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Support');
        OpportunityLineItem oli8 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[5].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Education');
        OpportunityLineItem oli9 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[3].Id,UnitPrice=3,Contract_Length__c=5,Offerings_Family__c='Services');
        OpportunityLineItem[] oli = new OpportunityLineItem[]{oli4,oli5,oli6,oli7,oli8,oli9,oli10};
        insert oli;
         
        OpportunityLineItem oli1_3 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[3].Id,UnitPrice=3,Contract_Length__c=5);
        OpportunityLineItem oli1_4 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[4].Id,UnitPrice=3,Contract_Length__c=5);
        OpportunityLineItem oli1_5 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[5].Id,UnitPrice=3,Contract_Length__c=5);
        //OpportunityLineItem[] oli = new OpportunityLineItem[]{oli1_3,oli1_4,oli1_5};
         
        PageReference opplinewpage3 = Page.AddOfferingsPage;
        opplinewpage3.getParameters().put('oppid',opp.Id);
        Test.setCurrentPage(opplinewpage3);
        ApexPages.StandardController stdcon3 = new ApexPages.StandardController(oli1_3);
        offeringscontroller opplicontroller3 = new offeringscontroller(stdcon3);
        opplicontroller3.saveproducts();
        opplicontroller3.addmore_edu();
        opplicontroller3.addmore_supp();
        opplicontroller3.addmore_serv();
        
        opp.StageName = label.Opp_Stage_Closed_Lost;
        update opp;

        
    }
}