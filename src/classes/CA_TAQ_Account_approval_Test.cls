@isTest
public class CA_TAQ_Account_approval_Test {

    public static testMethod void testFunc(){
    List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
        
        RecordTypes_Setting__c recordTypeObj12 = new RecordTypes_Setting__c();
        recordTypeObj12.Name = 'Acquistion';
        recordTypeObj12.SObject_Name__c = 'Opportunity';
        recordTypeObj12.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj12);
        
        RecordTypes_Setting__c recordTypeObj13 = new RecordTypes_Setting__c();
        recordTypeObj13.Name = 'Deal Registration - opp';
        recordTypeObj13.SObject_Name__c = 'Opportunity';
        recordTypeObj13.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj13);
        
        RecordTypes_Setting__c recordTypeObj14 = new RecordTypes_Setting__c();
        recordTypeObj14.Name = 'New Opportunity';
        recordTypeObj14.SObject_Name__c = 'Opportunity';
        recordTypeObj14.RecordType_Id__c = '01230000000cohD';
        listOfRecordType.add(recordTypeObj14);
        
        RecordTypes_Setting__c recordTypeObj15 = new RecordTypes_Setting__c();
        recordTypeObj15.Name = 'Partner Opportunity';
        recordTypeObj15.SObject_Name__c = 'Opportunity';
        recordTypeObj15.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj15);
       
        insert listOfRecordType;        
        
        Account acc3 = new Account();
    acc3.Name = 'Partner test acc111';
    acc3.BillingState = 'NY';
    acc3.Region_Country__c = 'IN';
    acc3.Alliance__c = true;
    acc3.Alliance_Program_Level__c = 'Premier';
    acc3.Service_Provider__c = true;
    acc3.Service_Provider_Program_level__c = 'Premier';
    acc3.Solution_Provider__c = true;
    acc3.Solution_Provider_Program_Level__c = 'Premier';
    acc3.Velocity_Seller__c = true;
    acc3.Velocity_Seller_Program_Level__c = 'Advanced';
    acc3.Commercial_Id__c = 'asdf';
    acc3.BillingStreet='Street';
    acc3.BillingCountry='US';
    acc3.BillingCity='New York';
    insert acc3;
        system.debug('acc id'+acc3.id);
    
    List<Route_To_Market__c> rtmlist = new List<Route_To_Market__c>();   
    Route_To_Market__c rtm = new Route_To_Market__c();
    rtm.Account__c = acc3.Id;
    rtm.RTM__c = 'Alliance';
    rtm.Name = 'RTM 1';
    rtmlist.add(rtm);
        
    Route_To_Market__c rtm1 = new Route_To_Market__c();
    rtm1.Account__c = acc3.Id;
    rtm1.RTM__c = 'Alliance';
    rtm1.Name = 'RTM 1';
    rtmlist.add(rtm1);
        
    Route_To_Market__c rtm2 = new Route_To_Market__c();
    rtm2.Account__c = acc3.Id;
    rtm2.RTM__c = 'Solution Provider';
    rtm2.Name = 'RTM 2';
    rtmlist.add(rtm2);
        
    Route_To_Market__c rtm3 = new Route_To_Market__c();
    rtm3.Account__c = acc3.Id;
    rtm3.RTM__c = 'Service Provider';
    rtm3.Name = 'RTM 3';
    rtmlist.add(rtm3);    
    insert rtmlist;    
     /*   
        //try{  
     //Accounts Data
     List<Account> acc = new List<Account>();
     Account acc1 = new Account();
           acc1.Name = 'test 1';
           acc1.BillingStreet = 'Arlington';
           acc1.BillingCountry = 'US';
           acc1.BillingCity = 'VA';
           acc1.Enterprise_ID__c='EA0520';
           acc.add(acc1);
      Account acc2 = new Account();
           acc2.Name = 'test 2';
           acc2.BillingStreet = 'Arlington';
           acc2.BillingCountry = 'US';
           acc2.BillingCity = 'VA';   
           acc2.Enterprise_ID__c='EA0521';
           acc.add(acc2);
           insert acc;   
    */
            //TAQ Accounts 
      List<TAQ_Account__c> Tacc = new List<TAQ_Account__c>();
      TAQ_Account__c Tacc1=new TAQ_Account__c(); 
            Tacc1.name='test 1 acc';
            Tacc1.RecordTypeId = '01230000000cogV';
            Tacc1.View_Acc_Record__c=acc3.id;
            Tacc1.Approval_Process_Status__c = 'Pending Review';
            //Tacc1.Alliance_CAM_PMFKey__c = 'POTAB02';
            Tacc1.Service_Provider__c = true;
            Tacc1.Service_Provider_Type__c = 'GSP';
            Tacc1.Service_Provider_Program_Level__c = 'Advanced';
            Tacc1.Service_Provider_CAM_PMFKey__c = 'POTAB02';
            //Tacc1.Solution_Provider_CAM_PMFKey__c = 'BAJPI01';
            //Tacc1.Velocity_Seller_CAM_PMFKey__c = 'BAJPI01';
            Tacc1.Enterprise_Id__c='EA0520';
            Tacc1.Enterprise_Account_Name__c='test 1';
            Tacc1.Region__c='EMEA';
            Tacc1.Area__c='testa';
            Tacc1.Territory__c='testt';
            Tacc1.Country__c='testc';
            Tacc1.Account_Type__c='test type';
            Tacc1.Approval_Process_Status__c ='Send For Approval';
            Tacc1.OwnerId = '00530000003rQuJ';
            Tacc1.Process_Step__c='Account Add';
            Tacc.add(Tacc1);
       TAQ_Account__c Tacc2=new TAQ_Account__c(); 
            Tacc2.name='test 2 acc';
            Tacc2.RecordTypeId = '01230000000cogV';
            Tacc2.Service_Provider_Type__c = 'GSP';
            Tacc2.Service_Provider_Program_Level__c = 'Advanced';
            //Tacc2.Alliance_CAM_PMFKey__c = 'POTAB02';
            Tacc2.Service_Provider__c = true;
            Tacc2.Service_Provider_CAM_PMFKey__c = 'POTAB02';
            //Tacc2.Solution_Provider_CAM_PMFKey__c = 'BAJPI01';
            //Tacc2.Velocity_Seller_CAM_PMFKey__c = 'BAJPI01';
            Tacc2.View_Acc_Record__c=acc3.id;
            Tacc2.Enterprise_Id__c='EA0521';
            Tacc2.Enterprise_Account_Name__c='test 2';
            Tacc2.Region__c='EMEA';
            Tacc2.Area__c='testa';
            Tacc2.Territory__c='testt';
            Tacc2.Country__c='testc';
            Tacc2.Account_Type__c='test type';
            Tacc2.Approval_Process_Status__c ='Send For Approval';
            Tacc2.Process_Step__c='Account Add';
            Tacc2.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc2);
        TAQ_Account__c Tacc3=new TAQ_Account__c(); 
            Tacc3.name='test 3 acc';
            Tacc3.RecordTypeId = '01230000000cogV';
            Tacc3.Solution_Provider_Program_Level__c = 'Premier';
            Tacc3.Solution_Provider_Type__c = 'Reseller';
            Tacc3.Solution_Provider_CAM_PMFKey__c = 'BAJPI01';
            Tacc3.Solution_Provider__c = true;
            //Tacc2.Velocity_Seller_CAM_PMFKey__c = 'BAJPI01';
            Tacc3.View_Acc_Record__c=acc3.id;
            Tacc3.Enterprise_Id__c='EA0521';
            Tacc3.Enterprise_Account_Name__c='test 2';
            Tacc3.Region__c='EMEA';
            Tacc3.Area__c='testa';
            Tacc3.Territory__c='testt';
            Tacc3.Country__c='testc';
            Tacc3.Account_Type__c='test type';
            Tacc3.Approval_Process_Status__c ='Send For Approval';
            Tacc3.Process_Step__c='Account Add';
            Tacc3.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc3);
        TAQ_Account__c Tacc4=new TAQ_Account__c(); 
            Tacc4.name='test 4 acc';
            Tacc4.RecordTypeId = '01230000000cogV';
            Tacc4.Velocity_Seller_CAM_PMFKey__c = 'BAJPI01';
            Tacc4.Velocity_Seller__c = true;
            Tacc4.Velocity_Seller_Program_Level__c = 'Premier';
            Tacc4.Velocity_Seller_Type__c = 'Reseller';
            Tacc4.View_Acc_Record__c=acc3.id;
            Tacc4.Enterprise_Id__c='EA0521';
            Tacc4.Enterprise_Account_Name__c='test 2';
            Tacc4.Region__c='EMEA';
            Tacc4.Area__c='testa';
            Tacc4.Territory__c='testt';
            Tacc4.Country__c='testc';
            Tacc4.Account_Type__c='test type';
            Tacc4.Process_Step__c='Account Add';    
            Tacc4.Approval_Process_Status__c ='Send For Approval';
            Tacc4.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc4);
        TAQ_Account__c Tacc5=new TAQ_Account__c(); 
            Tacc5.name='test 5 acc';
            Tacc5.RecordTypeId = '01230000000cogV';
            Tacc5.Alliance_CAM_PMFKey__c = 'BAJPI01';
            Tacc5.Alliance__c = true;
            Tacc5.Alliance_Program_Level__c = 'Premier';
            Tacc5.Alliance_Type__c = 'Reseller';
            Tacc5.View_Acc_Record__c=acc3.id;
            Tacc5.Enterprise_Id__c='EA0521';
            Tacc5.Enterprise_Account_Name__c='test 2';
            Tacc5.Region__c='EMEA';
            Tacc5.Area__c='testa';
            Tacc5.Territory__c='testt';
            Tacc5.Country__c='testc';
            Tacc5.Account_Type__c='test type';
            Tacc5.Process_Step__c='Account Add';
            Tacc5.Approval_Process_Status__c ='Send For Approval';
            Tacc5.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc5);
            insert Tacc ;
            
            Map<id,string> mTAQAccOwnerPMFkey = new Map<id,string>();
        for(TAQ_Account__c ta:Tacc){
            mTAQAccOwnerPMFkey.put(Ta.id, String.valueOf(Ta.OwnerId));
            }
                
        
        
            CA_TAQ_Account_Approval_Class temp = new CA_TAQ_Account_Approval_Class();
            temp.validatePMFKeys(Tacc);
            temp.createUpdateStdAccount(Tacc, mTAQAccOwnerPMFkey);
            
            temp.syncmemembers(Tacc[3], Tacc[4], 'BAJPI01', 'POTAB02', 'Advanced');
             Route_To_Market__c rtm4 = new Route_To_Market__c();
             rtm4.Account__c = Tacc[0].View_Acc_Record__c;
             rtm4.RTM__c = 'Service Provider';
             rtm4.Name = 'RTM 3';
              
            insert rtm4;   
        
        
            temp.createTAQAccApprRec(Tacc);
            Tacc1.Approval_Process_Status__c = 'Approved';
            Tacc1.Service_Provider_CAM_PMFKey__c = 'BAJPI01';
            Tacc.add(Tacc1);
            update Tacc[0];
        
       
            /*Tacc3.Approval_Process_Status__c = 'Approved';
            Tacc3.Solution_Provider_CAM_PMFKey__c = 'POTAB02';
            Tacc.add(Tacc3);
            update Tacc[2];
            Tacc4.Approval_Process_Status__c = 'Approved';
            Tacc4.Velocity_Seller_CAM_PMFKey__c = 'POTAB02';
            Tacc.add(Tacc4);
            update Tacc[3];
            Tacc5.Approval_Process_Status__c = 'Approved';
            Tacc5.Alliance_CAM_PMFKey__c = 'POTAB02';
            Tacc.add(Tacc5);
            update Tacc[4];*/
            //update Tacc;
            CA_TAQ_Account_Approval_Class.TAQPartnerRoutes Taq_temp = new CA_TAQ_Account_Approval_Class.TAQPartnerRoutes();
            Taq_temp.velocity = 'velocity';
            Taq_temp.alliance = 'alliance';
            Taq_temp.serviceProvider = 'serviceProvider';
            Taq_temp.solutionProvider = 'solutionProvider';
            
        
    }
}