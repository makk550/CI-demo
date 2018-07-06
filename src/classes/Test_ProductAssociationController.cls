@isTest
public class Test_ProductAssociationController{
    
    private static String articleNumber;
    private static String productId1;
    private static String productId;
    private static String componentString;
    private static String releaseString;
    private static String articleKnwId;
    private static List<knowledge__kav> listKnowledgeObj;
    private static String URLNameVal;
    
    private static testMethod void productAssociationMethod(){
        Test.startTest();
        createTestData();
        apexpages.currentpage().getparameters().put('aId', articleNumber);
        ApexPages.currentPage().getHeaders().put('Host','comm.support.ca.com');
        ProductAssociationController controller = new ProductAssociationController();
        apexpages.currentpage().getparameters().put('productName', productId);
        controller.productComponent();
        controller.getProductComponent();
        controller.getSelectedComponents();
        controller.getRelease();
        controller.getSelectedReleases();
        apexpages.currentpage().getparameters().put('productId', productId);
        apexpages.currentpage().getparameters().put('articleNum', articleNumber);
        apexpages.currentpage().getparameters().put('prepareCompString', componentString);
        apexpages.currentpage().getparameters().put('prepareReleaseString', releaseString);
        controller.createPrimaryProductAssociation();
        controller.cancelDetails();
        apexpages.currentpage().getparameters().put('productRecordId', productId);
        controller.fetchValuesForEdit();
        apexpages.currentpage().getparameters().put('buttonId', 'saveAndCloseButton');
        controller.submitProductAssociation();
        
        apexpages.currentpage().getparameters().put('productId', productId);
        apexpages.currentpage().getparameters().put('productFlag', 'true');
        apexpages.currentpage().getparameters().put('productComponent', componentString);
        apexpages.currentpage().getparameters().put('productRelease', releaseString);
        apexpages.currentpage().getparameters().put('artNum', articleNumber);
        controller.callRemoveProduct();
        Test.stopTest();
    }

    @IsTest
      static void should_get_pendingCaseNumber() {
          KBDetailsController turkeySvcMock = new KBDetailsController();
          //Case aCase = buildCase();
          //aCase.Next_Action__c = System.label.Pending_Customer ;
          turkeySvcMock.testData();
          Test.startTest();
          String s = KBDetailsController.pendingCaseNumber;
          Test.stopTest();
          System.assertNotEquals(null,s);
      }
            
    private static testMethod void productAssociationMethod2(){
        Test.startTest();
        createTestData();
        apexpages.currentpage().getparameters().put('aId', articleNumber);
        ProductAssociationController controller = new ProductAssociationController();
        apexpages.currentpage().getparameters().put('productName', productId1);
        controller.productComponent();
        controller.getProductComponent();
        controller.getSelectedComponents();
        controller.getRelease();
        controller.getSelectedReleases();
        apexpages.currentpage().getparameters().put('productId', productId1);
        apexpages.currentpage().getparameters().put('articleNum', articleNumber);
        apexpages.currentpage().getparameters().put('prepareCompString', componentString);
        apexpages.currentpage().getparameters().put('prepareReleaseString', releaseString);
        controller.createPrimaryProductAssociation();
        controller.cancelDetails();
        apexpages.currentpage().getparameters().put('productRecordId', productId1);
        controller.fetchValuesForEdit();
        apexpages.currentpage().getparameters().put('buttonId', 'saveAndCloseButton');
        controller.submitProductAssociation();
        
        apexpages.currentpage().getparameters().put('productId', productId1);
        apexpages.currentpage().getparameters().put('productFlag', 'true');
        apexpages.currentpage().getparameters().put('productComponent', componentString);
        apexpages.currentpage().getparameters().put('productRelease', releaseString);
        apexpages.currentpage().getparameters().put('artNum', articleNumber);
        controller.callRemoveProduct();
        Test.stopTest();
    }
    
    private static testMethod void productAssociationMethod1(){
        Test.startTest();
        //createTestData();
        apexpages.currentpage().getparameters().put('aId', '');
        ProductAssociationController controller = new ProductAssociationController();
        Test.stopTest();
    }
    
