/*
Redesign the whole structure based on US371683
*/
public class productAreaControllerExtension{
    public Product_Area__c productArea;
    public List<CA_Product_Component__c> listOfCaProductComp{get;set;}
    public String productName{get;set;}
    public Id productId{get;set;}
    public Boolean showDefault{get;set;}
    public String defaultComp{get;set;}
    public String refreshPrev{get;set;}
    public String productAreaName{get;set;}
    public List<CA_Product_Component__c> listForErrorMsg{get;set;}
    
    public productAreaControllerExtension(ApexPages.StandardController standardCtrl){
        showDefault = true;
        listOfCaProductComp = new List<CA_Product_Component__c>();
        this.productArea = (Product_Area__c)standardCtrl.getRecord();
        refreshPrev = '';
        
        List<Product_Area__c> productAreaObj = [Select id, CA_Product__c, Name, CA_Product__r.Name, Default_Group_Component__c from Product_Area__c where Id=:this.productArea.id limit 1];
        system.debug('*****'+productAreaObj);
        if(productAreaObj<>null && productAreaObj.size()>0 && String.isNotBlank(productAreaObj[0].CA_Product__c) && String.isNotBlank(productAreaObj[0].CA_Product__r.Name) && String.isNotBlank(productAreaObj[0].Name)){
            productName = productAreaObj[0].CA_Product__r.Name;
            productId = productAreaObj[0].Id;
            productAreaName = productAreaObj[0].Name;
            if(String.isNotBlank(productAreaObj[0].Default_Group_Component__c)){
                defaultComp = productAreaObj[0].Default_Group_Component__c;
                showDefault = false;    
            }
            if(String.isNotBlank(defaultComp)){
                List<CA_Product_Component__c> listOfComp = [Select id from CA_Product_Component__c where CA_Product_Controller__c=:productAreaObj[0].CA_Product__c AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null) order by Component_Code__c asc];
                if(listOfComp<>null && listOfComp.size()>0){
                    set<Id> compId = new set<Id>();
                    for(CA_Product_Component__c compObj:listOfComp){
                        compId.add(compObj.Id);
                    }
                    List<Product_Area_Components__c> listOfPAC = [Select CA_Product_Component__c from Product_Area_Components__c where Product_Area__c=:productId];
                    
                    if(listOfPAC<>null && listOfPAC.size()>0){
                        for(Product_Area_Components__c pacObj:listOfPAC){
                            if(compId.contains(pacObj.CA_Product_Component__c)){
                                compId.remove(pacObj.CA_Product_Component__c);
                            }
                        }
                        if(compId<>null && compId.size()>0){
                        	listOfCaProductComp = [Select id, Name, Component_Code__c from CA_Product_Component__c where CA_Product_Controller__c=:productAreaObj[0].CA_Product__c AND Id IN:compId AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null) order by Component_Code__c asc];
                        }
                    }
                }
            }else{
            	listOfCaProductComp = [Select id, Name, Component_Code__c from CA_Product_Component__c where CA_Product_Controller__c=:productAreaObj[0].CA_Product__c AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null) order by Component_Code__c asc];
            }
            listForErrorMsg = [Select id from CA_Product_Component__c where CA_Product_Controller__c=:productAreaObj[0].CA_Product__c AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null) limit 1];
        }
    }
    
    public pageReference submitRecords(){
        List<String> listOfName = (List<String>)JSON.deserialize(System.currentPagereference().getParameters().get('selectedRecords'), List<String>.class);
        String defaultComponent = System.currentPagereference().getParameters().get('defaultRecords');
        Set<String> setOfComponentIds = new Set<String>();
        List<Product_Area__c> listOfPA = new List<Product_Area__c>();
        if(listOfName<>null && listOfName.size()>0){
            for(String singleId:listOfName){
                if(singleId.contains('allId_select_')){
                    List<String> splitString = singleId.split('allId_select_');
                    if(String.isNotBlank(splitString[1])){
                        setOfComponentIds.add(splitString[1]);
                    }
                }
            }
        }
        
        system.debug('defaultComponent: '+defaultComponent);
        if(String.isNotBlank(defaultComponent)){
            setOfComponentIds.add(defaultComponent);
            Product_Area__c updateProductArea = new Product_Area__c(Id=productId);
            updateProductArea.Default_Group_Component__c = defaultComponent;
            listOfPA.add(updateProductArea);
        }
        system.debug('listOfPA: '+listOfPA);
        
        if(setOfComponentIds<>null && setOfComponentIds.size()>0){
            Boolean componentFlag = false;
            List<Product_Area_Components__c> updateList = new List<Product_Area_Components__c>();
            List<Product_Area_Components__c> listOfPAC = [Select id, Product_Area__c, CA_Product_Component__c from Product_Area_Components__c where Product_Area__c=:productId];
            
            if(listOfPAC<>null && listOfPAC.size()>0){
                Set<String> setOfPAC = new Set<String>();
                
                for(Product_Area_Components__c pacObj:listOfPAC){
                    setOfPAC.add(pacObj.CA_Product_Component__c);
                }
                
                if(setOfPAC<>null && setOfPAC.size()>0){
                    for(String existObj:setOfComponentIds){
                        if(setOfPAC.contains(existObj)){
                        }else{
                            Product_Area_Components__c newObj = new Product_Area_Components__c();
                            newObj.CA_Product_Component__c = existObj;
                            newObj.Product_Area__c = productId;
                            updateList.add(newObj); 
                        }
                    }
                }
            }else{
                for(String newCompObj:setOfComponentIds){
                    Product_Area_Components__c newObj = new Product_Area_Components__c();
                    newObj.CA_Product_Component__c = newCompObj;
                    newObj.Product_Area__c = productId;
                    updateList.add(newObj);
                } 
            }
            if(updateList<>null && updateList.size()>0 && !componentFlag){
                try{
                    Database.insert(updateList);
                    componentFlag = true;
                }Catch(DMLException e){system.debug('%%%UPDATE COMPONENT FAILED--->'+e.getMessage());}
            }
            
            if(componentFlag && listOfPA<>null && listOfPA.size()>0){
                try{
                    Database.update(listOfPA);
                    refreshPrev = 'Yes';
                    return new PageReference('/'+productId);
                }Catch(DMLException e){system.debug('%%%UPDATE Product Area FAILED'+e.getMessage());}
            }
        }
        return null;    
    }
    
    public pageReference cancelRecords(){
        return new PageReference('/'+productId);
    }
}