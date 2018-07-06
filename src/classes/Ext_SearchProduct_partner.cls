public class Ext_SearchProduct_partner
{
public boolean showNext {get;set;}
public boolean showExport{get;set;}
public boolean showPrevious {get;set;}
public Integer OffsetCount {get;set;}
public Integer totRecordCount{get;set;}
public String strResult {get; set;}
public String queryString{ get; set;} 
public boolean showResultsBlock{ get; set;} 
public String subject{ get; set;} 
public String body{ get; set;} 
public String ccList{ get; set;} 
public String toList{ get; set;} 
public boolean showEmail {get; set;}
String ProductGroupsForSearch ;//vasantha
public String cusSearchString{ get; set;} 
public List<ProductWrapperCls> searchResults{get;set;}
public String initialCurrncyVal{get;set;}
public boolean showErrorMsg{get;set;}
public boolean showSearchbutton{get;set;}
public boolean showifDM {get;set;}
public List<SelectOption> programList {get; set;}
public String selectedProgram{ get; set;}
public String selectedRegion {get;set;}
 
public String selectedRTMType {get;set;}
public List<SelectOption> regionList {get; set;}
public List<SelectOption> currencyList {get; set;}
public Product2 prod {get; set;}
public List<SelectOption> skuTypeList {get; set;}
public List<SelectOption> RTMList{get; set;}
public List<SelectOption> currenciesList {get; set;}
public String selectedSKUType{get;set;}
public Quote quote {get;set;}
public Product2 searchProdResults1 {get;}
public List<Account>  PartnerAccount = new List<Account>(); //vasantha
public List<Contact>  Usercontact= new List<Contact>(); //vasantha
public User loggedinUser{get;set;}
public User currentUserAccount{get;set;}  //vasantha
public String selectedProductName{get;set;}
public String selectedCurrency{get;set;}

public String AccountRTM{get;set;}
public Account AccForCurrencies {get;set;}  //vasantha
public Product_Alignment__c[] lstPA {get;set;}
public String selectedSKU {get;set;}
public List<SelectOption> SKUList {get; set;}
public List<Product2> product_SKUList {get; set;}

public String productName {get;set;}

public List<SelectOption> productGroupList {get; set;}
public List<SelectOption> businessUnitList {get; set;}
public String selectedPG {get;set;}
public String selectedBU {get;set;}
public  List<PriceBook2> pricebook2List {get;set;}
public Map<Id,Decimal> mapPBE {get;set;}
public String PartnerAccoutGeo {get;set;}
public String PartnerLanguage {get;set;}


public Ext_SearchProduct_partner(apexpages.standardController std)
{

    showErrorMsg = false;
      showExport = false;

   OffsetCount  = 0;
   currentUserAccount = [Select Id,Email,CurrencyIsoCode,Profile.Name,AccountId,ContactId,LanguageLocaleKey From User WHERE Id = :UserInfo.getUserId() LIMIT 1];   
   PartnerLanguage =string.valueof(currentUserAccount.LanguageLocaleKey);
   
   PartnerAccount =  [Select id,Customer_PriceSheet__c,Customer_Category__c ,GEO__c, Alliance__c ,Service_Provider__c ,Solution_Provider__c,Velocity_Seller__c  from Account WHERE Id = :currentUserAccount.AccountId LIMIT 1];
   Usercontact = [select id,HasOptedOutOfEmail,Do_Not_Email__c from contact where  id= :currentUserAccount.ContactId Limit 1];

PartnerAccoutGeo = PartnerAccount[0].GEO__c;

     AccountRTM  = '';
     if (PartnerAccount[0].Alliance__c == true)       
       AccountRTM = AccountRTM + 'Alliance';  
     if (PartnerAccount[0].Service_Provider__c == true) 
       if(AccountRTM == '') 
          AccountRTM = AccountRTM + 'Service Provider'; 
       else
          AccountRTM = AccountRTM + ';Service Provider'; 
            
     if (PartnerAccount[0].Solution_Provider__c == true) 
      if(AccountRTM == '') 
         AccountRTM = AccountRTM + 'Solution Provider'; 
       else
         AccountRTM = AccountRTM + ';Solution Provider'; 
      
     selectedRegion =  PartnerAccount[0].GEO__c;
         selectedCurrency = currentUserAccount.CurrencyIsoCode;
    showSearchbutton = false;
    getReferenceData();
    searchResults = new List<ProductWrapperCls>();
    showErrorMsg = false;

          if(PartnerAccount[0].Customer_PriceSheet__c == false)
         {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.WARNING,'You currently do not have access to Pricing. Please contact your Partner Account Manager for assistance.')); 
            showErrorMsg = true;
            showSearchbutton= true;
            showExport = false;

         }         
        ProductAlignment();
              
              

