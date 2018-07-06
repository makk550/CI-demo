@isTest//(SeeAllData=true)
public class Ext_PartnerLeadRoutingTest {
    
    public static testMethod void testRoutingExt(){
    
    List<RecordTypes_Setting__c> RTS_lst = new List <RecordTypes_Setting__c> ();
    
    RTS_lst.add(new RecordTypes_Setting__c (Name = 'SMB',RecordType_Id__c ='012V0000000Ckjl',SObject_Name__c='Account'));
    RTS_lst.add(new RecordTypes_Setting__c (Name='CA Indirect Lead',SObject_Name__c = 'Lead', RecordType_Id__c='01230000000Dhu2'));
    RTS_lst.add(new RecordTypes_Setting__c (Name = 'Account Team Covered Account',RecordType_Id__c ='012V0000000Ckjb',SObject_Name__c='Account'));
    RTS_lst.add(new RecordTypes_Setting__c (Name = 'Territory Covered Account',RecordType_Id__c ='012V0000000Ckjg',SObject_Name__c='Account'));

    insert RTS_lst;
    
    List<QueueCust__c> queue_lst = new List <QueueCust__c> ();
    
    queue_lst.add(new QueueCust__c (Name = 'Common Partner Lead Pool', Queue_ID__c ='00G300000036Yjq'));
    queue_lst.add(new QueueCust__c (Name = 'Partner Admin', Queue_ID__c ='00G300000036YkM'));

    insert queue_lst;
    
            Ext_PartnerLeadRouting ObjPLR = new Ext_PartnerLeadRouting();
            
            Partner_Lead_Routing_Rules__c pl = new Partner_Lead_Routing_Rules__c();
            pl.BU__c = 'Alliance';
            pl.NCV_Driver__c = 'RM Other';
            pl.RTM__c = 'Service Provider';
            pl.RTM_Type__c = 'CSP';
            pl.Account_RTM__c = 'Other';
            pl.Account_RTM_Designation__c ='Data Modeling';
            pl.Account_RTM_Type__c = 'Reseller';
            pl.Tie_Breaker_Rule__c = 'Score';
            pl.Rule_Start_Date__c = System.today()-2;
            pl.Rule_Expiration_Date__c= System.today()+2;
            pl.Territory_Region__c = 'NO_GREATLAKES';
            pl.Product_Group__c ='Clarity on Demand'; 
            insert pl;
            
            Partner_Lead_Routing_Rules__c pl_2 = new Partner_Lead_Routing_Rules__c();
            pl_2.BU__c = 'Application Delivery';
            pl_2.NCV_Driver__c = 'Automation';
            pl_2.RTM__c = 'Service Provider';
            pl_2.RTM_Type__c = 'CSP';
            pl_2.Account_RTM__c = 'Service Provider';
            pl_2.Account_RTM_Designation__c ='MSP';
            pl_2.Account_RTM_Type__c = 'Reseller';
            pl_2.Tie_Breaker_Rule__c = 'Round Robin';
            pl_2.Rule_Start_Date__c = System.today()-5;
            pl_2.Rule_Expiration_Date__c= System.today()+1;
            pl_2.Territory_Region__c = 'NO_GREATLAKES';
            pl_2.Product_Group__c ='Client Automation';
            insert pl_2;
            
             Partner_Lead_Routing_Rules__c pl_3 = new Partner_Lead_Routing_Rules__c();
            pl_3.BU__c = 'Applogic';
            pl_3.NCV_Driver__c = 'Applogic';
            pl_3.RTM__c = 'Service Provider';
            pl_3.RTM_Type__c = 'CSP';
            pl_3.Account_RTM__c = 'Service Provider';
           // pl_3.Account_RTM_Designation__c ='MSP';
            pl_3.Account_RTM_Type__c = 'Reseller';
            pl_3.Tie_Breaker_Rule__c = 'Shark Tank';
            pl_3.Rule_Start_Date__c = System.today();
            pl_3.Rule_Expiration_Date__c= System.today()+5;
            pl_3.Territory_Region__c = 'NO_GREATLAKES';
             pl_3.Product_Group__c ='Clarity on Demand';
            insert pl_3;
            
             Partner_Lead_Routing_Rules__c pl_4 = new Partner_Lead_Routing_Rules__c();
            pl_4.BU__c = 'Clarity';
            pl_4.NCV_Driver__c = 'Clarity';
            pl_4.RTM__c = 'Service Provider';
            pl_4.RTM_Type__c = 'CSP';
            pl_4.Account_RTM__c = 'Service Provider';
            pl_4.Account_RTM_Designation__c ='CSP';
            pl_4.Account_RTM_Type__c = 'Reseller';
            pl_4.Tie_Breaker_Rule__c = 'Manual';
            pl_4.Rule_Start_Date__c = System.today()-5;
            pl_4.Rule_Expiration_Date__c= System.today();
            pl_4.Territory_Region__c = 'NO_GREATLAKES';
            pl_4.Product_Group__c ='Client Automation';// Mari Ganesan Chandran
            pl_4.CA_Lead_Admin__c ='00530000007LdXV';
            insert pl_4;
            
           List<Partner_Lead_Routing_Rules__c> plList =[Select ID,BU__c,NCV_Driver__c,RTM__c,RTM_Type__c,Account_RTM__c, Account_RTM_Type__c,Tie_Breaker_Rule__c,Rule_Start_Date__c,Rule_Expiration_Date__c,Territory_Region__c,Product_Group__c,Account_RTM_Designation__c from Partner_Lead_Routing_Rules__c where RTM__c != null and RTM_Type__c != null and Product_Group__c!= null and BU__c!= null and NCV_Driver__c != null and Account_RTM__c!= null and Account_RTM_Type__c!= null  limit 20];
           if(plList == null) plList = new List<Partner_Lead_Routing_Rules__c>();
           plList.add(pl);
           plList.add(pl_2);
           plList.add(pl_3);
            plList.add(pl_4);
            
            RecordType rt = [select id,Name from RecordType where SobjectType='Lead' and Name='CA Global Lead' Limit 1];
            
            Lead lead_1 = new Lead();
            lead_1.LastName = 'Mari';
            lead_1.Company ='CA Technologies';
            lead_1.Status ='New';
            lead_1.No_Interest_Reason__c ='Competitor';
            lead_1.LeadSource ='Marketing Generation - MMI';
            lead_1.RecordTypeId = rt.id;//SystemIdUtility.getGlobalLeadRecordTypeId();
            lead_1.MKT_BU_Category__c ='Other';
            lead_1.MKT_Solution_Set__c ='Spectrum';
            lead_1.Sales_Territory__c= 'NO_GREATLAKES';
            lead_1.Lead_RTM__c ='Alliance';
            lead_1.Lead_RTM_Type__c ='Distributor';
            lead_1.Lead_RTM_Designation__c = 'MSP'; // Need to set and set segment also
            insert lead_1;
            
            Lead lead_2 = new Lead();
            lead_2.LastName = 'Ganesan';
            lead_2.Company ='CA Technologies';
            lead_2.Status ='New';
            lead_2.No_Interest_Reason__c ='Competitor';
            lead_2.LeadSource ='Marketing Generation - MMI';
            lead_2.RecordTypeId = rt.id;//SystemIdUtility.getGlobalLeadRecordTypeId();
            lead_2.MKT_BU_Category__c ='Other';
            lead_2.MKT_Solution_Set__c ='RM Other';
            lead_2.Sales_Territory__c= 'NO_GREATLAKES';
            lead_2.Lead_RTM__c ='Service Provider';
            lead_2.Lead_RTM_Type__c ='CSP';
            lead_2.Lead_RTM_Designation__c = 'CSP';
            insert lead_2;
            
            List<Lead> lList1 = [select OwnerId,Mkt_BU_Category__c,MKT_Solution_Set__c,Lead_RTM__c,Lead_RTM_Designation__c,Lead_RTM_Type__c,Segment__c,Sales_Territory__c from lead where Lead_RTM_Designation__c!= null and Lead_RTM_Type__c!= null and Lead_RTM__c != null and Mkt_BU_Category__c != null and MKT_Solution_Set__c != null and Sales_Territory__c!= null limit 25];
            if(lList1 == null) lList1 = new List<Lead>();
            lList1.add(lead_1);
            lList1.add(lead_2);
            System.debug('Printing From Test '+lList1);
             System.debug('Printing From Test '+plList);
             
            Test.startTest();
            objPLR.matchPLRR(lList1);
            
            objPLR.leadRouting_BUNCV(lList1,plList,'YES');
            objPLR.leadRouting_BUNCV(lList1,plList,'NO');
            
            objPLR.leadRouting_RTM(lList1,plList);
            
            objPLR.leadRouting_RTMDesignation(lList1,plList);
            Test.stopTest();
            
            /*
            pl.Tie_Breaker_Rule__c = 'Score';
            update pl;
             objPLR.matchPLRR(lList1);
             List<Lead> lList2 = [select OwnerId,Mkt_BU_Category__c,MKT_Solution_Set__c,Lead_RTM__c,Lead_RTM_Designation__c,Lead_RTM_Type__c,Segment__c,Sales_Territory__c from lead where Lead_RTM__c = 'Service Provider' and Lead_RTM_Type__c = 'CSP' and Sales_Territory__c= 'NO_GREATLAKES' and segment__c = null limit 5];
            
            objPLR.matchPLRR(lList2);
            
            pl.Tie_Breaker_Rule__c = 'Shark Tank';
            update pl;
            
            objPLR.matchPLRR(lList1);
            objPLR.matchPLRR(lList2);
            
             pl.Tie_Breaker_Rule__c = 'Shark Tank';
            update pl;
            
               objPLR.matchPLRR(lList1);
            objPLR.matchPLRR(lList2);
            */
            
            
       }

}