    private static testMethod void productAssociationMethod3(){
        Test.startTest();
        createTestData();
        KbManagement.PublishingService.publishArticle(articleKnwId, true);
        apexpages.currentpage().getparameters().put('aId', articleNumber);
        ProductAssociationController controller = new ProductAssociationController();
    }
    
    private static testMethod void method1(){
        test.startTest();
        createTestData();
        apexpages.currentpage().getparameters().put('id', articleKnwId);
        KBPreviewController KBPreviewControllerObj = new KBPreviewController(new ApexPages.StandardController(listKnowledgeObj[0]));
        test.stopTest();
    }
    
     private static testMethod void method2(){
        test.startTest();
        createTestData();
        List<knowledge__kav> knowledgeObject = [Select id, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[1].id];
        KbManagement.PublishingService.publishArticle(knowledgeObject[0].knowledgeArticleId, true);
        apexpages.currentpage().getparameters().put('id', knowledgeObject[0].knowledgeArticleId);
        KBPreviewController KBPreviewControllerObj = new KBPreviewController(new ApexPages.StandardController(knowledgeObject[0]));
        test.stopTest();
    }
    
    private static testMethod void method3(){
        test.startTest();
        createTestData();
        List<knowledge__kav> knowledgeObject = [Select id, title, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[1].id];
        KbManagement.PublishingService.publishArticle(knowledgeObject[0].knowledgeArticleId, true);
        apexpages.currentpage().getparameters().put('id', knowledgeObject[0].articleNumber);
        KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.getKBArticles();
        
        apexpages.currentpage().getparameters().put('hrefVal', listKnowledgeObj[0].URLName);
        KBDetailsControllerObj.articleDetails();
        
        apexpages.currentpage().getparameters().put('hrefVal', knowledgeObject[0].URLName);
        KBDetailsControllerObj.articleDetails();
        test.stopTest();
    }
    
    private static testMethod void method6(){
        test.startTest();
        createTestData();
        List<knowledge__kav> knowledgeObject = [Select id, title, URLName, articleNumber,knowledgeArticleId,IsVisibleInPkb,Publishstatus from knowledge__kav where id=:listKnowledgeObj[2].id];
        system.debug('-----status-----'+knowledgeObject[0].Publishstatus+'-----isInvisible-----'+knowledgeObject[0].IsVisibleInPkb);
        
        knowledge__kav testKnowledge = [select id,Publishstatus,IsVisibleInPkb,articleNumber,knowledgeArticleId,Content4__c,
                                        Content2__c,Question__c,Content1__c,Content3__c,Instructions__c from knowledge__kav where id=:knowledgeObject[0].id limit 1];
        testKnowledge.IsVisibleInPkb = true;
        testKnowledge.Content4__c = '<a></a>';
        testKnowledge.Content2__c = '<a></a>';
        testKnowledge.Question__c = '<a></a>';
        testKnowledge.Content1__c = '<a></a>';
        testKnowledge.Content3__c = '<a></a>';
        testKnowledge.Instructions__c = '<a></a>';
        update testKnowledge;
        KbManagement.PublishingService.publishArticle(testKnowledge.knowledgeArticleId, true);
        system.debug('---article number----'+knowledgeObject[0].articleNumber);
        testKnowledge = [select id,Publishstatus,IsVisibleInPkb from knowledge__kav where articlenumber=:knowledgeObject[0].articleNumber limit 1];
        system.debug('-----status-----'+testKnowledge.Publishstatus+'-----isInvisible-----'+testKnowledge.IsVisibleInPkb);
        
        apexpages.currentpage().getparameters().put('id', knowledgeObject[0].articleNumber);
        KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.getKBArticles();
        test.stopTest();
    }
    
