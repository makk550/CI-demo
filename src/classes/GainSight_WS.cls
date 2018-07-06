@RestResource(urlMapping='/GainSight')
global with sharing class GainSight_WS {
    
    global static Integer statusCde;
    global static String status;
    global static Integer requestCount;
    global static Boolean isValidationError;
        
    static{
        requestCount = 0;
        statusCde = 200;
        status = 'OK';
        isValidationError = false;
    }
    
    global class StatusMessage {
        public Integer totalRequestsReceieved;
        public boolean isTotalSuccessAchieved;
        public string  errorMessage;
        public Integer statusCode;
        public String  statusMessage;
        public Boolean isPartialSuccess;
        
        public StatusMessage(Integer count, string err) {
            this.totalRequestsReceieved = count;
            this.errorMessage  = err;
        }
    }

    
    
    @HttpPost
    global static StatusMessage createGainSightRecords(){
        
        RestRequest request = RestContext.request;
        String jsonInput = request.requestBody.toString();
        
        Map<Id,JBCXM__CustomerInfo__c> customerInfoFromDB = new Map<Id,JBCXM__CustomerInfo__c>();
        Map<Id,JBCXM__CustomerInstances__c> customerInstFromDB = new Map<Id,JBCXM__CustomerInstances__c>();
        Map<String,JBCXM__GSLRMHeader__c> lrmHeaderFromDB = new Map<String,JBCXM__GSLRMHeader__c>();
        
        List<JBCXM__PickList__c> pickListFromDB;
        
        Id customerInfoRecId,customerInstRecId,lrmHeaderRecId,lrmLineItmRecId;
        String message;
        Boolean successresult = true;
        Boolean isPartialSuccess = false;
        String errormsg = '';
        Boolean isExceptionOccured = false;
        StatusMessage statmsg;
         
        JBCXM__CustomerInfo__c customerInfoRec;
        JBCXM__CustomerInstances__c customerInstanceRec;
        JBCXM__GSLRMHeader__c lrmHeaderRec;  
        JBCXM__GSLRMLines__c lrmLineRec;
            
        List<GainSightWrapper> wrapperInstances;
        
        try{
            verifyJSONRequest(jsonInput);
            
            wrapperInstances = (List<GainSightWrapper>)JSON.deserialize(jsonInput, List<GainSightWrapper>.class);

             Set<Id> accountIds = new Set<Id>();
             Set<String> prodInstIds = new Set<String>();
            
            for(GainSightWrapper instance : wrapperInstances){
                accountIds.add(instance.sfdc_account_id);
                prodInstIds.add(instance.product_instance_id);
            }
            
            if( accountIds.size() > 0){
                
                for(JBCXM__CustomerInfo__c eachInfo :[Select Id,JBCXM__Account__c from JBCXM__CustomerInfo__c WHERE JBCXM__Account__c IN :accountIds]){
                    customerInfoFromDB.put(eachInfo.JBCXM__Account__c,eachInfo);
                }
                
                for(JBCXM__GSLRMHeader__c eachHeader : [Select Id,JBCXM__Account__c,Trial_Instance_ID__c from JBCXM__GSLRMHeader__c WHERE JBCXM__Account__c IN:accountIds 
                                                        and Trial_Instance_ID__c IN:prodInstIds]){
                    lrmHeaderFromDB.put(eachHeader.JBCXM__Account__c+'-'+eachHeader.Trial_Instance_ID__c,eachHeader);
                }
                
                pickListFromDB = [Select Id from JBCXM__PickList__c WHERE (Name =:'Active' OR Name =:'ACTIVE') LIMIT 1];
                
                List<JBCXM__CustomerInfo__c> customerInfoToInsert = new List<JBCXM__CustomerInfo__c>();
                List<JBCXM__GSLRMHeader__c> lrmHeaderToInsert = new List<JBCXM__GSLRMHeader__c>();
                
                for(GainSightWrapper instance : wrapperInstances){
                    
                    if( !customerInfoFromDB.containsKey(instance.sfdc_account_id)){
                        
                        customerInfoRec = new JBCXM__CustomerInfo__c();
                        customerInfoRec.JBCXM__Account__c = instance.sfdc_account_id;
                        
                        if(pickListFromDB.size() > 0){
                            customerInfoRec.JBCXM__Status__c = pickListFromDB[0].Id;
                        }
                        
                        customerInfoToInsert.add(customerInfoRec);
                    }
                    
                    if( !lrmHeaderFromDB.containsKey(instance.sfdc_account_id+'-'+instance.product_instance_id) 
                            && (instance.entitlement_type.equalsIgnoreCase('trial') || instance.entitlement_type.equalsIgnoreCase('freemium'))){
                        
                        lrmHeaderRec = new JBCXM__GSLRMHeader__c();
                        lrmHeaderRec.JBCXM__Account__c = instance.sfdc_account_id;
                        lrmHeaderRec.JBCXM__ExternalSourceId__c = instance.product_instance_id + '~' + instance.email;
                        lrmHeaderRec.Trial_Instance_Id__c = instance.product_instance_id;
                        lrmHeaderRec.Email__c = instance.email;
                        lrmHeaderRec.Trial_Start_Date__c = instance.entitlement_start_date.date();
                        lrmHeaderRec.Trial_End_Date__c = instance.entitlement_end_date.date();
                        lrmHeaderRec.JBCXM__SubscriptionStartDate__c = instance.entitlement_start_date.date();
                        lrmHeaderRec.JBCXM__SubscriptionEndDate__c = instance.entitlement_end_date.date();
                        lrmHeaderRec.CA_Contract_Start_Date__c = instance.entitlement_start_date.date();
                        lrmHeaderRec.CA_Contract_End_Date__c = instance.entitlement_end_date.date(); 
                        
                        lrmHeaderToInsert.add(lrmHeaderRec);
                    }
                }
                
                if( customerInfoToInsert.size() > 0){
                    Database.SaveResult[] saveresCust = Database.Insert(customerInfoToInsert,false);
                    Integer successCount = 0,errorCount = 0;
                    for(Database.SaveResult sr: saveresCust){
                        if(!sr.isSuccess()){
                            errorCount++;
                            for(Database.Error err : sr.getErrors()) {
                                errormsg +=err.getMessage() +'\n';
                            } 
                        }
                        else{
                            successCount++;
                        }
                    }
                    if( errorCount == 0){
                        successresult = true;
                    }
                    else if(successCount > 0 && errorCount > 0){
                        successresult = false;
                        isPartialSuccess = true;
                    }
                    else if( successCount == 0 && errorCount > 0){
                        successresult = false;
                    }
                }
                
                if( lrmHeaderToInsert.size() > 0){
                    Database.SaveResult[] saveresCust = Database.Insert(lrmHeaderToInsert,false);
                    Integer successCount = 0,errorCount = 0;
                    for(Database.SaveResult sr: saveresCust){
                        if(!sr.isSuccess()){
                            errorCount++;
                            for(Database.Error err : sr.getErrors()) {
                                errormsg +=err.getMessage() +'\n';
                            } 
                        }
                        else{
                            successCount++;
                        }
                    }
                    
                    
                    if( errorCount == 0 && successCount > 0){
                        if(successresult){
                            successresult = true;
                        }
                        if(isPartialSuccess){
                            isPartialSuccess = true;        
                        }
                    }
                    else if(successCount > 0 && errorCount > 0){
                        successresult = false;
                        isPartialSuccess = true;
                    }
                    else if( successCount == 0 && errorCount > 0){
                        successresult = false;
                    }
                    
                }
                
                customerInfoFromDB.clear();
                lrmHeaderFromDB.clear();
                
                for(JBCXM__CustomerInfo__c eachInfo :[Select Id,JBCXM__Account__c from JBCXM__CustomerInfo__c WHERE JBCXM__Account__c IN :accountIds]){
                    customerInfoFromDB.put(eachInfo.JBCXM__Account__c,eachInfo);
                }
                for(JBCXM__CustomerInstances__c eachInst : [Select Id,JBCXM__Account__c from JBCXM__CustomerInstances__c WHERE JBCXM__Account__c IN:accountIds]){
                    customerInstFromDB.put(eachInst.JBCXM__Account__c,eachInst);
                }
                for(JBCXM__GSLRMHeader__c eachHeader : [Select Id,(Select Id from JBCXM__GSLRMLines__r),JBCXM__Account__c,Trial_Instance_ID__c,
                                                        Trial_Start_Date__c,Trial_End_Date__c from JBCXM__GSLRMHeader__c WHERE 
                                                        JBCXM__Account__c IN:accountIds and Trial_Instance_ID__c IN:prodInstIds]){
                    lrmHeaderFromDB.put(eachHeader.JBCXM__Account__c+'-'+eachHeader.Trial_Instance_ID__c,eachHeader);
                }
                
                List<JBCXM__CustomerInstances__c> customerInstToInsert = new List<JBCXM__CustomerInstances__c>();
                List<JBCXM__GSLRMLines__c> lrmHeaderLinesToInsert = new List<JBCXM__GSLRMLines__c>();
                
                for(GainSightWrapper instance : wrapperInstances){
                    
                    if( !customerInstFromDB.containsKey(instance.sfdc_account_id)){
                        
                        customerInstanceRec = new JBCXM__CustomerInstances__c();
                        customerInstanceRec.JBCXM__Account__c = instance.sfdc_account_id;
                        
                        if( customerInfoFromDB.get(instance.sfdc_account_id) != null){
                            customerInstanceRec.JBCXM__CustomerInfo__c = customerInfoFromDB.get(instance.sfdc_account_id).id;
                        }
                        
                        customerInstanceRec.JBCXM__InstanceName__c = instance.instance_id;
                        customerInstanceRec.Name = instance.product_instance_id;
                        
                        customerInstToInsert.add(customerInstanceRec);
                    }
                    
                    if( lrmHeaderFromDB.containsKey(instance.sfdc_account_id+'-'+instance.product_instance_id) 
                            && (instance.entitlement_type.equalsIgnoreCase('trial') || instance.entitlement_type.equalsIgnoreCase('freemium'))){
                        
                        JBCXM__GSLRMHeader__c temp = lrmHeaderFromDB.get(instance.sfdc_account_id+'-'+instance.product_instance_id);
                        
                        if( temp.JBCXM__GSLRMLines__r.size() ==0){
                            
                            lrmLineRec = new JBCXM__GSLRMLines__c();
                            lrmLineRec.JBCXM__HeaderSourceId__c = temp.id;
                            lrmLineRec.JBCXM__LRMHeader__c = temp.id;
                            lrmLineRec.JBCXM__ExternalSourceId__c = instance.product_instance_id + '~' + instance.email;
                            lrmLineRec.Instance_ID__c = instance.product_instance_id;
                            lrmLineRec.Email__c = instance.email;
                            lrmLineRec.Product_Id__c = instance.material_id;
                            lrmLineRec.Trial_Start_Date__c = temp.Trial_Start_Date__c;
                            lrmLineRec.Trial_End_Date__c = temp.Trial_End_Date__c;
                            
                            lrmHeaderLinesToInsert.add(lrmLineRec);
                        }
                    }
                }
                
                if( customerInstToInsert.size() > 0){
                    Database.SaveResult[] saveresCust = Database.Insert(customerInstToInsert,false);
                    Integer successCount = 0,errorCount = 0;
                    for(Database.SaveResult sr: saveresCust){
                        if(!sr.isSuccess()){
                            errorCount++;
                            for(Database.Error err : sr.getErrors()) {
                                errormsg +=err.getMessage() +'\n';
                            } 
                        }
                        else{
                            successCount++;
                        }
                    }
                    
                    if( errorCount == 0 && successCount > 0){
                        if(successresult){
                            successresult = true;
                        }
                        if(isPartialSuccess){
                            isPartialSuccess = true;        
                        }
                    }
                    else if(successCount > 0 && errorCount > 0){
                        successresult = false;
                        isPartialSuccess = true;
                    }
                    else if( successCount == 0 && errorCount > 0){
                        successresult = false;
                    }
                }
                    
                if( lrmHeaderLinesToInsert.size() > 0){
                    Database.SaveResult[] saveresCust = Database.Insert(lrmHeaderLinesToInsert,false);
                    Integer successCount = 0,errorCount = 0;
                    for(Database.SaveResult sr: saveresCust){
                        if(!sr.isSuccess()){
                            errorCount++;
                            for(Database.Error err : sr.getErrors()) {
                                errormsg +=err.getMessage() +'\n';
                            } 
                        }
                        else{
                            successCount++;
                        }
                    }
                    
                    if( errorCount == 0 && successCount > 0){
                        if(successresult){
                            successresult = true;
                        }
                        if(isPartialSuccess){
                            isPartialSuccess = true;        
                        }
                    }
                    else if(successCount > 0 && errorCount > 0){
                        successresult = false;
                        isPartialSuccess = true;
                    }
                    else if( successCount == 0 && errorCount > 0){
                        successresult = false;
                    }
                }
                    
            }
        }
        catch(Exception e){
            successresult = false;
            isExceptionOccured = true;
            errormsg = e.getMessage();
            if(!isValidationError){
                status = 'Internal Server Error';
                statusCde = 500;
            }
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }
        
        if(!isExceptionOccured){
            statmsg = new StatusMessage(wrapperInstances.size(),errormsg);    
        }
        else{
            statmsg = new StatusMessage(requestCount,errormsg); 
        }

        statmsg.statusMessage = status;
        statmsg.statusCode = statusCde;
        statmsg.isPartialSuccess = isPartialSuccess;
        statmsg.isTotalSuccessAchieved = successresult;
        
        return statmsg;
    }
    
    static void verifyJSONRequest(String jsonString){
        
        Map<String,String> inputJSONKeyMap = new Map<String,String>{'sfdc_account_id'=>'String','instance_id'=>'String','product_instance_id'=>'String',
                                                                    'entitlement_type'=>'String','email'=>'String','entitlement_start_date'=>'DateTime',
                                                                    'entitlement_end_date'=>'DateTime','material_id'=>'String','event_id'=>'String'};
        
        List<Object> untypedMapList = (List<Object>) JSON.deserializeUntyped(jsonString);
        
        requestCount = untypedMapList.size();
        
        Set<String> entitlementTypeValues = new Set<String>{'freemium', 'trial', 'paid','Freemium','Paid','Trial'};
        Set<String> eventIdValues = new Set<String>{'TRLPRV' , 'TRLREQ' , 'GAINSIGHT'};    
        
        Map<String,Object> tempMap;
        
            for(Object indivMap : untypedMapList){
                for(String key : inputJSONKeyMap.keySet()){
                    
                tempMap = (Map<String,Object>) indivMap;
                
                if( !tempMap.containsKey(key)){
                    statusCde = 400;
                    status = 'Bad Request';
                    isValidationError = true;
                    throw new GainSightWSException('One or More Objects in the JSON request array is malformed.Please verify.');
                }
                else{
                    if( inputJSONKeyMap.get(key) == 'String' && !(tempMap.get(key) instanceof String)){
                        statusCde = 400;
                        status = 'Bad Request';
                        isValidationError = true;
                        throw new GainSightWSException('One or More Objects in the JSON request has field value mismatch.Please verify.');
                    }
                    if( inputJSONKeyMap.get(key) == 'DateTime'){
                        
                        String tempDateTime = String.valueOf(tempMap.get(key)).replace('T',' ').removeEnd('.000Z');
                        
                        DateTime tempDate;
                        
                        try{
                            tempDate = Datetime.valueOfGmt(tempDateTime);
                        }
                        catch(Exception e){
                            
                        }
                        if( tempDate == null){
                            statusCde = 400;
                            status = 'Bad Request';
                            isValidationError = true;
                            throw new GainSightWSException('One or More Objects in the JSON request has field value mismatch.Please verify.');        
                        }
                    }
                    
                    if( key == 'entitlement_type' && !entitlementTypeValues.contains(String.valueOf(tempMap.get(key)))){
                        statusCde = 400;
                        status = 'Bad Request';
                        isValidationError = true;
                        throw new GainSightWSException('One or More Objects in the JSON request has garbage value for "entitlement_type".Please verify.');
                    }
                        
                    if( key == 'event_id' && !eventIdValues.contains(String.valueOf(tempMap.get(key)))){
                        statusCde = 400;
                        status = 'Bad Request';
                        isValidationError = true;
                        throw new GainSightWSException('One or More Objects in the JSON request has garbage value for "event_id".Please verify.');
                    }    
                }       
            }
        }
        
        
    }
    
    
    global class GainSightWrapper{
        
        global string sfdc_account_id;
        global string instance_id;
        global String product_instance_id;
        global String entitlement_type;
        global String email;
        global DateTime entitlement_start_date;
        global DateTime entitlement_end_date;
        global String material_id;
        global String event_id;
        
    }
}