if(PartnerAccount[0].Customer_Category__c == 'Distributor')
  showifDM  = true ;
else
    showifDM=false;

     showResultsBlock = false;
      showEmail=false;

}
public void PreviousPage()
{
   if(OffsetCount >= 200)
    {
        OffsetCount = OffsetCount  - 200;
        showNext = true;
        doSearch();
    }        
}
public void NextPage()
{

  if(OffsetCount <= totRecordCount)
    showPrevious = true;
 
  OffsetCount = OffsetCount  + 200;
 
  if(OffsetCount <= totRecordCount)
     doSearch();   
  
}
public PageReference ExportToExcel()
{

 strResult  = '';       
 
 
 if(showifDM)
     strResult = strResult + 'Product Name~Product Family~Platform~Product Group~Sales Coverage Business Unit~Time/Capacity/NCV~Upfront Revenue Eligible~SKU~SKU Type~GEO~Status~Encrypted~Product Class~Disti Discount%~Version~License Fee~Maintenance %~Royalty Product~Royalty Description~Program~Route To Market~Disti Price~Product Description~TOPS Code~License Metric~Media Language~Currency~List Price~SAP ID~Active~Start Of Life Date~End Of Life Date~Price Book Authorized\n';
 else
    strResult = strResult + 'Product Name~Product Family~Platform~Product Group~Sales Coverage Business Unit~Time/Capacity/NCV~Upfront Revenue Eligible~SKU~SKU Type~GEO~Status~Encrypted~Product Class~Version~License Fee~Maintenance %~Royalty Product~Royalty Description~Program~Route To Market~Product Description~TOPS Code~License Metric~Media Language~Currency~List Price~SAP ID~Active~Start Of Life Date~End Of Life Date~Price Book Authorized\n';
    
   List<Product2> pr= new List<Product2>();
   String strQuery ;
   strQuery  =  queryString.replace('License_fee__c','convertCurrency(License_fee__c)');
   pr= database.query(strQuery  ) ;

   set<Id> prodId = new set<Id>();
   for(Integer i=0;i < pr.size(); i++)
   {
     prodId.add(pr[i].Id);
   }
    
    List<PricebookEntry> p1 = [Select UseStandardPrice, UnitPrice, ProductCode,Product2Id, Pricebook2Id, Id, CurrencyIsoCode From PricebookEntry where CurrencyIsoCode =:selectedCurrency  AND  Product2Id in : prodId];
    Map<Id,Decimal> mapPBE1  = new Map<Id,Decimal>() ;
    for(Integer i=0;i < p1.size(); i++)
    {
       mapPBE1.put(p1[i].Product2Id,p1[i].UnitPrice.setScale(2));
    }
   for(Integer i=0;i < pr.size(); i++)
   {      
        if(showifDM)
       {
        strResult = strResult + pr[i].name  + '~' + pr[i].Family  + '~' + pr[i].Mainframe_or_Distributed__c  + '~' + pr[i].Product_Group__c  + '~' + pr[i].Market_Focus_Area__c + '~' + pr[i].Time_Capacity_NCV__c  + '~' + pr[i].Upfront_Revenue_Eligible__c  + '~' + pr[i].SKU__c  + '~' + pr[i].SKU_Type__c + '~' + selectedRegion  + '~' + pr[i].Status__c  + '~' + pr[i].Encrypted__c + '~' + pr[i].Product_Class__c  + '~' ;
        strResult = strResult + pr[i].Disti_Discount__c  + '~' + pr[i].Version__c + '~' + pr[i].License_fee__c + '~' + pr[i].maintenance__c  + '~' + pr[i].Royalty_product__c + '~' + pr[i].Royalty_Description__c + '~' + pr[i].program__c + '~' + pr[i].Partner_Approved__c  + '~' + pr[i].Dist_Price__c  + '~' + pr[i].Description  + '~' +  pr[i].TOPS_Code__c  + '~' + pr[i].License_metric__c     + '~' + pr[i].Media_Language__c  + '~' + selectedCurrency + '~' +  mapPBE1.get(pr[i].id)+ '~' + pr[i].SAP_ID__c  + '~' + pr[i].IsActive  + '~' + pr[i].Start_of_Life_Date__c  + '~' + pr[i].End_Of_Life_Date__c + '~' + pr[i].Price_Book_Authorized__c  + '\n' ;
       }
       else
       {
        strResult = strResult + pr[i].name  + '~' + pr[i].Family  + '~' + pr[i].Mainframe_or_Distributed__c  + '~' + pr[i].Product_Group__c  + '~' + pr[i].Market_Focus_Area__c + '~' + pr[i].Time_Capacity_NCV__c  + '~' + pr[i].Upfront_Revenue_Eligible__c  + '~' + pr[i].SKU__c  + '~' + pr[i].SKU_Type__c + '~' + selectedRegion  + '~' + pr[i].Status__c  + '~' + pr[i].Encrypted__c + '~' + pr[i].Product_Class__c  + '~' ;
        strResult = strResult + pr[i].Version__c + '~' + pr[i].License_fee__c + '~' + pr[i].maintenance__c  + '~' + pr[i].Royalty_Product__c + '~' + pr[i].Royalty_Description__c + '~' + pr[i].program__c + '~' + pr[i].Partner_Approved__c  + '~' + pr[i].Description  + '~' +  pr[i].TOPS_Code__c  + '~' + pr[i].License_metric__c     + '~' + pr[i].Media_Language__c  + '~' + selectedCurrency + '~' +  mapPBE1.get(pr[i].id)+ '~' + pr[i].SAP_ID__c  + '~' + pr[i].IsActive  + '~' + pr[i].Start_of_Life_Date__c  + '~' + pr[i].End_Of_Life_Date__c + '~' + pr[i].Price_Book_Authorized__c  + '\n' ;       
       }
    }
 strResult = strResult.replaceAll(',', ' ');          
 strResult = strResult.replaceAll('~', ',');          
 strResult = strResult.replaceAll('TRUE', 'Yes');          
 strResult = strResult.replaceAll('FALSE', 'No');          
 strResult = strResult.replaceAll('null', '');          

 
 
/* if(showifDM)
     strResult = strResult + 'Product Name~Product Family~Platform~Product Group~Sales Coverage Business Unit~Time/Capacity/NCV~Upfront Revenue Eligible~SKU~SKU Type~GEO~Status~Encrypted~Product Class~Disti Discount%~Version~License Fee~Maintenance %~Royalty Product~Royalty Description~Program~Route To Market~Disti Price~Product Description~TOPS Code~License Metric~Media Language~Currency~List Price~SAP ID~Active~Start Of Life Date~End Of Life Date~Price Book Authorized\n';
 else
    strResult = strResult + 'Product Name~Product Family~Platform~Product Group~Sales Coverage Business Unit~Time/Capacity/NCV~Upfront Revenue Eligible~SKU~SKU Type~GEO~Status~Encrypted~Product Class~Version~License Fee~Maintenance %~Royalty Product~Royalty Description~Program~Route To Market~Product Description~TOPS Code~License Metric~Media Language~Currency~List Price~SAP ID~Active~Start Of Life Date~End Of Life Date~Price Book Authorized\n';
  
 
    for(Product2 p : database.query(queryString + ' LIMIT 1000 '  ))
    {     
        if(showifDM)
       {
        strResult = strResult + p.name  + '~' + p.Family  + '~' + p.Mainframe_or_Distributed__c  + '~' + p.Product_Group__c  + '~' + p.Market_Focus_Area__c + '~' + p.Time_Capacity_NCV__c  + '~' + p.Upfront_Revenue_Eligible__c  + '~' + p.SKU__c  + '~' + p.SKU_Type__c + '~' + selectedRegion  + '~' + p.Status__c  + '~' + p.Encrypted__c + '~' + p.Product_Class__c  + '~' ;
        strResult = strResult + p.Disti_Discount__c  + '~' + p.Version__c + '~' + p.License_fee__c + '~' + p.maintenance__c  + '~' + p.Royalty_product__c + '~' + p.Royalty_Description__c + '~' + p.program__c + '~' + p.Partner_Approved__c  + '~' + p.Dist_Price__c  + '~' + p.Description  + '~' +  p.TOPS_Code__c  + '~' + p.License_metric__c     + '~' + p.Media_Language__c  + '~' + selectedCurrency + '~' +  mapPBE.get(p.id)+ '~' + p.SAP_ID__c  + '~' + p.IsActive  + '~' + p.Start_of_Life_Date__c  + '~' + p.End_Of_Life_Date__c + '~' + p.Price_Book_Authorized__c  + '\n' ;
       }
       else
       {
        strResult = strResult + p.name  + '~' + p.Family  + '~' + p.Mainframe_or_Distributed__c  + '~' + p.Product_Group__c  + '~' + p.Market_Focus_Area__c + '~' + p.Time_Capacity_NCV__c  + '~' + p.Upfront_Revenue_Eligible__c  + '~' + p.SKU__c  + '~' + p.SKU_Type__c + '~' + selectedRegion  + '~' + p.Status__c  + '~' + p.Encrypted__c + '~' + p.Product_Class__c  + '~' ;
        strResult = strResult + p.Version__c + '~' + p.License_fee__c + '~' + p.maintenance__c  + '~' + p.Royalty_product__c + '~' + p.Royalty_Description__c + '~' + p.program__c + '~' + p.Partner_Approved__c  + '~' + p.Description  + '~' +  p.TOPS_Code__c  + '~' + p.License_metric__c     + '~' + p.Media_Language__c  + '~' + selectedCurrency + '~' +  mapPBE.get(p.id)+ '~' + p.SAP_ID__c  + '~' + p.IsActive  + '~' + p.Start_of_Life_Date__c  + '~' + p.End_Of_Life_Date__c + '~' + p.Price_Book_Authorized__c  + '\n' ;       
       }
    }
         strResult = strResult.replaceAll(',', ' ');          
         strResult = strResult.replaceAll('~', ',');          
         strResult = strResult.replaceAll('TRUE', 'Yes');          
         strResult = strResult.replaceAll('FALSE', 'No');          
         strResult = strResult.replaceAll('null', '');          

    */

PageReference excelPage = Page.ExportToExcelForPricing;
return excelPage;

}
  public string toBlank(String cont)
{
     if(cont == null) 
         cont = '';
      return cont;
}

