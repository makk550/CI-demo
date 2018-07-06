@istest(SeeAllData=true)
public class Ext_SearchProductTest{

public static Quote preTestMethod(){
    Contact contact = new Contact(lastName='vinay kurudi');
         insert contact;
         
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
   
        Account acc = new Account(Name='Test_Acc1',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');
       insert acc;
       
       Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
       Opportunity opp = new Opportunity(AccountId=acc.Id,Reseller__c=acc.Id,Name='Opp1',Type='DM',RecordTypeId=oppRecId,CloseDate=System.today()+3,StageName=Label.Opp_Stage_Closed_Won,Initial_Billing__c=2);       
       insert opp; 
   
      Product2 product= new Product2(Name='Prd1',SKU__c = 'CAAAVM1600W00C6', Family='Product',Market_Focus_Area__c='Test1',IsActive=true);
        //Product2 prd2 = new Product2(Name='Prd2', Family='Time',Market_Focus_Area__c='Test2',IsActive=true);
        
       // Product2[] prd = new Product2[]{prd1,prd2};
        insert product;
     // Pricebook2 pb = new Pricebook2();
     // pb = [Select Id from Pricebook2 where IsStandard=true];
        
       // PricebookEntry pbe1 = new PricebookEntry(Product2Id=prd[0].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true); 
       
      List<PriceBook2>pb = [Select Id from Pricebook2 ];
     PriceBookEntry pr1 = new PriceBookEntry();
        // pr1.PRICEBOOK2ID = '01s30000000602WAAQ';
        pr1.PRICEBOOK2ID  = pb.get(0).id;
         pr1.PRODUCT2ID = product.id;
         pr1.CURRENCYISOCODE = 'USD';
         pr1.UNITPRICE = 222;
         pr1.ISACTIVE = true;
         pr1.USESTANDARDPRICE = false;
         insert pr1;
         
             PriceBookEntry pr2 = new PriceBookEntry();
        // pr2.PRICEBOOK2ID = '01s30000000602WAAQ';
        pr2.PRICEBOOK2ID  = pb.get(1).id;
         pr2.PRODUCT2ID = product.id;
         pr2.CURRENCYISOCODE = 'USD';
         pr2.UNITPRICE = 222;
         pr2.ISACTIVE = true;
         pr2.USESTANDARDPRICE = false;
         insert pr2;
         
          Quote quote = new Quote();
         quote.Name = 'test opp';
         quote.EU_Name__c = contact.id;
         quote.Reseller_Name__c  = contact.id;
         quote.Disti_Name__c  = contact.id;
         quote.OpportunityId= opp.id;
         quote.Pricebook2Id =pb.get(1).id;
         insert quote;
         
         return quote;
}
    @istest(SeeAllData=true) 
    public static void searchProductsTest(){
       try{
          
          
       ApexPages.StandardController sc = new ApexPages.StandardController( preTestMethod() );
       Ext_SearchProduct ext_searchProdcutMock = new Ext_SearchProduct(sc);  
       ext_searchProdcutMock.doSearch(); 
       
       }catch( Exception ex){
       
       }
    
    }
    public static void searchProductsWithAllValuesTest(){
        try{
           
       ApexPages.StandardController sc = new ApexPages.StandardController(preTestMethod() );
       Ext_SearchProduct ext_searchProdcutMock = new Ext_SearchProduct(sc); 
       ext_searchProdcutMock.selectedProgram ='OLP'; 
       ext_searchProdcutMock.selectedRegion ='NA';
       ext_searchProdcutMock.selectedSKUType = 'Full';
       ext_searchProdcutMock.selectedSKU  = 'GMRD2DW1W010FG';
       ext_searchProdcutMock.selectedPG  = 'ArcD2D';
       ext_searchProdcutMock.selectedBU = 'Alliance';
       ext_searchProdcutMock.doSearch();
        
        
    }catch( Exception ex ){}
        
    }
    
   @istest(SeeAllData=true)
    public static void getReferencedataTest(){
       try{
           
           ApexPages.StandardController sc = new ApexPages.StandardController(preTestMethod() );
           Ext_SearchProduct ext_searchProdcutMock = new Ext_SearchProduct(sc);
          ext_searchProdcutMock.getReferenceData();
       
       
       }catch( Exception ex){}
    
    }
    
    @istest(SeeAllData=true)
    public static void getSKUListTest(){
       try{
           
           ApexPages.StandardController sc = new ApexPages.StandardController(preTestMethod() );
           Ext_SearchProduct ext_searchProdcutMock = new Ext_SearchProduct(sc);
          ext_searchProdcutMock.getSKUList();
       
       }catch( Exception ex){}
    
    }
    
   @istest(SeeAllData=true)
    public static void doSelectTest(){
        try{
            
           ApexPages.StandardController sc = new ApexPages.StandardController(preTestMethod() );
           Ext_SearchProduct ext_searchProdcutMock = new Ext_SearchProduct(sc);
            ext_searchProdcutMock.doSearch(); 
            system.debug('search results '+ ext_searchProdcutMock.searchResults.size());
            if(  ext_searchProdcutMock.searchResults != null &&  ext_searchProdcutMock.searchResults.get(0) != null )
                 ext_searchProdcutMock.searchResults.get(0).isSelected = true;
              ext_searchProdcutMock.doSelect();
        
        
        }catch(Exception ex){}
    
    }
    
    @istest(SeeAllData=true)
    public static void productAlignmentTest(){
        try{
             
           ApexPages.StandardController sc = new ApexPages.StandardController(preTestMethod() );
           Ext_SearchProduct ext_searchProdcutMock = new Ext_SearchProduct(sc);
          ext_searchProdcutMock.ProductAlignment();
        
        }catch(Exception ex ){}
    
    }
    

}