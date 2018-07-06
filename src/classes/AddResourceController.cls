/*
* Uses Test Class = AddResourceControllerTest
* Coverage = 95%.
* Updated by SAMTU01
*/ 

public class AddResourceController {
    
    public Id presalesId;
    public Presales_Request__c presale{set;get;}
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Presales Pending Fulfillment');
    Id Fulfillmentrecordtypeid = rec.RecordType_Id__c;
    public AddResourceController(){
        presale=new Presales_Request__c();
        presalesId=ApexPages.currentPage().getParameters().get('id');         

          presale=[select id,Action__c,Activity__c,GEO__c,opportunity__r.Opportunity_Number__c,Opportunity__r.Account.name,Opportunity__r.owner.name,OwnerId,Opportunity__c,Opportunity__r.Rpt_Territory_Country__c,Opportunity__r.Segment__c,Opportunity__r.name,Duration__c,Request_Status__c,Commission_BU__c,Start_Date__c,Number_of_PreSales_Resource__c,Presales_Resource1__c,Presales_Resource2__c,Presales_Resource3__c,Role1__c,
                  Role2__c,Role3__c,PreSales_Commission__r.Presales_Resource1__c,PreSales_Commission__r.Presales_Resource2__c,PreSales_Commission__r.Presales_Resource3__c,PreSales_Commission__r.Commission_Split1__c,
                  PreSales_Commission__r.Commission_Split2__c,PreSales_Commission__r.Commission_Split3__c,Opportunity__r.Coverage_Model__c,Name from Presales_Request__c where id=:presalesId]; //added cov model and Name in query as part of US334584 and US331730 by SAMTU01
        
        
    }
    
    
    public PageReference addResource(){
        if(presale.Presales_Resource1__c!=null&&presale.Presales_Resource2__c!=null&&presale.Presales_Resource3__c!=null){
            
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Pre_Sales_Add_Resource_Maxed_Out_Error));
              return null;
        }else{
            
           presale.OwnerId=PreSalesFormController.queueIds(presale).Queue_Id__c;
           presale.Request_Status__c='Pending Fulfillment';
            presale.Action__c = 'Add';
            presale.RecordTypeId = Fulfillmentrecordtypeid;
            update presale;
            List<GroupMember> gmb=[select UserOrGroupId,GroupId from GroupMember where GroupId=:presale.OwnerId];
              Set<id> userId=new Set<id>();
        
                for(GroupMember grp:gmb){
                    userId.add(grp.GroupId);
                    
                }
            String strUr=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PreSalesEditpage?id='+presale.id;

        
        System.debug('------------gmb----------'+gmb);
        List< Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        String subject = preSalesEmailClass.emailsubjectAdd(presale.GEO__c, presale.Opportunity__r.Rpt_Territory_Country__c, presale.Commission_BU__c, presale.Opportunity__r.Segment__c,presale.Opportunity__r.Coverage_Model__c);//added cov model in method as part of US334584 by SAMTU01
        String body = preSalesEmailClass.emailbody(presale.Opportunity__r.name,presale.opportunity__r.Opportunity_Number__c, presale.Opportunity__r.owner.name,presale.Opportunity__r.Account.name,presale.Name);//added presales req number in method as part of US331730 by SAMTU01
        String pagelink = preSalesEmailClass.presalesrequestpagelink(presale.id,strUr);
        body = body + pagelink;
        
      for(Id emailId:PreSalesFormController.GetUserIdsFromGroup(userId)){

         Messaging.SingleEmailMessage mail=new  Messaging.SingleEmailMessage();
            //mail.setSubject('Presales Request for Add'+'-'+ presale.GEO__c+','+ presale.Commission_BU__c+','+presale.Opportunity__r.Rpt_Territory_Country__c+','+presale.Opportunity__r.Segment__c);
            mail.setSubject(subject);
            mail.saveAsActivity = false;
            //mail.setHtmlBody('Dear Presales Director,</br><p>A Presales request has been submitted for your approval.</br></br>'+''+'Opportunity name:'+ presale.Opportunity__r.name+'</br>'+'Opportunity Number:'+presale.opportunity__r.Opportunity_Number__c+'</br>'+'</br>'+'Opportunity Owner Name:'+presale.Opportunity__r.owner.name+'</br>'+'</br>'+'Account Name:'+presale.Opportunity__r.Account.name+'</br>'+'</br>Please complete the approval process by clicking on the link below:</p></br><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PreSalesEditpage?id='+presale.id+'>'+strUr+'</a>'+'</br></br>'+'Thank You');
            mail.setHtmlBody(body);
            mail.setTargetObjectId(emailId);
             mails.add(mail);
         
        }
         Messaging.SendEmailResult[] mailIndicat=Messaging.sendEmail(mails);
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.Pre_Sales_Add_Resource_Confirmation));
              return null;
            
        }
        
           
    }
    
    public PageReference redirectRequest(){
        PageReference pg = new PageReference('/'+presale.Id);
         pg.setRedirect(true);
          Return pg;
        
        
    }

}