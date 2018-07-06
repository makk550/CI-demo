@isTest
private class HomePageControllerTests {

  // test method for the HomePageController class
  static testMethod void testHomePageController() {
    // create a new account for testing
    Account testAcc = new Account();
    testAcc.Name = 'testAcc';
    testAcc.Lead_Rating__c = 'B';
    testAcc.Customer_Category__c = 'Reseller';
    testAcc.Account_Status__c = 'Approved';
    testAcc.Reseller_Type__c = 'Value';
    testAcc.CPMS_ID__c = '1900';
    testAcc.BillingState = 'NY';
    testAcc.Reseller_Disti_Regional_ID__c = '12';
    testAcc.Reseller_Distributor_Name__c = 'rdName';    
    testAcc.Commercial_ID__c =   '12';
    testAcc.Commercial_Account_Name__c = 'caName';
    insert testAcc;
    
    // set the page reference
    PageReference homPage = new PageReference('/apex/HomePage');
        Test.setCurrentPage(homPage);
    
    // Instantiate the HomePageController class
    HomePageControllerClass homTestController = new HomePageControllerClass();
    // start the test
        Test.startTest();
        // access the controller methods
        homTestController.getaccList();
        homTestController.getnoOfClosingOpportunities();
        homTestController.getnoOfOpenOpportunities_alert3();
        homTestController.getnoOfOpenOpportunities_alert4();
        homTestController.getnoOfOpenOpportunities_alert5();
        homTestController.getClInsiVisibleFlag();
        homTestController.getTargetVisibleFlag();
        homTestController.getSapImageVisibility();
        homTestController.getSalesWBenchVisibility();
        homTestController.getPricingPortalVisility();
        homTestController.getPerfMgmtVisibility();
        homTestController.getServiceDeskVisibility();
        homTestController.getLeaderBoardVisibility();
        homTestController.getCpmsVisibility();
        homTestController.getCustFeedbackVisibility();
            
        homTestController.getPipelineYTD();
        homTestController.getPipelineQT();
        homTestController.getColumn1StyleYTD();
        homTestController.getColumn2StyleYTD();
        homTestController.getColumn1StyleQT();
        homTestController.getColumn2StyleQT();
        homTestController.getReportLink1Status();
        homTestController.getReportLink2Status();
        homTestController.getColumnHeaderYTD();
        homTestController.getSummaryTable();
        homTestController.getAccTitle();
        homTestController.getAccCol2();
        homTestController.getAccCol3();
        homTestController.getAccCol4();
        homTestController.getAccCol5();
        homTestController.getAccCol6();
        homTestController.getAccCol7();
        homTestController.getTotQualPlineYTD();
        homTestController.getTotClosedPlineYTD();
        homTestController.getTotQualClosedPlineYTD();
        homTestController.getTotQualUnitsYTD();
        homTestController.getTotClosedUnitsYTD();
        homTestController.getTotQualClosedUnitsYTD();
        homTestController.getAccounts();
        homTestController.getNewOpenOpps();
    homTestController.getNewOpenOppList();
    homTestController.getColumnHeaderQT();
        homTestController.getAmtBelow5AlertStyle();
        
        homTestController.view = 'prodView';
        homTestController.view_QT = 'prodView';

        homTestController.getPipelineYTD();
        homTestController.getPipelineQT();
        homTestController.getColumn1StyleYTD();
        homTestController.getColumn2StyleYTD();
        homTestController.getColumn1StyleQT();
        homTestController.getColumn2StyleQT();
        homTestController.getReportLink1Status();
        homTestController.getReportLink2Status();
        homTestController.getColumnHeaderYTD();
        homTestController.getSummaryTable();
        homTestController.getAccTitle();
        homTestController.getAccCol2();
        homTestController.getAccCol3();
        homTestController.getAccCol4();
        homTestController.getAccCol5();
        homTestController.getAccCol6();
        homTestController.getAccCol7();
        homTestController.getTotQualPlineYTD();
        homTestController.getTotClosedPlineYTD();
        homTestController.getTotQualClosedPlineYTD();
        homTestController.getTotQualUnitsYTD();
        homTestController.getTotClosedUnitsYTD();
        homTestController.getTotQualClosedUnitsYTD();
        homTestController.getColumnHeaderQT();
        
        homTestController.userType = 'indirect';
        homTestController.getAccTitle();
        
        homTestController.init();
        
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'direct';
    homTestController.userRoleName ='APJ_';
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'direct';
    homTestController.userRoleName ='EMEA_';
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'direct';
    homTestController.userRoleName ='LA_';
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'direct';
    homTestController.userRoleName ='NA_';
     homTestController.identifyFieldsVisibility();
    homTestController.userType = 'direct';
    homTestController.userRoleName ='PSCAN_';
            
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'indirect';
    homTestController.userRoleName ='APJ_';
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'indirect';
    homTestController.userRoleName ='EMEA_';
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'indirect';
    homTestController.userRoleName ='LA_';
    homTestController.identifyFieldsVisibility();
    homTestController.userType = 'indirect';
    homTestController.userRoleName ='NA_';
     homTestController.identifyFieldsVisibility();
    homTestController.userType = 'indirect';
    homTestController.userRoleName ='PSCAN_';
    homTestController.getOpenOppAlertStyle();
    homTestController.getAmtBelow5AlertStyle();
    homTestController.changeView();
    homTestController.changeQTView();
    homTestController.showMFAviewYTD();
    homTestController.showMFAviewQT();
        homTestController.updateProdPipelineList();
        homTestController.updatePipelineList();
        homTestController.calculatePlineYTDSummary();
        homTestController.calculatePlineYTDProdSummary();
    
    try
    {
      homTestController.pipelineListYTD.get(0).getQualifiedPline();
      homTestController.pipelineListYTD.get(0).getMarketFA();
      homTestController.pipelineListYTD.get(0).getQualifiedPlineD();
      homTestController.pipelineListYTD.get(0).getClosedWon();
      homTestController.pipelineListYTD.get(0).getClosedWonD();
      homTestController.pipelineListYTD.get(0).getPLineAndWon();
      homTestController.pipelineListYTD.get(0).getPLineAndWonD();
      homTestController.pipelineListYTD.get(0).getQualifiedPlineU();
      homTestController.pipelineListYTD.get(0).getClosedWonU();
      homTestController.pipelineListYTD.get(0).getTotalU();
      
      homTestController.accList.get(0).getTotalOppValue();
      homTestController.accList.get(0).gettarget();
      homTestController.accList.get(0).getClosedOpportunities();
      homTestController.accList.get(0).getopenOpportunities();
      homTestController.accList.get(0).getClosedOpenInsideOpportunities();
      homTestController.accList.get(0).getstyle();
      homTestController.accList.get(0).getAccount();
      homTestController.addPlineYTDSummary();
            
    }
    catch(Exception ex)
    {
      // just incase if there are no accounts or opportunities, the exception will be caught
    }    
    
    //HomePageControllerClass.dirProfileIds.add(UserInfo.getProfileId());
    //homTestController.identifyFieldsVisibility();
    // stop the test
        Test.stopTest();         
  } 
  
