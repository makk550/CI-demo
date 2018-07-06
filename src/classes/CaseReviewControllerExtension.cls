public class CaseReviewControllerExtension
{
    private final Case_Review__c caseReview;
    private final Case_Review__c myCaseReview;
    private final Id caseId;
    public List<Case_Review_Admin__c> caseReviewAdmin {set; get;}
    public List<Case_Review_Type__c> caseQuestionsList {set; get;}
    public List<Case_Review_Type__c> caseQuestionsViewList {set; get;}
    public List<List<SelectOption>> scoreOptionsList {set; get;}
    public String myScoreOptionsNew {set; get;}
    private Apexpages.StandardController controller;
    public List<boolean> scoreOption1 {set; get;}
    public List<boolean> scoreOption2 {set; get;}
    public List<boolean> scoreOption3 {set; get;}
    public List<boolean> scoreOption4 {set; get;}
    public String recordTypeValue{set;get;}
    public Boolean showButton{get;set;}
    public String getCaseRecordId{get;set;}
    public String getReviewRecordId{get;set;}
    public String getRetURL;
    
    public CaseReviewControllerExtension() {} 
    
    public List<SelectOption> getRecordValues() {
        List<SelectOption> recordTypeObj = new List<SelectOption>();
        recordTypeObj.add(new SelectOption('-None-','-None-'));
        for(Case_Review_Record_Type__c recordTypeObject:Case_Review_Record_Type__c.getall().values()){
          recordTypeObj.add(new SelectOption(recordTypeObject.Name,recordTypeObject.Name));    
        }
        return recordTypeObj;
    }
  
    public CaseReviewControllerExtension(ApexPages.StandardController stdController){
         getCaseRecordId = ApexPages.currentPage().getParameters().get('caseId')<>null?ApexPages.currentPage().getParameters().get('caseId'):'';
    getReviewRecordId = ApexPages.currentPage().getParameters().get('Id')<>null?ApexPages.currentPage().getParameters().get('Id'):'';
        getRetURL = ApexPages.currentPage().getParameters().get('retURL')<>null?ApexPages.currentPage().getParameters().get('retURL'):'';
        
        system.debug(getRetURL+'-relative url-'+recordTypeValue+'-#######:'+getReviewRecordId+'-getRecordId:-'+getCaseRecordId);
        
        if(String.isNotBlank(getRetURL)){
          controller = stdController;        
            caseReview = (Case_Review__c)stdController.getRecord();
            showButton = false;
            caseReviewLogic();    
        }else{
            showButton = true;
        }
        
        if(String.isBlank(getCaseRecordId) && String.isNotBlank(getReviewRecordId)){
          List<Case_Review__c> caseReviewObj = [Select id, Engineer_Name__c, Reviewer_Name__c, Assessment_Type__c, Review_Type__c, Chat_Transcript__c, Case_Number__c, Review_Today_Date__c, Today_Date__c, case__c from Case_Review__c where Id =:getReviewRecordId];
            
            if(caseReviewObj<>null && caseReviewObj.size()>0){
            List<Case> myCase = [Select id, casenumber, ownerid from Case where id = :caseReviewObj[0].case__c];     
                if(caseReviewObj[0].id<>null && myCase<>null && myCase.size()>0){
                    if(String.isNotBlank(caseReviewObj[0].Review_Type__c) && caseReviewObj[0].Review_Type__c.equalsIgnoreCase('Chat')){
                      recordTypeValue = 'Chat';    
                      }else if(String.isNotBlank(caseReviewObj[0].Review_Type__c) && caseReviewObj[0].Review_Type__c.equalsIgnoreCase('Customer Assistance')){
                        recordTypeValue = 'Customer Assistance';    
                    }
                    else{
                        recordTypeValue = 'Assisted'; 
                    }
                    caseQuestionsList = new List<Case_Review_Type__c>();
               caseQuestionsViewList = [Select Comment__c, Description__c, Explanation__c, Score__c, Score_New__c, Type__c,render_1__c
                                  ,render_2__c,render_3__c,render_4__c
                                  ,Score_Picklist_1__c,Score_Picklist_2__c,Score_Picklist_3__c
                                  ,Score_Picklist_4__c,Case_Review__c from Case_Review_Type__c where case_review__c = :caseReviewObj[0].Id order by Sort_Order__c ASC];
               caseQuestionsList.addAll(caseQuestionsViewList);    
                }
            }
        }else if(String.isBlank(getReviewRecordId) && String.isNotBlank(getCaseRecordId)){
          controller = stdController;        
            caseReview = (Case_Review__c)stdController.getRecord(); 
        }
      /*controller = stdController;
        this.myCaseReview = (Case_Review__c)stdController.getRecord(); 
        system.debug(myCaseReview.id+'**mycaseReview'+myCaseReview);
        System.debug('**** 1 *****');  
        if(myCaseReview.Id != null)
            caseReview = [Select id, Engineer_Name__c, Reviewer_Name__c, Today_Date__c, case__c from Case_Review__c where id =: myCaseReview.Id];
        else
            caseReview = (Case_Review__c)stdController.getRecord(); 
        
        Case myCase; //= caseReview.Case__r;    
        System.debug('**** 2 *****'+caseReview);        
        
        if(caseReview.case__c!=null)
            myCase = [Select id, casenumber, ownerid from Case where id = :caseReview.case__c][0];
        
        else{     
            caseId = ApexPages.currentPage().getParameters().get('caseId');
            CaseReview.Case__c = caseId;
            myCase = [Select id, casenumber, ownerid from Case where id = :caseId][0];
        }
        
        System.debug('**** 3 *****');        
        if(caseReview.Id == null)
        {
            this.caseReview.Engineer_Name__c = myCase.ownerid;
            this.caseReview.Reviewer_Name__c = UserInfo.getUserId();
            this.caseReview.Today_Date__c = Date.today();
            this.caseReview.Case_Number__c = myCase.casenumber;
            if(caseQuestionsList == null)
            {
                caseQuestionsList = new List<Case_Review_Type__c>();
            }
            
            if(scoreOption1 == null)
            {
                scoreOption1 = new List<boolean>();
            }            
            
            if(scoreOption2 == null)
            {
                scoreOption2 = new List<boolean>();
            } 
            
            if(scoreOption3 == null)
            {
                scoreOption3 = new List<boolean>();
            } 
            
            if(scoreOption4 == null)
            {
                scoreOption4 = new List<boolean>();
            }                                     
            
            System.debug('**** 4 *****');        
            if(caseReviewAdmin == null)
            {
                caseReviewAdmin = new List<Case_Review_Admin__c>();
                caseReviewAdmin = [Select Description__c, Score_Options_New__c, Explanation_of_Scores__c, Sort_Order__c, Title__c from Case_Review_Admin__c order by Sort_Order__c ASC];
                scoreOptionsList = new List<List<SelectOption>>();
                
                for(Case_Review_Admin__c myAdmin : caseReviewAdmin)
                {
                    Case_Review_Type__c tmp = new Case_Review_Type__c(Score_Options__c=myAdmin.Score_Options_New__c, Description__c=myAdmin.Description__c, Explanation__c=myAdmin.Explanation_of_Scores__c, Type__c=myAdmin.Title__c, Sort_Order__c=myAdmin.Sort_Order__c);
                    
                    if(myAdmin.Score_Options_New__c == '1-5')
                    {
                        tmp.render_3__c = true;
                    }
                    
                    if(myAdmin.Score_Options_New__c == '1-5 NR')
                    {
                        tmp.render_4__c = true;
                    }
                    
                    if(myAdmin.Score_Options_New__c == 'Yes-No')
                    {
                        tmp.render_1__c = true;
                    }
                    
                    if(myAdmin.Score_Options_New__c == 'Yes-No NR')
                    {
                        tmp.render_2__c = true;
                    }
                    caseQuestionsList.add(tmp);                                                       
                    //scoreOptionsList.add(getScoreOptions(myAdmin.Score_Options__c));
                }            
            }
            System.debug('**** 5 *****');
            
        }
        System.debug('**** 6 *****');        
        if(caseReview.Id != null)
        {   caseQuestionsList = new List<Case_Review_Type__c>();
         caseQuestionsViewList = [Select Comment__c, Description__c, Explanation__c, Score__c, Score_New__c, Type__c,render_1__c
                                  ,render_2__c,render_3__c,render_4__c
                                  ,Score_Picklist_1__c,Score_Picklist_2__c,Score_Picklist_3__c
                                  ,Score_Picklist_4__c,Case_Review__c from Case_Review_Type__c where case_review__c = :caseReview.Id order by Sort_Order__c ASC];
         caseQuestionsList.addAll(caseQuestionsViewList);
        }
        
        
        System.debug('**** 7 *****');    */    
    }
    
    public void caseReviewLogic(){
        system.debug(getCaseRecordId+'#@@$$#$this.CaseReview'+this.CaseReview);
        if((String.isBlank(getReviewRecordId) && String.isNotBlank(getCaseRecordId) && !recordTypeValue.equalsIgnoreCase('-None-')) || (String.isNotBlank(getRetURL) && String.isNotBlank(getReviewRecordId))){
            List<Case> listOfCase = [Select id, Troubleshooting_Stage__c, casenumber, ownerid from Case where id =:getCaseRecordId];
            
            if(listOfCase<>null && listOfCase.size()>0){
                List<Case_Review__c> listOfCaseReview = [Select Case__c, Engineer_Name__c, Reviewer_Name__c, createdBy.Name  from Case_Review__c where Review_Type__c=:recordTypeValue AND Case__c=:getCaseRecordId AND Reviewer_Name__c=:UserInfo.getUserId() AND Engineer_Name__c=:listOfCase[0].ownerid];
                system.debug('@@@@@@: '+listOfCaseReview.size());
                if(listOfCaseReview<>null && listOfCaseReview.size()>0 && String.isBlank(getRetURL)){
                    showButton = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot add another Case Review record to this Case, as there is already a Case Review for this Reviewer-Engineer Case Type.'));
                }else{
                    showButton = false;
                    this.CaseReview.Case__c = getCaseRecordId;
                    this.caseReview.Engineer_Name__c = listOfCase[0].ownerid;
                    this.caseReview.Reviewer_Name__c = UserInfo.getUserId();
                    this.caseReview.Review_Type__c = recordTypeValue;
                    this.caseReview.Case_Troubleshooting_Stage__c = listOfCase[0].Troubleshooting_Stage__c;//US368336
                    this.caseReview.Case_Number__c = listOfCase[0].casenumber;//US494954
                    this.caseReview.Today_Date__c = Date.today();//US494954
                    /*if(recordTypeValue.equalsIgnoreCase('Assisted')){
                        this.caseReview.Case_Number__c = listOfCase[0].casenumber;//US494954 
                        this.caseReview.Today_Date__c = Date.today();   
                    }else*///US494954 
                    if(recordTypeValue.equalsIgnoreCase('Chat')){
                        //this.caseReview.Case_Number__c = listOfCase[0].casenumber;//US494954 
                        //this.caseReview.Today_Date__c = Date.today();//US494954
                        this.caseReview.Chat_Transcript__c = listOfCase[0].casenumber;
                        this.caseReview.Review_Today_Date__c = Date.today();    
                    }else if(recordTypeValue.equalsIgnoreCase('Customer Assistance')){
                        //this.caseReview.Case_Number__c = listOfCase[0].casenumber;//US494954 
                        //this.caseReview.Today_Date__c = Date.today();//US494954
                        this.caseReview.Chat_Transcript__c = listOfCase[0].casenumber;
                        this.caseReview.Review_Today_Date__c = Date.today();
                    }
                    
                    if(caseQuestionsList == null){
                        caseQuestionsList = new List<Case_Review_Type__c>();
                    }
                    
                    if(scoreOption1 == null)
                    {
                        scoreOption1 = new List<boolean>();
                    }            
                    
                    if(scoreOption2 == null)
                    {
                        scoreOption2 = new List<boolean>();
                    } 
                    
                    if(scoreOption3 == null)
                    {
                        scoreOption3 = new List<boolean>();
                    } 
                    
                    if(scoreOption4 == null)
                    {
                        scoreOption4 = new List<boolean>();
                    }
                    
                    if(caseReviewAdmin == null) {
                        caseReviewAdmin = new List<Case_Review_Admin__c>();
                        caseReviewAdmin = [Select Description__c, Score_Options_New__c, Explanation_of_Scores__c, Sort_Order__c, Review_Type__c, Title__c from Case_Review_Admin__c where Review_Type__c=:recordTypeValue order by Sort_Order__c ASC];
                        scoreOptionsList = new List<List<SelectOption>>();
                        
                        for(Case_Review_Admin__c myAdmin : caseReviewAdmin){
                            Case_Review_Type__c tmp = new Case_Review_Type__c(Score_Options__c=myAdmin.Score_Options_New__c, Description__c=myAdmin.Description__c, Explanation__c=myAdmin.Explanation_of_Scores__c, Type__c=myAdmin.Title__c, Sort_Order__c=myAdmin.Sort_Order__c);
                            
                            if(myAdmin.Score_Options_New__c == '1-5')
                            {
                                tmp.render_3__c = true;
                            }
                            
                            if(myAdmin.Score_Options_New__c == '1-5 NR')
                            {
                                tmp.render_4__c = true;
                            }
                            
                            if(myAdmin.Score_Options_New__c == 'Yes-No')
                            {
                                tmp.render_1__c = true;
                            }
                            
                            if(myAdmin.Score_Options_New__c == 'Yes-No NR')
                            {
                                tmp.render_2__c = true;
                            }
                            caseQuestionsList.add(tmp);    
                            system.debug('caseQuestionsList: '+caseQuestionsList);
                        }            
                    }
                }
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the valid Record Type'));     
        }
    }
    
    public PageReference Save(){
        System.debug(this.caseReview+'**** Calling Save ****'+caseReview);
        
        if(caseReview.id == null){     
            try{
              insert caseReview;
            }catch(DMLException e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insert Failed'));     
                return null;
           }
        }else if(caseReview.id<>null){
           if([Select createdby.Name from case_review__c where id=:caseReview.Id].createdBy.Name == userinfo.getName()){ 
               caseReview.Reviewer_Name__c = UserInfo.getUserId();
               try{
                   update caseReview;    
               }catch(DMLException e){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Update Failed'));     
                   return null;
               }
           }else{
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Only Creator of the Case Review can edit this Case Review.'));     
              return null; 
           }
        }
        
        for(Case_Review_Type__c Q : caseQuestionsList)
        {
            System.debug('**** Q Score 1 ****' + Q.Score_Picklist_1__c);
            System.debug('**** Q Score 2 ****' + Q.Score_Picklist_2__c);
            System.debug('**** Q Score 3 ****' + Q.Score_Picklist_3__c);
            System.debug('**** Q Score 4 ****' + Q.Score_Picklist_4__c);
            
            //Begin of Changes for CR:200-157898
            if(Q.Score_Picklist_3__c== null && Q.Score_Picklist_4__c==null){
                Q.Total_Score__c = 0;
                Q.Score_New__c = Q.Score_Picklist_3__c;
            }
            
            //End of changes for CR:200-157898
            
            if(Q.Score_Picklist_1__c != null && Q.Score_Picklist_1__c != '')
            {
                Q.Score_New__c = Q.Score_Picklist_1__c;
            }
            if(Q.Score_Picklist_2__c != null && Q.Score_Picklist_2__c != '')
            {
                Q.Score_New__c = Q.Score_Picklist_2__c;
            }
            if(Q.Score_Picklist_3__c != null && Q.Score_Picklist_3__c != '')
            {  
                Q.Total_Score__c = Integer.valueOf(Q.Score_Picklist_3__c);
                Q.Score_New__c = Q.Score_Picklist_3__c;
            }
            if(Q.Score_Picklist_4__c != null && Q.Score_Picklist_4__c != '')
            {
                Q.Total_Score__c = (Q.Score_Picklist_4__c=='NR'?0:Integer.valueOf(Q.Score_Picklist_4__c));
                Q.Score_New__c = Q.Score_Picklist_4__c;
            }     
            
            
            if(Q.Case_Review__c==null)
            {
                Q.Case_Review__c = caseReview.id;
            }
        }
        try{
            system.debug('@@@@@@@@@@caseQuestionsList@@@@@'+caseQuestionsList);
            upsert caseQuestionsList;
        }
        
        catch(DMLException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Upsert Failed'));     
            return null;
        }
        
        PageReference pageRef;
        if(String.isBlank(getCaseRecordId))
            pageRef = controller.save(); 
        else
            
            pageRef = new PageReference('/'+getCaseRecordId); 
        return pageRef;              
    }   
    
    
    
    Public PageReference Cancel(){
        
        PageReference pageRef;
        if(String.isBlank(getCaseRecordId))
            pageRef = controller.cancel(); 
        else
            
            pageRef = new PageReference('/'+getCaseRecordId); 
        return pageRef;   
    } 
    
}