     private static testMethod void method7(){
        test.startTest();
        createTestData();
        List<knowledge__kav> knowledgeObject = [Select id, title, URLName, articleNumber,knowledgeArticleId,IsVisibleInPkb,Publishstatus from knowledge__kav where id=:listKnowledgeObj[2].id];
        system.debug('-----status--method7---'+knowledgeObject[0].Publishstatus+'-----isInvisible-----'+knowledgeObject[0].IsVisibleInPkb);
        
        knowledge__kav testKnowledge = [select id,Publishstatus,IsVisibleInPkb,articleNumber,knowledgeArticleId,Content4__c,
                                        Content2__c,Question__c,Content1__c,Content3__c,Instructions__c,
                                        Additional_Information__c, Answer__c,Background__c from knowledge__kav where id=:knowledgeObject[0].id limit 1];
        testKnowledge.IsVisibleInPkb = true;
        testKnowledge.Content4__c = '';
        testKnowledge.Content2__c = '';
        testKnowledge.Question__c = '';
     //   testKnowledge.Content1__c = ;
        testKnowledge.Content3__c = '';
        testKnowledge.Instructions__c = '';
         testKnowledge.Additional_Information__c = '';
         testKnowledge.Answer__c = '';
         testKnowledge.Background__c = '';
        update testKnowledge;
        KbManagement.PublishingService.publishArticle(testKnowledge.knowledgeArticleId, true);
        system.debug('---article number---method7-'+knowledgeObject[0].articleNumber);
        testKnowledge = [select id,Publishstatus,IsVisibleInPkb from knowledge__kav where articlenumber=:knowledgeObject[0].articleNumber limit 1];
        system.debug('-----status----method7-'+testKnowledge.Publishstatus+'-----isInvisible-----'+testKnowledge.IsVisibleInPkb);
        
        apexpages.currentpage().getparameters().put('id', knowledgeObject[0].articleNumber);
        KBDetailsController KBDetailsControllerObj = new KBDetailsController();
         KBDetailsControllerObj.getKBArticles();
        test.stopTest();
    }
    private static testMethod void method8(){
        test.startTest();
        createTestData();
        List<knowledge__kav> knowledgeObject = [Select id, title, URLName, articleNumber,knowledgeArticleId,IsVisibleInPkb,Publishstatus from knowledge__kav where id=:listKnowledgeObj[3].id];
        system.debug('-----status---method8--'+knowledgeObject[0].Publishstatus+'-----isInvisible-----'+knowledgeObject[0].IsVisibleInPkb);
        
        knowledge__kav testKnowledge = [select id,Publishstatus,IsVisibleInPkb,articleNumber,knowledgeArticleId,Content4__c,
                                        Content2__c,Question__c,Content1__c,Content3__c,Instructions__c,
                                        Additional_Information__c, Answer__c,Background__c from knowledge__kav where id=:knowledgeObject[0].id and publishstatus='draft' limit 1];
        
        System.debug(' Method 8 : Content4__c'+ testKnowledge.Content4__c);
        testKnowledge.IsVisibleInPkb = true;
        //testKnowledge.Content4__c = '';
        testKnowledge.Content2__c = '';
        testKnowledge.Question__c = '';
     //   testKnowledge.Content1__c = ;
        testKnowledge.Content3__c = '';
        testKnowledge.Instructions__c = '';
         testKnowledge.Additional_Information__c = '';
         testKnowledge.Answer__c = '';
         testKnowledge.Background__c = '';
        update testKnowledge;
        KbManagement.PublishingService.publishArticle(testKnowledge.knowledgeArticleId, true);
        system.debug('---article number----'+knowledgeObject[0].articleNumber);
        testKnowledge = [select id,Publishstatus,IsVisibleInPkb from knowledge__kav where articlenumber=:knowledgeObject[0].articleNumber limit 1];
        system.debug('-----status-----'+testKnowledge.Publishstatus+'-----isInvisible-----'+testKnowledge.IsVisibleInPkb);
        
        apexpages.currentpage().getparameters().put('id', knowledgeObject[0].articleNumber);
        KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.getKBArticles();
        test.stopTest();
    }
    
    private static testMethod void method4(){
        test.startTest();
        createTestData();
        apexpages.currentpage().getparameters().put('id', '');
        KBPreviewController KBPreviewControllerObj = new KBPreviewController(new ApexPages.StandardController(listKnowledgeObj[0]));
        test.stopTest();
    }
    
