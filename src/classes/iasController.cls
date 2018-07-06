public class iasController {

// FOR PRODUCT//
    public String productName{get;set;}
    public Id accId{get;set;}
    public String searchProd {get; set;}
    public Map<Id,String> mapOfProd {get;set;} 
    public Map<Id,String> mapOfAllProds {get;set;} 
    
    public String siteProductName{get;set;}
    //public String SiteProductNames{get;set;}
    
    public String searchTerm {get; set;}
    public Boolean executeFlow{get;set;}
    
    //FOR PROD RELEASES//
    public String productReleaseValue{get;set;}
    public Map<Id,String> mapOfRelease{get;set;} 
    public Map<String,String>mapOfSiteProds{get;set;} 
    
     //FOR COMPONENTS RELEASES//
    public String ComponentReleaseValue{get;set;}
    public Map<Id,String> mapOfCompRel{get;set;}
    
     //FOR PROD COMPONENTS//
    public String productComponentValue{get;set;}
    public String productComponentText{get;set;}
    public Map<Id,String> mapOfComp{get;set;}
    
    //FOR SERVICE PACKS //
    public String ProdServicePackValue{get;set;}
    public Map<Id,String> mapOfSP{get;set;}
    public String responseFromService {get;set;}
    public Boolean isDetailsPresent{get;set;}
    
    public String  startRecNum {get;set;}

    String selectedProdText = '';
       
    public String siteName          {get;set;} 
    public String topsSiteID        {get;set;}
    public String selectedSiteId    {get; set;}
    public String contactName;
    
    public String getSiteAssociationNamefromUrlField;
    public String getSiteAssociationIdfromUrlField;
    public String getContactIdfromUrlField;
    
          
      public List<SiteUtilServicesDataWrapper.Data> entitlementDetailsWrapperList{get;set;}
    public SiteUtilServicesDataWrapper.Error entitlementErrorDetailsWrapper{get;set;}
    public SiteUtilServicesDataWrapper siteUtilDetailsWrapperRef {get;set;}
    public SiteUtilServicesDataWrapper siteUtilDetailsWrapperSupportOfferingRef {get;set;}
    public List<SiteUtilServicesDataWrapper.Data> offeringDetailsWrapperList{get;set;}      
          
    public iasController (ApexPages.StandardController controller)
    { 
       
    }
    
              
    public iasController ()
    { 
      
           //this.executeFlow = false;
    }
    
    public List<SelectOption> getproductNames()
    {
         mapOfAllProds = new Map<Id,String>();        
         List<SelectOption> allProdObj = new List<SelectOption>();
         List<CA_Product_Controller__c > allProductsObj = new List<CA_Product_Controller__c>();
         System.Debug('Very first call for search term ... ' + searchTerm);
        // if(executeFlow==false)
         //{
         allProductsObj = [ Select Name , ID From CA_Product_Controller__c ORDER BY Name ASC];
                            if(allProductsObj <>null && allProductsObj.size()>0)
                            {
                                Set<String> uniqueProds = new Set<String>();
                                for(CA_Product_Controller__c prodsObj: allProductsObj )
                                    {
                                        if(uniqueProds ==null || uniqueProds.size()==0 || (uniqueProds.size()>0 && !uniqueProds.contains(prodsObj.Name)))
                                        {
                                            mapOfAllProds.put(prodsObj.Id,prodsObj.Name);
                                           // showTable = true;
                                            uniqueProds.add(prodsObj.Name);
                                            
                                            
                                        }
                                    }
                             }
                            else
                            {
                                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'No product release found');
                                    ApexPages.addmessage(errorMsg);
                            }
                         
              
                //System.Debug('Entered getProudctRelease and mapOfRelease is :' + mapOfRelease);
                if(mapOfAllProds <>null && mapOfAllProds.keySet()<>null)
                {
                    allProdObj.add(new SelectOption('-None-','-None-')); 
                    allProdObj.sort();
                    for(String getIdValue:mapOfAllProds.keySet()){
                        allProdObj.add(new SelectOption(getIdValue,mapOfAllProds.get(getIdValue)));    
                    }
                                 
                }
                system.debug('%%%%%%'+allProdObj );
                system.debug('%%%%%%Count of prods is: '+allProdObj.Size() );
       //    }
         //  else
           //{
           
           
           
           //}

         
        return allProdObj ;              
    } 
    
    public PageReference refresh()
    {
        return null;
    }
    
    public List<SelectOption> getProudctRelease(){
        List<SelectOption> productReleaseObj = new List<SelectOption>();
        productReleaseObj.add(new SelectOption('-None-','-None-')); 
        if(mapOfRelease<>null && mapOfRelease.keySet()<>null){

            
            for(String getIdValue:mapOfRelease.keySet()){
                productReleaseObj.add(new SelectOption(getIdValue,mapOfRelease.get(getIdValue)));    
            }
            productReleaseObj.sort();
        }
        system.debug('%%%%%%'+productReleaseObj);
        return productReleaseObj;
    }
    
