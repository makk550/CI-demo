public class OppLineitem_View_Edit_controller_PRM
    {
        public string salesPrice_usd {get;set;}
    // fy13    public string comfort_usd {get;set;}
        public string actiontitle {get;set;}
        public string actionsubtitle {get;set;}
        
        private String strOppLineID = '';
        private String ProdId = '';
        private OpportunityLineItem lineitemrecord;
        private Map<Id,Product2> prdmap;
        private String stroppid = '';
        private String strooppid = '';
        public boolean show_ondemand {get;set;}
        public OpportunityLineItem lineitemrec {get;set;}
        public Opportunity headerrec {get;set;}
        public Boolean isRenewal {get;set;}
        public Boolean isProduct {get;set;}
      
        public String prdfamily {get;set;}
        
        public Boolean isUF {get;set;}

         
        public String prdbu {get;set;}
        public String prdname {get;set;}
        public String replace_expirydate_label {get;set;}
        public Boolean isView {get;set;}
        public Boolean isEdit {get;set;}
        public Boolean isclosedlost {get;set;}
        public Boolean showreason {get;set;}
        public Boolean otherreason {get;set;}
         
        public Boolean isViewOfferings {get;set;}
        public Boolean isEditOfferings {get;set;}
        public Boolean isOffering {get;set;}
        public Boolean isServices {get;set;}
        public Boolean isEducation {get;set;}
        public Boolean isSupport {get;set;}
        
        public Boolean isCompetitorRequired {get;set;}
        public Boolean isWinLoss {get;set;}
        public Boolean isDeallostTo {get;set;}
        public List<SelectOption> selbustype {get;set;}
        public List<SelectOption> selcloudplatformuse {get;set;}
        public String bustype {get;set;}
        public String cloudplatformuse {get;set;}
        public Boolean showmilestone {get;set;}
        public Boolean isMainFrame {get;set;}

        public List<Active_Contract_Product__c>  ACPLineItems = new List<Active_Contract_Product__c>();      

        public List<SelectOption> cldplatformuse_entries = new List<SelectOption>();
        
        public Id oppId {get;set;}        // fy13
        public String oppName {get;set;}  // fy13

        public OppLineitem_View_Edit_controller_PRM(ApexPages.Standardcontroller stdcontroller)
        {
            stroppid = ApexPages.currentPage().getParameters().get('retURL');
            System.debug(stroppid);
            //incase returnurl is present, means its an edit
            if(stroppid !=null)
            {
                isEdit = true;
                isView = false; 
            }   
            else
            {
                isEdit = false;
                isView = true;
            }   
            //get lineitem id    
            strOppLineID = ApexPages.currentPage().getParameters().get('id');
            lineitemrecord = new OpportunityLineItem();
            //fetch the lineitem details
            lineitemrecord = [SELECT OpportunityId,Stretch__c,UF_License_Fee__c,X1st_Year_Maintenance__c,Business_Type__c,
                                     Quote_Number__c,Contract_Number__c,Quantity, ListPrice,
                                     PriceBookEntry.UnitPrice,Sales_Price_USD__c, PricebookEntry.Name,PricebookEntry.product2Id,Partner_Sales_Price__c,
                                     Partner_Term__c,   
                                     CurrencyISOCode 
                                FROM OpportunityLineItem 
                               where ID=:strOppLineID
                                 and Business_Type__c != 'Renewal' ];
            String prdid = lineitemrecord.PricebookEntry.product2Id;

            headerrec = new Opportunity(); // fy13
            headerrec = [select Id, Name, New_Deal_Term_months__c, Stretch_Deal_Term_Months__c, 
                                Stretch_Sales_Price_Gap_Reason__c
                           from Opportunity where Id =: lineitemrecord.OpportunityId]; // fy13
    //        oppId = opp.Id;      // fy13
    //        oppName = opp.Name;  // fy13


            salesPrice_usd = String.ValueOf(lineitemrecord.Sales_Price_USD__c);
                    //comfort_usd = String.ValueOf(lineitemrecord.comfort_USD__c);
            //get product details
            Product2 oppprd = [select Name,Family,Market_Focus_Area__c,Upfront_Revenue_Eligible__c from Product2 where Id =: prdid and Salesforce_CPQ_Product__c=false];
            prdfamily = oppprd.Family; 
            prdbu = oppprd.Market_Focus_Area__c;
            prdname = oppprd.Name;
                       
            strooppid =lineitemrecord.OpportunityId;
            if(stroppid!=null && stroppid.contains('/apex/'))
            {
                stroppid = '/'+lineitemrecord.OpportunityId;
                
            }
            //set all flags
            if(prdfamily.toLowerCase() == 'product')
            {
                actiontitle = 'Add/Edit Products';
                actionsubtitle = 'Product Details';
                replace_expirydate_label = 'Replace';
                isProduct = true;
                isRenewal = false;
                isOffering = false;
                showmilestone = false;
                isMainFrame = false;
               
                if(oppprd.Upfront_Revenue_Eligible__c == 'Yes') 
                {
                    isUF = true;               
                }            
            }
            else if(prdfamily.toLowerCase() == 'renewal' || prdfamily.tolowercase() == 'time' || prdfamily.tolowercase() == 'mainframe capacity')
            {
                actiontitle = 'Edit Renewing Products';
                actionsubtitle = 'Renewal Details';
                replace_expirydate_label = 'Original Expiration Date';
                isProduct = false;
                isRenewal = true;
                isOffering = false;
                showmilestone = false;
                isMainFrame = false;
            }
            else if(prdfamily.toLowerCase() == 'services' || prdfamily.toLowerCase() == 'education' || prdfamily.toLowerCase() == 'support')
            {
                actiontitle = 'Add/Edit Offerings';
                if(prdfamily.toLowerCase() == 'services')
                {
                    isServices = true;
                    isEducation = false;
                    isSupport = false;
                    showmilestone = true;
                    actionsubtitle = 'Services Details';
                }
                else if(prdfamily.toLowerCase() == 'education')
                {
                    isServices = false;
                    isEducation = true;
                    isSupport = false;
                    showmilestone = true;
                    actionsubtitle = 'Education Details';
                }
                else if(prdfamily.toLowerCase() == 'support')
                {
                    isServices = false;
                    isEducation = false;
                    isSupport = true;
                    showmilestone = false;
                    actionsubtitle = 'Support Details';
                }
                isProduct = false;
                isRenewal = false;
                isOffering = true;
                isEdit = false;
                isView = false;
                isMainFrame = false;
                if(stroppid !=null)
                {
                    isEditOfferings = true;
                    isViewOfferings = false;
                }
                else
                {
                    isEditOfferings = false;
                    isViewOfferings = true;
                }   
            }
            //Opportunity opp = [select CloseDate,StageName,Probability,ForecastCategory from Opportunity where Id =: lineitemrecord.OpportunityId];
            
            this.lineitemrec = (OpportunityLineItem)stdController.getRecord();  
            fetchbusinesstype();
            bustype = lineitemrecord.Business_Type__c; 
            
            
            if(isproduct)
            {
            List<Products_for_On_Demand__c> lst_Ondemand = Products_for_On_Demand__c.getall().values();
            Set<string> set_ondemand = new Set<string>{};
            
            for(Products_for_On_Demand__c   pod:lst_Ondemand)
                set_ondemand.add(pod.product__c.toLowerCase());
            show_ondemand =   set_ondemand.contains(prdname.toLowerCase());
            
            }
            
            if(prdfamily.tolowercase() == 'mainframe capacity' && prdname.tolowercase()== 'mainframe capacity') 
             {                          
                  actiontitle = 'Add/Edit Mainframe Capacity';
                  actionsubtitle = 'Mainframe Capacity Details';
                  isProduct = false;                          
                  isRenewal = false;                          
                  isOffering = false;                          
                  showmilestone = false;                
                  isMainFrame = true;                
                               
              }
        }
        public void fetchbusinesstype()
        {
            selbustype = new List<SelectOption>();
            selbustype.add(new SelectOption('--Select--','--Select--'));
            
            Schema.DescribeFieldResult bustypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
            for(Schema.PicklistEntry entry : bustypevalues.getPicklistValues())
            {
                //business type to be restricted to particular values for products and renewals
                if(prdfamily.toLowerCase() == 'renewal' || prdfamily.tolowercase() == 'time' || prdfamily.tolowercase() == 'mainframe capacity')
                {
                    if(entry.getValue() == 'Renewal' || entry.getValue() == 'Medium Touch' || entry.getValue() == 'Indirect Medium Touch')
                        selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                else if(prdfamily.toLowerCase() == 'product' || prdfamily.toLowerCase() == 'support')
                {
                    if(entry.getValue() == 'New' || entry.getValue() == 'Time' || entry.getValue() == 'Maintenance')
                        selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    
                    if(entry.getValue() == 'Capacity' || entry.getValue() == 'Upgrade' )
                    {
                        if(prdfamily.toLowerCase() == 'product')
                        {
                            if(prdbu.toLowerCase() != 'mainframe')
                                selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                        }
                        else
                            selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }       
                    
                }
            }
            
        }
        public PageReference updateproduct()
        {          

        //if all fields are not populated, display error message
            if(lineitemrec.Partner_Sales_Price__c!=null)
            {
                /*if(isOffering)
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the details.');
                    ApexPages.addMessage(msg);
                    return null;
                }*/
                if(bustype != '--Select--')
                    lineitemrec.Business_Type__c = bustype;
                else
                {
                    //lineitemrec.Business_Type__c = null;
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please select the Business Type.');
                    ApexPages.addMessage(msg);
                    return null;
                }
                 
                
                if(isMainframe){

                    // fy13 - BR165 - default stretch deal term if not specified
                    if(headerrec.Stretch_Deal_Term_Months__c == null || headerrec.Stretch_Deal_Term_Months__c == 0)
                        headerrec.Stretch_Deal_Term_Months__c = headerrec.New_Deal_Term_months__c;
                    }

                if(!isRenewal && ! isProduct ) //to exclude re-newals and products from this check
                 {                
                       //lineitemrec.Win_Loss_Reason__c = null;
                 }
                                
                //set Probability and Forecast category based upon SalesMilestone
                
                    //lineitemrec.Probability__c = 0;
                    //lineitemrec.Forecast_Category__c = 'Closed';
                
                try{
                   update lineitemrec;
                   
                   decimal salesPrice;
                    salesPrice = 0;
                   for(OpportunityLineItem opli : [SELECT OpportunityId,Partner_Sales_Price__c,
                                     Partner_Term__c,   
                                     CurrencyISOCode FROM OpportunityLineItem where OpportunityId=:strooppid and Business_Type__c != 'Renewal' and partner_added__c = true])
                    {
                      salesPrice = salesPrice + opli.Partner_Sales_Price__c;
                    }
                    System.debug('adfadsf --> ' + salesPrice );
                    System.debug('adfadsf --> ' + strooppid );
                   Opportunity oppr = [select Partner_Sales_Price__c from Opportunity where Id =: strooppid];
                    
                     //   salesprice   -- added by danva01
                  
                   if(oppr != null )
                   {
                       oppr.Partner_Sales_Price__c = salesPrice;
                       system.debug('error' + oppr.Partner_Sales_Price__c);                
                       update oppr;
                   }
                    
                }catch(Exception ex){
                    ApexPages.addMessages(ex);
                    return null;
                }

                // fy13 - BR165 - update at opportunity level is required to handle stretch term and reason
                if(isMainframe){
                    try{
                        update headerrec;
                    }catch(Exception ex){
                        ApexPages.addMessages(ex);
                        return null;
                        }
                    }
          
                
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the details.');
                ApexPages.addMessage(msg);
                return null;
            }
            PageReference pref = new PageReference(stroppid);
            pref.setRedirect(true);
            return pref;
        }
        public PageReference dodelete()
        {
            String opid = lineitemrecord.OpportunityId;
            delete lineitemrec;
            PageReference pref = new PageReference('/'+opid);
            pref.setRedirect(true);
            return pref;
        }
        
        public PageReference docancel()
        {
            if(stroppid == null || stroppid == '')
                stroppid = '/'+lineitemrecord.OpportunityId;
            PageReference pref = new PageReference(stroppid);
            pref.setRedirect(true);
            return pref;
        }
        
        
        
        public boolean inIt{get;set;}
        
        public void calculateUFLicenseFee()
        {
        
                  if(isUF)
                         {     
                            Decimal totMaint;   
                            Decimal totSalesPrice = (lineitemrec.Partner_Sales_Price__c <> null? lineitemrec.Partner_Sales_Price__c : 0);
                            Decimal termInYears =   (lineitemrec.Partner_Term__c <> null? lineitemrec.Partner_Term__c /12 : 0);     
                        
                            Decimal UFLicenseFee = 0;
                            
                            if(termInYears <> 0)
                                UFLicenseFee  = (10 *  totSalesPrice ) /  (10 + 2 * termInYears);      
                            
                            totMaint  =  0.2 * UFLicenseFee * termInYears ;
                            Decimal FirstYearMaint = 0;
                            if(termInYears <> 0)
                                FirstYearMaint = totMaint / termInYears;
                    
                         }
                         

        }
      
        
        
    }