    private static testMethod void method5(){
        test.startTest();
        createTestData();
        apexpages.currentpage().getparameters().put('id', '');
        KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.getKBArticles();
        test.stopTest();
    }

    private static testMethod void test_ReformHrefUrl1(){
		String s = '<a href="/kb/articles/Knowledge/List-of-Jaspersoft-Commands-in-accordance-with-CA-PPM-Version" target="_blank">TEC1027861</a>Test data ';
		Test.startTest();
         KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.reformHrefUrl(s);
        Test.stopTest();        
    }
    
    private static testMethod void test_ReformHrefUrl2(){
		String s = '<a href="/apex/CustomKnowledgeEdit?articleId=ka01k0000004iBbAAI" target="_blank">TEC1027861</a>Test data ';
		Test.startTest();
         KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.reformHrefUrl(s);
        Test.stopTest();        
    }
    
    private static testMethod void test_checkImageURL(){
		String s = '<p style=""><img alt="Capture.JPG" height="420" src="https://ca--FSB1--c.cs78.content.force.com/servlet/servlet.FileDownload?file=0151k0000000YfZAAU" width="796"></img></p>';
		Test.startTest();
         KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.checkImageURL(s);
        Test.stopTest();
    }
    
    private static void createTestData(){
        List<XMD_Product__c> xmdProductList = new List<XMD_Product__c>();
        XMD_Product__c xmdObj = new XMD_Product__c();
        xmdObj.Name = 'CA Application Performance Management';
        xmdObj.CMS_ID__c = '5974';
        xmdProductList.add(xmdObj);
        
        XMD_Product__c xmdObj1 = new XMD_Product__c();
        xmdObj1.Name = 'CA PPM';
        xmdObj1.CMS_ID__c = '5590';
        xmdProductList.add(xmdObj1);
        
        XMD_Product__c xmdObj2 = new XMD_Product__c();
        xmdObj2.Name = 'CA Service Desk Manager';
        xmdObj2.CMS_ID__c = '8165';
        xmdProductList.add(xmdObj2);
        
        XMD_Product__c xmdObj3 = new XMD_Product__c();
        xmdObj3.Name = 'CA Single Sign-On';
        xmdObj3.CMS_ID__c = '5262';
        xmdProductList.add(xmdObj3);
        
        insert xmdProductList;
        productId = xmdProductList[1].id;
        productId1 = xmdProductList[0].id;
        
        List<CA_Product_Controller__c> listOfCA = new List<CA_Product_Controller__c>();
        CA_Product_Controller__c caProductObj1 = new CA_Product_Controller__c();
        caProductObj1.name='CLARITY ON DEMAND';
        listOfCA.add(caProductObj1);
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='CLARITY ON PREMISE';
        listOfCA.add(caProductObj);
        
        CA_Product_Controller__c caProductObj2 = new CA_Product_Controller__c();
        caProductObj2.name='SERVICE DESK MANAGER';
        listOfCA.add(caProductObj2);
        
        CA_Product_Controller__c caProductObj3 = new CA_Product_Controller__c();
        caProductObj3.name='SINGLE SIGN ON';
        listOfCA.add(caProductObj3);
        insert listOfCA; 
        
        List<Product_Names__c> listOfPN = new List<Product_Names__c>();
        Product_Names__c pnObj = new Product_Names__c();
        pnObj.CA_Product_Controller__c = listOfCA[0].Id;
        pnObj.Product_Synonyms__c = 'testing';
        pnObj.Product_Usage__c = 'Documentation';
        listOfPN.add(pnObj);
        
        Product_Names__c pnObj1 = new Product_Names__c();
        pnObj1.CA_Product_Controller__c = listOfCA[1].Id;
        pnObj1.Product_Synonyms__c = 'testing1';
        pnObj1.Product_Usage__c = 'Documentation';
        listOfPN.add(pnObj1);
        
        Product_Names__c pnObj2 = new Product_Names__c();
        pnObj2.CA_Product_Controller__c = listOfCA[1].Id;
        pnObj2.Product_Synonyms__c = 'testing2';
        pnObj2.Product_Usage__c = 'Documentation';
        listOfPN.add(pnObj2);
        
        insert listOfPN;
        
        List<CA_Product_Component__c> listOfComp = new List<CA_Product_Component__c>();
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='CLARITY ON DEMAND ODMNTR';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=listOfCA[0].id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='ODMNTR';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp);
        