public void emailExcel()
{
Transient String strResult ;
showEmail = true;
boolean results = true  ;
 strResult  = '';       
 
if(showifDM)
     strResult = strResult + 'Product Name~Product Family~Platform~Product Group~Sales Coverage Business Unit~Time/Capacity/NCV~Upfront Revenue Eligible~SKU~SKU Type~GEO~Status~Encrypted~Product Class~Disti Discount%~Version~License Fee~Maintenance %~Royalty Product~Royalty Description~Program~Route To Market~Disti Price~Product Description~TOPS Code~License Metric~Media Language~Currency~List Price~SAP ID~Active~Start Of Life Date~End Of Life Date~Price Book Authorized\n';
 else
    strResult = strResult + 'Product Name~Product Family~Platform~Product Group~Sales Coverage Business Unit~Time/Capacity/NCV~Upfront Revenue Eligible~SKU~SKU Type~GEO~Status~Encrypted~Product Class~Version~License Fee~Maintenance %~Royalty Product~Royalty Description~Program~Route To Market~Product Description~TOPS Code~License Metric~Media Language~Currency~List Price~SAP ID~Active~Start Of Life Date~End Of Life Date~Price Book Authorized\n';
 
   String strQuery ;
   strQuery  =  queryString.replace('License_fee__c','convertCurrency(License_fee__c)');
 
 
   List<Product2> pr= new List<Product2>();
   pr= database.query(strQuery) ;
   set<Id> prodId = new set<Id>();
   for(Integer i=0;i < pr.size(); i++)
   {
     prodId.add(pr[i].Id);
   }
    
    List<PricebookEntry> p1 = [Select UseStandardPrice, UnitPrice, ProductCode,Product2Id, Pricebook2Id, Id, CurrencyIsoCode From PricebookEntry where CurrencyIsoCode =:selectedCurrency  AND  Product2Id in : prodId];
    Map<Id,Decimal> mapPBE1  = new Map<Id,Decimal>() ;
    for(Integer i=0;i < p1.size(); i++)
    {
       mapPBE1.put(p1[i].Product2Id,p1[i].UnitPrice.setScale(2));
    }
    
 
 //for(Product2 p : database.query(queryString + ' LIMIT 1000 '  ))
   for(Integer i=0;i < pr.size(); i++)
   {      
        if(showifDM)
       {
        strResult = strResult + pr[i].name  + '~' + pr[i].Family  + '~' + pr[i].Mainframe_or_Distributed__c  + '~' + pr[i].Product_Group__c  + '~' + pr[i].Market_Focus_Area__c + '~' + pr[i].Time_Capacity_NCV__c  + '~' + pr[i].Upfront_Revenue_Eligible__c  + '~' + pr[i].SKU__c  + '~' + pr[i].SKU_Type__c + '~' + selectedRegion  + '~' + pr[i].Status__c  + '~' + pr[i].Encrypted__c + '~' + pr[i].Product_Class__c  + '~' ;
        strResult = strResult + pr[i].Disti_Discount__c  + '~' + pr[i].Version__c + '~' + pr[i].License_fee__c + '~' + pr[i].maintenance__c  + '~' + pr[i].Royalty_product__c + '~' + pr[i].Royalty_Description__c + '~' + pr[i].program__c + '~' + pr[i].Partner_Approved__c  + '~' + pr[i].Dist_Price__c  + '~' + pr[i].Description  + '~' +  pr[i].TOPS_Code__c  + '~' + pr[i].License_metric__c     + '~' + pr[i].Media_Language__c  + '~' + selectedCurrency + '~' +  mapPBE1.get(pr[i].id)+ '~' + pr[i].SAP_ID__c  + '~' + pr[i].IsActive  + '~' + pr[i].Start_of_Life_Date__c  + '~' + pr[i].End_Of_Life_Date__c + '~' + pr[i].Price_Book_Authorized__c  + '\n' ;
       }
       else
       {
        strResult = strResult + pr[i].name  + '~' + pr[i].Family  + '~' + pr[i].Mainframe_or_Distributed__c  + '~' + pr[i].Product_Group__c  + '~' + pr[i].Market_Focus_Area__c + '~' + pr[i].Time_Capacity_NCV__c  + '~' + pr[i].Upfront_Revenue_Eligible__c  + '~' + pr[i].SKU__c  + '~' + pr[i].SKU_Type__c + '~' + selectedRegion  + '~' + pr[i].Status__c  + '~' + pr[i].Encrypted__c + '~' + pr[i].Product_Class__c  + '~' ;
        strResult = strResult + pr[i].Version__c + '~' + pr[i].License_fee__c + '~' + pr[i].maintenance__c  + '~' + pr[i].Royalty_Product__c + '~' + pr[i].Royalty_Description__c + '~' + pr[i].program__c + '~' + pr[i].Partner_Approved__c  + '~' + pr[i].Description  + '~' +  pr[i].TOPS_Code__c  + '~' + pr[i].License_metric__c     + '~' + pr[i].Media_Language__c  + '~' + selectedCurrency + '~' +  mapPBE1.get(pr[i].id)+ '~' + pr[i].SAP_ID__c  + '~' + pr[i].IsActive  + '~' + pr[i].Start_of_Life_Date__c  + '~' + pr[i].End_Of_Life_Date__c + '~' + pr[i].Price_Book_Authorized__c  + '\n' ;              }
    }
 strResult = strResult.replaceAll(',', ' ');          
 strResult = strResult.replaceAll('~', ',');          
 strResult = strResult.replaceAll('TRUE', 'Yes');          
 strResult = strResult.replaceAll('FALSE', 'No');          
 strResult = strResult.replaceAll('null', '');          

 if(results == false)  
 {
        showErrorMsg = true;
        Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'No Records to Export')); 
        showSearchbutton= true;
 } 
 if(results == true)
  {
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob =   Blob.valueOf(strResult);
        string csvname= 'Pricing.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {toList};
        
        String[] ccAddresses = new list<string>() ;
        ccAddresses  = ccList.split(';'); 
        String subject1 = subject;
        if(subject1 == null)
        subject1  = 'Pricing';
        email.setSubject(subject1 );
        if(toList!= null)
        email.setToAddresses( toAddresses );
        if(ccList != null)
        email.setCcAddresses(ccAddresses);
        if(body == null)
          body = 'Pricing' ; 
        email.setPlainTextBody(body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        if (r.get(0).isSuccess())
        {
        showErrorMsg = true;
        Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.CONFIRM,'Mail Sent')); 
        showSearchbutton= false;
        }
        else
        {
        showErrorMsg = true;
        Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Mail not sent')); 
        showSearchbutton= true;
        }
              showEmail=false;
        
  }


}

