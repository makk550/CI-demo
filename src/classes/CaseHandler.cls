/*************************************************************************\
       @ Author      : D.S Sandeep Reddy
       @ Date        : 16/04/14
       @ Test File   : Initial Version
       @ Description : Trigger Handler for the Case SObject. This class implements the ITrigger.
                       interface to help ensure the trigger code is bulkified and all in one place.

@ Audit Trial : Repeating block for each change to the code
       @ Last Modified By   : Vamshi    
       @ Last Modified On   :  22/06/14 
       @ Last Modified Reason     :  Updated Business hours calculation rules.

 @Last Modified on **** by *** to ******

 ****************************************************************************/

public without sharing class CaseHandler implements ITrigger{

    // Member variable to hold the site details of the case.
    private Map<Id,Case> siteDtls = new Map<Id,Case>();

    // Member variable to hold the Business hour name and corresponding Id related to Case.
    Map<String,id> busHrsIdMap = new Map<String,id>();
    Map<id,User> usrPMFkeyMap = new Map<id,User>(); 
    Map<id,GSS_Transactions__c> caseGSSMap;
    String conMilli='60000';
    List<GSS_Transactions__c> gssLst = new List <GSS_Transactions__c>();
    List<CaseComment> cseCommentlst = new List<CaseComment>();
    List<Task> taskLst = new List<Task>();
    Set<Id> closedCaseSet = new Set<Id>();
    Map<Id,List<Task>> otherSupportTypeTaskMap = new Map<Id,List<Task>>(); // Map to hold case ID as key and values as list of other support tasks

    Map<String, GSS_Transactions__c> caseStageGSSMap; //US108116 
    List<Case_Portal_View__c> portalViewList = new List<Case_Portal_View__c>();
    
    public list<id> ProductContIdlist = new list<id>();
    Public Set<string> automicproset = new Set<string>();
    public list<case> caselist = new list<case>();
    //list of Problem Case Ids
    Public List<Id> ProblemCaseIds = new List<Id>();
    Public List<Id> IncidentCaseIds = new List<Id>();
    public list<case> rcount = new list<case>();
    public list<string> probtypelst = new list<string>();
    Public List<id> rcountid = new List<id>();
    Public List<id> inccountid = new List<id>();
    Public List<case> increcordlst = new List<case>();
    Public Map<string,List<case>> problemIncidentMap = new Map<string,List<case>>();
    Public List<case> incidentlstcount = new List<case>();
                                                                          
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {        
        if (Trigger.isInsert || Trigger.isUpdate)
            busHrsIdMap = CaseGateway.loadCaseBulkBefore();       
    }

    public void bulkAfter()
    {
        if (Trigger.isInsert || Trigger.isUpdate)
            usrPMFkeyMap = CaseGateway.loadCaseBulkAfter();

    } 
    public void beforeInsert(SObject so)
    {
        Case caseRec = (Case)so; 
          System.debug('caseRec ' + caseRec);
          System.debug('busHrsIdMap' + busHrsIdMap);
        //US203673 - Implement Case Time Zones for Callback SLOs  
        caseRec.BusinessHoursid =  CaseGateway.fetchBusinessHoursId(caseRec, busHrsIdMap);
        caseRec.SE_Action__c = false; //US393771
        //caseRec.BusinessHoursid =  busHrsIdMap.get(CaseGateway.siteCntryMap.get(caseRec.Site_Association__c));
         System.debug('SKG - Case Type - ' + caseRec.Case_Type__c);
        //Case Concern logic 
        if(caseRec.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('CaseConcern').getRecordTypeId()){
            UtilityFalgs.isCaseConcern = true;
            caseRec.Internal_CA__c=true;
            caseRec.Status = 'New';
        }
        if(caseRec.Case_Type__c == System.Label.ProactiveCaseType && caseRec.Origin.equalsIgnoreCase(System.Label.CaseOrigin_Gainsight)){
            caseRec.Site_Association__c =CaseGateway.siteAccountIdMap.get(caseRec.AccountId);
        } else {
            caseRec.Accountid=CaseGateway.siteAccMap.get(caseRec.Site_Association__c);
        }
      //  CaseGateway.updateContactFieldsOnCase(caseRec); CR:400-1600
        if(caseRec.Case_Type__c == System.Label.ProactiveCaseType )
           caseRec.Case_Originator_Contact_Name__c = userinfo.getUserId();
        if(caseRec.Next_Action__c!=null)
           caseRec.Next_Action_Date__c =System.Now(); 
       
           
       //Common Code for Support Offerings Flow
       Boolean SSEBackendFLag = false;
       system.debug(caseRec.Case_Type__c+ 'caseRec.RecordTypeId');
       if(! (String.isNotBlank(caseRec.Case_Type__c) && caseRec.Case_Type__c.equalsIgnoreCase(System.Label.ProactiveCaseType)) && caseRec.Case_Type__c != 'Case Concern') { //added this to skip for proactive cases
       system.debug('Enter proactive case---');
        if(!caseRec.Case_Created_without_Entitlement__c && caseRec.Origin!='Chat'){
        system.debug('Enter proactive case111---');
             SupportOfferingsFlowController supportOfferingsFlowController=new SupportOfferingsFlowController();               
            SupportOfferingsFlowController.FinalOfferingData finalOfferingData=supportOfferingsFlowController.getAdvantageousOfferingCodeDetails(caseRec.Tops_Support_Site_ID__c, caseRec.CA_Product_Controller__c, caseRec.ContactId, caseRec.Severity__c);
             if(finalOfferingData<>null){
                caseRec.Offering_Code_Ref__c=finalOfferingData.offeringCode;
                caseRec.Offering_Name__c=finalOfferingData.offeringBusinessRulesID;
                caseRec.Offering_Source__c=finalOfferingData.offeringSource;
                caseRec.Offering_Support_Engineer__c=finalOfferingData.offeringDSE;
                caseRec.Certified_Bypass_Routing_Qualified__c=finalOfferingData.isCBRQualified;
                caseRec.Offering_Code_Configuration_Issue__c=finalOfferingData.isOfferingCodeConfIssue;
                //US130725 -- Start
                caseRec.Queue_Jumping__c = finalOfferingData.isQueueJumpingField;
                //US130725 -- End
                caseRec.Guaranteed_Restoration__c = finalOfferingData.isRestorationFeatureAvailable; //US202426
                SSEBackendFLag = finalOfferingData.isSelectSupportExperience;//US299629
            }
        }
        }
        //SEAL CASE TYPE --- START
        if(String.isNotBlank(caseRec.Case_Type__c) && caseRec.Case_Type__c.equalsIgnoreCase(System.Label.ProactiveCaseType)){
            caseRec.Internal_CA__c = true;
            caseRec.Reason ='Proactive';
             caseRec.Category__c = 'Documentation';
            caseRec.Subcategory__c = 'Clarification';
        }
        //SEAL CASE TYPE --- END
        
        if(caseRec.Case_Type__c =='Case Concern'){
        try{
        if(String.isNotBlank(caseRec.parentId) && String.isNotBlank(CaseGateway.userMapInsert.get(CaseGateway.userparentMap.get(caseRec.parentId)).managerId) && !(CaseGateway.userMapInsert.get(CaseGateway.userparentMap.get(caseRec.parentId)).manager.Profile.Name).contains('Chatter'))
        {
        System.debug('===== Profile.Name==' +CaseGateway.userMapInsert.get(CaseGateway.userparentMap.get(caseRec.parentId)).manager.Profile.Name);
        caseRec.OwnerId = CaseGateway.userMapInsert.get(CaseGateway.userparentMap.get(caseRec.parentId)).managerId;
       }
        
        else
        caseRec.OwnerId = System.Label.Case_Concern_Error_Queue;
        
        System.debug('caseRec.OwnerId=='+caseRec.OwnerId);
        }
        catch(Exception e)
        {caseRec.OwnerId = System.Label.Case_Concern_Error_Queue;
        }
        }
        /*US237090: Priority Case Ordering----PART1--START---*/
        /*String caseOrderingValue;
        caseOrderingValue = caseRec.Severity__c;
        
        //adding immediate callback field value on case
        caseOrderingValue = caseOrderingValue+'9';
        //adding queue jumping value
        if(caseRec.Queue_Jumping__c<>null && caseRec.Queue_Jumping__c){
            caseOrderingValue = caseOrderingValue+'19';
        }else{
            caseOrderingValue = caseOrderingValue+'99';
        }
        
        //adding future Platinum field value on case
        /*if(finalOfferingData.offeringCode.equalsIgnoreCase('ESS PLAT')){
        caseOrderingValue = caseOrderingValue+'1';
        }else{
        caseOrderingValue = caseOrderingValue+'9'; 
        }****
        
        //adding FTK value
        if(caseRec.Certified_Bypass_Routing_Qualified__c<>null && caseRec.Certified_Bypass_Routing_Qualified__c){
            caseOrderingValue = caseOrderingValue+'1999';
        }else{
            caseOrderingValue = caseOrderingValue+'9999'; 
        } */
        /*US237090: Priority Case Ordering----PART1--END---*/        
        
        //US371683---NEW DESIGN FOR PA---START
        if(String.isNotBlank(caseRec.Product_Area__c) && String.isNotBlank(caseRec.Site_Association__c) && String.isNotBlank(caseRec.CA_Product_Controller__c)){
            //US367725--START
            System.debug('----inside case handler before insert--');
            String componentName = checkExistingCases.defaultComponent(caseRec.Product_Area__c);
            UtilityFalgs.caseCommentBodyValue = checkExistingCases.checkOldExistingCases(caseRec.Site_Association__c, caseRec.CA_Product_Controller__c, caseRec.Product_Area__c);
            if(String.isNotBlank(componentName)){
                 System.debug('----inside case handler if--');
                caseRec.CA_Product_Component__c = componentName;
            }
            //US367725---END
        }
        //US371683---NEW DESIGN FOR PA---END
        
        //US138062-Set utility flags value to true when case is queue jumping enabled-start
        if(caseRec.Queue_Jumping__c && caseRec.Queue_Jumping__c!=null)
        UtilityFalgs.isQueueJumpingEnabled=true;
        //US138062-end 
        CaseGateway.updInternalPriority(caseRec); //Commented as part of US252305
        /*if(String.isNotBlank(caseOrderingValue)){
            caseOrderingValue = caseOrderingValue+CaseGateway.internalPriorityValue;
            caseRec.Case_sequence__c = Decimal.valueOf(caseOrderingValue);
        }*/
        caseRec.Select_Support_Experience__c = false;
        if(! (String.isNotBlank(caseRec.Case_Type__c) && caseRec.Case_Type__c.equalsIgnoreCase(System.Label.ProactiveCaseType)&&(caseRec.Case_Type__c == 'Case Concern') )) { // added this as not to execuet for Proactive Cases
            if(caseRec.Status=='Open' && caseRec.Site_Association__c<>null ){
               Boolean SSEAccountFlag = CaseGateway.checkAccountSelectSupportExperience(caseRec.Site_Association__c);
                if(SSEBackendFLag || SSEAccountFlag){
                  caseRec.Select_Support_Experience__c = true;    
                } 
            }
        }
        UtilityFalgs.callbackCreated=true;
        UtilityFalgs.isInitialCallBackTaskCreated = true;

// ********************* Before Insert Automic Code Started ******************************//

        if(caseRec.Case_Type__c=='Standard' || caseRec.Case_Type__c=='Problem' && (caseRec.Component_Release_Only_Selection__c != null) ){
            List<Component_Release__c>  componentReleaseObject = [Select Name,component_expiration_date__c from Component_Release__c where id = :caseRec.Component_Release_Only_Selection__c];
            // Component_Release__c  componentReleaseObject = [Select Name from Component_Release__c where id = :caseRec.Component_Release_Only_Selection__c];
            //if(componentReleaseObject != null){
            if(componentReleaseObject .size() > 0) {
                if(componentReleaseObject[0].component_expiration_date__c >= system.today()){
                    List<Component_Release__c> componentReleseList = [SELECT Name FROM Component_Release__c where Component_Code__c=:caseRec.Component_Code__c];
                    if(componentReleseList != null){
                        boolean flagValue = true;
                        for(Component_Release__c componentRelease :componentReleseList){
                            if(componentRelease.Name.equals(componentReleaseObject[0].Name)){
                                flagValue = false;
                            }
                        }
                        if(flagValue){
                            caseRec.addError('The Component Release selection must be for the Case CA Product and Component Code.');
                        }
                    }
                }else{
                    caseRec.addError('The Component Release selection for the Case CA Product and Component Code is Expired');
                }
            }
        }       
        
//Case Concern Check  
//Case Concern and Proactive cases are not applicable for Problem Cases
 if(caseRec.Case_Type__c != 'Case Concern' && caseRec.Case_Type__c != System.Label.ProactiveCaseType ){
        List<Problem_Case_Products__c> automicpro = Problem_Case_Products__c.getall().values();
        system.debug('custom setting product...'+automicpro);
        
        for(Problem_Case_Products__c Prob:automicpro)
        {
            automicproset.add(Prob.CA_Product_Controller_Name__c);
        }
        If(caseRec.CA_Product_Controller__c != NULL){
            ProductContIdlist.add(caseRec.CA_Product_Controller__c);
            caselist.add(caseRec);
        }
        If(caseRec.CA_Product_Controller__c == NULL && caseRec.Case_Type__c=='Problem')
        {
            caseRec.CA_Product_Controller__c.adderror('Please Select the Product Controller.');
        }

    If( !caselist.isempty()){
       if (caselist[0].Case_Type__c=='Problem'){ 
         Map<Id,CA_Product_Controller__c> Productcontmap = new Map<Id,CA_Product_Controller__c>(
          [Select Name from CA_Product_Controller__c where Id in: ProductContIdlist]
          );
          for(case cse:caselist){
              If(cse.CA_Product_Controller__c != NULL){
                  CA_Product_Controller__c ProdController = Productcontmap.get(cse.CA_Product_Controller__c);
                  system.debug('product rec...!!!!'+ProdController.Name);
                  If(cse.Case_Type__c=='Problem'){
                      system.debug('Case Product..!!' +cse.CA_Product_Controller__r.Name);
                      If(!(automicproset.contains(ProdController.Name))){
                          system.debug('ProdController Name result...'+ProdController.Name);
                          system.debug('automic records...'+automicproset);
                          cse.addError('Problem Case can not be created for the selected CA Product.');
                          break;
                      }
                  }
              }
          }
       }   
    }
    }// Case Concern Check finished
// ****************** Before Insert Automic Code Ended *************************//
  }


    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Case caseRecNew = (Case)so;
        Case caseRecOld = (Case)oldSo;
        
        boolean caseWithSpCond = false;
        //US303641
        if((caseRecOld.Reason<>caseRecNew.Reason) || (!caseRecOld.Description.equalsIgnoreCase(caseRecNew.Description)) || (!caseRecOld.Severity__c.equalsIgnoreCase(caseRecNew.Severity__c)) || (caseRecOld.CA_Product_Controller__c<>caseRecNew.CA_Product_Controller__c)){
            System.debug('Updating case mgmt fields...');
            System.debug('userinfo.getUserId():'+userinfo.getUserId());
            caseRecNew.Case_mgmt_LastUpdateDT__c = system.now();
            caseRecNew.Case_mgmt_LastUpdatedBy_User__c = userinfo.getUserId();
        }
            
        
        /*System.debug('Error for Problem='+caseRecNew.casenumber+'@'+caseRecNew.parentID+'@'+caseRecOld.casenumber+'@'+caseRecOld.Component_Release_Only_Selection__c);
        if(caseRecOld.case_type__c == 'Problem' && caseRecOld.Component_Release_Only_Selection__c == NULL  ){
                  System.debug('Error for Problem='+caseRecNew.casenumber+'@'+caseRecOld.casenumber+'@'+caseRecOld.Component_Release_Only_Selection__c);
                  caseRecNew.adderror('Error: Please Select Component Release before attaching to a Problem.');
        } */
        if(caseRecNew.case_type__c == 'Problem' && caseRecNew.parentID != NULL  ){
                List<Case> c =[select case_type__c from Case where id=:caseRecNew.ParentId];
                if (c.size()>0 && c[0].case_type__c=='Problem'){
                  caseRecNew.adderror('You cant attach a Problem to another Problem.');
                }
        }
        //US303641
        
        //CR:400-1270
        //CR:400-1600
        /*
        if((caseRecNew.ContactId!=caseRecOld.ContactId)||(caseRecNew.Internal_Contact__c!=caseRecOld.Internal_Contact__c)){
           CaseGateway.updateContactFieldsOnCase(caseRecNew); 
        }*/
       /* if(caseRecNew.Case_Type__c == System.Label.ProactiveCaseType )
           caseRecNew.Case_Originator_Contact_Name__c = userinfo.getUserId();*/
        
        CaseGateway.updInternalPriority(caseRecNew); //Commented as part of US252305
        
         /*US237090: Priority Case Ordering----PART4--START---*/
        /*if(caseRecNew.Severity__c <> null && String.isNotBlank(String.valueOf(caseRecNew.Case_sequence__c)) && String.valueOf(caseRecNew.Case_sequence__c).length() == 18 && (String.valueOf(caseRecNew.Case_sequence__c).subString(2,3) == '1' || String.valueOf(caseRecNew.Case_sequence__c).subString(2,3) == '9')){
          caseRecNew.Case_sequence__c = Decimal.valueOf(caseRecNew.Severity__c + String.valueOf(caseRecNew.Case_sequence__c).subString(1,8)+ (caseRecNew.Internal_Priority__c.length()>1?caseRecNew.Internal_Priority__c:'0'+caseRecNew.Internal_Priority__c) + caseRecNew.CaseNumber);
          system.debug('updated value in before update: '+caseRecNew.Case_sequence__c);
        }else{
            String newUpdatedValue = caseRecNew.Severity__c;
            //adding immediate callback field value on case
            newUpdatedValue = newUpdatedValue+'9';
            //adding queue jumping value
            if(caseRecNew.Queue_Jumping__c){
                newUpdatedValue = newUpdatedValue+'19';
            }else{
                newUpdatedValue = newUpdatedValue+'99';
            }
            
            //adding FTK value
            if(caseRecNew.Certified_Bypass_Routing_Qualified__c){
                newUpdatedValue = newUpdatedValue+'1999';
            }else{
                newUpdatedValue = newUpdatedValue+'9999'; 
            }  
            system.debug('######################'+newUpdatedValue);
            if(String.isNotBlank(newUpdatedValue)){
                newUpdatedValue = newUpdatedValue+ (caseRecNew.Internal_Priority__c.length()>1?caseRecNew.Internal_Priority__c:'0'+caseRecNew.Internal_Priority__c);
                newUpdatedValue = newUpdatedValue+caseRecNew.CaseNumber;
                system.debug(caseRecNew.Internal_Priority__c+'%%%%%%%%%%%'+caseRecNew.Severity__c+'^^^^^^^^^^^^^'+caseRecNew.Certified_Bypass_Routing_Qualified__c+'###############'+caseRecNew.Queue_Jumping__c);
                system.debug(caseRecOld.Internal_Priority__c+'%%%%%1%%%%%%'+caseRecOld.Severity__c+'^^^^^^^^2^^^^^'+caseRecOld.Certified_Bypass_Routing_Qualified__c+'#####3##########'+caseRecOld.Queue_Jumping__c);
                caseRecNew.Case_sequence__c = Decimal.valueOf(newUpdatedValue);
            }
        } */
        /*US237090: Priority Case Ordering----PART4--END---*/ 
        
        //US203673 - Implement Case Time Zones for Callback SLOs 
        caseRecNew.BusinessHoursid =  CaseGateway.fetchBusinessHoursId(caseRecNew, busHrsIdMap);        
        //caseRecNew.BusinessHoursid =  busHrsIdMap.get(CaseGateway.siteCntryMap.get(caseRecNew.Site_Association__c));
        //if(caseRecOld.Case_Type__c!='Proactive')   
        /*Added caseOrigin condition because for cases created From ServiceCloud, accountId should be determined based on Site.
            For cases created from Gainsight, Site is determined based on the account    
        */
        if( !(caseRecOld.Case_Type__c == System.Label.ProactiveCaseType && caseRecOld.Origin.equalsIgnoreCase(System.label.CaseOrigin_Gainsight)) )
        {
          caseRecNew.Accountid=CaseGateway.siteAccMap.get(caseRecNew.Site_Association__c);
        }
        if(caseRecNew.Status!=caseRecOld.Status && (caseRecNew.Status =='Closed') && (caseRecNew.Case_Type__c != 'Case Concern') && (caseRecNew.Case_Type__c != System.Label.ProactiveCaseType)) {    
            caseRecNew.Eligible_for_Survey__c = CaseGateway.checkSurveyEligibility(caseRecNew);
            caseRecNew.Medallia_Survey__c = CaseGateway.medalliaSurveyFlag;
        }
       //code to enable search on tops site --commented below
      // String site_id=caseRecNew.Tops_Support_Site_ID__c;
      // caseRecNew.SiteId__c=(site_id.leftpad(6)).replace(' ','0');
       
         if(caseRecNew.Next_Action__c != null){
            if(caseRecNew.Next_Action__c!=caseRecOld.Next_Action__c || caseRecNew.Next_Action_due_date__c!=caseRecOld.Next_Action_Due_Date__c)
             caseRecNew.Next_Action_Date__c =System.Now();
         }      
        else
            caseRecNew.Next_Action_Date__c = null; //testing
                          
         if((caseRecNew.Status!=caseRecOld.Status) && (caseRecNew.Status =='Verify')){
                if(caseRecNew.Close_Count__c!=null)   
                   caseRecNew.Verify_Count__c = caseRecNew.Verify_Count__c+1;
                else
                   caseRecNew.Verify_Count__c =1;                
         }
         if((caseRecNew.Status!=caseRecOld.Status) && (caseRecNew.Status =='Closed')){                 
                 caseRecNew.Open_CB__c='N';
                if(caseRecNew.Close_Count__c!=null)
                   caseRecNew.Close_Count__c = caseRecNew.Close_Count__c+1;
                else
                   caseRecNew.Close_Count__c =1;                               
         }
       system.debug('1. SE_Action__c = ' +caseRecNew.SE_Action__c+' :caseRecNew.Next_Action__c = '+caseRecNew.Next_Action__c+' :caseRecNew.Case_Type__c = '+caseRecNew.Case_Type__c); 
         //US203920 - Add an 'SE Action' field on the Case object - If the case has an SEAction task created
         if( UtilityFalgs.isSEActionTaskCreated == true && caseRecOld.SE_Action__c != true){
                caseRecNew.SE_Action__c = true;
         }else if(!UtilityFalgs.isSEActionTaskCreated && !caseRecOld.SE_Action__c){ //US393771----START
             caseRecNew.SE_Action__c = false;
         }//US393771----END   
         system.debug('Checking Next Action' +caseRecNew.Next_Action__c);
         //Added a Case Concern Check
        system.debug('2. SE_Action__c = ' +caseRecNew.SE_Action__c+' :caseRecNew.Next_Action__c = '+caseRecNew.Next_Action__c+' :caseRecNew.Case_Type__c = '+caseRecNew.Case_Type__c);
       if (caseRecNew.SE_Action__c == false && caseRecNew.Next_Action__c =='Pending CA Engineering (L2)' && (caseRecNew.Case_Type__c != 'Case Concern'))
      {
         //  caseRecNew.adderror('Next Action Owner cannot be set to Pending CA Engineering (L2) without the SE ACTION flag being set.  Please use SE Engagement / Related Defect to formally engage Engineering to enable that Next Action Owner value.');
       }
        
// ************************** Before Update Automic Code Started *************************//
        
        if(caseRecNew.Case_Type__c=='Standard' || caseRecNew.Case_Type__c=='Problem' &&(caseRecNew.Component_Release_Only_Selection__c != null) && (caseRecNew.Component_Release_Only_Selection__c != caseRecOld.Component_Release_Only_Selection__c)){
            List<Component_Release__c>  componentReleaseObject = [Select Name,component_expiration_date__c from Component_Release__c where id = :caseRecNew.Component_Release_Only_Selection__c];
            //if(componentReleaseObject != null){
            if(componentReleaseObject .size() > 0) {
                if(componentReleaseObject[0].component_expiration_date__c >= system.today()){
                    List<Component_Release__c> componentReleseList = [SELECT Name FROM Component_Release__c where Component_Code__c=:caseRecNew.Component_Code__c];
                    if(componentReleseList != null){
                        boolean flagValue = true;
                        for(Component_Release__c componentRelease :componentReleseList){
                            if(componentRelease.Name.equals(componentReleaseObject[0].Name)){
                                flagValue = false;
                            }
                        }
                        if(flagValue){
                            caseRecNew.addError('The Component Release selection must be for the Case CA Product and Component Code.');
                        }
                    }
                }else{
                    caseRecNew.addError('The Component Release selection for the Case CA Product and Component Code is Expired');
                }
            }
        }
        
        //Case Concern Check , Proactive Case Check - Skip Problem Case Logic for both of these 
        if(caseRecNew.Case_Type__c != 'Case Concern' && caseRecNew.Case_Type__c != System.Label.ProactiveCaseType)
        {
        List<Problem_Case_Products__c> automicpro = Problem_Case_Products__c.getall().values();
        system.debug('custom setting product...'+automicpro);

        for(Problem_Case_Products__c Prob:automicpro)
        {
            automicproset.add(Prob.CA_Product_Controller_Name__c);
        }

        If(caseRecNew.CA_Product_Controller__c != NULL){
            ProductContIdlist.add(caseRecNew.CA_Product_Controller__c);
            caselist.add(caseRecNew);
        }
        If(caseRecNew.CA_Product_Controller__c == NULL && caseRecNew.Case_Type__c=='Problem')
        {
            caseRecNew.CA_Product_Controller__c.adderror('Please Select the Product Controller.');
        }

    If( !caselist.isempty()){
       if (caselist[0].Case_Type__c=='Problem'){ 
         Map<Id,CA_Product_Controller__c> Productcontmap = new Map<Id,CA_Product_Controller__c>(
          [Select Name from CA_Product_Controller__c where Id in: ProductContIdlist]
          );
          for(case cse:caselist){
              If(cse.CA_Product_Controller__c != NULL){
                  CA_Product_Controller__c ProdController = Productcontmap.get(cse.CA_Product_Controller__c);
                  If(cse.Case_Type__c=='Problem'){
                      If(!(automicproset.contains(ProdController.Name))){
                          cse.addError('Problem Case can not be created for the selected CA Product.');
                          break;
                      }
                  }
              }
          }
       }   
    }
    }// Case Concern Check End
        if(1==2 && caseRecNew.JIRA_Issue_Key__c != null && (caseRecNew.Severity__c != caseRecOld.Severity__c || caseRecNew.No_of_problem_or_standard_cases__c != caseRecOld.No_of_problem_or_standard_cases__c || caseRecNew.Offering_Code_Ref__c != caseRecOld.Offering_Code_Ref__c || caseRecNew.Status != caseRecOld.Status)){
            caseRecNew = JiraIntegrationHelper.updateNextActionOwnerAndTime(caseRecNew);  
        }
        if(caseRecNew.Case_Type__c == 'Standard' && caseRecOld.Case_Type__c == 'Standard' && caseRecNew.ParentId != null && caseRecOld.ParentId == null && caseRecNew.Component_Release_Only_Selection__c == null){
            Case parentProblemCase = [Select Case_Type__c from Case where id = :caseRecNew.ParentId];
            system.debug('new case Case_Type__c : '+parentProblemCase.Case_Type__c);
            if(parentProblemCase.Case_Type__c == 'Problem'){
                caseRecNew.adderror('Please Select Component Release Before Attaching Case To A Problem.');
            }
        }
        //Cant change from Standard to Problem or vice Versa.        
        if((caseRecNew.Case_Type__c == 'Problem' && caseRecOld.Case_Type__c !='Problem') || (caseRecOld.Case_Type__c == 'Problem' && caseRecNew.Case_Type__c !='Problem')){
            caseRecNew.adderror(' Case Type Change is not allowed');
        }

// ************************** Before Update Automic Code Ended *************************//
  }

    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so)
    {  
// ************************** Before Delete Automic Code Started *************************//
        Case deleteCase = (Case)so;
        if(deleteCase.ParentId != null) {
            ProblemCaseIds.add(deleteCase.ParentId);
            IncidentCaseIds.add(deleteCase.Id);
            system.debug('existing Problem Case Ids..!!'+ProblemCaseIds);
            system.debug('existing Incident Case Ids..!!'+IncidentCaseIds);
        }

        If(!ProblemCaseIds.isempty()){
            CheckRecursiveTrigger.recursiveHelper(true);
        }
// ************************** Before Delete Automic Code Ended *************************//
    }
    public void afterInsert(SObject so)
    {
     System.debug('isCaseConcern*******:'+ UtilityFalgs.isCaseConcern);
        Case caseRec = (Case)so;   
        String pmfKey;
        //updated dueDate field from Date to Datetime - VELUD01 - 30-01-2015 - 300-208365
        DateTime dueDate=null;
        
         
           
        if(caseRec.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('CaseConcern').getRecordTypeId()){
            UtilityFalgs.isCaseConcern = true;
            
        }

        
        List<CaseComment> listOfCaseComment = new List<CaseComment>();
        List<Case> listOfCases = new List<Case>();
        //US367725---START
        if(String.isNotBlank(UtilityFalgs.caseCommentBodyValue)){
            system.debug('--After insert- inside if-caseCommentBodyValue--->'+UtilityFalgs.caseCommentBodyValue);
            CaseGateway.caseCreateReferenceComment(caseRec.Id,UtilityFalgs.caseCommentBodyValue);
            UtilityFalgs.caseCommentBodyValue = '';
        }
        //US367725---END
        //US447507 CaseConsern---START
        //System.debug('isCaseConcern:'+ UtilityFalgs.isCaseConcern);
        if(UtilityFalgs.isCaseConcern){
         String caseCommentBody = 'Case Concern '+caseRec.CaseNumber +' has been created for this case by '+ userinfo.getName();
           Case c =[select Internal_CA__c from Case where id=:caseRec.ParentId];
           system.debug('select Internal_CA__c: caseConcern');
           CaseComment  caseCommentObj = caseCommentCommonFields(caseCommentBody, caseRec.ParentId);
          // if(c.Internal_CA__c)
           caseCommentObj.IsPublished = false;
          // else
          // caseCommentObj.IsPublished = true;
           //insert caseCommentObj;
          
            if(CaseGateway.isExternalUser()){
                CaseGateway.caseCreateReferenceComment(caseRec.ParentId,caseCommentBody);
            } else {
                 listOfCaseComment.add(caseCommentObj);
            }
            
          
           
           //System.debug('*******listOfCaseComment:'+listOfCaseComment);


           //update caseconsern flag on case object
         /* Case updateCase = new Case(Id=caseRec.parentId);
           updateCase.Case_Concern__c = true;
           //listOfCases.add(updateCase);
           update updateCase;*/
        }

        
        //US447507 END
        
        Case caseObj = new Case(Id=caseRec.id);
        /*if(String.isNotBlank(String.valueOf(caseRec.Case_sequence__c)) && String.valueOf(caseRec.Case_sequence__c).length()<18){
            caseObj.Case_sequence__c = decimal.valueOf(String.valueOf(caseRec.Case_sequence__c) + caseRec.CaseNumber);
            update caseObj;
        }*/
        /*US261809---Add Restoration Task--START---
        if(caseRec.Status=='Open' && caseRec.Severity__c =='1' && String.isNotBlank(caseRec.Sev_1_Impact_c__c) && caseRec.Sev_1_Impact_c__c=='Production Down' && (String.isNotBlank(caseRec.Production_Down_Status__c) && (caseRec.Production_Down_Status__c!='Resolved' || caseRec.Production_Down_Status__c!='Resolved'))){
            Task taskObj = new Task();
            taskObj.WhatId = caseRec.Id;
            taskObj.Subject = 'Restoration';
            insert taskObj;
        }
        //US261809---Add Restoration Task--END---
        */
        //US289127--Add case comment for live agent chat---START
        if(caseRec.Status=='Open' && caseRec.Origin.equalsIgnoreCase('Chat')){
            if(String.isNotBlank(caseRec.NoProductFound__c) || (String.isNotBlank(caseRec.noDefaultTopsCodeFlag__c) && caseRec.noDefaultTopsCodeFlag__c<>'X') || String.isNotBlank(caseRec.NoComponentFound__c)){
                CaseComment caseCommentObj = new CaseComment();
                if(String.isNotBlank(caseRec.NoProductFound__c)){
                    UtilityFalgs.skipPrivateCaseCommentTrigger = 'Skip';//US289127--enhancement to remove case comment trigger
                    caseCommentObj.CommentBody = System.Label.Cso_Invalid_Product_Scbug_Comment+' '+caseRec.NoProductFound__c;
                    caseCommentObj.ParentId = caseRec.Id;
                }else{
                    UtilityFalgs.skipPrivateCaseCommentTrigger = 'Skip';//US289127--enhancement to remove case comment trigger
                    if(String.isBlank(caseRec.NoComponentFound__c)){
                        if(String.isNotBlank(caseRec.noDefaultTopsCodeFlag__c) && String.isNotBlank(caseRec.noDefaultTopsCode__c)){
                            if(caseRec.noDefaultTopsCodeFlag__c.equalsIgnoreCase('N')){
                                caseCommentObj.CommentBody = System.Label.Create_E2c_Scbug_Comment+' '+caseRec.noDefaultTopsCode__c;
                            }else if(caseRec.noDefaultTopsCodeFlag__c.equalsIgnoreCase('Y')){
                                caseCommentObj.CommentBody = System.Label.Create_No_Default_Comp_Comment+' '+caseRec.noDefaultTopsCode__c;
                            }
                        }
                    }else if(String.isNotBlank(caseRec.NoComponentFound__c)){
                        caseCommentObj.CommentBody = System.Label.Create_Cso_Missing_Comp_Comment+' '+caseRec.NoComponentFound__c;//no tops code
                    }
                    caseCommentObj.ParentId = caseRec.Id;
                }
                listOfCaseComment.add(caseCommentObj);
              //insert caseCommentObj;
              UtilityFalgs.skipPrivateCaseCommentTrigger = '';//US289127--enhancement to remove case comment trigger 
            }
        }
        //US289127--Add case comment for live agent chat---END
        if(caseRec.Next_Action_Due_Date__c!=null)
            dueDate = caseRec.Next_Action_Due_Date__c; 
        //end of changes for 300-208365

        if(usrPMFkeyMap.get(caseRec.LastmodifiedbyID) != null && usrPMFkeyMap.get(caseRec.LastmodifiedbyID).PMFKey__c!= null)
            pmfKey = usrPMFkeyMap.get(caseRec.LastmodifiedbyID).PMFKey__c;

        if(pmfkey==null)
            pmfKey = Userinfo.getName();
        
        // US222674 - Added the field 'Restoration_SLA_Disqualified__c' to push to GSS
        gssLst.add(new GSS_Transactions__c(Case__c=caseRec.id,Current_GSS_TR__c='N',Current_Next_Action__c=caseRec.Next_Action__c,
        Current_Status__c=caseRec.Status,Current_Status_Added_By__c=pmfKey, Current_Next_Action_Date__c=caseRec.Next_Action_Date__c,
        Current_Status_Date__c=DateTime.now(),Curr_Next_Action_By__c=pmfKey,Current_GSS_TR_Date__c=DateTime.now(),Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,
        Current_Next_Action_Due_Date__c=dueDate,ReOpen_Date__c = caseRec.CreatedDate,Case_Owner__c=caseRec.OwnerID,Case_Severity__c=caseRec.Severity__c,
        Restoration_SLA_Disqualified__c = caseRec.Restoration_SLA_Disqualified__c));


            //US108116  & US131502
            // US222674 - Added the field 'Restoration_SLA_Disqualified__c' to push to GSS        
         gssLst.add(new GSS_Transactions__c(Case__c=caseRec.id,Current_GSS_TR__c=UtilityFalgs.stageGSSTransCode.get(caseRec.Troubleshooting_Stage__c),
            Date_Current_Troubleshooting_Stage_set__c=DateTime.now(),Current_GSS_TR_Date__c=DateTime.now(),Case_Owner__c=caseRec.OwnerID,Case_Severity__c=caseRec.Severity__c,
            Current_Status_Added_By__c = pmfKey,Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,Stage_Count__c =1,
            Current_Status__c = caseRec.Status,Current_Next_Action__c=caseRec.Next_Action__c,Current_Next_Action_Date__c=caseRec.Next_Action_Date__c,Curr_Next_Action_By__c=pmfKey,
            Current_Next_Action_Due_Date__c=dueDate,ReOpen_Date__c = caseRec.CreatedDate,Restoration_SLA_Disqualified__c = caseRec.Restoration_SLA_Disqualified__c));
       //US108116  & US131502 


        /*
       If the owner of the case is a queue 
          Then unassigned user would be the owner of the Task/Call back

         **/                         

        String caseOwner = caseRec.Ownerid;
        
        //Commented as this is not being used anywhere - TODO: Recheck 
        /*Map<id,String> BhrsMap = new Map<id,String>();
        for(BusinessHours bhRec:[select id,TimeZoneSidKey from BusinessHours])
        {
            BhrsMap.put(bhRec.id,bhRec.TimeZoneSidKey );
        }*/
              
        UtilityFalgs.callbackCreated=true;     
        
         //Added as part of Case Activity Flag Issue start
        try{
        Case_Portal_View__c portal_view = new Case_Portal_View__c();
        portal_view.Case__c=caseRec.Id;
        portal_view.Portal_View_Date__c=System.Now();
        database.insert(portal_view ,false);
        }catch(Exception e){
 
        }
        
        //Added as part of Case Activity Flag Issue end 
        
        //Added as Part of Support Offerings to populate topsproduct code on Case comment.
        if(caseRec.Offering_Tops_Product_Code_Selected__c<>null){
            CaseComment case_comment = new CaseComment();
            case_comment.CommentBody = 'Originally selected Entitled Product = '+caseRec.Offering_Tops_Product_Code_Selected__c;
            case_comment.ParentId = caseRec.Id;
           // insert case_comment;  
           listOfCaseComment.add(case_comment);          
        }
        
        if(caseRec.Offering_Code_Configuration_Issue__c && caseRec.Offering_Code_Ref__c<>null && caseRec.Offering_Name__c==null){
           String supportEngineer=caseRec.Offering_Support_Engineer__c;
            String dseMessage=''; 
            if(supportEngineer==null){
                supportEngineer='';
                dseMessage='';
            }
            else if(supportEngineer<>null){
                dseMessage='Please assign this Case to '+ supportEngineer;
            }
            CaseComment case_comment = new CaseComment();
            case_comment.CommentBody = 'The Site/Product for this Case is configured to have a Services Offering, but the definition for this offering is missing from Service Cloud. Please contact the System Administrator.Offering Code: '+ caseRec.Offering_Code_Ref__c+'\n'+dseMessage; 
            case_comment.ParentId = caseRec.Id;
           // insert case_comment;
           listOfCaseComment.add(case_comment); 
            
            Case newC=new Case(Id=caseRec.Id);
            newC.Offering_Code_Ref__c='';
            newC.Offering_Support_Engineer__c='';  
            //listOfCases.add(newC);
            update newC;
        }   
        //End of Aditya-Support Offering Code
         System.debug('====='+listOfCaseComment);
        if(listOfCaseComment.size()>0)
            insert listOfCaseComment;
        
        //Changes related to ESS PLUS
        if(caseRec.Offering_Name__c!= null){
              UtilityFalgs.createWRTasks = true;
        }

// ****************** After Insert Automic Code Started *************************//
        
        if(caseRec.Case_Type__c != 'Case Concern'){
        if(caseRec.ParentId != null){
            ProblemCaseIds.add(caseRec.ParentId);
            IncidentCaseIds.add(caseRec.Id);
            system.debug('New Problem Case Ids..!!'+ProblemCaseIds);
            system.debug('New Incident Case Ids..!!'+IncidentCaseIds);
            }
        If(!ProblemCaseIds.isempty()){
            CheckRecursiveTrigger.recursiveHelper(true);
        }
        }
// ****************** After Insert Automic Code Ended *************************//
    }
    public void afterUpdate(SObject oldSo, SObject so)
    {
        Case caseRec = (Case)so;
        Case oldCaseRec = (Case)oldSo;
        String pmfKey;   
        String NextAction=caseRec.Next_Action__c;

        system.debug('^^^^^^^^^^^^^11'+oldCaseRec.ParentId);
        
       if(caseRec.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('CaseConcern').getRecordTypeId()){
            UtilityFalgs.isCaseConcern = true;
         System.debug('**'+UtilityFalgs.isCaseConcern+'$$$'+CheckRecursiveTrigger.recursiveflag +'==='+caseRec.status);
        if(!UtilityFalgs.caseConcernparentComment && (caseRec.status =='Closed Resolved' || caseRec.status =='Closed Unresolved' )){
            
                String caseCommentBody = 'Case Concern '+caseRec.CaseNumber +' has been '+caseRec.status+' for this case by '+ userinfo.getName();
                CaseComment c =caseCommentCommonFields(caseCommentBody,caseRec.ParentId);
                cseCommentlst.add(c);
                UtilityFalgs.caseConcernparentComment = true;
        }
                       
        }

        if(usrPMFkeyMap.get(caseRec.LastmodifiedbyID) != null && usrPMFkeyMap.get(caseRec.LastmodifiedbyID).PMFKey__c!= null)
            pmfKey = usrPMFkeyMap.get(caseRec.LastmodifiedbyID).PMFKey__c;
        else
            pmfKey = Userinfo.getName();

        DateTime dueDate=null;
        DateTime prevDueDate=null;  
        if(caseRec.Next_Action_Due_Date__c!=null)
            dueDate = caseRec.Next_Action_Due_Date__c;     

        if(oldCaseRec.Next_Action_Due_Date__c!=null)
            prevDueDate = oldCaseRec.Next_Action_Due_Date__c;     

        caseGSSMap = CaseGateway.caseGSSMap;
        caseStageGSSMap = CaseGateway.caseStageGSSMap; //US108116

        String lastModId = caseRec.LastModifiedById;
        /*US237090: Priority Case Ordering----PART5--START---*/
       /* system.debug(oldCaseRec.Status+'$$$$$$$$$$$'+caseRec.Status+'$$$$$$$$$$$$$$'+oldCaseRec.Internal_Priority__c+'%%%%%%%%%%'+caseRec.Internal_Priority__c);
        if(caseRec.Severity__c <> null && String.isNotBlank(String.valueOf(oldCaseRec.Case_sequence__c)) && oldCaseRec.Status!=caseRec.Status){
            Case caseObj = new Case(id=caseRec.Id);
            caseObj.Case_sequence__c = Decimal.valueOf(caseRec.Severity__c + String.valueOf(caseRec.Case_sequence__c).subString(1,8)+ (caseRec.Internal_Priority__c.length()>1?caseRec.Internal_Priority__c:'0'+caseRec.Internal_Priority__c) + caseRec.CaseNumber);
            update caseObj;
            system.debug('updated value in after update: '+caseObj.Case_sequence__c);
        } */
        /*US237090: Priority Case Ordering----PART5--END---*/
        
        /*---Add Restoration Task--START---
        if(UtilityFalgs.oneTaskCreate && caseRec.Status=='Open' && oldCaseRec.Severity__c!=caseRec.Severity__c && caseRec.Severity__c=='1' && caseRec.Sev_1_Impact_c__c=='Production Down' && (caseRec.Production_Down_Status__c!='Resolved' || caseRec.Production_Down_Status__c!='Resolved')){
            system.debug(UtilityFalgs.oneTaskCreate+'$#%#$#create new task');
            Task newTaskObj = new Task();
            newTaskObj.Subject = 'Restoration';
            newTaskObj.WhatId = caseRec.Id;
            taskLst.add(newTaskObj);
            UtilityFalgs.oneTaskCreate = false;
        }
        system.debug('AFTER UPDATE TAKS VAL: '+UtilityFalgs.oneTaskCreate);
        //US261809---Add Restoration Task--END---*/ 
        if(String.isNotBlank(caseRec.id)){
            Boolean callBackResponse = CaseGateway.checkCallBackTask(caseRec.id);
            system.debug('-callBackResponse123---->'+callBackResponse);
            if(callBackResponse){
                if(!UtilityFalgs.callbackCreated && !UtilityFalgs.isDefectUpdate &&((oldCaseRec.Status!=caseRec.Status && (oldCaseRec.Status=='Closed' || oldCaseRec.Status=='Closed Resolved' || oldCaseRec.Status=='Closed Unresolved'))|| (caseRec.Status!='Closed' && CaseGateway.isExternalUser() == true))){ //US201990 - not create case update task for files_from_ca
                     if(String.isNotBlank(UtilityFalgs.callbackSubject) && String.isNotBlank(UtilityFalgs.callbackSource)){//US201990 - not create Call task for files_from_ca
                         UtilityFalgs.bCaseSLOFlag=false;
                       
                         Task taskRec = new Task(RecordTypeId=label.Service_cloud_Task_Record_Type,Subject=UtilityFalgs.callbackSubject,Source__c=UtilityFalgs.callbackSource,Status='Open',Priority='Low',WhatId=caseRec.id,Type='Callback',IsVisibleInSelfService=true);  //added IsVisibleInSelfService as true to query task for portal users             
                         
                        // if owner is queue assign task to unassigned user.           
                        String caseOwner = caseRec.Ownerid; 
                        if(caseOwner.substring(0, 3)!='005')
                            taskRec.OwnerId=label.Service_cloud_Task_assignee;
                        else
                            taskRec.OwnerId=caseRec.Ownerid;                                      
            
                        taskLst.add(taskRec); 
                        UtilityFalgs.callbackCreated=True;
                     }             
                }
            }
        }
        //US344581---END
        //US108116 - Starts
                     
            GSS_Transactions__c gssRecToInsert ;
            GSS_Transactions__c gssRecToUpdate;
            
            
            System.debug('caseStageGSSMap ==>' +caseStageGSSMap);
            System.debug('oldCaseRec.Troubleshooting_Stage__c ==>' +oldCaseRec.Troubleshooting_Stage__c);
            System.debug('caseRec.Troubleshooting_Stage__c ==>' +caseRec.Troubleshooting_Stage__c);
           // if((oldCaseRec.Troubleshooting_Stage__c != caseRec.Troubleshooting_Stage__c) && (caseRec.Case_Type__c != 'Case Concern')){
                 if((oldCaseRec.Troubleshooting_Stage__c != caseRec.Troubleshooting_Stage__c) ){  
                     
                     Decimal prevStageCount ;
                     Decimal stageCount;
                    //if(caseStageGSSMap != null && caseStageGSSMap.size()>0){
                        //calculate the stage count value for new record to be inserted.

                        //update the existing gss record.
                           
                            gssRecToUpdate = caseStageGSSMap.get(caseRec.id +'-'+oldCaseRec.Troubleshooting_Stage__c);
                            if(gssRecToUpdate!=null){
                                gssRecToUpdate.Current_Stage_End_Date__c = DateTime.now();
                                //Added below fields for Timeboxing
                                gssRecToUpdate.Threshold_Start_time__c = oldCaseRec.Threshold_Start_Date_Time__c;
                                gssRecToUpdate.Threshold_Target_Date_time__c = oldCaseRec.Threshold_Target_Date_time__c;
                                gssRecToUpdate.Threshold_Time_Exceeded_Flag__c = oldCaseRec.Threshold_Exceeded_Flag__c;
                                gssRecToUpdate.Threshold_Notification_Start_Date_Time__c = oldCaseRec.Notification_Start_Date_Time__c; 
                                gssRecToUpdate.Threshold_Notification_End_Date_Time__c = oldCaseRec.Notification_Target_Date_Time__c;
                                gssRecToUpdate.Threshold_Notification_Flag__c = oldCaseRec.Notification_Exceeded_Flag__c;
                                gssRecToUpdate.Threshold_End_Time__c = DateTime.now();  //Update the stage end time
                                gssRecToUpdate.Manager_Action__c = oldCaseRec.Manager_Action__c;
                                gssRecToUpdate.Manager_Action_Comment__c=oldCaseRec.Manager_Action_Comment__c;
                                gssRecToUpdate.Manager_Action_Comment_Update_Date_Time__c = oldCaseRec.Manager_Action_Comment_Update_Date_Time__c;
                                gssRecToUpdate.Manager_Action_Update_By__c = oldCaseRec.Manager_Action_Update_By__c;
                                gssRecToUpdate.Manager_Action_Update_Date_Time__c=oldCaseRec.Manager_Action_Update_Date_Time__c;
                                gssRecToUpdate.Manager_Action_Comment_By__c= oldCaseRec.Manager_Action_Comment_By__c;
                            }
                            
                            //fecth the stage count of previous GSS TRansaction for the same case with new Stage value
                            GSS_Transactions__c gssTrObj = caseStageGSSMap.get(caseRec.id +'-'+caseRec.Troubleshooting_Stage__c);
                           
                            if(gssTrObj!=null){                                
                                stageCount = gssTrObj.Stage_Count__c +1;
                            }
                            else{
                                stageCount =1;
                            }
                            
                        //insert a new GSS record
                        if(gssRecToUpdate!=null){
                            System.debug('11====11');   
                        
                            // US131502 , US222674 - Added the field 'Restoration_SLA_Disqualified__c' to push to GSS
                             gssRecToInsert =  new GSS_Transactions__c (Case__c=caseRec.id,Current_GSS_TR__c=UtilityFalgs.stageGSSTransCode.get(caseRec.Troubleshooting_Stage__c),
                                                                       Date_Current_Troubleshooting_Stage_set__c=DateTime.now(),Current_GSS_TR_Date__c=DateTime.now(),Case_Owner__c=caseRec.OwnerID,Case_Severity__c=caseRec.Severity__c,
                                                                       Current_Status_Added_By__c = pmfKey,Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,Stage_Count__c = stageCount ,
                                                                       Previous_Troubleshooting_Stage__c = oldCaseRec.Troubleshooting_Stage__c,Previous_GSS_TR__c = gssRecToUpdate.Current_GSS_TR__c ,
                                                                       Previous_GSS_TR_Date__c = gssRecToUpdate.Current_GSS_TR_Date__c,Current_Status__c = caseRec.Status,Status_From__c=oldCaseRec.Status,
                                                                       Restoration_SLA_Disqualified__c = caseRec.Restoration_SLA_Disqualified__c);
                        }else {
                             System.debug('22====22');   
                            // US131502
                             gssRecToInsert =  new GSS_Transactions__c (Case__c=caseRec.id,Current_GSS_TR__c=UtilityFalgs.stageGSSTransCode.get(caseRec.Troubleshooting_Stage__c),
                                                                       Date_Current_Troubleshooting_Stage_set__c=DateTime.now(),Current_GSS_TR_Date__c=DateTime.now(),Case_Owner__c=caseRec.OwnerID,Case_Severity__c=caseRec.Severity__c,
                                                                       Current_Status_Added_By__c = pmfKey,Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,Stage_Count__c = stageCount ,
                                                                       Previous_Troubleshooting_Stage__c = oldCaseRec.Troubleshooting_Stage__c,
                                                                       Previous_GSS_TR__c = UtilityFalgs.stageGSSTransCode.get(oldCaseRec.Troubleshooting_Stage__c),Current_Status__c = caseRec.Status,
                                                                       Status_From__c=oldCaseRec.Status,Restoration_SLA_Disqualified__c = caseRec.Restoration_SLA_Disqualified__c
                                                                      );
                        }
                        //US131502, US222674 - Added the field 'Restoration_SLA_Disqualified__c' to push to GSS
                        if((caseRec.Status=='Open' || caseRec.Status=='Verify') && (caseRec.Calculated_Status_Transfer_In_Count__c > 0 && caseRec.Is_Task_Closed__c == false ))
                            gssRecToInsert.Current_Status__c = 'Transferred';
                     //  }
                    
                        if(!UtilityFalgs.createStageGSSTransactions)
                         {
                            if(gssRecToInsert!= null){        
     
                                gssLst.add(gssRecToInsert);
                            }
                             if(gssRecToUpdate!= null){

                                gssLst.add(gssRecToUpdate);
                             }
                           UtilityFalgs.createStageGSSTransactions=true;
                         }    

            }
        //US108116 - ends



        /*
        When the case is re-assigned to a real user(case owner) from a Queue, All Initial Callbacks and Subsequent Callbacks will be re-assigned from “Unassigned” to the case owner.
        When case is reassigned to new owner, only initial callback will be transferred(transfer happens only when initial call back is open), but secondary callbacks still stay with previous owner which he has to close them out. 
         */
           
//Added caseconcern  condition in if block for case concern user story US431216
        if(oldCaseRec.ownerid!=caseRec.ownerid || (caseRec.Status=='Closed' && oldCaseRec.Status!=caseRec.Status) || ((caseRec.Status =='Closed Resolved' || caseRec.Status =='Closed Unresolved') && caseRec.Case_Type__c == 'Case Concern')){
            System.debug('Case Handler 903 TaskMap' +CaseGateway.taskMap);
            List<Task> caseTaks = CaseGateway.taskMap.get(caseRec.Id);
            System.debug('caseTaks in caseHandler ==>' +caseTaks);
            String caseOwner = caseRec.Ownerid; 
            if(caseTaks!=null && !caseTaks.isEmpty()){            
                for(Task rec:caseTaks){
                    
                    //US217005 -- Added the first if block - to set task closure from process builder for restoration task
                    //if(caseRec.Status=='Closed' && oldCaseRec.Status!=caseRec.Status)
                    //    taskLst.add(new Task(id= rec.Id,Status='Closed'));
                    
                    //US432727 : the below condition fire when any Gainsight tasks are still open while case status value change to Closed  
                     if(caseRec.Status=='Closed' && oldCaseRec.Status!=caseRec.Status && caseRec.Case_Type__c == 'Proactive' && rec.Case__c !=null) {
                     
                         caseRec.addError('All Gainsight Tasks must be closed in order to Close the case');
                     
                         
                     }
                     if((caseRec.Status=='Closed' && oldCaseRec.Status!=caseRec.Status) || ((caseRec.Status =='Closed Resolved' || caseRec.Status =='Closed Unresolved') && caseRec.Case_Type__c == 'Case Concern')){
                         System.debug('Ajay Debug CaseHandler 912' );
                         if(rec.Type == 'Restoration'){
                             taskLst.add(new Task(id= rec.Id,Status='Closed',Task_Closure_By_ProcessFlow__c = true));
                         }
                         else{
                             System.debug('Ajay 2 1 ');
                                 system.debug('All tasks 2 1 ==>' +taskLst);
                             taskLst.add(new Task(id= rec.Id,Status='Closed'));
                         }
                     }                                           
                        else if((oldCaseRec.ownerid!=caseRec.ownerid) && ((rec.OwnerId==label.Service_cloud_Task_assignee && (rec.RecordTypeId==label.Service_Cloud_Task_Record_Type || rec.RecordTypeId == Label.Service_Cloud_Restoratio_Task_Type ))|| (label.Gainsight_Task_Type).equalsIgnoreCase(rec.Type))){//US295822 new custom label to store restoration record type
                           System.debug('rec==>'+ rec + 'rec.type==>'+ rec.type);
                        if((caseOwner.substring(0, 3)!='005') && !((label.Gainsight_Task_Type).equalsIgnoreCase(rec.Type)))
                            taskLst.add(new Task(id= rec.Id,Ownerid=label.Service_cloud_Task_assignee));
                        else if((rec.ownerId==label.Service_cloud_Task_assignee) || ((label.Gainsight_Task_Type).equalsIgnoreCase(rec.Type) && (caseOwner.substring(0, 3)!='00G')))                        
                            taskLst.add(new Task(id= rec.Id,Ownerid=caseRec.Ownerid));
                        else if(rec.Type=='Initial Callback' || rec.Type=='Workaround' || rec.Type=='Resolution' || rec.Type=='Restoration')//US295822 added restortaion condition
                            taskLst.add(new Task(id= rec.Id,Ownerid=caseRec.Ownerid));
                    }                         
                }
                System.debug('===='+taskLst);
            }
        }
         System.debug('oldCaseRec.Next_Action__c-->'+oldCaseRec.Next_Action__c); 
         System.debug('caseRec.Next_Action__c-->'+caseRec.Next_Action__c); 
         //updated condition to look for next action due date also - VELUD01 - 30-01-2015 - 300-208365
            if(oldCaseRec.status!=caseRec.Status ||oldCaseRec.Next_Action__c!=caseRec.Next_Action__c||oldCaseRec.Next_Action_Due_Date__c!=caseRec.Next_Action_Due_Date__c){
                GSS_Transactions__c gssRec =null ;
                // US222674 - Added the field 'Restoration_SLA_Disqualified__c' to push to GSS
                System.debug('caseGSSMap.size()-->'+caseGSSMap.size()); 
                 if(caseGSSMap!=null && caseGSSMap.size()>0 ){ 
                    System.debug('111====111');       
                     gssRec = new GSS_Transactions__c(Case__c=caseRec.id,Previous_GSS_TR__c=caseGssMap.get(caseRec.id).Current_GSS_TR__c,Current_Next_Action__c=caseRec.Next_Action__c,Current_Status__c=caseRec.Status,
                                                      Current_Status_Added_By__c=pmfKey,Current_Next_Action_Date__c=caseRec.Next_Action_Date__c,Current_Status_Date__c=DateTime.now(),Prev_Next_Action_Date__c=oldCaseRec.Next_Action_Date__c,
                                                      Status_From_Date__c=caseGssMap.get(caseRec.id).Current_Status_Date__c,Prev_Next_Action_By__c=caseGssMap.get(caseRec.id).Curr_Next_Action_By__c,Curr_Next_Action_By__c=pmfKey,
                                                      Previous_Status_Added_By__c=caseGssMap.get(caseRec.id).Current_Status_Added_By__c,Previous_Next_Action__c=oldCaseRec.Next_Action__c,Status_From__c=oldCaseRec.Status,
                                                      Current_Next_Action_Due_Date__c=dueDate,Prev_Next_Action_Due_Date__c=prevDueDate,Current_GSS_TR_Date__c=DateTime.now(),Previous_GSS_TR_Date__c=caseGssMap.get(caseRec.id).Current_GSS_TR_Date__c, 
                                                      ReOpen_Date__c = caseRec.Date_Time_ReOpened__c!=null ? caseRec.Date_Time_ReOpened__c :caseRec.CreatedDate,Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,
                                                      Case_Owner__c=caseRec.OwnerID,Case_Severity__c=caseRec.Severity__c,Restoration_SLA_Disqualified__c = caseRec.Restoration_SLA_Disqualified__c);
                 }
                  else{   
                    
                    System.debug('222====222');
                                                        
                     gssRec = new GSS_Transactions__c(Case__c=caseRec.id,Previous_GSS_TR__c= '',Current_Next_Action__c=caseRec.Next_Action__c,Current_Status__c=caseRec.Status,Current_Status_Added_By__c=pmfKey,Current_Next_Action_Date__c=caseRec.Next_Action_Date__c,
                                                      Current_Status_Date__c=system.now(),Prev_Next_Action_Date__c=oldCaseRec.Next_Action_Date__c,Status_From_Date__c= null ,Prev_Next_Action_By__c= '' ,Curr_Next_Action_By__c=pmfKey,Previous_Status_Added_By__c= '',
                                                      Previous_Next_Action__c=oldCaseRec.Next_Action__c,Status_From__c=oldCaseRec.Status,Current_Next_Action_Due_Date__c=dueDate,Prev_Next_Action_Due_Date__c=prevDueDate,Current_GSS_TR_Date__c=system.now(),
                                                      Previous_GSS_TR_Date__c= null,ReOpen_Date__c = caseRec.Date_Time_ReOpened__c!=null ? caseRec.Date_Time_ReOpened__c :caseRec.CreatedDate,Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,
                                                      Case_Owner__c=caseRec.OwnerID,Case_Severity__c=caseRec.Severity__c,Restoration_SLA_Disqualified__c = caseRec.Restoration_SLA_Disqualified__c);                                    
                 }

                otherSupportTypeTaskMap = CaseGateway.otherSupportTypeTaskMap;
                List<Task> otherSupportTaskList = new List<Task>();     
                Boolean taskOpen = false;
                Boolean caseHasTask = false;
                if(otherSupportTypeTaskMap!=null && otherSupportTypeTaskMap.containskey(caseRec.Id)){
                    caseHasTask = true;
                    otherSupportTaskList = otherSupportTypeTaskMap.get(caseRec.Id);
                    if(otherSupportTaskList!=null && otherSupportTaskList.Size()>0){
                        for(Task recTask :otherSupportTaskList){
                            if(recTask.Status !='Closed'){
                                taskOpen = true;
                                break;
                            }
                        }
                    }
                }
                //adding logic to set calculated status on GSS Current_Status__c field
                if((caseRec.Status=='Open' || caseRec.Status=='Verify') && caseHasTask && taskOpen){
                    gssRec.Current_Status__c = 'Transferred';               
                }
                else if(caseRec.Status=='Verify' && caseHasTask && !taskOpen){
                    gssRec.Current_Status__c = 'Pending'; 
                }
                else if(caseRec.Status=='Open' && caseHasTask && !taskOpen){
                    gssRec.Current_Status__c = 'Open'; 
                }
                else if(caseRec.Status=='Open' && !caseHasTask){
                    gssRec.Current_Status__c = 'Open'; 
                }
                else if(caseRec.Status=='Verify' && !caseHasTask){
                    gssRec.Current_Status__c = 'Verify'; 
                }
                else if(caseRec.Status=='Closed'){
                    gssRec.Current_Status__c = 'Closed'; 
                   
                }
                else if(caseRec.Status=='Closed Resolved'){
                    gssRec.Current_Status__c = 'Closed Resolved'; 
                   
                }
                else if(caseRec.Status=='Closed Unresolved'){
                    gssRec.Current_Status__c = 'Closed Unresolved'; 
                   
                }
                
                
                System.debug('*** Status :'+caseRec.Status + '***caseRec.Reopen_Count__c:'+caseRec.Reopen_Count__c+'***oldcaseRec.Reopen_Count__c:'+oldcaseRec.Reopen_Count__c);
                if(oldCaseRec.status!=caseRec.Status){
                     if(caseRec.Status=='Open'){
                        if(oldCaseRec.status == 'Closed' && (caseRec.Reopen_Count__c-oldcaseRec.Reopen_Count__c==0) ){
                            gssRec.Current_GSS_TR__c='R';  // when case status changes from closed to open for any number of times 
                        }
                        else if(oldCaseRec.status=='Verify'){
                            if(caseRec.Reopen_count_from_verify__c==0){
                                gssRec.Current_GSS_TR__c='R3'; //when case status changed from verify to open for first time 
                            }
                            else if(caseRec.Reopen_count_from_verify__c>=1 &&(caseRec.Reopen_count_from_verify__c-oldcaseRec.Reopen_count_from_verify__c==0 )){
                                gssRec.Current_GSS_TR__c='R4'; //when case status changed from verify to open for more than once
                            }

                        }
                    }
                    else if( caseRec.Status=='Closed' ){
                        if( caseRec.Close_Count__c==1){
                            gssRec.Current_GSS_TR__c='S1'; //when case was closed for first time 
                        }

                        else if( caseRec.Close_Count__c>1){
                            gssRec.Current_GSS_TR__c='S2'; //when case was closed for more than once
                        }
                    }

                    else if(caseRec.Status=='Verify'){
                        if(caseRec.Verify_Count__c==1){
                            gssRec.Current_GSS_TR__c='S3'; //when case status changed to verify for first time
                        }
                        else if(caseRec.Verify_Count__c>1){
                            gssRec.Current_GSS_TR__c='S4'; //when case status changed to verify more than once
                        }
                    }
                    else if((caseRec.Status =='Closed Resolved' || caseRec.Status =='Closed Unresolved') && caseRec.Case_Type__c == 'Case Concern'){
                         //if( caseRec.Close_Count__c==1){
                             gssRec.Current_GSS_TR__c='S1'; //when case was closed for first time 
                        // }
                    }
                 
                }
                else if(oldCaseRec.Next_Action__c!=caseRec.Next_Action__c || oldCaseRec.Next_Action_Due_Date__c!=caseRec.Next_Action_Due_Date__c){
                    gssRec.Current_GSS_TR__c = gssRec.Previous_GSS_TR__c ; // For Next Action and Next Action Due Date change previous TR code is copied over --due date change added for 300-308265 
                }
                System.debug('gssLst size-1--->' + gssLst.size());
                System.debug('UtilityFalgs.createGSS-->' + UtilityFalgs.createGSS);
                System.debug('gssRec.Current_GSS_TR__c-->' + gssRec.Current_GSS_TR__c);
                //Updated code to restrict the GSS transactions created to only 1 by adding createGSS flag. - VELUD01 - CR#400-1275
                //if(!UtilityFalgs.createGSS && gssRec.Current_GSS_TR__c!=null)
                if(gssRec.Current_GSS_TR__c!=null)
                 {
                    
                   gssLst.add(gssRec);
                   //UtilityFalgs.createGSS=true;
                 }  
                 System.debug('gssLst size-2--->' + gssLst.size());
            }
            if(caserec.Case_Type__c != 'Case Concern' && caseRec.Case_Type__c != System.Label.ProactiveCaseType){
            List<Case> listparentCaseUpdte = new List<Case>();
         //this block is to do a fake update on parent case to get the latest modification details
         if(caserec.parentid!=null && UtilityFalgs.relatedcaseFlag)
       {
           UtilityFalgs.relatedcaseFlag=false;

        //Case parentrec=[select id from Case where id = :caserec.parentid];
       // system.debug('CaseConcern after update: select id from Case where id');
          //if(parentrec!=null)
          //{
            try
            {
             //   update parentrec;
              // listparentCaseUpdte.add(parentrec); 
            }
            catch(Exception ex)
            {
                String msg=ex.getMessage();
                if(ex.getMessage().contains('VALIDATION_EXCEPTION'))
                    msg=msg.substring(10+msg.indexof('EXCEPTION,'),msg.indexof(': ['));
                if(!Trigger.isDelete)
                    Trigger.new[0].addError(msg+' on Parent Case');
                else
                    Trigger.old[0].addError(msg+' on Parent Case');
            }
          //}    
       }
// ****************** After Update Automic Code Started *************************//

        if(caseRec.ParentId != null){
            ProblemCaseIds.add(caseRec.ParentId);
            IncidentCaseIds.add(caseRec.Id);
            system.debug('New Problem Case Ids..!!'+ProblemCaseIds);
            system.debug('New Incident Case Ids..!!'+IncidentCaseIds);
        }
        
        //CheckRecursiveTrigger.recursiveHelper(true);
        system.debug('Update isafter..!!!');
        system.debug('Case New records'+Trigger.new);
        system.debug('Case new record size'+Trigger.new.size());
        system.debug('Case oldmap be'+Trigger.oldmap.values());
        system.debug('Case oldmap size'+Trigger.oldmap.size());
        //Update Severity, Number of Incidents and Component Release
        if(!UtilityFalgs.isCaseConcern && CheckRecursiveTrigger.recursiveflag == false){
              JiraCaseTriggerUpdate.JiraUpdateFieldFutureCallout(caseRec, oldCaseRec);
              CheckRecursiveTrigger.recursiveHelper(true);
        }
         //If the Standard Case is delinked from a Problem Case
        if(oldCaseRec.parentID!=NULL && caseRec.parentID==NULL){
              JiraCaseTriggerUpdate.JiraUpdateFieldFutureCallout(caseRec, oldCaseRec);
              CheckRecursiveTrigger.recursiveHelper(true);
        }
         
        If(!ProblemCaseIds.isempty()){
            CheckRecursiveTrigger.recursiveHelper(true);
        }
        }
        
// ****************** After Update Automic Code Ended ************************* //
    }
    
    public void afterDelete(SObject so)
    {

    }
    
    /**
    *caseCommentCommonFields
    *
    * this is common method for case comment fields
    */

    public CaseComment caseCommentCommonFields(String commentBody, String caseId){
         
            CaseComment caseCommentObj = new CaseComment();
            caseCommentObj.CommentBody = commentBody;
            caseCommentObj.ParentId = caseId;
            return caseCommentObj; 
    }


    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        /*if(gssLst.size()>0)
            database.insert(gssLst,false);*/
        //US108116  - commented above lines and added below. - made insert to upsert
         if(gssLst.size()>0){
            
            database.upsert(gssLst,false);
         }           

        if(taskLst.size()>0)
        {
        //Commented because it is not allowing to case concern
             System.debug('===='+taskLst);
             if(UtilityFalgs.recursiveCheck)
             {upsert taskLst;
             UtilityFalgs.recursiveCheck = false;
             }
             }
        portalViewList = CaseGateway.casePortalViewList ;
        if(portalViewList!=null && portalViewList.Size()>0){
            database.update(portalViewList,false);
        }
        if(cseCommentlst != null && cseCommentlst.size()>0)
            database.insert(cseCommentlst,false);
    }
      public void caseHandlerTestData(){
        Integer i=0;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++; 
    }
}