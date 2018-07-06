@istest
private class  Test_UpdateAccountProducts{

    static testMethod void myUnitTest3() {

        List<RecordTypes_Setting__c> lstaccrectype = new List<RecordTypes_Setting__c>();
        lstaccrectype.add(new RecordTypes_Setting__c(name = 'Commercial Account',RecordType_Id__c = '01230000000GaFY', SObject_Name__c = 'Account'));
        lstaccrectype.add(new RecordTypes_Setting__c(name = 'SMB',RecordType_Id__c = '01230000001L55j', SObject_Name__c = 'Account'));
        lstaccrectype.add(new RecordTypes_Setting__c(name = 'Territory Covered Account',RecordType_Id__c = '01230000001L55o', SObject_Name__c = 'Account'));
        lstaccrectype.add(new RecordTypes_Setting__c(name = 'Reseller/Distributor Account',RecordType_Id__c = '01230000000GaFd', SObject_Name__c = 'Account'));
        lstaccrectype.add(new RecordTypes_Setting__c(name = 'Account Team Covered Account',RecordType_Id__c = '01230000001L55e', SObject_Name__c = 'Account'));
        lstaccrectype.add(new RecordTypes_Setting__c(name = 'CA Enterprise Account',RecordType_Id__c = '01230000000DNfM', SObject_Name__c = 'Account'));
        insert lstaccrectype;
        
        RecordType accrec = [select ID,Name from RecordType where Name='Account Team Covered Account' and SObjectType='Account'];
        
        Account createacc = new Account(Name='Acc 1',GEO__c='NA',RecordTypeId=accrec.id,Customer_Category__c='Enterprise',Enterprise_ID__c='ACC001',Enterprise_Account_Name__c='Ent Acc');
        insert createacc;
        ///for After Insert Trigger
        Product_Alignment__c  objPAl1 = new Product_Alignment__c(Product_Group_MPL__c='TestSiteMinder',Related_Account__c=createacc.id  );
        Product_Alignment__c  objPAl2 = new Product_Alignment__c(Product_Group_MPL__c='TestSiteMinder',Related_Account__c=createacc.id);
        List<Product_Alignment__c> lstprodalignment = new List<Product_Alignment__c>();

        lstprodalignment.add(objPAl1);
        lstprodalignment.add(objPAl2);
        insert lstprodalignment;
        
        ///for After update Trigger
        for(Product_Alignment__c prodal: lstprodalignment) {
            prodal.Notes__c = 'Updated notes';
        }
        Update lstprodalignment;
        //For Delete Trigger 
       
       //List<Product_Alignment__c>  lstPAlDel = [Select id, Notes__c ,Product_Group_MPL__c,Related_Account__c  from Product_Alignment__c where  Related_Account__c!= null  and  (JP_Product_Group__c != null  OR Product_Group_MPL__c != null )  limit 3  ];
        
        //List<Product_Alignment__c>  lstPAlDel = [Select id, Notes__c ,Product_Group_MPL__c,Related_Account__c  from Product_Alignment__c where  Related_Account__c!= null  and  (Product_Group_MPL__c != null ) and id =:prodal ];
        Database.Delete( lstprodalignment);      
        
        
        
     }//end TestMethod
    
}/// end class