/*
* Uses Test Class = RemoveResourceControllerTest
* Coverage = 79%.
* Updated by SAMTU01
*/ 
public class RemoveResorceRequestController {
    public Presales_Request__c  presale{set;get;}
    Id presalesId;
    
    Public String removalReson1{set;get;}
    Public String removalReson2{set;get;}
    Public String removalReson3{set;get;}
    
    public boolean removalDisable{set;get;}
    
    public String cancellationReason{set;get;}
    
    public Boolean disableCancelltion{set;get;}
    
    public List<SelectOption> removeReasons{set;get;}
    
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Presales Pending Fulfillment');
    Id Fulfillmentrecordtypeid = rec.RecordType_Id__c;
    RecordTypes_Setting__c rec2 = RecordTypes_Setting__c.getValues('Presales Cancelled Request');
    Id cancelledrecordtypeid = rec2.RecordType_Id__c;
    
    public List < SelectOption > getremoveReasons {
      get {
       removeReasons = getNumberReason();
    
       return removeReasons;
    
      }
      set; 
    
     }

  public List < SelectOption > getNumberReason() {
      List < SelectOption > selectval = new List < SelectOption > ();
      selectval.add(new SelectOption('', ''));
      selectval.add(new SelectOption('Scheduling Conflict', 'Scheduling Conflict'));
      selectval.add(new SelectOption('Assigned Activity No Longer Needed', 'Assigned Activity No Longer Needed'));
      selectval.add(new SelectOption('Skillset No Longer Required', 'Skillset No Longer Required'));
            selectval.add(new SelectOption('Vacation', 'Vacation'));
                  selectval.add(new SelectOption('Other', 'Other '));


    
      return selectval;
    
    
     }

    
     public RemoveResorceRequestController()
      {
         
          presalesId=ApexPages.currentPage().getParameters().get('id');
          presale=[select Cancellation_Reason__c,opportunity__r.name,opportunity__r.Account.name,opportunity__r.Opportunity_Number__c,
                   opportunity__r.owner.name,opportunity__r.Rpt_Territory_Country__c,opportunity__r.Segment__c,OwnerId,GEO__c,Action__c,
                   Removal_Reason1__c,Removal_Reason2__c,Removal_Reason3__c,Activity__c,Opportunity__c,Duration__c,Request_Status__c,
                   Commission_BU__c,Start_Date__c,Number_of_PreSales_Resource__c,Presales_Resource1__c,Presales_Resource2__c,
                   Presales_Resource3__c,Role1__c,
                    Role2__c,Role3__c,PreSales_Commission__r.Presales_Resource1__c,PreSales_Commission__r.Presales_Resource2__c,
                   PreSales_Commission__r.Presales_Resource3__c,PreSales_Commission__r.Commission_Split1__c,
                  PreSales_Commission__r.Commission_Split2__c,PreSales_Commission__r.Commission_Split3__c,opportunity__r.Coverage_Model__c,Name from Presales_Request__c
                   where id=:presalesId]; //added cov model and Name in query as part of US334584 and US331730 by SAMTU01
         
          System.debug('------presale------'+presale);
          
      }
    
