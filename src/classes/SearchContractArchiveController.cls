public class SearchContractArchiveController{

    Public String searchContractEndPoint{get;set;}
    
    public SearchContractArchiveController(){
        searchContractEndPoint = '';
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        if(orgObj.IsSandbox){
            searchContractEndPoint = System.Label.SearchContractArchiveQA;
        }else {
            searchContractEndPoint = System.Label.SearchContractArchiveProd;
        }
    }   
    
    @RemoteAction
    public static String search(String filename){
        String bucket =  EncodingUtil.urlEncode(System.Label.AWS_Bucket_Name, 'UTF-8');
        AWS_credentials__c credentials = AWS_credentials__c.getValues(System.Label.AWS_Credential_Name);
        if(credentials!=null)
        {
            S3.AmazonS3 as3 = new S3.AmazonS3(credentials.key__c,credentials.secret__c);
            System.debug('key:'+as3.key);
            System.debug('secret:'+as3.secret);
                
            String S3Key = credentials.key__c;
            String fname = EncodingUtil.urlEncode(filename, 'UTF-8');
            Datetime now = DateTime.now();
            Datetime expireson = now.AddSeconds(120);
            Long Lexpires = expireson.getTime()/1000;
            String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucket +filename;
            System.debug('redirectToS3Key stringstosign: ' + stringtosign);
            String signed = make_sig(stringtosign,as3);
            System.debug('signed: ' + signed);
            String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
            System.debug('codedsigned: ' + codedsigned);
            String url = System.Label.AWS_Root_URL+bucket +filename+'?AWSAccessKeyId='+as3.key+'&Expires='+Lexpires+'&Signature='+codedsigned;
            System.debug('url: ' + url);
            
            HttpResponse resp = new HttpResponse();
            if(!Test.isRunningTest())
                 resp = getResource(url);
                 System.debug('resp====='+resp);
            if(resp == null)
               return url;
            
            if(resp.getStatusCode() == 404)
                return 'Requested resource not found.';
            return url;
        }
        return 'Given AWS Credentials Not Found!';
    }
    
    public static HttpResponse getResource(String url){
        HttpRequest req = new HttpRequest();
         HttpResponse resp;
        req.setEndpoint(url);
        req.setMethod('GET');  
        Http htp = new Http();
        try{
            resp = htp.send(req);
        }catch (System.CalloutException e){
             System.debug('ERROR:====' + e);
             
        }
        
        return resp;
    }
    
    public static String make_sig(string canonicalBuffer, S3.AmazonS3 as3) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(as3.secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(as3.secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    } 
}