public pageReference getReleaseFunc()
{
        System.Debug('Hello Hi Welcome executeflow is' + executeFlow);
        String idVal = System.currentPagereference().getParameters().get('productId');                
        System.Debug('Prod ID is IAS : '  +idVal);
        if(executeFlow == null || executeFlow == false)
        {
            String prodText = mapOfAllProds.get(idVal);
            mapOfRelease = new Map<Id,String>();
            if(String.isNotBlank(idVal))
            {
                if(String.isNotBlank(prodText ))
                {
                        List<Product_Release__c> productReleaseObj = [Select Id, Product_Release__c from Product_Release__c where Product__c=:prodText ORDER BY Product_Release__c DESC];
                        if(productReleaseObj<>null && productReleaseObj.size()>0)
                        {
                                        Set<String> uniqueVal = new Set<String>();
                                        for(Product_Release__c prodRelObj:productReleaseObj)
                                            {
                                                if(uniqueVal==null || uniqueVal.size()==0 || (uniqueVal.size()>0 && !uniqueVal.contains(prodRelObj.Product_Release__c)))
                                                {
                                                    mapOfRelease.put(prodRelObj.Id,prodRelObj.Product_Release__c);
                                                   // showTable = true;
                                                    uniqueVal.add(prodRelObj.Product_Release__c);
                                                }
                                            }
                         }
                         mapOfComp = new Map<Id,String>();
                         //System.Debug('productName is : ' +productName );
                         System.Debug('Entered getProudctComponent' );
                         //productName = accName; //'CLARITY ON DEMAND';//selectedProd;     
                         if(String.isNotBlank(idVal))
                         {
                                    //System.Debug('Prod Name is NOT Blank');
                                    List<CA_Product_Component__c> productComponentObj = [SELECT CA_Product_Text__c, Component_Code__c, Component_Text__c,component_expiration_date__c, Id FROM CA_Product_Component__c WHERE CA_Product_Text__c =:prodText ORDER BY Component_Text__c ASC];
                                    if(productComponentObj<>null && productComponentObj.size()>0)
                                    {
                                          //if(productComponentObj[0].component_expiration_date__c >= system.today())
                                          {
                                           Set<String> uniqueCompVal = new Set<String>();
                                            for(CA_Product_Component__c prodCompObj:productComponentObj)
                                            {
                                                if(prodCompObj.component_expiration_date__c >= system.today())
                                                {
                                                    String compCodeText = prodCompObj.Component_Text__c + ' : ' + prodCompObj.Component_Code__c ;
                                                    //System.Debug('Concatenatediasvasailues is : ' + compCodeText );     
                                                    if(uniqueCompVal==null || uniqueCompVal.size()==0 || (uniqueCompVal.size()>0 && !uniqueCompVal.contains(prodCompObj.Component_Code__c) && !uniqueCompVal.contains(prodCompObj.Component_Text__c)))
                                                    {
                                                        mapOfComp.put(prodCompObj.Id,compCodeText);
                                                        //showTable = true;
                                                        uniqueCompVal.add(prodCompObj.Component_Text__c + ' , ' + prodCompObj.Component_Code__c);
                                                        //uniqueCompVal.add(prodCompObj.Component_Text__c);
                                                    }
                                                }
                                                else
                                                {
                                                    System.Debug('expired comp is : ' + prodCompObj.Component_Code__c);
                                                }
                                            }
                                          
                                    }
                                    
                                   }
                         }
                   }
               }
            }
            else
            {
                 System.Debug('New Flow Starts here to get releases based on entitlements------ ' );
                 String siteProdText = mapOfSiteProds.get(idVal);
                 mapOfRelease = new Map<Id,String>();
                 List<Product_Release__c> productReleaseObj = [Select Id, Product_Release__c from Product_Release__c where Product__c=:siteProdText ORDER BY Product_Release__c DESC];
                 if(productReleaseObj<>null && productReleaseObj.size()>0)
                    {
                                    Set<String> uniqueVal = new Set<String>();
                                    for(Product_Release__c prodRelObj:productReleaseObj)
                                        {
                                            if(uniqueVal==null || uniqueVal.size()==0 || (uniqueVal.size()>0 && !uniqueVal.contains(prodRelObj.Product_Release__c)))
                                            {
                                                mapOfRelease.put(prodRelObj.Id,prodRelObj.Product_Release__c);
                                               // showTable = true;
                                                uniqueVal.add(prodRelObj.Product_Release__c);
                                            }
                                        }
                    }
                    
                          mapOfComp = new Map<Id,String>();
                         //System.Debug('productName is : ' +productName );
                         System.Debug('Entered getProudctComponent' );
                         //productName = accName; //'CLARITY ON DEMAND';//selectedProd;     
                         if(String.isNotBlank(idVal))
                         {
                                    //System.Debug('Prod Name is NOT Blank');
                                    List<CA_Product_Component__c> productComponentObj = [SELECT CA_Product_Text__c, Component_Code__c, Component_Text__c,component_expiration_date__c, Id FROM CA_Product_Component__c WHERE CA_Product_Text__c =:siteProdText ORDER BY Component_Text__c ASC];
                                    if(productComponentObj<>null && productComponentObj.size()>0)
                                    {
                                          //if(productComponentObj[0].component_expiration_date__c >= system.today())
                                          {
                                           Set<String> uniqueCompVal = new Set<String>();
                                            for(CA_Product_Component__c prodCompObj:productComponentObj)
                                            {
                                                if(prodCompObj.component_expiration_date__c >= system.today())
                                                {
                                                    String compCodeText = prodCompObj.Component_Text__c + ' : ' + prodCompObj.Component_Code__c ;
                                                    //System.Debug('Concatenatediasvasailues is : ' + compCodeText );     
                                                    if(uniqueCompVal==null || uniqueCompVal.size()==0 || (uniqueCompVal.size()>0 && !uniqueCompVal.contains(prodCompObj.Component_Code__c) && ! uniqueCompVal.contains(prodCompObj.Component_Text__c)))
                                                    {
                                                        mapOfComp.put(prodCompObj.Id,compCodeText);
                                                        //showTable = true;
                                                        uniqueCompVal.add(prodCompObj.Component_Text__c + ' , ' + prodCompObj.Component_Code__c);
                                                        //uniqueCompVal.add(prodCompObj.Component_Text__c);
                                                    }
                                                }
                                                else
                                                {
                                                    System.Debug('expired comp is : ' + prodCompObj.Component_Code__c);
                                                }
                                            }
                                          
                                          }
                                    
                                    }
                          }
            
            }
            

            return null;
}

