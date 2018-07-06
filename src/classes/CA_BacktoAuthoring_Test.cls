@isTest
public Class CA_BacktoAuthoring_Test{
 
  static testMethod void testMethod1(){
    User u = [select Id, profileId, Name,isActive from User where Profile.Name= 'Global Quote Support/Deal Desk' AND isActive = true limit 1];
    RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
    RecordType ndaRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Standard_NDA' AND SObjectType = 'Apttus__APTS_Agreement__c'];
    
    List<Apttus__APTS_Agreement__c> agrListToInsert = new List<Apttus__APTS_Agreement__c >();
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
    agr1.Apttus__Status_Category__c = 'In Authoring';
    agr1.Apttus__Status__c = 'Author Contract';
    agrListToInsert.add(agr1);
    
    Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c();
    agr.Name = 'Test Agreement';
    agr.Apttus__Contract_Start_Date__c = System.today();
    agr.CA_Agreement_Type__c = 'Order Form' ;
    agr.RecordTypeId = ndaRec.id;    
    //agr1.Sterling_Quote__c = listOfquote[0].id;
    agr.CA_Geo__c = 'NA';
    agr.CA_Sales_Territory__c = 'AUSTRALIA';
    agr.CA_Language__c = 'English';
    agr.CA_Operating_Area__c = 'Public Sector/Canada';
    agr.CA_Sales_Region__c = 'AUSTRALIA';
    agr.CA_Classified_Contract__c = 'Yes';
    agr.Apttus__Status_Category__c = 'Approved';
    agr.Apttus__Status__c = 'Approved';
    agr.CA_NDA_Flag__c = 'Standard NDA';
    agrListToInsert.add(agr);
    
    insert agrListToInsert;
    
    System.runAs(u) {
    Apttus__APTS_Agreement__c agr2 = new Apttus__APTS_Agreement__c();
    agr2.Name = 'Test Agreement';
    agr2.Apttus__Contract_Start_Date__c = System.today();
    agr2.CA_Agreement_Type__c = 'Order Form' ;
    agr2.RecordTypeId = ndaRec.id;    
    //agr1.Sterling_Quote__c = listOfquote[0].id;
    agr2.CA_Geo__c = 'NA';
    agr2.CA_Sales_Territory__c = 'AUSTRALIA';
    agr2.CA_Language__c = 'English';
    agr2.CA_Operating_Area__c = 'Public Sector/Canada';
    agr2.CA_Sales_Region__c = 'AUSTRALIA';
    agr2.CA_Classified_Contract__c = 'Yes';
    //agr2.Apttus__Status_Category__c = 'Approved';
    //agr2.Apttus__Status__c = 'Approved';
    //agr2.CA_NDA_Flag__c = 'Standard NDA';
    insert agr2;
    }
    
    PageReference pageRef = Page.CA_BacktoAuthoring;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('id', agr1.id);
    CA_BacktoAuthoring ca = new CA_BacktoAuthoring();
    ca.updateAgreementStatus();
       ApexPages.currentPage().getParameters().put('id', agr.id);
    CA_BacktoAuthoring ca1 = new CA_BacktoAuthoring();
    ca1.updateAgreementStatus();


 }   
}