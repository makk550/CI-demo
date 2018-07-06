public with sharing class AutomicVersion
{
    Public Case c {get; set;}
    
    Map<string,Automic_R_D_Component_Version__c> versionOldMap;
    Map<string,Id> componentReleaseMap;
    public String ccomments { get; set; }

    public Boolean isError{get;set;}
    public String errorMessage {get;set;}
    
    public SelectOption[] selectedOptions { get; set; }
    public SelectOption[] allOptions { get; set; }
    
   // SelectOption lists for public consumption
    public SelectOption[] leftOptions { get; set; }
    public SelectOption[] rightOptions { get; set; }

    public AutomicVersion() 
    {
        string probId = ApexPages.currentPage().getParameters().get('caseId');
        isError = false;
        c= new Case();
        List<Case> cList = new List<Case>([select id,Component_Release_Only_Selection__r.Component_Code__c from Case where id =: probId]);
        if(!cList.isEmpty()){
            c = cList[0];
           
        }
    }
    
    public AutomicVersion(ApexPages.StandardController controller)  
    {
        string probId = ApexPages.currentPage().getParameters().get('caseId');
        isError = false;
        errorMessage='';
        c= new Case();
        List<Case> cList = new List<Case>([select id,case_type__c,CA_Product_Controller__c,Component_Release_Only_Selection__c,CA_Product_Component__c,Component_Code__c,Component_Release_Only_Selection__r.Component_Code__c from Case where id =: probId]);
        if(!cList.isEmpty()){
            c = cList[0];
            
            //makePicklistMap();
            system.debug('Product: '+c.CA_Product_Controller__c);
            
            
            // picking up version names from already created versions
            versionOldMap = new Map<string,Automic_R_D_Component_Version__c>();
            for(Automic_R_D_Component_Version__c pVer: [SELECT Id, Name, Component_Release__c, Problem__c, Planned_Released_Date__c, Fixed_Type_display__c, Version_Jira_Id__c, Fixed_Type__c, Fixed_In__c, Actual_Release_Date__c FROM Automic_R_D_Component_Version__c where Problem__c =:c.id]) {
                //selectedOptions.add(new SelectOption(pVer.Component_Release__c,pVer.Name));
                versionOldMap.put(pVer.Name,pVer);                
            }
            PicklistONProductSelect();   
        }
    }
    // Parse &-separated values and labels from value and 
    // put them in option
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(leftOptions, value);
        }
    }
    
    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(rightOptions, value);
        }
    }

    
    
    
    public void Save()
    {
        if (c.case_type__c=='Standard'){
                    errorMessage='There is no Problem associated with this Case.';
                    isError=true;
        }
        if(!selectedOptions.isEmpty())
        {
            List<Automic_R_D_Component_Version__c> versionsListInsert = new List<Automic_R_D_Component_Version__c>();
            for(SelectOption selectedVer : selectedOptions){
                if(!versionOldMap.containsKey(selectedVer.getLabel()))
                    versionsListInsert.add(new Automic_R_D_Component_Version__c(name=selectedVer.getLabel(),Problem__c=c.id,Created_Internally__c=TRUE,Component_Release__c=selectedVer.getValue(),Fixed_Type__c='?'));
            }
            //if(!versionOldMap.isEmpty())
            //delete versionOldMap.values();
            if(!versionsListInsert.isEmpty())
                insert versionsListInsert;
        }
        update c;
    }

    public void sendProblemComments()
    {
            List<Case> cList = [select id,parentID,SE_Action__c,case_type__c,casenumber,JIRA_Issue_Key__c,BusinessHoursId,Next_Action_Due_Date__c,Next_Action__c,Severity__c from Case where id =:c.id];
            //if(ccomments==''){
                //errorMessage='Please enter Comments for Case / Problem Intercommunication.';
                //isError=true;
              //  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Comments for Case / Problem Intercommunication.');
              //  ApexPages.addMessage(msg);  
            //}
        isError=false;
        if(string.isBlank(ccomments)){
            errorMessage='Please enter Comments for Case / Problem Intercommunication.';
            isError=true;
        } else {
            if (cList[0].case_type__c=='Problem'){
                List<Case> childList = new List<Case>([select id,SE_Action__c,parentID,case_type__c,casenumber,JIRA_Issue_Key__c,BusinessHoursId,Next_Action_Due_Date__c,Next_Action__c,Severity__c from Case where parentID =:c.id AND Status!='Closed']);
                JiraIntegrationHelper.createSEActionTask(childList);
                List<CaseComment> caseCommentList = new List<CaseComment>(); 
                if (!childList.isEmpty()){
                    String caselist='';
                    for(Case pc:childList){
                        System.debug('Problem Case Comments='+ccomments);
                        String casemsg  =  'Message from Problem '+cList[0].casenumber + '\n\n'+ccomments;   
                        Casecomment cm=new Casecomment(parentID=pc.id,isPublished=false,commentbody=casemsg);
                        //insert cm;
                        caseCommentList.add(cm);
                        caselist = caselist==''? pc.casenumber:  caselist +',' + pc.casenumber;
                        //pc = JiraIntegrationHelper.updateNextActionOwnerAndTime(pc);
                        pc = JiraIntegrationHelper.caseProblemIntercommunication(pc);
                    }
                    JiraIntegrationHelper.createSEActionTask(childList);
                    update childList;
                    String msg='Message is sent to '+caselist + '\n\n'+ccomments;
                    Casecomment pcm=new Casecomment(parentID=c.id,isPublished=false,commentbody=msg);
                    //insert pcm;
                    caseCommentList.add(pcm);
                    insert caseCommentList;
                    List<Case> parentCaseList = new List<Case>();
                    parentCaseList.add(cList[0]);
                    JiraIntegrationHelper.createSEActionTask(parentCaseList);
                }else{
                    errorMessage='There are no Case(s) associated with this Problem.';
                    isError=true;
                }
            }else if (cList[0].case_type__c=='Standard'){
                Case standardCase = cList[0];
                //List<Case> cList = [select id,parentID from Case where id =:c.id];
                if (!cList.isEmpty() && standardCase.parentID != NULL){
                    List<Case> parent = new List<Case>([select casenumber, Next_Action_Due_Date__c, Next_Action__c, BusinessHoursId from Case where ID =:standardCase.parentID AND Status!='Closed']);
                    List<Case> taskCaseList = new List<Case>();
                    System.debug('Problem Case Comments='+ccomments);    
                    String msgtosend =  'Message from Case '+standardCase.casenumber + '\n\n' + ccomments;    
                    Casecomment cm=new Casecomment(parentID=standardCase.parentID,isPublished=false,commentbody=msgtosend);
                    insert cm;
                    String msg='Message is sent to '+parent[0].casenumber + '\n\n' + ccomments;
                    Casecomment pcm=new Casecomment(parentID=standardCase.Id,isPublished=false,commentbody=msg);
                    insert pcm;
                    taskCaseList.add(standardCase);
                    JiraIntegrationHelper.createSEActionTask(taskCaseList);
                    //standardCase = JiraIntegrationHelper.updateNextActionOwnerAndTime(standardCase);  
                    parent[0] = JiraIntegrationHelper.caseProblemIntercommunication(parent[0]);  
                    parent.add(standardCase);
                    update parent;
                }else{
                    errorMessage='There is no Problem associated with this Case.';
                    isError=true;
                 }   
            }
        }
    }

    public void resetVersionLists()
    {
        selectedOptions = new List<SelectOption>();
        allOptions = new List<SelectOption>();
    }
    
    public void PicklistONProductSelect()
    {
        resetVersionLists();
        //if(c.Component_Release_Only_Selection__c != null) {
            system.debug('c.Component_Code__c: '+c.Component_Code__c);
            Set<string> verUnique = new Set<string>();
            //for(Component_Release__c dVer: [SELECT Component_Code__c, Component_Release__c, Component_Text__c, Id, Name FROM Component_Release__c where Component_Code__c =: c.Component_Release_Only_Selection__r.Component_Code__c])
            for(Component_Release__c dVer: [SELECT Component_Code__c, Component_Release__c, Component_Text__c, Id, Name FROM Component_Release__c where component_code__c=: c.Component_Code__c])
            {
                string newName = dVer.Component_Text__c+' '+dVer.Component_Release__c;
                system.debug('version_name '+newName+' id: '+dVer.id);
                if(!verUnique.contains(newName)){
                    if(!versionOldMap.containsKey(newName)){
                        allOptions.add(new SelectOption(dVer.id,newName));
                        verUnique.add(newName);
                    }   
                }
            }
            allOptions.sort();
        //}
        system.debug('allOptions: '+allOptions);
    }
    @InvocableMethod
    public static void createSEAction(List<Case> secaseList){
        CheckRecursiveTrigger.isInitiatedByJira=TRUE;
        system.debug('************* createSEAction Started for='+secaseList);
        system.debug('************* createSEAction Started'+secaseList.size());
        if (secaseList[0]!= NULL &&  secaseList.size()!=0 ){
                if(secaseList[0].ParentID!=NULL){
                    List<Case> pbc=[Select CaseNumber,Status,owner.email,Offering_Code_Ref__c,JIRA_Issue_Key__c,No_of_problem_or_standard_cases__c from Case where ID=:secaseList[0].ParentID];
                    if (!pbc.isEmpty()){
                        createSEActionFutureMethod(secaseList[0].Id,secaseList[0].ParentID,pbc[0].JIRA_Issue_Key__c);
                        if(pbc[0].JIRA_Issue_Key__c!=NULL && pbc[0].JIRA_Issue_Key__c!=''){
                            String status = pbc[0].Status;
                            String offeringCode = (null == pbc[0].Offering_Code_Ref__c || '' == pbc[0].Offering_Code_Ref__c ? 'Standard' : pbc[0].Offering_Code_Ref__c);
                            JiraIntegrationHelper.updateStatus(pbc[0].JIRA_Issue_Key__c ,status, offeringCode,String.valueOf(pbc[0].No_of_problem_or_standard_cases__c));
                        }
                    }
                }    
         }   
    }
    @Future
    public static void createSEActionFutureMethod(String CaseID,String parentID,String Parent_JIRA_Issue_Key){
        List<Case> secaseList= new List<Case>();
        Case newc=new Case(Id=CaseID);
        secaseList.add(newc);
        system.debug('************* createSEActionFutureMethod Started for='+secaseList+'@'+parentID);
        system.debug('JIRa Issue Number'+Parent_JIRA_Issue_Key);
        if(Parent_JIRA_Issue_Key!=NULL &&Parent_JIRA_Issue_Key!=''){
            JiraIntegrationHelper.createSEActionTask(secaseList);
            Case pc = updateNextAction(CaseID);
            update pc;  
        }
      system.debug('************* createSEActionFutureMethod Ended');
    }
     //This method will use for the Process Builder method 
     public static Case updateNextAction(String CaseID){
        List<Case> ListCaseObj=[Select id,CaseNumber,BusinessHoursId,Severity__c from Case where ID=:CaseID];
        Case caseObject=ListCaseObj[0];          
        Datetime currentDate=System.now();
        Datetime finalDate = null;
        case newc=new Case(Id=caseObject.id);
        Map<id,integer> taskBusinessdayMap = new Map<id,integer>();
        if(caseObject.BusinessHoursId!=null){
            for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id =:caseObject.BusinessHoursId])
                taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
        }
        if(caseObject.Severity__c=='1' || caseObject.Severity__c=='2')
        {
            finalDate=BusinessHours.addGmt(caseObject.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseObject.BusinessHoursId) *Integer.valueOf('1'))*long.Valueof('3600000')));
        }
        else if(caseObject.Severity__c=='3' || caseObject.Severity__c=='4' )
        {
            finalDate=BusinessHours.addGmt(caseObject.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseObject.BusinessHoursId)*Integer.valueOf('5'))*long.Valueof('3600000')));
        }
        newc.SE_Action__c = true;
        newc.Next_Action_Due_Date__c = finalDate; 
        newc.Next_Action__c='Pending CA Engineering (L2)';
        return newc;
    }

}