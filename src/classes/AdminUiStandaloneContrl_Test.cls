@isTest
public class AdminUiStandaloneContrl_Test{

    @isTest
    static void testPageRedirection(){
        
        PageReference pref = Page.AdminUI_Standalone;
    
        Test.setCurrentPageReference(pref);
        
        AdminUiStandaloneContrl controller = new AdminUiStandaloneContrl();
        
        Test.startTest();
        
        controller.cemail = ' ';
        controller.contractNumber='';
        controller.prodId='';
        controller.subScriptionName='';
        controller.validateAndSearch();
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        
        Boolean b;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please enter valid email address or Product Instance Id or Contract Number or Subscription name.')) b = true;
        }
        system.assertEquals(true,b);
        
        controller.cemail = 'testing@ca.com';
        PageReference resultantPref = controller.validateAndSearch();
        
        String decodedURL = EncodingUtil.urlDecode(resultantPref.getUrl(),'UTF-8');
        
        system.assertEquals('/apex/AdminUiPage?cemail=testing@ca.com'+'&'+'checkCon='+'true',decodedURL);
        
        Test.stopTest();
        
        
        
    }
     @isTest
    static void testPageRedirection_ProdI(){
        
        PageReference pref = Page.AdminUI_Standalone;
    
        Test.setCurrentPageReference(pref);
        
        AdminUiStandaloneContrl controller = new AdminUiStandaloneContrl();
        
        Test.startTest();
        
        controller.cemail = ' ';
        controller.contractNumber='';
        controller.prodId='';
        controller.subScriptionName='';
        controller.validateAndSearch();
        
               
        controller.prodId = '70625';
        controller.selectedVale='';
        PageReference resultantPref = controller.validateAndSearch();
        
        String decodedURL = EncodingUtil.urlDecode(resultantPref.getUrl(),'UTF-8');
        
        system.assertEquals('/apex/AdminUiPage?checkCon=true&prodId=70625',decodedURL);
        
        Test.stopTest();
        
        
        
    }
    
      @isTest
    static void testPageRedirection_ContractNumber(){
        
        PageReference pref = Page.AdminUI_Standalone;
    
        Test.setCurrentPageReference(pref);
        
        AdminUiStandaloneContrl controller = new AdminUiStandaloneContrl();
        
        Test.startTest();
        
              
        controller.contractNumber = '0040248388';
        PageReference resultantPref = controller.validateAndSearch();
        
        String decodedURL = EncodingUtil.urlDecode(resultantPref.getUrl(),'UTF-8');
        
        system.assertEquals('/apex/AdminUiPage?checkCon=true&contractNumber=0040248388',decodedURL);
        
        Test.stopTest();
        
        
        
    }
    
}