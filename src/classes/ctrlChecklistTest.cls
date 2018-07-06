@isTest
private class ctrlChecklistTest{
 static testMethod void runTestCases() 
    { 
    
    checklist_type__C ct = new checklist_type__C(name = 'test dev');
    insert ct;
    
    Checklist_Item__c ci = new Checklist_Item__c(name ='ci 1', due_date__c = date.today());
    insert ci;
    ci = new Checklist_Item__c(name ='ci 2', due_date__c = date.today());
    insert ci;
    
    
    ctrlChecklist  cls = new ctrlChecklist();
    cls.initPage();
    cls.submit();
   
    ctrlChecklist_lookup cls2 = new ctrlChecklist_lookup();
   
    
    }         

}