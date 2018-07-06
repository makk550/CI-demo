global class GlobalLeaderboardController {
    public class ConfigwrapperClass{
        public String leaderboard;
        public String ranking;
        public String updateddate;
        public String actualsMonth;
        public String preliminaryMonth;
        
    }
    public class rankingWrapperClass{
        public String GEO;
        public String Photo;
        public String PMFKey;
        public String Name;
   
    }
    public class leaderboardWrapperClass{
        public String PMFKey;
        public String GL1PMFkey;
        public String GL2PMFkey;
        public String GL3PMFkey;
        public String GL4PMFkey;
    }
    public class DealDataClass{
    public DealReportMetadata reportMetadata{get;set;}
    }
    public class DealReportMetadata{
        public List<String> detailColumns{get;set;}
    }
       public class Deal
        {
            public string UserID { get; set; }
            public string Name { get; set; }
            public string Pic { get; set; }
            public string Account { get; set; }
            public string Product { get; set; }
            public string Amount { get; set; }
            public double SortNum { get; set; }
            public string Geo { get; set; }
            public string Region { get; set; }
            public string Territory { get; set; }
            public string BusinessUnit { get; set; }
            public string Area { get; set; }
        }
    @RemoteAction
    public Static String configFetch(){
        list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp'];
        String Documentresult = null;
        if(folderlist.size()>0){
            String DocumentName = 'config';
            List<Document> doc = [SELECT name,body,BodyLength,Url, Type FROM Document where name = :DocumentName and FolderId = :folderlist[0].id limit 1];
             if(doc.size() > 0){
               Blob blobdata = Blob.valueof(doc[0].body.toString());
               Documentresult =  blobdata.tostring();
               //System.debug('vlaue '+blobdata.tostring()); 
               //System.debug(blobdata.tostring());
              System.debug('config');
            }  
            else{
                 System.debug('not found document');
            }
        }
        return Documentresult;
    }
   @RemoteAction
   public Static String fetchDatafromFile(String TypeData){
        String Documentresult = null;
        String configData =configFetch();
        if(configData != null){
            ConfigwrapperClass configObj = (ConfigwrapperClass)JSON.deserialize(configData, ConfigwrapperClass.class);
            list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp']; 
            if(folderlist.size()>0){
                String DocumentName;
                    if(TypeData == 'ranking'){
                        DocumentName = configObj.ranking;
                    }else{
                        DocumentName = configObj.leaderboard;
                 }
                List<Document> doc = [SELECT name,body,BodyLength,Url, Type FROM Document where name = :DocumentName and FolderId = :folderlist[0].id limit 1];
                if(doc.size() > 0){
                   Blob blobdata = Blob.valueof(doc[0].body.toString());
                   //System.debug('vlaue '+blobdata.tostring()); 
                   Documentresult =  blobdata.tostring();
                    System.debug('saikumar Amand' + Documentresult);
                  
                }  
                else{
                     System.debug('not found document');
                }
            }
            else{
                System.debug('not found folder');
            }
        }

        System.debug('Documentresult'+Documentresult);    
        return Documentresult;
  
    }
    public Static void updatePhotosofJson(String feed){
        Set<String> UserPMFList =new Set<String>();
        String configData =configFetch();
        if(configData != null){
            ConfigwrapperClass configObj = (ConfigwrapperClass)JSON.deserialize(configData, ConfigwrapperClass.class);
            list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp'];
            if(folderlist.size() > 0){
                    String DocumentName;
                    if(feed == 'ranking'){
                        DocumentName = configObj.ranking;
                    }else{
                        DocumentName = configObj.leaderboard;
                    }
                    List<Document> doc = [SELECT name,body,BodyLength,Url, Type FROM Document where name = :DocumentName and FolderId = :folderlist[0].id limit 1];
                    if(doc.size() > 0){
                       Blob blobdata = Blob.valueof(doc[0].body.toString());
                        System.debug('blobdata'+blobdata.tostring());
                        if(feed == 'ranking'){
                           List<rankingWrapperClass> rankingObj = (List<rankingWrapperClass>)JSON.deserialize(blobdata.tostring(), List<rankingWrapperClass>.class);
                            for(rankingWrapperClass Data:rankingObj){
                                if(Data.PMFKey != null){
                                    UserPMFList.add(Data.PMFKey);
                                }  
                            }
                        }
                        else{
                            List<leaderboardWrapperClass> leaderboardObj = (List<leaderboardWrapperClass>)JSON.deserialize(blobdata.tostring(), List<leaderboardWrapperClass>.class);
                            for(leaderboardWrapperClass Data:leaderboardObj){
                                if(Data.PMFKey != null){
                                    UserPMFList.add(Data.PMFKey);
                                } 
                                if(Data.GL1PMFkey != null){
                                    UserPMFList.add(Data.GL1PMFkey);
                                } 
                                if(Data.GL2PMFkey != null){
                                    UserPMFList.add(Data.GL2PMFkey);
                                }
                                if(Data.GL3PMFkey != null){
                                    UserPMFList.add(Data.GL3PMFkey);
                                }
                                if(Data.GL4PMFkey != null){
                                    UserPMFList.add(Data.GL4PMFkey);
                                } 
                            }
                        }
                        List<User> ulist = [select id,Name,FullPhotoUrl,PMFKey__c from User where PMFKey__c IN :UserPMFList and isActive = true and PMFKey__c != null];
                        System.debug('ulist'+ulist.size()+DocumentName+UserPMFList.size());
                        Map<String,String> UsernamephotoMap =  new Map<String,String>();
                        if(ulist.size() > 0){
                            for(User u : ulist){
                                UsernamephotoMap.put(u.PMFKey__c, u.FullPhotoUrl);
                            
                            }
                            
                        }
                        String userJson = JSON.serialize(UsernamephotoMap);
                        savetoDocument(userJson,feed);
                    }
            }
          
        }
        
    }
    public static void savetoDocument(String JSONData,String feed){
        list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp'];
        if(folderlist.size()>0){
            String DocumentName;
            if(feed == 'ranking'){
                DocumentName = 'rankingPhotoSavedData.json';
            }else{
                DocumentName = 'leaderboardPhotoSavedData.json';
            }
            list<Document> doc= [select id,name,FolderId,body from Document where name = :Documentname  and FolderId = :folderlist[0].id limit 1]; 
               if(doc.size()>0){  
                  doc[0].FolderId = folderlist[0].id;
                  doc[0].body = blob.valueof(JSONData);                    
                   update doc;   
                   //System.debug('document is updated');
                }  else {                
                    Document doc1 = new Document (Name = Documentname);
                    doc1.FolderId = folderlist[0].id;
                    doc1.Description = feed + 'dashboard user photos';              
                    doc1.Body = Blob.valueOf(JSONData);                
                    insert doc1;    
                    //System.debug('new Document is created ');
                   } 
            
        }else{
            System.debug('unable to find folder');
        }
    }
    
    @RemoteAction
    public Static String getUserPhoto(String feed){
        //System.debug('in user photo');
        String Documentresult = null;
        list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp'];
        if(folderlist.size()>0){
            String DocumentName;
            if(feed == 'ranking'){
                DocumentName = 'rankingPhotoSavedData.json';
            }else{
                DocumentName = 'leaderboardPhotoSavedData.json';
            }
            List<Document> doc = [SELECT name,body,BodyLength,Url, Type FROM Document where name = :DocumentName and FolderId = :folderlist[0].id limit 1];
            if(doc.size() > 0){
               Blob blobdata = Blob.valueof(doc[0].body.toString());
               //System.debug('vlaue '+blobdata.tostring()); 
              Documentresult =  blobdata.tostring();
               System.debug('Documentresult'+Documentresult);
               
                
            }  
            else{
                 System.debug('not found document');
            }
        }
        else{
            System.debug('not found folder');
        }
        
        return Documentresult; 
    }
    
    @RemoteAction
    public Static string featchDealsData(string feedSourceID)
        {
             string jsonString = null;
            list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp']; 
            if(folderlist.size()>0){
            String DocumentName;
            
                DocumentName = feedSourceID+'_sfdc_ReportData.json';
               
            list<Document> doc= [select id,name,FolderId,body from Document where name = :Documentname  and FolderId = :folderlist[0].id limit 1]; 
                system.debug('query--->'+'select id,name,FolderId,body from Document where name = '+Documentname+'and FolderId ='+folderlist[0].id);
                system.debug(doc);
                if(doc.size() > 0){
               Blob blobdata = Blob.valueof(doc[0].body.toString());
               System.debug('vlaue '+blobdata.tostring()); 
               system.debug(blobdata);
              jsonString =  blobdata.tostring();
               System.debug('jsonString'+jsonString);
               
                
            }  
            else{
                 System.debug('not found document');
            }
        
         }else{
            System.debug('not found folder');
        }
        return jsonString;
        }
        
      @future (callout=true)
        public Static void saveDealsdatatoDOC(string feedSourceID){
            
            string jsonString = null;
            try
            {
                    String reportID = (feedSourceID == 'bookeddeals')?'00Oa0000008sXV1':'00Oa0000008sXUc';
                
                    String restQuery = 'callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/' + reportID+'?includeDetails=true';
                    Http h2 = new Http();
                    HttpRequest req1 = new HttpRequest();
                    req1.setHeader('Content-Type','application/json');
                    req1.setHeader('accept','application/json');
                    req1.setMethod('GET');
                  req1.setTimeout(60000);
                    req1.setEndpoint(restQuery);
                    HttpResponse res1 = h2.send(req1);
                    String jsonresponse = String.valueOf(res1.getbody());
                    System.debug('before clean :'+ jsonresponse);
                    String Cleanjsonresponse = CleanJson(jsonresponse);
                    DealDataClass delametadata = (DealDataClass)JSON.deserialize(Cleanjsonresponse, DealDataClass.class);
                    Map<String, Object> dealobjdata = (Map<String, Object>)JSON.deserializeUntyped(Cleanjsonresponse);
                    Map<String, Object> dealfactmap = (Map<String, Object>)dealobjdata.get('factMap');
                    Map<String, Object> dealtotal = (Map<String, Object>)dealfactmap.get('Total');
                    List<Deal> deals = new List<Deal>();
                    List<Object> dealrows = (List<Object>)dealtotal.get('rows');
                    List<String> dealcolumn =delametadata.reportMetadata.detailColumns;
                    Boolean topPic = false;
                    Set<ID> DealUserList = new Set<ID>();
                    for (Object row : dealrows)
                    {
                        Deal deal = new Deal();
                        Map<String,Object> datarow = (Map<String,Object>)row;
                       List<Object> dealdatacells = (List<Object>)datarow.get('dataCells');
                        Integer count = 0;
                        for (String column:dealcolumn)
                        {
                            Map<String,Object> datacell = (Map<String,Object>) dealdatacells[count];
                            if (column.toLowerCase().Contains('alias')) //rep_name , Swapped "account_owner_alias" with "alias" to pull opportunity owner instead of account owner
                            {
                                deal.UserID = (String)datacell.get('value');
                                DealUserList.add(deal.UserID);
                            }
                            else if (column.toLowerCase().Contains('full_name'))  //swapped "account_owner" with "full_name" to pull opprtunity owner instead of account owner
                                deal.Name = (String)datacell.get('label');
                            else if (column.toLowerCase().Contains('account_name'))
                                deal.Account = (String)datacell.get('label');
                            else if (column.toLowerCase().Contains('driving_sales_coverage_business_unit__c'))
                            {
                                deal.Product = (String)datacell.get('label');
                                deal.BusinessUnit = (String)datacell.get('label');
                            }
                            else if (column.toLowerCase().Contains('amount')) // amount
                            {
                                String Amount = (String)datacell.get('label');
                                deal.Amount = Amount.Replace('USD ', '$');
                                deal.Amount = deal.Amount.substringBefore('.');
                                
                               
                                try
                                {
                                    string value = (String)datacell.get('label');
                                    value = value.Replace('USD ', '').Replace(' ', '').Replace(',', '');
                                    value = value.substringBefore('.');
                                    deal.SortNum = Decimal.valueOf(value);
                                    
                                }catch(Exception e) { 
                                    deal.SortNum = 0;
                                }
                            }
                            else if (column.toLowerCase().Contains('rpt_region__c'))
                                deal.Geo = (String)datacell.get('label');
                            else if (column.toLowerCase().Contains('rpt_territory_country__c'))
                                deal.Region = (String)datacell.get('label');
                            else if (column.toLowerCase().Contains('rpt_country__c'))
                                deal.Territory = (String)datacell.get('label');
                            else if (column.toLowerCase().Contains('rpt_area__c'))
                                deal.Area = (String)datacell.get('label');

                            count++;
                        }
                        boolean containsDeal = false;
                        for (Deal searchFor : deals)
                        {
                            if (searchFor.Amount == deal.Amount && searchFor.Product == deal.Product && searchFor.Name == deal.Name && searchFor.Account == deal.Account)
                                containsDeal = true;
                        }
                        if (!containsDeal && deal.Amount != '0' && deal.Amount != '0.00' && deal.Amount != '$0.00' && deal.Amount != '$0')
                            deals.Add(deal);
                    }
                List<User> userSFDCList = new List<User>(); 
                Map<String,String> userPhotoMap =new Map<String,String>();
                if(DealUserList.size() > 0 && deals.size() > 0){
                    userSFDCList =[select id,Name,FullPhotoUrl from user where ID in :DealUserList];
                    System.debug('userSFDCList'+userSFDCList);
                    if(userSFDCList.size()>0){
                        for(user u:userSFDCList){
                            userPhotoMap.put(u.id, u.FullPhotoUrl);
                        }
                        for(Deal d:deals){
                            d.Pic= userPhotoMap.containsKey(d.UserID) ? userPhotoMap.get(d.UserID): 'https://ca.my.salesforce.com/profilephoto/005/F';
                        }
                    }   
                }
                          
                        jsonString = Json.serialize(deals);                     
                        System.debug('deals--'+jsonString);
                    //deals = deals.OrderByDescending(x => x.SortNum).ToList();
                    saveDealstoDocument(jsonString,feedSourceID);
                
            }
            catch (System.CalloutException ex)
            {
               sendEmailonException(ex, 'saveDealsdatatoDOC');
            }
            //return jsonString;
            
            
            
            
            
            
        }
         public static void saveDealstoDocument(String JSONData,String feedSourceID){
             list<Folder> folderlist = [select id,name from Folder where Name = 'TopSalesLeaderboardApp'];
        if(folderlist.size()>0){
            String DocumentName;
            
                DocumentName = feedSourceID+'_sfdc_ReportData.json';
            
                system.debug(DocumentName);
           
            list<Document> doc= [select id,name,FolderId,body from Document where name = :Documentname  and FolderId = :folderlist[0].id limit 1];
            system.debug(doc + ''+ folderlist[0].id);
               if(doc.size()>0){  
                  doc[0].FolderId = folderlist[0].id;
                  doc[0].body = blob.valueof(JSONData);                    
                   update doc;
                   
                   System.debug('document is updated');
                }  else {                
                    Document doc1 = new Document (Name = Documentname);
                    doc1.FolderId = folderlist[0].id;
                    doc1.Description = feedSourceID+'_sfdc_Data.json';              
                    doc1.Body = Blob.valueOf(JSONData);                
                    insert doc1;    
                    System.debug('new Document is created ');
                    system.debug(doc1.Body);
                   } 
            
        }else{
            System.debug('unable to find folder');
        } 
             
             
             
         }
        
        
        
        public Static String CleanJson(String json){
            json = json.replace('\"10!T\"', '\"_10\"');
            json = json.replace('\"11!T\"', '\"_11\"');
            json = json.replace('\"12!T\"', '\"_12\"');
            json = json.replace('\"13!T\"', '\"_13\"');
            json = json.replace('\"14!T\"', '\"_14\"');
            json = json.replace('\"15!T\"', '\"_15\"');
            json = json.replace('\"16!T\"', '\"_16\"');
            json = json.replace('\"17!T\"', '\"_17\"');
            json = json.replace('\"18!T\"', '\"_18\"');
            json = json.replace('\"19!T\"', '\"_19\"');
            json = json.replace('\"20!T\"', '\"_20\"');
            json = json.replace('\"21!T\"', '\"_21\"');
            json = json.replace('\"22!T\"', '\"_22\"');
            json = json.replace('\"23!T\"', '\"_23\"');
            json = json.replace('\"24!T\"', '\"_24\"');
            json = json.replace('\"25!T\"', '\"_25\"');
            json = json.replace('\"26!T\"', '\"_26\"');
            json = json.replace('\"27!T\"', '\"_27\"');
            json = json.replace('\"28!T\"', '\"_28\"');
            json = json.replace('\"29!T\"', '\"_29\"');
            json = json.replace('\"30!T\"', '\"_30\"');
            json = json.replace('\"31!T\"', '\"_31\"');
            json = json.replace('\"32!T\"', '\"_32\"');
            json = json.replace('\"33!T\"', '\"_33\"');
            json = json.replace('\"34!T\"', '\"_34\"');
            json = json.replace('\"35!T\"', '\"_35\"');
            json = json.replace('\"36!T\"', '\"_36\"');
            json = json.replace('\"37!T\"', '\"_37\"');
            json = json.replace('\"38!T\"', '\"_38\"');
            json = json.replace('\"39!T\"', '\"_39\"');
            json = json.replace('\"40!T\"', '\"_40\"');
            json = json.replace('\"41!T\"', '\"_41\"');
            json = json.replace('\"42!T\"', '\"_42\"');
            json = json.replace('\"43!T\"', '\"_43\"');
            json = json.replace('\"44!T\"', '\"_44\"');
            json = json.replace('\"45!T\"', '\"_45\"');
            json = json.replace('\"46!T\"', '\"_46\"');
            json = json.replace('\"47!T\"', '\"_47\"');
            json = json.replace('\"48!T\"', '\"_48\"');
            json = json.replace('\"49!T\"', '\"_49\"');
            json = json.replace('\"50!T\"', '\"_50\"');
            json = json.replace('\"51!T\"', '\"_51\"');
            json = json.replace('\"52!T\"', '\"_52\"');
            json = json.replace('\"53!T\"', '\"_53\"');
            json = json.replace('\"54!T\"', '\"_54\"');
            json = json.replace('\"55!T\"', '\"_55\"');
            json = json.replace('\"56!T\"', '\"_56\"');
            json = json.replace('\"57!T\"', '\"_57\"');
            json = json.replace('\"58!T\"', '\"_58\"');
            json = json.replace('\"59!T\"', '\"_59\"');
            json = json.replace('\"60!T\"', '\"_60\"');
            json = json.replace('\"61!T\"', '\"_61\"');
            json = json.replace('\"62!T\"', '\"_62\"');
            json = json.replace('\"63!T\"', '\"_63\"');
            json = json.replace('\"64!T\"', '\"_64\"');
            json = json.replace('\"65!T\"', '\"_65\"');
            json = json.replace('\"66!T\"', '\"_66\"');
            json = json.replace('\"67!T\"', '\"_67\"');
            json = json.replace('\"68!T\"', '\"_68\"');
            json = json.replace('\"69!T\"', '\"_69\"');
            json = json.replace('\"70!T\"', '\"_70\"');
            json = json.replace('\"71!T\"', '\"_71\"');
            json = json.replace('\"72!T\"', '\"_72\"');
            json = json.replace('\"73!T\"', '\"_73\"');
            json = json.replace('\"74!T\"', '\"_74\"');
            json = json.replace('\"75!T\"', '\"_75\"');
            json = json.replace('\"76!T\"', '\"_76\"');
            json = json.replace('\"77!T\"', '\"_77\"');
            json = json.replace('\"78!T\"', '\"_78\"');
            json = json.replace('\"79!T\"', '\"_79\"');
            json = json.replace('\"80!T\"', '\"_80\"');
            json = json.replace('\"81!T\"', '\"_81\"');
            json = json.replace('\"82!T\"', '\"_82\"');
            json = json.replace('\"83!T\"', '\"_83\"');
            json = json.replace('\"84!T\"', '\"_84\"');
            json = json.replace('\"85!T\"', '\"_85\"');
            json = json.replace('\"86!T\"', '\"_86\"');
            json = json.replace('\"87!T\"', '\"_87\"');
            json = json.replace('\"88!T\"', '\"_88\"');
            json = json.replace('\"89!T\"', '\"_89\"');
            json = json.replace('\"90!T\"', '\"_90\"');
            json = json.replace('\"91!T\"', '\"_91\"');
            json = json.replace('\"92!T\"', '\"_92\"');
            json = json.replace('\"93!T\"', '\"_93\"');
            json = json.replace('\"94!T\"', '\"_94\"');
            json = json.replace('\"95!T\"', '\"_95\"');
            json = json.replace('\"96!T\"', '\"_96\"');
            json = json.replace('\"97!T\"', '\"_97\"');
            json = json.replace('\"98!T\"', '\"_98\"');
            json = json.replace('\"99!T\"', '\"_99\"');
            json = json.replace('\"0!T\"', '\"_0\"');
            json = json.replace('\"1!T\"', '\"_1\"');
            json = json.replace('\"2!T\"', '\"_2\"');
            json = json.replace('\"3!T\"', '\"_3\"');
            json = json.replace('\"4!T\"', '\"_4\"');
            json = json.replace('\"5!T\"', '\"_5\"');
            json = json.replace('\"6!T\"', '\"_6\"');
            json = json.replace('\"7!T\"', '\"_7\"');
            json = json.replace('\"8!T\"', '\"_8\"');
            json = json.replace('\"9!T\"', '\"_9\"');
            json = json.replace('T!T', 'Total');
            return json;
        }  
        public Static void sendEmailonException(Exception e,String Methodname){
             Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
             String[] toAddresses = new String[] {'amasa03@ca.com','ponse01@ca.com'};
             mail.setToAddresses(toAddresses);
             mail.setReplyTo('developer@acme.com');
             mail.setSenderDisplayName('Apex error message');
             mail.setSubject('Error In Global Leaderboard - '+Methodname);
             mail.setHtmlBody('<html><body>handled exception <br/> <br/> <b>Exception details:</b> <br/> <br/>  Class Name: GlobalLeaderboardController  <br/>   Method :'+Methodname+' <br/>  '+ e+'</body></html>');
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
}