  // test method for the HomePageControllerPop functions
  static testMethod void test1HomePageControllerPopup() {
    // create a new account for testing
    Account testAcc = new Account();
    testAcc.Name = 'testAcc';
    testAcc.Lead_Rating__c = 'B';
    testAcc.Customer_Category__c = 'Reseller';
    testAcc.Account_Status__c = 'Approved';
    testAcc.Reseller_Type__c = 'Value';
    testAcc.CPMS_ID__c = '1900';
    testAcc.BillingState = 'NY';
    testAcc.Reseller_Disti_Regional_ID__c = '12';
    testAcc.Reseller_Distributor_Name__c = 'rdName';    
    testAcc.Commercial_ID__c =   '12';
    testAcc.Commercial_Account_Name__c = 'caName';
    insert testAcc;
    
    // set the page reference
    PageReference popUpPage = new PageReference('/apex/HomePage?pageState=popsUp&accId='+testAcc.Id+'&oppsType=closedOpps');
        Test.setCurrentPage(popUpPage);
    
    // Instantiate the HomePageController class
    HomePageControllerClass homTestController = new HomePageControllerClass();
    // start the test
        Test.startTest();
        // access the controller methods
        homTestController.init();
        homTestController.getPopUpPageBlockTitle();
        homTestController.getMonthTableStatus();
        homTestController.getMonthlyOpportunities();
        homTestController.opportunityDetailView();
        homTestController.monthlyView();
        homTestController.getMonthwiseOpps();
        homTestController.getMonthwiseOppDetail();
    
    homTestController.view_oppDet = 'oppDetView';
    // stop the test
    Test.stopTest();
  }

