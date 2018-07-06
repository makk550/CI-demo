@isTest
private class Renewal_Notifactiontest {
    
    static testMethod void testEmailReportNotification()
    {
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        Ruletable_for_Approval_notification__c RuleApproval=new Ruletable_for_Approval_notification__c();
        RuleApproval.Name='Ruled';
        RuleApproval.Market__c='GEM';
        RuleApproval.Segmentation__c='LT';
        RuleApproval.Account_Type__c='Direct';
        RuleApproval.User_To_Be_Notified__c=userinfo.getUserId();
        
        //insert RuleApproval;
        Ruletable_for_Approval_notification__c RuleApproval2=new Ruletable_for_Approval_notification__c();
        RuleApproval2.Name='Ruled2';            
        RuleApproval2.User_To_Be_Notified__c=userinfo.getUserId();          
        //insert RuleApproval2;
        List<Ruletable_for_Approval_notification__c> RuletableList = new List<Ruletable_for_Approval_notification__c>();
        RuletableList.add(RuleApproval);
        RuletableList.add(RuleApproval2);
        insert RuletableList;
        
        Account testaccount =new Account();
        testaccount.Name ='testaccount';
        testaccount.GEO__c='NA';
         testaccount.Market__c='GEM';
        testaccount.Sales_Area__c='PUBLIC SECTOR';
        testaccount.Sales_Region__c='PUB_DOD';
        testaccount.Account_Status__c='Submitted';
        testaccount.Customer_Category__c='Commercial';
        testaccount.Region_Country__c='US';
        testaccount.Enterprise_ID__c='';
        testaccount.Enterprise_Account_Name__c='';        
        
        insert testaccount;
        
        Account testaccount1 =new Account();
        testaccount1.Name ='testaccount1';
        testaccount1.GEO__c='Asia-Pacific';
        testaccount1.Sales_Area__c='ANZ';
        testaccount1.Sales_Region__c='Australia';
        testaccount1.Market__c='GEM';
        testaccount1.Account_Status__c='Submitted';
        testaccount1.Customer_Category__c='Commercial';
        testaccount1.Region_Country__c='US';
        testaccount1.Enterprise_ID__c='';
        testaccount1.Enterprise_Account_Name__c='';        
        
        insert testaccount1;
        
        List<Renewal__c> lsttemp;
        Renewal__c renewal1 =new Renewal__c(Name='testRenewal',        
        Segmentation__c='MT',Segmentation_Reason__c='Acquisition/Indirect-move to MT, Invalid',
        Change_Of_Projected_Renewal__c=6.00,
        Account__c=testaccount.Id,ChangeDate__c = date.today());
        //insert renewal1;       
        Renewal__c renewal2 =new Renewal__c(Name='testRenewal1',        
        Segmentation__c='MT',Segmentation_Reason__c='Acquisition/Indirect-move to MT, Invalid',        
        Account__c=testaccount1.Id,ChangeDate__c = date.today());
        insert renewal2 ;
        
        List<Renewal__c> RenwalList = new List<Renewal__c>();
        RenwalList.add(renewal1);
        insert RenwalList;

        
        Renewal_Notification notification =new Renewal_Notification();
        //notification.EmailReportNotification();
        
        notification.sendEmail('Testing','testing@tt.com');
    }   
}