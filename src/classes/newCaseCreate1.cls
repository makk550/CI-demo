public class newCaseCreate1

{

    public String siteSelected{get;set;}
    public String searchTerm {get; set;}

    public String responseFromService {get;set;}
    public SiteUtilServicesDataWrapper siteUtilDetailsWrapperRef {get;set;}
    public List<SiteUtilServicesDataWrapper.Data> entitlementDetailsWrapperList{get;set;}
    public Boolean isDetailsPresent{get;set;}

    // FOR PRODUCT//
    public String productName{get;set;}
    public Id accId{get;set;}
    public String searchProd {get; set;}
    public Map<Id,String> mapOfProd {get;set;} 
    
    //FOR PROD RELEASES//
    public String productReleaseValue{get;set;}
    public Map<Id,String> mapOfRelease{get;set;} 
    
    //FOR PROD COMPONENTS//
    public String productComponentValue{get;set;}
    public String productComponentText{get;set;}
    public Map<Id,String> mapOfComp{get;set;}
    
    //FOR COMPONENTS RELEASES//
    public String ComponentReleaseValue{get;set;}
    public Map<Id,String> mapOfCompRel{get;set;}
    
    //FOR SERVICE PACKS //
    public String ProdServicePackValue{get;set;}
    public Map<Id,String> mapOfSP{get;set;}
    
    public String siteName          {get;set;} 
    public String topsSiteID        {get;set;}
    public String selectedSiteId    {get; set;}
    public String contactName;
    
    public String getSiteAssociationNamefromUrlField;
    public String getSiteAssociationIdfromUrlField;
    public String getContactIdfromUrlField;
    
    public newCaseCreate1()
    {
    
            
        
    }
            
    public newCaseCreate1(ApexPages.StandardController controller)
    { 
      
           
    }
   
@RemoteAction
public static List<CA_Product_Controller__c> searchProdControllerList(String searchProd) 
    {
            //Map mapOfProd = new Map<Id,String>();
            System.Debug('Entered searchProdControllerList');
            list<CA_Product_Controller__c >accList = new list<CA_Product_Controller__c >();
            
            if(searchProd != ''){
                System.Debug('Entered searchProd not null');
                accList = [ Select Name , ID From CA_Product_Controller__c WHERE Name LIKE :'%' + String.escapeSingleQuotes(searchProd ) + '%' ] ;
               // accList = database.query(query);
            } 
            /*for(CA_Product_Controller__c prodItems:accList)
            {
                 mapOfProd.put(prodItems.Id,prodItems.Name);                                       
            }*/
            
            return accList;
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
    public PageReference refresh()
    {
        return null;
    }
    
       
    public List<SelectOption> getProudctRelease()
    {
         mapOfRelease = new Map<Id,String>();
         System.Debug('productName is : ' +productName );
         //System.Debug('Entered getProudctRelease');
         //productName = accName; //'CLARITY ON DEMAND';//selectedProd;     
         if(String.isNotBlank(productName))
         {
                    //System.Debug('Prod Name is NOT Blank');
                    List<Product_Release__c> productReleaseObj = [Select Id, Product_Release__c from Product_Release__c where Product__c=:productName ORDER BY Product_Release__c DESC];
                    //productReleaseObj.sort();

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
                    else
                    {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'No product release found');
                            ApexPages.addmessage(errorMsg);
                    }
         }
         else
         {
                    System.Debug('Prod Name is Blank');
         }        
        List<SelectOption> productReleaseObj = new List<SelectOption>();
        //System.Debug('Entered getProudctRelease and mapOfRelease is :' + mapOfRelease);
        if(mapOfRelease<>null && mapOfRelease.keySet()<>null){
            productReleaseObj.add(new SelectOption('-None-','-None-')); 
            productReleaseObj.sort();
            for(String getIdValue:mapOfRelease.keySet()){
                productReleaseObj.add(new SelectOption(getIdValue,mapOfRelease.get(getIdValue)));    
            }
                         
        }
        system.debug('%%%%%%'+productReleaseObj);
        return productReleaseObj;
              
    }
    
    public  List<String> getSortedKeyset(Map<String, String> dataMap) 
    {
        List<String> keySetList = new List<String>();
        keySetList.addAll(dataMap.keySet());
        keySetList.sort();
        return keySetList;
     }
    
    public List<SelectOption> getProudctComponent()
    {
         mapOfComp = new Map<Id,String>();
         //System.Debug('productName is : ' +productName );
         //System.Debug('Entered getProudctComponent' );
         //productName = accName; //'CLARITY ON DEMAND';//selectedProd;     
         if(String.isNotBlank(productName))
         {
                    //System.Debug('Prod Name is NOT Blank');
                    List<CA_Product_Component__c> productComponentObj = [SELECT CA_Product_Text__c, Component_Code__c, Component_Text__c,component_expiration_date__c, Id FROM CA_Product_Component__c WHERE CA_Product_Text__c =:productName ORDER BY Component_Text__c ASC];
                    if(productComponentObj<>null && productComponentObj.size()>0)
                    {
                          //if(productComponentObj[0].component_expiration_date__c >= system.today()){
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
                          //}
                    }
                    else
                    {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'No product release found');
                            ApexPages.addmessage(errorMsg);
                    }
         }
         else
         {
                    //System.Debug('Prod Name is Blank');
         }
        
              
        
        List<SelectOption> productCompObj = new List<SelectOption>();
        //System.Debug('Entered getProudctCOmponent and mapOfComp is :' + mapOfComp);
        if(mapOfComp<>null && mapOfComp.keySet()<>null){
            
            productCompObj.add(new SelectOption('-None-','-None-')); 
            productCompObj.sort();
            for(String getIdValue:mapOfComp.keySet()){
               // productCompObj.sort();
                productCompObj.add(new SelectOption(getIdValue,mapOfComp.get(getIdValue)));    
            }
            
        }
        system.debug('%%%%%%IASPLSPLSCOMP IS'+productCompObj);
        
                
        return productCompObj;
   }
    