    public PageReference reMoval(){
        presale.OwnerId=PreSalesFormController.queueIds(presale).Queue_Id__c;
        presale.Removal_Reason1__c=removalReson1;
        presale.Removal_Reason2__c=removalReson2;
         presale.Removal_Reason3__c=removalReson3;
        presale.Request_Status__c='Pending Fulfillment';
        presale.Action__c = 'Remove';
        presale.RecordTypeId = Fulfillmentrecordtypeid;
        System.debug('---------------'+ presale.Removal_Reason1__c);
        
        if( (presale.Presales_Resource1__c!=null && presale.Presales_Resource2__c!=null && presale.Presales_Resource3__c!=null)){
            if(String.isBlank(presale.Removal_Reason1__c) && String.isBlank(presale.Removal_Reason2__c) && 
               String.isBlank(presale.Removal_Reason3__c)){
                   
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                   return null; 
               }
        }
        else if( (presale.Presales_Resource1__c!=null && presale.Presales_Resource2__c!=null && presale.Presales_Resource3__c==null)){
            if(String.isBlank(presale.Removal_Reason1__c) && String.isBlank(presale.Removal_Reason2__c) && String.isBlank(presale.Removal_Reason3__c) ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                    return null;
            }
            else if((!(String.isBlank(presale.Removal_Reason1__c) && String.isBlank(presale.Removal_Reason2__c))) && (!String.isBlank(presale.Removal_Reason3__c))){               
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Empty_Resource));
                return null;
            }
        }
        else if( (presale.Presales_Resource1__c!=null && presale.Presales_Resource2__c==null && presale.Presales_Resource3__c!=null)){
            if(String.isBlank(presale.Removal_Reason1__c) && String.isBlank(presale.Removal_Reason3__c) && String.isBlank(presale.Removal_Reason2__c) ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                    return null;
            }
            else if((!(String.isBlank(presale.Removal_Reason1__c) && String.isBlank(presale.Removal_Reason3__c))) && (!String.isBlank(presale.Removal_Reason2__c))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Empty_Resource));
                return null;
            }
        }
        else if( (presale.Presales_Resource1__c==null && presale.Presales_Resource2__c!=null && presale.Presales_Resource3__c!=null)){
            if(String.isBlank(presale.Removal_Reason3__c) && String.isBlank(presale.Removal_Reason2__c) && String.isBlank(presale.Removal_Reason1__c) ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                    return null;
            }
            else if((!(String.isBlank(presale.Removal_Reason3__c) && String.isBlank(presale.Removal_Reason2__c))) && (!String.isBlank(presale.Removal_Reason1__c))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Empty_Resource));
                return null;
            }
        }
        else if( (presale.Presales_Resource1__c!=null && presale.Presales_Resource2__c==null && presale.Presales_Resource3__c==null)){
            if((String.isBlank(presale.Removal_Reason1__c)) && (String.isBlank(presale.Removal_Reason2__c) && String.isBlank(presale.Removal_Reason3__c))){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                    return null;
            }
            else if((String.isBlank(presale.Removal_Reason1__c)) || (!String.isBlank(presale.Removal_Reason2__c) || !String.isBlank(presale.Removal_Reason3__c))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Empty_Resource));    
                return null;
            }
        }
        else if( (presale.Presales_Resource1__c==null && presale.Presales_Resource2__c!=null && presale.Presales_Resource3__c==null)){
            if((String.isBlank(presale.Removal_Reason2__c)) && (String.isBlank(presale.Removal_Reason1__c) && String.isBlank(presale.Removal_Reason3__c))){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                    return null;
            }
            else if((String.isBlank(presale.Removal_Reason2__c)) || (!String.isBlank(presale.Removal_Reason1__c) || !String.isBlank(presale.Removal_Reason3__c))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Empty_Resource));   
                return null;
            }
        }
        else if( (presale.Presales_Resource1__c==null && presale.Presales_Resource2__c==null && presale.Presales_Resource3__c!=null)){
            if((String.isBlank(presale.Removal_Reason3__c)) && (String.isBlank(presale.Removal_Reason2__c) && String.isBlank(presale.Removal_Reason1__c))){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                    return null;
            }
            else if((String.isBlank(presale.Removal_Reason3__c)) || (!String.isBlank(presale.Removal_Reason2__c) || !String.isBlank(presale.Removal_Reason1__c))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Reason_Required));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Removal_Empty_Resource));    
                return null;
            }
        }
        
        update presale;
        removalDisable=true;
        List<GroupMember> gmb=[select UserOrGroupId,GroupId from GroupMember where GroupId=:presale.OwnerId];
        Set<id> userId=new Set<id>();
        
        for(GroupMember grp:gmb){
            userId.add(grp.GroupId);
            
        }
        String strUr=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RemoveByPresalesDirectorPage?id='+presale.id;
        String subject = preSalesEmailClass.emailsubjectremoval(presale.GEO__c, presale.Opportunity__r.Rpt_Territory_Country__c, presale.Commission_BU__c, presale.Opportunity__r.Segment__c,presale.Opportunity__r.Coverage_Model__c);//added cov model in method as part of US334584 by SAMTU01
        String body = preSalesEmailClass.emailbody(presale.Opportunity__r.name,presale.opportunity__r.Opportunity_Number__c,presale.Opportunity__r.owner.name,presale.Opportunity__r.Account.name,presale.Name);//added presales req number in method as part of US331730 by SAMTU01
        String pagelink = preSalesEmailClass.presalesremovepagelink(presale.id,strUr);
        body = body + pagelink;
        List< Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        for(Id emailId:PreSalesFormController.GetUserIdsFromGroup(userId)){
          
         Messaging.SingleEmailMessage mail=new  Messaging.SingleEmailMessage();
            mail.setSubject(subject);
            mail.saveAsActivity = false;
            mail.setTargetObjectId(emailId);
            mail.setHtmlBody(body);
             mails.add(mail);
           
        }
         Messaging.SendEmailResult[] mailIndicat=Messaging.sendEmail(mails);
        
         if( !String.isBlank(presale.Removal_Reason1__c)|| !String.isBlank(presale.Removal_Reason2__c)|| !String.isBlank(presale.Removal_Reason3__c)){
        
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'You are request has been sumbited sucessfully'));
           return null;       
      }
        
      
         
     return null; 
    }
    
    
   
    
    Public PageReference cancellationRequest(){

        
        if(String.isEmpty(cancellationReason)){
            
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Cancel_Reason_Is_Null));
           return null; 
            
        }
        else{
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.Pre_Sales_Cancel_Submit_Confirmation));  
          presale.OwnerId=PreSalesFormController.queueIds(presale).Queue_Id__c;
           presale.RecordTypeId = Fulfillmentrecordtypeid;
           presale.Cancellation_Reason__c=cancellationReason;
            presale.Action__c = 'Cancel';
            presale.Request_Status__c='Cancel';
          update presale;
            disableCancelltion=true;
        }
         
        
       
        List<GroupMember> gmb=[select UserOrGroupId,GroupId from GroupMember where GroupId=:presale.OwnerId];
        
          Set<id> userId=new Set<id>();
        
        for(GroupMember grp:gmb){
            userId.add(grp.GroupId);
            
        }
        
        List< Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        String strUr=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RemoveByPresalesDirectorPage?id='+presale.id+'&'+'cancelApprove'+'='+'true';
        String subject = preSalesEmailClass.emailsubjectcancel(presale.GEO__c, presale.Opportunity__r.Rpt_Territory_Country__c, presale.Commission_BU__c, presale.Opportunity__r.Segment__c,presale.Opportunity__r.Coverage_Model__c);//added cov model in method as part of US334584 by SAMTU01
        String body = preSalesEmailClass.emailbody(presale.Opportunity__r.name,presale.opportunity__r.Opportunity_Number__c,presale.Opportunity__r.owner.name,presale.Opportunity__r.Account.name,presale.Name);//added presales req number in method as part of US331730 by SAMTU01
        String pagelink = preSalesEmailClass.presalescancelpagelink(presale.id,strUr);
        body = body + pagelink;
        for(Id emailId:PreSalesFormController.GetUserIdsFromGroup(userId)){
            
         Messaging.SingleEmailMessage mail=new  Messaging.SingleEmailMessage();
          // mail.setSubject('Presales Request for Cancel'+'-'+ presale.GEO__c+','+ presale.Commission_BU__c+','+presale.Opportunity__r.Segment__c+','+presale.Opportunity__r.Rpt_Territory_Country__c);//presale.Opportunity__r.Rpt_Territory_Country__c
            //mail.setTemplateId('00X19000000I7fH');
            mail.setSubject(subject);
            mail.saveAsActivity = false;
            mail.setTargetObjectId(emailId);
            //mail.setHtmlBody('Dear Presales Director,</br><p>A Presales request has been submitted for your approval.</br></br>'+''+'Opportunity name:'+ presale.Opportunity__r.name+'</br>'+'Opportunity Number:'+presale.opportunity__r.Opportunity_Number__c+'</br>'+'</br>'+'Opportunity Owner Name:'+presale.Opportunity__r.owner.name+'</br>'+'</br>'+'Account Name:'+presale.Opportunity__r.Account.name+'</br>'+'</br>Please complete the approval process by clicking on the link below:</p></br><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RemoveByPresalesDirectorPage?id='+presale.id+'&'+'cancelApprove'+'='+'true'+'>'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RemoveByPresalesDirectorPage?id='+presale.id+'</a>'+'</br></br>'+'Thank You'); 
            mail.setHtmlBody(body);
            mails.add(mail);
          
        }
         Messaging.SendEmailResult[] mailIndicat=Messaging.sendEmail(mails);
        
       return null; 
        
    }
    
     public PageReference redirectRecord(){
         PageReference pg = new PageReference('/'+presale.Id);
        pg.setRedirect(true);
     Return pg;
                
        
    }
    

}