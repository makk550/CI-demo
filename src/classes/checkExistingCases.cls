//US341391: On Create of a Portal Case default the product data to the same as the last case created, if case exists for CA Product/SiteID
//new modified user story - US367725 and 
public class checkExistingCases{     
    
    public static String checkOldExistingCases(String siteAssociation, String caProduct, String productArea){
        if(String.isNotBlank(siteAssociation) && String.isNotBlank(caProduct) && String.isNotBlank(productArea)){
            String caseCommentString = '';
            List<Case> listOfCase = [Select Id,CA_Product_Component__c, CA_Product_Controller__r.Name, CA_Product_Component__r.Component_Code__c, Product_Material__c, Product_Material__r.Name, casenumber, Product_Release__c, Product_Service_Pack__c, Alternate_OS__c from Case where Site_Association__c=:siteAssociation AND CA_Product_Controller__c=:caProduct AND Product_Area__c=:productArea order by caseNumber desc limit 1];
            if(listOfCase<>null && listOfCase.size()>0){
               
                caseCommentString += '*Reference Case = '+ listOfCase[0].casenumber;
                if(String.isNotBlank(listOfCase[0].CA_Product_Controller__r.Name)){
                  caseCommentString +='\nCA Product = '+listOfCase[0].CA_Product_Controller__r.Name;    
                }
                
                if(String.isNotBlank(listOfCase[0].Product_Material__c) && String.isNotBlank(listOfCase[0].Product_Material__r.Name)){
                    caseCommentString +='\nProduct Code = '+listOfCase[0].Product_Material__r.Name;    
                }
                
                if(String.isNotBlank(listOfCase[0].Product_Release__c)){
                   caseCommentString +='\nProduct Release ='+listOfCase[0].Product_Release__c;    
                }
                
                if(String.isNotBlank(listOfCase[0].CA_Product_Component__c) && String.isNotBlank(listOfCase[0].CA_Product_Component__r.Component_Code__c)){
                  caseCommentString +='\nComponent Code = '+listOfCase[0].CA_Product_Component__r.Component_Code__c;    
                }
                caseCommentString += '\n'+System.Label.CC_ReferenceCase;
                return caseCommentString;
            }else{
                
                List<Case> listOfOldCase = [Select Id,CA_Product_Component__c, CA_Product_Controller__r.Name, CA_Product_Component__r.Component_Code__c, Product_Material__c, Product_Material__r.Name, casenumber, Product_Release__c, Product_Service_Pack__c, Alternate_OS__c from Case where Site_Association__c=:siteAssociation AND CA_Product_Controller__c=:caProduct order by caseNumber desc limit 1];
                if(listOfOldCase<>null && listOfOldCase.size()>0){
                    caseCommentString += '*Reference Case = '+ listOfOldCase[0].casenumber+' was found';
                    if(String.isNotBlank(listOfOldCase[0].CA_Product_Controller__r.Name)){
                        caseCommentString +='\nCA Product = '+listOfOldCase[0].CA_Product_Controller__r.Name;    
                    }
                    
                    if(String.isNotBlank(listOfOldCase[0].Product_Material__c) && String.isNotBlank(listOfOldCase[0].Product_Material__r.Name)){
                        caseCommentString +='\nProduct Code = '+listOfOldCase[0].Product_Material__r.Name;    
                    }
                    
                    if(String.isNotBlank(listOfOldCase[0].Product_Release__c)){
                        caseCommentString +='\nProduct Release ='+listOfOldCase[0].Product_Release__c;    
                    }
                    
                    if(String.isNotBlank(listOfOldCase[0].CA_Product_Component__c) && String.isNotBlank(listOfOldCase[0].CA_Product_Component__r.Component_Code__c)){
                        caseCommentString +='\nComponent Code = '+listOfOldCase[0].CA_Product_Component__r.Component_Code__c;    
                    }
                    caseCommentString += '\n'+System.Label.CC_ReferenceCase;
                    return caseCommentString;
                }else{
                    List<Product_Area__c> listOfPA = [Select Default_Group_Component__c from Product_Area__c where id=:productArea AND (Default_Group_Component__c!=:'' OR Default_Group_Component__c!=:null) limit 1];
                    if(listOfPA<>null && listOfPA.size()>0 && String.isNotBlank(listOfPA[0].Default_Group_Component__c)){
                       caseCommentString = 'No Prior case was found to display previous case product information';
                       return caseCommentString;
                    }else{
                       return ''; 
                    }
                }   
            }
        }   
        return '';
    }
    
    public static string defaultComponent(String productArea){
       List<Product_Area__c> listOfPA = [Select Default_Group_Component__c from Product_Area__c where id=:productArea AND (Default_Group_Component__c!=:'' OR Default_Group_Component__c!=:null) limit 1];
        if(listOfPA<>null && listOfPA.size()>0 && String.isNotBlank(listOfPA[0].Default_Group_Component__c)){
            return listOfPA[0].Default_Group_Component__c;
        }
        return '';
    }
}