public PageReference releaseFunc()
{
        String idVal = System.currentPagereference().getParameters().get('productComponentValue');
        //System.Debug('entered getRelForComp AND idVal IaS: ' + idVal);
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
 
    public List<SelectOption> getComponentRelease()
    {
       //System.Debug('entered getComponentRelease AND PROD IaS: ' + productName);
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
   
    public void spin() {
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<10); // Busy loop for 5000 ms
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
            if(productName == null || productName == '' )
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
                        fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'='+prodSelected+'&'+fieldIDValues[5]+'='+prodRelText+'&'+fieldIDValues[6]+'='+prodServicePackText+'&'+fieldIDValues[7]+'='+prodCompText+'&'+fieldIDValues[8]+'='+compRelText;
                        System.Debug('New URL is: ' + fieldUrl);
                        System.Debug('OMG IAS Site Name is: ' + siteName);
                      }
                      else
                      {
                        //Below line of code contains URL with Lookup parameters and IDs// 
                        //fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'='+prodSelected+'&'+fieldIDValues[5]+'='+productReleaseValue+'&'+fieldIDValues[8]+'='+prodRelText+'&'+fieldIDValues[9]+'='+productReleaseValue+'&'+fieldIDValues[6]+'='+prodCompText+'&'+fieldIDValues[7]+'='+productComponentValue+'&'+fieldIDValues[10]+'='+prodSelected+'&'+fieldIDValues[11]+'='+prodCompText+'&'+fieldIDValues[12]+'='+prodServicePackText+'&'+fieldIDValues[13]+'='+ProdServicePackValue+'&'+fieldIDValues[14]+'='+compRelText+'&'+fieldIDValues[15]+'='+ComponentReleaseValue;
                        fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[9]+'='+siteName+'&'+fieldIDValues[10]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'='+prodSelected+'&'+fieldIDValues[5]+'='+prodRelText+'&'+fieldIDValues[6]+'='+prodServicePackText+'&'+fieldIDValues[7]+'='+prodCompText+'&'+fieldIDValues[8]+'='+compRelText;
                          
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
    
}