public void getReferenceData(){

     System.debug('get Reference data!!!!');
     programList = new List<SelectOption>();
     programList.add( new SelectOption('0', '--None--'));
     programList.add( new SelectOption('OLP', 'OLP'));
     programList.add( new SelectOption('GLP', 'GLP'));
     programList.add( new SelectOption('SAP', 'SAP'));
     programList.add( new SelectOption('TOPS', 'TOPS'));
     
     regionList = new List<SelectOption>();

     regionList.add( new SelectOption('NA', 'NA'));
     regionList.add( new SelectOption('LA', 'LA'));
     regionList.add( new SelectOption('EMEA', 'EMEA'));
     regionList.add( new SelectOption('APJ', 'APJ'));
     //US467148 - FY19, New Geo Location added
     regionList.add( new SelectOption('PS/CAN', 'PS/CAN'));
     //US467148 - change ended
     
     skuTypeList = new List<SelectOption>();
     skuTypeList.add( new SelectOption('0', '--None--'));
     skuTypeList.add( new SelectOption('Competitive Upgrade', 'Competitive Upgrade'));
     skuTypeList.add( new SelectOption('Full/Boxed', 'Full/Boxed'));
     skuTypeList.add( new SelectOption('Maintenance', 'Maintenance'));
     skuTypeList.add( new SelectOption('Media Kit', 'Media Kit'));
     skuTypeList.add( new SelectOption('Services', 'Services'));
     skuTypeList.add( new SelectOption('Version Upgrade', 'Version Upgrade'));
   
     

     RTMList= new List<SelectOption>();
     RTMList.add( new SelectOption('0', '--None--'));
    if(PartnerAccount != null)
    {
     if (PartnerAccount[0].Alliance__c == true)       
          RTMList.add(new SelectOption('Alliance', 'Alliance'));
     if (PartnerAccount[0].Service_Provider__c == true) 
          RTMList.add(new SelectOption('Service Provider','Service Provider')); 
            
     if (PartnerAccount[0].Solution_Provider__c == true) 
                RTMList.add(new SelectOption('Solution Provider','Solution Provider')); 
     }
     
     SKUList = new List<SelectOption>();
     SKUList.add( new SelectOption('0', '--None--'));
     
       currenciesList= new list<SelectOption>();

      Schema.sObjectType objType = Account.getSObjectType(); 
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      list<Schema.PicklistEntry> values =
         fieldMap.get('CurrencyIsoCode').getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : values)
      { 
         currenciesList.add(new SelectOption(a.getValue(),a.getLabel())); 
      }
    
}