public List<SelectOption> getProudctComponent()
    {
        List<SelectOption> productCompObj = new List<SelectOption>();
        productCompObj.add(new SelectOption('-None-','-None-')); 
        if(mapOfComp<>null && mapOfComp.keySet()<>null){
            productCompObj.sort();
            for(String getIdValue:mapOfComp.keySet()){
               // productCompObj.sort();
                productCompObj.add(new SelectOption(getIdValue,mapOfComp.get(getIdValue)));    
            }
            
        }
        system.debug('%%%%%%IASPLSPLSCOMP IS'+productCompObj);
        return productCompObj;
   }
    
    public List<SelectOption> getComponentRelease()
    {
        System.Debug('entered getComponentRelease AND PROD IaS: ' + productName);
       //System.Debug('Selected ProudctComponent is ias: ' + productComponentValue);
       
        List<SelectOption> productCompRelObj = new List<SelectOption>();
        productCompRelObj.add(new SelectOption('-None-','-None-')); 
        productCompRelObj.sort();
        if(mapOfCompRel<>null && mapOfCompRel.keySet()<>null){
           // productCompObj.add(new SelectOption('-None-','-None-')); 
            
            for(String getIdValue:mapOfCompRel.keySet()){
                productCompRelObj.add(new SelectOption(getIdValue,mapOfCompRel.get(getIdValue)));    
            }
            
        }
       system.debug('CCCCCOOOOORELLLLL'+productCompRelObj);
        return productCompRelObj;
   }
   
