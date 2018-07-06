global class SFCPQ_Product2History_BatchJob implements Database.Batchable<sObject>,Database.Stateful {
    
    global String finalString = 'Product, Field Name, Old Value, New Value, User Name, Modified Date \n';
    Set<String> fieldSet = new Set<String>{'Target_Approval__c','Sales_Management_Approval__c','Floor_Approval__c',
        'SBQQ__SubscriptionPricing__c','SBQQ__SubscriptionTerm__c','SBQQ__SubscriptionBase__c',
        'SBQQ__SubscriptionPercent__c','Product_Code_For_Promotions__c'};
            
            global Database.QueryLocator start(Database.BatchableContext bc){
                List<SFCPQ_Audit_History__c> productAuditHistory = new List<SFCPQ_Audit_History__c>();
                productAuditHistory = [select id,createddate from SFCPQ_Audit_History__c where Object_Name__c=:'Product2History' order by createddate desc];
                string query;
                if(productAuditHistory.size()>0){
                    DateTime lastCreatedDate = productAuditHistory[0].createddate;
                    query = 'SELECT Field, OldValue,NewValue,CreatedDate,CreatedBy.Name,Product2.Name FROM Product2History where Field IN: fieldSet and Product2.Salesforce_CPQ_Product__c=true and CreatedDate>:lastCreatedDate';  
                }	                  
                else
                    query = 'SELECT Field, OldValue,NewValue,CreatedDate,CreatedBy.Name,Product2.Name FROM Product2History where Field IN: fieldSet and Product2.Salesforce_CPQ_Product__c=true ';    
                return Database.getQueryLocator(query);
            }
    
    global void execute(Database.BatchableContext bc,List<Product2History> product2History){
        
        for(Product2History ph:product2History){
            finalString = finalString + ph.Product2.Name + ',' + ph.Field + ',' + ph.OldValue + ',' + ph.NewValue + ',' + ph.CreatedBy.Name + ',' + ph.CreatedDate + '\n';
        }
        
        
    }
    
    // for pre processing operations - called after batch job is finished
    global void finish(Database.BatchableContext bc){
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalString);
        string csvname= 'ProductHistory.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'bajpi01@ca.com'};
        String subject ='Product History';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Product History');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        SFCPQ_Audit_History__c auditRecord = new SFCPQ_Audit_History__c(Object_Name__c='Product2History');
        insert auditRecord;
    }
    
}