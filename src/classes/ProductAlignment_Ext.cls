public with sharing class ProductAlignment_Ext {

    public List<Product_Alignment__c> lstPA{get;set;}
    public boolean editView {get;set;}
    
    public pagereference EditPA()
    {
        editView = true;
        return null;
    }
    
    public pagereference SavePA()
    {
        if(lstPA <> null && lstPA.size() > 0)
            update lstPA;
        editView = false;    
        return null;
    }
    
    
    public ProductAlignment_Ext(ApexPages.StandardController controller) {
            
            account acc = (account) controller.getRecord();
            if(acc <> null && acc.Id <> null && lstPA == null)
            lstPA = [Select p.Route_To_Market__c, p.RTM__c, p.Related_Account__c, p.Product_Group__c, 
                    p.Partner_Delivered_Support__c, p.Partner_Approved__c, p.Business_Unit__c, p.Business_Plan__c, 
                    p.Authorized_Agreement__c, p.Accreditation_Certification__c 
                    From Product_Alignment__c p 
                    WHERE Related_Account__c =: acc.Id
                    ];
    }

@isTest(SeeAllData=true)
public static void productAlignmentTest(){

     Account acc = new Account(Name='Test_Acc1',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
     insert acc;
     ApexPages.StandardController sc = new ApexPages.StandardController( acc );
     ProductAlignment_Ext ext = new ProductAlignment_Ext(sc);
     ext.SavePA();
     ext.EditPA();
}

}