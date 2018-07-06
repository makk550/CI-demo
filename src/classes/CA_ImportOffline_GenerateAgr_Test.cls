@isTest(SeeAllData = true)
public Class CA_ImportOffline_GenerateAgr_Test{

PageReference pref;
    public static testMethod void testmeth1(){
    RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.CA_Agreement_Type__c = 'Order Form' ;
        agr1.RecordTypeId = agrRec.id;    
        //agr1.Sterling_Quote__c = listOfquote[0].id;
        agr1.CA_Geo__c = 'NA';
        agr1.CA_Sales_Territory__c = 'AUSTRALIA';
        agr1.CA_Language__c = 'English';
        agr1.CA_Operating_Area__c = 'Public Sector/Canada';
        agr1.CA_Sales_Region__c = 'AUSTRALIA';
        agr1.CA_Classified_Contract__c = 'Yes';
        agr1.Apttus__Status_Category__c = 'Request';
        agr1.Apttus__Status__c = 'Request';
        agr1.CA_Agreement_Amends_Terms_of_Master__c = null;
        insert agr1;
        
        PageReference pref = new PageReference('apex/apex/CA_GenerateAgreement?id='+agr1.id);
        pref.setRedirect(true);
    }
}