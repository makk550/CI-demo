public class PartnerEngagementRequest_Controller {
 
public Opportunity Opp;
public Id oppId{get;set;}
public  Id  OppReg{get;set;}    
public boolean showReadOnly{get;set;}
public boolean showEdit{get;set;}
public boolean showeditbutton{set;get;}
public boolean isapprovededit{set;get;}
public string selectedstatus{get;set;}
public Partner_Engagement_Program__c per{set;get;}
User dUser=[select Alias from User where Id=:UserInfo.getUserId() limit 1];

      public PartnerEngagementRequest_Controller(ApexPages.StandardController stdController) 
     {
        OppReg =  ApexPages.currentPage().getParameters().get('oppReg');
        oppId= ApexPages.currentPage().getParameters().get('oppId');
       Id PEId= ApexPages.currentPage().getParameters().get('Id');
       String returl=ApexPages.currentPage().getParameters().get('retURL');
       showeditbutton=false;
        per = (Partner_Engagement_Program__c)stdController.getrecord();
         showReadOnly =true;
         showEdit =true;
         isapprovededit=false;
         if(PEId!=null){
         if(PEId!=null&&returl!=null)
         {              
            per=[select id,Name,Parent_Opportunity__c,Distributor__c,License_Implementation__c,Customer_Procurement__c,Contract_Administration__c,Support_and_Maintenance__c,Customer_Training__c,Proposal__c,Presentation__c,Distributor_Contact__c,Partner_Engagement_Type__c,Partner__c,Partner_Contact__c,Comments__c,Engagement_Approver__c,POC__c,Demo__c,Status__c,Lunch_and_Learn__c,On_Customer_s_Approved_Vendor_List_for__c,Relationship_with_Customer__c,SendemailtoPartner__c,createdbyid,CreatedDate,PartnerFinancing__c,ProcurementContractAccess__c  from Partner_Engagement_Program__c where id=:PEId limit 1 ];
             if(per.Status__c=='Approved')
             {
                 showReadOnly = true;
                showEdit =false;
                isapprovededit=true;
             }
             else 
             {
                 showReadOnly = false;
                showEdit =true;
             }
         }
         if(PEId!=null&&(returl==null))
         {
              showReadOnly = true;
              showeditbutton=true;
            showEdit =false;
             per=[select id,Name,Parent_Opportunity__c,Distributor__c,License_Implementation__c,Customer_Procurement__c,Contract_Administration__c,Support_and_Maintenance__c,Customer_Training__c,Proposal__c,Presentation__c,SendemailtoPartner__c,Distributor_Contact__c,Partner_Engagement_Type__c,Partner__c,Partner_Contact__c,Comments__c,Engagement_Approver__c,POC__c,Demo__c,Status__c,Lunch_and_Learn__c,On_Customer_s_Approved_Vendor_List_for__c,Relationship_with_Customer__c,createdbyid,CreatedDate,PartnerFinancing__c,ProcurementContractAccess__c from Partner_Engagement_Program__c where id=:PEId limit 1 ];
         }
         }
         else
         {
          if(per.Status__c == 'Pending' && per.Engagement_Approver__c == UserInfo.getUserId())
        {
            showReadOnly = false;
            showEdit =true;
        } 
         else if(per.Status__c == 'Approved' && per.Engagement_Approver__c == UserInfo.getUserId())
        {
            showReadOnly = true;
            showEdit =false;
        } 
          else
        {
             showEdit =true;    
             showReadOnly = false;
        }
          if(oppId == null)
        {
           oppId = per.Parent_Opportunity__c;
        }
        opp = [select stagename,Probability,recordtypeId,Account.Alliance__c,Type,closedate,Accountid,Account.RecordtypeId,Account.Service_Provider__c,Partner_Engagement__c,(SELECT Id, Status__c FROM Partner_Engagement_Requests__r where (Status__c != null AND Status__c != '' AND (Status__c =: 'Approved' OR Status__c =: 'Pending Approval' OR Status__c =: 'New'))),(select id,OpportunityId from OpportunityContactRoles where isprimary=:true)  from Opportunity where Id= :oppId ] ;  
        Integer fyMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        Integer fyYear = System.today().year();
        Integer closemonth = opp.closedate.month();
        Integer closeyear = opp.closedate.year();
        if(opp != null)
        {
            if(opp.type=='xSP'||opp.type=='OEM')
            {
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner Engagement Request is for 1 Tier and 2 Tier transactions only');            
                ApexPages.addMessage(msg);
                showReadOnly = true;
                showEdit =false; 
            }
            if(Label.Opp_Stage_Closed_Won == opp.StageName || Label.Opp_Stage_Closed_Lost == opp.StageName || opp.CloseDate <  Date.today()) 
            { 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner Engagement Request cannot be created if the Opportunity Sales Milestone = "' + Label.Opp_Stage_Closed_Lost +'" OR "' + Label.Opp_Stage_Closed_Won +'" and the "Close Date" of the Opportunity cannot be in the past.');            
                ApexPages.addMessage(msg);
                showReadOnly = true;
                showEdit =false; 

            } 
         
            user u=[select id,Opportunity_Validation_Bypass__c  from user where id=:userinfo.getUserId()];
            if(u.Opportunity_Validation_Bypass__c=true&&(opp.recordtypeId==RecordTypes_Setting__c.getValues('New Opportunity').RecordType_Id__c||opp.recordtypeId==RecordTypes_Setting__c.getValues('Acquisition').RecordType_Id__c)&&opp.Account.Service_Provider__c==true)
            {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, '"Sell To" account cannot be a Service Provider account.');            
                ApexPages.addMessage(msg);
                showReadOnly = true;
                showEdit =false; 
            }
            if(u.Opportunity_Validation_Bypass__c=true&&(opp.recordtypeId==RecordTypes_Setting__c.getValues('New Opportunity').RecordType_Id__c||opp.recordtypeId==RecordTypes_Setting__c.getValues('Acquisition').RecordType_Id__c)&&opp.Account.Recordtypeid!=RecordTypes_Setting__c.getValues('Account Team Covered Account').RecordType_Id__c&&opp.Account.Recordtypeid!=RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c&&opp.Account.Recordtypeid!=RecordTypes_Setting__c.getValues('Territory Covered Account').RecordType_Id__c&&(opp.Account.Recordtypeid!=RecordTypes_Setting__c.getValues('Reseller/Distributor Account').RecordType_Id__c&&!(opp.Account.Service_Provider__c||opp.Account.Alliance__c)))
            {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, '"New Opportunity" and Acquistions, can be created only for Account Team , Territory Covered, SMB or Service Provider accounts.');            
                ApexPages.addMessage(msg);
                showReadOnly = true;
                showEdit =false; 
            }
            //if('Collaborative' == opp.Partner_Engagement__c || 'Fulfillment-Only' == opp.Partner_Engagement__c || 'Pending' == opp.Partner_Engagement__c) 
            if(opp.Partner_Engagement_Requests__r.size() != 0)
            { 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Only 1 Partner Engagement Request per Opportunity.');            
                ApexPages.addMessage(msg);
                showReadOnly = true;
                showEdit =false; 

            } 
            
        }
        }
         if(oppId == null)
        {
           oppId = per.Parent_Opportunity__c;
        }
        else
        per.Parent_Opportunity__c=oppId;
     }
     public PageReference save()
     {   
         Date myDate = Date.newInstance(2016, 4, 25); //AR3955

         PageReference pref;
         System.debug(per.Demo__c+'@@'+per.Lunch_and_Learn__c);
      
         try{
             if((per.partner__c != null && per.partner_Contact__c == null)&&dUser.Alias!=Label.Damigration_User_Alias){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A Partner Contact is required.');            
               ApexPages.addMessage(msg);
                pref=null;
            }
            else if((per.Distributor__c!= null && per.Distributor_Contact__c== null)&&dUser.Alias!=Label.Damigration_User_Alias){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A Distributor Contact is required.');            
                ApexPages.addMessage(msg);
                pref=null;
            }else if (per.Engagement_Approver__c!= null && per.CreatedById!= null && per.CreatedDate!=null && per.CreatedDate > myDate && (per.Engagement_Approver__c == per.CreatedById)&&dUser.Alias!=Label.Damigration_User_Alias){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'PER Creator cannot be set as the approver of the PER.');            
                ApexPages.addMessage(msg);
                pref=null;
      }
            else
            {
             if(per.On_Customer_s_Approved_Vendor_List_for__c || per.Relationship_with_Customer__c || per.POC__c || per.Demo__c ||per.Lunch_and_Learn__c||per.Proposal__c||per.Presentation__c||per.Customer_Training__c||per.License_Implementation__c||per.Contract_Administration__c||per.Support_and_Maintenance__c||per.Customer_Procurement__c) {
             if(selectedstatus!=''&&selectedstatus!=null)
             per.status__c=selectedstatus;
             if(per.Relationship_with_Customer__c || per.POC__c ||per.Demo__c || per.Lunch_and_Learn__c||per.Proposal__c||per.Presentation__c||per.Customer_Training__c) 
                per.Partner_Engagement_Type__c = 'Collaborative';
              else per.Partner_Engagement_Type__c = 'Fulfillment';
                   upsert per;
                 pref = new PageReference('/apex/PartnerEngagementRequest_VFP?id='+per.id);
                  pref.setRedirect(true); 
            }
             else if(dUser.Alias!=Label.Damigration_User_Alias)
             {
                 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select atleast one value from Collaborative or Fulfillment.');            
                 ApexPages.addMessage(msg);
               pref=null;
             }
             }
             
         }
          catch(Exception e)
         {
            if(ApexPages.getMessages().size()<=0&&dUser.Alias!=Label.Damigration_User_Alias){
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());            
           ApexPages.addMessage(msg);
           }
            pref=null;
         }

      
        
        return pref;
     }
     public PageReference saveNsubmit()
     { 
         Date myDate = Date.newInstance(2016, 4, 25);//AR3955 
         PageReference pref;
         //try{
             if(per.partner__c != null && per.partner_Contact__c == null ){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A Partner Contact is required.');            
                ApexPages.addMessage(msg);
                pref=null;
            }
            else if(per.Distributor__c!= null && per.Distributor_Contact__c== null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A Distributor Contact is required.');            
                ApexPages.addMessage(msg);
                pref=null;
            }else if (per.Engagement_Approver__c!= null && per.CreatedById!= null && per.CreatedDate!=null && per.CreatedDate > myDate && (per.Engagement_Approver__c == per.CreatedById)){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'PER Creator cannot be set as the approver of the PER.');            
                ApexPages.addMessage(msg);
                pref=null;
      }
            else
            {
             if(per.On_Customer_s_Approved_Vendor_List_for__c || per.Relationship_with_Customer__c || per.POC__c || per.Demo__c ||per.Lunch_and_Learn__c||per.Proposal__c||per.Presentation__c||per.Customer_Training__c||per.License_Implementation__c||per.Contract_Administration__c||per.Support_and_Maintenance__c||per.Customer_Procurement__c) {
             if(selectedstatus!=''&&selectedstatus!=null)
             per.status__c=selectedstatus;
             if(per.Relationship_with_Customer__c  || per.POC__c ||per.Demo__c || per.Lunch_and_Learn__c||per.Proposal__c||per.Presentation__c||per.Customer_Training__c) 
                per.Partner_Engagement_Type__c = 'Collaborative';
             else per.Partner_Engagement_Type__c = 'Fulfillment';
       try{
                 upsert per;
             }
                 catch(Exception e){
                     system.debug('Entered exception');
                     if(ApexPages.getMessages().size()<=0){
                     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());            
               ApexPages.addMessage(msg);
                     pref=null;
                     }
                 }
                 if(ApexPages.getMessages().size()==0){
                  try{
             
                     Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                     req.setObjectId(per.Id);
                     Approval.ProcessResult result = Approval.process(req);
                     pref = new PageReference('/apex/PartnerEngagementRequest_VFP?id='+per.id);
                   pref.setRedirect(true);
                     }
                      catch(Exception e)
                     {
                       if(ApexPages.getMessages().size()<=0){
                       ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());            
                       ApexPages.addMessage(msg);
                       }
                        pref=null;
                     }   
                 }
       
     
              
            }
             else
             {
                 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select atleast one value from Collaborative or Fulfillment.');            
                 ApexPages.addMessage(msg);
               pref=null;
             }
             }
         /*}
          catch(Exception e)
         {
           if(ApexPages.getMessages().size()<=0){
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());            
           ApexPages.addMessage(msg);
           }
            pref=null;
         }*/
         system.debug('pref??'+pref);
         return pref;
     }
     public PageReference cancel()
     {
        PageReference pref = new PageReference('/'+ oppId);
        pref.setRedirect(true); 
        return pref;
     }
     public pagereference editPER()
     {
         PageReference pref = new PageReference('/apex/PartnerEngagementRequest_VFP?id='+per.id+'&retURL='+ oppId);
        pref.setRedirect(true); 
        return pref;
     }
}