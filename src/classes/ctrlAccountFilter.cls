public class ctrlAccountFilter {

    //Region -> Area -> territory/Country
    public Account acc{get;set;}
    public Account acc2{get;set;}
    public string accname{get; set;}
    public string recType{get;set;}
    public string custCat{get;set;}
    public string parentId{get;set;}
    public boolean hq{get;set;}
    public string commAccName{get;set;}
    public string commId{get;set;}
    public string countryPick{get;set;}
    public string geo{get;set;}
    public string salesArea{get;set;}
    public string salesRegion{get;set;}
    public string state{get;set;}
    public string city{get;set;}
    public string street{get;set;}
    public string gu_duns_number{get;set;}
    public string gu_duns_name{get;set;}
    public string duns_number{get;set;}
    public string duns_name{get;set;}    
    
    public list<SelectOption> rectypes{get;set;}
    public List<account> lstAccount{get;set;}
    public string msg{get;set;}

    public list<SelectOption> custCats{get;set;}
    public list<SelectOption> countryPicks{get;set;}
    public list<SelectOption> geos{get;set;}
    public list<SelectOption> salesAreas{get;set;}
    public list<SelectOption> salesRegions{get;set;}
    public boolean isPrimary{get;set;}
    
    public Account geoOnPage{get;set;}
    
    public PageReference cancel() {
        return null;
    }


    public ctrlAccountFilter() {
        acc = new Account();
        acc2 = new Account();
        rectypes = getItems();
        custCats = getCustCats();
        countryPicks = getCountries();
        geoOnPage = new Account();
      //  geos= getGeos();
     //   salesAreas = getsalesAreas();
      //  salesRegions = getsalesRegions();        
        
        
    }
    
    
    public ctrlAccountFilter(ApexPages.StandardController std){
        acc = new Account();
        acc2 = new Account();
        rectypes = getItems();
        custCats = getCustCats();
        countryPicks = getCountries();
        geoOnPage = new Account();
    }
    
    
    public List<SelectOption> getItems()
      {
            List<SelectOption> options = new List<SelectOption>();
            recType= '';
            options.add(new SelectOption('','--None--'));
            for(RecordType cs: [Select id, name from RecordType Where sObjectType = 'Account' and isActive=true])
            {    
                options.add(new SelectOption(cs.id,cs.Name));
            }
            return options;
      }
      
   
    public List<SelectOption> getCustCats()
      {
            List<SelectOption> options = new List<SelectOption>();
            countryPick= '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Customer_Category__c.getDescribe();
                List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
         
    
    public List<SelectOption> getCountries()
      {
            List<SelectOption> options = new List<SelectOption>();
            countryPick= '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Country_Picklist__c.getDescribe();
                List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
      
    public List<SelectOption> getGeos()
      {
            List<SelectOption> options = new List<SelectOption>();
            geoOnPage.GEO__c = '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Geo__c.getDescribe();
                List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
    
    public List<SelectOption> getSalesAreas()
      {
            List<SelectOption> options = new List<SelectOption>();
            geoOnPage.Sales_Area__c = '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Sales_Area__c.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
    
    public List<SelectOption> getSalesRegions()
      {
            List<SelectOption> options = new List<SelectOption>();
            geoOnPage.Sales_Region__c = '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Sales_Region__c.getDescribe();
                List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
    
     public void Go()
     {
          string searchstr = '%' + accname.replace('*','%') + '%';
         
          lstAccount = [Select a.Sales_Region__c, a.Sales_Area__c, a.RecordTypeId,a.Is_Primary_Account__c,
                            a.Physical_State_Prov_Local__c, a.Physical_City_Local__c, a.ParentId, 
                            a.Name, a.Id, a.GU_NAME__c,
                            // a.HQ__c, 
                            a.GEO__c, a.Customer_Category__c, a.Country_Picklist__c,
                            a.Commercial_ID__c, a.Commercial_Account_Name__c, a.BillingStreet, a.BillingCity, a.BillingState  From Account a
                            Where a.name like : searchstr 
                            and a.RecordType.isactive = true
                            limit 500];
     }

         
    public void Search()
     {
          string filterstring = '';
          if(accname != '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Name like \'%' + accname + '%\' ';
          if(rectype != '' && rectype != null)
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.RecordTypeId  =\'' + rectype + '\' ';
          if(custcat!= '' && custcat!= null)
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Customer_Category__c  = \'' + custcat + '\' ';
          if(acc.ParentId!= null)
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.ParentId  =\'' + acc.ParentId + '\' ';
        //  if(HQ != null)
        //          filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.HQ__c  = ' + hq + ' ';
          if(CommAccName != '' && CommAccName!= null)
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Commercial_Account_Name__c like \'%' + CommAccName + '%\' ';
          if(CommId != '' && CommId!= null)
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Commercial_ID__c like \'%' + commId + '%\' ';
          if(CountryPick != '' && CountryPick != null)
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Country_Picklist__c = \'' + countryPick + '\' ';
         
          if( geoOnPage.GEO__c != null &&  geoOnPage.GEO__c != '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.GEO__c like \'' + geoOnPage.GEO__c + '\' ';
          if(geoOnPage.Sales_Area__c != null &&  geoOnPage.Sales_Area__c != '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Sales_Area__c = \'' + geoOnPage.Sales_Area__c + '\' ';
          if(geoOnPage.Sales_Region__c!= null && geoOnPage.Sales_Region__c!= '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Sales_Region__c like \'' + geoOnPage.Sales_Region__c + '\' ';
         
          if(State != null && State != '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.BillingState like \'%' + State + '%\' ';
          if(City != null && City!= '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.BillingCity like \'%' + City + '%\' ';
          if(Street != null && Street!= '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.BillingStreet like \'%' + Street + '%\' ';
          
          if(gu_duns_number != null && gu_duns_number != '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.GU_DUNS_NUMBER__c like \'%' + gu_duns_number+ '%\' ';
     
          if(gu_duns_name!= null && gu_duns_name!= '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.GU_NAME__c like \'%' + gu_duns_name+ '%\' ';
      
          if(duns_number != null && duns_number != '')
                  filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.DUNS_Number__c like \'%' + duns_number+ '%\' ';
     
        //  if(duns_name!= null && duns_name!= '')
         //         filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Business_Name__c like \'%' + duns_name+ '%\' ';
         
                    
     //     if(isPrimary!= null)                  
     //             filterstring = filterstring + (filterstring != null && filterstring != ''?' AND ':'') + ' a.Is_Primary_Account__c  = ' + isPrimary + ' ';
        
         filterstring  = filterstring.replace('*','%'); 
         msg=filterstring;
         try
         {
             if(filterstring != '')
                  lstAccount = Database.Query('Select a.Enterprise_ID__c, a.Sales_Region__c, a.Sales_Area__c, a.RecordTypeId, a.Physical_State_Prov_Local__c, a.Physical_City_Local__c, a.ParentId, a.Name, a.Id, a.GU_NAME__c, ' +
                 // a.HQ__c, 
                 ' a.GEO__c, a.Customer_Category__c, a.Country_Picklist__c, a.Commercial_ID__c, a.Commercial_Account_Name__c, a.BillingStreet, a.BillingCity, a.BillingState,a.Is_Primary_Account__c From Account a  Where ' + filterstring  + '  and a.RecordType.isactive = true limit 500 ' );
         }
         catch(exception ex)
         {    
             msg = 'Select a.Enterprise_ID__c, a.Sales_Region__c, a.Sales_Area__c, a.RecordTypeId, a.Physical_State_Prov_Local__c, a.Physical_City_Local__c, a.ParentId, a.Name, a.Id, a.GU_NAME__c, ' +
              //a.HQ__c, 
             ' a.GEO__c, a.Customer_Category__c, a.Country_Picklist__c, a.Commercial_ID__c, a.Commercial_Account_Name__c, a.BillingStreet, a.BillingCity, a.BillingState, a.Is_Primary_Account__c From Account a  Where ' + filterstring   + ' limit 500 ';
         }
              
     }
   
     
    public List<SelectOption> Sales_Area{
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select Value'));

            if (acc.GEO__c != null) {
                Schema.DescribeFieldResult F = Account.Sales_Area__c.getDescribe();
                List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }            
            }else{
               // disableBU = true;
            }

            return options;           
        }
        set;
    }     
    
    public void changeItems()
    {
    
    }
}