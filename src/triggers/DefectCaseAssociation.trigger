trigger DefectCaseAssociation on Defect_Case_Association__c (before delete) {
    
    Set<Id>caseIdSet = new Set<Id>();
    Set<Id>defectIdSet = new Set<Id>();
    Map<Id,String> defectAssociationMap = new map<Id,String>();
    List<CaseComment> caseCommentList = new List<caseComment>();
    if(trigger.isDelete && trigger.isBefore){
        for(Defect_Case_Association__c defectCase :Trigger.Old){
            caseIdset.add(defectCase.case__c);
            defectIdSet.add(defectCase.defect__c);
        }
        Map<Id,defect__c>defectMap  = new Map<Id,Defect__c>([Select Id , Name from Defect__c where Id IN:defectIdSet ]); 
            for(Defect_Case_Association__c defectCase :Trigger.Old){
                if(defectMap!=null && defectMap.containskey(defectCase.defect__c)){
                    defectAssociationMap.put(defectCase.Id,defectMap.get(defectCase.defect__c).Name);
                    
                }
            }
            for(Defect_Case_Association__c defectCase :Trigger.Old){
                CaseComment caseComment = new CaseComment();
                caseComment.ParentId = defectCase.case__c ;
                caseComment.CommentBody = 'Defect  '+ defectAssociationMap.get(defectCase.Id)  +' is un-associated from the case ';
                caseCommentList.add(caseComment);
            }
             UtilityFalgs.isDefectUpdate = true;
            insert caseCommentList;
    }

}