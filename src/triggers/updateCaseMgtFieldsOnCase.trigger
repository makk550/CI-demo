trigger updateCaseMgtFieldsOnCase on Case_Related_Object__c (After Insert, After Update) {
    //Trigger is implemented for US316753:Filter by Related Content Type
    
    //if(Label.Integration_UserProfileIds.contains(userinfo.getProfileId().substring(0,15)))
      // return;
    
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        List<Case> listOfCase = new List<Case>();
        Set<String> listOfAllSources = new Set<String>();
        
        for(Related_Content_Source__c relatedContentSource:Related_Content_Source__c.getall().values()){
            listOfAllSources.add(relatedContentSource.Name);    
        }
        system.debug('***HI INSIDE*');
        for(Case_Related_Object__c relatedObj:Trigger.new){
            if(Trigger.isInsert && listOfAllSources<>null && listOfAllSources.contains(relatedObj.Source__c)){
                Case caseObj = new Case(id=relatedObj.CaseId__c,Case_mgmt_LastUpdatedBy_User__c = userinfo.getUserId(),Case_mgmt_LastUpdateDT__c=system.now()); //Case_mgmt_LastUpdatedBy__c=userinfo.getName(),
                listOfCase.add(caseObj);
            }
            if(Trigger.isUpdate && listOfAllSources<>null && listOfAllSources.contains(relatedObj.Source__c) && Trigger.oldMap.get(relatedObj.Id).Source__c<>relatedObj.Source__c){
               Case caseObj = new Case(id=relatedObj.CaseId__c,Case_mgmt_LastUpdatedBy_User__c = userinfo.getUserId(),Case_mgmt_LastUpdateDT__c=system.now()); //Case_mgmt_LastUpdatedBy__c=userinfo.getName(),
               listOfCase.add(caseObj); 
            }
        }
        
        try{
            if(listOfCase<>null && listOfCase.size()>0){
                update listOfCase;
            }
        }catch(DmlException e){
            system.debug('Exception on case update: '+e.getMessage());
        }
    }
}