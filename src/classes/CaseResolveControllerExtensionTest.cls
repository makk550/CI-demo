@isTest(SeeAllData=true)
public class CaseResolveControllerExtensionTest {
    
  private static Site_Association__c testSite ; 
  private static Site_Association__c excludedSite;
  private static CA_Product_Controller__c testCAProduct ; 
  private static Contact testContact ; 
  private static User supportUser ; 
    private static User testUser ; 
  private static Offering_Business_Rules__c offeringBusinessRulesObj;
  private static Offering_Business_Rules__c offeringBusinessRulesObj2;
 
  public static User createDataUser(){
         Profile adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO' limit 1];
         testUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
         testUser.Case_Validation_Bypass__c =true;
         return testUser ;
  }
  
  
  static testmethod void testInsertCase () {
     system.runAs(createDataUser()){
        createDataUser();
     }     
     system.runAs(testUser){  
        
         List<Case> caseList = new List<Case>();
        Case case1 = CaseResolveControllerExtensionTest.prepareVDACase('1');
        caseList.add(case1);
        insert caseList; 

        case1.Next_Action_Due_Date__c = System.today()+3;
        update case1;
           case1.Product_Material__c= 'a2Fa000000244ML'; 
           case1.Product_Release_Selection__c= 'a7na0000000DCIB';   
           case1.Troubleshooting_Stage__c= '7. Closed'; 
           case1.Next_Action__c= 'Issue Closed';
           case1.Function__c= 'a1e0R000000AIs4QAG';
           case1.Category__c= 'Asset Collector'; 
           case1.Subcategory__c= 'Asset Collector'; 
           case1.Root_Cause_Category_vda__c= 'a1f0R000000Gx1tQAC'; 
           case1.Root_Cause_Sub_Category__c= 'a1g0R0000003MRx';    
           case1.Resolution__c= 'Test'; 
           case1.Reason= 'Defect - New'; 
         update case1;
         
        
        Test.StartTest();   
        
       
            PageReference pageRef = Page.CaseResolvePage; // Add your VF page Name here
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', String.valueOf(case1.Id));
            ApexPages.StandardController contrller= new ApexPages.StandardController(case1);
            CaseResolveControllerExtension caseResolveControllerExtension = new CaseResolveControllerExtension(contrller);
            caseResolveControllerExtension.objCase=case1;
            caseResolveControllerExtension.caseId=case1.Id;
            
            // Test for VDA product with all data
            
            caseResolveControllerExtension.checkVDA();
             caseResolveControllerExtension.checkVDAOnLoad();
            caseResolveControllerExtension.getFunctionList();
            caseResolveControllerExtension.getRootCauseCategoryList();
            caseResolveControllerExtension.getRootCauseSubCategoryList();
            caseResolveControllerExtension.save();
            caseResolveControllerExtension.cancel();
         
          // Test for VDA product with null data
            
           case1.Product_Material__c= 'a2Fa000000244ML'; 
           case1.Product_Release_Selection__c= 'a7na0000000DCIB';   
           case1.Troubleshooting_Stage__c= null; 
           case1.Next_Action__c= null;
           case1.Function__c= null; 
           case1.Root_Cause_Category_vda__c= null; 
           case1.Root_Cause_Sub_Category__c= null;   
           case1.Resolution__c= null; 
           case1.Reason= null;
         update case1;
            
            caseResolveControllerExtension.checkVDA();
            caseResolveControllerExtension.checkVDAOnChange();
            caseResolveControllerExtension.getFunctionList();
            caseResolveControllerExtension.getRootCauseCategoryList();
            caseResolveControllerExtension.getRootCauseSubCategoryList();
            caseResolveControllerExtension.save();
            caseResolveControllerExtension.cancel();
            
             // Test for non VDA product with all data
            
           case1.CA_Product_Controller__c= 'a7Za0000000Cb0J'; 
           case1.CA_Product_Component__c= 'a7Ya00000004DAb';     
           case1.Product_Material__c= 'a2Fa0000001udP0'; 
           case1.Product_Release_Selection__c= 'a7na0000000Gmue';   
           case1.Troubleshooting_Stage__c= '7. Closed'; 
           case1.Next_Action__c= 'Issue Closed';
           case1.Function__c= null; 
           case1.Category__c= 'Product'; 
           case1.Subcategory__c= 'Configuration'; 
           case1.Resolution__c= 'Test'; 
           case1.Reason= 'Defect - New';
         update case1;
            
            caseResolveControllerExtension.checkVDA();
            caseResolveControllerExtension.getFunctionList();
            caseResolveControllerExtension.getRootCauseCategoryList();
            caseResolveControllerExtension.getRootCauseSubCategoryList();
            caseResolveControllerExtension.save();
            caseResolveControllerExtension.cancel();
            
             // Test for non VDA product with null data
            
           case1.CA_Product_Controller__c= 'a7Za0000000Cb0J'; 
           case1.CA_Product_Component__c= 'a7Ya00000004DAb';     
           case1.Product_Material__c= 'a2Fa0000001udP0'; 
           case1.Product_Release_Selection__c= 'a7na0000000Gmue';   
           case1.Troubleshooting_Stage__c= null; 
           case1.Next_Action__c= null;
           case1.Function__c= null; 
           case1.Category__c= null; 
           case1.Subcategory__c= null; 
           case1.Resolution__c= null; 
           case1.Reason= null;
         update case1;
            
            caseResolveControllerExtension.checkVDA();
            caseResolveControllerExtension.getFunctionList();
            caseResolveControllerExtension.getRootCauseCategoryList();
            caseResolveControllerExtension.getRootCauseSubCategoryList();
            caseResolveControllerExtension.save();
            caseResolveControllerExtension.cancel();

        Test.StopTest();
     }   
  }

