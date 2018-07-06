/*
Created By: Tarun Sharma
Created Date: 03/23/2016
Purpose: Read a file from S3 bucket through Rest API
Last Modified Date:
Last Modified By:
*/
public class AWSBucketAccess{
    
    public String AWSBucketAccessMethod(String AWSLink, String sourceFolderName, String caseNumber){
        String XMLFileContent;
        system.debug(AWSLink+'$$$$$$$$$$$$$$$'+sourceFolderName+'$$$$$$$$$$$$$'+caseNumber);
        String AWSLinkValue;
        String selecticaBucket ='';
        if(String.isNotBlank(AWSLink)){
            if(AWSLink.contains('RelatedXMLs')){
                if(String.isNotBlank(sourceFolderName) && String.isNotBlank(caseNumber)){
                    if(caseNumber.contains('_')){
                        if(sourceFolderName.equalsIgnoreCase('Layer7')){
                            AWSLinkValue = '/'+sourceFolderName+AWSLink;   
                        }else{
                            AWSLinkValue = '/'+sourceFolderName+AWSLink;
                            //AWSLinkValue = '/Layer7/'+sourceFolderName+AWSLink;    
                        }  
                    }else{
                        AWSLinkValue = '/'+sourceFolderName+'/'+caseNumber+AWSLink;
                    }
                }    
            }else{
                List<String> sourceName = AWSLink.split('/');
                system.debug('sourceName------->'+sourceName);
                if(AWSLink.contains('/')){
                    AWSLinkValue = AWSLink.substringAfter('/');
                    system.debug('****AWSLINK*****'+AWSLinkValue);
                    if(String.isNotBlank(AWSLinkValue)){
                        if(AWSLinkValue.contains('/')){
                            if(String.isNotBlank(sourceName[0]) && sourceName[0].equalsIgnoreCase('DOCS')){
                                selecticaBucket = sourceName[0];
                                if(AWSLink.contains('.xml')){
                                    AWSLinkValue = '/'+AWSLink;
                                }else{
                                    AWSLinkValue = '/'+AWSLink+'.xml';    
                                } 
                            }else{
                                AWSLinkValue = '/'+AWSLink+'.xml';  
                            }   
                        }else{
                            if(String.isNotBlank(sourceName[0]) && sourceName[0].equalsIgnoreCase('Docs')){
                                selecticaBucket = sourceName[0];
                                if(AWSLink.contains('.xml')){
                                    AWSLinkValue = '/'+AWSLink;
                                }else{
                                    AWSLinkValue = '/'+AWSLink+'.xml';    
                                } 
                            }else{
                                if(AWSLink.contains('.xml')){
                                    AWSLinkValue = '/Layer7/'+AWSLink;
                                }else{
                                    AWSLinkValue = '/'+AWSLink+'.xml';    
                                }
                            }
                        }
                    }
                }    
            }   
        }
        system.debug('AWSLinkValue------->'+AWSLinkValue);
        system.debug('*******'+selecticaBucket);
        String bucket;
        AWS_credentials__c credentials;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1];
        if(String.isNotBlank(selecticaBucket) && !orgObj.IsSandbox){
            bucket =  EncodingUtil.urlEncode(System.Label.AWS_SelecticaArchival_Bucket_Name, 'UTF-8');  
            credentials = AWS_credentials__c.getValues(System.Label.AWS_Selectica_Credential_Name);
        }else{
            bucket =  EncodingUtil.urlEncode(System.Label.AWS_CaseArchival_Bucket_Name, 'UTF-8');
            credentials = AWS_credentials__c.getValues(System.Label.AWS_CaseArchival_Credential_Name);
        }
        if(credentials!=null){
            String S3Key = credentials.Key__c;
            String fname = EncodingUtil.urlEncode(AWSLinkValue, 'UTF-8');//
            Datetime now = DateTime.now();
            Datetime expireson = now.AddSeconds(120);
            Long Lexpires = expireson.getTime()/1000;
            String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucket+AWSLinkValue;
            System.debug('redirectToS3Key stringstosign: ' + stringtosign);
            String signed = make_sig(stringtosign,credentials);
            System.debug('signed: ' + signed);
            String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
            System.debug('codedsigned: ' + codedsigned);
            String url = System.Label.AWS_CaseArchival_Root_URL+bucket+AWSLinkValue+'?AWSAccessKeyId='+S3Key+'&Expires='+Lexpires+'&Signature='+codedsigned;
            System.debug('url: ' + url);
            
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            if(String.isNotBlank(url)){
                request.setEndpoint(url);
                request.setMethod('GET');  
            }
            Http httpObj = new Http();
            if(!Test.isRunningTest()){
              response = httpObj.send(request);
            }else{
              response = httpObj.send(request);
            }
            XMLFileContent = response.getBody();
        }
       system.debug('!@#@!@#'+XMLFileContent);
       return XMLFileContent;
    }
    
    public static String make_sig(string canonicalBuffer, AWS_credentials__c credentials) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(credentials.Secret__c));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(credentials.Secret__c)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }

}