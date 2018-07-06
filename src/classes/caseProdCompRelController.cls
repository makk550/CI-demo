public class caseProdCompRelController {
public String productName{get;set;}
public Id accId{get;set;}
public String searchProd {get; set;}
    
    

public caseProdCompRelController(ApexPages.StandardController controller)
{
    
    
}
public caseProdCompRelController()
{
    
    
}

@RemoteAction
public static List<CA_Product_Controller__c> searchProdControllerList(String searchProd ) {
        list<CA_Product_Controller__c >accList = new list<CA_Product_Controller__c >();
        if(searchProd != ''){
            accList = [ Select Name From CA_Product_Controller__c WHERE Name LIKE :'%' + String.escapeSingleQuotes(searchProd ) + '%' ] ;
           // accList = database.query(query);
        }    
        return accList;
}
    
}