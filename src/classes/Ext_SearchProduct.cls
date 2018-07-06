public class Ext_SearchProduct
{

public String cusSearchString{ get; set;} 
public List<ProductWrapperCls> searchResults{get;set;}

public String initialCurrncyVal{get;set;}
public boolean showErrorMsg{get;set;}
public List<SelectOption> programList {get; set;}
public String selectedProgram{ get; set;}
public String selectedRegion {get;set;}
public List<SelectOption> regionList {get; set;}
public Product2 prod {get;set;}
public List<SelectOption> skuTypeList {get; set;}
public String selectedSKUType{get;set;}
public Quote quote {get;set;}
public String selectedProductName{get;set;}

public String selectedSKU {get;set;}
public List<SelectOption> SKUList {get; set;}
public List<Product2> product_SKUList {get; set;}

public String productName {get;set;}

public List<SelectOption> productGroupList {get; set;}
public List<SelectOption> businessUnitList {get; set;}
public String selectedPG {get;set;}
public String selectedBU {get;set;}
public  List<PriceBook2> pricebook2List {get;set;}

public Ext_SearchProduct(apexpages.standardController std)
{
    prod = new Product2();
    quote = (Quote)std.getRecord();
    system.debug('opp currency: '+ quote.CurrencyIsoCode );
    prod.CurrencyIsoCode = quote.CurrencyIsoCode;
    getReferenceData();
    searchResults = new List<ProductWrapperCls>();
    ProductAlignment();
    pricebook2List = [Select p.Name, p.Id From Pricebook2 p];
     if(pricebook2List != null && pricebook2List.get(1) != null){
          quote.Pricebook2Id = pricebook2List.get(1).Id;
           
      }
      
      // this initial value going to use in clear method
      initialCurrncyVal = prod.CurrencyIsoCode;
      showErrorMsg = false;
}

public void getReferenceData(){

     programList = new List<SelectOption>();
     programList.add( new SelectOption('0', '--None--'));
     programList.add( new SelectOption('OLP', 'OLP'));
     programList.add( new SelectOption('GLP', 'GLP'));
     programList.add( new SelectOption('SAP', 'SAP'));
     programList.add( new SelectOption('TOPS', 'TOPS'));
     
     regionList = new List<SelectOption>();
     regionList.add( new SelectOption('0', '--None--'));
     regionList.add( new SelectOption('NA', 'NA'));
     //sunji03 - FY19, PS/CAN GEO is added
     regionList.add( new SelectOption('PS/CAN', 'PS/CAN'));
     regionList.add( new SelectOption('LA', 'LA'));
     regionList.add( new SelectOption('EMEA', 'EMEA'));
     regionList.add( new SelectOption('APJ', 'APJ'));
     
     skuTypeList = new List<SelectOption>();
     skuTypeList.add( new SelectOption('0', '--None--'));
     skuTypeList.add( new SelectOption('Competitive Upgrade', 'Competitive Upgrade'));
     skuTypeList.add( new SelectOption('Full/Boxed', 'Full/Boxed'));
     skuTypeList.add( new SelectOption('Maintenance', 'Maintenance'));
     skuTypeList.add( new SelectOption('Media Kit', 'Media Kit'));
     skuTypeList.add( new SelectOption('Services', 'Services'));
     skuTypeList.add( new SelectOption('Version Upgrade', 'Version Upgrade'));
     
     SKUList = new List<SelectOption>();
     SKUList.add( new SelectOption('0', '--None--'));
     
}

public void getSKUList(){
    system.debug('getSKUList started...'+prod.Product_Group__c);
    
    SKUList.clear();
    SKUList.add( new SelectOption('0', '--None--'));
   
    boolean flag = false;
    String queryString ='select SKU__c,Market_Focus_Area__c,Product_Group__c,Region_Territory__c,program__c,SKU_Type__c from Product2 p ';
      if( selectedBU != null && selectedBU.length() > 0 && selectedBU != '0'){
        if( flag){ 
            String test = 
            queryString = queryString + ' p.Market_Focus_Area__c= ' + '\''+selectedBU +'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.Market_Focus_Area__c=' + '\'' + selectedBU +'\'' ;
        }
        
        flag = true;
      }
      if( selectedPG != null && selectedPG.length() > 0 && selectedPG != '0' ){
        
         if( flag){
        queryString = queryString + ' AND p.Product_Group__c=' + '\''+ selectedPG  +'\'';
         }
         else
         {
            queryString = queryString + ' WHERE Salesforce_CPQ_Product__c=false and p.Product_Group__c=' + '\'' + selectedPG +'\'' ;
         }
        flag = true;
      }

      if( selectedRegion != null && selectedRegion.length() > 0 && selectedRegion != '0'  ){
        if( flag){ 
            //queryString = queryString + ' AND p.Region_Territory__c= ' + '\''+selectedRegion+'\'';
            //sunji03, the code above is wrong, retion_territory__c is a multiple select field, should be include
             queryString = queryString + ' AND p.Region_Territory__c includes ' + '(\''+selectedRegion+'\')';
        }
        else{
          //sunji03, the code above is wrong, retion_territory__c is a multiple select field, should be include
           queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.Region_Territory__c includes ' + '(\'' + selectedRegion +'\')' ;
        }
        flag = true;
      }
      
       if( selectedProgram != null && selectedProgram.length() > 0 && selectedProgram != '0' ){
        if( flag){ 
            queryString = queryString + ' AND p.program__c= ' + '\''+selectedProgram+'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c and p.program__c=' + '\'' + selectedProgram +'\'' ;
        }
        
        flag = true;
      }
      if( selectedSKUType != null && selectedSKUType.length() > 0  && selectedSKUType != '0'){
        if( flag){ 
            queryString = queryString + ' AND p.SKU_Type__c= ' + '\''+selectedSKUType+'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.SKU_Type__c=' + '\'' + selectedSKUType +'\'' ;
        }
        
        flag = true;
      }
      
      Decimal temp = 999;
       queryString = queryString + ' limit ' + temp ;
   
    Set<String> skuSet = new Set<String>();
    for (Product2 ps :database.query(queryString )  ){
        skuSet.add(ps.SKU__c);
    }
    if( skuSet != null && skuSet.size() > 0 ){
         for (String sku :skuSet ){
         system.debug('getSKUList for loop started...');
            if( sku != null && sku.length() > 0 )
            SKUList.add( new SelectOption(sku, sku ));
        }
    }
    
    system.debug('getSKUList ended...'+ SKUList.size());
}
public void doSearch(){

  searchResults.clear();
  showErrorMsg = false;
  String queryString ='Select p.SKU__c,P.Description, p.SKU_Type__c, p.Region__c, p.Dist_Price__c, p.Product_Group__c, p.Name, p.Market_Focus_Area__c, p.Id, p.program__c, p.Family, p.Disti_Discount__c, p.CurrencyIsoCode, p.Region_Territory__c From Product2 p';
  
  boolean flag = false;
  if( selectedProductName != null && selectedProductName.length() > 0 && selectedProductName!= '0'){
        if( flag){ 
            String test = 
            queryString = queryString + ' p.Name LIKE' + '\''+selectedProductName+ '%'+'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.Name LIKE' + '\'' + selectedProductName+ '%'+'\'';
        }
        
        flag = true;
      }
      if( selectedBU != null && selectedBU.length() > 0 && selectedBU != '0'){
        if( flag){ 
            String test = 
            queryString = queryString + ' AND p.Market_Focus_Area__c= ' + '\''+selectedBU +'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.Market_Focus_Area__c=' + '\'' + selectedBU +'\'' ;
        }
        
        flag = true;
      }
      if( selectedPG != null && selectedPG.length() > 0 && selectedPG != '0' ){
        
         if( flag){
        queryString = queryString + ' AND p.Product_Group__c=' + '\''+ selectedPG  +'\'';
         }
         else
         {
            queryString = queryString + ' WHERE Salesforce_CPQ_Product__c=false and p.Product_Group__c=' + '\'' + selectedPG +'\'' ;
         }
        flag = true;
      }
       //if( prod.CurrencyIsoCode != null && prod.CurrencyIsoCode.length() > 0 ){
        //if( flag){
        //queryString = queryString + ' AND p.CurrencyIsoCode='+ '\'' + prod.CurrencyIsoCode+'\'';
       // }
        //else
        //{
          //  queryString = queryString + ' WHERE p.CurrencyIsoCode='+ '\'' + prod.CurrencyIsoCode +'\'';
        //}
        //flag = true;
      //}
      if( selectedRegion != null && selectedRegion.length() > 0 && selectedRegion != '0'  ){
        if( flag){ 
            //queryString = queryString + ' AND p.Region_Territory__c= ' + '\''+selectedRegion+'\'';
            //sunji03, the code above is wrong, retion_territory__c is a multiple select field, should be include
             queryString = queryString + ' AND p.Region_Territory__c includes ' + '(\''+selectedRegion+'\')';
        }
        else{
          //sunji03, the code above is wrong, retion_territory__c is a multiple select field, should be include
           queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.Region_Territory__c includes ' + '(\'' + selectedRegion +'\')' ;
        }

        flag = true;
      }
      
       if( selectedProgram != null && selectedProgram.length() > 0 && selectedProgram != '0' ){
        if( flag){ 
            queryString = queryString + ' AND p.program__c= ' + '\''+selectedProgram+'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.program__c=' + '\'' + selectedProgram +'\'' ;
        }
        
        flag = true;
      }
      
       if( selectedSKU != null && selectedSKU.length() > 0 && selectedSKU != '0'){
        if( flag){ 
            queryString = queryString + ' AND p.SKU__c= ' + '\''+selectedSKU+'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.SKU__c=' + '\'' + selectedSKU +'\'' ;
        }
        
        flag = true;
      }
      if( selectedSKUType != null && selectedSKUType.length() > 0  && selectedSKUType != '0'){
        if( flag){ 
            queryString = queryString + ' AND p.SKU_Type__c= ' + '\''+selectedSKUType+'\'';
        }
        else{
            queryString = queryString + '  WHERE Salesforce_CPQ_Product__c=false and p.SKU_Type__c=' + '\'' + selectedSKUType +'\'' ;
        }
        
        flag = true;
      }
      System.debug(queryString);
      Decimal temp = 50;
       queryString = queryString + ' limit ' + temp ;
   for(Product2 p : database.query(queryString ))
  {
       ProductWrapperCls pwc = new ProductWrapperCls(p);
       
       System.debug('test'+p.name);
       pwc.qty = '1';
       
       String currency1 = prod.CurrencyIsoCode;
      if( currency1  == null ){
              currency1  = 'USD';
       }
        List<PricebookEntry> p1 = [Select UseStandardPrice, UnitPrice, ProductCode,
         Product2Id, Pricebook2Id, Id, CurrencyIsoCode From PricebookEntry  
         where Product2Id =:  p.id AND  CurrencyIsoCode =:currency1   AND Pricebook2Id =: quote.Pricebook2Id
         limit 1];
         if( p1 != null && p1.size()>0 &&  p1.get(0) != null ){
             pwc.suggestedListPrice = String.valueOf( p1.get(0).UnitPrice);
             pwc.salesPrice = String.valueOf( p1.get(0).UnitPrice);
             pwc.priceBookEntryId = p1.get(0).Id;
         }
         
         if( pwc.suggestedListPrice != null && pwc.suggestedListPrice.length() > 0 &&
             pwc.salesPrice != null && pwc.salesPrice.length() > 0){
              searchResults.add(pwc);
         }
        
       //Product2 p23 = [Select id,name,(Select Product2Id, CurrencyIsoCode, UnitPrice From PricebookEntries where CurrencyIsoCode =:prod.CurrencyIsoCode  AND Pricebook2Id =: quote.Pricebook2Id) From Product2 product where product.id =: p.id];
       //if( p23.PricebookEntries != null && p23.PricebookEntries.size() > 0  ){
         //pwc.suggestedListPrice = String.valueOf( p23.PricebookEntries.get(0).UnitPrice);
         //pwc.salesPrice = String.valueOf( p23.PricebookEntries.get(0).UnitPrice);
       //}
  }
  
}

public PageReference doSelect(){
    
    List<ProductWrapperCls> selectedRecords = new List<ProductWrapperCls>();
  
        if(pricebook2List != null && pricebook2List.get(1) != null){
               update quote;
        }
   
   if( searchResults != null ){
       for( ProductWrapperCls prWrapper1: searchResults){
            if( prWrapper1 != null && prWrapper1.isSelected != null && prWrapper1.isSelected ){
                 selectedRecords.add(prWrapper1);
            }
       } 
   }
     
     if( selectedRecords != null && selectedRecords.size() > 0 ){
        for( ProductWrapperCls prWrapper: selectedRecords){
            Decimal tempDiscount = 0;
            System.debug('Insertion Started' );
            QuoteLineItem qlt = new QuoteLineItem();
            qlt.Quantity = decimal.valueOf(prWrapper.qty);
            if( prWrapper.salesPrice != null && prWrapper.salesPrice.length() > 0){
                qlt.UnitPrice = decimal.valueOf(prWrapper.salesPrice);
            }else
            {
                qlt.UnitPrice = decimal.valueOf('0');
            }
           
            if( prWrapper.discount != null && prWrapper.discount.length() > 0){
                qlt.Discount_1__c = decimal.valueOf(prWrapper.discount);
                tempDiscount = decimal.valueOf(prWrapper.discount);
            }
            if( prWrapper.addtDiscount != null  && prWrapper.addtDiscount.length() > 0 ){
                qlt.Additional_Discount__c = decimal.valueOf(prWrapper.addtDiscount);
                tempDiscount = decimal.valueOf(prWrapper.addtDiscount);
                
            }
             if( prWrapper.addtDiscount != null  && prWrapper.addtDiscount.length() > 0 &&
                  prWrapper.discount != null && prWrapper.discount.length() > 0){
                
                tempDiscount = ((decimal.valueOf(prWrapper.discount)/100)+(decimal.valueOf(prWrapper.addtDiscount)/100)-(decimal.valueOf(prWrapper.discount)*decimal.valueOf(prWrapper.addtDiscount))/10000)*100;
                
            }
            qlt.Discount = tempDiscount;
            qlt.QuoteId = quote.Id;
            qlt.SKU__c = prWrapper.cProduct.SKU__C;
           // qlt.Disti__c = prWrapper.cProduct.Dist_Price__c;
           // qlt.Disti_Unit_Cost__c = prWrapper.cProduct.Dist_Price__c;
            qlt.Product_Description__c =  prWrapper.cProduct.Description;
            System.debug('Product description:@@@@@@@@@@@'+qlt.Product_Description__c);
            System.debug('prWrapper.cProduct.Product_Group__c>>>>>>>>>>'+prWrapper.cProduct.Product_Group__c);
            qlt.Business_Unit__c = prWrapper.cProduct.Product_Group__c;
            
            qlt.MSRP_Unit_Cost__c = qlt.UnitPrice;
            qlt.MSRP_total__c = qlt.UnitPrice * decimal.valueOf(prWrapper.qty);
            
            qlt.Disti__c = qlt.Disti_Unit_Cost__c;
            
            //PricebookEntry p1 = [Select p.UseStandardPrice, p.UnitPrice, p.ProductCode,
             //p.Product2Id, p.Pricebook2Id, p.Id, p.CurrencyIsoCode From PricebookEntry p 
             //where p.Product2Id =:  prWrapper.cProduct.id AND  p.CurrencyIsoCode =: quote.CurrencyIsoCode AND p.Pricebook2Id =: quote.Pricebook2Id
            // limit 1];
            // if(p1!= null){
             //   qlt.PricebookEntryId = p1.id;
             //}
             
             qlt.PricebookEntryId = prWrapper.priceBookEntryId; 
             
             System.debug('Insertion ended'+ qlt.PricebookEntryId);
            
            insert qlt;
            System.debug('Insertion ended' );
            
        }
     }
     else{
         Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Please select Product(s)'));
         showErrorMsg = true;
         return null;
     }
    
    System.debug('selectedRecords = '+selectedRecords.size() );  
    PageReference p = new PageReference('/'+quote.Id);
    return   p;
}
public PageReference doCancel(){

     PageReference p = new PageReference('/'+quote.Id);
     return   p;
}

public void ProductAlignment()
{
    User u = [Select id, contactid, accountid from user where id=:Userinfo.getUserId()];
    set<string> setpg = new set<string>();
    set<string> setbu = new set<string>();

    if(u.accountid <> null)
     {
        Product_Alignment__c[] lstPA= [Select p.Related_Account__c, p.Product_Group__c, p.Id, p.Business_Unit__c, p.Authorized_Agreement__c From Product_Alignment__c p 
            WHERE Related_Account__c =: u.accountid and Authorized_Agreement__c = true];
        
        for(Product_Alignment__c pa:lstPA)
        {
            setpg.add(pa.Product_Group__c);
            setbu.add(pa.Business_Unit__c);
        }
            
     }
     else
     {
        product2[] lstP = [select market_focus_area__c, product_group__c from Product2 where Family = 'Product' and Salesforce_CPQ_Product__c=false];
        
        for(product2 p:lstP)
        {
            setpg.add(p.Product_Group__c);
            setbu.add(p.Market_Focus_Area__c);
        }
     
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
     
     for( String productGroup : sortedPg){
        if( productGroup != null)
        productGroupList.add( new SelectOption(productGroup, productGroup));
     }
     for( String businessUnit : sortedBu){
        if( businessUnit != null )
         businessUnitList.add( new SelectOption(businessUnit, businessUnit));
     }
     system.debug( 'productGroupList'+ productGroupList.size());
     system.debug('businessUnitList' + businessUnitList.size());
     
}

public void doClear()
{
 // clearing the search results  
 searchResults.clear();

// clearing the search criteria 
selectedProgram = '';
selectedRegion='';
selectedSKUType='';
selectedProductName='';
selectedSKU='';
selectedPG ='';
selectedBU ='';
prod.CurrencyIsoCode = initialCurrncyVal;


}

public static TestMethod void testSearch(){


}
public static TestMethod void testSelect(){


}

}