public void getSKUList(){
   }
public void showEmailSection()
{
   if(Usercontact[0].Do_Not_Email__c  == true)
   {
        showEmail =  false;
        Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.WARNING,'Partner has Do not email option  checked.')); 
            showErrorMsg = true;
            
   }
  else
    showEmail = true ;
}
public void calldoSearch1()
{
    if(currentUserAccount.Profile.Name  == 'Partner Champion')
    {
       showExport = true;
    }
    else
    {
      showExport=false;
    }
  OffsetCount = 0;
  doSearch();
}
public void doSearch(){
   

   showResultsBlock = true;

  showemail = false;   
  searchResults.clear();
  showErrorMsg = false;
  showExport = true;
  
 
    queryString = 'select Name,Family,Mainframe_or_Distributed__c,Product_Group__c,Market_Focus_Area__c,Time_Capacity_NCV__c,Upfront_Revenue_Eligible__c,SKU__c,SKU_Type__c,Region__c,Status__c,Encrypted__c,Product_Class__c,Disti_Discount__c,Version__c,License_fee__c,maintenance__c,Royalty_product__c,Royalty_Description__c,program__c,Dist_Price__c,Description,TOPS_Code__c,License_metric__c,Media_Language__c,CurrencyIsoCode,SAP_ID__c,IsActive,Start_of_Life_Date__c,End_Of_Life_Date__c,Price_Book_Authorized__c,Partner_Approved__c from product2 p where Salesforce_CPQ_Product__c=false and IsActive=true and Price_Book_Authorized__c=true  and  Id in (Select Product2Id From PricebookEntry where CurrencyIsoCode =:selectedCurrency) ';

      showResultsBlock = true;
      boolean flag = false;
    if(selectedProductName != null && selectedProductName.length() > 0 && selectedProductName!= '0')        
            queryString = queryString + ' And Name LIKE' + '\''+selectedProductName+ '%'+'\'';
        
      if( selectedBU != null && selectedBU.length() > 0 && selectedBU != '0')        
            queryString = queryString + ' AND Market_Focus_Area__c= ' + '\''+selectedBU +'\'';
        
      if( selectedPG != null && selectedPG.length() > 0 && selectedPG != '0' )        
        queryString = queryString + ' AND Product_Group__c=' + '\''+ selectedPG  +'\'';
        
      else      
        queryString = queryString + ' AND Product_Group__c in ('+     ProductGroupsForSearch  + ')' ;
      
      //if( selectedCurrency != null && selectedCurrency.length() > 0 && selectedCurrency != '0')        
       //     queryString = queryString + ' AND CurrencyIsoCode = ' + '\''+ selectedCurrency  +'\'';

      if( selectedRegion != null && selectedRegion.length() > 0 && selectedRegion != '0'  )        
            queryString = queryString + ' AND Region_Territory__c INCLUDES(' + '\''+selectedRegion +'\')';
      
      
       if( selectedProgram != null && selectedProgram.length() > 0 && selectedProgram != '0' )
            queryString = queryString + ' AND program__c= ' + '\''+selectedProgram+'\'';
      
       if( selectedSKU != null && selectedSKU.length() > 0 && selectedSKU != '0')
            queryString = queryString + ' AND SKU__c like' + '\'%'+selectedSKU + '%\'';

      if( selectedSKUType != null && selectedSKUType.length() > 0  && selectedSKUType != '0')
            queryString = queryString + ' AND SKU_Type__c= ' + '\''+selectedSKUType+'\'';
       
       if( selectedRTMType!= null && selectedRTMType.length() > 0  && selectedRTMType != '0')    
            queryString = queryString + ' AND Partner_Approved__c INCLUDES(' + '\''+ selectedRTMType +'\')';
      
      System.debug(queryString);
      Decimal temp = 200;
       set<Id> ids = new set<Id>();
    List<Product2>  p = new List<Product2>();
    p = database.query(queryString + ' limit ' + temp + ' OFFSET ' + OffsetCount );
    
   String  AggQueryString = queryString.replace('select Name,Family,Mainframe_or_Distributed__c,Product_Group__c,Market_Focus_Area__c,Time_Capacity_NCV__c,Upfront_Revenue_Eligible__c,SKU__c,SKU_Type__c,Region__c,Status__c,Encrypted__c,Product_Class__c,Disti_Discount__c,Version__c,License_fee__c,maintenance__c,Royalty_product__c,Royalty_Description__c,program__c,Dist_Price__c,Description,TOPS_Code__c,License_metric__c,Media_Language__c,CurrencyIsoCode,SAP_ID__c,IsActive,Start_of_Life_Date__c,End_Of_Life_Date__c,Price_Book_Authorized__c,Partner_Approved__c', 'select count(Id)  noOfprods  ');

//get total count
  LIST<AggregateResult> totProducts = new LIST<AggregateResult> ();
  totProducts = database.query(AggQueryString);
  totRecordCount = Integer.valueOf(totProducts[0].get('noOfprods'));


if(totRecordCount <= 200)
{
   showNext = false;
   showPrevious = false;
}
if((OffsetCount+200) <= totRecordCount)
{
   showNext = true;
}
else
{
  showNext = false;
}


   for(Integer i=0;i< p.size();i++)
   {
     ids.add(p[i].Id);
   }
    
    List<PricebookEntry> p1 = [Select UseStandardPrice, UnitPrice, ProductCode,Product2Id, Pricebook2Id, Id, CurrencyIsoCode From PricebookEntry where CurrencyIsoCode =:selectedCurrency  AND  Product2Id in : ids ];
    mapPBE  = new Map<Id,Decimal>() ;
    for(Integer i=0;i < p1.size(); i++)
    {
       mapPBE.put(p1[i].Product2Id,p1[i].UnitPrice.setScale(2));
    }
     
   for(Integer i=0;i< p.size();i++)
  {
       ProductWrapperCls pwc = new ProductWrapperCls(p[i]);            
       pwc.salesPrice = String.valueOf(mapPBE.get(p[i].id));
       searchResults.add(pwc);
  }
  
  if(searchResults.size() == 0  || searchResults == null)
  {
      Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.WARNING,'Please refine your search or contact you CA Account Manager')); 
       showErrorMsg = true;
           showResultsBlock = false;
           showExport = false;
  }

}
public void ExportExcel()
{
      toList = currentUserAccount.Email;
      PageReference pageRef= new PageReference('/{!$Site.prefix}/apex/ExportToExcelForPricing?queryString =' + queryString );
        //pageRef.setRedirect(false);        
}
public void ProductAlignment()
{
    User u = [Select id, contactid, accountid from user where id=:Userinfo.getUserId()];
    set<string> setpg = new set<string>();
    set<string> setbu = new set<string>();

    
    if(u.accountid <> null)
     {
         lstPA= [Select p.Related_Account__c, p.Product_Group__c, p.Id, p.Business_Unit__c, p.Authorized_Agreement__c From Product_Alignment__c p 
            WHERE Related_Account__c =: u.accountid and Authorized_Agreement__c = true];
        
        if(lstPA ==null || lstPA.size()== 0 )
         {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.WARNING,'As there is no product alignment record maintained for the account, search shall not display any search results.'));
            showErrorMsg = true;
            showSearchbutton= true;
         }
        ProductGroupsForSearch   = '';
        for(Product_Alignment__c pa:lstPA)
        {
            setpg.add(pa.Product_Group__c);
            setbu.add(pa.Business_Unit__c);
            ProductGroupsForSearch  = ProductGroupsForSearch  + '\'' + pa.Product_Group__c + '\',';
        }
         ProductGroupsForSearch   = ProductGroupsForSearch   + '\' \' ';
     }
     

     List<String> sortedPg = new List<String>();
     List<String> sortedBu = new List<String>();
     sortedPg.addAll(setpg);
     sortedPg.sort();
     sortedBu.addAll(setbu);
     sortedBu.sort();
     
     productGroupList = new List<SelectOption>();
     productGroupList.add( new SelectOption('0', '--None--'));
     
     businessUnitList = new List<SelectOption>();
     businessUnitList.add( new SelectOption('0', '--None--'));
     
     for( String businessUnit : sortedBu){
        if( businessUnit != null )
         businessUnitList.add( new SelectOption(businessUnit, businessUnit));
     }
     
     
     //system.debug( 'productGroupList'+ productGroupList.size());
     system.debug('businessUnitList' + businessUnitList.size());
     
}


