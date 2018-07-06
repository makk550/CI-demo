/************************************************************************************************
* Modified By 		 Date           User Story      Details
* SAMAP01			02/22/2018		US450479		GPOC: Display and Verify that products selected are associated with the Sales Coverage BU selected
* SAMAP01			03/07/2018		US450538		GPOC: Eliminate the need to input license quantities 
* samap01			03/20/2019		US450476		GPOC:  Display only the products associated with the Product Type 
* SAMAP01			03/27/2019		US450482 		GPOC: Allow mixing of SaaS and On-Premises products on one POC (Request Type) -Multitypes
* SAMAP01			03/27/2019		US450474		GPOC: Support of Options (license keys only, no download – that is not available now) 
* **********************************************************************************************/
public with sharing class PocMaterialController {
    
    @TestVisible
    private Trial_Request__c poc;
    //samap01
    public boolean showallscbu{get;set;}
    public boolean showallrt{get;set;}
    public boolean isSaaSstdtype{get;set;}
    //samap01
    public boolean ifNoError {get; set;}
    public List<ckProduct> ckProductList {
        get {
            if (ckProductList == null) {
                ckProductList = new ckProduct[]{};
                    }
            return ckProductList;
        } 
        set;
    }
    public boolean isViewMode {get; set;}
    public List<ckProduct> currentPocProductMaterials {get; set;}  
    Set<String> scbuset = new Set<string> ();  //samap01
    public string pocid ='';
    public string pocbusid='';
    public  Boolean pocmultitype =false; //samap01 
    Set<String> requesttypeset = new Set<string> ();  //samap01
    Map<Id,Boolean> MatLicenseonly = NEW    Map<Id,Boolean>();//samp01
    public string strrequesttype = '';
    public string strscbu = '';
    public boolean isCancelled {get; set;}
    public  string GPOC_UIM_TopsCodes = System.label.GPOC_UIM_TopsCodes ; 
    public set<Id> productmaterialId = new Set<Id>();
    // CTOR
    @TestVisible
    private PocMaterialController(){}
    
    public PocMaterialController(ApexPages.StandardController controller) {
        controller.addFields(new String[]{'Id', 'Name', 'Opp_Name__c' ,'Business_Unit__c','Request_Type__c','POC_SAAS_Type__c','Request_Status__c','Products_Added__c'}); //samap01 -Business_Unit__c,POC_SAAS_Type__c,Request_Type__c
        this.poc = (Trial_Request__c)controller.getRecord();
        this.pocid = poc.id;
        this.pocbusid = poc.Business_Unit__c ;
        //system.debug('samap01 pocbusid' +pocbusid);
        isCancelled=false;
        // this.strrequesttype = poc.Request_Type__c ; //samap01
        List<pocMaterial__c> pocProducts = [Select Id from pocMaterial__c where POC_Request__c=:poc.id];
        if(pocProducts.size() >0 && poc.Request_Type__c =='POC Multitype Request' )
        {
            showallscbu =true;
            showallrt =true;
        }
        else
        {
            showallscbu =false;
            showallrt=false;
        }
        init();
        //US479879 
        // if(poc.Request_Status__c =='Cancelled' || poc.Request_Status__c =='Extension for Approval' || poc.Request_Status__c =='Extension Approved' ||
        //   poc.Request_Status__c == 'Expired' || poc.Request_Status__c == 'Request Approved' || poc.Request_Status__c == 'In Process' )
        
        if( poc.Request_Status__c == 'New' || poc.Request_Status__c == 'Request for Approval' )
        {
            isViewMode = false;
            isCancelled =false;
        }
        else
        {
            isViewMode = true;
            isCancelled =true;
            string errmessage = 'Product Materials cannot be edited for Request status - ' + poc.Request_Status__c  ; 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, errmessage));
            return ;
        }
        
        
        if(poc.Products_Added__c> 0  && poc.Products_Added__c !=null )  //samap01 
        {
            isViewMode = true;
        }
        else
        {
            isViewMode = false;
        }
        system.debug('samap01 isViewMode' +isViewMode);   
    }
    
    public void editMaterialSelection() {
        //US479879 
        // if(poc.Request_Status__c =='Cancelled' || poc.Request_Status__c =='Extension for Approval' || poc.Request_Status__c == 'Expired' || poc.Request_Status__c =='Request Approved' )
        if( poc.Request_Status__c == 'New' || poc.Request_Status__c == 'Request for Approval' )
        {
            isViewMode = false;
            isCancelled =false;
        }
        else
        {
            isViewMode = true;
            string errmessage = 'Product Materials cannot be edited for Request status - ' + poc.Request_Status__c  ; 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, errmessage));
            
        }
        
    }
    
    public void cancel() {
        isViewMode = true;
    }
    
    
    public void refreshmaterials() {
        system.debug('samap01 refreshmaterials'+showallscbu);        
        init();
        isViewMode = false;
    }
    // handle the action of the commandButton
    public void saveMaterialSelection() {
        // existing pocmaterials on this trial request - we delete all of these
        List<pocMaterial__c> pocProducts = [Select Id from pocMaterial__c where POC_Request__c=:poc.id];
        delete pocProducts;
        
        List<Trial_Request__c> trRequest = new List<Trial_Request__c>();
        trRequest  =  [Select Id,Materials_For_Email__c,Products_Added__c,Business_Unit__c,Request_type__C //samap01
                       from Trial_Request__c where Id =:poc.id];
        trRequest[0].Products_Added__c = -1; // why do this?
        update trRequest;
        
        // add product materials selected for trials to a list of pocMaterials to save
        List<pocMaterial__c> pmsToSave = buildPmsToSave();
        
        // save poc materials, if any
        if(pmsToSave.size() > 0) {
            
            // US450482 : GPOC: Allow mixing of SaaS and On-Premises 
         	 /*  if(pocmultitype)
            {
                if ( trRequest[0].Request_type__C  != 'POC Multitype Request')
                {
                    
                    trRequest[0].Request_type__C  = 'POC Multitype Request';
                    
                }
            }
			*/
            //samap01
            insert pmsToSave;
            trRequest[0].Products_Added__c = pmsToSave.size();
            update trRequest;
            isViewMode = true;
        } 
        // if there are no poc materials to save then do this.
        else {
            trRequest[0].Products_Added__c = 0; // did they mean to save this?
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Materials selected to save.'));
            ifNoError = true;
        }
        
        FetchTransactionalProducts();
    }   
    
    private pocMaterial__c[] buildPmsToSave() {
        // add product materials selected for trials to a list of pocMaterials to save
        List<pocMaterial__c> pmsToSave = new List<pocMaterial__c>();
        for(ckProduct selprod: ckProductList){
            
            for(ckProductMaterial selprodmaterial: selprod.pms){
                if(selprodmaterial.selected){ 
                    pocMaterial__c prodmaterial = new pocMaterial__c();
                    //List<Product2> p = [select Id from Product2 where Id=:selprod.product.Id limit 1];
                    prodmaterial.Product__c = selprod.product.Id;
                    // prodmaterial.quantity__c = selprodmaterial.qty;  //US450538 - Quantity not required anymore
                    prodmaterial.Product_Material__c = selprodmaterial.materialId;
                    prodmaterial.POC_Request__c = poc.Id;
                    pmsToSave.add(prodmaterial);
                    //samap01 - US450482 
                    if(scbuset.size()>0)
                    {
                        if(!scbuset.contains(selprodmaterial.scbu))
                            scbuset.add(selprodmaterial.scbu); 
                    }
                    else
                    {
                        scbuset.add(selprodmaterial.scbu); 
                    }
                    
                    if(this.pocbusid  =='Mainframe')    //US450476                 
                    {
                        if(MatLicenseonly != null && MatLicenseonly.size() >0 )
                        {
                            
                            boolean haslicense =  MatLicenseonly.get(selprodmaterial.materialId);
                            
                            if(haslicense != null && haslicense ==true)
                            {
                                selprodmaterial.requesttype ='OPTION' ; 
                                
                            }   
                            else
                            {
                                selprodmaterial.requesttype ='SOFTWARE';
                            }                      
                            
                        }
                        
                    }
                    //US450482 
                    system.debug('samap01 strrequesttype' + strrequesttype);
                    system.debug('samap01 selprodmaterial.requesttype' + selprodmaterial.requesttype);
                    if(strrequesttype != selprodmaterial.requesttype)
                    {
                        pocmultitype =true;
                    }
                    
                    
                }
            }
        }
        return pmsToSave;
    }
    
    @TestVisible
    private void init() {
        ifNoError = true;
        ckProductList = new List<ckProduct>();
        //poc = [Select Id, Name, Opp_Name__r.Id from Trial_Request__c where Id=:poc.id];
        string swhere=''; //samap01
        Boolean viewMaterial = false;
        
        
        String oppid =poc.Opp_Name__c;
        List<OpportunityLineItem> ols = Database.query('Select Id,PriceBookEntry.Product2Id,PricebookEntry.Product2.Name From OpportunityLineItem where OpportunityId= \''+oppid + '\'');
        
        
        String pocquery = 'Select Id, quantity__c, Product_Material__r.Id, Product_Material__r.Material_Text__c, Product__r.Id, Product_Material__r.IsAppliance__C, '+ //samap01
            ' Product__r.Name ,Product__r.Market_Focus_Area__c,Product__r.Mainframe_or_Distributed__c,Product_Material__r.Platform_Category__c from pocMaterial__c where POC_Request__c=\''+pocid + '\'' ;
        //US450482 -Allow mixing of request type -POC Multi type
        if(poc.Request_Type__c == 'POC Multitype Request')
        {                   
            pocmultitype =true;
        }
        else
        {                   
            pocmultitype =false;
        } 
        if(!showallscbu)
        {
            System.debug('samap01 init showallscbu' + showallscbu);
            pocquery = pocquery + ' and Product__r.Market_Focus_Area__c=\''+pocbusid + '\'';
            
        }
        //samap01 -US450476
        if(!showallrt)
        {
            System.debug('samap01 init showallrt' + showallrt);
            pocquery = sWhere(pocquery);            
        }
        //US450482 -Allow mixing of request type -POC Multi type
        if(pocmultitype)
        {
            showallrt =true;
        }
        
        
        system.debug('samap01 pocquery in init'+ pocquery );
        List<pocMaterial__c> tPocProductMaterials = Database.query(pocquery);
        
        
        //build set of productIDs
        Set<Id> productIdSet = new Set<Id>();
        for(OpportunityLineitem ol : ols){
            productIdSet.add(ol.PriceBookEntry.Product2Id);
        }
        
        
        
        //build product map
        Map<Id, Product2> products = buildProductMap(productIdSet);
        Map<Id, List<Product_Material__c>> materialMapByProductId = buildMaterialMap(productIdSet);
        
        system.debug(ols.size()+'   ols size1*****');
        for(OpportunityLineitem ol : ols) {                
            ckProduct prod = new ckProduct();                
            Product2 product = products.get(ol.PriceBookEntry.Product2Id);
            prod.product = product;
            List<Product_Material__c> materials = materialMapByProductId.get(product.Id); //[select Id, Material_Text__c, Source_System__c, SAP_Product_Mapping__c, Product__r.Id, Product__r.Name from Product_Material__c where Product__r.Id = :prod.product.Id and Source_System__c = 'SAP' and POC_Eligible__c = True];  
            system.debug('samap01 product.Id '+product.Id);
            //Populate for Edit mode        
            for (Product_Material__c mat : materials) {
                ckProductMaterial prodm = new ckProductMaterial();   
                prodm.scbu = mat.Product__r.Market_Focus_Area__c ;
                prodm.platformcategory = mat.Platform_Category__c ;
                prodm.materialId = mat.Id;            
                prodm.materialName = mat.Material_Text__c;    
                prodm.saptopsid = mat.SAP_Product_Mapping__c;               
                
                system.debug('samap01 materials Id '+mat.Id); 
                if (tPocProductMaterials.size() > 0 ) {   
                    prodm.selected = false;           
                }       
                //samap01US450482 : GPOC: Allow mixing of SaaS and On-Premises products -get request type information
                ////US483691
                if(GPOC_UIM_TopsCodes.containsIgnoreCase(mat.SAP_Product_Mapping__c))
                {
                    prodm.requesttype ='HYBRID';
                } //US483691
                else if(mat.IsAppliance__C ==true)
                {
                    prodm.requesttype ='APPLIANCE';
                }
                else if(mat.Platform_Category__c =='SAAS')
                {
                    prodm.requesttype ='SAAS';
                    
                    
                }
           
                else
                {
                    prodm.requesttype ='SOFTWARE';
                }
                
                //samap01 US450482 : GPOC: Allow mixing of SaaS and On-Premises products 
                for(pocMaterial__c currentpocmitem: tPocProductMaterials) {
                    system.debug('condition -->' + currentpocmitem.Product_Material__r.Id + '=='+ mat.Id);
                    if(currentpocmitem.Product_Material__r.Id == mat.Id) {                  
                        prodm.selected = true;                   
                        //  prodm.qty = currentpocmitem.quantity__c;  //US450538 - not required to input quantity
                    }               
                } 
                prod.pms.add(prodm);        
                SYSTEM.debug('samap01 prodm'+prodm);
                viewMaterial = true ;   //samap01
            }
            if(materials.size() > 0) {
                ckProductList.add(prod);
                system.debug('samap01 added to the list ckProductList' );
            }
          //  system.debug('sadfds --> ' +  ckProductList);
        }
        
        
        
        //samap01  US450474	GPOC: Support of Options
        // phase 2 - build currentPocProductMaterials
        FetchTransactionalProducts();
        
        // error handling
        system.debug('material size*****');
        //samap01 US469160  - SAAS request
        if(poc.Request_Type__c== 'POC Saas Request' &&  poc.POC_SAAS_Type__c == 'Standard' && !showallrt )
        {
            isSaaSstdtype =true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.GPOC_SaaS_Error_Message));
        }
        if(showallrt )
        {
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.GPOC_Multitype_Message));
        }
        if(ols.size()==0||ols==null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Products added to the opportunity'));
            ifNoError = false;
        } 
        else if(viewMaterial == false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.GPOC_Norecords)); //samap01  -putting right msg 'Product not marked POC eligible in SFDC, please contact GlobalPOCTeam@ca.com'));
            ifNoError = false;
        }
        
    }
    
    @TestVisible
    private Map<Id, Product2> buildProductMap(Set<Id> productIds) {
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        // populate map from SOQL
        List<Product2> products = [select Id, Name,Market_Focus_Area__c,Platform_Category__c,Mainframe_or_Distributed__c from Product2 where Id in :productIds and Salesforce_CPQ_Product__c=false];
        productMap.putAll(products);
        return productMap;
    }
    
    //samap01  US450474 -Get licenseonly information
    @TestVisible
    private Map<Id,Boolean> LicenseOnlyMainframe(set<Id> productmaterialId)
    {
        System.debug('samap01 - LicenseOnlyMainframe productmaterialId' + productmaterialId);
        map<id,boolean> mapprodlicenseonly = new map<id,boolean>();
        List<Product_Release__c > prodrelease = new  List<Product_Release__c >();
        if(productmaterialId.size() >0)
        {
            prodrelease  = [select Product_Material__c , Product_Release__c ,Has_Entitlement__c
                            from Product_Release__c where  GA_Level__C =0.0 and  Product_Material__c in : productmaterialId ] ; 
            //from Product_Material__c where Product__r.Id IN :productIds 
        }
        //system.debug('samap01 prodrelease'+prodrelease);
        for(Product_Release__c pocrelease : prodrelease)
        {             
            mapprodlicenseonly.put(pocrelease.Product_Material__c,pocrelease.Has_Entitlement__c);
            system.debug('samap01 prodrelease - has entitltment '+pocrelease.Has_Entitlement__c + '--'+pocrelease.Product_Material__c);
        }
        
        return mapprodlicenseonly ;
    }
    
    //US450476  - where clause 
    @TestVisible
    Private string sWhere(string pocquery )
    {
        System.debug('samap01 init poc.Request_Type__c' + poc.Request_Type__c);
        System.debug('samap01 init sWhere' + pocquery);
        if(poc.Request_Type__c == 'POC Appliance Request')
        {
            pocquery = pocquery + ' and Product_Material__r.IsAppliance__C= true ';
            strrequesttype ='APPLIANCE';
        }
        else if(poc.Request_Type__c == 'POC Saas Request')
        {
            string pcatogory = 'SAAS' ;
            pocquery = pocquery + ' and Product_Material__r.Platform_Category__c=\''+pcatogory + '\'' ;
            strrequesttype ='SAAS';
        }
        //samap01 4/23 - No filter for Platform category only the 
        else if(poc.Request_Type__c == 'POC Option Type Request')
        {
            // string pcatogory = 'Mainframe' ;
            // pocquery = pocquery + ' and Product_Material__r.Platform_Category__c=\''+pcatogory + '\'' ;
            strrequesttype ='OPTION';
        }
        
        
        
        else if(poc.Request_Type__c == 'POC Software Request')
        {
            
            //string []pcatogory = new string[]{'Mainframe', 'SAAS' } ;
            //  String pcatogory = '(\'';               
            //  pcatogory += 'Mainframe' + '\',\'' + 'SAAS' + '\'' + ')';  
            String pcatogory = '(\'' + 'SAAS' + '\'' + ')'; 
            
            pocquery = pocquery + ' and Product_Material__r.IsAppliance__C= false  ' ;
            pocquery =  pocquery+ ' and Product_Material__r.Platform_Category__c not in '+ pcatogory ;
            strrequesttype ='SOFTWARE';
        }
        else if(poc.Request_Type__c == 'POC Hybrid SaaS Request')
        {
            // string GPOC_UIM_TopsCodes = System.label.GPOC_UIM_TopsCodes ;         
            String[] arrtopscodes = GPOC_UIM_TopsCodes.split('\\,');
            String  prodcodes =''       ;
            for(String str : arrtopscodes)
                prodcodes += '\'' + str + '\',';
            prodcodes = prodcodes.lastIndexOf(',') > 0 ? '(' + prodcodes.substring(0,prodcodes.lastIndexOf(',')) + ')' : prodcodes ;
            
            pocquery =  pocquery+ ' and Product_Material__r.SAP_Product_Mapping__c in  '+ prodcodes ;
            strrequesttype ='HYBRID';
        }
        System.debug('samap01 init sWhere final' + pocquery);                 
        return pocquery ;
    }
    
    @TestVisible
    private Map<Id, List<Product_Material__c>> buildMaterialMap(Set<Id> productIds){
        Map<Id, List<Product_Material__c>> materialMap = new Map<Id, List<Product_Material__c>>();
        System.debug('samap01 productIds '+productIds );
        
        for (Id productId : productIds) {
            materialMap.put(productId, new List<Product_Material__c>());
        }
        
        String materialsquery = 'select Id, Material_Text__c, Source_System__c, SAP_Product_Mapping__c, Product__r.Id, Product__r.Name,IsAppliance__C, '+
            ' Product__r.Market_Focus_Area__c,Platform_Category__c,Product__r.Mainframe_or_Distributed__c from Product_Material__c where Product__r.Id IN :productIds ' ;
        //  ' Source_System__c =\''+sap + '\' and POC_Eligible__c = True' ;
        //only mainframe scbu 
        if(poc.Request_Type__c == 'POC Option Type Request')
        {
            string sourcesys ='TOPS';
             materialsquery +=  ' and Source_System__c =\''+sourcesys + '\' and POC_Eligible__c = True ' ;
          //	String sourcesys = '(\''+ 'SAP' + '\',\'' + 'TOPS' + '\'' + ')'; 
          //  materialsquery +=  ' and Source_System__c in '+sourcesys + ' and POC_Eligible__c = True ' ;
        }
        else
        {
            string sourcesys ='SAP';
            materialsquery +=  ' and Source_System__c =\''+sourcesys + '\' and POC_Eligible__c = True ' ;
        }
        
        
        if(!showallscbu)
        {
            System.debug('samap01 init showallscbu' + showallscbu);
            materialsquery = materialsquery + ' and Product__r.Market_Focus_Area__c=\''+pocbusid + '\'';     
            
        }
        
        //samap01 -US450476
        if(!showallrt)
        {
            System.debug('samap01 init showallrt' + showallrt);
            if(poc.Request_Type__c == 'POC Appliance Request')
            {
                materialsquery = materialsquery + ' and IsAppliance__C= true ';
                strrequesttype ='APPLIANCE';
            }
            else if(poc.Request_Type__c == 'POC Saas Request')
            {
                string pcatogory = 'SAAS' ;
                materialsquery = materialsquery + ' and Platform_Category__c=\''+pcatogory + '\'' ;
                strrequesttype ='SAAS';
            }
            else if(poc.Request_Type__c == 'POC Option Type Request')
            {
                
                strrequesttype ='OPTION';
            }
            else if(poc.Request_Type__c == 'POC Software Request')
            {
                //string []pcatogory = new string[]{'Mainframe', 'SAAS' } ;
                // String pcatogory = '(\''+ 'Mainframe' + '\',\'' + 'SAAS' + '\'' + ')'; 
                String pcatogory = '(\'' + 'SAAS' + '\'' + ')'; 
                materialsquery = materialsquery + ' and IsAppliance__C= false  ' ;
                materialsquery =  materialsquery+ ' and Platform_Category__c not in '+ pcatogory ;
                strrequesttype ='SOFTWARE';
                
            }
            else if(poc.Request_Type__c == 'POC Hybrid SaaS Request')
            {
                
                system.debug('samap01 GPOC_UIM_TopsCodes'+GPOC_UIM_TopsCodes);
                String[] arrtopscodes = GPOC_UIM_TopsCodes.split('\\,');
                String  prodcodes =''       ;
                for(String str : arrtopscodes)
                    prodcodes += '\'' + str + '\',';
                prodcodes = prodcodes.lastIndexOf(',') > 0 ? '(' + prodcodes.substring(0,prodcodes.lastIndexOf(',')) + ')' : prodcodes ;
                
                materialsquery =  materialsquery+ ' and SAP_Product_Mapping__c in  '+ prodcodes ;
                strrequesttype ='HYBRID';
            }
            
            
            
        } 
        
        System.debug('samap01 materialsquery'+materialsquery);
        List<Product_Material__c> materials = Database.query(materialsquery);
        
        Set<Id> productmaterialIds = (new Map<Id,Product_Material__c>(materials)).keySet(); 
        
        //samap01  US450474	GPOC: Support of Options
        if(productmaterialIds.size() > 0)
        {       
            system.debug('samap01 get hasentitlement license' +productmaterialIds );
            MatLicenseonly =  LicenseOnlyMainframe(productmaterialIds);
            
        }
        //add materials to materialMap
        for(Product_Material__c material : materials){
            List<Product_Material__c> updateMaterialList = materialMap.get(material.Product__r.Id);
            
            //samap01 --US450474	GPOC: Support of Options (license keys only, no download – that is not available now) 
            if(poc.Request_Type__c == 'POC Option Type Request'  && showallrt==false)
            {
                if(MatLicenseonly != null && MatLicenseonly.size() > 0)
                {
                    boolean haslicense = MatLicenseonly.get(material.Id);
                    if(haslicense !=null &&  haslicense==true)
                    {
                        System.debug('samap01- haslicense' +material);
                        updateMaterialList.add(material);
                    }  
                }
                
            }
            else  if(poc.Request_Type__c == 'POC Software Request'  && showallrt==false)
            {
                if(MatLicenseonly != null && MatLicenseonly.size() > 0)
                {
                    boolean haslicense = MatLicenseonly.get(material.Id);
                    if( haslicense !=null &&  haslicense==false)
                    {
                        updateMaterialList.add(material);
                    }  
                }
                else
                {
                    updateMaterialList.add(material);
                }
            }
            else
            {
                updateMaterialList.add(material);
            }
            //samap01 --US450474
            
            //updateMaterialList.add(material);
        }
        return materialMap;
    }
    
    private void FetchTransactionalProducts() {
        currentPocProductMaterials = new List<ckProduct>();  
        //  string GPOC_UIM_TopsCodes = System.label.GPOC_UIM_TopsCodes ; 
        List<pocMaterial__c> currentProductMaterials = new  List<pocMaterial__c>();
        List<AggregateResult> currentProducts = [Select Product__r.Id, Product__r.Name,Product__r.Market_Focus_Area__c  //samap01 2/26 -adding SCBU
                                                 from pocMaterial__c where POC_Request__c=:poc.id group by Product__r.Id,
                                                 Product__r.Name,Product__r.Market_Focus_Area__c]; 
        
        string  currprodmatquery = 'Select Product__r.Id, Product__r.Name, Product_Material__r.Id, Product_Material__r.Material_Text__c, '+
            'Product_Material__r.Source_System__c, Product_Material__r.SAP_Product_Mapping__c, quantity__c,'+
            'Product_Material__r.Product__r.Market_Focus_Area__c,Product__r.Mainframe_or_Distributed__c, '+
            'Product_Material__r.IsAppliance__C,Product_Material__r.Platform_Category__c '+//samap01 2/26 -adding SCBU
            ' from pocMaterial__c where POC_Request__c=\''+pocid + '\'' ;
        
       /* if(!showallscbu)
        {
            System.debug('samap01 init showallscbu' + showallscbu);
            currprodmatquery = currprodmatquery + ' and Product__r.Market_Focus_Area__c=\''+pocbusid + '\'';     
            
        }*/
        //samap01 -US450476
        if(!showallrt)
        {
            System.debug('samap01 init showallrt' + showallrt);
            currprodmatquery = sWhere(currprodmatquery);               
            
        }
        System.debug('samap01 currprodmatquery'+currprodmatquery);
        currentProductMaterials = Database.query(currprodmatquery);
        
        //ckProduct prod = new ckProduct();                
        for (AggregateResult aprod : currentProducts) {
            ckProduct tprod = new ckProduct();
            Product2 p = new Product2();
            p.Id = (String) aprod.get('Id');
            p.Name = (String) aprod.get('Name');
            tprod.product = p;
            for (pocMaterial__c tprodmat : currentProductMaterials) {
                if (p.Id == tprodmat.Product__r.Id) {
                    ckProductMaterial prodm = new ckProductMaterial();
                    prodm.scbu = tprodmat.Product_Material__r.Product__r.Market_Focus_Area__c ;
                    
                    prodm.platformcategory = tprodmat.Product_Material__r.Platform_Category__c ;
                    prodm.materialId = tprodmat.Product_Material__r.Id;
                    prodm.materialName = tprodmat.Product_Material__r.Material_Text__c;
                    prodm.src = tprodmat.Product_Material__r.Source_System__c;
                    prodm.saptopsid = tprodmat.Product_Material__r.SAP_Product_Mapping__c;
                    // prodm.qty = tprodmat.quantity__c; //US450538 - Not required
                    //samap01US450482 : GPOC: Allow mixing of SaaS and On-Premises products -get request type information
                    System.debug('samap01 tprodmat.Product_Material__r.Product__r.Market_Focus_Area__c' +tprodmat.Product_Material__r.Product__r.Market_Focus_Area__c);
                    if(GPOC_UIM_TopsCodes.containsIgnoreCase(tprodmat.Product_Material__r.SAP_Product_Mapping__c))
                    {
                        prodm.requesttype ='HYBRID';    
                    }
                    else if(tprodmat.Product_Material__r.IsAppliance__C ==true)
                    {
                        prodm.requesttype ='APPLIANCE';
                    }
                    else if(tprodmat.Product_Material__r.Platform_Category__c =='SAAS')
                    {
                        prodm.requesttype ='SAAS';
                    }
                    //else if(tprodmat.Product_Material__r.Platform_Category__c =='Mainframe')  //4/23 -- check SCBU
                    else if(this.pocbusid   =='Mainframe')
                    {   if(MatLicenseonly != null)
                    {
                        boolean haslicense = MatLicenseonly.get(tprodmat.Product_Material__r.Id);
                        System.debug('samap01 haslicense'+haslicense);
                        if(haslicense !=null &&  haslicense==true)
                        {
                            prodm.requesttype ='OPTION';
                        } 
                        else
                        {
                            prodm.requesttype ='SOFTWARE';     
                        }
                    }
                    }
                    else
                    {
                        prodm.requesttype ='SOFTWARE';                        
                        
                    }
                    
                    
                    
                    //samap01 US450482 : GPOC: Allow mixing of SaaS and On-Premises products
                    tprod.pms.add(prodm);
                }           
            }                       
            currentPocProductMaterials.add(tprod);                   
        }                
        
    }
    
    public class ckProduct{   
        public Product2 product {get; set;}        
        public List<ckProductMaterial> pms {get; set;}  
        
        public ckProduct (){        
            pms = new List<ckProductMaterial>();     
        }
    }
    
    public class ckProductMaterial{   
        public String scbu {get; set;}  //samap01
        public String platformcategory {get; set;}  //samap01
        public String requesttype {get; set;}  //samap01
        public String materialId {get; set;}    
        public String materialName {get; set;}    
        public String src {get; set;}    
        public String saptopsid {get; set;}            
        //  public Decimal qty {get; set;}     //US450538 - Quantity not required
        public boolean selected {get; set;}                         
        public ckProductMaterial(){       
            this.selected = false;              //// requirement that all the mateirals to be unchecked by defualt      
            // this.qty = 1;     
            this.saptopsid = 'nbjmd';
        }
    }
}