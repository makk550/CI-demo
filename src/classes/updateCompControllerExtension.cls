/*
Redesign the whole structure based on US371683
*/
public class updateCompControllerExtension {
    public Product_Area__c productArea;
    public String productName{get;set;}
    public List<Product_Area_Components__c> listOfPAC{get;set;}
    public Id productId{get;set;}
    public Id productAreaId{get;set;}
    public set<Id> setOfIds{get;set;}
    public String refreshPrev{get;set;}
    public String productAreaName{get;set;}
    public List<Product_Area_Components__c> listForErrorMsg{get;set;}
    
    public updateCompControllerExtension(ApexPages.StandardController standardCtrl){
        this.productArea = (Product_Area__c)standardCtrl.getRecord();
        String idVal = ApexPages.currentPage().getParameters().get('Id');
        refreshPrev = '';
        List<Product_Area__c> productAreaObj = [Select id, CA_Product__c, Name, CA_Product__r.Name, Default_Group_Component__c from Product_Area__c where Id=:this.productArea.Id limit 1];
        if(productAreaObj<>null && productAreaObj.size()>0 && String.isNotBlank(productAreaObj[0].CA_Product__c) && String.isNotBlank(productAreaObj[0].CA_Product__r.Name) && String.isNotBlank(productAreaObj[0].Name)){
            productName = productAreaObj[0].CA_Product__r.Name;
            productId = productAreaObj[0].Default_Group_Component__c;
            system.debug('******'+productId);
            productAreaId = this.productArea.Id;
            productAreaName = productAreaObj[0].Name;
            listOfPAC = [Select id, CA_Product_Component__c, CA_Product_Component__r.Component_Code__c, CA_Product_Component__r.Name, Product_Area__c from Product_Area_Components__c where Product_Area__c=:productAreaId AND CA_Product_Component__c!=:null AND CA_Product_Component__c!=:''];
            listForErrorMsg = [Select id from Product_Area_Components__c where Product_Area__c=:productAreaId AND (CA_Product_Component__c=:null OR CA_Product_Component__c=:'')];
            if(listOfPAC<>null && listOfPAC.size()>0){
                setOfIds = new Set<Id>();
                for(Product_Area_Components__c pacObj:listOfPAC){
                	setOfIds.add(pacObj.CA_Product_Component__c);    
                }
            }
        }
    }
    
    public pageReference submitRecords(){
        List<String> listOfName = (List<String>)JSON.deserialize(System.currentPagereference().getParameters().get('selectedRecords'), List<String>.class);
        String defaultComponent = System.currentPagereference().getParameters().get('defaultRecords');
        Set<String> addNotBlankProductArea = new Set<String>();
        Set<String> addBlankProductArea = new Set<String>();
        Set<String> convertListToSet = new Set<String>();
        for(String compId:listOfName){
            if(compId.contains('allId_select_')){
                List<String> newString = compId.split('allId_select_');
                convertListToSet.add(newString[1]);
            }
        }
        
        system.debug('#@###'+listOfPAC);
        if(listOfPAC<>null && convertListToSet<>null && listOfPAC.size()>0 && convertListToSet.size()>0 && String.isNotBlank(defaultComponent)){
            Boolean setFlag = false;
            Boolean setNewFlag = false;
            for(Product_Area_Components__c compObj:listOfPAC){
                if(convertListToSet.contains(compObj.CA_Product_Component__c) || defaultComponent.equalsIgnoreCase(compObj.CA_Product_Component__c)){
                    addNotBlankProductArea.add(compObj.CA_Product_Component__c);    
                }else if(!convertListToSet.contains(compObj.CA_Product_Component__c)){
                    addBlankProductArea.add(compObj.CA_Product_Component__c);    
                }
            }
            system.debug('************'+addNotBlankProductArea);
            system.debug('****addBlankProductArea********'+addBlankProductArea);
            List<Product_Area_Components__c> updateWithoutBlankComp = new List<Product_Area_Components__c>();
            List<Product_Area_Components__c> deleteBlankComp = new List<Product_Area_Components__c>();
            if(addNotBlankProductArea<>null && addNotBlankProductArea.size()>0){
                updateWithoutBlankComp = [Select Id from Product_Area_Components__c where CA_Product_Component__c IN:addNotBlankProductArea];
            } 
            
            if(addBlankProductArea<>null && addBlankProductArea.size()>0){
               	deleteBlankComp = [Select Id from Product_Area_Components__c where CA_Product_Component__c IN:addBlankProductArea];
             }
            
            if(deleteBlankComp<>null && deleteBlankComp.size()>0 && !setFlag){
                try{
                    Database.delete(deleteBlankComp);
                    setFlag = true;
                }Catch(DMLException e){system.debug('Comp Delete Failed----->'+e.getMessage());}    
            }
            
            if(updateWithoutBlankComp<>null && updateWithoutBlankComp.size()>0 && !setNewFlag){
                try{
                    Database.update(updateWithoutBlankComp);
                    setNewFlag = true;
                }Catch(DMLException e){system.debug('Comp Update Failed----->'+e.getMessage());} 
            }
            
            if(String.isNotBlank(defaultComponent) && (setFlag || setNewFlag)){
                List<Product_Area__c> listOfPA = new List<Product_Area__c>();
                Product_Area__c updateProductArea = new Product_Area__c(Id=productAreaId);
                updateProductArea.Default_Group_Component__c = defaultComponent;
                listOfPA.add(updateProductArea);
                
                if(listOfPA<>null && listOfPA.size()>0){
                    try{
                        Database.update(listOfPA);
                        refreshPrev = 'Yes';
                        return new PageReference('/'+productAreaId);
                    }Catch(DMLException e){system.debug('--UPDATE Product Area FAILED---'+e.getMessage());}   
                }
            }
        }
        return null;
    }
    
    public pageReference cancelRecords(){
        return new PageReference('/'+productAreaId);
    }
}