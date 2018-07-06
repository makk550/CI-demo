global class Batch_EmailPartnerOnProductUpdate implements Database.Batchable<sObject>,Database.Stateful   
{

List <Product_Alignment__c> listPA = new  List <Product_Alignment__c>();
     Set <id> AccIds = new Set<id>();
     Set <id>  ProdIds = new Set<id>();
     Set <String> setProductGroup= new Set<String>();
     Map<Id, String> mapProduct = new Map<Id, String>();
      Map<Id, String>  mapAccount= new Map<Id, String>();
     Set <Id> userAccount =new Set<Id>();
     Set <Id> settargetObject = new Set <Id>();
     String[] toAddresses = new list<string> {'danva01@ca.com'};   
     String[] ccAddresses = new list<string> {'danva01@ca.com'};
      Set <String>  setAddresses= new Set<String>();
            Set <Id>  setUserId= new Set<Id>();
            List<Product_Alignment__c> lstproductAlignment = new List<Product_Alignment__c>();
           
    global Batch_EmailPartnerOnProductUpdate()   
   {          
      Date today = Date.today().addDays(-30);
              system.debug('date' + today);
        for(Product2 modifiedProducts : [select Name,Family,Mainframe_or_Distributed__c,Product_Group__c,Market_Focus_Area__c,Time_Capacity_NCV__c,Upfront_Revenue_Eligible__c,SKU__c,SKU_Type__c,Region__c,Status__c,Encrypted__c,Product_Class__c,Disti_Discount__c,Version__c,License_fee__c,maintenance__c,Royalty_product__c,Royalty_Description__c,program__c,Dist_Price__c,Description,TOPS_Code__c,License_metric__c,Media_Language__c,CurrencyIsoCode,SAP_ID__c,IsActive,Start_of_Life_Date__c,End_Of_Life_Date__c,Price_Book_Authorized__c,Partner_Approved__c from product2 where  Salesforce_CPQ_Product__c=false and IsActive=true and Id in (Select Product2Id From PricebookEntry) and LastModifiedDate >= today  Limit 5000])
        {
          system.debug('inside Product2');
          setProductGroup.add(modifiedProducts.Product_Group__c);
        }

        if(setProductGroup != null && setProductGroup.size() > 0 )
        {   
            system.debug('setProductGroup --> ' + setProductGroup);
//            lstproductAlignment = [Select Related_Account__c From Product_Alignment__c  WHERE  Authorized_Agreement__c = true and Product_Group__c in :setProductGroup LIMIT 5000];
         lstproductAlignment = [Select Related_Account__c From Product_Alignment__c  WHERE  Authorized_Agreement__c = true and Product_Group__c in :setProductGroup and Related_Account__c in (select Id from Account where Customer_PriceSheet__c = true) and Related_Account__c in (Select AccountId From User WHERE ProfileId = '00e3000000208rW')];
              for(Product_Alignment__c PA :  [Select Related_Account__c From Product_Alignment__c  WHERE  Authorized_Agreement__c = true and Product_Group__c in :setProductGroup and Related_Account__c in (select Id from Account where Customer_PriceSheet__c = true) and Related_Account__c in (Select AccountId From User WHERE ProfileId = '00e3000000208rW')])
              {
                  userAccount.add(PA.Related_Account__c);              
              }
           //      for(Integer i=0 ;i < lstproductAlignment.size();i++ )
            //       userAccount.add(lstproductAlignment[i].Related_Account__c );
          /*for(User currentUser :  [Select Id,Email,CurrencyIsoCode,AccountId,ProfileId From User WHERE ProfileId = '00e3000000208rW' and AccountId in (select AccountId from contact where HasOptedOutOfEmail = null)  and AccountId in :userAccount and AccountId in(select Id from Account where Customer_PriceSheet__c = true and Id in :userAccount) and AccountId in(Select Related_Account__c From Product_Alignment__c  WHERE  Authorized_Agreement__c = true and Product_Group__c in :setProductGroup)])
          {
              userAccount.add(Id);
          }*/
    }
   
 }  
 global Database.QueryLocator start(Database.BatchableContext BC)   
   {
      String query;
      query =  'Select Id,Email,CurrencyIsoCode,AccountId,ProfileId From User WHERE ProfileId = \'00e3000000208rW\' and AccountId in (select AccountId from contact where HasOptedOutOfEmail = null)  and AccountId in :userAccount and AccountId in(select Id from Account where Customer_PriceSheet__c = true and Id in :userAccount)';
      return Database.getQueryLocator(query);  
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope)   
   {
            
               //setAddresses.add(currentUserAccount.Email);
               //setUserId.add(currentUserAccount.Id);
               String currentUserEmail;
               for(User  currentUserAccount : [Select Id,Email,CurrencyIsoCode,AccountId,ProfileId From User WHERE ProfileId = '00e3000000208rW' and AccountId in (select AccountId from contact where HasOptedOutOfEmail = null)  and AccountId in :userAccount and AccountId in(select Id from Account where Customer_PriceSheet__c = true and Id in :userAccount)])
            {
                     toAddresses.clear();
                     Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();                  
                     currentUserEmail = currentUserAccount.Email;
                     if(currentUserEmail.endsWith('@ca.com') && !setAddresses.contains(currentUserAccount.Email))
                     {
                       toAddresses.add(currentUserAccount.Email);                                
                     }
                     email.setTemplateId('00Xf0000000M24Q');                 
                     email.setToAddresses(toAddresses);
                     email.setTargetObjectId(currentUserAccount.Id);
                     email.setSaveAsActivity(false);
                     
                     if(toAddresses.size() > 0 && toAddresses != null)
                     {
                       Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});          
                       setAddresses.add(currentUserAccount.Email);
                     }
                }   
   }
   
   global void finish(Database.BatchableContext BC)   
   {   
   }  
   
}