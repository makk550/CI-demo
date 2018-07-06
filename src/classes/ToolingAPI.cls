public class ToolingAPI {

    private ToolingAPIWSDL.SforceService service;
    private static final String endpointSuffix = '/services/Soap/T/32.0';

    /**
     * Uses the current users Session Id, only compatible in a interactive context
     * @throws ToolingAPIException if no Session Id can be resolved (e.g. in a batch context)
     **/
    public ToolingAPI() {
        this(UserInfo.getSessionId(),URL.getSalesforceBaseUrl().toExternalForm());
    }

    /**
     * Uses the given Session Id, useful when using the API in a batch context
     **/
    public ToolingAPI(String sessionId,String endpoint) {
         if(sessionId==null)
            throw new ToolingAPIException('Unable to obtain Session Id');

        service = new ToolingAPIWSDL.SforceService();
        service.SessionHeader = new ToolingAPIWSDL.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        service.endpoint_x = endpoint + endpointSuffix;
    }
    
    /**
    public ToolingAPIWSDL.QueryResult queryMore(String queryLocator,String recordClassName){
        return castQueryResultToSubclass(service.queryMore(queryLocator),recordClassName);
    }
    
    
    public ToolingAPIWSDL.SearchResult search(String searchString){
        return search(searchString,null);
    }
    **/
    
    public ToolingAPIWSDL.QueryResult query(String queryString) {
        return castQueryResultToSubclass(service.query(queryString),null);
    }

   
    public ToolingAPIWSDL.QueryResult query(String queryString,String recordClassName) {
        ToolingAPIWSDL.QueryResult qr = service.query(queryString);
        return castQueryResultToSubclass(qr,recordClassName);
    }
    
     /**
    public ToolingAPIWSDL.SearchResult search(String searchString,String recordClassName){
        ToolingAPIWSDL.SearchResult result = service.search_x(searchString);
        if(!String.isEmpty(recordClassName)){
            for(ToolingAPIWSDL.SearchRecord record : result.searchRecords){
                record.record = castSobjToSubclass(record.record,recordClassName);
            }
        }
        return result;
    }

    public ToolingAPIWSDL.DescribeSObjectResult describeSObject(String type_x){
        return service.describeSObject(type_x);
    }

    public ToolingAPIWSDL.DeleteResult[] deleteByIds(String[] ids) {
        return service.delete_x(ids);
    }

    public ToolingAPIWSDL.SaveResult[] updatesObjects(ToolingAPIWSDL.sObject_x[] sObjects) {
        return service.update_x(sObjects);
    }

    public ToolingAPIWSDL.UpsertResult[] upsert_x(String fieldName,ToolingAPIWSDL.sObject_x[] sObjects) {
        return service.upsert_x(fieldName,sObjects);
    }

    public ToolingAPIWSDL.ExecuteAnonymousResult executeAnonymous(String String_x) {
        return service.executeAnonymous(String_x);
    }

    public ToolingAPIWSDL.GetUpdatedResult getUpdated(String sObjectType,DateTime start,DateTime end_x) {
        return service.getUpdated(sObjectType,start,end_x);
    }

    public ToolingAPIWSDL.DescribeSObjectResult[] describeSObjects(String[] types) {
        return service.describeSObjects(types);
    }

    public ToolingAPIWSDL.QueryResult queryAll(String queryString) {
        return castQueryResultToSubclass(service.queryAll(queryString),null);
    }

    public ToolingAPIWSDL.QueryResult queryAll(String queryString,String recordClassName) {
        return castQueryResultToSubclass(service.queryAll(queryString),recordClassName);
    }

    public ToolingAPIWSDL.sObject_x[] retrieve(String select_x,String type_x,String[] ids) {
        return castSobjectArrToSubclass(service.retrieve_x(select_x,type_x,ids),null);
    }

    public ToolingAPIWSDL.sObject_x[] retrieve(String select_x,String type_x,String[] ids,String recordClassName) {
        return castSobjectArrToSubclass(service.retrieve_x(select_x,type_x,ids),recordClassName);
    }

    public ToolingAPIWSDL.DescribeGlobalResult describeGlobal() {
        return service.describeGlobal();
    }

    public ToolingAPIWSDL.DescribeValueTypeResult describeValueType(String type_x){
        return service.describeValueType(type_x);
    }

    public ToolingAPIWSDL.RunTestsResult runTests(ToolingAPIWSDL.RunTestsRequest RunTestsRequest) {
        return service.runTests(RunTestsRequest);
    }

    public ToolingAPIWSDL.GetDeletedResult getDeleted(String sObjectType,DateTime start,DateTime end_x) {
        return service.getDeleted(sObjectType,start,end_x);
    }

    public ToolingAPIWSDL.InvalidateSessionsResult[] invalidateSessions(String[] ArrayList) {
        return service.invalidateSessions(ArrayList);
    }

    public String runTestsAsynchronous(String String_x) {
        return service.runTestsAsynchronous(String_x);
    }

    public ToolingAPIWSDL.SaveResult[] create(ToolingAPIWSDL.sObject_x[] sObjects) {
        return service.create(sObjects);
    }

    public ToolingAPIWSDL.GetServerTimestampResult getServerTimestamp() {
        return service.getServerTimestamp();
    }

    public ToolingAPIWSDL.DescribeWorkitemActionResult[] describeWorkitemActions(String[] workitemIds) {
        return service.describeWorkitemActions(workitemIds);
    }

    public ToolingAPIWSDL.GetUserInfoResult getUserInfo(){
        return service.getUserInfo();
    }
    
    **/
    
    private ToolingAPIWSDL.QueryResult castQueryResultToSubclass(ToolingAPIWSDL.QueryResult queryResult, String recordClassName){
        if(!String.isEmpty(recordClassName)){
            queryResult.records = castSobjectArrToSubclass(queryResult.records,recordClassName);
        }
        return queryResult;
    }
    
    
    
    private ToolingAPIWSDL.sObject_x [] castSobjectArrToSubclass(List<ToolingAPIWSDL.sObject_x> sobjArr,String recordClassName){
        List<ToolingAPIWSDL.sObject_x> records = (List<ToolingAPIWSDL.sobject_x>)Type.forName('List<'+recordClassName+'>').newInstance();
        for(Integer i=0; i < sobjArr.size(); i++){
            records.add(castSobjToSubclass(sObjArr.get(i),recordClassName));
            sObjArr.remove(i);
        }
        return records;
    }
    
    
    
    public class ToolingAPIException extends Exception{}
    
    private ToolingAPIWSDL.sObject_x castSobjToSubclass(ToolingAPIWSDL.sObject_x sobj,String recordClassName){
        return (ToolingAPIWSDL.sObject_x)Json.deserialize(JSON.serialize(sobj),Type.forName(recordClassName));
    }
        

   
}