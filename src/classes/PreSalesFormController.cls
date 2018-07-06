/*
* Uses Test Class = PreSalesFormControllerTest
* Coverage = 94%.
* Updated by SAMTU01
*/ 
public class PreSalesFormController{
    private String oppId{set;get;}
    public Presales_Request__c prsal{set;get;} 
    public List<OpportunityLineItem> listoppProductspick{set;get;}
    public List<SelectOption> selectBu{set;get;}
    public List<OpportunityLineItem> listProduct{set;get;}
    
    public String selectedProduct{set;get;}
    
    public List<string> blocklist{set;get;}
    
    
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Presales Pending Fulfillment');
    Id Fulfillmentrecordtypeid = rec.RecordType_Id__c;
    public PreSalesFormController() {
        oppId=ApexPages.currentPage().getParameters().get('id');
        init();    
    }
    public boolean emptyProductnot{set;get;}
    public void init(){
        blocklist=new List<string>();
        blocklist.add('test');
        prsal=new Presales_Request__c (); 
        selectBu=new List<SelectOption>();
        listoppProductspick=[select name,id,Opportunity.name,opportunity.Opportunity_Number__c,opportunity.Account.name,opportunity.owner.name,Opportunity.Account.GEO__c,Opportunity.Segment__c,Opportunity.Account.Sales_Region__c,Product2.name,Product2.Commissionable_BU__c,Commissionable_BU__c,Sales_Price_USD__c,Sales_Price_Net_to_CA__c,UnitPrice,Stretch__c,Opportunity.Account.Coverage_Model__c from OpportunityLineItem where OpportunityId=:oppId]; //'00619000005r4UgAAI'//added cov model in query as part of US334584 by SAMTU01
        set<string> unqiueBU=new set<string>();
        if(listoppProductspick.size()>0){
            emptyProductnot=true;
            System.debug('-----------------------listoppProductspick'+listoppProductspick[0].Opportunity.Account.GEO__c);
            for(OpportunityLineItem opit:listoppProductspick){
                unqiueBU.add(opit.Product2.Commissionable_BU__c);
                
                
            }
            selectBu.add(new SelectOption('--None--','--None--') )  ;
            
            for(string cbu:unqiueBU){
                system.debug('---entering select bu----');
                selectBu.add(new SelectOption(cbu,cbu) )  ;   
            }
            system.debug('-----select bu----'+selectBu);
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Request_Form_No_Product));
            
        }   
    }
    
    Public PageReference getProductAssociateCBU(){
        
        listProduct=[select name,id,Product_Family__c,Opportunity.name,Opportunity.Rpt_Region__c,Product2.name,Product2.Commissionable_BU__c,Commissionable_BU__c,Sales_Price_USD__c,Sales_Price_Net_to_CA__c,UnitPrice,Stretch__c from OpportunityLineItem where OpportunityId=:oppId  and Commissionable_BU__c=:selectedProduct]; //'00619000005r4UgAAI'
        
        system.debug(' sun is testing listProduct' + listProduct);
        system.debug(' sun is testing selectedProduct' + selectedProduct);
        
        

        return null;
    }
    
    public Static PreSales_Director_Queues__c queueIds(Presales_Request__c preSal){
        system.debug('-----------------'+preSal.GEO__c);
        List<PreSales_Director_Queues__c> queueRules= PreSales_Director_Queues__c.getall().values();              
        Map<string,PreSales_Director_Queues__c>  rulesMap=new Map<string,PreSales_Director_Queues__c>();
        for(PreSales_Director_Queues__c quRul:queueRules){
            system.debug('-----------------'+preSal.GEO__c);
            if(quRul.GEO__c=='NA'&&preSal.GEO__c=='NA'){
                if(quRul.CBU__c==preSal.Commission_BU__c){
                    System.debug('------------NA CBU');
                    rulesMap.put(quRul.GEO__c, quRul);
                    
                }
            }else if(preSal.GEO__c=='LA'&&quRul.GEO__c=='LA'){
                rulesMap.put(quRul.GEO__c, quRul);
                
            }else if(preSal.GEO__c=='APJ'&&quRul.GEO__c=='APJ'){
                if(quRul.CBU__c==preSal.Commission_BU__c){
                    System.debug('------------APJ CBU');
                    rulesMap.put(quRul.GEO__c, quRul);
                }
                
            }else if(preSal.GEO__c=='EMEA'&&quRul.GEO__c=='EMEA'){
                if(quRul.CBU__c==preSal.Commission_BU__c){
                    System.debug('------------EMEA CBU');
                    rulesMap.put(quRul.GEO__c, quRul);
                    
                }
            }
            //sunji03 - FY19 PS/CAN GEO is added
            else if(preSal.GEO__c=='PS/CAN'&&quRul.GEO__c=='PS/CAN'){
                if(quRul.CBU__c==preSal.Commission_BU__c){
                    System.debug('------------PS/CAN CBU');
                    rulesMap.put(quRul.GEO__c, quRul);
                    
                }
            }
            
        }
        
        if(rulesMap.size()>0){
            System.debug('-------Enter into GEO related Queue');
            return rulesMap.get(preSal.GEO__c);
            
        }else  if(preSal.GEO__c=='NA'){ 
            System.debug('-------Enter into Presales Queue NA Mismatch');
            return PreSales_Director_Queues__c.getValues('Presales Queue NA Mismatch');
        }else if(preSal.GEO__c=='APJ'){
            System.debug('-------Enter into Presales Queue APJ Mismatch');
            return PreSales_Director_Queues__c.getValues('Presales Queue APJ Mismatch'); 
        }
        else if(preSal.GEO__c=='EMEA'){
            System.debug('-------Enter into Presales Queue EMEA Mismatch');
            return PreSales_Director_Queues__c.getValues('Presales_Queue_EMEA_Other');    
        }
        //sunji03 - FY19 PS/CAN GEO is added
        else if(preSal.GEO__c=='PS/CAN'){
            System.debug('-------Enter into Presales Queue PSCAN Mismatch');
            return PreSales_Director_Queues__c.getValues('Presales Queue PSCAN Mismatch');           
        }else{
            System.debug('----------------Enter into NULL value');
            return null;
        }
        
    }
    public static Set<id> getUserIdsFromGroup(set<Id> groupId)
    {
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<id> userIds=new Set<id>();
        
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId])
        {
            userIds.add(m.UserOrGroupId);
            if (((String)m.UserOrGroupId).startsWith(userType))
            {
                System.debug('---------------result to UserID'+result);
                result.add(m.UserOrGroupId);
            }
            
            else if (((String)m.UserOrGroupId).startsWith(groupType))
            {
                System.debug('---------------result to Group ID'+result);
                
                result.addAll(GetUSerIdsFromGroup(userIds));
            }
        }
        
        return result;  
    }
    
    
    public PageReference submitForm(){
        
        
        if(selectedProduct=='--None--'||prsal.Start_Date__c==null||prsal.Duration__c==null||prsal.Activity__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Request_Form_Missing_Value));
            return null;
        }
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=oppId; 
        preRecord.GEO__c=listoppProductspick[0].Opportunity.Account.GEO__c;
        preRecord.Activity__c=prsal.Activity__c;
        preRecord.Commission_BU__c=selectedProduct;
        preRecord.Duration__c=prsal.Duration__c;
        preRecord.Start_Date__c=prsal.Start_Date__c;
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
       
        //string qsobjid = PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        //QueueSObject qsobj = [select QueueId from QueueSObject where id=:qsobjid];
        //system.debug('qsobjid'+qsobjid);
        
        
        //preRecord.OwnerId=qsobj.QueueID;
        
        
        insert preRecord;
        List<Presales_Request__c> prelist=new List<Presales_Request__c>{};
            prelist=[Select Name from Presales_Request__c where id= :preRecord.id]; //added the query as part of US331730 by SAMTU01
        List<GroupMember> gmb=[select UserOrGroupId,GroupId from GroupMember where GroupId=:preRecord.OwnerId];
        
        Set<id> userId=new Set<id>();
        
        for(GroupMember grp:gmb){
            userId.add(grp.GroupId);
            
        }
        
        
        String strUr=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PreSalesEditpage?id='+preRecord.id;
        
        
        System.debug('------------gmb----------'+gmb);
        List< Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        String subject = preSalesEmailClass.emailsubject(preRecord.GEO__c, listoppProductspick[0].Opportunity.Account.Sales_Region__c, preRecord.Commission_BU__c, listoppProductspick[0].Opportunity.Segment__c,listoppProductspick[0].Opportunity.Account.Coverage_Model__c);//added cov model in method as part of US334584 by SAMTU01
        String body = preSalesEmailClass.emailbody(listoppProductspick[0].Opportunity.name,listoppProductspick[0].opportunity.Opportunity_Number__c,listoppProductspick[0].Opportunity.owner.name,listoppProductspick[0].Opportunity.Account.name,prelist[0].Name);//added presales req number in method as part of US331730 by SAMTU01
        String pagelink = preSalesEmailClass.presalesrequestpagelink(preRecord.id,strUr);
        body = body + pagelink;
        for(Id emailid:getUserIdsFromGroup(userId)){
            
            Messaging.SingleEmailMessage mail=new  Messaging.SingleEmailMessage();
            
            mail.setSubject(subject);
            mail.saveAsActivity = false;
            mail.setHtmlBody(body);
            mail.setTargetObjectId(emailid);
            mails.add(mail);
            
        }
        Messaging.SendEmailResult[] mailIndicat=Messaging.sendEmail(mails);

        PageReference pg = new PageReference('/'+preRecord.Id);
        pg.setRedirect(true);
        Return pg;
    }
    
    public PageReference cancel(){
        
        PageReference pg = new PageReference('/apex/OpportunityViewOverride?id='+oppId);
        pg.setRedirect(true);
        Return pg;
        
    }
    
    
}