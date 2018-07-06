/*
* Added by BAJPI01 - US179439
* 
* This controller fetches account data from MDM through EAI for the GP Number
* associated with the account. Using that GP number, it then fetches entitlement
* data from ERDB through external object. On Clicking of CA Site ID, specific (sales)
* users can edit ISP values.
*/

public class ProductInstanceUIController {

/*
    
    public boolean result{get;set;}
    @TestVisible List<Duns> dunsList;                                                                       //stores the deserialized duns list
    @TestVisible List<Duns> finaldunsList = new List<Duns>();                                               //stores the final deserialized duns list
    String GPNumber,GPName;                                                                                 //variables to store the GPNumber and GP Name of the account.
    public String valToSearch{get;set;}                                                                     //the value to search as part of the search functionality
    @TestVisible Account acc;                                                                               //to store the account record.
    @TestVisible List<Account> acclist = new List<Account>();
    @TestVisible Id Accid;                                                                                  // to store the account id from the page URL, using this GP Number is fetched
    Public String dunsnofrompage{get;set;}                                                                  //duns number from the instance page, for which the entitlement records need to be displayed
    Public String type{get;set;}                                                                            //duns type -whether it is gp/gu/duns
    Public string ispnumber{get;set;}                                                                       //isp number from the page
    public Map<GUDunsNumberClass,Integer> renderchildornot {get;set;}                                       //this map stores if the GU has child or not, and accordingly + sign is displayed
    public Map<String,Integer> renderGUchildornot{get;set;}                                                 //this map stores if the GP has child or not, and accordingly + sign is displayed
    @TestVisible Map<String,List<Duns>> GUDunsList = new Map<String,List<Duns>>();                          //to store the initial tree structre,this is later filtered to populate dunsHierarchyTree
    @TestVisible Map<String,Duns> DunsNoMap = new Map<String,Duns>();
    public Map<GUDunsNumberClass,List<Duns>> DunsTree{get;set;}                                             //to store GU-Duns Maping with details
    public Map<String,Map<GUDunsNumberClass,List<Duns>>> dunsHierarchyTree{get;set;}                        //this map is used to display the tree structure
    public List<ProductInstanceView__x> dunsdetailstodisplay{get;set;}                                      //to display the instance details against selected record from tree(3/4th of the screen)
    @TestVisible List<ProductInstanceView__x> allDunDetailsBasedongp = new List<ProductInstanceView__x>();  //to store records against the gp number
    public boolean solutionexists{get;set;}                                                                 //variable to store if the solution exists or not
    public boolean treesolutionexists{get;set;}                                                             //variable to store whether the account has a gp number or not.
    @TestVisible Map <String,List<String>> parentchildlist = new Map<String,List<String>>(); //stores the list of children against the parent -filtered final pairing
    @TestVisible Map<String,List<ProductInstanceView__x>> dunsentitlementmap = new Map<String,List<ProductInstanceView__x>>(); //map to store instance details against 
                                                                                                                                // the duns number, a duns number can return more than 1 row of product instance details
    Public GPAggregate gpdetail{get;set;}                                                                   //to show the aggregation values against the gp number
    Public Boolean doesgpdetailexist{get;set;}                                                              //if aggregation exists or not
    @Testvisible Map<String,List<ProductInstanceView__x>> productSearchHelper = new Map<String,List<ProductInstanceView__x>>();
    Public String NoEntitlementRecordsMessage{get{
        if(solutionexists==false)
            NoEntitlementRecordsMessage = 'There are no entitlements related to the selected customer.';
            return NoEntitlementRecordsMessage;}
        set;}
    Public Boolean NoEntitlementRecord{get;set;}
    Public Boolean NoRecordUnderAcc{get;set;}
    Public Map<Duns,Integer> renderdunsentitlement{get;set;}
    Public Map<GUDunsNumberClass,Integer> renderguentitlement{get;set;}
    public string usageredirectString{get;set;}
    static Map<String,String> paramMap; 
    public string accNameToUsage{get;set;}
    public string nametodisplay{get;set;}
    
    @TestVisible Integer status;
    // Generated by JSON2Apex http://json2apex.herokuapp.com/ - as part of the JSON response from MDM
    
    public class DunsFamilyHierarchyResponsemain{
        DunsFamilyHierarchyResponse dunsFamilyHierarchyResponse;
        
    } 
    public class DunsFamilyHierarchyResponse{
        String Status;
        SearchResults searchResults;
        DunsFamilyHierarchyRequest dunsFamilyHierarchyRequest;
    }
    public class DunsFamilyHierarchyRequest{
        String gpdunsnumber;
    }
    public class SearchResults{
        List<Duns> duns; //stores the final deserialized list of duns value
    }
    public class Duns{
        public String domesticultimatebusinessname;
        public String businessname{get;set;}
        public String domesticultimatedunsnumber;
        public String physicalstreetaddress;
        public String parentOrHqname;
        public String globalultimatebusinessname;
        public String isactive;
        public String dunsnumber{get;set;}
        public String countryname;
        public String physiclstate{get;set;}
        public String physicalcity{get;set;}
        public String physicalzip;
        public String secondstreetaddress;
        public String globalultimatedunsnumber;
        public String parentdunsnumber;
    }
    
    //Generated by JSON2Apex ends here.
    
    //the below class is used to populate the GU details on the UI, it implements
    //comparable as it is a complex key for the map, so it needs the CompareTo function.
    public class GUDunsNumberClass implements Comparable{
        public String gudunsno{get;set;}
        public String state{get;set;}
        public String country{get;set;}
        public string gubusinessname{get;set;}
        public String dunsno{get;set;}
        
        public Integer CompareTo(object compareTo){
            
            GUDunsNumberClass TempGUDU = (GUDunsNumberClass) compareTo;
            if(gudunsno == TempGUDU.gudunsno)
                return 0;
            if(gudunsno > TempGUDU.gudunsno)
                return 1;
            return -1;
            
        }  
    }
    
    public class GPAggregate{
        public integer totalseats{get;set;}
        public integer totalpaid{get;set;}
        public integer totalunpaid{get;set;}
        public double ispvalue{get;set;}
    }
    
    private static String MDMEndpoint
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.ProdInstMDMEndpointProd : Label.ProdInstMDMEndpointQA;}
    } 
    
    private static String MDMUserName
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.ProdInstMDMUsernameProd : Label.ProdInstMDMUsernameQA;}
    } 
    
    private static String MDMAuthentication
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.ProdInstMDMAuthProd : Label.ProdInstMDMAuthQA;}
    } 
    
    public ProductInstanceUIController(){
        treesolutionexists = false;
        doesgpdetailexist = false;
        NoEntitlementRecord = false;
        
        if(ApexPages.currentPage().getParameters().get('accId')!=null&&ApexPages.currentPage().getParameters().get('accId')!='')
        {
            Accid = ApexPages.currentPage().getParameters().get('accId');
            acc = [Select GU_DUNS_NUMBER__c,GU_NAME__c,ISP__c from account where id =: Accid];
            if(acc!=null){
                GPNumber = acc.GU_DUNS_NUMBER__c;
                GPName = acc.GU_NAME__c; 
            }
            if(GPNumber!=null&&GPNumber!=''){
                treesolutionexists = true; //setting the variable to true if there is GP Number and GP Name associated with the acc.
                
                NoRecordUnderAcc = false;
                renderchildornot = new Map<GUDunsNumberClass,Integer>();
                renderguentitlement =new Map<GUDunsNumberClass,Integer>();
                renderGUchildornot = new Map<String,Integer>();
                renderdunsentitlement = new Map<Duns,Integer>();
                DunsTree = new Map<GUDunsNumberClass,List<Duns>>();
                dunsHierarchyTree = new Map<String,Map<GUDunsNumberClass,List<Duns>>>();
                gpdetail = new GPAggregate();
                usageredirectString = '';
                paramMap = ApexPages.currentPage().getParameters();
                for(String eachParam : paramMap.keySet()){
                    usageredirectString +='&'+eachParam+'='+paramMap.get(eachParam);
                } 
                loadservice();              //call loadservice method, it fetches data from MDM
                
            }
            else
            {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no GP Number associated with the account'));
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no account'));
        }
        
        
    }
    
    
    public void loadservice(){
        string responseFromGetService;
        Integer position;
        try{
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(MDMEndpoint); //endpoint
            //request.setEndpoint('https://eaisvcqafs.ca.com/mdm/duns/familytree/r.v1'); 
            request.setTimeout(12000);
            request.setMethod('POST');
            request.setBody('{"dunsFamilyHierarchyRequest": {"gpdunsnumber": "'+GPNumber+'"}}'); //body
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('consumerUsername', MDMUserName);
            request.setHeader('Authorization',MDMAuthentication);
            Http http = new Http();
            HTTPResponse response = http.send(request);
            system.debug('req-------- '+response);
            status = response.getStatusCode();
            responseFromGetService = String.valueOf(response.getBody());
            system.debug('--responseFromGetService -->'+responseFromGetService);
            if(status == 200){
                system.debug('200-------- '+status);                
                
                //this method will deserialize the response and store it in the DunsFamilyHierarchyResponse object
                DunsFamilyHierarchyResponsemain obj = (DunsFamilyHierarchyResponsemain)JSON.deserializestrict(
                    responseFromGetService, DunsFamilyHierarchyResponsemain.class);
                system.debug('DunsFamilyHierarchyResponsemain'+obj.dunsFamilyHierarchyResponse);
                dunsList = obj.dunsFamilyHierarchyResponse.searchResults.duns; //stores the duns list
                system.debug('duns'+dunsList);
                fetchrecords();
            }
        
        }
        catch(exception e){
            system.debug('exception '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Our Servers are currently being upgraded. Please try again later.'));
        }
        

        if(status==400){
            system.debug('entered 400----------');
            try{
                if(responseFromGetService.contains('"code":"12"')){                
                    position = responseFromGetService.indexOf('GP:');
                    position = responseFromGetService.indexOf('USER', position);
                    position = responseFromGetService.indexOf('GP:',position);
                    GPNumber = responseFromGetService.substring(position+3,position+12);
                    system.debug('pos========='+GPNumber);
                    callmdmagain();
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Our Servers are currently being upgraded. Please try again later.'));
                    NoEntitlementRecord = true;
                    NoRecordUnderAcc = true;
                }
                
            }
            catch(exception e){
                system.debug('exception is '+e);
            }
            
        }
        else if(status!=200&&status!=400){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Our Servers are currently being upgraded. Please try again later.'));
            NoEntitlementRecord = true;
            NoRecordUnderAcc = true;
        }
        
    }
    //to call mdm the second time incase the first mdm call has GU rolls up to GP message.
    public void callmdmagain(){
        string responseFromGetService;
        Integer position;
        try{
            
            HttpRequest request2 = new HttpRequest();
            request2.setEndpoint(MDMEndpoint); //endpoint
            //request2.setEndpoint('https://eaisvcqafs.ca.com/mdm/duns/familytree/r.v1'); 
            request2.setTimeout(12000);
            request2.setMethod('POST');
            request2.setBody('{"dunsFamilyHierarchyRequest": {"gpdunsnumber": "'+GPNumber+'"}}'); //body
            request2.setHeader('Content-Type', 'application/json');
            request2.setHeader('consumerUsername', MDMUsername);
            request2.setHeader('Authorization', MDMAuthentication);
            Http http2 = new Http();
            HTTPResponse response2 = http2.send(request2);
            system.debug('req-------- '+response2);
            status = response2.getStatusCode();
            responseFromGetService = String.valueOf(response2.getBody());
            system.debug('--responseFromGetService -->'+responseFromGetService);
            if(status == 200){
                system.debug('200-------- '+status);                
                
                //this method will deserialize the response and store it in the DunsFamilyHierarchyResponse object
                DunsFamilyHierarchyResponsemain obj = (DunsFamilyHierarchyResponsemain)JSON.deserializestrict(
                    responseFromGetService, DunsFamilyHierarchyResponsemain.class);
                system.debug('DunsFamilyHierarchyResponsemain'+obj.dunsFamilyHierarchyResponse);
                dunsList = obj.dunsFamilyHierarchyResponse.searchResults.duns; //stores the duns list
                system.debug('duns'+dunsList);
                fetchrecords();
            }
            
        }
        catch(exception e){
            system.debug('exception '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Our Servers are currently being upgraded. Please try again later.'));
            NoEntitlementRecord = true;
            NoRecordUnderAcc = true;
        }
        
        
        if(status!=200){
            system.debug('entered 400----------');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Please try again later.'));
            NoEntitlementRecord = true;
            NoRecordUnderAcc = true;
        }
    }

    
    //this method runs on page load, after constructor call and fetches data from ERDB and populates a map
    //the map stores the records returned against a particular duns or GU number
    public void fetchrecords(){
        if(status == 200){
            system.debug('fetch----------');
            try{
                
                    Date todaysdate = System.today();
                    Time defaultendtime = Time.newInstance(0, 0, 0, 0);
                    Time defaultstarttime = Time.newInstance(23,59,59,999);
                    Datetime enddt = Datetime.newInstance(todaysdate,defaultendtime);
                    Datetime startdt = Datetime.newInstance(todaysdate,defaultstarttime);
                    String enddtstring = String.valueOf(enddt);
                    String startdtstring = String.valueOf(startdt);
                    Datetime finaldt = datetime.valueOfGmt(enddtstring);
                    Datetime finalstartdt = datetime.valueOfGmt(startdtstring);
                
                if(!Test.isRunningTest()){
                    system.debug('==========gp===='+GPNumber);
   
                    //allDunDetailsBasedongp = [Select ca_site_id__c,duns__c,product_instance_id__c,instance_id__c,product_detail__c,name__c,entitlement_start_date__c,entitlement_end_date__c,quantity__c,edition__c,entitlement_type__c,software_type__c,metric__c from ProductInstanceView__x where dunsgp__c =:GPNumber and entitlement_start_date__c<=:System.today() and entitlement_end_date__c>=:System.today() and (status__c='active' OR status__c='Active') and product_instance_id__c!=null and quantity__c>:0 and duns__c!=null and duns__c!=' ' and fulfillment_status__c=:'fulfillment complete'];
                    allDunDetailsBasedongp = [Select ca_site_id__c,duns__c,product_instance_id__c,instance_id__c,product_detail__c,name__c,entitlement_start_date__c,entitlement_end_date__c,quantity__c,edition__c,entitlement_type__c,software_type__c,metric__c from ProductInstanceView__x where dunsgp__c =:GPNumber and entitlement_start_date__c<=:finalstartdt and entitlement_end_date__c>=:finaldt and (status__c='active' OR status__c='Active') and product_instance_id__c!=null and quantity__c>:0 and duns__c!=null and duns__c!=' ' and fulfillment_status__c=:'fulfillment complete'];

                    system.debug('found records...');
                    system.debug('allDunDetailsBasedongp = '+allDunDetailsBasedongp);
                   
                }
                else{
                    allDunDetailsBasedongp = dummyprodinstdata();
                    system.debug('did not find records...');
                }
                system.debug('entered fetchrecords');
                
                if(allDunDetailsBasedongp.size()>0){
                    
                    for(ProductInstanceView__x t:allDunDetailsBasedongp){
                        
                        if(t.metric__c=='max_ue_seats')
                            t.metric__c = 'FDE UE Seats';
                        if(t.metric__c=='paid_addon_seats')
                            t.metric__c = 'FDE Paid Addon seats';
                        if(t.metric__c == 'paid_standalone_seats')
                            t.metric__c = 'FDE Paid Standalone seats';
                        
                        if(dunsentitlementmap.get(t.duns__c)!=null){
                            system.debug('Populating map 2nd time'+t);
                            dunsentitlementmap.get(t.duns__c).add(t);
                        }
                        else{
                            List<ProductInstanceView__x> prodinstlist = new List<ProductInstanceView__x>();
                            prodinstlist.add(t);
                            system.debug('Populating map 1st time'+t);
                            dunsentitlementmap.put(t.duns__c,prodinstlist);
                        }
                       
                    }
                    refinetree();
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'There are no entitlements associated with any customer in this hierarchy.'));
                    NoEntitlementRecord = true;
                    NoRecordUnderAcc = true;
                    dunsList.clear();
                }
            }
            catch(exception e){
                ApexPages.addMessages(e);
                system.debug('entered exception'+e);
                //ApexPages.addMessages(e);
            }
        }
    }
    
    public void populatesearchmap(List<ProductInstanceView__x> dunsproductsearchlist){
        productSearchHelper.clear();
        for(ProductInstanceView__x t:dunsproductsearchlist){
            if(!productSearchHelper.containsKey(t.name__c)){
                productSearchHelper.put(t.name__c,new List<ProductInstanceView__x>{t});
            }
            else{
                productSearchHelper.get(t.name__c).add(t);
            }
        }
    }
    
    public void refinetree(){
        
        if(dunsList.size()>0){
            for(Duns temp:dunsList){
                if(!String.isBlank(temp.dunsnumber)){
                    DunsNoMap.put(temp.dunsnumber,temp);
                    if(dunsentitlementmap.containsKey(temp.dunsnumber)){
                        finaldunslist.add(temp);
                    }
                }
            }
        }
        system.debug('finaldunslist size'+finaldunslist.size() + finaldunslist);
        if(finaldunslist.size()>0){
            Duns d = new Duns();
            List<Duns> tempdunslist = new List<Duns>();
            for(Duns t:finaldunslist){
                if(t.globalultimatedunsnumber!=GPNumber){
                    if(DunsNoMap.containsKey(t.globalultimatedunsnumber)){
                        d = DunsNoMap.get(t.globalultimatedunsnumber);
                        tempdunslist.add(d);
                    }     
                } 
            }
            if(tempdunslist.size()>0)
                finaldunslist.addAll(tempdunslist);
        }
        system.debug('finaldunslist size second time'+finaldunslist.size() + finaldunslist);
        
        if(finaldunslist.size()>0){
            system.debug('entering tree population');
            populateHierarchy(finaldunslist); //populates the tree structure on the page
            DunsHierarcyList();
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'There are no entitlements associated with any customer in this hierarchy.'));
            NoEntitlementRecord = true;
            NoRecordUnderAcc = true;
            system.debug('clearing list');
            dunsList.clear();
        }
    }
    
    
    
    //this method populates the tree structure, takes the deserialized dunslist as parameter
    public void populateHierarchy(List<Duns> finalListduns){
        try{
        if(finalListduns.size()>0){
            for(Duns temp: finalListduns){
                //if map has value against the given key, add it to the list
                if(temp.globalultimatedunsnumber!=GPNumber){
                    if(temp.dunsnumber!=GPNumber){
                        
                        if(GUDunsList.get(temp.globalultimatedunsnumber) != null){ 
                            GUDunsList.get(temp.globalultimatedunsnumber).add(temp); 
                            system.debug('globalultimatedunsnumber number'+ temp.globalultimatedunsnumber);
                        }
                        //else, create a new key value pair
                        else{
                            List<Duns> childDunsList = new List<Duns>();
                            childDunsList.add(temp);
                            GUDunsList.put(temp.globalultimatedunsnumber,childDunsList);     
                        }
                        
                    }
                }
                else if(temp.globalultimatedunsnumber==GPNumber){
                    //if(temp.dunsnumber!=GPNumber){
                        if(GUDunsList.get(temp.dunsnumber) != null){ 
                            GUDunsList.get(temp.dunsnumber).add(temp); 
                            system.debug('duns number'+ temp.dunsnumber);
                        }
                        //else, create a new key value pair
                        else{
                            List<Duns> childDunsList = new List<Duns>();
                            childDunsList.add(temp);
                            GUDunsList.put(temp.dunsnumber,childDunsList);     
                        }
                    //}
                }
            }
        }
        }
        catch(exception e){
            system.debug('exception '+e);
        }
    }
    //this method pupulates the unique parent-child tree from the initial map prepared
    //in the above method, populateHierarchy
    public void DunsHierarcyList(){
        //if map size is greater than zero
        try{
        if(GUDunsList.size()>0){
            
            GUDunsNumberClass tempgudunsno;
            //iterate through the map keyset
            for(String s:GUDunsList.keySet()){
                system.debug('s: '+s);
                List<Duns> dunschildren = new List<Duns>(); //to store the duns value list against the key
                List <Duns> listofuniquedunschild = new List<Duns>(); //to store the child duns and put it in the map
                List <String> uniquechildlist = new List<String>();
                dunschildren = GUDunsList.get(s);
                system.debug('dunschildren: '+dunschildren);
                if(s!=null&&s!=''){ //if there is a parent(gu) associated against the child, store values in the GUDunsNumberClass object
                    tempgudunsno = new GUDunsNumberClass();
                    if(dunschildren.size()>0){
                        system.debug('Entered children');    
                        if(dunschildren.size()==1&&s==dunschildren[0].dunsnumber){ //if there is only 1 child and it is the same as gu number,put empty list as value
                            system.debug('GU is same as DU');
                            //empty child list
                            
                            for(Duns t:finaldunslist){
                                if(s==t.dunsnumber){
                                    tempgudunsno.gudunsno = s;
                                    tempgudunsno.state = dunschildren[0].physiclstate;
                                    tempgudunsno.country = dunschildren[0].countryname;
                                    tempgudunsno.gubusinessname = dunschildren[0].businessname;
                                    tempgudunsno.dunsno = dunschildren[0].dunsnumber;
                                    break;
                                }
                                else if(s==t.globalultimatedunsnumber){
                                    tempgudunsno.gudunsno = s;
                                    tempgudunsno.state = dunschildren[0].physiclstate;
                                    tempgudunsno.country = dunschildren[0].countryname;
                                    tempgudunsno.gubusinessname = dunschildren[0].globalultimatebusinessname;
                                    tempgudunsno.dunsno = dunschildren[0].dunsnumber;
                                    break;
                                }
                            }
                            
                            
                            DunsTree.put(tempgudunsno,new List<Duns>());
                            parentchildlist.put(s,new List<String>()); //no child
                        }
                        else{ //if more than one child, add those child as values, that are different from parent
                            system.debug('More than 1 child or child and parent are different');
                            for(Duns uniquechild:dunschildren){
                                if(uniquechild.dunsnumber==uniquechild.globalultimatedunsnumber){
                                    tempgudunsno.gudunsno = s;
                                    tempgudunsno.state = uniquechild.physiclstate;
                                    tempgudunsno.country = uniquechild.countryname;
                                    tempgudunsno.gubusinessname = uniquechild.globalultimatebusinessname;
                                    tempgudunsno.dunsno = uniquechild.dunsnumber;
                                    break;
                                }
                            }
                            for(Duns uniquechild:dunschildren){
                                system.debug('uniquechild dunschild'+uniquechild.dunsnumber);
                                if(uniquechild.dunsnumber!=s){
                                    system.debug('GU different');
                                    listofuniquedunschild.add(uniquechild);
                                    uniquechildlist.add(uniquechild.dunsnumber);
                                }
                            }
                            system.debug('listofuniquedunschild'+listofuniquedunschild);
                            DunsTree.put(tempgudunsno,listofuniquedunschild);
                            parentchildlist.put(s,uniquechildlist); //has children
                        }
                    }
                    else{ //if no child
                        //empty child list
                        DunsTree.put(tempgudunsno,new List<Duns>());
                        parentchildlist.put(s,new List<String>()); //no child
                    }
                }
                else //if parent is null, then children become the parent and report directly to GP
                {
                    for(Duns childdun:dunschildren){
                        //empty child list
                        tempgudunsno = new GUDunsNumberClass();
                        tempgudunsno.gudunsno = childdun.dunsnumber;
                        tempgudunsno.state = childdun.physiclstate;
                        tempgudunsno.country = childdun.countryname;
                        tempgudunsno.gubusinessname = childdun.businessname;
                        tempgudunsno.dunsno = childdun.dunsnumber;
                        DunsTree.put(tempgudunsno,new List<Duns>());
                        parentchildlist.put(childdun.dunsnumber,new List<String>());
                    }
                }
            }
        }
       
        //populate renderchildornot with the child list size
        for(GUDunsNumberClass key : DunsTree.keySet()){
            renderchildornot.put(key, DunsTree.get(key).size()); //using this map we display the + sign on the UI
        }
        
        //DunsTree Map is the value against the GP Number
        dunsHierarchyTree.put(GPName,DunsTree);
        
        //See if GP Number has child or not.
        for(String s: dunsHierarchyTree.keySet()){
            renderGUchildornot.put(s,dunsHierarchyTree.get(s).size()); //using this map we display the + sign on the UI
        }
        system.debug('264+ ' +parentchildlist);
        }
        catch(exception e){
            system.debug('exception '+e);
        }
        finally{
            GUDunsList.clear();
            dunslist.clear();
            finaldunslist.clear();
            DunsNoMap.clear();
        }
        
        
    }
     
    
    //on click of tree structure on UI, this method returns the appropriate records
    public void fetchDetails(){
        accNameToUsage = ApexPages.currentPage().getParameters().get('accNameToUsage');
        ApexPages.getMessages().clear();
        valToSearch = '';
        solutionexists = false;
        NoEntitlementRecord = false;
        system.debug('dunsnofrompage'+dunsnofrompage);
        system.debug('dunstype'+type);
        dunsdetailstodisplay = new List<ProductInstanceView__x>();
        if(type=='duns')
        {
            fetchdunsdetails();
        }
        else if(type=='gu'){
            fetchgudetails();
        }
        else{
            fetchgpdetails();
        }
    }
    
    
    //this method fetches the records against the duns number from the map and populates the list to display on page
    public void fetchdunsdetails(){
        
        doesgpdetailexist = false;
        List<ProductInstanceView__x> temp,aggregatedlist;
        try{
            temp = dunsentitlementmap.get(dunsnofrompage);
            aggregatedlist = aggregateinstdata(temp);
            populatesearchmap(temp);
            dunsdetailstodisplay.clear();
            dunsdetailstodisplay.addall(aggregatedlist);
        }
        catch(exception e)
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'There are no entitlements associated with the selected customer.'));
        }
        
        if(dunsdetailstodisplay.size()>0){
            solutionexists = true;
            NoEntitlementRecord =  false;
        }
        else{
            solutionexists = false;
            NoEntitlementRecord =  true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'There are no entitlements associated with the selected customer.'));
        }
    }
    
    //this method fetches the children against the GU number from the map,
    //and then fetches records for each child and populates the list to display on page
    public void fetchgudetails(){
        doesgpdetailexist = false;
        system.debug('entered gu details');
        List <String> listofdunsundergu = new List<String>();
        List<ProductInstanceView__x> listtoaggregate = new List<ProductInstanceView__x>();
        List<ProductInstanceView__x> aggregatedlist;
        if(allDunDetailsBasedongp.size()>0)
        {
            system.debug('has data');
            if(type=='gu'){
                system.debug('entered gu');
                if(parentchildlist.containsKey(dunsnofrompage))
                    listofdunsundergu =  parentchildlist.get(dunsnofrompage);
                if(listofdunsundergu.size()>0){
                    system.debug('has child?');
                    for(String temp:listofdunsundergu){
                        if(dunsentitlementmap.containsKey(temp)){
                            system.debug('child contains data?');
                            listtoaggregate.addall(dunsentitlementmap.get(temp));
                        }
                    }
                    //adding gu if gu contains data
                    if(dunsentitlementmap.containsKey(dunsnofrompage))
                        listtoaggregate.addall(dunsentitlementmap.get(dunsnofrompage));
                    
                    system.debug('list size---------------'+listtoaggregate.size());
                    if(listtoaggregate.size()>0){
                        aggregatedlist = aggregateinstdata(listtoaggregate);
                        dunsdetailstodisplay.addAll(aggregatedlist);
                        populatesearchmap(listtoaggregate);
                    }
                    
                    
                    if(dunsdetailstodisplay.size()>0){
                        solutionexists = true;
                        NoEntitlementRecord =  false;
                    }
                    else{
                        solutionexists = false;
                        NoEntitlementRecord =  true;
                    }
                }
                else{
                    
                    if(dunsentitlementmap.containsKey(dunsnofrompage)){
                            listtoaggregate.addall(dunsentitlementmap.get(dunsnofrompage));
                    }
                    system.debug('size------------'+listtoaggregate.size());
                    if(listtoaggregate.size()>0){
                        aggregatedlist = aggregateinstdata(listtoaggregate);
                        dunsdetailstodisplay.addAll(aggregatedlist);
                        populatesearchmap(listtoaggregate);
                    }
                    
                    if(dunsdetailstodisplay.size()>0){
                        solutionexists = true;
                        NoEntitlementRecord =  false;
                    }
                    else{
                        solutionexists = false;
                        NoEntitlementRecord =  true;
                    }
                }
  
            }

        }
        else{
            solutionexists = false;
            NoEntitlementRecord =  true;
        }           
    }
    
    public void fetchgpdetails(){
        Double isp=0;
        gpdetail.totalpaid = 0;
        gpdetail.totalunpaid = 0;
        gpdetail.totalseats = 0;
        if(allDunDetailsBasedongp.size()>0)
        {
            acclist = [select isp__c from account where GU_Duns_Number__c =:GPNumber];
            for(Account a:acclist){
                if(a.isp__c!=null)
                    isp+=a.isp__c;
            }
            if(type=='gp'){
                for(ProductInstanceView__x t:allDunDetailsBasedongp){
                    if(t.edition__c=='UE'||t.edition__c=='EE'){
                        if(t.quantity__c!=null){
                            gpdetail.totalseats += Integer.valueof(t.quantity__c);
                            if(t.metric__c=='PaidSeats'){
                                gpdetail.totalpaid += Integer.valueof(t.quantity__c);
                            }
                            else if(t.metric__c=='UnpaidSeats'){
                                gpdetail.totalunpaid += Integer.valueof(t.quantity__c);
                            }
                        }
                    }
                }
                if(isp!=null)
                    gpdetail.ispvalue = isp;
                doesgpdetailexist = true;
            }
        }
        else{
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'There are no entitlements associated with the selected customer.'));
            NoEntitlementRecord = true;
        }
    }
    
    //search functionality
    public void fetchdunsdetailsonSearch(){
        List<ProductInstanceView__x> listtoaggregate = new List<ProductInstanceView__x>();
        List<ProductInstanceView__x> aggregatedlist;
        ApexPages.getMessages().clear();
        if( String.isBlank(valToSearch)){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Please enter 2 or more characters to search.')); 
        }
        else {
            dunsdetailstodisplay.clear();
            for(String eachProdName : productSearchHelper.keySet()){
                if(String.isNotBlank(valToSearch) && eachProdName.containsIgnoreCase(valToSearch)){
                    listtoaggregate.addAll(productSearchHelper.get(eachProdName));
                }
            }
            if(listtoaggregate.size()>0){
                aggregatedlist = aggregateinstdata(listtoaggregate);
                dunsdetailstodisplay.addAll(aggregatedlist);
            }
        }
    }
    
    //method to update ISP, redirects to isp record page on a new tab
    public PageReference updateisp(){
        List<Site_ISP_Junction__c> ispid = new List<Site_ISP_Junction__c>();
        system.debug('ISP Number: '+ispnumber);
        if(String.isNotBlank(ispnumber))
            ispnumber = String.valueOf(Integer.valueOf(ispnumber));
        system.debug('ISP Number: '+ispnumber);
        try{
            string s = String.valueof(URL.getSalesforceBaseUrl());
            s = s.substringBetween('=',']');
            system.debug('s '+s);
            ispid = [select id from Site_ISP_Junction__c where SAP_Site_ID__c=:ispnumber limit 1];
            if(ispid.size()>0){
                PageReference pf = new PageReference(s+'/'+ispid[0].id);
                pf.setRedirect(true);
                system.debug('page ref '+pf);
                return pf;
            }
            else{
                PageReference pf2 = new PageReference(s+'/apex/NoSiteISPRecord');
                pf2.setRedirect(true);
                system.debug('page ref '+pf2);
                return pf2;
            }
        }
        catch(exception e){
            system.debug('entered exception');
            return null;
        }
        
    }
    
    //method to help redirection for Back Button
    public pageReference redirectHelper(){
        
        Map<String,String> pageparams = ApexPages.currentPage().getParameters();
        
        if( pageParams.containsKey('oppId')){
            return new PageReference('/'+pageParams.get('oppId'));
        }
        else {
            return new PageReference('/'+pageParams.get('accId'));
        }
    }
    
    
    public List<ProductInstanceView__x> aggregateinstdata(List<ProductInstanceView__x> temp){
        Map<String,List<ProductInstanceView__x>> instancerelatedlist = new Map<String,List<ProductInstanceView__x>>();
        List<ProductInstanceView__x> aggregatedlist = new List<ProductInstanceView__x>();
        String uniquekey;
        system.debug('temp size-------------'+temp.size());
        for(ProductInstanceView__x p: temp){
            
                uniquekey = p.product_instance_id__c + p.name__c + p.metric__c;
            system.debug('unique key----------'+uniquekey);
                if(instancerelatedlist.get(uniquekey) != null){
                    instancerelatedlist.get(uniquekey).add(p); 
                    system.debug('record '+ p);
                }
                //else, create a new key value pair
                else{
                    List<ProductInstanceView__x> instlist = new List<ProductInstanceView__x>();
                    instlist.add(p);
                    instancerelatedlist.put(uniquekey,instlist);
                    system.debug('record 2 '+ p);
                } 
        }
        if(instancerelatedlist.size()>0){
            List<ProductInstanceView__x> listtoaggregate = new List<ProductInstanceView__x>();
            
            for(String s:instancerelatedlist.keyset()){
                ProductInstanceView__x prod = new ProductInstanceView__x();
                listtoaggregate.clear();
                listtoaggregate = instancerelatedlist.get(s);
                for(ProductInstanceView__x p:listtoaggregate){
                    if(prod.instance_id__c==null){
                        system.debug('entered prod detail');
                        prod.ca_site_id__c = p.ca_site_id__c;
                        prod.duns__c = p.duns__c;
                        prod.product_instance_id__c = p.product_instance_id__c;
                        prod.instance_id__c = p.instance_id__c;
                        prod.product_detail__c = p.product_detail__c;
                        prod.name__c = p.name__c;
                        prod.entitlement_start_date__c = p.entitlement_start_date__c;
                        prod.entitlement_end_date__c = p.entitlement_end_date__c;
                        if(p.quantity__c!=null)
                            prod.quantity__c = p.quantity__c;
                        prod.edition__c = p.edition__c;
                        prod.entitlement_type__c = p.entitlement_type__c;
                        prod.software_type__c = p.software_type__c;
                        prod.metric__c = p.metric__c;
                        system.debug('entered a value');
                    }
                    else{
                        if(p.quantity__c!=null){
                            if(prod.quantity__c!=null)
                                prod.quantity__c += p.quantity__c;
                            else
                                prod.quantity__c = p.quantity__c;
                        }
                            
                        if(p.entitlement_start_date__c<=prod.entitlement_start_date__c)
                            prod.entitlement_start_date__c = p.entitlement_start_date__c;
                        if(p.entitlement_end_date__c>=prod.entitlement_end_date__c)
                            prod.entitlement_end_date__c = p.entitlement_end_date__c;
                    }
                }
                if(prod.instance_id__c!=null&&prod.instance_id__c!='')
                    aggregatedlist.add(prod);
            }
        }
        return aggregatedlist;
    }
    
    public List<ProductInstanceView__x> dummyprodinstdata(){
        List<ProductInstanceView__x> dummylist = new List<ProductInstanceView__x>();
        ProductInstanceView__x t1 = new ProductInstanceView__x();
        t1.ca_site_id__c = '123456789';
        t1.duns__c = '060321254';
        t1.product_instance_id__c = '5524';
        t1.instance_id__c = 'I0040163916000025nXhdvogy7kQKpO{sxB1NI0';
        t1.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t1.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        string year = '2008';
        string month = '10';
        string year2 = '2009';
        string day = '5';
        string hour = '12';
        string minute = '20';
        string second = '20';
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        string stringDate2 = year2 + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        t1.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t1.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t1.quantity__c = 10;
        t1.edition__c = 'UE';
        t1.entitlement_type__c = 'Paid';
        t1.software_type__c = 'Hosted';
        t1.metric__c = 'max_ue_seats';
        dummylist.add(t1);
        ProductInstanceView__x t2 = new ProductInstanceView__x();
        t2.ca_site_id__c = '123456789';
        t2.duns__c = '060321254';
        t2.product_instance_id__c = '5524';
        t2.instance_id__c = 'I0040163916000025nXhdvogy7kQKpO{sxB1NI0';
        t2.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t2.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t2.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t2.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t2.quantity__c = 15;
        t2.edition__c = 'UE';
        t2.entitlement_type__c = 'Paid';
        t2.software_type__c = 'Hosted';
        t2.metric__c = 'paid_addon_seats';
        dummylist.add(t2);
        ProductInstanceView__x t3 = new ProductInstanceView__x();
        t3.ca_site_id__c = '0000007994';
        t3.duns__c = '980455968';
        t3.product_instance_id__c = '5525';
        t3.instance_id__c = 'I0040163916000025nXhdvogy7kQKpO{sxB1NI2';
        t3.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t3.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t3.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t3.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t3.quantity__c = 15;
        t3.edition__c = 'UE';
        t3.entitlement_type__c = 'Paid';
        t3.software_type__c = 'Hosted';
        dummylist.add(t3);
        
        
        ProductInstanceView__x t4 = new ProductInstanceView__x();
        t4.ca_site_id__c = '0000007995';
        t4.duns__c = '189699317';
        t4.product_instance_id__c = '5525';
        t4.instance_id__c = 'I0040163916000025nXhdvogy7kQKpO{sxB1NI1';
        t4.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t4.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t4.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t4.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t4.quantity__c = 15;
        t4.edition__c = 'UE';
        t4.entitlement_type__c = 'Paid';
        t4.software_type__c = 'Hosted';
        dummylist.add(t4);
        
        ProductInstanceView__x t5 = new ProductInstanceView__x();
        t5.ca_site_id__c = '0000007996';
        t5.duns__c = '189699317';
        t5.product_instance_id__c = '5525';
        t5.instance_id__c = 'I0040163916000025nXhdvogy7kQKpO{sxB1NI1';
        t5.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t5.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t5.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t5.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t5.quantity__c = 15;
        t5.edition__c = 'UE';
        t5.entitlement_type__c = 'UnPaid';
        t5.software_type__c = 'Hosted';
        dummylist.add(t5);
        
        ProductInstanceView__x t6 = new ProductInstanceView__x();
        t6.ca_site_id__c = '0000007916';
        t6.duns__c = '791312069';
        t6.product_instance_id__c = '5525';
        t6.instance_id__c = 'I0040163916000025nXhdvogy7kQKpO{sxB1NI2';
        t6.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t6.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t6.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t6.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t6.quantity__c = 15;
        t6.edition__c = 'UE';
        t6.entitlement_type__c = 'Paid';
        t6.software_type__c = 'Hosted';
        dummylist.add(t6);
        
        return dummylist;
        
    }
    */
}