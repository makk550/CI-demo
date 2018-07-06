global class ContractsInvalidation implements Messaging.InboundEmailHandler {
      public boolean runTest = false;
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          //Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          //---THIS EMAIL SERVICE GETS INVOKED WHEN ACL LOAD IS DONE FROM INFORMATICA END AND DEVELOPED DURING DECEMBER MINI RELEASE 2012---
          System.debug('++++++++In InboundEmailHandler +++++++');          
          ContractsInvalidationBatch CIB = new ContractsInvalidationBatch();          
          Date myDate = System.Today()-30;
          DateTime lastOneMonthDateTime = DateTime.newInstance(myDate.Year(), myDate.Month(), myDate.Day());
          CIB.DT = lastOneMonthDateTime.formatGMT('yyyy-MM-dd') + 'T' + lastOneMonthDateTime.formatGMT('HH:mm:ss.SSS') + 'Z';
          
          DateTime currentDateTime = System.Now()-1;
          CIB.CDT = currentDateTime.formatGMT('yyyy-MM-dd') + 'T' + currentDateTime.formatGMT('HH:mm:ss.SSS') + 'Z';
          
          if(SystemIdUtility.runTestContractsInvalidation){//---If we run test method of this class then this query will be executed else the actual query with NO LIMIT will get executed
              CIB.Query = 'SELECT Id,Contract_Product__c,Contract_Product__r.Active_Contract__c,ACL_Status__c,Licensed_MIPS_Quantity__c,CreatedDate from Active_Contract_Line_Item__c where CreatedDate >=' + CIB.CDT + 'OR LastModifiedDate >='+ CIB.DT + 'LIMIT 200';
              SystemIdUtility.runTestContractsInvalidation = false;
          }else{
              CIB.Query = 'SELECT Id,Contract_Product__c,Contract_Product__r.Active_Contract__c,ACL_Status__c,Licensed_MIPS_Quantity__c,CreatedDate from Active_Contract_Line_Item__c where CreatedDate >=' + CIB.CDT + 'OR LastModifiedDate >='+ CIB.DT;
          }
            
          //CIB.Query = 'SELECT Id,Contract_Product__c,Contract_Product__r.Active_Contract__c,ACL_Status__c,Licensed_MIPS_Quantity__c,CreatedDate from Active_Contract_Line_Item__c where CreatedDate >=' + CIB.DT + 'OR LastModifiedDate >='+ CIB.DT;
          /*Date currentDate = System.Today();
          DateTime currentDateTime = DateTime.newInstance(currentDate.Year(), currentDate.Month(), currentDate.Day());            
          System.debug('++++++++currentDateTime++++++++'+currentDateTime);
          CIB.current = currentDateTime.formatGMT('yyyy-MM-dd') + 'T' + currentDateTime.formatGMT('HH:mm:ss.SSS') + 'Z';
          Date previousDate = System.Today()-1;
          DateTime previousDateTime = DateTime.newInstance(previousDate.Year(), previousDate.Month(), previousDate.Day());            
          System.debug('++++++++previousDateTime++++++++'+previousDateTime);            
          CIB.previous = previousDateTime.formatGMT('yyyy-MM-dd') + 'T' + previousDateTime.formatGMT('HH:mm:ss.SSS') + 'Z';
          CIB.Query = 'SELECT Id,Contract_Product__c,Contract_Product__r.Active_Contract__c,ACL_Status__c,Licensed_MIPS_Quantity__c from Active_Contract_Line_Item__c where CreatedDate >=' + CIB.previous + 'OR LastModifiedDate >='+ CIB.previous;
          */
          //Id i = 'a1t30000000NmQ5';
          //CIB.Query = 'SELECT Id,Contract_Product__c,Contract_Product__r.Active_Contract__c,ACL_Status__c,CreatedDate from Active_Contract_Line_Item__c where Id=\'' + i + '\'';          
          //CIB.Query = 'SELECT Id,Contract_Product__c,Contract_Product__r.Active_Contract__c,ACL_Status__c,Licensed_MIPS_Quantity__c,CreatedDate from Active_Contract_Line_Item__c where CreatedDate >=' + CIB.CDT;
          SystemIdUtility.skipAccountOnMIPSUpdate = false;
          ID batchprocessid = Database.executeBatch(CIB);
          return null;
      }      
  }