public PageReference getCompReleaseFunc()
{
        String idVal = System.currentPagereference().getParameters().get('productComponentValue');
        System.Debug('entered getCompReleaseFunc AND idVal IaS: ' + idVal);
        if(String.isNotBlank(idVal))
        {
            mapOfCompRel = new Map<Id,String>();
            List<CA_Product_Component__c> selectedCompCode = [SELECT Component_Code__c FROM CA_Product_Component__c where ID =:idVal limit 1];// 'a7Ya0000000TNhTEAW'
            List<Component_Release__c> compReleaseObj  = [SELECT Component_Release__c, Id FROM Component_Release__c WHERE Component_Code__c =:selectedCompCode[0].Component_Code__c ORDER BY Component_Release__c DESC ];            
            if(compReleaseObj<>null && compReleaseObj.size()>0)
            {
                  for(Component_Release__c comRelObj:compReleaseObj)
                  {
                         Set<String> uniqueCompRelVal = new Set<String>();            
                         if(uniqueCompRelVal==null || uniqueCompRelVal.size()==0 || (uniqueCompRelVal.size()>0 && !uniqueCompRelVal.contains(comRelObj.Component_Release__c) ))
                         {
                                 mapOfCompRel.put(comRelObj.Id,comRelObj.Component_Release__c);
                                 uniqueCompRelVal.add(comRelObj.Component_Release__c);
                         }
                  }  
            } 
        }
        return null;
       
}

public List<SelectOption> getProductServicePack()
    {
    //servicePackFunc();
       //mapOfSP = new Map<Id,String>();    
       List<SelectOption> spObj = new List<SelectOption>();
       spObj.add(new SelectOption('-None-','-None-')); 
       spObj.sort();
       if(mapOfSP<>null && mapOfSP.keySet()<>null){
                       
            for(String getIdValue:mapOfSP.keySet()){
                spObj.add(new SelectOption(getIdValue,mapOfSP.get(getIdValue)));    
            }
            spObj.sort();
        }     
        return spObj;
   }
   
public PageReference servicePackFunc()
{
        String idValRel = System.currentPagereference().getParameters().get('productReleaseValue');
        System.Debug('entered servicePackFunc AND idVal of selected Release is : ' + idValRel);
        if(String.isNotBlank(idValRel))
        {
            mapOfSP = new Map<Id,String>();
            List<Product_Service_Pack__c> serPackObj  = [SELECT Id,Product_Service_Pack__c FROM Product_Service_Pack__c WHERE Product_Release__c =:idValRel ORDER BY Product_Service_Pack__c DESC ];  
            System.Debug('entered Product_Service_Pack__c AND value  of Product_Service_Pack__c after queryias is : ' + serPackObj);
            if(serPackObj<>null && serPackObj.size()>0)
            {
                 System.Debug('entered Product_Service_Pack__c for loop : ' + serPackObj);
                  for(Product_Service_Pack__c spObj:serPackObj)
                  {
                         Set<String> uniqueSPVal = new Set<String>();            
                         if(uniqueSPVal==null || uniqueSPVal.size()==0 || (uniqueSPVal.size()>0 && !uniqueSPVal.contains(spObj.Product_Service_Pack__c) ))
                         {
                                 mapOfSP.put(spObj.Id,spObj.Product_Service_Pack__c);
                                 uniqueSPVal.add(spObj.Product_Service_Pack__c);
                         }
                  }  
            } 
        }
        return null;
       
}

