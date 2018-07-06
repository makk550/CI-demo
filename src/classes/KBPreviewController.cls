public class KBPreviewController
{

public list<knowledge__kav> KBArticles   {get;set;}
public string recordTypeVal            {get;set;}
public List<String> releases           {get;set;} 
public List<String> prods              {get;set;} 
public List<String> components         {get;set;} 
public boolean hasAttachments          {get;set;}
public boolean hasTechDetails          {get;set;}
public string Status                   {get;set;}
    public String publishDate {get;set;}

 
 public KBPreviewController(ApexPages.StandardController stdController)
 { 
     string articleId = String.isNotBlank(ApexPages.currentPage().getParameters().get('id'))?ApexPages.currentPage().getParameters().get('id'):'';
     string release;
     string compName;
     string prodName;
     if(String.isNotBlank(articleId))
     {
     
              KBArticles = [ 
                             Select id ,File_attachment__Body__s,recordType.Name, Auto_Article_Number__c, Title, Please_select_a_heading__c, Search_Result_Summary__c, Content1__c ,Environment__c, 
                             product_names__c, LastModifiedDate , Cause__c , Please_select_a_heading2__c , Content2__c , Additional_Information__c ,
                             Component_Names__c , Component_Codes__c , Releases__c,
                             File_attachment__Name__s,File_attachment2__Name__s,File_attachment3__Name__s,File_attachment4__Name__s,File_attachment5__Name__s,
                             Introduction__c, Question__c , Answer__c,
                             Please_select_a_heading3__c, knowledgeArticleId, Content3__c , Background__c, Instructions__c, Content4__c, LastPublishedDate
                             from knowledge__kav
                             where PublishStatus = 'Draft' and KnowledgeArticleId = :articleId ];  
              
             
             if(KBArticles==null || KBArticles.size()==0){
                 KBArticles = [ 
                             Select id ,File_attachment__Body__s,recordType.Name, knowledgeArticleId, Auto_Article_Number__c, Title, Please_select_a_heading__c, Search_Result_Summary__c, Content1__c ,Environment__c, 
                             product_names__c, LastModifiedDate , Cause__c , Please_select_a_heading2__c , Content2__c , Additional_Information__c ,
                             Component_Names__c , Component_Codes__c , Releases__c,
                             File_attachment__Name__s,File_attachment2__Name__s,File_attachment3__Name__s,File_attachment4__Name__s,File_attachment5__Name__s,
                             Introduction__c, Question__c , Answer__c,
                             Please_select_a_heading3__c, Content3__c , Background__c, Instructions__c, Content4__c, LastPublishedDate
                             from knowledge__kav
                             where PublishStatus = 'Online' and KnowledgeArticleId = :articleId 
                           ];
             }
               
             if(KBArticles<>null && KBArticles.size()>0)
             {
                 if(KBArticles[0].recordType.Name<>null)
                 {
                     recordTypeVal       =  KBArticles[0].recordType.Name;  
                 } 
                 DateTime dateTimeVal;
                 if(kbarticles[0].LastPublishedDate<>null){
                    dateTimeVal = kbarticles[0].LastPublishedDate;
                 }else{
                    dateTimeVal = kbarticles[0].LastModifiedDate;
                 }
                String formatdateTimeVal = dateTimeVal.format('dd/MM/yyyy');
                 publishDate = String.valueOf(formatdateTimeVal ); 
                 
                 if(KBArticles[0].Releases__c<>null)
                 {
                      release      =  KBArticles[0].Releases__c;
                      if(release<>null)
                      {
                          releases = new List<String>();
                          List<String> listOfRelease = release.split('\n');
                          for(String rNumber:listOfRelease){
                              if(String.isNotBlank(rNumber) && rNumber.contains(':')){
                                  String ecmProductName = rNumber.substringBefore(':');
                                  if(rNumber.contains(';')){
                                      List<String> listOfRN = rNumber.subStringAfter(':').split(';');
                                      for(String rNumberVal:listOfRN){
                                          if(String.isNotBlank(rNumberVal)){
                                              rNumberVal = rNumberVal.replace(' ','');
                                              rNumberVal = rNumberVal.replace('\n','');
                                              releases.add(ecmProductName+':Release:'+rNumberVal);
                                          }
                                      }
                                  }else{
                                      rNumber = rNumber.subStringAfter(':');
                                      rNumber = rNumber.replace(' ','');
                                      rNumber = rNumber.replace('\n','');
                                      releases.add(ecmProductName+':Release:'+rNumber);
                                  }
                              }
                          }
                       //releases = release.split(';');
                      }
                 }
                 if(KBArticles[0].product_names__c<>null)
                 {
                     prodName =  KBArticles[0].product_names__c;
                     if(prodName <>null)
                     {
                         prods = new List<String>();
                         List<String> listOfProducts = prodName.split('\n');
                         for(String pnName:listOfProducts){
                             if(String.isNotBlank(pnName)){
                                prods.add(pnName);    
                             }
                         }
                         //prods       = prodName.split(';');
                     }
                 }
                 if(KBArticles[0].Component_Codes__c <>null)
                 {
                     compName =  KBArticles[0].Component_Codes__c ;
                     if(compName <>null)
                     {
                         components = new List<String>();
                         List<KCS_Association__c> listOfKCS = [Select id,Product_ID__c, Product_Count__c, Component_ID__c from KCS_Association__c where Component_ID__c!='' AND Component_ID__c!=null AND Article_Id__c=:KBArticles[0].knowledgeArticleId order by Product_Count__c asc];

                         if(listOfKCS<>null && listOfKCS.size()>0){
                             Map<Integer,String> mapOfXMDAndComp = new Map<Integer,String>();
                             Map<String,String> mapOfCompIdAndText = new Map<String,String>();
                             set<Id> compIds = new set<Id>();
                             set<Integer> productCount = new set<Integer>();
                             for(KCS_Association__c kcsObj:listOfKCS){
                                 system.debug(kcsObj+'====>>>>>'+mapOfXMDAndComp);
                                 if(mapOfXMDAndComp==null || mapOfXMDAndComp.size()==0 || !mapOfXMDAndComp.containsKey(Integer.valueOf(kcsObj.Product_Count__c))){
                                     mapOfXMDAndComp.put(Integer.valueOf(kcsObj.Product_Count__c),kcsObj.Component_ID__c);
                                 }else if(mapOfXMDAndComp<>null && mapOfXMDAndComp.size()>0 && String.isNotBlank(mapOfXMDAndComp.get(Integer.valueOf(kcsObj.Product_Count__c))) && !mapOfXMDAndComp.get(Integer.valueOf(kcsObj.Product_Count__c)).contains(kcsObj.Component_ID__c)){
                                     mapOfXMDAndComp.put(Integer.valueOf(kcsObj.Product_Count__c),mapOfXMDAndComp.get(Integer.valueOf(kcsObj.Product_Count__c))+';'+kcsObj.Component_ID__c);
                                 }
                                 compIds.add(kcsObj.Component_ID__c);
                                 productCount.add(Integer.valueOf(kcsObj.Product_Count__c));
                             }
                             
                             
                             if(compIds<>null && compIds.size()>0){
                                 List<ca_product_component__c> listOfComp =[Select id,Component_Text__c,Component_Code__c from ca_product_component__c where Component_Text__c!=null AND Component_Text__c!='' AND Component_Code__c!=null AND Component_Code__c!='' AND (component_expiration_date__c>=:system.today() OR component_expiration_date__c=:null) AND Id IN:compIds];
                                 
                                 if(listOfComp<>null && listOfComp.size()>0){
                                     for(ca_product_component__c compObj:listOfComp){
                                         mapOfCompIdAndText.put(compObj.Id, compObj.Component_Text__c+':'+compObj.Component_Code__c);
                                     }
                                 }
                             }
                             
                             if(mapOfXMDAndComp<>null && mapOfXMDAndComp.size()>0){
                                 for(Integer i:productCount){
                                     if(String.isNotBlank(mapOfXMDAndComp.get(i)) && mapOfXMDAndComp.get(i).contains(';')){
                                         List<String> listOfCompId = mapOfXMDAndComp.get(i).split(';');
                                         for(String compText:listOfCompId){
                                             if(String.isNotBlank(compText)){
                                                 components.add(mapOfCompIdAndText.get(compText.replace(' ','')));
                                             }
                                         }
                                         
                                     }else if(String.isNotBlank(mapOfXMDAndComp.get(i)) && !mapOfXMDAndComp.get(i).contains(';')){
                                         components.add(mapOfCompIdAndText.get(mapOfXMDAndComp.get(i).replace(' ','')));
                                     }
                                 }
                             }
                         }
                     }
                  }
                if(KBArticles[0].File_attachment__Name__s != null || KBArticles[0].File_attachment2__Name__s != null || KBArticles[0].File_attachment3__Name__s != null || KBArticles[0].File_attachment4__Name__s != null || KBArticles[0].File_attachment5__Name__s != null)
                 {
                    
                     hasAttachments = true;          
                 
                 }
                 else
                 {
                     hasAttachments = false;
                 }
                 if(KBArticles[0].Component_Names__c != null || KBArticles[0].product_names__c!= null || KBArticles[0].Releases__c!= null)
                 {
                    
                     hasTechDetails  = true;          
                 }
                 else
                 {
                     hasTechDetails  = false;
                 }                        
                              
     }
     }else{
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Not Found');
         ApexPages.addMessage(myMsg);
     }
 }
 }