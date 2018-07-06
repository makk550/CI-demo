global class LiveAgentPreChatFormController {

    Public Static boolean changeCommentValue = false;
    Public Static String noProductFound{get;set;}
    Public Static String noTopsCodeFound{get;set;}
    Public Static String noDefaultComp{get;set;}
    Public Static String noDefaultCompFlag{get;set;}
    
   public LiveAgentPreChatFormController( ) {
         Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
   }
    
    @RemoteAction
    global static String getSiteId(String siteTopId) { 
        System.debug('siteTopId*****'+siteTopId);
        String result = '';
        if(sitetopId!=NULL && Integer.valueOf(siteTopId) >= 8000000 && Integer.valueOf(siteTopId) <= 8888887 )
        {
            List<Project_Site_Association__c> site = new  List< Project_Site_Association__c> () ;
            if(siteTopId!=null && siteTopId!='')
                site = [select id,Project_ID__c,Site_Association__c from Project_Site_Association__c  where Project_ID__c =: siteTopId]; 
            if(!site.isEmpty())
            {
                String siteAss = site[0].Site_Association__c;
                String projectSiteId = site[0].Id;
               //result+=site[0].Site_Association__c+site[0].Id;
                return siteAss +'-'+ projectSiteId;
            }

        }
        else
        {
            List<Site_Association__c> site = new  List<Site_Association__c> () ;
            if(siteTopId!=null && siteTopId!='')
                site = [select id,SC_TOPS_ID__c from Site_Association__c  where SC_TOPS_ID__c =: siteTopId]; 
            if(!site.isEmpty())
                return site[0].Id;          
        }
        return ('null');
   }
    
    @RemoteAction
    global static String getProductId(String proName) {
        //US289127--Chat Default Product--START
        String[] listOfProduct = new String[]{proName,Label.Global_Service_Center};
        List<CA_Product_Controller__c> listOfProductName = null;
        List<CA_Product_Controller__c> products;
        String productFlag;
        listOfProductName = [Select id, Name from CA_Product_Controller__c where Name IN:listOfProduct];
        
        if(listOfProductName<>null && listOfProductName.size()>0){
            if(listOfProductName.size()>=2){
                products = new List<CA_Product_Controller__c>();
                for(CA_Product_Controller__c caProductName:listOfProductName){
                    if(caProductName.Id<>null && caProductName.Name!=Label.Global_Service_Center){
                      products.add(caProductName); 
                        noProductFound = '';
                        productFlag = '';
                    }
                }
            }else if(listOfProductName.size()==1){
                products = new List<CA_Product_Controller__c>();
                if(listOfProductName[0].Id<>null && listOfProductName[0].Name==Label.Global_Service_Center){
                    products.add(listOfProductName[0]);
                    noProductFound = proName;
                    productFlag = system.Label.Product_Problem_Case;
                }                
            }
        }
        return products[0].id+'='+noProductFound+'='+productFlag;
        //US289127--Chat Default Product--END
        /*List<CA_Product_Controller__c> products = [select id,Name from CA_Product_Controller__c  where Name =: proName];
        if(!products.isEmpty()){
            return products[0].Id;
        }
        else{ 
            return ('null');
        }*/
    }
    
    @RemoteAction
    global static String getCAProductController(String topsCode) { 
        //US289127--Chat Default Tops Code--START
        String productName;
        String[] listOfTopsCode = new String[]{topsCode,Label.Create_Case_Missing_TopsCd};
        List<Product_Material__c> defaultTopCode = null;
        List<Product_Material__c> materials;
        String changedProductFlag;
        defaultTopCode = [Select Id,Name,CA_Product_Controller__c, CA_Product_Controller__r.Name from Product_Material__c where Name IN:listOfTopsCode AND (CA_Product_Controller__c<>null OR CA_Product_Controller__c<>'')];
        
        if(defaultTopCode<>null && defaultTopCode.size()>0){
            if(defaultTopCode.size()>=2){
                materials = new List<Product_Material__c>();
                for(Product_Material__c productMaterialObj:defaultTopCode){
                    if(productMaterialObj.CA_Product_Controller__c<>null && productMaterialObj.Id<>null && productMaterialObj.Name!=Label.Create_Case_Missing_TopsCd){
                      materials.add(productMaterialObj);    
                        noTopsCodeFound = '';
                        productName = productMaterialObj.CA_Product_Controller__r.Name;
                        changedProductFlag = '';
                    }
                }                
            }else if(defaultTopCode.size()==1){
                materials = new List<Product_Material__c>();
                if(defaultTopCode[0].CA_Product_Controller__c<>null && defaultTopCode[0].Id<>null && defaultTopCode[0].Name==Label.Create_Case_Missing_TopsCd){
                      materials.add(defaultTopCode[0]);  
                      noTopsCodeFound = topsCode;
                      productName = defaultTopCode[0].CA_Product_Controller__r.Name;
                      changedProductFlag = System.Label.Product_Problem_Case;
                } 
            }
        }
        
        return materials[0].CA_Product_Controller__c+'='+materials[0].id+'='+noTopsCodeFound+'='+productName+'='+changedProductFlag;
        //US289127--Chat Default Tops Code--END
        /*List<Product_Material__c> materials = new List<Product_Material__c>();
        if(topsCode!=null && topsCode!='')
            materials = [SELECT Id,CA_Product_Controller__c FROM Product_Material__c where Name = : topsCode ];
        if(!materials.isEmpty()){
            return materials[0].CA_Product_Controller__c+'='+materials[0].id;
           //return materials[0].CA_Product_Controller__c;
        }
        else{ 
            return ('null');
        }*/
    }
    
    @RemoteAction
    global static String getCAProductComponent(String controllerId, String materialId, String changedProductFlag){ 
        //US289127--Chat Default Component--START
        Boolean defaultFalg=false;
        List<CA_Product_Component__c> components;
        List<CA_Product_Component__c> productCompObj = null;
        List<CA_Product_Component__c> deafultComponents  = [Select Id,CA_Product_Controller__c, CA_Product_Controller__r.Name, Default_Component_for_this_CA_Product__c from CA_Product_Component__c where CA_Product_Controller__c =:controllerId AND (component_expiration_date__c=:null OR component_expiration_date__c >=: System.today())];
        if(deafultComponents<>null && deafultComponents.size()>0){
            components = new List<CA_Product_Component__c>();
            //Default Component
            for(CA_Product_Component__c prodComp:deafultComponents){
                if(prodComp<>null && (prodComp.CA_Product_Controller__c<>Label.Global_Service_Center_Id || prodComp.CA_Product_Controller__c==controllerId) && prodComp.Default_Component_for_this_CA_Product__c){
                  components.add(prodComp);
                    noDefaultCompFlag = 'X';
                    noDefaultComp = prodComp.CA_Product_Controller__c;
                    defaultFalg = true;
                    break;
                }
            }
            //if default component doesn't exist then pass any component
            if(!defaultFalg){
                for(CA_Product_Component__c prodElseComp:deafultComponents){
                    if(prodElseComp<>null && (prodElseComp.CA_Product_Controller__c<>Label.Global_Service_Center_Id || prodElseComp.CA_Product_Controller__c==controllerId) && !prodElseComp.Default_Component_for_this_CA_Product__c){
                        components.add(prodElseComp);
                        noDefaultCompFlag = 'Y';
                        noDefaultComp = prodElseComp.CA_Product_Controller__c;
                        changedProductFlag = System.Label.Product_Problem_Case;
                        break;
                    }
                }    
            }
        }else{
            productCompObj  = [Select Id, Component_Code__c, Default_Component_for_this_CA_Product__c, CA_Product_Controller__c,CA_Product_Controller__r.Name From CA_Product_Component__c where CA_Product_Controller__c =:Label.Global_Service_Center_Id AND Component_Code__c=:'SCBUG' AND (component_expiration_date__c=:null OR component_expiration_date__c >=: System.today()) ORDER BY CREATEDDATE DESC limit 1];
            if(productCompObj<>null && productCompObj.size()>0){
                materialId = system.Label.GCS_Product_Material;
                components = new List<CA_Product_Component__c>();
                components.add(productCompObj[0]);
                noDefaultCompFlag = 'N';
                noDefaultComp = productCompObj[0].CA_Product_Controller__c;
                changedProductFlag = System.Label.Product_Problem_Case;
            }
        }
        
        return components[0].id+'='+noDefaultCompFlag+'='+noDefaultComp+'='+materialId+'='+changedProductFlag;
        //US289127--Chat Default Component--END
        /*List<CA_Product_Component__c> components = new List<CA_Product_Component__c> ();
        if(controllerId!=null && controllerId!='')
        components = [SELECT ID FROM CA_Product_Component__c where CA_Product_Controller__c =: controllerId and Default_Component_for_this_CA_Product__c = True ];
        if(!components.isEmpty()){
            return components[0].Id;
        }
        else{ 
            return ('null');
        }*/
    }
    
    @RemoteAction
    global static String getContactId(String connectID) { 
        List<Contact> contacts = new  List<Contact>();
        String Id;
        if(connectID!=null && connectID!=''){
            if (connectId.isNumeric()){
                contacts = [Select ID from Contact where SC_CONTACT_LDAPID__c =: connectID];
                if(!contacts.isEmpty()){
                    id = contacts[0].Id + '#contact';
                }
            }else{
                /*for(User user : [Select id from user where PmfKey__c =:connectID ]){
                    Id  = user.id +'#user';
                }*/
                //US285561
                List<Contact> internalContactObj = [Select id from Contact where SC_CONTACT_LDAPID__c=:connectID];
                if(internalContactObj<>null && internalContactObj.size()>0){
                  id = internalContactObj[0].Id + '#user';    
                }
                //US285561
            }
            
            if(id ==null){
                id= 'null';
            }
            
            return id;
        }else{ 
            return ('null');
        }
    }
}