public PageReference gottodirectCasePage()
{
          PageReference pageref=null;          
                  
          String[] fieldIDValues=new String[16];
          String fieldUrl=null;
          String url=null;
          String prodSelected = '';
          String prodCompText = '';
          String prodRelText  = '';
          String prodIDSelected = '';
          String prodServicePackText  = '';
          String compRelText  = '';
        try{
            fieldIDValues[0]=System.Label.OfferingCaseFieldIdSite;
            fieldIDValues[1]=System.Label.OfferingCaseFieldIdSiteLkid;
            fieldIDValues[2]=System.Label.OfferingCaseFieldIdCasewithoutEntitlement;
            fieldIDValues[3]=System.Label.TSStage;
            
            System.Debug('Selected Site AssociationIASIASIASPLSMIRACLEPLSIAS is: ' +searchTerm);
            //Product
            //fieldIDValues[4] = 'CF00Na000000ArhgS';
            //fieldIDValues[5] = 'CF00Na000000ArhgS_lkid';
            //Component
            //eldIDValues[6] = 'CF00Na000000ArhgR';
            //eldIDValues[7] = 'CF00Na000000ArhgR_lkid';
            //Product Release // 
            //fieldIDValues[8] = 'CF00Na000000Arhh3';
            //fieldIDValues[9] = 'CF00Na000000Arhh3_lkid'; 
            //fieldIDValues[15] = '00Na000000Arhgd_lkid';
  
            
            //New Fields CA Product Text Field
            fieldIDValues[4] ='00N1D000001IweX';
            //New Field for Product Release
            fieldIDValues[5] = '00N1D000001Iwem';            
            // New Field for Product Service Pack 
            fieldIDValues[6] = '00N1D000001WnZm'; 
            //New Field for Component
            fieldIDValues[7] = '00N1D000001Iweh';
            // Component Release Selection //
            fieldIDValues[8] = '00N1D000001X3gi';
            //SITE ASSOC//
            fieldIDValues[9] = '00Na000000ArhhM';
            fieldIDValues[10] = '00Na000000ArhhM_lkid';
                     
            System.Debug('Prod Name is: ' +productName );
            //CA Product//
            if(productName == null || productName == '' || siteProductName == '')
            {  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please select a Product');
                ApexPages.addMessage(myMsg);
            
            }
            else if(productComponentValue == '-None-')
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please select a Component for the Product');
                ApexPages.addMessage(myMsg);
            }
            else
            {
                      prodSelected = productName;  
                      String prodSelText = '';
                      if(executeFlow == null || executeFlow == false)
                      {                     
                          prodSelText = mapOfAllProds.get(prodSelected );
                      }
                      else
                      {
                          prodSelText = mapOfSiteProds.get(siteProductName);
                          
                      }
                      list<CA_Product_Controller__c >prodIDList ;
                      prodCompText = mapOfComp.get(productComponentValue);
                      if(productReleaseValue <> '-None-')
                      {
                          prodRelText = mapOfRelease.get(productReleaseValue);
                      }
                      else
                      {
                          prodRelText = '';
                          productReleaseValue = ''; 
                          
                      }
                      if(prodSelected <> null || prodSelected <> '')
                      {
                         prodIDList = new list<CA_Product_Controller__c >();            
                         prodIDList = [ Select ID From CA_Product_Controller__c WHERE Name LIKE :'%' + String.escapeSingleQuotes(prodSelected) + '%'  LIMIT 1] ;
                      }
                      if(ProdServicePackValue <>  '-None-')
                      {
                           prodServicePackText = mapOfSP.get(ProdServicePackValue);
                      }
                      if(ComponentReleaseValue <>  '-None-')
                      {
                          compRelText = mapOfCompRel.get(ComponentReleaseValue);
                      }
                     // siteName = 'CA TECHNOLOGIES';
                     // selectedSiteId = 'a26a0000001D5zCAAS';
                     
                      siteName = searchTerm;
                      selectedSiteId = selectedSiteId;
                     
                
                      System.Debug('In Btn: Selected Prod Comp Text is: ' + prodCompText);
                      System.Debug('In Btn: Selected Prod Comp Val is:  ' + productComponentValue);
                      System.Debug('In Btn: Selected Prod Rel Val is:   ' + productReleaseValue);
                      System.Debug('In Btn: Selected Prod Rel Text is:  ' + prodRelText);
                      System.Debug('In Btn: Selected Prod ID Text is:   ' + prodIDList);
                      System.Debug('In Btn: Selected Prod SP Val is:    ' + ProdServicePackValue);
                      System.Debug('In Btn: Selected Prod SP Txt is:    ' + prodServicePackText);
                      System.Debug('In Btn: Selected Comp Rel Val is:   ' + ComponentReleaseValue);
                      System.Debug('In Btn: Selected Comp Rel Txt is:   ' + compRelText);
                                 
                      if(siteName<>null && siteName!='' && selectedSiteId<>null && selectedSiteId!='')
                      {             
                        siteName=EncodingUtil.urlEncode(siteName,'UTF-8'); 
                        fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'='+prodSelText+'&'+fieldIDValues[5]+'='+prodRelText+'&'+fieldIDValues[6]+'='+prodServicePackText+'&'+fieldIDValues[7]+'='+prodCompText+'&'+fieldIDValues[8]+'='+compRelText;
                        System.Debug('New URL is: ' + fieldUrl);
                        System.Debug('OMG IAS Site Name is: ' + siteName);
                      }
                      else
                      {
                        //Below line of code contains URL with Lookup parameters and IDs// 
                        //fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'='+prodSelected+'&'+fieldIDValues[5]+'='+productReleaseValue+'&'+fieldIDValues[8]+'='+prodRelText+'&'+fieldIDValues[9]+'='+productReleaseValue+'&'+fieldIDValues[6]+'='+prodCompText+'&'+fieldIDValues[7]+'='+productComponentValue+'&'+fieldIDValues[10]+'='+prodSelected+'&'+fieldIDValues[11]+'='+prodCompText+'&'+fieldIDValues[12]+'='+prodServicePackText+'&'+fieldIDValues[13]+'='+ProdServicePackValue+'&'+fieldIDValues[14]+'='+compRelText+'&'+fieldIDValues[15]+'='+ComponentReleaseValue;
                        fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[9]+'='+siteName+'&'+fieldIDValues[10]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'='+prodSelText+'&'+fieldIDValues[5]+'='+prodRelText+'&'+fieldIDValues[6]+'='+prodServicePackText+'&'+fieldIDValues[7]+'='+prodCompText+'&'+fieldIDValues[8]+'='+compRelText;
                          
                        System.Debug('OMG URL is: ' + fieldUrl);
                      }           
                      url=System.URL.getSalesforceBaseUrl().toExternalForm()+fieldUrl;               
                      if(!(url.length()>=2000)){
                        pageref=new PageReference(url);
                        pageref.setRedirect(true); 
                      }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please contact System Administrator,URL Length reached Limitation');
                        ApexPages.addMessage(myMsg);
                     } 
                 }
             
        }catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,e.getMessage());
            ApexPages.addMessage(myMsg);
        }finally{
            if(fieldIDValues<>null){
                fieldIDValues=null;  
            }
            if(fieldUrl<>null){
                fieldUrl=null;  
            }
            if(url<>null){
                url=null; 
            }
        }         
        return pageref;
     }   

    public PageReference resetValues(){
        this.entitlementDetailsWrapperList=null;        
        this.topsSiteID=null;
        this.startRecNum=null;
        this.executeFlow=false;        
        this.siteName=null;
        this.searchTerm=null;  
      
        return null;
    }
    