        CA_Product_Component__c prodcomp1 = new CA_Product_Component__c();
        prodcomp1.Name='SERVICE DESK MANAGER SMDOC';
        prodcomp1.CA_Product_Component_Ext_ID__c='Test';
        prodcomp1.Default_Component_for_CA_Product__c=True;
        prodcomp1.CA_Product_Controller__c=listOfCA[2].id;
        prodcomp1.CA_Product_Text__c='Test';
        prodcomp1.Component_Code__c='Test';
        prodcomp1.Component_Text__c='SMDOC';
        prodcomp1.Default_Component_for_this_CA_Product__c=True;
        prodcomp1.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp1);
        
        CA_Product_Component__c prodcomp2 = new CA_Product_Component__c();
        prodcomp2.Name='CLARITY ON PREMISE ODPRD';
        prodcomp2.CA_Product_Component_Ext_ID__c='Test';
        prodcomp2.Default_Component_for_CA_Product__c=True;
        prodcomp2.CA_Product_Controller__c=listOfCA[1].id;
        prodcomp2.CA_Product_Text__c='Test';
        prodcomp2.Component_Code__c='ODPRD';
        prodcomp2.Component_Text__c='Test';
        prodcomp2.Default_Component_for_this_CA_Product__c=True;
        prodcomp2.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp2);
        
        CA_Product_Component__c prodcomp3 = new CA_Product_Component__c();
        prodcomp3.Name='SINGLE SIGN ON SSODOC';
        prodcomp3.CA_Product_Component_Ext_ID__c='Test';
        prodcomp3.Default_Component_for_CA_Product__c=True;
        prodcomp3.CA_Product_Controller__c=listOfCA[3].id;
        prodcomp3.CA_Product_Text__c='Test';
        prodcomp3.Component_Code__c='SSODOC';
        prodcomp3.Component_Text__c='Test';
        prodcomp3.Default_Component_for_this_CA_Product__c=True;
        prodcomp3.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp3);
        
        CA_Product_Component__c prodcomp4 = new CA_Product_Component__c();
        prodcomp4.Name='CLARITY ON DEMAND 22';
        prodcomp4.CA_Product_Component_Ext_ID__c='Test';
        prodcomp4.Default_Component_for_CA_Product__c=True;
        prodcomp4.CA_Product_Controller__c=listOfCA[0].id;
        prodcomp4.CA_Product_Text__c='Test';
        prodcomp4.Component_Code__c='22';
        prodcomp4.Component_Text__c='Test';
        prodcomp4.Default_Component_for_this_CA_Product__c=True;
        prodcomp4.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp4);
        insert listOfComp;
        
        List<Product_Material__c> productMaterialList = new List<Product_Material__c>();
        Product_Material__c productMaterialObj = new Product_Material__c();
        productMaterialObj.Name = 'ITMEBM9900';
        productMaterialObj.CA_Product_Controller__c = listOfCA[0].Id;
        productMaterialObj.Source_System__c = 'TOPS';
        productMaterialList.add(productMaterialObj);
        
        Product_Material__c productMaterialObj1 = new Product_Material__c();
        productMaterialObj1.Name = 'ITMEBM9900';
        productMaterialObj1.CA_Product_Controller__c = listOfCA[0].Id;
        productMaterialObj1.Source_System__c = 'TOPS';
        productMaterialList.add(productMaterialObj1);
        
        insert productMaterialList;
        
        Product_Release__c productReleaseObj =  new Product_Release__c();
        productReleaseObj.Name = 'ITMEBM99000-5.6-IT Process Manager-Enterprise Bundle';
        productReleaseObj.Product_Release__c = '1';
        productReleaseObj.Product_Material__c = productMaterialList[0].Id; 
        insert productReleaseObj;
        
        releaseString = productReleaseObj.Product_Release__c;
        List<CA_XMD_Product_Mapping__c> mappingList = new List<CA_XMD_Product_Mapping__c>();
        CA_XMD_Product_Mapping__c mappingObj = new CA_XMD_Product_Mapping__c();
        mappingObj.CA_Product__c = listOfCA[0].id;
        mappingObj.XMD_Product__c = xmdProductList[1].Id;
        mappingList.add(mappingObj);
        
        CA_XMD_Product_Mapping__c mappingObj1 = new CA_XMD_Product_Mapping__c();
        mappingObj1.CA_Product__c = listOfCA[1].id;
        mappingObj1.XMD_Product__c = xmdProductList[1].Id;
        mappingList.add(mappingObj1);
        
        CA_XMD_Product_Mapping__c mappingObj2 = new CA_XMD_Product_Mapping__c();
        mappingObj2.CA_Product__c = listOfCA[2].id;
        mappingObj2.XMD_Product__c = xmdProductList[2].Id;
        mappingList.add(mappingObj2);
        
        CA_XMD_Product_Mapping__c mappingObj3 = new CA_XMD_Product_Mapping__c();
        mappingObj3.CA_Product__c = listOfCA[3].id;
        mappingObj3.XMD_Product__c = xmdProductList[3].Id;
        mappingList.add(mappingObj3);        
        insert mappingList;
        
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        List<RecordType> listOfRecordGen = [Select id, Name from RecordType where Name='generic' limit 1];
        
        System.debug(' generic id : '+ listOfRecordGen[0].id);
        listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue &lt;img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" &gt;';
        knowledgeObj1.Content2__c = '&lt;img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" &gt;';
        listKnowledgeObj.add(knowledgeObj1);
        
        knowledge__kav knowledgeObj2 = new knowledge__kav();
        knowledgeObj2.Title = 'test11112';
        knowledgeObj2.UrlName = 'testing12111';
        knowledgeObj2.Summary = 'testingning121111';
        knowledgeObj2.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj2.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj2.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj2.Releases__c = 'CA PPM: 1;2;3;4';
        knowledgeObj2.Product_Names__c = 'CA PPM';
        knowledgeObj2.Content1__c=' Issue <img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" />';
        knowledgeObj2.Content2__c = '&lt;img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" &gt;';
        knowledgeObj2.IsVisibleInPkb = true;
        knowledgeObj2.Introduction__c = '<a></a>';
        knowledgeObj2.Additional_Information__c = '<a></a>';
        knowledgeObj2.Answer__c = '<a></a>';
        knowledgeObj2.Background__c = '<a></a>';
        knowledgeObj2.Cause__c = '<a></a>';
        
        listKnowledgeObj.add(knowledgeObj2);
        
        knowledge__kav knowledgeObj3 = new knowledge__kav();
        knowledgeObj3.Title = 'test11112xxx';
        knowledgeObj3.UrlName = 'testing12111xxy';
        knowledgeObj3.Summary = 'testingning121111xxxx';
        knowledgeObj3.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj3.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj3.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj3.Releases__c = 'CA PPM: 1';
        knowledgeObj3.Product_Names__c = 'CA PPM';
        knowledgeObj3.Content1__c='Issue <img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" />';
        knowledgeObj3.Content2__c = 'content <img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" >';
        knowledgeObj3.IsVisibleInPkb = true;
        knowledgeObj3.Introduction__c = '<a></a>';
        knowledgeObj3.Additional_Information__c = '<a></a>';
        knowledgeObj3.Environment__c='Env  <img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" >';
        knowledgeObj3.Answer__c = '<a></a>';
        knowledgeObj3.Background__c = '<a></a>';
        knowledgeObj3.Cause__c = '<a></a>';
        listKnowledgeObj.add(knowledgeObj3);
        
        knowledge__kav knowledgeObj4 = new knowledge__kav();
        knowledgeObj4.Title = 'test11112xxx';
        knowledgeObj4.UrlName = 'testing12111xxz';
        knowledgeObj4.Summary = 'testingning121111xxxx';
        knowledgeObj4.RecordTypeId = listOfRecordGen[0].Id;
        knowledgeObj4.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj4.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj4.Releases__c = 'CA PPM: 1';
        knowledgeObj4.Product_Names__c = 'CA PPM';
        knowledgeObj4.Content1__c='Issue ';
        knowledgeObj4.Content2__c = 'Resolution';
        knowledgeObj4.Content4__c = 'content <img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" /> ';
        knowledgeObj4.IsVisibleInPkb = true;
        knowledgeObj4.Introduction__c = '<a></a>';
        knowledgeObj4.Additional_Information__c = '<a></a>';
        knowledgeObj4.Answer__c = '<a></a>';
        knowledgeObj4.Background__c = '<a></a>';
        knowledgeObj4.Cause__c = '<a></a>';
        
        listKnowledgeObj.add(knowledgeObj4);
        
        insert listKnowledgeObj;
        
        List<knowledge__kav> knowledgeObject = [Select id, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[0].id];
        List<knowledge__kav> knowledgeObject1 = [Select id, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[1].id];
        List<knowledge__kav> knowledgeObject2 = [Select id, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[2].id];
        articleNumber = knowledgeObject[0].articleNumber;
        articleKnwId = knowledgeObject[0].knowledgeArticleId;
        URLNameVal = knowledgeObject[0].URLName;
        
        componentString = listOfComp[0].Id+'; '+listOfComp[1].Id+'; '+listOfComp[2].Id;
        
        List<KCS_Association__c> kcsObj = new List<KCS_Association__c>();
        KCS_Association__c kObj = new KCS_Association__c();
        kObj.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj.Component_ID__c = listOfComp[0].id;
        kObj.Primary__c = true;
        kObj.Product_ID__c = xmdProductList[1].Id;
        kObj.Release_ID__c = '';
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj);
        
        KCS_Association__c kObj1 = new KCS_Association__c();
        kObj1.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj1.Component_ID__c = listOfComp[1].id;
        kObj1.Primary__c = true;
        kObj1.Product_ID__c = xmdProductList[1].Id;
        kObj1.Release_ID__c = '';
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj1);
        
        KCS_Association__c kObj2 = new KCS_Association__c();
        kObj2.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj2.Component_ID__c = listOfComp[2].id;
        kObj2.Primary__c = true;
        kObj2.Product_ID__c = xmdProductList[1].Id;
        kObj2.Release_ID__c = '';
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj2);
        
        KCS_Association__c kObj3 = new KCS_Association__c();
        kObj3.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj3.Component_ID__c = '';
        kObj3.Primary__c = true;
        kObj3.Product_ID__c = xmdProductList[1].Id;
        kObj3.Release_ID__c = productReleaseObj.id;
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj3);    
        
        KCS_Association__c kObj4 = new KCS_Association__c();
        kObj4.Article_Id__c = knowledgeObject1[0].knowledgeArticleId;
        kObj4.Component_ID__c = listOfComp[0].id;
        kObj4.Primary__c = true;
        kObj4.Product_ID__c = xmdProductList[1].Id;
        kObj4.Release_ID__c = '';
        kObj4.Product_Count__c = 2;
        kcsObj.add(kObj4);
        
        KCS_Association__c kObj5 = new KCS_Association__c();
        kObj5.Article_Id__c = knowledgeObject2[0].knowledgeArticleId;
        kObj5.Component_ID__c = listOfComp[1].id;
        kObj5.Primary__c = true;
        kObj5.Product_ID__c = xmdProductList[1].Id;
        kObj5.Release_ID__c = '';
        kObj5.Product_Count__c = 3;
        kcsObj.add(kObj5);
        
        KCS_Association__c kObj6 = new KCS_Association__c();
        kObj6.Article_Id__c = knowledgeObject2[0].knowledgeArticleId;
        kObj6.Component_ID__c = listOfComp[2].id;
        kObj6.Primary__c = true;
        kObj6.Product_ID__c = xmdProductList[1].Id;
        kObj6.Release_ID__c = '';
        kObj6.Product_Count__c = 3;
        kcsObj.add(kObj6);
        
        KCS_Association__c kObj7 = new KCS_Association__c();
        kObj7.Article_Id__c = knowledgeObject2[0].knowledgeArticleId;
        kObj7.Component_ID__c = '';
        kObj7.Primary__c = true;
        kObj7.Product_ID__c = xmdProductList[1].Id;
        kObj7.Release_ID__c = productReleaseObj.id;
        kObj7.Product_Count__c = 3;
        kcsObj.add(kObj7); 
        insert kcsObj;
    }
        private static testMethod void check_article_rating(){
         Test.startTest();
          List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        
           listKnowledgeObj = new List<knowledge__kav>();
           knowledge__kav knowledgeObj1 = new knowledge__kav();
           knowledgeObj1.Title = 'test111';
           knowledgeObj1.UrlName = 'testing1111';
           knowledgeObj1.Summary = 'testingning11111';
           knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
           knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
           knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
           knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
           knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
           knowledgeObj1.Content1__c='Issue';
           knowledgeObj1.Content2__c = 'Resolution';
           listKnowledgeObj.add(knowledgeObj1);
            
           insert listKnowledgeObj;
         
            knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber,CADocid__c FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
            KbManagement.PublishingService.publishArticle(knowledgeObj1.KnowledgeArticleId, true);
           
            KBArticleFeedbackController con=new KBArticleFeedbackController();
         
               con.aId = knowledgeObj1.KnowledgeArticleId;
               con.aNumber = knowledgeObj1.ArticleNumber;
               con.legArticleNumber = knowledgeObj1.CADocid__c;
               con.contactName = 'Test';
               con.contactEmail = 'test@test.com';
               con.feedbackComment = 'Testing controller';
               con.thumbsUpDownRating = 100;
                           
             con.incrementVoteCount();
             System.assertEquals(con.thumbsUpDownRating,100);
             System.assertEquals(con.renderGreyThumbsUp,false);
             System.assertEquals(con.renderGreyThumbsDown,true);
             System.assertEquals(con.renderContactPanel,true);
         
             con.decrementVoteCount();
             System.assertEquals(con.thumbsUpDownRating, 20);
             System.assertEquals(con.renderGreyThumbsUp,true);
             System.assertEquals(con.renderGreyThumbsDown,false);
             System.assertEquals(con.renderContactPanel,true);
         
         con.save();
         
         /*con.reset();       
         
         System.assertEquals(con.renderFeedbackInput,true);
         System.assertEquals(con.renderGreyThumbsUp,true);
         System.assertEquals(con.renderGreyThumbsDown,true);
         System.assertEquals(con.renderContactPanel,false);
         System.assertEquals(con.disableSubmitFeedback,true);
         System.assertEquals(con.thumbsUpDownRating,0);
         System.assertEquals(con.contactName,'');
         System.assertEquals(con.contactEmail,'');
         System.assertEquals(con.feedbackComment,'');
         */
         
         ApexPages.currentPage().getParameters().put('id',listKnowledgeObj[0].articleNumber);
         KBDetailsController kc=new KBDetailsController();
         kc.getKBArticles();
         Test.stopTest(); 
     }

    private static testMethod void image_validation(){
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];

        test.startTest();
           listKnowledgeObj = new List<knowledge__kav>();
           knowledge__kav knowledgeObj1 = new knowledge__kav();
           knowledgeObj1.Title = 'test111';
           knowledgeObj1.UrlName = 'testing1111';
           knowledgeObj1.Summary = 'testingning11111';
           knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
           knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
           knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
           knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
           knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
            knowledgeObj1.Content1__c='Issue <img src="https://comm.support.ca.com/servlet/servlet.FileDownload?file=0151k0000000Y9ZAAU" &gt;';
            knowledgeObj1.Content2__c = 'Resolution';
           listKnowledgeObj.add(knowledgeObj1);
            
           insert listKnowledgeObj;
         
            knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber,CADocid__c FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
            apexpages.currentpage().getparameters().put('Id', 'KB'+articleNumber);
            ApexPages.currentPage().getHeaders().put('Host','comm.support.ca.com');
            KBDetailsController KBDetailsControllerObj = new KBDetailsController();
        KBDetailsControllerObj.getKBArticles();
        test.stopTest();
    }
        
}