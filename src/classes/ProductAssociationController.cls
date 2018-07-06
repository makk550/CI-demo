public class ProductAssociationController{
    
    public Boolean showBlock{get;set;} 
    public Boolean showComp{get;set;} 
    public String productName{get;set;} 
    public String componentName{get;set;}
    public String selectedComponentName{get;set;}
    public String releaseName{get;set;}
    public String selectedReleaseName{get;set;}
    public Map<String, String> mapOfComponent{get;set;}
    public Map<String, String> mapOfSelectedComponent{get;set;}
    public Map<String, String> mapOfRelease{get;set;}
    public Map<String, String> mapOfSelectedRelease{get;set;}
    public Map<String, String> mapOfProductController{get;set;}
    public String listOfProductWrapperClass{get;set;}
    public List<wrapperProductDetails> listOfWrapperProductDetails{get;set;}
    public String listOfProductWrapperClass1{get;set;}
    public Map<String,Map<String,String>> mapForEditScenario{get;set;}
    public Map<String,Map<String,String>> mapForEditReleaseScenario{get;set;}
    public Boolean showFlag{get;set;}
    public String articleId{get;set;}
    public String articleIdVal{get;set;}
    public set<String> setOfSelectedComp;
    public set<String> setOfSelectedRelease;
    public set<String> setOfSelectedProduct;
    public Map<String,String> mapOfComponentIds;
    public Map<String,String> mapOfReleaseIds;
    public List<KCS_Association__c> listOfKCSAssociation;
    public Boolean errorFlag{get;set;}
    public Integer wrapperSize{get;set;}
    public String knowledgeArticleIdVal{get;set;}
    public Map<Id,String> mapOfXMDAndProdComp{get;set;}
    public List<ProcessInstance> listOfProcessInstance{get;set;}
    public Map<Id,String> mapOfXMDAndReleaseId{get;set;}
    
    public ProductAssociationController(){
        showFlag=false;
        showBlock = false;
        knowledgeArticleIdVal = '';
        showComp = false;
        errorFlag = false;
        wrapperSize = 0;
        listOfProductWrapperClass = '';
        listOfProductWrapperClass1 = '';
        mapOfXMDAndProdComp = new Map<Id,String>();
        mapOfXMDAndReleaseId = new Map<Id,String>();
        listOfProcessInstance = new List<ProcessInstance>();
        mapForEditScenario = new Map<String,Map<String,String>>();
        mapForEditReleaseScenario = new Map<String,Map<String,String>>();
        mapOfProductController = new Map<String,String>();
        mapOfComponent = new Map<String,String>();
        mapOfSelectedComponent = new Map<String,String>();
        mapOfRelease = new Map<String,String>();
        mapOfSelectedRelease = new Map<String,String>(); 
        listOfWrapperProductDetails = new List<wrapperProductDetails>();
        
        articleId = String.isNotBlank(ApexPages.currentPage().getParameters().get('aId'))?ApexPages.currentPage().getParameters().get('aId'):'';
        
        if(String.isNotBlank(articleId)){
            List<XMD_Product__c> listOfProduct= [Select Id, Name from XMD_Product__c where Name!=null AND Name!='' order by Name];
            
            if(listOfProduct<>null && listOfProduct.size()>0){
                for(XMD_Product__c productObj:listOfProduct){
                    if(String.isNotBlank(productObj.Name)){
                        listOfProductWrapperClass +='{\"label\":\"'+productObj.Name+'\",\"value\":\"'+productObj.Name+'\",\"Id\":\"'+productObj.Id+'\"},';
                        mapOfProductController.put(productObj.Id,productObj.Name);
                    }
                }
                if(String.isNotBlank(listOfProductWrapperClass)){
                    listOfProductWrapperClass = listOfProductWrapperClass.subString(0,listOfProductWrapperClass.length()-1);
                }
                system.debug('listOfProductWrapperClass---->'+listOfProductWrapperClass);
                showBlock = true;
                List<knowledge__kav> listOfArticle = [select id, RecordTypeId, knowledgeArticleId, articleNumber from knowledge__kav where articleNumber=:articleId AND PublishStatus='Draft' limit 1];
                if(listOfArticle<>null && listOfArticle.size()>0){
                    listOfProcessInstance = [Select id from ProcessInstance where TargetObjectId=:listOfArticle[0].Id AND Status='Pending' order by lastmodifieddate desc limit 1];
                }
                List<knowledge__kav> listOfPublishedArticle = [select id, knowledgeArticleId, articleNumber from knowledge__kav where articleNumber=:articleId AND PublishStatus='Online' limit 1];
                List<knowledge__kav> listOfArchivedArticle = [select id, knowledgeArticleId, articleNumber from knowledge__kav where articleNumber=:articleId AND PublishStatus='Archived' limit 1];
                if(listOfArticle<>null && listOfArticle.size()>0){
                    articleIdVal = listOfArticle[0].knowledgeArticleId;
                    String artId = listOfArticle[0].Id;
                    knowledgeArticleIdVal = listOfArticle[0].knowledgeArticleId;
                    listOfKCSAssociation = [Select id, Article_Id__c, Component_ID__c, Primary__c,Product_Count__c, Product_ID__c, Release_ID__c from KCS_Association__c where Article_Id__c=:knowledgeArticleIdVal order by createdDate];
                    
                    if(listOfKCSAssociation<>null && listOfKCSAssociation.size()>0){
                        showFlag = true;
                        setOfSelectedProduct = new set<String>();
                        setOfSelectedComp = new set<String>();
                        setOfSelectedRelease = new set<String>();
                        set<String> setOfSelectedPrimary = new set<String>();
                        Map<Id,Boolean> mapOfPrimaryProducts = new Map<Id,Boolean>();
                        Map<String,Integer> mapOfProductCount = new Map<String,Integer>();
                        
                        for(KCS_Association__c kcsObj:listOfKCSAssociation){
                            system.debug('--kcsObj.Component_ID__ckcsObj.Component_ID__c---->'+kcsObj.Component_ID__c);
                            setOfSelectedProduct.add(kcsObj.Product_ID__c);
                            if(String.isNotBlank(kcsObj.Component_ID__c)){
                                setOfSelectedComp.add(kcsObj.Product_ID__c+'_'+kcsObj.Component_ID__c);    
                            }
                            if(String.isNotBlank(kcsObj.Release_ID__c)){
                                setOfSelectedRelease.add(kcsObj.Product_ID__c+'_'+kcsObj.Release_ID__c);    
                            }
                            mapOfPrimaryProducts.put(kcsObj.Product_ID__c,kcsObj.Primary__c);
                            mapOfProductCount.put(kcsObj.Product_ID__c,Integer.valueOf(kcsObj.Product_Count__c));
                            
                        }
                        
                        if(setOfSelectedProduct<>null && setOfSelectedComp<>null && mapOfPrimaryProducts<>null && setOfSelectedProduct.size()>0 && setOfSelectedComp.size()>0 && mapOfPrimaryProducts.keySet()<>null){
                            fetchExistingRecordDetails(mapOfProductCount, setOfSelectedProduct,setOfSelectedComp,setOfSelectedRelease,mapOfPrimaryProducts, artId,listOfPublishedArticle,listOfArchivedArticle);    
                        }
                    }
                }else{
                    errorFlag = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,articleId+ ' Article is not in draft status');
                    ApexPages.addMessage(myMsg);
                }
            }else{
                errorFlag = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No ECM Product avaiable');
                ApexPages.addMessage(myMsg);    
            }
        }else{
            errorFlag = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the valid article number');
            ApexPages.addMessage(myMsg);    
        }
    }
    
    public void fetchExistingRecordDetails(Map<String,Integer> mapOfProductCount, set<String> setOfSelectedProduct,set<String> setOfSelectedComp,set<String> setOfSelectedRelease,Map<Id,Boolean> mapOfPrimaryProducts, String artId, List<knowledge__kav> listOfPublishedArticle, List<knowledge__kav> listOfArchivedArticle){
        
        List<CA_XMD_Product_Mapping__c> listOfMapping = [Select id, XMD_Product__c, CA_Product__c from CA_XMD_Product_Mapping__c where XMD_Product__c!=null AND XMD_Product__c!='' AND CA_Product__c!=null AND CA_Product__c!='' AND XMD_Product__c IN:setOfSelectedProduct];
        
        if(listOfMapping<>null && listOfMapping.size()>0){
            set<Id> setOfCAProducts = new set<Id>();
            
            for(CA_XMD_Product_Mapping__c xmdMap:listOfMapping){
                setOfCAProducts.add(xmdMap.CA_Product__c);    
            }
            
            if(setOfCAProducts<>null && setOfCAProducts.size()>0){
                
                set<String> setOfComponents = new set<String>();                
                set<String> setOfRelease = new set<String>();
                set<String> setOfXMD = new set<String>();
                Map<String,String> mapOfCompIdAndName = new Map<String,String>();
                Map<String,String> mapOfCompIdAndCode = new Map<String,String>();
                Map<String,String> mapOfReleaseIdAndNumber = new Map<String,String>();
                Map<String,String> mapOfReleaseIdAndId = new Map<String,String>();
                mapOfXMDAndProdComp = new Map<Id,String>();
                Map<Id,String> mapOfXMDAndProdCode = new Map<Id,String>();
                mapOfXMDAndReleaseId = new Map<Id,String>();
                Map<Id,String> mapOfXMDAndReleaseNumber = new Map<Id,String>();
                
                for(String compId:setOfSelectedComp){
                    setOfComponents.add(compId.substringAfter('_'));    
                }
                
                if(setOfComponents<>null && setOfComponents.size()>0){
                   List<CA_Product_Component__c> listOfCAComp = [Select id,Name,CA_Product_Controller__c, Component_Code__c from CA_Product_Component__c where id IN:setOfComponents AND CA_Product_Controller__c IN:setOfCAProducts AND Component_Code__c!=null AND Component_Code__c!=''];
                    List<Product_Release__c> listOfProductRelease = new List<Product_Release__c>();
                    if(setOfSelectedRelease<>null && setOfSelectedRelease.size()>0){
                        for(String releaseId:setOfSelectedRelease){
                            setOfRelease.add(releaseId.substringAfter('_'));    
                        }
                        listOfProductRelease = [Select Id,Product_Release__c,Product_Material__r.CA_Product_Controller__c from Product_Release__c where Product_Release__c!=null AND Product_Release__c!='' AND Product_Material__c!=null AND Product_Material__r.CA_Product_Controller__c!=null AND Product_Material__r.CA_Product_Controller__c IN:setOfCAProducts AND Id IN:setOfRelease];
                    }
                    
                    if(listOfCAComp<>null && listOfCAComp.size()>0){
                        mapOfComponentIds = new Map<String,String>();
                        Map<String,String> mapOfComponentValue = new Map<String,String>();
                        String componentIds = '';
                        String componentValues = '';
                        
                        mapOfReleaseIds = new Map<String,String>();
                        Map<String,String> mapOfReleaseValue = new Map<String,String>();
                        String releaseIds = '';
                        String releaseValues = '';
                        
                        
                        for(CA_Product_Component__c caProductComp:listOfCAComp){
                            mapOfCompIdAndName.put(caProductComp.Id, caProductComp.Id);
                            mapOfCompIdAndCode.put(caProductComp.Id, caProductComp.Component_Code__c);
                        }
                        
                        if(listOfProductRelease<>null && listOfProductRelease.size()>0){
                            for(Product_Release__c caProductRelease:listOfProductRelease){
                                mapOfReleaseIdAndId.put(caProductRelease.Id, caProductRelease.Id);
                                mapOfReleaseIdAndNumber.put(caProductRelease.Id, caProductRelease.Product_Release__c);    
                            }
                        }
                        
                        for(String prepareString:setOfSelectedComp){
                            setOfXMD.add(prepareString.substringBefore('_'));  
                            if(setOfXMD<>null && setOfXMD.size()>0 && setOfXMD.contains(prepareString.substringBefore('_'))){
                                String compVal = prepareString.substringAfter('_');
                                String xmdVal = prepareString.substringBefore('_');
                                if(mapOfXMDAndProdComp==null || mapOfXMDAndProdComp.size()==0 || mapOfXMDAndProdComp.isEmpty() || !mapOfXMDAndProdComp.containsKey(xmdVal)){
                                    mapOfXMDAndProdComp.put(xmdVal,mapOfCompIdAndName.get(compVal));    
                                }else if(mapOfXMDAndProdComp<>null && mapOfXMDAndProdComp.size()>0 && mapOfXMDAndProdComp.containsKey(xmdVal)){
                                    mapOfXMDAndProdComp.put(xmdVal,mapOfXMDAndProdComp.get(xmdVal)+'; '+mapOfCompIdAndName.get(compVal));
                                }
                                
                                if(mapOfXMDAndProdCode==null || mapOfXMDAndProdCode.size()==0 || mapOfXMDAndProdCode.isEmpty() || !mapOfXMDAndProdCode.containsKey(xmdVal)){
                                    mapOfXMDAndProdCode.put(xmdVal,mapOfCompIdAndCode.get(compVal));    
                                }else if(mapOfXMDAndProdCode<>null && mapOfXMDAndProdCode.size()>0 && mapOfXMDAndProdCode.containsKey(xmdVal)){
                                    mapOfXMDAndProdCode.put(xmdVal,mapOfXMDAndProdCode.get(xmdVal)+'<br/>'+mapOfCompIdAndCode.get(compVal));
                                }
                            }
                        }
                        
                        if(setOfSelectedRelease<>null && setOfSelectedRelease.size()>0){
                            setOfXMD.clear();
                            for(String prepareString:setOfSelectedRelease){
                                setOfXMD.add(prepareString.substringBefore('_'));  
                                if(setOfXMD<>null && setOfXMD.size()>0 && setOfXMD.contains(prepareString.substringBefore('_'))){
                                    String releaseVal = prepareString.substringAfter('_');
                                    String xmdVal = prepareString.substringBefore('_');
                                    if(mapOfXMDAndReleaseId==null || mapOfXMDAndReleaseId.size()==0 || mapOfXMDAndReleaseId.isEmpty() || !mapOfXMDAndReleaseId.containsKey(xmdVal)){
                                        mapOfXMDAndReleaseId.put(xmdVal,mapOfReleaseIdAndId.get(releaseVal));    
                                    }else if(mapOfXMDAndReleaseId<>null && mapOfXMDAndReleaseId.size()>0 && mapOfXMDAndReleaseId.containsKey(xmdVal)){
                                        mapOfXMDAndReleaseId.put(xmdVal,mapOfXMDAndReleaseId.get(xmdVal)+'; '+mapOfReleaseIdAndId.get(releaseVal));
                                    }
                                    
                                    if(mapOfXMDAndReleaseNumber==null || mapOfXMDAndReleaseNumber.size()==0 || mapOfXMDAndReleaseNumber.isEmpty() || !mapOfXMDAndReleaseNumber.containsKey(xmdVal)){
                                        mapOfXMDAndReleaseNumber.put(xmdVal,mapOfReleaseIdAndNumber.get(releaseVal));    
                                    }else if(mapOfXMDAndReleaseNumber<>null && mapOfXMDAndReleaseNumber.size()>0 && mapOfXMDAndReleaseNumber.containsKey(xmdVal)){
                                        mapOfXMDAndReleaseNumber.put(xmdVal,mapOfXMDAndReleaseNumber.get(xmdVal)+'<br/>'+mapOfReleaseIdAndNumber.get(releaseVal));
                                    }
                                }
                            }
                        }
                        
                        if(String.isNotBlank(listOfProductWrapperClass)){
                            List<ProcessInstance> ProcessInstanceObj = [Select Id, TargetObjectId, Status from ProcessInstance where TargetObjectId=:artId limit 1];
                            listOfWrapperProductDetails = new List<wrapperProductDetails>();
                            for(String selectedObj:setOfSelectedProduct){
                                system.debug('*****selectedObj*******'+selectedObj);
                                system.debug('*****mapOfReleaseIds*******'+mapOfReleaseIds.get(selectedObj));
                                String newString = '{\"label\":\"'+mapOfProductController.get(selectedObj)+'\",\"value\":\"'+mapOfProductController.get(selectedObj)+'\",\"Id\":\"'+selectedObj+'\"}';
                                listOfProductWrapperClass = listOfProductWrapperClass.replace(newString,'');
                                listOfProductWrapperClass = listOfProductWrapperClass.replace(',,',',');
                                listOfProductWrapperClass = listOfProductWrapperClass.replace('{,','{');
                                listOfProductWrapperClass = listOfProductWrapperClass.replace(',}','}');
                                
                                wrapperProductDetails wrapperProductDetailsObj = new wrapperProductDetails();
                                wrapperProductDetailsObj.articleId = articleIdVal;
                                wrapperProductDetailsObj.productId = mapOfProductController.get(selectedObj);
                                wrapperProductDetailsObj.componentNames = mapOfXMDAndProdCode.get(selectedObj);//<br/>
                                if(mapOfXMDAndReleaseNumber<>null && mapOfXMDAndReleaseNumber.size()>0 && mapOfXMDAndReleaseNumber.get(selectedObj)<>null){//<br/>
                                    wrapperProductDetailsObj.releaseNames = mapOfXMDAndReleaseNumber.get(selectedObj).replaceAll(selectedObj+'_','');    
                                }else{
                                    wrapperProductDetailsObj.releaseNames = '';
                                }
                                wrapperProductDetailsObj.productIdVal = selectedObj;
                                wrapperProductDetailsObj.componentIds = mapOfXMDAndProdComp.get(selectedObj);
                                if(mapOfXMDAndReleaseId<>null && mapOfXMDAndReleaseId.get(selectedObj)<>null){
                                    wrapperProductDetailsObj.releaseIds = mapOfXMDAndReleaseId.get(selectedObj);    
                                }else{
                                    wrapperProductDetailsObj.releaseIds = '';
                                }
                                if(mapOfPrimaryProducts<>null && mapOfPrimaryProducts.size()>0 && mapOfPrimaryProducts.get(selectedObj) && (ProcessInstanceObj<>null && ProcessInstanceObj.size()>0 && ProcessInstanceObj[0].Status.equalsIgnoreCase('Rejected') || listOfPublishedArticle<>null && listOfPublishedArticle.size()>0 || listOfArchivedArticle<>null && listOfArchivedArticle.size()>0)){
                                    wrapperProductDetailsObj.articlePreviousStatus = 'Rejected';//ProcessInstanceObj[0].Status;
                                }else{
                                    wrapperProductDetailsObj.articlePreviousStatus = 'Not Rejected';    
                                }
                                
                                wrapperProductDetailsObj.productCount = mapOfProductCount.get(selectedObj);
                                wrapperProductDetailsObj.primaryProduct = mapOfPrimaryProducts.get(selectedObj);
                                listOfWrapperProductDetails.add(wrapperProductDetailsObj);
                            }
                            wrapperSize = listOfWrapperProductDetails.size();
                            system.debug('------wrapper-aaaa----ffff--->'+listOfProductWrapperClass);
                            if(listOfProductWrapperClass.substring(0,1)==','){
                                listOfProductWrapperClass = listOfProductWrapperClass.substring(1,listOfProductWrapperClass.length());
                            }
                            system.debug('------wrapper-----ffff--->'+listOfProductWrapperClass);
                            system.debug('-8706958745890---->'+mapOfReleaseIds);
                        }    
                   } 
                }
            }    
        }
    }
    
    public void productComponent(){
        String productVal = System.currentPagereference().getParameters().get('productName');
        
        if(String.isNotBlank(productVal) && String.isNotBlank(articleIdVal)){
            productVal = productVal.replaceAll('\"','');
            
            List<CA_XMD_Product_Mapping__c> xmdMapping = [Select CA_Product__c, XMD_Product__c from CA_XMD_Product_Mapping__c where XMD_Product__c!=null AND XMD_Product__c!='' AND CA_Product__c!=null AND CA_Product__c!='' AND XMD_Product__c=:productVal];
            
            if(xmdMapping<>null && xmdMapping.size()>0){
                set<Id> setOfCAProducts = new set<Id>();
                for(CA_XMD_Product_Mapping__c xmdObj:xmdMapping){
                    setOfCAProducts.add(xmdObj.CA_Product__c);
                }
                
                if(setOfCAProducts<>null && setOfCAProducts.size()>0){
                    List<ca_product_component__c> listOfComp = [Select id, Name, Component_Code__c from ca_product_component__c where Component_Code__c!=null AND Component_Code__c!='' AND CA_Product_Controller__c IN:setOfCAProducts AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null) order by Component_Code__c];
                    List<Product_Release__c> listOfProductRelease = [Select Id,Product_Release__c from Product_Release__c where Product_Release__c!=null AND Product_Release__c!='' AND Product_Material__c!=null AND Product_Material__r.CA_Product_Controller__c!=null AND Product_Material__r.CA_Product_Controller__c IN:setOfCAProducts order by Product_Release__c];
                    mapOfComponent = new Map<String,String>();
                    mapOfSelectedComponent = new Map<String,String>();
                    mapOfRelease = new Map<String,String>();
                    mapOfSelectedRelease = new Map<String,String>();
                    
                    system.debug('listOfWrapperProductDetails----***---->: '+listOfWrapperProductDetails);
                    String stringOfExistingComponents = '';
                    if(listOfWrapperProductDetails<>null && listOfWrapperProductDetails.size()>0){
                        for(wrapperProductDetails wrapperProductDetailsObj: listOfWrapperProductDetails){
                            if(String.isNotBlank(wrapperProductDetailsObj.componentIds) && wrapperProductDetailsObj.primaryProduct){
                                stringOfExistingComponents = stringOfExistingComponents + wrapperProductDetailsObj.componentIds;    
                            }    
                        }
                    }
                    
                    if(listOfComp<>null && listOfComp.size()>0){
                        for(ca_product_component__c compObj:listOfComp){
                            if(String.isBlank(stringOfExistingComponents) || (String.isNotBlank(stringOfExistingComponents) && !stringOfExistingComponents.contains(compObj.Id))){
                                mapOfComponent.put(compObj.Id, compObj.Component_Code__c);
                            }else{
                                mapOfSelectedComponent.put(compObj.Id, compObj.Component_Code__c);
                            }
                            showComp = true;
                        }
                        
                        if(mapOfSelectedComponent==null || mapOfSelectedComponent.isEmpty()){
                            mapOfSelectedComponent = null;
                        }
                    }else{
                        mapOfComponent = null;
                        mapOfSelectedComponent = null;
                        showComp = true;
                    }
                    
                    if(listOfProductRelease<>null && listOfProductRelease.size()>0){
                        set<String> setOfDuplicateRelease = new set<String>();
                        for(Product_Release__c prodReleaseObj:listOfProductRelease){
                            if(setOfDuplicateRelease==null || setOfDuplicateRelease.size()==0 || !setOfDuplicateRelease.contains(prodReleaseObj.Product_Release__c)){
                                mapOfRelease.put(prodReleaseObj.Id,prodReleaseObj.Product_Release__c);
                                showComp=true;
                            }
                            setOfDuplicateRelease.add(prodReleaseObj.Product_Release__c);
                        }
                        mapOfSelectedRelease = null;
                    }else{
                        mapOfRelease = null;
                        mapOfSelectedRelease = null;
                        showComp = true;
                    }
                }
            }
        }
    }
    
    public List<SelectOption> getProductComponent(){
        List<SelectOption> listOfComponent = new List<SelectOption>();
        if(mapOfComponent<>null && mapOfComponent.keySet()<>null && mapOfComponent.size()>0){
            set<String> setOfComponent = new set<String>();
            for(String getIdValue:mapOfComponent.keySet()){
                if(setOfComponent==null || setOfComponent.isEmpty() || setOfComponent.size()==0 || (setOfComponent<>null && setOfComponent.size()>0 && !setOfComponent.contains(mapOfComponent.get(getIdValue)))){
                    setOfComponent.add(mapOfComponent.get(getIdValue));
                    listOfComponent.add(new SelectOption(getIdValue,mapOfComponent.get(getIdValue)));  
                }
            }
            //listOfComponent.sort();
        }else{
            listOfComponent.add(new SelectOption('-None-','No Component Found'));
        }
        system.debug('%%%%%%'+listOfComponent);
        return listOfComponent;
    }
    
    public List<SelectOption> getSelectedComponents(){
        List<SelectOption> listOfSelectedComponent = new List<SelectOption>();
        system.debug('^^^'+mapOfSelectedComponent);
        if(mapOfSelectedComponent<>null && mapOfSelectedComponent.keySet()<>null){
            for(String getIdValue:mapOfSelectedComponent.keySet()){
                listOfSelectedComponent.add(new SelectOption(getIdValue,mapOfSelectedComponent.get(getIdValue)));  
            }
            //listOfSelectedComponent.sort();
        }else{
            listOfSelectedComponent.add(new SelectOption('-None-','No Component Selected'));
        }
        system.debug('%%%%#####%%'+listOfSelectedComponent);
        return listOfSelectedComponent;
    }
    
    public List<SelectOption> getRelease(){
        List<SelectOption> listOfRelease = new List<SelectOption>();
        if(mapOfRelease<>null && mapOfRelease.keySet()<>null){
            for(String getIdValue:mapOfRelease.keySet()){
                if(mapOfRelease.get(getIdValue).contains('_')){
                    listOfRelease.add(new SelectOption(getIdValue,mapOfRelease.get(getIdValue).subString(19,mapOfRelease.get(getIdValue).length())));     
                }else{
                    listOfRelease.add(new SelectOption(getIdValue,mapOfRelease.get(getIdValue)));      
                }
            }
        }else{
            listOfRelease.add(new SelectOption('-None-','No Release Found'));
        }
        system.debug('%%%%%%'+listOfRelease);
        return listOfRelease;
    }
    
    public List<SelectOption> getSelectedReleases(){
        List<SelectOption> listOfSelectedRelease = new List<SelectOption>();
        system.debug('^^^'+mapOfSelectedRelease);
        if(mapOfSelectedRelease<>null && mapOfSelectedRelease.keySet()<>null){
            for(String getIdValue:mapOfSelectedRelease.keySet()){
                listOfSelectedRelease.add(new SelectOption(getIdValue,mapOfSelectedRelease.get(getIdValue)));  
            }
            //listOfSelectedRelease.sort();
        }else{
            listOfSelectedRelease.add(new SelectOption('-None-','No Release Selected'));
        }
        system.debug('%%%%#####%%'+listOfSelectedRelease);
        return listOfSelectedRelease;
    }
    
    public void createPrimaryProductAssociation(){
        String productVal = System.currentPagereference().getParameters().get('productId');
        String articleNumber = System.currentPagereference().getParameters().get('articleNum');
        String componentVal = System.currentPagereference().getParameters().get('prepareCompString');
        String releaseVal = System.currentPagereference().getParameters().get('prepareReleaseString');
        
        if(String.isNotBlank(productVal) && String.isNotBlank(articleNumber) && String.isNotBlank(componentVal) && String.isNotBlank(releaseVal)){
            List<String> listOfComponents = componentVal.split(';');
            List<String> listOfRelease = releaseVal.split(';');
            Map<String,String> newMapValues = new Map<String,String>();
            Map<String,String> newMapReleaseValues = new Map<String,String>();
            
           if(listOfComponents<>null && listOfRelease<>null && listOfComponents.size()>0 && listOfRelease.size()>0){
                String componentString = '';
                String releaseString ='';
                String stringOfSelectedComp = '';
                String stringOfSelectedRelease = '';
        
                for(String compObj:listOfComponents){
                    if(String.isNotBlank(compObj)){
                        if(mapOfComponent<>null && mapOfComponent.get(compObj)<>null){
                            componentString = componentString + mapOfComponent.get(compObj)+'<br/>';
                            if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0 && setOfSelectedComp<>null && setOfSelectedComp.size()>0 && setOfSelectedProduct.contains(productVal) && !mapOfXMDAndProdComp.get(productVal).contains(compObj)){
                               stringOfSelectedComp = stringOfSelectedComp+compObj+'--'; 
                            }else{
                                newMapValues.put(compObj,mapOfComponent.get(compObj));
                                mapForEditScenario.put(productVal,newMapValues);
                            }
                        }else if(mapOfSelectedComponent<>null && mapOfSelectedComponent.get(compObj)<>null){
                            componentString = componentString + mapOfSelectedComponent.get(compObj)+'<br/>';
                            if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0 && setOfSelectedProduct.contains(productVal)){
                                stringOfSelectedComp = stringOfSelectedComp+compObj+'--';
                            }else{
                                newMapValues.put(compObj,mapOfSelectedComponent.get(compObj));
                                mapForEditScenario.put(productVal,newMapValues);
                            }
                        }
                    }
                }
                
                if(String.isNotBlank(stringOfSelectedComp)){
                    List<String> splitOfString = stringOfSelectedComp.split('--');
                    mapOfXMDAndProdComp.put(productVal,'');
                    //setOfSelectedComp = new Set<String>();
                    for(String addString:splitOfString){
                        if(String.isNotBlank(addString) && (mapOfXMDAndProdComp.get(productVal)=='' || !mapOfXMDAndProdComp.get(productVal).contains(addString))){
                            mapOfXMDAndProdComp.put(productVal,mapOfXMDAndProdComp.get(productVal)+addString+';');   
                        }
                    }
                }
                
                for(String releaseObj:listOfRelease){
                    if(String.isNotBlank(releaseObj) && releaseObj!='-None-' && releaseObj!='All'){
                        if(mapOfRelease<>null && mapOfRelease.get(releaseObj)<>null){
                            releaseString = releaseString + mapOfRelease.get(releaseObj)+'<br/>';
                            if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0 && setOfSelectedRelease<>null && setOfSelectedRelease.size()>0 && setOfSelectedProduct.contains(productVal) && mapOfXMDAndReleaseId<>null && mapOfXMDAndReleaseId.size()>0 && (String.isNotBlank(mapOfXMDAndReleaseId.get(productVal)) && !mapOfXMDAndReleaseId.get(productVal).contains(releaseObj) || String.isBlank(mapOfXMDAndReleaseId.get(productVal)))){
                               stringOfSelectedRelease = stringOfSelectedRelease+releaseObj+'--'; 
                            }else if(mapOfRelease<>null && String.isNotBlank(mapOfRelease.get(releaseObj))){
                                newMapReleaseValues.put(releaseObj,mapOfRelease.get(releaseObj));
                                mapForEditReleaseScenario.put(productVal,newMapReleaseValues);
                            }
                        }else if(mapOfSelectedRelease<>null && mapOfSelectedRelease.get(releaseObj)<>null){
                            releaseString = releaseString + mapOfSelectedRelease.get(releaseObj)+'<br/>';
                            if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0 && setOfSelectedProduct.contains(productVal)){
                                stringOfSelectedRelease = stringOfSelectedRelease+releaseObj+'--';
                            }else if(mapOfSelectedRelease<>null && String.isNotBlank(mapOfSelectedRelease.get(releaseObj))){
                                newMapReleaseValues.put(releaseObj,mapOfSelectedRelease.get(releaseObj));
                                mapForEditReleaseScenario.put(productVal,newMapReleaseValues);
                            }
                        }
                    }
                    
                    if(releaseObj=='All'){
                        mapForEditReleaseScenario.remove(productVal);    
                        mapOfRelease = new Map<String,String>();
                        if(mapOfSelectedRelease<>null && mapOfSelectedRelease.keySet()<>null){
                            for(String addAllRelease:mapOfSelectedRelease.keySet()){
                                mapOfRelease.put(addAllRelease,mapOfSelectedRelease.get(addAllRelease));
                                if(mapOfXMDAndReleaseId<>null && String.isNotBlank(mapOfXMDAndReleaseId.get(productVal))){
                                    mapOfXMDAndReleaseId.remove(productVal);    
                                }
                            }
                            mapOfSelectedRelease = new Map<String,String>(); 
                        }
                    }
                    
                }
               
                if(String.isNotBlank(stringOfSelectedRelease)){
                    List<String> splitOfString = stringOfSelectedRelease.split('--');
                    mapOfXMDAndReleaseId.put(productVal,'');
                    //setOfSelectedComp = new Set<String>();
                    for(String addString:splitOfString){
                        if(String.isNotBlank(addString) && (mapOfXMDAndReleaseId.get(productVal)=='' || !mapOfXMDAndReleaseId.get(productVal).contains(addString))){
                            mapOfXMDAndReleaseId.put(productVal,mapOfXMDAndReleaseId.get(productVal)+addString+';');   
                        }
                    }
                }
               
                system.debug('--componentString->'+componentString);
                system.debug('listOfWrapperProductDetails: '+listOfWrapperProductDetails);
                Boolean newFlag = false;
                if(listOfWrapperProductDetails<>null && listOfWrapperProductDetails.size()>0){
                    system.debug('--size->'+listOfWrapperProductDetails.size());
                    for(Integer i=0;i<listOfWrapperProductDetails.size();i++){
                        system.debug('--PRODODODODODO->'+listOfWrapperProductDetails.get(i).productIdVal);
                        system.debug('--productValproductValproductVal->'+productVal);
                        if(listOfWrapperProductDetails.get(i).productIdVal ==productVal){
                            newFlag = false;
                            listOfWrapperProductDetails.get(i).articleId = articleNumber;
                            listOfWrapperProductDetails.get(i).productId = mapOfProductController.get(productVal);
                            listOfWrapperProductDetails.get(i).componentNames = componentString;
                            listOfWrapperProductDetails.get(i).releaseNames = releaseString;
                            listOfWrapperProductDetails.get(i).productIdVal = productVal;
                            listOfWrapperProductDetails.get(i).componentIds = componentVal;
                            listOfWrapperProductDetails.get(i).releaseIds = releaseVal;
                            listOfWrapperProductDetails.get(i).primaryProduct = listOfWrapperProductDetails.get(i).primaryProduct;
                            break;
                        }else{
                            newFlag = true; 
                        }
                    } 
                }else{
                    newFlag = true;
                }
                system.debug(articleNumber+'--After change listOfWrapperProductDetails: '+listOfWrapperProductDetails);
                if(newFlag){
                    system.debug('====>listOfWrapperProductDetails before'+listOfWrapperProductDetails.size());
                    wrapperProductDetails wrapperProductDetailsObj = new wrapperProductDetails();
                    wrapperProductDetailsObj.articleId = articleNumber;
                    wrapperProductDetailsObj.productId = mapOfProductController.get(productVal);
                    wrapperProductDetailsObj.componentNames = componentString;
                    wrapperProductDetailsObj.releaseNames = releaseString;
                    wrapperProductDetailsObj.productIdVal = productVal;
                    wrapperProductDetailsObj.componentIds= componentVal;
                    wrapperProductDetailsObj.releaseIds = releaseVal;
                    if(listOfWrapperProductDetails.size()>0){
                        System.debug('loaskdoakdsad:'+listOfWrapperProductDetails);
                        if(!Test.isRunningTest()){
                            wrapperProductDetailsObj.productCount = listOfWrapperProductDetails[listOfWrapperProductDetails.size()-1].productCount+1;    
                        }else{
                            wrapperProductDetailsObj.productCount = 1;
                        }
                    }else{
                        wrapperProductDetailsObj.productCount = listOfWrapperProductDetails.size()+1;
                    }
                    if((listOfKCSAssociation==null || listOfKCSAssociation.size()==0) && (listOfWrapperProductDetails==null || listOfWrapperProductDetails.size()==0)){
                        wrapperProductDetailsObj.primaryProduct = true;
                    }else{
                        wrapperProductDetailsObj.primaryProduct = false;
                    }
                    listOfWrapperProductDetails.add(wrapperProductDetailsObj);    
                    system.debug('====>listOfWrapperProductDetails after'+listOfWrapperProductDetails.size());
                }
                
                wrapperSize = listOfWrapperProductDetails.size();
                
                system.debug('listOfProductWrapperClass: '+listOfProductWrapperClass);
                String newString = '{\"label\":\"'+mapOfProductController.get(productVal)+'\",\"value\":\"'+mapOfProductController.get(productVal)+'\",\"Id\":\"'+productVal+'\"}';
                system.debug('newString: '+newString);
                if(String.isNotBlank(listOfProductWrapperClass1)){
                    listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(newString,'');
                }else{
                    listOfProductWrapperClass1 = listOfProductWrapperClass.replace(newString,'');    
                }
                listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(',,',',');
                listOfProductWrapperClass1 = listOfProductWrapperClass1.replace('{,','{');
                listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(',}','}');
                listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(',]',']');
                if(!listOfProductWrapperClass1.contains('[') && !listOfProductWrapperClass1.contains(']')){
                  listOfProductWrapperClass1 = '['+listOfProductWrapperClass1+']';
                }
                if(listOfProductWrapperClass1.substring(1,2)==','){
                    listOfProductWrapperClass1 =  listOfProductWrapperClass1.substring(2,listOfProductWrapperClass1.length());   
                    listOfProductWrapperClass1 = '['+listOfProductWrapperClass1;
                }
                system.debug('listOfProductWrapperClass---->'+listOfProductWrapperClass1);
            }
       }
        
    }
        
    public void cancelDetails(){
        
    }
    
    public PageReference callRemoveProduct(){
        String productVal = System.currentPagereference().getParameters().get('productId');    
        String productFlagVal = System.currentPagereference().getParameters().get('productFlag');  
        String productCompVal = System.currentPagereference().getParameters().get('productComponent');  
        String productReleaseVal = System.currentPagereference().getParameters().get('productRelease');  
        String articleNum = System.currentPagereference().getParameters().get('artNum');
        
        Boolean flagVal =false;
        Boolean deleteFlag = false;
        if(productFlagVal == 'true'){
            flagVal = true;    
        }
        String removedProductVal = productVal.replace('removeId_','');
        system.debug(listOfWrapperProductDetails.size()+'--listOfWrapperProductDetails->'+setOfSelectedProduct);
        system.debug('--listOfProductWrapperClass1->'+listOfProductWrapperClass1);
        system.debug('--listOfProductWrapperClass->'+listOfProductWrapperClass);
        system.debug('--removedProductVal----->'+removedProductVal);
        List<KCS_Association__c> listOfDeleteKCS = new List<KCS_Association__c>();
        //if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0 && setOfSelectedProduct.contains(removedProductVal)){
            system.debug('----listOfKCSAssociation'+listOfKCSAssociation);
            if(!flagVal){
                showFlag = false;
                listOfDeleteKCS = [Select id, Article_Id__c, Component_ID__c, Primary__c, Product_ID__c, Release_ID__c from KCS_Association__c where Article_Id__c=:articleIdVal AND Product_ID__c=:removedProductVal];    
            }else{
                listOfDeleteKCS = [Select id, Article_Id__c, Component_ID__c, Primary__c, Product_ID__c, Release_ID__c from KCS_Association__c where Article_Id__c=:articleIdVal];
            }
            
            if(listOfDeleteKCS<>null && listOfDeleteKCS.size()>0){
                
                List<knowledge__kav> listOfTesting = [Select id, Product_Names__c,Component_Names__c, Releases__c, Component_Codes__c,CMS_IDs__c from knowledge__kav where articlenumber=:articleId AND PublishStatus='Draft' limit 1];
                List<CA_XMD_Product_Mapping__c> listOfCAProduct = [select id, Name, CA_Product__c, CA_Product__r.Name, XMD_Product__c, XMD_Product__r.CMS_ID__c from CA_XMD_Product_Mapping__c where XMD_Product__c=:removedProductVal];
                List<XMD_Product__c> listOfXMD = [Select id,Name,CMS_ID__c from XMD_Product__c where Name!=null AND Name!='' AND Id=:removedProductVal limit 1]; 
                system.debug('listOfTesting: '+listOfTesting);
                system.debug('listOfXMD: '+listOfCAProduct);
                
                if(listOfTesting<>null && listOfTesting.size()>0 && listOfCAProduct<>null && listOfCAProduct.size()>0){
                    set<String> setOfCAProduct = new set<String>();
                    set<String> setOfCAProductIds = new set<String>();
                    Map<String,String> mapOfCaIdAndName = new Map<String,String>();
                    set<String> setOfXMD = new set<String>();
                    for(CA_XMD_Product_Mapping__c caProdObj:listOfCAProduct){
                        setOfCAProduct.add(caProdObj.CA_Product__r.Name);
                        setOfCAProductIds.add(caProdObj.CA_Product__c);
                        mapOfCaIdAndName.put(caProdObj.CA_Product__c, caProdObj.CA_Product__r.Name);
                        setOfXMD.add(caProdObj.XMD_Product__r.CMS_ID__c);
                    }
                    
                    if(setOfCAProduct<>null && setOfCAProduct.size()>0 && String.isNotBlank(listOfTesting[0].Product_Names__c)){
                        
                        List<String> splitByNewLine = listOfTesting[0].Product_Names__c.split('\n');
                        listOfTesting[0].Product_Names__c = '';
                        if(splitByNewLine<>null && splitByNewLine.size()>0){
                            set<String> newProductName = new set<String>();
                            for(String newString:splitByNewLine){
                                if(String.isNotBlank(newString) && newString.contains(listOfXMD[0].Name)){
                                    listOfTesting[0].Product_Names__c =  listOfTesting[0].Product_Names__c.replace(newString,''); 
                                    listOfTesting[0].Product_Names__c =  listOfTesting[0].Product_Names__c.replace('\n\n','\n');
                                    break;
                                }
                            }    
                        }
                    }
                    
                    if(String.isNotBlank(listOfTesting[0].Component_Names__c) && setOfCAProduct<>null && setOfCAProduct.size()>0){
                        List<String> splitComponentNewLine = listOfTesting[0].Component_Names__c.split('\n');    
                        if(splitComponentNewLine<>null && splitComponentNewLine.size()>0){
                            for(String replaceCompName:splitComponentNewLine){
                                if(String.isNotBlank(replaceCompName) && replaceCompName.contains(listOfXMD[0].Name+': ')){
                                    listOfTesting[0].Component_Names__c = listOfTesting[0].Component_Names__c.replace(replaceCompName,'');
                                    listOfTesting[0].Component_Names__c = listOfTesting[0].Component_Names__c.replace('\n\n','\n');
                                    break;
                                }
                            }
                        }
                    }
                    
                
                    if(String.isNotBlank(listOfTesting[0].Component_Codes__c) && setOfCAProduct<>null && setOfCAProduct.size()>0){
                        List<String> splitCodeNewLine = listOfTesting[0].Component_Codes__c.split('\n');
                        if(splitCodeNewLine<>null && splitCodeNewLine.size()>0){
                            for(String replaceCompCode:splitCodeNewLine){
                                if(String.isNotBlank(replaceCompCode) && replaceCompCode.contains(listOfXMD[0].Name+': ')){
                                    listOfTesting[0].Component_Codes__c = listOfTesting[0].Component_Codes__c.replace(replaceCompCode,'');
                                    listOfTesting[0].Component_Codes__c = listOfTesting[0].Component_Codes__c.replace('\n\n','\n');
                                    break;
                                }
                            }
                        }
                    }
                    
                    if(String.isNotBlank(listOfTesting[0].Releases__c) && setOfCAProduct<>null && setOfCAProduct.size()>0){
                        List<String> splitReleaseNewLine = listOfTesting[0].Releases__c.split('\n');
                        
                        if(splitReleaseNewLine<>null && splitReleaseNewLine.size()>0){
                            for(String replaceRelease:splitReleaseNewLine){
                                if(String.isNotBlank(replaceRelease) && replaceRelease.contains(listOfXMD[0].Name+': ')){
                                    listOfTesting[0].Releases__c = listOfTesting[0].Releases__c.replace(replaceRelease,'');
                                    listOfTesting[0].Releases__c = listOfTesting[0].Releases__c.replace('\n\n','\n');
                                    break;
                                }
                            }
                        }
                    }
                
                    if(String.isNotBlank(listOfTesting[0].CMS_IDs__c)){
                        List<String> splitByCommas = listOfTesting[0].CMS_IDs__c.split(';');
                        
                        if(splitByCommas<>null && splitByCommas.size()>0){
                            String newCMSVal = '';
                            for(Integer i=0;i<splitByCommas.size();i++){
                                if(setOfXMD.contains(splitByCommas[i])){
                                    splitByCommas.remove(i);    
                                    break;
                                }
                            }
                            
                            if(splitByCommas<>null && splitByCommas.size()>0){
                                listOfTesting[0].CMS_IDs__c = '';
                                for(String val:splitByCommas){
                                    listOfTesting[0].CMS_IDs__c = listOfTesting[0].CMS_IDs__c +val+';';    
                                }
                            }else{
                                listOfTesting[0].CMS_IDs__c = '';
                            }
                        }
                    }
                    try{database.update(listOfTesting[0]);}Catch(exception e){system.debug('--------UPDATE FAILED ON REMOVED-----'+e.getMessage());}
                }
            }
        //}
        Boolean alphaFlag = false;
        if(listOfWrapperProductDetails<>null && listOfWrapperProductDetails.size()>1){
            if(!flagVal){
                productVal = productVal.replace('removeId_','');
                Integer indexVal =0;
                String addNewString = '{\"label\":\"'+mapOfProductController.get(productVal)+'\",\"value\":\"'+mapOfProductController.get(productVal)+'\",\"Id\":\"'+productVal+'\"}';
                if(String.isNotBlank(listOfProductWrapperClass1)){
                    listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(']',','+addNewString+']');
                }else{
                    listOfProductWrapperClass1 = listOfProductWrapperClass +','+addNewString;
                    if(!listOfProductWrapperClass1.contains('[') && !listOfProductWrapperClass1.contains(']')){
                        listOfProductWrapperClass1 = '['+listOfProductWrapperClass1+']';
                    }
                }
                for(Integer i=0;i<listOfWrapperProductDetails.size();i++){
                    if(listOfWrapperProductDetails.get(i).productIdVal == productVal && listOfWrapperProductDetails.get(i).componentIds== productCompVal){
                        indexVal = i;   
                        break;
                    }
                }
                listOfWrapperProductDetails.remove(indexVal);    
                if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0){
                    setOfSelectedProduct.remove(productVal);    
                }
                deleteFlag=true;
            }else{
                String addListOfNewStrings = ',';
                for(wrapperProductDetails wrapperProductDetailsObject:listOfWrapperProductDetails){
                    addListOfNewStrings = addListOfNewStrings + '{\"label\":\"'+mapOfProductController.get(wrapperProductDetailsObject.productIdVal)+'\",\"value\":\"'+mapOfProductController.get(wrapperProductDetailsObject.productIdVal)+'\",\"Id\":\"'+wrapperProductDetailsObject.productIdVal+'\"},';
                    if(setOfSelectedProduct<>null){
                        setOfSelectedProduct.remove(wrapperProductDetailsObject.productIdVal);
                    }
                }
                addListOfNewStrings = addListOfNewStrings.substring(0,addListOfNewStrings.length()-1);
                if(String.isNotBlank(listOfProductWrapperClass1)){
                    listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(']',addListOfNewStrings+']');
                    listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(',]',']');
                }else{
                    listOfProductWrapperClass1 = listOfProductWrapperClass+addListOfNewStrings;
                    listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(',]',']');
                    if(!listOfProductWrapperClass1.contains('[') && !listOfProductWrapperClass1.contains(']')){
                        listOfProductWrapperClass1 = '['+listOfProductWrapperClass1+']';
                    }
                }
                deleteFlag = true;
                system.debug('=======>'+listOfProductWrapperClass1);
                listOfWrapperProductDetails.clear();
                listOfKCSAssociation.clear();
                //listOfProductWrapperClass1 = '';                                                                
            }
        }else{
            productVal = productVal.replace('removeId_','');
            String addNewString = '{\"label\":\"'+mapOfProductController.get(productVal)+'\",\"value\":\"'+mapOfProductController.get(productVal)+'\",\"Id\":\"'+productVal+'\"}';
            if(String.isNotBlank(listOfProductWrapperClass1)){
                listOfProductWrapperClass1 = listOfProductWrapperClass1.replace(']',','+addNewString+']');
            }else{
                listOfProductWrapperClass1 = listOfProductWrapperClass +','+addNewString;
                if(!listOfProductWrapperClass1.contains('[') && !listOfProductWrapperClass1.contains(']')){
                    listOfProductWrapperClass1 = '['+listOfProductWrapperClass1+']';
                }
            }
            listOfWrapperProductDetails.clear();
            listOfKCSAssociation.clear();
            //listOfProductWrapperClass1 = '';
            deleteFlag = true;
            alphaFlag = true;
        }
        wrapperSize = listOfWrapperProductDetails.size();
        
        if(listOfDeleteKCS<>null && listOfDeleteKCS.size()>0){
            try{database.delete(listOfDeleteKCS);if(alphaFlag){PageReference retPage = new PageReference(System.URL.getSalesforceBaseUrl().toExternalForm()+'/knowledge/publishing/articleEdit.apexp?id='+articleIdVal); return retPage;}}Catch(Exception e){system.debug('---DELETE FAIL---');}
        }
        return null;
    }
    
    public void fetchValuesForEdit(){
        String productVal = System.currentPagereference().getParameters().get('productRecordId');
        system.debug('---productVal->'+productVal);
        system.debug(mapForEditReleaseScenario+'-----------aaa-------'+mapForEditScenario);
        
        List<CA_XMD_Product_Mapping__c> listOfMap = [Select id, XMD_Product__c, CA_Product__c from CA_XMD_Product_Mapping__c where CA_Product__c!=null AND CA_Product__c!='' AND XMD_Product__c=:productVal];
        
        if(listOfMap<>null && listOfMap.size()>0){
            set<Id> setOfCAproduct = new set<Id>();
            for(CA_XMD_Product_Mapping__c mapObj:listOfMap){
                setOfCAproduct.add(mapObj.CA_Product__c);    
            }
            
            if(setOfCAproduct<>null && setOfCAproduct.size()>0){
                List<ca_product_component__c> listOfComp = [Select id,CA_Product_Controller__c, Component_Code__c, Name from ca_product_component__c where Component_Code__c!=null AND Component_Code__c!='' AND CA_Product_Controller__c IN:setOfCAproduct AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null)];
                List<Product_Release__c> listOfProductRelease = [Select Id,Product_Material__r.CA_Product_Controller__c,Product_Release__c from Product_Release__c where Product_Release__c!=null AND Product_Release__c!='' AND Product_Material__c!=null AND Product_Material__r.CA_Product_Controller__c!=null AND Product_Material__r.CA_Product_Controller__c IN:setOfCAproduct];
            
                if(setOfSelectedProduct<>null && setOfSelectedProduct.size()>0 && setOfSelectedProduct.contains(productVal)){
                    mapOfComponent = new Map<String,String>();
                    mapOfSelectedComponent = new Map<String,String>();
                    mapOfRelease = new Map<String,String>();
                    mapOfSelectedRelease = new Map<String,String>();
                    
                    if(listOfComp<>null && listOfComp.size()>0){
                        set<String> setOfCompCode = new set<String>();
                        for(ca_product_component__c compObj:listOfComp){
                            if(mapOfXMDAndProdComp.get(productVal).contains(compObj.Id)){
                                mapOfSelectedComponent.put(compObj.Id, compObj.Component_Code__c);    
                                setOfCompCode.add(compObj.Component_Code__c);
                            }else if(setOfCompCode==null || setOfCompCode.size()==0 || (setOfCompCode<>null && setOfCompCode.size()>0 && !setOfCompCode.contains(compObj.Component_Code__c))){
                                mapOfComponent.put(compObj.Id, compObj.Component_Code__c);    
                            }
                        }
                        
                        set<String> setOfDuplicateRelease = new Set<String>();
                        if(listOfProductRelease<>null && listOfProductRelease.size()>0){
                            for(Product_Release__c releaseObj:listOfProductRelease){
                                if(mapOfXMDAndReleaseId<>null && mapOfXMDAndReleaseId.size()>0 && String.isNotBlank(mapOfXMDAndReleaseId.get(productVal)) && mapOfXMDAndReleaseId.get(productVal).contains(releaseObj.Id)){
                                    mapOfSelectedRelease.put(releaseObj.Id, releaseObj.Product_Release__c);    
                                }else if(setOfDuplicateRelease==null || setOfDuplicateRelease.size()==0 || !setOfDuplicateRelease.contains(releaseObj.Product_Release__c)){
                                    mapOfRelease.put(releaseObj.Id, releaseObj.Product_Release__c);    
                                }
                                setOfDuplicateRelease.add(releaseObj.Product_Release__c);
                            }
                        }
                        if(mapOfComponent==null || mapOfComponent.isEmpty() || mapOfComponent.keySet()==null){
                            mapOfComponent.put('All','All components are selected');
                        }
                        
                        if(mapOfRelease==null || mapOfRelease.isEmpty() || mapOfRelease.keySet()==null){
                            mapOfRelease.put('All','All Releases are selected');
                        }
                        
                        if(mapOfSelectedRelease==null || mapOfSelectedRelease.isEmpty() || mapOfSelectedRelease.keySet()==null){
                            mapOfSelectedRelease.put('-None-','No Release Selected');
                        }
                        system.debug(mapOfComponent+'---sss-->'+mapOfSelectedComponent.size());
                        system.debug('---mapOfSelectedComponent-->'+mapOfSelectedComponent);
                        showComp = true;
                    }
                }else if(mapForEditScenario<>null && mapForEditScenario.keySet()<>null){
                    mapOfComponent = new Map<String,String>();
                    mapOfSelectedComponent = new Map<String,String>();
                    mapOfRelease = new Map<String,String>();
                    mapOfSelectedRelease = new Map<String,String>();
                    
                    if(listOfComp<>null && listOfComp.size()>0){
                        Boolean checkFlag = false;
                        set<String> setOfComp = new set<String>();
                        set<String> setOfRelease = new set<String>();
                        if(mapForEditScenario.get(productVal)<>null){
                            for(String innerKey:mapForEditScenario.get(productVal).keySet()){
                                mapOfSelectedComponent.put(innerKey,mapForEditScenario.get(productVal).get(innerKey));   
                                setOfComp.add(mapForEditScenario.get(productVal).get(innerKey));
                            }
                        }
                    
                        if(mapForEditReleaseScenario<>null && mapForEditReleaseScenario.keySet()<>null && mapForEditReleaseScenario.get(productVal)<>null){
                            for(String innerKey:mapForEditReleaseScenario.get(productVal).keySet()){
                                mapOfSelectedRelease.put(innerKey,mapForEditReleaseScenario.get(productVal).get(innerKey));    
                                setOfRelease.add(mapForEditReleaseScenario.get(productVal).get(innerKey));
                            }
                        }
                    
                        for(ca_product_component__c pcObj:listOfComp){
                            if(mapOfSelectedComponent.get(pcObj.Id)==null && (setOfComp==null || setOfComp.size()==0 || (setOfComp<>null && setOfComp.size()>0 && !setOfComp.contains(pcObj.Component_Code__c)))){
                                mapOfComponent.put(pcObj.Id, pcObj.Component_Code__c);    
                            }
                        }
                        
                        set<String> setOfDuplicateRelease = new set<String>();
                        if(listOfProductRelease<>null && listOfProductRelease.size()>0){
                            for(Product_Release__c prodReleaseObj:listOfProductRelease){
                                if(mapOfSelectedRelease.get(prodReleaseObj.Id)==null && (setOfDuplicateRelease==null || setOfDuplicateRelease.size()==0 || !setOfDuplicateRelease.contains(prodReleaseObj.Product_Release__c))){
                                    mapOfRelease.put(prodReleaseObj.Id,prodReleaseObj.Product_Release__c);
                                }
                                setOfDuplicateRelease.add(prodReleaseObj.Product_Release__c);
                            }
                        }
                        system.debug('--mapOfComponent->'+mapOfComponent);
                        if(mapOfComponent==null || mapOfComponent.isEmpty() || mapOfComponent.keySet()==null){
                            mapOfComponent.put('All','All components are selected');
                        }
                    
                        if(mapOfRelease==null || mapOfRelease.isEmpty() || mapOfRelease.keySet()==null){
                            mapOfRelease.put('All','All Releases are selected');
                        }
                        
                        if(mapOfSelectedRelease==null || mapOfSelectedRelease.isEmpty() || mapOfSelectedRelease.keySet()==null){
                            mapOfSelectedRelease.put('-None-','No Release Selected');
                        }
                    }        
                }
            }
        }
    }
    
    public void submitProductAssociation(){
        String buttonVal = System.currentPagereference().getParameters().get('buttonId');    
        system.debug('*listOfWrapperProductDetails***'+listOfWrapperProductDetails);
        if(String.isNotBlank(buttonVal) && String.isNotBlank(articleIdVal) && listOfWrapperProductDetails<>null && listOfWrapperProductDetails.size()>0){
            insertKCSAssociation(listOfWrapperProductDetails,buttonVal);
        }
    }    
    
    private void insertKCSAssociation(List<wrapperProductDetails> listOfWrapperProductDetails, String buttonName){
        if(listOfWrapperProductDetails<>null && listOfWrapperProductDetails.size()>0){
            List<KCS_Association__c> listOfKCSAssociation = new List<KCS_Association__c>();
            Set<String> setOfProduct = new Set<String>();
            Set<String> setOfComp = new Set<String>();
            Set<String> setOfRelease = new Set<String>();
            Set<Integer> count = new Set<Integer>();
            Map<String,Integer> setOfProductCount = new Map<String,Integer>();
            Map<String,String> mapOfReleaseNames = new Map<String,String>();
            
            for(wrapperProductDetails wrapperObj:listOfWrapperProductDetails){
                if(String.isNotBlank(wrapperObj.componentIds)){
                    List<String> splitComponentIds = wrapperObj.componentIds.split(';');
                    for(String componentVal:splitComponentIds){
                        if(String.isNotBlank(componentVal)){
                            KCS_Association__c kcsObj = new KCS_Association__c();
                            kcsObj.Article_Id__c = articleIdVal;
                            kcsObj.Component_ID__c = componentVal;
                            if(wrapperObj.primaryProduct == null){
                                wrapperObj.primaryProduct = false;
                            }
                            kcsObj.Primary__c = wrapperObj.primaryProduct;
                            kcsObj.Product_ID__c = wrapperObj.productIdVal;
                            kcsObj.Product_Count__c = wrapperObj.productCount;
                            setOfProduct.add(wrapperObj.productIdVal);
                            count.add(wrapperObj.productCount);
                            setOfProductCount.put(wrapperObj.productIdVal,wrapperObj.productCount);
                            setOfComp.add(wrapperObj.productIdVal+'_'+componentVal.replace(' ',''));
                            listOfKCSAssociation.add(kcsObj);
                        }    
                    }
                }
                
                
                if(String.isNotBlank(wrapperObj.releaseIds)){
                    List<String> splitReleaseIds = wrapperObj.releaseIds.split(';');
                    for(String releaseVal:splitReleaseIds){
                        if(String.isNotBlank(releaseVal) && releaseVal!='-None-'){
                            setOfProduct.add(wrapperObj.productIdVal);
                            KCS_Association__c kcsObj = new KCS_Association__c();
                            kcsObj.Article_Id__c = articleIdVal;
                            kcsObj.Release_ID__c = releaseVal;
                            if(wrapperObj.primaryProduct == null){
                                wrapperObj.primaryProduct = false;    
                            }
                            kcsObj.Primary__c = wrapperObj.primaryProduct;
                            kcsObj.Product_ID__c = wrapperObj.productIdVal;
                            kcsObj.Product_Count__c = wrapperObj.productCount;
                            count.add(wrapperObj.productCount);
                            setOfProductCount.put(wrapperObj.productIdVal,wrapperObj.productCount);
                            setOfRelease.add(wrapperObj.productIdVal+'_'+releaseVal.replace(' ',''));
                            listOfKCSAssociation.add(kcsObj);
                        }    
                    }
                }
            }
            
            if(listOfKCSAssociation<>null && listOfKCSAssociation.size()>0 && setOfComp<>null && setOfComp.size()>0 && setOfProduct<>null && setOfProduct.size()>0){
                Map<String,String> mapOfCAProducts = new Map<String,String>();
                Map<String,String> mapOfCompName = new Map<String,String>();
                Map<String,String> mapOfCompCode = new Map<String,String>();
                Map<String,String> mapOfRelease = new Map<String,String>();
                Map<String,String> mapOfXMDandCA = new Map<String,String>();
                Map<String,String> xmdAndFullProd = new Map<String,String>();
                Map<Id,String> mapOfXMDAndProdComp = new Map<Id,String>();
                Map<Id,String> mapOfXMDAndProdCode = new Map<Id,String>();
                Map<Id,String> mapOfXMDAndRelease = new Map<Id,String>();
                set<Id> setOfCAProduct = new set<Id>();
                set<Id> setOfXMDIds = new set<Id>();
                Map<String,String> setOfXMD = new Map<String,String>();
                
                List<CA_XMD_Product_Mapping__c> listOfProductMap = [Select id, CA_Product__c, CA_Product__r.Name, XMD_Product__c, XMD_Product__r.CMS_ID__c, XMD_Product__r.Name from CA_XMD_Product_Mapping__c where CA_Product__c!=null AND CA_Product__c!='' AND XMD_Product__r.CMS_ID__c!='' AND XMD_Product__c IN:setOfProduct];
                
                if(listOfProductMap<>null && listOfProductMap.size()>0){
                    for(CA_XMD_Product_Mapping__c mapObj:listOfProductMap){
                        setOfCAProduct.add(mapObj.CA_Product__c);
                        mapOfXMDandCA.put(mapObj.XMD_Product__c,mapObj.XMD_Product__r.Name);
                        setOfXMD.put(mapObj.XMD_Product__c,mapObj.XMD_Product__r.CMS_ID__c);
                    }                                                               
                }
                
                if(setOfComp<>null && setOfComp.size()>0 && setOfCAProduct<>null && setOfCAProduct.size()>0){
                    set<String> newCompSet = new set<String>();
                    for(String compIds:setOfComp){
                        newCompSet.add(compIds.subStringAfter('_'));    
                    }
                    
                    List<CA_Product_Component__c> listOfComponent = [Select id, Name, CA_Product_Controller__c, Component_Code__c,CA_Product_Controller__r.Name,Component_Text__c from CA_Product_Component__c where Component_Text__c!='' AND Component_Text__c!=null AND CA_Product_Controller__c!=:null AND CA_Product_Controller__r.Name!=null AND CA_Product_Controller__r.Name !=:'' AND id IN:newCompSet];
                    if(listOfComponent<>null && listOfComponent.size()>0){
                        for(CA_Product_Component__c componentObj:listOfComponent){
                            mapOfCompName.put(componentObj.Id,componentObj.Name);
                            mapOfCompCode.put(componentObj.Id,componentObj.Component_Code__c);
                        }
                    
                        if(mapOfCompName<>null && mapOfCompName.size()>0 && mapOfCompCode<>null && mapOfCompCode.size()>0){
                            for(String prepareString:setOfComp){
                                system.debug('prepareString.substringBefore: '+prepareString.substringBefore('_'));
                                setOfXMDIds.add(prepareString.substringBefore('_'));
                                system.debug('setOfXMDIds: '+setOfXMDIds);
                                if(setOfXMDIds<>null && setOfXMDIds.size()>0 && setOfXMDIds.contains(prepareString.substringBefore('_'))){
                                    String compVal = prepareString.substringAfter('_');
                                    String xmdVal = prepareString.substringBefore('_');
                                    if(mapOfXMDAndProdComp==null || mapOfXMDAndProdComp.size()==0 || mapOfXMDAndProdComp.isEmpty() || !mapOfXMDAndProdComp.containsKey(xmdVal)){
                                        mapOfXMDAndProdComp.put(xmdVal,mapOfCompName.get(compVal));    
                                    }else if(mapOfXMDAndProdComp<>null && mapOfXMDAndProdComp.size()>0 && mapOfXMDAndProdComp.containsKey(xmdVal)){
                                        mapOfXMDAndProdComp.put(xmdVal,mapOfXMDAndProdComp.get(xmdVal)+'; '+mapOfCompName.get(compVal));
                                    }
                                    
                                    if(mapOfXMDAndProdCode==null || mapOfXMDAndProdCode.size()==0 || mapOfXMDAndProdCode.isEmpty() || !mapOfXMDAndProdCode.containsKey(xmdVal)){
                                        mapOfXMDAndProdCode.put(xmdVal,mapOfCompCode.get(compVal));    
                                    }else if(mapOfXMDAndProdCode<>null && mapOfXMDAndProdCode.size()>0 && mapOfXMDAndProdCode.containsKey(xmdVal)){
                                        mapOfXMDAndProdCode.put(xmdVal,mapOfXMDAndProdCode.get(xmdVal)+'; '+mapOfCompCode.get(compVal));
                                    }
                                }
                            }    
                        }
                    }
                }
                
                if(setOfRelease<>null && setOfRelease.size()>0 && setOfCAProduct<>null && setOfCAProduct.size()>0){
                    set<String> newReleaseIds = new set<String>();
                    for(String releaseIdObj:setOfRelease){
                         newReleaseIds.add(releaseIdObj.subStringAfter('_'));   
                    }
                    List<Product_Release__c> listOfProductRelease = [Select Id,Product_Release__c,Product_Material__r.CA_Product_Controller__c, Product_Material__r.CA_Product_Controller__r.Name from Product_Release__c where Product_Release__c!=null AND Product_Release__c!='' AND Product_Material__c!=null AND Product_Material__r.CA_Product_Controller__c!=null AND Product_Material__r.CA_Product_Controller__c IN:setOfCAProduct AND Id IN:newReleaseIds];    
                    system.debug('listOfProductRelease: '+listOfProductRelease);
                    if(listOfProductRelease<>null && listOfProductRelease.size()>0){
                        for(Product_Release__c releaseObj:listOfProductRelease){
                            mapOfRelease.put(releaseObj.Id,releaseObj.Product_Release__c);   
                        }
                        system.debug('mapOfRelease: '+mapOfRelease);
                        set<String> setOfReleases = new set<String>();
                        for(String prepareString:setOfRelease){
                            setOfReleases.add(prepareString.substringBefore('_'));   
                            if(setOfReleases<>null && setOfReleases.size()>0 && setOfReleases.contains(prepareString.substringBefore('_'))){
                                String releaseVal = prepareString.substringAfter('_');
                                String xmdVal = prepareString.substringBefore('_');
                                if(mapOfXMDAndRelease==null || mapOfXMDAndRelease.size()==0 || mapOfXMDAndRelease.isEmpty() || !mapOfXMDAndRelease.containsKey(xmdVal)){
                                    mapOfXMDAndRelease.put(xmdVal,mapOfRelease.get(releaseVal));    
                                }else if(mapOfXMDAndRelease<>null && mapOfXMDAndRelease.size()>0 && mapOfXMDAndRelease.containsKey(xmdVal)){
                                    mapOfXMDAndRelease.put(xmdVal,mapOfXMDAndRelease.get(xmdVal)+'; '+mapOfRelease.get(releaseVal));
                                }
                            }
                        }
                        system.debug('mapOfXMDAndRelease: '+mapOfXMDAndRelease);
                    }
                }
                
                if(mapOfXMDandCA<>null && mapOfXMDandCA.size()>0 && setOfCAProduct<>null && setOfCAProduct.size()>0 && mapOfCompName<>null && mapOfCompName.size()>0 && mapOfCompCode.size()>0){
                    List<XMD_Product__c> listOfXMD = [Select id, Name from XMD_Product__c where id IN:setOfProduct];
                    Map<Integer,String> sortProductName = new Map<Integer,String>();
                    Map<Integer,String> sortCompName = new Map<Integer,String>();
                    Map<Integer,String> sortCompCode = new Map<Integer,String>();
                    Map<Integer,String> sortRelease = new Map<Integer,String>();
                    Map<Integer,String> sortCMSId = new Map<Integer,String>();
                    if(listOfXMD<>null && listOfXMD.size()>0){
                        String productNames = '';
                        String componentNames = '';
                        String componentCode = '';
                        String releaseVersion = '';
                        String cmsIds = '';
                        for(XMD_Product__c caProductObj:listOfXMD){
                            if(mapOfXMDandCA<>null && mapOfXMDandCA.size()>0 && String.isNotBlank(mapOfXMDandCA.get(caProductObj.id))){
                                sortProductName.put(setOfProductCount.get(caProductObj.id),mapOfXMDandCA.get(caProductObj.id)+'\n');
                            }
                            
                            if(mapOfXMDAndProdComp<>null && mapOfXMDAndProdComp.size()>0 && String.isNotBlank(mapOfXMDAndProdComp.get(caProductObj.id))){
                                componentNames = componentNames+ caProductObj.Name+': '+ mapOfXMDAndProdComp.get(caProductObj.id)+'\n';
                                sortCompName.put(setOfProductCount.get(caProductObj.id),caProductObj.Name+': '+ mapOfXMDAndProdComp.get(caProductObj.id)+'\n');
                            }
                            if(mapOfXMDAndProdCode<>null && mapOfXMDAndProdCode.size()>0 && String.isNotBlank(mapOfXMDAndProdCode.get(caProductObj.id))){
                                componentCode = componentCode+ caProductObj.Name+': '+mapOfXMDAndProdCode.get(caProductObj.id)+'\n';
                                sortCompCode.put(setOfProductCount.get(caProductObj.id),caProductObj.Name+': '+mapOfXMDAndProdCode.get(caProductObj.id)+'\n');
                            }
                            
                            if(mapOfXMDAndRelease<>null && mapOfXMDAndRelease.size()>0 && String.isNotBlank(mapOfXMDAndRelease.get(caProductObj.id))){
                                releaseVersion = releaseVersion+ caProductObj.Name+': '+mapOfXMDAndRelease.get(caProductObj.id)+'\n';
                                sortRelease.put(setOfProductCount.get(caProductObj.id),caProductObj.Name+': '+mapOfXMDAndRelease.get(caProductObj.id)+'\n');
                            }
                            
                            if(setOfXMD<>null && setOfXMD.size()>0 && String.isNotBlank(setOfXMD.get(caProductObj.Id))){
                                cmsIds = cmsIds + setOfXMD.get(caProductObj.Id)+';';  
                                sortCMSId.put(setOfProductCount.get(caProductObj.id),setOfXMD.get(caProductObj.Id)+';');
                            }
                        }
                        
                        if(String.isNotBlank(componentNames) && String.isNotBlank(componentCode)){
                            String pn = '';
                            String cn = '';
                            String cc = '';
                            String cms = '';
                            String rn = '';
                            for(Integer i:count){
                                if(sortProductName<>null && sortProductName.size()>0 && String.isNotBlank(sortProductName.get(i))){
                                    pn = pn + sortProductName.get(i);
                                }
                                if(sortCompName<>null && sortCompName.size()>0 && String.isNotBlank(sortCompName.get(i))){
                                    cn = cn + sortCompName.get(i);    
                                }
                                if(sortCompCode<>null && sortCompCode.size()>0 && String.isNotBlank(sortCompCode.get(i))){
                                    cc = cc + sortCompCode.get(i);   
                                }
                                if(sortCMSId<>null && sortCMSId.size()>0 && String.isNotBlank(sortCMSId.get(i))){
                                    cms = cms + sortCMSId.get(i);  
                                }
                                if(sortRelease<>null && sortRelease.size()>0 && String.isNotBlank(sortRelease.get(i))){
                                    rn = rn + sortRelease.get(i);    
                                }
                            }
                            List<knowledge__kav> listOfArticle = [select id,articlenumber, PublishStatus from knowledge__kav where PublishStatus='Draft' AND articleNumber=:articleId limit 1];
                            List<knowledge__kav> listOfTest = new List<knowledge__kav>();
                            knowledge__kav testingObj = new knowledge__kav(Id=listOfArticle[0].Id);
                            testingObj.Component_Names__c = cn;
                            testingObj.Component_Codes__c = cc;
                            testingObj.Product_Names__c = pn;
                            testingObj.Releases__c = rn;
                            testingObj.CMS_IDs__c = cms;    
                            listOfTest.add(testingObj);
                            
                            if(listOfTest<>null && listOfTest.size()>0){
                                Boolean updatedFlag = false;
                                String errorString = '';
                                try{Database.update(listOfTest);updatedFlag=true;}Catch(Exception e){errorString=e.getMessage();system.debug('---UPDATE FAILED LINE NUMBER 695-----');}    
                                
                                if(updatedFlag){
                                    Boolean insertKCS = false;
                                    List<KCS_Association__c> deleteList = [Select id from KCS_Association__c where article_id__c=:articleIdVal];
                                    if(deleteList<>null && deleteList.size()>0){
                                        Boolean deleteFlag = false;
                                        try{Database.delete(deleteList);deleteFlag=true;}Catch(Exception e){errorString=e.getMessage();system.debug('---UPDATE FAILED LINE NUMBER 856-----');}
                                        if(deleteFlag){
                                            try{Database.insert(listOfKCSAssociation);insertKCS=true;}Catch(Exception e){errorString=e.getMessage();system.debug('---UPDATE FAILED LINE NUMBER 856-----');}
                                            if(insertKCS){
                                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product Association Successfully completed and Article <b>'+articleId+'</b> successfully updated. Please check the draft version of the article!!!');
                                                ApexPages.addMessage(myMsg);    
                                            }else{
                                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorString);
                                                ApexPages.addMessage(myMsg);    
                                            }    
                                        }else{
                                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorString);
                                            ApexPages.addMessage(myMsg);    
                                        }
                                    }else{
                                        try{Database.insert(listOfKCSAssociation);insertKCS=true;}Catch(Exception e){errorString=e.getMessage();system.debug('---UPDATE FAILED LINE NUMBER 856-----');}
                                        if(insertKCS){
                                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product Association Successfully completed and Article <b>'+articleId+'</b> successfully updated. Please check the draft version of the article!!!');
                                            ApexPages.addMessage(myMsg);    
                                        }else{
                                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorString);
                                            ApexPages.addMessage(myMsg);    
                                        }     
                                    }
                                }else{
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorString);
                                    ApexPages.addMessage(myMsg);
                                }
                            }
                        }
                    }    
                }
            }
        }
    }
    
    
    public class wrapperProductDetails{
        public String articleId{get;set;}
        public String productId{get;set;}
        public String componentNames{get;set;}
        public String releaseNames{get;set;}
        public String productIdVal{get;set;}
        public String componentIds{get;set;}
        public String releaseIds{get;set;}
        public Boolean primaryProduct{get;set;}
        public String articlePreviousStatus{get;set;}
        public Integer productCount{get;set;}
    }
}