@RemoteAction
public static List<Site_Association__c> searchSiteList(String searchTerm) 
{
        String query=null;
        List<Site_Association__c> siteList = null;       
        try{
            searchTerm=String.escapeSingleQuotes(searchTerm);                  
            query='Select ID,SC_TOPS_ID__c,Name,City__c,Country_Picklist__c from Site_Association__c';
            if(searchTerm.isNumeric()){
                query=query+' WHERE SC_TOPS_ID__c=:searchTerm ORDER BY SC_TOPS_ID__c';  
            }else{
                query=query+'  WHERE SC_TOPS_ID__c<>NULL AND NAME LIKE \'%' + searchTerm + '%\' ORDER BY SC_TOPS_ID__c';   
            }
            siteList=Database.query(query);
        }finally{
            if(query!=null){
                query=null;
            }            
        }        
        return siteList;
} 
List<String> lstProdNames =new List<String>();
public PageReference executeDetails()
{

         System.Debug('Search Term is -- clicked button: '+ searchTerm);
         System.Debug('TOPS SITE ID -- clicked button: '+ topsSiteID);
         //this.searchTerm=searchTerm;
         if(searchTerm<> null || searchTerm <>'')
         {
            //responseFromService=SiteUtilServicesHandler.getServiceDetails(topsSiteID,'1','','EntitlementService'); 
            responseFromService=SiteUtilServicesHandler.getServiceDetails(topsSiteID,null,'1','EntitlementService'); 
            if(responseFromService<>null && responseFromService!='')
            {                   
                siteUtilDetailsWrapperRef=SiteUtilServicesHandler.getServiceResponseList(responseFromService);              
                if(siteUtilDetailsWrapperRef<> null  && siteUtilDetailsWrapperRef.status=='success')
                {                   
                    entitlementDetailsWrapperList=SiteUtilServicesHandler.getDataWrapperList(responseFromService);
                    if(entitlementDetailsWrapperList.size()>0)
                    {
                        this.isDetailsPresent=true;
                        System.Debug('IASMIRACLE entitlementDetailsWrapperList is' +entitlementDetailsWrapperList);
                        lstProdNames = new List<String>();
                        Set<String> uniqueSiteProdVal = new Set<String>(); 
                        mapOfSiteProds = new Map<String,String>();
                        //Id i;
                              for(SiteUtilServicesDataWrapper.Data prodDetails : entitlementDetailsWrapperList)
                              {                        
                                    lstProdNames.add(prodDetails.cAProductName);
                                    //i=i+1;
                                    if(uniqueSiteProdVal==null || uniqueSiteProdVal.size()==0 || (uniqueSiteProdVal.size()>0 && !uniqueSiteProdVal.contains(prodDetails.cAProductName) ))
                                    {
                                         uniqueSiteProdVal.add(prodDetails.cAProductName);   
                                         System.Debug('IAS Prod Details are: ' + prodDetails );
                                         mapOfSiteProds.put(prodDetails.cAProductName,prodDetails.cAProductName);      
                                         //mapOfAllProds.put(prodDetails.cAProductName,prodDetails.cAProductName);     
                                         //mapOfSiteProds.put(i,prodDetails.cAProductName);                        
                                    }

                              } 
                        
                        System.Debug('Prod Size is IAS: '+lstProdNames.Size());
                        System.Debug('Prod Names: '+lstProdNames);
                        System.Debug('IAS Unique entitlements is: ' +uniqueSiteProdVal.size());
                        System.Debug('IAS Site Prod Map values are ' + mapOfSiteProds );     
                        executeFlow=true;         
                        ///getsiteProductNames();             
                        
                    }
                    else
                   {
                        this.isDetailsPresent=false;                        
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Active Entitlements for Site :'+topsSiteID);
                        ApexPages.addMessage(myMsg);
                   }  
                }
                else if(siteUtilDetailsWrapperRef<> null  && siteUtilDetailsWrapperRef.status=='failure')
                {
                    this.isDetailsPresent=false;                  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,siteUtilDetailsWrapperRef.Error.description);
                    ApexPages.addMessage(myMsg);
                }
            }
            else
            {
                this.isDetailsPresent=false;          
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Unable to Connect Entitlement Service');
                ApexPages.addMessage(myMsg);
            }
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Select a Site Association for Entitlement Search');
                ApexPages.addMessage(myMsg);
            
            }
           return null;
   }

    
public List<SelectOption> getsiteProductNames()
{
      
       System.Debug('IAS Entered getSiteProductNames ' + mapOfSiteProds );
       System.Debug('IAS Entered getSiteProductNames Site ID is ' + topsSiteID);
             
       List<SelectOption> sprodObj = new List<SelectOption>();
       sprodObj.add(new SelectOption('-None-','-None-')); 
       sprodObj.sort();
       if(mapOfSiteProds<>null && mapOfSiteProds.keySet()<>null){                       
       for(String getIdValue:mapOfSiteProds.keySet())
          {            
                    System.Debug('Entered ForLoop ----- mapOfSiteProds.get(getIdValue) is IAS: ' +mapOfSiteProds.get(getIdValue));
                    sprodObj.add(new SelectOption(getIdValue,mapOfSiteProds.get(getIdValue)));    
                    System.Debug('Inside ForLoop ----- sprodObj is IAS: ' +sprodObj);
          }
            sprodObj.sort();
        } 
        System.Debug('Exited ForLoop ----- finally value of sprodObj is : ' +sprodObj);    
        return sprodObj;
}

public void spin() 
{
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<5000); // Busy loop for 5000 ms
}
    

}