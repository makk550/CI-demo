public class Renewal_editCAProduct {
       String strOppId;   
            String WhereCond;   
        //added these variable to get the filter values.
        public String Product_Name_Filter {get;set;}
        public String Orig_Exp_Date_Filter {get;set;}
        public String Raw_Maint_Calc_Filter {get;set;}
        public String Sales_Price_Filter{get;set;}
        public String Stretch_Filter {get;set;}
        public String Quote_Filter {get;set;}
        public String Contract_Filter {get;set;}

        public decimal Stretch_USD{get;set;}
        public decimal Projected_Renewal_USD{get;set;}
        public String quote {get;set;}
        public Integer ContractNo {get;set;}
        public Decimal ProjectedRenewal{get;set;}
        public integer npages;    
        public integer remainder;
        public integer acpage = 1;
        public Integer PageSize = 10 ;
        public List<CA_Product_Renewal__c> caProductList;
        public List<CA_Product_Renewal__c> caProductList_Filter;
        public OpportunityLineItem opplineitm {get;set;}
        public Opportunity opp {get;set;}
        public Decimal TotalRawMaintenanceCacl {get;set;}
        public Boolean showMsg {get;set;}

        private String sortDirection = 'ASC'; 
        private String sortExp = 'name';   
        
        public Renewal_editCAProduct(ApexPages.StandardSetController controller) {

        //quote  = '';
        
            //String strVal = System.currentPageReference().getParameters().get('Id');
            strOppId=system.currentPageReference().getParameters().get('Id');
            caProductList = new List<CA_Product_Renewal__c>();
            //System.debug('strOppId## '+strOppId);
            mainMethod();
            /*if(strVal != null || strVal != ''){
            showMsg = false;
            strOppId=system.currentPageReference().getParameters().get('Id');
            caProductList = new List<CA_Product_Renewal__c>();
            //System.debug('strOppId## '+strOppId);
            mainMethod();
            }else{
               showMsg = True;
            }*/
          
        }
        public void mainMethod(){
            
            for(CA_Product_Renewal__c ca: [Select c.ATTRF__c,c.name,c.Renewal_Opportunity__r.New_Deal_Term_months__c,
            c.Renewal_Opportunity__r.Stretch_Deal_Term_Months__c,
            c.Renewal_Opportunity__r.Stretch_Sales_Price_Gap_Reason__c,
            c.Renewal_Opportunity__r.Business_Type__c,c.Renewal_Opportunity__c,
            c.Renewal_Opportunity__r.Projected_Renewal__c,c.Renewal_Opportunity__r.name,
            c.Renewal_Opportunity__r.Total_Raw_Maintenance_Cacl__c,
            Original_Expiration_Date__c,Active_Contract_Number__c,
            c.Quote__c, c.Projected_Renewal__c,
            Raw_Maintenance__c From CA_Product_Renewal__c c
            where c.Renewal_Opportunity__c =:strOppId order by c.name ]){
                opp = new Opportunity(
                id= ca.Renewal_Opportunity__c,
                name = ca.Renewal_Opportunity__r.name,
                New_Deal_Term_months__c = ca.Renewal_Opportunity__r.New_Deal_Term_months__c,
                
                Stretch_Deal_Term_Months__c = ca.Renewal_Opportunity__r.Stretch_Deal_Term_Months__c,
                Stretch_Sales_Price_Gap_Reason__c = ca.Renewal_Opportunity__r.Stretch_Sales_Price_Gap_Reason__c,
                Business_Type__c = ca.Renewal_Opportunity__r.Business_Type__c,
                Projected_Renewal__c = ca.Renewal_Opportunity__r.Projected_Renewal__c);
                TotalRawMaintenanceCacl = ca.Renewal_Opportunity__r.Total_Raw_Maintenance_Cacl__c;            
                

                //opp.Total_Raw_Maintenance_Cacl__c = ca.Renewal_Opportunity__r.Total_Raw_Maintenance_Cacl__c);
                /*CA_Product_Renewal__c caObj = new CA_Product_Renewal__c(
                id = ca.id,name = ca.name,
                Quote__c = ca.Quote__c,
                Projected_Renewal__c = ca.Projected_Renewal__c);*/

                caProductList.add(ca);
            }        /*  for(OpportunityLineItem Opplineitm:[select o.Contract_Number__c,o.Opportunity.New_Deal_Term_months__c,o.Opportunity.Stretch__c,o.Opportunity.Stretch_Deal_Term_Months__c,o.Opportunity.Stretch_Sales_Price_Gap_Reason__c,o.Opportunity.Business_Type__c,o.Opportunity.id,o.Opportunity.Projected_Renewal__c,o.Opportunity.name,o.Opportunity.Total_Raw_Maintenance_Cacl__c,o.Original_Expiration_Date__c,o.Quote_Number__c from opportunitylineitem o where o.opportunity.id=:
            strOppId]){
            
             }*/
             
      }

        public String sortExpression  
        {     get 
                { 
                       return sortExp;    
                 }  
              set   
                 {
                     if (value == sortExp)   
                        sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
                     else         sortDirection = 'ASC';       sortExp = value;     
                 }
        }
        
        public String getSortDirection() 
        {  
             if (sortExpression == null || sortExpression == '')      
                   return 'ASC';  
              else   
                  return sortDirection; 
         } 
        
        public void setSortDirection(String value) 
         {  
             sortDirection = value;
         }


        public pagereference clearFilter()
        {
            Product_Name_Filter = '';
            Orig_Exp_Date_Filter = '';
            Raw_Maint_Calc_Filter= '';
            Sales_Price_Filter= '';
            Stretch_Filter= '';
            Quote_Filter= '';
            Contract_Filter = '';
            caProductList.clear(); 
            mainMethod();
            return null;
        }
        public pagereference ViewData()
        {
            
            //Raw_Maint_Calc_Filter = Raw_Maint_Calc_Filter.replaceAll(',','');
            //Sales_Price_Filter = Sales_Price_Filter.replaceAll(',','') ;
            //Stretch_Filter = Stretch_Filter.replaceAll(',','') ;
            //Quote_Filter =Quote_Filter.replaceAll(',','') ;
            //Contract_Filter = Contract_Filter.replaceAll(',','') ;
       try
       { 
                           WhereCond = '';
        if(Product_Name_Filter != '')
            WhereCond = '  and c.name = \'' + Product_Name_Filter + '\'';
        if(Orig_Exp_Date_Filter != '')
        {
           WhereCond = WhereCond +  '  and c.Original_Expiration_Date__c = ' + date.parse(Orig_Exp_Date_Filter);
           WhereCond = WhereCond.replace(' 00:00:00','');
        }
        /*if(Raw_Maint_Calc_Filter != '')
           WhereCond =WhereCond +  '  and c.Raw_Maintenance__c = ' + Raw_Maint_Calc_Filter;
        if(Sales_Price_Filter != '')
           WhereCond = WhereCond + '  and c.Projected_Renewal__c = ' + Sales_Price_Filter ;
        if(Stretch_Filter != '')
           WhereCond =WhereCond +  '  and c.Stretch__c = ' + Stretch_Filter;
        if(Quote_Filter != '')
           WhereCond =WhereCond +  '  and c.Quote__c = ' + Quote_Filter ;
        if(Contract_Filter != '')
           WhereCond =WhereCond +  '  and c.Contract_No__c = \''+ Contract_Filter + '\'' ;
          */    
           WhereCond = '\'' + strOppId + '\'' + WhereCond ;

            string sortFullExp = sortExpression +',name' + ' ' + sortDirection;        
            System.debug('WhereCond-->' + WhereCond);
            //accounts = Database.query('Select id, Name, BillingCity, BillingCountry, Phone from Account order by  ' + sortFullExp + '  limit 1000');       return null;   
            caProductList.clear();
            String qry  = 'Select c.ATTRF__c, c.name,c.Renewal_Opportunity__r.New_Deal_Term_months__c,' ; 
                 qry  = qry + 'c.Renewal_Opportunity__r.Stretch_Deal_Term_Months__c, ' ;
                 qry  = qry + 'c.Renewal_Opportunity__r.Stretch_Sales_Price_Gap_Reason__c,';
                 qry  = qry + 'c.Renewal_Opportunity__r.Business_Type__c,c.Renewal_Opportunity__c,';
                 qry  = qry + 'c.Renewal_Opportunity__r.Projected_Renewal__c,c.Renewal_Opportunity__r.name,';
                 qry  = qry + 'c.Renewal_Opportunity__r.Total_Raw_Maintenance_Cacl__c,';
                 qry  = qry + 'Original_Expiration_Date__c,Active_Contract_Number__c,';
                 qry  = qry + 'c.Quote__c, c.Projected_Renewal__c,';
                 qry  = qry + 'Raw_Maintenance__c From CA_Product_Renewal__c c ' ; 
                 qry  = qry + 'where  c.Renewal_Opportunity__c = '+ WhereCond + ' order by ' +  sortFullExp + ' limit 1000';                   

            System.debug('qry-->' + qry);                
                    caProductList =  Database.query(qry);
            System.debug('qry-->' + qry);
           }catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
                ApexPages.addMessage(msg); 
            }

            return null;
        }

        public pagereference applyFilter()
            {                     
          /*WhereCond = '';
        if(Product_Name_Filter != '')
            WhereCond = '  and c.name = \'' + Product_Name_Filter + '\'';
        if(Orig_Exp_Date_Filter != '')
           WhereCond = WhereCond +  '  and c.Original_Expiration_Date__c = ' + Orig_Exp_Date_Filter;
        if(Raw_Maint_Calc_Filter != '')
           WhereCond =WhereCond +  '  and c.Raw_Maintenance__c = ' + Raw_Maint_Calc_Filter;
        if(Sales_Price_Filter != '')
           WhereCond = WhereCond + '  and c.Projected_Renewal__c = ' + Sales_Price_Filter ;
        if(Stretch_Filter != '')
           WhereCond =WhereCond +  '  and c.Stretch__c = ' + Stretch_Filter;
        if(Quote_Filter != '')
           WhereCond =WhereCond +  '  and c.Quote__c = ' + Quote_Filter ;
        if(Contract_Filter != '')
           WhereCond =WhereCond +  '  and c.Contract_No__c = '+ Contract_Filter ;

           WhereCond = '\'' + strOppId + '\'' + WhereCond ;

            caProductList.clear();
            String qry  = 'Select c.ATTRF__c, c.name,c.Renewal_Opportunity__r.New_Deal_Term_months__c,' ; 
                 qry  = qry + 'c.Renewal_Opportunity__r.Stretch__c,c.Renewal_Opportunity__r.Stretch_Deal_Term_Months__c, ' ;
                 qry  = qry + 'c.Renewal_Opportunity__r.Stretch_Sales_PriceGap_Reason__c,';
                 qry  = qry + 'c.Renewal_Opportunity__r.Business_Type__c,c.Renewal_Opportunity__c,';
                 qry  = qry + 'c.Renewal_Opportunity__r.Projected_Renewal__c,c.Renewal_Opportunity__r.name,';
                 qry  = qry + 'c.Renewal_Opportunity__r.Total_Raw_Maintenance_Cacl__c,';
                 qry  = qry + 'Original_Expiration_Date__c,Active_Contract_Number__c,';
                 qry  = qry + 'c.Quote__c, c.Projected_Renewal__c, c.Stretch__c,';
                 qry  = qry + 'Raw_Maintenance__c From CA_Product_Renewal__c c ' ; 
                 qry  = qry + 'where c.Renewal_Opportunity__c = ' + WhereCond;                   
                
                    caProductList =  Database.query(qry);

                    
            */
                  ViewData();
                    return null;
            }
        // here need to add oppline item
        public pagereference updateOpportunity(){
            
            try{
               for(Integer i=0;i < caProductList.size() ; i++)
               {
                    if(quote != '' && quote != 'NULL')
                    {
                        caProductList[i].Quote__c = quote;  
                        //opplineitm.Quote_Number__c = quote;             
                    }
                    if(ContractNo > 0 )
                    {
                       // caProductList[i].Contract_no__c =   String.ValueOf(ContractNo);
                        //opplineitm.Contract_Number__c = String.valueOf(ContractNo);
                        
                    }            
               }

               for(CA_Product_Renewal__c ca : caProductList){
                if(ca.Raw_Maintenance__c == null || ca.Raw_Maintenance__c == 0)
                    ca.Projected_Renewal__c = 0;
                  
                else if(TotalRawMaintenanceCacl  == null || TotalRawMaintenanceCacl == 0)
                    ca.Projected_Renewal__c = 0;
                else
                {
                    ProjectedRenewal  = (ca.Raw_Maintenance__c / TotalRawMaintenanceCacl )* opp.Projected_Renewal__c;
                    //ca.Projected_Renewal__c = (ca.Raw_Maintenance__c / TotalRawMaintenanceCacl )* opp.Projected_Renewal__c;                    
                    ca.Projected_Renewal__c = ProjectedRenewal;
                }
                /*if(ca.Quote__c == '' || ca.Quote__c == NULL)
                {
                    ca.Quote__c = quote;  
                    //opplineitm.Quote_Number__c = quote;             
                }
             //   if(ca.Contract_no__c== NULL  &&  String.valueOf(ContractNo)!= '' )
                {
               //     ca.Contract_no__c= ContractNo;
                    //opplineitm.Contract_Number__c = String.valueOf(ContractNo);
                    
                } */           
            }        
            //update static flag to true, to avoid the trigger at CA product
            //to update projected renewal again at opportunity level
           Renewals_Util.Renewal_updateProjectedRenewalOnOpp  = true;
            update opp;
            
            if(caProductList.size()>0)
            {
                update caProductList;             
                //update ca;
            }
                caProductList.clear();
                mainMethod();    
            }catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
                ApexPages.addMessage(msg); 
            }
                        
            return null;
        } 
        // Opportunity product is updated based on the 1.06 req by subsa03
        public pagereference updateProducts(){
            try{
            if(caProductList.size()>0)
                update caProductList;
                //update opplineitm;
                caProductList.clear();
                mainMethod();    
            }catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
                ApexPages.addMessage(msg); 
            }
            return null;
        }  
        public void setCaProductList(List<CA_Product_Renewal__c> caProductList){
            this.caProductList = caProductList;
        }
         public List<CA_Product_Renewal__c> getCaProductList(){
            
            if(getResultSize() > pageSize)
         {
                 List<CA_Product_Renewal__c> my_plist = new List<CA_Product_Renewal__c>();
                 npages = getResultsize()/pagesize;
                 remainder = getResultsize() - (pageSize*npages);   
                    
                  for (integer i=0; i<pagesize; i++)
                  {
                     if(((acpage-1)*pagesize +i) < getResultsize())
                     my_plist.add(caProductList[(acpage-1)* pageSize + i]); 
                   }
                return my_plist;
         }        
         return caProductList;
            
            //return lstAccount;
        }  
        
        public boolean getHasNext() {
             if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize())
                return false;
            else    
                return true;
        }

        public Boolean getHasPrevious() {
            if( getResultSize() == 0 || acpage == 1 )
                return false;
            else
                return true;    
        }
        
        public Integer getPageSize() {  
               return pageSize;   
        }  

        public void setPageSize(Integer ps) {
               if(ps != pageSize)
                {       
                    acpage =1;
                    pageSize = ps;
                }
       }
        public void next() {
               acpage +=1;
        }
      
        public void previous() {
               acpage-=1;
        }
        

        public Integer getResultSize() {
            if(caProductList== null)
                return 0;
            else
                return caProductList.size();
       }
       
       @isTest
       public static void Renewal_editCAProduct_test() {
      
           RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
           recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
                    id res;
                    id com;
                    for(recordtype rec: recs)
                        if(rec.name == 'SMB')
                                com = rec.id;
                        else
                                res = rec.id;
                    account a = new account(name ='we', recordtypeid =res);
                    a.customer_Category__c= 'Reseller';
                    a.hq__c= true;
                    a.Commercial_Account_Name__c='test 11111114'  ;
                    a.Commercial_ID__c= 'test 11111115';
                    a.Country_Picklist__c= 'JP - JAPAN';
                    a.GEO__c= 'JAPAN';
                    a.Sales_Area__c= 'JAPAN';
                    a.Sales_Region__c= 'JAPAN';
                    a.Billingstate= 'A';
                    a.Billingcity= 'B';
                    a.Billingstreet= 'C';
                    insert a;
         Opportunity opp = new Opportunity(RecordTypeId=recopp.Id,Reseller__c = a.Id,
         Name = 'TestOpp' ,
         StageName = 'test' , 
         CloseDate = Date.today(),
         New_Deal_Term_months__c = 12, 
         Stretch_Deal_Term_Months__c = 8,
         Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
         Business_Type__c = 'High Touch',
         Projected_Renewal__c = 12345.0);
         insert opp;
        CA_Product_Renewal__c ca =new CA_Product_Renewal__c(Name ='TestCA',Renewal_Opportunity__c = opp.Id,Quote__C ='testquote');
        insert ca;
            CA_Product_Renewal__c renOpp = [Select Id, Renewal_Opportunity__c from CA_Product_Renewal__c where Renewal_Opportunity__c =:opp.Id];
            ApexPages.StandardSetController controller;
            system.currentPageReference().getParameters().put('Id',renOpp.Renewal_Opportunity__c);
            Renewal_editCAProduct c = new Renewal_editCAProduct(controller);
            c.getSortDirection();
            c.setSortDirection('ASC');
            c.clearFilter();
            c.ViewData();
            c.applyFilter();
            c.updateOpportunity();
            c.updateProducts();
            List<CA_Product_Renewal__c> tempList = new List<CA_Product_Renewal__c>();
            tempList.add(renOpp);
            c.setCaProductList(tempList);
            c.getCaProductList();
            c.getHasNext();
            c.getHasPrevious();
            c.getPageSize();
            c.setPageSize(10);
            c.next();
            c.previous();
            c.getResultSize();                                      
       } 
 
  }