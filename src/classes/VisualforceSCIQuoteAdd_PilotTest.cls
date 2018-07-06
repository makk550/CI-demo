@isTest
private class VisualforceSCIQuoteAdd_PilotTest{

    /**
    * TestVisualforceSCIQuoteAdd_Pilot : used for test coverage of VisualforceSCIQuoteAdd_Pilot
    *
    * @param 
    * @return void
    * @throws 
    */
    
   public static testmethod void TestVisualforceSCIQuoteAdd_Pilot(){
      ApexPages.StandardController sCtrl = new ApexPages.StandardController(new scpq__SciQuote__c());
      Test.setCurrentPage(Page.VisualforceSCIQuoteAdd_Pilot);
      VisualforceSCIQuoteAdd_Pilot obj = new VisualforceSCIQuoteAdd_Pilot(sCtrl);
      pagereference pg = obj.urlRedirect();
      String str = obj.iframeHeight;
   }
   /**
    * TestVisualforceSCIQuoteDelete_Pilot : used for test coverage of VisualforceSCIQuoteDelete_Pilot
    *
    * @param 
    * @return void
    * @throws 
    */ 
   public static testmethod void TestVisualforceSCIQuoteDelete_Pilot(){
      ApexPages.StandardController sCtrl = new ApexPages.StandardController(new scpq__SciQuote__c());
      Test.setCurrentPage(Page.VisualforceSCIQuoteDelete_Pilot);
      VisualforceSCIQuoteDelete_Pilot obj = new VisualforceSCIQuoteDelete_Pilot(sCtrl);
      pagereference pg = obj.urlRedirect();
      String str = obj.iframeHeight;
   } 
   /**
    * TestVisualforceSCIQuoteEdit_Pilot : used for test coverage of VisualforceSCIQuoteEdit_Pilot
    *
    * @param 
    * @return void
    * @throws 
    */
   public static testmethod void TestVisualforceSCIQuoteEdit_Pilot(){
      ApexPages.StandardController sCtrl = new ApexPages.StandardController(new scpq__SciQuote__c());
      Test.setCurrentPage(Page.VisualforceSCIQuoteEdit_Pilot);
      VisualforceSCIQuoteEdit_Pilot obj = new VisualforceSCIQuoteEdit_Pilot(sCtrl);
      pagereference pg = obj.urlRedirect();
      String str = obj.iframeHeight;
    }
    /**
    * TestVisualforceSCIQuoteView_Pilot : used for test coverage of VisualforceSCIQuoteView_Pilot
    *
    * @param 
    * @return void
    * @throws 
    */
    public static testmethod void TestVisualforceSCIQuoteView_Pilot(){
      ApexPages.StandardController sCtrl = new ApexPages.StandardController(new scpq__SciQuote__c());
      Test.setCurrentPage(Page.VisualforceSCIQuoteView_Pilot);
      VisualforceSCIQuoteView_Pilot obj = new VisualforceSCIQuoteView_Pilot(sCtrl);
      pagereference pg = obj.urlRedirect();
      String str = obj.iframeHeight;
    }
    /**
    * TestVisualforceSCIQuoteIdentifyCPQUser : used for test coverage of VisualforceSCIQuoteIdentifyCPQUser
    *
    * @param 
    * @return void
    * @throws 
    */
    public static testmethod void TestVisualforceSCIQuoteIdentifyCPQUser(){
      VisualforceSCIQuoteIdentifyCPQUser.isValidCPQUser();
   }
}