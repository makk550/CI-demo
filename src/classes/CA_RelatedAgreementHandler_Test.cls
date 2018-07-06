@isTest(seeAllData = true)
public class CA_RelatedAgreementHandler_Test{

 static testMethod void testRelAgreement(){
        RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        
        List<Apttus__APTS_Agreement__c> agreeToInsert= new List<Apttus__APTS_Agreement__c>();
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.CA_Agreement_Type__c = 'Order Form' ;
        agr1.RecordTypeId = agrRec.id;        
        
        agr1.CA_Agreement_Sub_Type__c = 'Education';
        agr1.CA_Sales_Type__c = 'Direct';
        agreeToInsert.add(agr1);
        
        Apttus__APTS_Agreement__c agr2 = new Apttus__APTS_Agreement__c();
        agr2.Name = 'Test Agreement';
        agr2.Apttus__Contract_Start_Date__c = System.today();
        agr2.CA_Agreement_Type__c = 'Order Form' ;
        agr2.RecordTypeId = agrRec.id;        
       
        agr2.CA_Agreement_Sub_Type__c = 'Education';
        agr2.CA_Sales_Type__c = 'Direct';
        agreeToInsert.add(agr2);
        
        if(agreeToInsert.size()>0){
            insert agreeToInsert;
        }
 
     Apttus__APTS_Related_Agreement__c relAgr = new Apttus__APTS_Related_Agreement__c();
     relAgr.Apttus__APTS_Contract_To__c = agreeToInsert[0].id;
     relAgr.Apttus__Relationship_From_Type__c = agreeToInsert[1].id;
     insert relAgr ;
 }
 
 }