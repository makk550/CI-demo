public class dashboardController{
    public static Integer SEARCH_LIST_LIMIT = 750;
    public static Integer SEARCH_ARTICLE_LIMIT = 500;
    public static Integer TITLE_DISPLAY_LIMIT = 80;
    public String id { get; set; }
    public List<Knowledge__kav>         PendingApprovals        {get;set;}
    public List<Knowledge__kav>         RejectedKBs             {get;set;}
    public List<Knowledge__kav>         PubKBArticles           {get;set;}
    public List<Knowledge__kav>         ArchivedArticles        {get;set;}
    public List<Knowledge__kav>         MyDrafts                {get;set;}
    public List<Knowledge__kav>         MyPendingApprovals      {get;set;}
    
    // For Search
    public List<Knowledge__kav>         accList                 {get;set;}
    public String searchStr                                   {get; set;}
    
    public string scriptvar                                   {get;set;}
    public Boolean useExactMatch {get;set;}

    // For create
    public String selectedVal{get;set;} 

    public List<SelectOption> getOptns() {
        List<SelectOption> recordTypesPermitted = new List<SelectOption>();
        recordTypesPermitted.add(new SelectOption('','Please Select Template'));
        for(RecordTypeInfo info: Knowledge__kav.SObjectType.getDescribe().getRecordTypeInfos()) {           
            if(info.isAvailable()) {
                if(info.getName() != 'Master') {
                    recordTypesPermitted.add(new SelectOption(info.getRecordTypeId(), info.getName()));
                }
            } 
        }        
        return recordTypesPermitted;
    }


    public dashboardController()
        
    { 
        /* 
           *accList
           *MyDrafts
           *MyPendingApprovals
           *PendingApprovals
           *RejectedKBs
           *PubKBArticles
           *ArchivedArticles      
        */
        useExactMatch = true;
        MyPendingApprovals = new List<Knowledge__kav>();
        List<ProcessInstance> pendingAppProcessKBIds = new List<ProcessInstance>();
        List<ProcessInstance> draftKBIds = new List<ProcessInstance>();
        List<ProcessInstance> rejectedKBIds = new List<ProcessInstance>(); 
        List<ProcessInstance> listOfRejectedArticles = new List<ProcessInstance>();
        List<ProcessInstance>  processKBIds = new List<ProcessInstance>();
        
         
        List<Knowledge__kav> draftKBArticles =  [Select id                       
                                                  from Knowledge__kav
                                                  where Publishstatus='Draft' and CreatedById=:userinfo.getUserId()
                                                  ORDER BY LastModifiedDate desc ];
                          
        if(draftKBArticles <> null && draftKBArticles.size() >0 ){ 
             // Get KB IDs which are Draft from Knowledge
             set<Id> setOfdraftKBIds = new set<Id>();
             for(Knowledge__kav draftKBObject:draftKBArticles ){
                 setOfdraftKBIds.add(draftKBObject.Id);
             }
            
             if(setOfdraftKBIds<>null && setOfdraftKBIds.size()>0){
                 processKBIds    = [SELECT Id,TargetObjectId FROM ProcessInstance where TargetObjectId IN:setOfdraftKBIds];
               } 
             set<Id> setOfNotProcessIds  = new set<Id>();  
             if(processKBIds <> null && processKBIds.size() > 0 )
             { 
                 for(ProcessInstance PIobj:processKBIds){
                      setOfNotProcessIds.add(PIobj.TargetObjectId);
                    }
                    
             } 
                       
             MyDrafts = [Select Id ,ArticleNumber,recordType.Name, Auto_Article_Number__c, Title, product_names__c, LastModifiedDate , CreatedById ,Releases__c, PublishStatus                         
                                             from Knowledge__kav where Id Not IN:setOfNotProcessIds and CreatedById=:userinfo.getUserId() and Publishstatus='Draft'  ORDER BY LastModifiedDate desc ];                 

            MyDrafts = compressFields(MyDrafts);
            for (Knowledge__kav art : MyDrafts) {
                    art.Title = art.Title.left(80);
            }
         }  

        List<Knowledge__kav> pendingAppKBArticles =  [Select id                       
                                                      from Knowledge__kav
                                                      where Publishstatus='Draft' and AssignedToId=:userinfo.getUserId()
                                                      ORDER BY LastModifiedDate desc ];
                          
         if(pendingAppKBArticles <> null && pendingAppKBArticles.size() >0 )
        { 
             // Get KB IDs which are Draft from Knowledge
             set<Id> setOfPendingAppKBIds = new set<Id>();
             for(Knowledge__kav pendingAppKBObject:pendingAppKBArticles ){
                 setOfPendingAppKBIds.add(pendingAppKBObject.Id);
             }
              List<String> closedStatuses = new List<String>();
              closedStatuses.add('Approved');
              closedStatuses.add('Rejected');
             if(setOfPendingAppKBIds<>null && setOfPendingAppKBIds.size()>0){
                 pendingAppProcessKBIds    = [SELECT Id,TargetObjectId FROM ProcessInstance where TargetObjectId IN:setOfPendingAppKBIds and Status NOT IN :closedStatuses];
               } 
             set<Id> setOfNotPendingAppProcessIds  = new set<Id>();  
             if(pendingAppProcessKBIds <> null && pendingAppProcessKBIds.size() > 0 )
             { 
                 for(ProcessInstance PIobj:pendingAppProcessKBIds){
                      setOfNotPendingAppProcessIds.add(PIobj.TargetObjectId);
                    }
                    
             } 
                       
             MyPendingApprovals = [Select Id ,ArticleNumber,recordType.Name, Auto_Article_Number__c, Title, product_names__c, LastModifiedDate , CreatedById ,Releases__c, PublishStatus                         
                                             from Knowledge__kav where Id IN:setOfNotPendingAppProcessIds and AssignedtoId=:userinfo.getUserId() and Publishstatus='Draft'  ORDER BY LastModifiedDate desc ];                 
         } 
           
         PubKBArticles = [Select id,recordType.Name, Auto_Article_Number__c,ArticleNumber, Title, product_names__c, LastModifiedDate , CreatedById ,Releases__c, PublishStatus                         
                         from Knowledge__kav where Publishstatus='Online' and CreatedById=:userinfo.getUserId()
                         ORDER BY LastModifiedDate desc ];
        PubKBArticles = compressFields(PubKBArticles);
        ArchivedArticles = [Select id,recordType.Name, Auto_Article_Number__c,ArticleNumber, Title, product_names__c, LastModifiedDate , CreatedById ,Releases__c, PublishStatus                         
                         from Knowledge__kav where Publishstatus='Archived' and CreatedById=:userinfo.getUserId()
                         ORDER BY LastModifiedDate desc ];
        ArchivedArticles = compressFields(ArchivedArticles);
                            
       
           
        List<Knowledge__kav> knowledgeList = [select Id, knowledgeArticleId from Knowledge__kav where PublishStatus='Draft' and CreatedById=:userinfo.getUserId() ORDER BY LastModifiedDate desc];        
                                                                               
        if(knowledgeList<>null && knowledgeList.size()>0)
        { 
             // Get KB IDs which are Draft from Knowledge
             set<Id> setOfDraftArticle = new set<Id>();
             for(Knowledge__kav knowledgeObject:knowledgeList){
             //setOfDraftArticle.add(knowledgeObject.knowledgeArticleId);
                 setOfDraftArticle.add(knowledgeObject.Id);
             }
                           
             set<Id> setOfPendingArticle  = new set<Id>();
             if(setOfDraftArticle<>null && setOfDraftArticle.size()>0){
                 draftKBIds    = [SELECT Id,ProcessDefinitionId,SubmittedById,TargetObjectId FROM ProcessInstance where Status = 'Pending' and TargetObjectId IN:setOfDraftArticle];
                            
                 for(ProcessInstance PIobj:draftKBIds){
                      setOfPendingArticle.add(PIobj.TargetObjectId);
                 }
                             
                 if(setOfPendingArticle<>null && setOfPendingArticle.size()>0)
                 {                                   
                    Set<string> setkbid = new Set<String>();                    
                    for(Knowledge__kav KnwObj:knowledgeList)
                    {
                        if(setOfPendingArticle.contains(KnwObj.Id))
                        {
                            setkbid.add(KnwObj.Id);
                        }                                                    
                    }
                  PendingApprovals = [Select Id ,recordType.Name, Auto_Article_Number__c, AssignedTo.Name, Title, product_names__c, LastModifiedDate , CreatedById ,Releases__c, PublishStatus                         
                                             from Knowledge__kav where Id  = :setkbid ORDER BY LastModifiedDate desc ];
                  PendingApprovals = compressFields(PendingApprovals);                      
                     
                 }
                 
        }
        }
        

        
        set<Id> setOfKnowledgeArticleId = new set<Id>();
        Map<Id,DateTime> mapOfLastModifiedDate =  new Map<Id,DateTime>();
        set<Id> setOfApprovedArticleId= new set<Id>();
        
        listOfRejectedArticles = [SELECT Id, TargetObjectId, Status, LastModifiedDate FROM ProcessInstance where Status!='Started' and createdById=:userinfo.getUserId() ORDER BY LastModifiedDate DESC ];
        for(ProcessInstance ProcessInstanceObj:listOfRejectedArticles){
                    if(String.isNotBlank(ProcessInstanceObj.TargetObjectId) && ProcessInstanceObj.Status.equalsIgnoreCase('Rejected') && (setOfKnowledgeArticleId.isEmpty() || !setOfKnowledgeArticleId.contains(ProcessInstanceObj.TargetObjectId) || (setOfKnowledgeArticleId.contains(ProcessInstanceObj.TargetObjectId) && mapOfLastModifiedDate.get(ProcessInstanceObj.TargetObjectId)<ProcessInstanceObj.lastmodifieddate))){
                        if(setOfApprovedArticleId.isEmpty() || (setOfApprovedArticleId<>null && !setOfApprovedArticleId.contains(ProcessInstanceObj.TargetObjectId))){
                            setOfKnowledgeArticleId.add(ProcessInstanceObj.TargetObjectId);    
                            mapOfLastModifiedDate.remove(ProcessInstanceObj.TargetObjectId);
                            mapOfLastModifiedDate.put(ProcessInstanceObj.TargetObjectId,ProcessInstanceObj.lastmodifieddate);    
                        }
                    }
                    else if(ProcessInstanceObj.Status.equalsIgnoreCase('Approved') || ProcessInstanceObj.Status.equalsIgnoreCase('Pending'))
                    {
                        if(setOfKnowledgeArticleId<>null && setOfKnowledgeArticleId.size()>0 && setOfKnowledgeArticleId.contains(ProcessInstanceObj.TargetObjectId)){
                            setOfKnowledgeArticleId.remove(ProcessInstanceObj.TargetObjectId);
                        }
                        setOfApprovedArticleId.add(ProcessInstanceObj.TargetObjectId);
                    }
                    
          }
          
         System.Debug('IAS Rejected here : '+ setOfKnowledgeArticleId);
        // System.Debug('IAS Pending here : ' + setOfApprovedArticleId);
        if(setOfKnowledgeArticleId<>null && setOfKnowledgeArticleId.size()>0){
           RejectedKBs = [Select Id ,recordType.Name, Auto_Article_Number__c, Title, product_names__c, LastModifiedDate , CreatedById ,Releases__c, PublishStatus from Knowledge__kav where Id IN:setOfKnowledgeArticleId and CreatedById=:userinfo.getUserId() AND PublishStatus = 'Draft' ORDER BY LastModifiedDate desc]; 
           RejectedKBs = compressFields(RejectedKBs);
       }
         
         


        
    }


    public PageReference Create() {
          
           String selectedTemplate = selectedVal;
           PageReference pr;
           if(String.isNotBlank(selectedVal))
           {   
             pr= new PageReference('/apex/CustomKnowledgeEdit?recordTypeId='+selectedVal+'&type=Knowledge__kav');
             pr.setRedirect(true);
           }
           else
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select an Article Template!!');
              ApexPages.addMessage(myMsg);
           }
           return pr;        
     }


    public void searchKB() {
        accList = New List<Knowledge__kav>();
        List<Knowledge__kav> bccList = New List<Knowledge__kav>();
        List<Knowledge__kav> arcList = new List<Knowledge__kav>();
        if(searchStr.length() > 1)
        {
           if(searchStr.length() > 1)
           {
               
               if(searchStr.Contains('*') || searchStr.Contains('(') || searchStr.Contains(')') || searchStr.Contains('{') || searchStr.Contains('}') || searchStr.Contains('#') )
               {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter a valid Search text!!');
                  ApexPages.addMessage(myMsg);
                  return;
               } 
               else
               { 
                   String searchStr1 = '';
                   if (useExactMatch) {
                       searchStr1='"'+searchStr+'"';
                   } else {
                       searchStr1 = searchStr;
                   }
                   List<List<sObject>> search_results = [FIND :searchStr1 IN ALL FIELDS RETURNING Knowledge__kav (Id,Title,PublishStatus,Auto_Article_Number__c,Product_Names__c,Releases__c,LastModifiedDate,CreatedById WHERE PublishStatus = 'Online' ORDER BY LastModifiedDate desc LIMIT :SEARCH_ARTICLE_LIMIT) ];    
                   accList = search_results[0];
                   
                   
                   List<List<sObject>> search_results_dr = [FIND :searchStr1 IN ALL FIELDS RETURNING Knowledge__kav (Id,Title,PublishStatus,Auto_Article_Number__c,Product_Names__c,Releases__c,LastModifiedDate,CreatedById WHERE PublishStatus = 'Draft' ORDER BY LastModifiedDate desc LIMIT :SEARCH_ARTICLE_LIMIT) ];         
                   bccList = search_results_dr[0];

                   List<List<sObject>> search_results_ar = [FIND :searchStr1 IN ALL FIELDS RETURNING Knowledge__kav (Id,Title,PublishStatus,Auto_Article_Number__c,Product_Names__c,Releases__c,LastModifiedDate,CreatedById WHERE PublishStatus = 'Archived' ORDER BY LastModifiedDate desc LIMIT :SEARCH_ARTICLE_LIMIT) ];         
                   arcList = search_results_ar[0];
                   
                   if (accList.size() <= SEARCH_ARTICLE_LIMIT) {
                    accList.addAll(bccList);
                   }

                   if (accList.size() <= (SEARCH_ARTICLE_LIMIT * 1.5)) {
                    accList.addAll(arcList);
                   }
                   
                   if (accList.size() > SEARCH_LIST_LIMIT) {
                       integer listPos = (accList.size() - 1);
                       while (listPos >= SEARCH_LIST_LIMIT) {
                           accList.remove(listPos);
                           listPos--;
                       }
                   }

                   accList = compressFields(accList);
                   
                   
                   if(accList.size() == 0)
                   {
                           apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'No results found..'));
                           return;
                   }

               }
           }
           else
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter a valid Search text!!');
              ApexPages.addMessage(myMsg);
              return;
           }  

          
        }
        else
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter a valid Search text!!');
          ApexPages.addMessage(myMsg);
          return;
        }
    }

    public List<Knowledge__kav> compressFields(List<Knowledge__kav> articles) {
        for (Knowledge__kav art : articles) {
            if (art.Title.length() >= TITLE_DISPLAY_LIMIT) {
                art.Title = art.Title.left(TITLE_DISPLAY_LIMIT - 3) + '...';
            }
        }
        return articles;
    }
}