  // test method for the HomePageControllerPopUp 1 functions
  static testMethod void test2HomePageControllerPopup() {
    
    // create a new account for testing
    Account testAcc = new Account();
    testAcc.Name = 'testAcc';
    testAcc.Lead_Rating__c = 'B';
    testAcc.Customer_Category__c = 'Reseller';
    testAcc.Account_Status__c = 'Approved';
    testAcc.Reseller_Type__c = 'Value';
    testAcc.CPMS_ID__c = '1900';
    testAcc.BillingState = 'NY';
    testAcc.Reseller_Disti_Regional_ID__c = '12';
    testAcc.Reseller_Distributor_Name__c = 'rdName';    
    testAcc.Commercial_ID__c =   '12';
    testAcc.Commercial_Account_Name__c = 'caName';
    insert testAcc;
    
    /*Opportunity opp = new Opportunity();
    opp.AccountId = testAcc.Id;
    opp.closeDate = Date.newInstance(2009,01,31);
    opp.Probability = 20;
    opp.Name = 'Test Opp1';
    opp.StageName = '100%-Sales Acct. Approved';
    opp.Initial_Billing__c = 21;
    opp.New_Deal_Term_months__c = 24;    
    insert opp;
     

    Opportunity opp1 = new Opportunity();
    opp1.AccountId = testAcc.Id;
    opp1.closeDate = Date.newInstance(2008,12,31);
    opp1.Probability = 20;
    opp1.Name = 'Test Opp2';
    opp1.StageName = '100%-Sales Acct. Approved';
    opp1.Initial_Billing__c = 22;
    opp1.New_Deal_Term_months__c = 24;    
    insert opp1;*/

    // set the page reference
    PageReference popUpPage = new PageReference('/apex/HomePage?pageState=popsUp&accId='+testAcc.Id+'&oppsType=openOpps');
        Test.setCurrentPage(popUpPage);
    
    // Instantiate the HomePageController class
    HomePageControllerClass homTestController = new HomePageControllerClass();
    // start the test
        Test.startTest();
        // access the controller methods
        homTestController.view_oppDet = 'oppDetView';
        homTestController.oppsType = 'closedOpps';
        homTestController.init();
        homTestController.getPopUpPageBlockTitle();
        homTestController.getMonthTableStatus();
        homTestController.getMonthlyOpportunities();
        homTestController.opportunityDetailView();
        homTestController.monthlyView();
        homTestController.getMonthwiseOpps();
        homTestController.getMonthwiseOppDetail();
    homTestController.getMonthValue(1);
    homTestController.getMonthValue(2);
    homTestController.getMonthValue(3);
    homTestController.getMonthValue(4);
    homTestController.getMonthValue(5);
    homTestController.getMonthValue(6);
    homTestController.getMonthValue(7);
    homTestController.getMonthValue(8);
    homTestController.getMonthValue(9);
    homTestController.getMonthValue(10);
    homTestController.getMonthValue(11);
    homTestController.getMonthValue(12);
    homTestController.getMonthValue(13);
    homTestController.resetPopupVariables();
    // stop the test
    Test.stopTest();
  }
  
  // test method for the HomePageControllerPopUp2 functions
  static testMethod void test3HomePageControllerPopup() {
    
    // create a new account for testing
    Account testAcc = new Account();
    testAcc.Name = 'testAcc';
    testAcc.Lead_Rating__c = 'B';
    testAcc.Customer_Category__c = 'Reseller';
    testAcc.Account_Status__c = 'Approved';
    testAcc.Reseller_Type__c = 'Value';
    testAcc.CPMS_ID__c = '1900';
    testAcc.BillingState = 'NY';
    testAcc.Reseller_Disti_Regional_ID__c = '12';
    testAcc.Reseller_Distributor_Name__c = 'rdName';    
    testAcc.Commercial_ID__c =   '12';
    testAcc.Commercial_Account_Name__c = 'caName';
    insert testAcc;
    
    /*Opportunity opp = new Opportunity();
    opp.AccountId = testAcc.Id;
    opp.closeDate = Date.newInstance(2009,01,31);
    opp.Probability = 20;
    opp.Name = 'Test Opp1';
    opp.StageName = '100%-Sales Acct. Approved';
    opp.Initial_Billing__c = 21;
    opp.New_Deal_Term_months__c = 24;    
    insert opp;
     

    Opportunity opp1 = new Opportunity();
    opp1.AccountId = testAcc.Id;
    opp1.closeDate = Date.newInstance(2008,12,31);
    opp1.Probability = 20;
    opp1.Name = 'Test Opp2';
    opp1.StageName = '100%-Sales Acct. Approved';
    opp1.Initial_Billing__c = 22;
    opp1.New_Deal_Term_months__c = 24;    
    insert opp1;*/

    // set the page reference
    PageReference popUpPage = new PageReference('/apex/HomePage?pageState=popsUp2');
        Test.setCurrentPage(popUpPage);
    
    // Instantiate the HomePageController class
    HomePageControllerClass homTestController = new HomePageControllerClass();
    // start the test
        Test.startTest();
        // access the controller methods
        homTestController.getAccounts();
        homTestController.getNewOpenOpps();
        homTestController.getnoOfNewOpenOpportunities_alert6();
        homTestController.getOpenOppAlertStyle();
    homTestController.userType = 'indirect';
    homTestController.userRoleName ='APJ_';
    homTestController.identifyFieldsVisibility();
        homTestController.getOpenOppAlertStyle();
    // stop the test
    Test.stopTest();
  }
     
}