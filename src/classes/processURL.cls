Public Class processURL
{

Public String RecordId {get;set;}
Public String Key {get;set;}
Public boolean CustomObj {get;set;} 
Public String ObjectName{get;set;}
Public String ObjectLabel{get;set;}
Public String SharedObjectName{get;set;}
Public Schema.SObjectType ObjectType {get;set;}
Public Schema.SObjectType SharedObjectType {get;set;}
Public Map<String, Schema.SObjectType> mapObj = Schema.getGlobalDescribe();


    Public processURL(String URL)
    {
    
     if(URL!=null&&URL!=''){   
     if(URL.contains('id=')&&URL.contains('&')){
         system.debug('inside &'+URL.substring(URL.IndexOf('id=')+3,URL.IndexOf('&')));
         RecordId = URL.substring(URL.IndexOf('id=')+3,URL.IndexOf('&'));
     }
          
     else if(URL.contains('id=')&&URL.contains('?')){
         system.debug('inside ?'+URL.substring(URL.IndexOf('id=')+3,URL.IndexOf('?')));
         RecordId = URL.substring(URL.IndexOf('id=')+3,URL.IndexOf('?'));
     }
     else   
         RecordId = URL.substring(URL.lastIndexOf('/')+1);
          
     system.debug('RecordId'+RecordId);
        Pattern id = Pattern.compile('^([a-zA-Z0-9]{15}|[a-zA-Z0-9]{18})$');
    	Matcher matcher = id.matcher(RecordId);
        if (!matcher.find()){
            system.debug('not found');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the right type of URL'));
        }
        else{
            system.debug('found');
        
     	Key = RecordId.substring(0,3);
         
            for(Schema.SObjectType objectInstance : mapObj.values()){
        if(objectInstance.getDescribe().getKeyPrefix() == Key){
             
             ObjectName = objectInstance.getDescribe().getName();
             ObjectLabel = objectInstance.getDescribe().getLabel();
             CustomObj = objectInstance.getDescribe().isCustom();
             ObjectType = objectInstance;
             
             }
            }
      SharedObjectName = ObjectName;
          if(CustomObj)
                 SharedObjectName = SharedObjectName.replace('__c','__share');
          else
                 SharedObjectName = SharedObjectName+'Share';
     
      SharedObjectType = mapObj.get(SharedObjectName);
     }
     }
     
}
}