      private static Case prepareVDACase(String severity){
            Case caseRec = new Case();
            
           Id idRT = [ SELECT id FROM RecordType where  SobjectType ='Case' and Name='Standard'].Id;
            
            caseRec.RecordTypeId =idRT;
            caseRec.AccountId  = '001a000001Ph9wD';
            caseRec.Site_Association__c = 'a26a0000001D5zCAAS' ;
            caseRec.BusinessHoursId ='01ma00000000PaH';
            caseRec.subject = 'Test VDA Case' ; 
            caseRec.Description = 'Test Description' ; 
            caseRec.ContactId = '0030c00002ZcVVK' ; 
           caseRec.CA_Product_Controller__c= 'a7Za0000000PB8F'; 
           caseRec.CA_Product_Component__c= 'a7Ya0000000Gowi'; 
            caseRec.Troubleshooting_Stage__c = '1. Problem Identification';  
            caseRec.Next_Action__c ='Pending CA Support';
            caseRec.Next_Action_Due_Date__c = System.Today()+1;
            caseRec.Origin = 'Phone Call';       
            caseRec.Severity__c = severity;
            if(severity == '1'){
                caseRec.Sev_1_Impact_c__c = 'Production Down';
                caseRec.Production_Down_Status__c = 'Investigating';
            }
            return caseRec;
      }
      
        private static Case prepareNonVDACase(String severity){
            Case caseRec = new Case();
            
           Id idRT = [ SELECT id FROM RecordType where  SobjectType ='Case' and Name='Standard'].Id;
            
            caseRec.RecordTypeId =idRT;
            caseRec.AccountId  = '001a000001Ph9wD';
            caseRec.Site_Association__c = 'a26a0000001D5zCAAS' ;
            caseRec.BusinessHoursId ='01ma00000000PaH';
            caseRec.subject = 'Test VDA Case' ; 
            caseRec.Description = 'Test Description' ; 
            caseRec.ContactId = '0030c00002ZcVVK' ; 
           caseRec.CA_Product_Controller__c= 'a7Za0000000Cb0J'; 
           caseRec.CA_Product_Component__c= 'a7Ya00000004DAb'; 
            caseRec.Troubleshooting_Stage__c = '1. Problem Identification';  
            caseRec.Next_Action__c ='Pending CA Support';
            caseRec.Next_Action_Due_Date__c = System.Today()+1;
            caseRec.Origin = 'Phone Call';       
            caseRec.Severity__c = severity;
            if(severity == '1'){
                caseRec.Sev_1_Impact_c__c = 'Production Down';
                caseRec.Production_Down_Status__c = 'Investigating';
            }
            return caseRec;
      }
        
}