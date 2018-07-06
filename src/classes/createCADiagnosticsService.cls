@RestResource(urlMapping='/CreateDiagnostic/*')
global class createCADiagnosticsService{
   
    @HttpPost
    global static void callCreateCADiagnostics(String caseId, String fileLocation, String fileSize, String source, String status, String uploadDate){
        RestResponse res = RestContext.response;
        if(String.isNotBlank(caseId)){
            List<Case> caseObj = [Select Id from Case where caseNumber=:caseId AND Status!=:'Closed' limit 1];
            if(caseObj<>null && caseObj.size()>0 && String.isNotBlank(fileLocation) && String.isNotBlank(fileSize) && String.isNotBlank(source) && String.isNotBlank(status) && String.isNotBlank(uploadDate)){
                CA_Diagnostics__c diagnosticObj = new CA_Diagnostics__c();
                system.debug('file name loc: '+fileLocation);
                diagnosticObj.Case__c = caseObj[0].Id;
                String diagnosticBucketName =  EncodingUtil.urlEncode(system.Label.AWS_CARE_Telemetry_Bucket_Name, 'UTF-8');
                String metricBucketName =  EncodingUtil.urlEncode(system.Label.AWS_CARE_Telemetry_Metric_Bucket_Name, 'UTF-8');
                String bucketName;
                if(fileLocation.contains(system.Label.AWS_CARE_Telemetry_Bucket_Name)){
                    bucketName = diagnosticBucketName;
                }else if(fileLocation.contains(system.Label.AWS_CARE_Telemetry_Metric_Bucket_Name)){
                    bucketName = metricBucketName;
                }
                if(String.isNotBlank(bucketName)){
                    AWS_credentials__c credentials = AWS_credentials__c.getValues(System.Label.AWS_CARETelemetry_Credential_Name);
                    if(credentials<>null){
                        String S3Key = credentials.Key__c;
                        List<String> splitTheURL = fileLocation.split(bucketName);
                        Datetime now = DateTime.now();
                        Datetime expireson = now.addDays(2000);
                        Long Lexpires = expireson.getTime()/1000;
                        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucketName+splitTheURL[1];
                        System.debug('redirectToS3Key stringstosign: ' + stringtosign);
                        String signed = make_sig(stringtosign,credentials);
                        System.debug('signed: ' + signed);
                        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
                        System.debug('codedsigned: ' + codedsigned);
                        diagnosticObj.File_location__c = fileLocation+'?AWSAccessKeyId='+S3Key+'&Expires='+Lexpires+'&Signature='+codedsigned;
                    }
                }else{
                    diagnosticObj.File_location__c = fileLocation;    
                }
                diagnosticObj.File_Size__c = fileSize;
                diagnosticObj.Source__c = source;
                diagnosticObj.Status__c = status;
                List<String> splitDateAndTime = uploadDate.split('T');
                List<String> splitDate = splitDateAndTime[0].split('-');
                List<String> splitTime = splitDateAndTime[1].split(':');
                System.debug('Time: '+splitTime);
                diagnosticObj.Upload_Date__c = DateTime.newInstanceGmt(integer.valueOf(splitDate[0]), integer.valueOf(splitDate[1]), integer.valueOf(splitDate[2]), integer.valueOf(splitTime[0]), integer.valueOf(splitTime[1]), integer.valueOf(splitTime[2].subString(0,2)));
                insert diagnosticObj;
                res.responseBody = blob.valueOf('Record was created successfully');
            }else{
                res.responseBody = blob.valueOf('Please pass the valid request payload');
            }
        }else{
            res.responseBody = blob.valueOf('Please pass the valid Case Number');
        }
    }
    
    public static String make_sig(string canonicalBuffer, AWS_credentials__c credentials) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(credentials.Secret__c));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(credentials.Secret__c)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
}