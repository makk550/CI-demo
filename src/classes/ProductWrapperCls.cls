public class ProductWrapperCls{

public boolean isSelected{get; set;}
public String salesPrice {get;set;}
public String qty {get;set;}
public String discount {get;set;}
public String addtDiscount {get;set;}
public Product2 cProduct{get; set;}
public String listPrice {get;set;}
public String suggestedListPrice {get;set;}
public String distPrice {get;set;}
public ID priceBookEntryId {get;set;}
public ProductWrapperCls( Product2 product2){
    this.cProduct = product2;
    if(  product2.Disti_Discount__c != null ){
        this.discount =String.valueOf( product2.Disti_Discount__c);
    }
    
}

}