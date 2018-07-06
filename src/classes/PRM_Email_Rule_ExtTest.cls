@istest(SeeAllData=true)
public class PRM_Email_Rule_ExtTest{


@istest(SeeAllData=true)
public static void saveRuleTest(){

    Email_rule__c er = new Email_rule__c();
        er.Action__c = 'Approved';
        er.Email_Capability__c = 'Quick Quote';
        er.Object__c = 'quote';
        er.Object__c = 'Email Field';
        
        insert er;
        
    ApexPages.StandardController sc = new ApexPages.StandardController( er );
    PRM_Email_Rule_Ext ext = new PRM_Email_Rule_Ext(sc);
    ext.getsize1();
    ext.getsize2();
    ext.eri.Recipient_Type__c ='Email Field';
    ext.SaveRule();
    ext.getMyPersonalTemplateOptions();
    ext.AddTemplates();
    ext.addValues();
    ext.removeRecipents();
    ext.removeValues();
    //ext.showFields();
}


}