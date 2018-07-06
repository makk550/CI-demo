global class DigitalLeaderboardController{
    Static List<UserData> UserListfromFile;
    Static Map<Id,String> UserListByID;
    Static Map<String,String> UserListByName;
    list<Folder> folderlist = null;
    /*wrapper classes to handle json data*/
    /*------BEGIN-------*/
    public class GettickerDataClass{
        public TickerGroupingsDown groupingsDown{get;set;}
    }
    public class TickerAggregates{
        List<TickerAggregatesList> aggregates{get;set;}
    }
    public class TickerAggregatesList{
        public String value{get;set;}
        public String label{get;set;}
    }
    public class DealDataClass{
        public DealReportMetadata reportMetadata{get;set;}
    }
    public class DealReportMetadata{
        public List<String> detailColumns{get;set;}
    }
    public class TickerGroupingsDown{
        public List<TickerGroupings> groupings{get;set;}
    }
    public class TickerGroupings{
        
        public String value{get;set;}
        public String label{get;set;}
        public String key{get;set;}
    }
    public class Team{
            public String FilterID { get; set; }
            public String FilterName { get; set; }
            public String TeamName { get; set; }
            public String Manager { get; set; }
            public String StackRankings { get; set; }
            public String Status { get; set; }
    }
    public class StackRanking{
            public String UserID{get;set;}
            public String Name{get;set;}
            public String Pic{get;set;}
            public Integer MeetingsHeld{get;set;}
            public Integer MeetingsScheduled{get;set;}
            public Integer SAOs{get;set;}
    }
    public class StackRanking_v2{
            public String UserID { get; set; }
            public String Name { get; set; }
            public String Pic { get; set; }
            public Integer SAOs { get; set; }
            public String BookedDeals { get; set; }
            public String PipelineAdded { get; set; }
            public Integer SortNum { get; set; }
   }
    public class DashboardFilterMainClass{
         public DashboardMetadataClass dashboardMetadata{get;set;}
    }
    public class DashboardMetadataClass{
        public List<DashboardMetadataFilter> filters{get;set;}
    }
    public class DashboardMetadataFilter{
        public List<DashboardFilterOptions> options{get;set;}
    }
    public class DashboardFilterOptions{
        public String id{get;set;}
        public String alias{get;set;}
        public String value{get;set;}
    }
    /*used refresh dashboard filter to get the team data*/ 
    public class DashboardComponentMain{
        public List<DashboardComponentClass> componentData{get;set;}
    }
    public Class DashboardComponentClass{
            public DashboardStatus status{get;set;}
            public DashboardReportResult reportResult{get;set;}
            public String componentId{get;set;}
    }
    public class DashboardStatus{
        public String dataStatus{get;set;}
    }
    public class DashboardReportResult{
        public TickerGroupingsDown groupingsDown{get;set;}
    }
    public class UserProfileDataClass{
        public UserProfileFactMap factMap{get;set;}
        public UserReportMetadata reportMetadata{get;set;}
    }
    public class UserProfileFactMap{
        FactMapTotal Total{get;set;}
    }
    public class FactMapTotal{
        List<FactMapRows> rows{get;set;}
    }
    public class FactMapRows{
        List<FactMapRowsData> dataCells{get;set;}
    }
    public class FactMapRowsData{
         public String value{get;set;}
         public String label{get;set;}
    }
    public class UserReportMetadata{
        public List<String> detailColumns{get;set;}
    }
    public class UserPhotoData{
        Photo photo{get;set;}
    }
    public class Photo{
        Public String fullEmailPhotoUrl{get;set;}
    }
    public class UserData{
            public String UserID { get; set; }
            public String Name { get; set; }
            public String Pic { get; set; }
            public String Alias { get; set; }
    }
    public class Deal{
            public String UserID { get; set; }
            public String Name { get; set; }
            public String Pic { get; set; }
            public String Account { get; set; }
            public String Product { get; set; }
            public String Amount { get; set; }
     }
    /* ----- END ------*/
    
   
 
    /* this method is to get the top header data [header ranking data] from SFDC report */
    @RemoteAction
    global static String GetTickerData(String Region){
        String returnData = null;
        try{
                System.debug('restQuerssy');
                System.debug(getSFDCReportsID(Region,'topISRsbySAOsID'));
                System.debug('restQuerssy');
                String restQuery = 'callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/' + getSFDCReportsID(Region,'topISRsbySAOsID');
                System.debug('restQuery'+restQuery);
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Content-Type','application/json');
                req1.setHeader('accept','application/json');
                req1.setMethod('GET');
                req1.setEndpoint(restQuery);
                HttpResponse res1 = h2.send(req1);
                //System.debug('res1--->'+res1);
                String jsonresponse = String.valueOf(res1.getbody());
                System.debug('before clean :'+ jsonresponse);
                String Cleanjsonresponse = CleanJson(jsonresponse);
                //System.debug('Cleanjsonresponse :'+ Cleanjsonresponse);
                GettickerDataClass tikerdataobj = (GettickerDataClass)JSON.deserialize(Cleanjsonresponse, GettickerDataClass.class);
                //System.debug('tikerdataobj  : '+tikerdataobj);
                Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(Cleanjsonresponse);
                Map<String, Object> n = (Map<String, Object>)m.get('factMap');
                Set<String> factmapkeys = n.keySet();
                //System.debug('TickerAggregates ');
                List<StackRanking> rankings = new List<StackRanking>();
                List<TickerGroupings> tickergroupingsList = tikerdataobj.groupingsDown.groupings;
                UserPhotoFromJson(Region);
                for(TickerGroupings itemdata : tickergroupingsList){
                    StackRanking rank = new StackRanking();
                    rank.Name = itemdata.label;
                    rank.UserID = itemdata.value;
                    rank.Pic = getUserPhotofromList(itemdata.value);
                    rank.MeetingsHeld=0;
                    rank.MeetingsScheduled=0;
                    
                    for(String key : factmapkeys){
                        //System.debug('key ' + n.get(key));
                        
                        if( (key == '_' + itemdata.key) || (key == itemdata.key + '!T')){
                            Map<String, object> l = (Map<String, object>)n.get(key);
                            List<Object> listofob = (List<Object>)l.get('aggregates');
                            Map<String,Object> mapofdata= (Map<String,Object>)listofob[0];
                            //System.debug('value '+ mapofdata.get('value'));
                            rank.SAOs = (Integer) mapofdata.get('value');
                            break;
                            
                        }
                    }
                    rankings.add(rank);
                    //System.debug(itemdata);
                }
                //System.debug('rankings '+ rankings);
                returnData = JSON.serialize(rankings);
                System.debug('Ticker format  '+ returnData);
        }
        catch(Exception e){
            System.debug('exception in GetTickerData method  ' + e );
            sendEmailonException(e,'GetTickerData');
        } 
        return returnData;
    }
    
    /* This method is to get the booked deals and deals likely to book from SFDC reports */
    @RemoteAction
    global static String GetDealsData(String dealType,String Region){
        String returnData = null;
        String feedSourceID = getSFDCReportsID(Region,dealType);
        try{
                String restQuery = 'callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/' + feedSourceID + '/describe';
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Content-Type','application/json');
                req1.setHeader('accept','application/json');
                req1.setMethod('GET');
                req1.setEndpoint(restQuery);
                HttpResponse res1 = h2.send(req1);
                String jsonresponse = String.valueOf(res1.getbody());
                System.debug('response from json' + jsonresponse);
                String reportfilter = jsonresponse.replace('\"REPLACE_ME\"', GetTeamNames(Region));
                //System.debug('change setBody' + reportfilter);
                String restQuery1 = 'callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/' + feedSourceID + '?includeDetails=true';
                Http h1 = new Http();
                HttpRequest req2 = new HttpRequest();
                req2.setHeader('Content-Type','application/json');
                req2.setHeader('accept','application/json');
                req2.setMethod('POST');
                req2.setBody(reportfilter);
                req2.setEndpoint(restQuery1);
                HttpResponse res2 = h1.send(req2);
                String jsonresponse1 = String.valueOf(res2.getbody());
                System.debug('jsonresponse1' + jsonresponse1);
                String Cleanjsonresponse = CleanJson(jsonresponse1);
                System.debug('Cleanjsonresponse '+ Cleanjsonresponse);
                DealDataClass delametadata = (DealDataClass)JSON.deserialize(Cleanjsonresponse, DealDataClass.class);
                Map<String, Object> dealobjdata = (Map<String, Object>)JSON.deserializeUntyped(Cleanjsonresponse);
                Map<String, Object> dealfactmap = (Map<String, Object>)dealobjdata.get('factMap');
                Map<String, Object> dealtotal = (Map<String, Object>)dealfactmap.get('Total');
                List<Deal> deals = new List<Deal>();
                List<Object> dealrows = (List<Object>)dealtotal.get('rows');
                List<String> dealcolumn =delametadata.reportMetadata.detailColumns;
                //System.debug('dealobjdata' + dealrows );
                UserPhotoFromJson(Region);
                for(Object row : dealrows ){
                    Deal deal = new Deal();
                    Map<String,Object> datarow = (Map<String,Object>)row;
                    List<Object> dealdatacells = (List<Object>)datarow.get('dataCells');
                    //System.debug('rowdata '+ dealdatacells);
                    Integer count =0;
                    for(String column:dealcolumn){
                        Map<String,Object> datacell = (Map<String,Object>) dealdatacells[count];
                        //System.debug('datacell' + datacell.get('label'));
                        if (column.toLowerCase().contains('rep_name')){
                                deal.Name = (String)datacell.get('label');
                                deal.UserID = (String)datacell.get('value');
                                deal.Pic = getUserPhotofromList(deal.UserID);
                         }
                         else if (column.toLowerCase().contains('account'))
                                deal.Account = (String)datacell.get('label');
                         else if (column.toLowerCase().contains('product'))
                                deal.Product = (String)datacell.get('label');
                        else if (column.toLowerCase().contains('sales_price_net_to_ca')){
                             String Amount = (String)datacell.get('label');
                             deal.Amount = Amount.replace('USD ', '$');
                        }
                               
                            count++;
                    }//End of column  for-loop
                    Boolean containsDeal = false;
                    for(Deal searchFor: deals){
                        if (searchFor.Amount == deal.Amount && searchFor.Product == deal.Product && searchFor.Name == deal.Name && searchFor.Account == deal.Account)
                                containsDeal = true;
                    }
                    if (!containsDeal && deal.Amount != '0' && deal.Amount != '0.00' && deal.Amount != '$0.00' && deal.Amount != '$0')
                            deals.Add(deal);
                }//End of row for-loo
                
                //System.debug('delas data' + deals);
                returnData = JSON.serialize(deals);
                System.debug(dealType+ ' json format  '+ returnData);

        }catch(Exception e){
            System.debug('exception' + e);
        }
        return returnData;
    }
    public Static String GetTeamNames(String Region){
        String resultstring = null;
        list<Folder> folderlist = [select id,name from Folder where Name = 'DigitalSalesLeaderboard'];
        if(folderlist.size()>0){
            String DocumentName = Region + '_sfdc_chatter_photos.json';
            List<Document> doc = [SELECT name,body,BodyLength,Url, Type FROM Document where name = :DocumentName and FolderId = :folderlist[0].id limit 1];
            if(doc.size() > 0){
               Blob blobdata = Blob.valueof(doc[0].body.toString());
               //System.debug('vlaue '+blobdata.tostring()); 
               String Documentresult =  blobdata.tostring();
                //System.debug('document result '+ Documentresult +' - ' + Region); 
               List<UserData> regionuserlist = (List<UserData>)JSON.deserialize(Documentresult,List<UserData>.class);
               //System.debug('user list  '+ regionuserlist); 
                if(regionuserlist != null){
                    if(String.isEmpty(resultstring)){
                        resultstring = '\"';
                        for(UserData u: regionuserlist){
                            resultstring = resultstring + u.Name +',';
                        }  
                        resultstring=resultstring.removeEndIgnoreCase(',');
                        resultstring = resultstring + '\"';
                    }
            
                }
                
            }  
            else{
                 System.debug('not found document');
            }
        }
        else{
            System.debug('not found folder');
        }
        //System.debug('before return ' + resultstring);
        return resultstring;
    }
    public Static String getUserPhotofromList(String UserID){
        String Userphoto = null;
        /*if(UserListfromFile != null){
            if(String.isEmpty(Userphoto)){
                for(UserData u: UserListfromFile){
                    if(u.UserID == UserID){
                        Userphoto = u.Pic;
                        break;
                    }
                }  
            }
            
            
        }*/
        Userphoto=UserListByID.get(UserID);
        return (!String.isEmpty(Userphoto)) ? Userphoto : 'https://ca.my.salesforce.com/img/userprofile/default_profile_200.png?fromEmail=1';
    }
    public Static String getUserPhotofromListByName(String UserName){
        String Userphoto = null;
        if(UserListfromFile != null){
            if(String.isEmpty(Userphoto)){
                for(UserData u: UserListfromFile){
                    if(u.Name == UserName){
                        Userphoto = u.Pic;
                        break;
                    }
                }  
            }
            
            
        }
        return (!String.isEmpty(Userphoto)) ? Userphoto : 'https://ca.my.salesforce.com/img/userprofile/default_profile_200.png?fromEmail=1';
    }
    
    /* this method is to get the team stack ranking data from SFDC Dashboard */ 
    @RemoteAction
    global static String RefreshDashboardAndFilters(String Region){
        String dasboardID = null;
        String Returnresult= null;
        try{
                dasboardID = getSFDCReportsID(Region,'dashboardID');
                    String restQuery = 'callout:Leaderboard_Auth/services/data/v31.0/analytics/dashboards/' + dasboardID;
                    Http h2 = new Http();
                    HttpRequest req1 = new HttpRequest();
                    req1.setHeader('Content-Type','application/json');
                    req1.setHeader('accept','application/json');
                    req1.setMethod('GET');
                    req1.setEndpoint(restQuery);
                    HttpResponse res1 = h2.send(req1);
                    String jsonresponse = String.valueOf(res1.getbody());
                    System.debug('before clean :'+ jsonresponse);
                    String Cleanjsonresponse = CleanJson(jsonresponse);
                    //System.debug('Cleanjsonresponse'+Cleanjsonresponse);
                    DashboardFilterMainClass dashboarddataobj = (DashboardFilterMainClass)JSON.deserialize(Cleanjsonresponse, DashboardFilterMainClass.class);
                    //List<DashboardFilterOptions> FilterOptions = dashboarddataobj.dashboardMetadata.filters[0].options;
                    List<DashboardMetadataFilter> dashboardFilter = dashboarddataobj.dashboardMetadata.filters;
                    //System.debug('json before - '+dashboardFilter);
                    List<Team> filters = new List<Team>();
                    UserPhotoFromJson(Region);
                    //filters data and storing in filters list
                    if(dashboardFilter != null){
                       for(DashboardMetadataFilter row : dashboardFilter){
                            List<DashboardFilterOptions> options = row.options;
                           if(options != null){
                               for(DashboardFilterOptions option : options){
                                    Team team = new Team();
                                    team.FilterName = option.alias;
                                    team.FilterID = option.id;
                                    team.Manager = option.value;
                                    try{
                                        team.TeamName = team.FilterName;
                                        team.TeamName = team.TeamName.substringBefore('/');
                                        //System.debug('team.TeamName' + team.TeamName);
                                       
                                    }catch(Exception e){
                                        System.debug('exception '+e);
                                    }
                                   team.StackRankings = null;
                                   if(Region == 'EMEA'){
                                       team.TeamName = '';
                                   }else if(Region == 'NA'){
                                       team.TeamName = team.TeamName.replace('1', '').replace('2', '');
                                   }else if(Region == 'LA' || Region == 'APJ'){
                                       team.TeamName = 'Operating Area';
                                   }else if(Region == 'GLOBAL'){
                                        team.TeamName = team.TeamName.replace('1', '').replace('2', '');
                                        if(team.TeamName == 'NA Service Management ' || team.TeamName == 'LA All ' || team.TeamName == 'EMEA All' || team.TeamName == 'APJ All ')
                                        {
    
                                            team.Manager = team.TeamName;
                                            team.TeamName = '';
    
                                        }
                                   }
                                    
                                   filters.add(team);
                               }
                           }
                           
                        
                        } 
                    }
                    //jSystem.debug('filters list ---' + filters);
                    //team members data from dashboard
                    try{
                            String BookedDealscomponentID =getSFDCReportsID(Region,'BookedDealscomponentID');
                            String PipelineAddedComponentId =getSFDCReportsID(Region,'PipelineAddedComponentId');
                            String SAOComponentID =getSFDCReportsID(Region,'SAOComponentID');
                          for(Team team : filters){
                            if(!String.isEmpty(team.FilterID)){
                                String restQuery1 = 'callout:Leaderboard_Auth/services/data/v31.0/analytics/dashboards/' + dasboardID + '?filter1=' + team.FilterID;
                                //System.debug(team.FilterID+'restQuery1 '+ restQuery1);
                                Http h = new Http();
                                HttpRequest req = new HttpRequest();
                                req.setHeader('Content-Type','application/json');
                                req.setHeader('accept','application/json');
                                req.setMethod('GET');
                                req.setEndpoint(restQuery1);
                                HttpResponse res = h.send(req);
                                String jsonresponse1 = String.valueOf(res.getbody());
                                //System.debug('before clean :'+ jsonresponse);
                                String resultresponse = CleanJson(jsonresponse1);
                                System.debug('resultresponse--2'+resultresponse);
                                List<StackRanking_v2> rankings = new List<StackRanking_v2>();
                                DashboardComponentMain dashboardcomponentobj = (DashboardComponentMain)JSON.deserialize(resultresponse, DashboardComponentMain.class);
                                Map<String, Object> rankfactmapobjdata = (Map<String, Object>)JSON.deserializeUntyped(resultresponse);
                                List<Object> rankfactmapcomponent = (List<Object>)rankfactmapobjdata.get('componentData');
                                Integer rankfactmapcount =0;
                                //System.debug('dashboardcomponentobj.componentData'+dashboardcomponentobj.componentData);
                                for(DashboardComponentClass component: dashboardcomponentobj.componentData){
                                    String componentID = component.componentID;
                                    String reportStatus = component.status.dataStatus;
                                    Map<String,Object> rankfactreport = (Map<String,Object>)rankfactmapcomponent[rankfactmapcount];
                                    Map<String,object> rankreportResult = (Map<String,Object>)rankfactreport.get('reportResult');
                                    Map<String,Object> rankreportfactmapdata = (Map<String,Object>)rankreportResult.get('factMap');
                                    Set<String> factmapkeys = rankreportfactmapdata.keySet();
                                    //System.debug('rankreportfactmapdata' + rankreportfactmapdata);
                                    if(reportStatus == 'DATA'){
                                        for(TickerGroupings grouping : component.reportResult.groupingsDown.groupings){
                                            Boolean add = false;
                                            StackRanking_v2 rank;
                                            for(StackRanking_v2 item : rankings){
                                                if(item.UserID == grouping.value){
                                                    rank = item;
                                                    break;
                                                }
                                            }
                                            if(rank == null){
                                                add = true;
                                                rank = new StackRanking_v2();
                                                rank.Name = grouping.label;
                                                rank.UserID = grouping.value;
                                                rank.Pic =getUserPhotofromList(grouping.value);
                                            }
                                            //System.debug('in for loop' + rank);
                                            for(String key : factmapkeys){
                                                if( (key == '_' + grouping.key) || (key == grouping.key + '!T')){
                                                    Map<String, object> l = (Map<String, object>)rankreportfactmapdata.get(key);
                                                    List<Object> listofob = (List<Object>)l.get('aggregates');
                                                    for(Object aggregateobj : listofob){
                                                        Map<String,Object> mapofdata= (Map<String,Object>)aggregateobj;
                                                        //System.debug('mapofdata' + mapofdata);
                                                        Integer num = 0;
                                                        num = Integer.valueOf(mapofdata.get('value'));
                                                        //int.TryParse(count.value.ToString(), out num);
                                                        String dollar = (String)mapofdata.get('label');
                                                        dollar = dollar.replace('USD ', '$');
                                                        dollar = (dollar.contains('.')) ? dollar.substringBefore('.') : dollar;
                                                        //System.debug('dollar'+dollar);
    
                                                        Integer sortnumber = 0;
                                                        sortnumber = Integer.valueOf(dollar.Replace('$', '').Replace(',', '').Replace(' ', ''));
                                                        //sortnumber = Integer.valueOf(dollar);
                                                            
                                                        rank.SortNum = sortnumber;
    
                                                        if(componentID == BookedDealscomponentID){
                                                            //$Booked Deals
                                                            rank.BookedDeals = dollar;
                                                        }else if(componentID == PipelineAddedComponentId){
                                                            //$Pipeline Added
                                                            rank.PipelineAdded = dollar;
                                                        }else if(componentID == SAOComponentID)
                                                        {
                                                            //#SAOs
                                                            rank.SAOs = num;
                                                        }
                                                        break;
                                                    }
                                                    
                                                }
                                                
                                            }
                                            if (add){
                                                rankings.Add(rank);
                                            }
                                                
                                        }
                                        
                                    }
                                    rankfactmapcount++;
                                }
                                
                                //System.debug('rankings' + rankings);
                                team.StackRankings = JSON.serialize(rankings);
                                
                            }
                         }
                        
                    }catch(Exception e){
                        System.debug('exception while fecthing data of team members' +e);   
                    }
                    //System.debug('filters' +filters);
                    //String teammembersdata = JSON.serialize(filters);
                    //managers info
                    List<StackRanking_v2> managers = new List<StackRanking_v2>();
                    for(Team team : filters){
                        if(!String.isEmpty(team.FilterID)){
                            StackRanking_v2 manager = new StackRanking_v2();
                            manager.Name = team.Manager;
                            String Jsonstackstring = team.StackRankings;
                            List<StackRanking_v2> individuals =(List<StackRanking_v2>)JSON.deserialize(Jsonstackstring, List<StackRanking_v2>.class);
                            //System.debug('individuals' + individuals);
                            if (individuals != null)
                            {
                                Integer bookings = 0;
                                Integer pipeline = 0;
                                Integer saos = 0;
                                for(StackRanking_v2 individual : individuals)
                                {
                                   try{
                                        Integer value1 = 0;
                                        if(individual.BookedDeals != null){
                                            value1 = Integer.valueOf(individual.BookedDeals.Replace(',', ''));
                                            bookings += value1;
                                        }
                                        Integer value2 = 0;
                                        if(individual.PipelineAdded != null){
                                            value2 = Integer.valueOf(individual.PipelineAdded.Replace(',', ''));
                                            pipeline += value2;
                                        }
                                       if(individual.SAOs != null){
                                           saos += individual.SAOs;
                                       }
                                        
                                        //String.equalsIgnoreCase(other)
                                        
                                            if (individual.Name.equalsIgnoreCase(manager.Name))
                                            {
                                                manager.UserID = individual.UserID;
                                                manager.Pic = individual.Pic;
                                            }
                                            
                                        }catch(Exception e){
                                            System.debug('Exception in team'+e);
                                        }
                                        
                                        
                                    
                                    
                                }
                                
                                manager.BookedDeals = String.valueOf(bookings); 
                                manager.PipelineAdded =String.valueOf(pipeline);
                                manager.SAOs = saos;
                                manager.SortNum = bookings;
                                manager.Pic = getUserPhotofromListByName(manager.Name);
                            }
                            managers.add(manager);
                            
                        }
                    }
                    //System.debug('managers' + managers);
                    Team managersdata = new Team();
                    managersdata.FilterID = null;
                    managersdata.FilterName = null;
                    if(Region == 'NA' || Region == 'EMEA'){
                        managersdata.TeamName = 'Managers';
                    }else if(Region == 'LA' || Region == 'APJ'){
                        managersdata.TeamName = 'Operating Area';
                    }else if(Region == 'GLOBAL'){
                        managersdata.TeamName = 'GEO\'s';
                    }
                    
                    managersdata.Manager = 'ALL';
                    managersdata.StackRankings =JSON.serialize(managers);
                    managersdata.Status = null;
                    filters.add(managersdata);
                    Returnresult = JSON.serialize(filters);

        }catch(Exception e){
            System.debug('exception'+e);
            sendEmailonException(e,'RefreshDashboardAndFilters');
        }
        System.debug('return result'+ Returnresult);
        return Returnresult;
    }
    public Static String getSFDCReportsID(String Region,String requestLabel){
        Map<String, DigitalLeaderbaordID__c> AllgeoData = DigitalLeaderbaordID__c.getAll();
        DigitalLeaderbaordID__c selectedregion = AllgeoData.get(Region);
        System.debug(selectedregion);
        if(requestLabel == 'insideSalesUsers'){
            return selectedregion.insideSalesUsers__c;
        }else if(requestLabel == 'dashboardID'){
            return selectedregion.dashboardID__c;
        }else if(requestLabel == 'bookedDealsByQuarter'){
            return selectedregion.bookedDealsByQuarter__c;
        }else if(requestLabel == 'likelyDealsByQuarter'){
            return selectedregion.likelyDealsByQuarter__c;
        }else if(requestLabel == 'topISRsbySAOsID'){
            return selectedregion.topISRsbySAOsID__c;
        }else if(requestLabel == 'BookedDealscomponentID'){
            return selectedregion.Booked_Deals_componentID__c;
            
        }else if(requestLabel == 'PipelineAddedComponentId'){
            return selectedregion.Pipeline_Added_ComponentId__c;
        }else if(requestLabel == 'SAOComponentID'){
            return selectedregion.SAO_ComponentID__c;
        }
        //System.debug('selected region salesusers ID '+selectedregion.insideSalesUsers__c);
        return null;
    }
         
    @Future(callout = true )
    public static void SaveTeamPhotos(String Region){
            List<String> UserchatterList =new List<String>();
            //List<Network> communityIDList = [SELECT Id FROM Network WHERE Name = 'Customer Community'];
            String restQuery = 'callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/' + getSFDCReportsID(Region,'insideSalesUsers') + '?includeDetails=true';
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('GET');
            req1.setEndpoint(restQuery);
            HttpResponse res1 = h2.send(req1);
            String jsonresponse = String.valueOf(res1.getbody());
            System.debug('before clean :'+ jsonresponse);
            String Cleanjsonresponse = CleanJson(jsonresponse);
            //System.debug('Cleanjsonresponse' + Cleanjsonresponse);
            UserProfileDataClass userprofiledataobj = (UserProfileDataClass)JSON.deserialize(Cleanjsonresponse, UserProfileDataClass.class);
            //System.debug('data of user profile ' + userprofiledataobj.factMap.Total.rows);
            List<FactMapRows> rows= userprofiledataobj.factMap.Total.rows;
            List<String> columns= userprofiledataobj.reportMetadata.detailColumns;
            List<UserData> users = new List<UserData>();
            for(FactMapRows row : rows){
                UserData user = new UserData();
                List<FactMapRowsData> dataCells = row.dataCells;
                Integer count = 0;
                for(String column:columns){
                    if (column.toUpperCase().contains('USER_ID'))
                        user.UserID = dataCells[count].value;
                    else if (column.toUpperCase().Contains('FULL_NAME'))
                        user.Name = dataCells[count].label;
                    else if (column.toUpperCase().Contains('ALIAS'))
                        user.Alias = dataCells[count].label;
                    count++;
                }
                if(!String.isEmpty(user.UserID)){
                    UserchatterList.add(user.Name);
                }
                users.add(user);
            }
            List<User> ulist = [select id,Name,FullPhotoUrl from User where Name IN :UserchatterList and isActive = true];
            Map<String,String> UsernamephotoMap =  new Map<String,String>();
            
            if(ulist.size() > 0){
                for(User u : ulist){
                    UsernamephotoMap.put(u.Name, u.FullPhotoUrl);
                
                }
                
            }
            for(UserData user :users){
                user.Pic = UsernamephotoMap.get(user.Name);   
             }
            String JSONString = JSON.serialize(users);
            //System.debug('json format  '+ JSONString);
            UpdateChatterJson(JSONString,Region);
            //System.debug('user list' +UserchatterList);
       
    }
    public static void UpdateChatterJson(String JSONData,String Region){
        list<Folder> folderlist = [select id,name from Folder where Name = 'DigitalSalesLeaderboard'];
        if(folderlist.size()>0){
            String Documentname = Region + '_sfdc_chatter_photos'+'.json';
            //System.debug('document name' + Documentname);
            list<Document> doc= [select id,name,FolderId,body from Document where name = :Documentname  and FolderId = :folderlist[0].id limit 1]; 
               if(doc.size()>0){  
                  doc[0].FolderId = folderlist[0].id;
                  doc[0].body = blob.valueof(JSONData);                    
                   update doc;   
                   //System.debug('document is updated');
                }  else {                
                    Document doc1 = new Document (Name = Documentname);
                    doc1.FolderId = folderlist[0].id;
                    doc1.Description = Region +'  region DigitalsalesLeaderbaord chatter photos';              
                    doc1.Body = Blob.valueOf(JSONData);                
                    insert doc1;    
                    //System.debug('new Document is created ');
                   } 
            
        }else{
            System.debug('unable to find folder');
        }
                 
           
    }
    public Static void UserPhotoFromJson(String Region){
        //System.debug('in user photo');
        list<Folder> folderlist = [select id,name from Folder where Name = 'DigitalSalesLeaderboard'];
        if(folderlist.size()>0){
            String DocumentName = Region + '_sfdc_chatter_photos.json';
            List<Document> doc = [SELECT name,body,BodyLength,Url, Type FROM Document where name = :DocumentName and FolderId = :folderlist[0].id limit 1];
            if(doc.size() > 0){
               Blob blobdata = Blob.valueof(doc[0].body.toString());
               //System.debug('vlaue '+blobdata.tostring()); 
               String Documentresult =  blobdata.tostring();
               UserListfromFile = (List<UserData>)JSON.deserialize(Documentresult,List<UserData>.class);
                //System.debug('user list  '+UserListfromFile); 
                if(UserListfromFile != null){
                    UserListByID = new Map<Id,String>();
                    for(UserData u: UserListfromFile){
                        if(!UserListByID.containsKey(u.UserID)){
                            UserListByID.put(u.UserID,u.Pic);
                        }
                    } 
                }
               
                
            }  
            else{
                 System.debug('not found document');
            }
        }
        else{
            System.debug('not found folder');
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
         String[] toAddresses = new String[] {'amasa03@ca.com'};
         mail.setToAddresses(toAddresses);
         mail.setReplyTo('noreply@ca.com');
         mail.setSenderDisplayName('Apex error message');
         mail.setSubject('Error In Digital Leaderboard - '+Methodname);
         mail.setHtmlBody('<html><body>handled exception <br/> <br/> <b>Exception details:</b> <br/> <br/>  Class Name: DigitalLeaderboardController  <br/>   Method :'+Methodname+' <br/>  '+ e+'</body></html>');
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
     
    
}