public void ProductGroupsPick()
{

    User u = [Select id, contactid, accountid from user where id=:Userinfo.getUserId()];
    set<string> setpg = new set<string>();
        
    if(u.accountid <> null)
     {
        Product_Alignment__c[] lstPA= [Select p.Related_Account__c, p.Product_Group__c, p.Id, p.Business_Unit__c, p.Authorized_Agreement__c From Product_Alignment__c p 
            WHERE Related_Account__c =: u.accountid and Authorized_Agreement__c = true];
        
        for(Product_Alignment__c pa:lstPA)
        {
              if(pa.Business_Unit__c  == selectedBU)
              setpg.add(pa.Product_Group__c);
        }            
     }
     

     List<String> sortedPg = new List<String>();
     sortedPg.addAll(setpg);
     sortedPg.sort();
     
     productGroupList = new List<SelectOption>();
     productGroupList.add( new SelectOption('0', '--None--'));
     
     
     for( String productGroup : sortedPg){
        if( productGroup != null)
        productGroupList.add( new SelectOption(productGroup, productGroup));
     }
     getSKUList();
     
}





public void doClear()
{
 // clearing the search results  
 searchResults.clear();
showResultsBlock = false;
showEmail= false;
tolist ='';
cclist='';
subject = '';
body = '';
// clearing the search criteria 
selectedProgram = '';
selectedRegion='';
selectedSKUType='';
selectedProductName='';
selectedSKU='';
selectedPG ='';
selectedBU ='';
selectedRTMType = '';
selectedCurrency = currentUserAccount.CurrencyIsoCode;
//prod.CurrencyIsoCode = initialCurrncyVal;


}

/*public static TestMethod void testSearch(){


}
public static TestMethod void testSelect(){


}*/

}