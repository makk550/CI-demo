/**
*Description :Class to calculate the rating which will be used to calculate the 
    Partner Milestone Complete percent and also the Progress Bar    
*Methods populatePartnerRating  , with List of Account as input
*SOQl: 0 
*Client: CA technologies
*Developed By:  Accenture
*/
public class PLM_AccountPercentCompleteForPartner {

    Integer progressCount=0;
    Set<Id> accArr = new Set<Id>();
    Set<Id> accWithProductAlignmentArr = new Set<Id>();
    List<Product_Alignment__c> listOfProductAlignment=new List<Product_Alignment__c>();
    List<Account> listofPrdAlign = new List<Account>(); // ALLHA02 AR 3385
    //Method to calculate the rating for Value and Technology partners
    public void populatePartnerRating(List<Account> ThisAccount){
    
      System.debug('*******accArr*'+ ThisAccount);
    
        //get the list of accounts Ids
        for (Account a : ThisAccount) {
            if(a.id!=null) 
            accArr.add(a.id);
        }
       
        
       //get the list of account Ids with product alignments
      /*
        System.debug('*******accArr*'+ accArr );
        listOfProductAlignment=[select Related_Account__r.Id from Product_Alignment__c where Related_Account__r.Id in: accArr];
        if(listOfProductAlignment!=null && listOfProductAlignment.size()>0){
            for(Product_Alignment__c p: listOfProductAlignment){
                accWithProductAlignmentArr.add(p.Related_Account__r.Id);
            }
        }
        
        
    */
          //ALLHA02 AR3385
              System.debug('*******accArr*'+ accArr );
              listofPrdAlign = [Select id ,(select id from Product_Alignments__r) from Account where id in: accArr];
              if(listofPrdAlign!=null && listofPrdAlign.size()>0){   
                       for(Account a: listofPrdAlign){   
                          if(a.Product_Alignments__r.size()>0){
                               System.debug('Has Product Alignments '+a.id);
                                accWithProductAlignmentArr.add(a.Id);
                              }
                        }
                  }
         //ALLHA02 AR3385 End         
        
        
        
        //populate the ratings
        for (Account a : ThisAccount) { 
            if(a.RecordTypeId == SystemIdUtility.getResellerDistRecordTypeId()){
                 if (a.Provide_Partner_Kit__c == 'Current')        
                 progressCount++;
                 if (a.Agreement__c == 'Current')        
                 progressCount++;
                 if (a.Contract_Start_Date__c != null)        
                 progressCount++;
                 if (a.Business_Plan__c == 'Current')        
                 progressCount++;
                 if (a.Business_Plan_Start_Date__c !=null)        
                 progressCount++;   
                 if (a.PDS_Addendum__c == 'Current')        
                 progressCount++;                          
                 if (a.Partner_Enablement_Addendum__c == 'Current')        
                 progressCount++;
                 if (a.Agreement_Number__c != null && a.Agreement_Number__c != '')        
                 progressCount++;   
                 if (a.Agreement_Attached__c)        
                 progressCount++;
                 if (a.Contract_End_Date__c != null)        
                 progressCount++;   
                 if (a.Business_Plan_Attached__c)        
                 progressCount++;
                 if (a.Business_Plan_End_Date__c != null)        
                 progressCount++;
                 if (a.Portal_Champion__c !=null)        
                 progressCount++;
                 if(accWithProductAlignmentArr!=null && accWithProductAlignmentArr.size()>0){
                    if(accWithProductAlignmentArr.contains(a.id))
                    progressCount++;
                 }
                 a.Value_Partner_Progress_Rating__c = progressCount;  
            }  
            
            Else if(a.RecordTypeId == SystemIdUtility.getTechPartnerRecordTypeId()){
                 if (a.Completion_of_NDA__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_Partner_Agreement__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_DLA__c == 'Completed')        
                 progressCount++;
                 if (a.BU_Approval__c == 'Completed')        
                 progressCount++;                          
                 if (a.Completion_of_Product_Integration__c == 'Completed')        
                 progressCount++;        
                 if (a.Partner_BU_Agree_to_proceed_Develop__c == 'Completed')        
                 progressCount++;     
                 if (a.Partner_s_Webpage_linked_to_CA_Products__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_Validation__c == 'Completed')        
                 progressCount++;  
                 if (a.Completion_of_a_Self_Running_Demo__c == 'Completed')        
                 progressCount++;  
                 if (a.Completion_of_Collateral_for_Solution__c == 'Completed')        
                 progressCount++;   
                 if (a.Partner_BU_Agree_to_proceed_Validate__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_Partner_Spotlight__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_Solution_Catalog_Submissio__c == 'Completed')        
                 progressCount++;  
                 if (a.Completion_of_a_Press_Release__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_Customer_Success_Story__c == 'Completed')        
                 progressCount++;
                 if (a.Completion_of_Three_References_of_the_In__c == 'Completed')        
                 progressCount++;
                 a.Technology_Partner_Progress_Rating__c = progressCount; 
            }
        }
        
    }
    
   @isTest(SeeAllData=true)
   public static void PLM_AccountPercentCompleteForPartner_test() {
            List<Account> accntList = new List<Account>();
            Account ac = new Account();
            ac.Name = 'Test Account';
            ac.BillingState = 'NY';   
            ac.Customer_Category__c = 'Enterprise';
            //ac.Account_Status__c = 'Approved';        
            ac.GEO__c='NA';
            ac.Enterprise_ID__c = '1234te';
            ac.Enterprise_Account_Name__c = 'rdName';
            ac.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
            ac.Commercial_ID__c = 'asdf';
            ac.Provide_Partner_Kit__c = 'Current';      
            ac.Agreement__c = 'Current';
            ac.Contract_Start_Date__c = system.today();        
            ac.Business_Plan__c = 'Current';        
            ac.Business_Plan_Start_Date__c = system.today();        
            ac.PDS_Addendum__c = 'Current';
            ac.Partner_Enablement_Addendum__c = 'Current';
            ac.Agreement_Number__c = '123';
            ac.Agreement_Attached__c = true;      
            ac.Contract_End_Date__c = system.today()+7;        
            ac.Business_Plan_Attached__c = true;
            ac.Business_Plan_End_Date__c = system.today()+7;        
            accntList.add(ac);
            
            Account ac1 = new Account();
            ac1.Name = 'Test Account';
            ac1.BillingState = 'NY';   
            ac1.Customer_Category__c = 'Enterprise';
            //ac1.Account_Status__c = 'Approved';       
            ac1.GEO__c='LA';
            ac1.Enterprise_ID__c = '1234te';
            ac1.Enterprise_Account_Name__c = 'rdName1';
            ac1.Commercial_ID__c = 'asdf';
            ac1.RecordTypeId = SystemIdUtility.getTechPartnerRecordTypeId();
            
            ac1.Completion_of_NDA__c = 'Completed';
            ac1.Completion_of_Partner_Agreement__c = 'Completed';
            ac1.Completion_of_DLA__c = 'Completed';
            ac1.BU_Approval__c = 'Completed';   
            ac1.Completion_of_Product_Integration__c = 'Completed';        
            ac1.Partner_BU_Agree_to_proceed_Develop__c = 'Completed';        
            ac1.Partner_s_Webpage_linked_to_CA_Products__c = 'Completed';        
            ac1.Completion_of_Validation__c = 'Completed';
            ac1.Completion_of_a_Self_Running_Demo__c = 'Completed';       
            ac1.Completion_of_Collateral_for_Solution__c = 'Completed';        
            ac1.Partner_BU_Agree_to_proceed_Validate__c = 'Completed';       
            ac1.Completion_of_Partner_Spotlight__c = 'Completed';   
            ac1.Completion_of_Solution_Catalog_Submissio__c = 'Completed';        
            ac1.Completion_of_a_Press_Release__c = 'Completed';
            ac1.Completion_of_Customer_Success_Story__c = 'Completed';        
            ac1.Completion_of_Three_References_of_the_In__c = 'Completed';
            
            accntList.add(ac1);
            insert accntList;
        
        List<product_alignment__c> prodAlignList= new List<product_alignment__c>();
        product_alignment__c prodA1= new product_alignment__c();
        prodA1.related_account__c = ac.id;
        prodAlignList.add(prodA1);
        
        product_alignment__c prodA2= new product_alignment__c();
        prodA2.related_account__c = ac1.id;
        prodAlignList.add(prodA2);

        insert prodAlignList;
   
   
   
   
        //Product_Alignment__c prodA1 = [Select Id, Related_Account__c from Product_Alignment__c where Related_Account__r.RecordTypeId = :SystemIdUtility.getResellerDistRecordTypeId() LIMIT 1];
        //Product_Alignment__c prodA2 = [Select Id, Related_Account__c from Product_Alignment__c where Related_Account__r.RecordTypeId = :SystemIdUtility.getTechPartnerRecordTypeId() LIMIT 1];
        List<Account> lstAcc1 = [Select Id, Provide_Partner_Kit__c, RecordTypeId, Agreement__c, Contract_Start_Date__c, Business_Plan__c, Business_Plan_Start_Date__c, PDS_Addendum__c, Partner_Enablement_Addendum__c, Agreement_Number__c, Agreement_Attached__c, Contract_End_Date__c, Business_Plan_Attached__c, Business_Plan_End_Date__c, Portal_Champion__c, Value_Partner_Progress_Rating__c, Completion_of_NDA__c, Completion_of_Partner_Agreement__c, Completion_of_DLA__c, BU_Approval__c, Completion_of_Product_Integration__c, Partner_BU_Agree_to_proceed_Develop__c, Partner_s_Webpage_linked_to_CA_Products__c, Completion_of_Validation__c, Completion_of_a_Self_Running_Demo__c, Completion_of_Collateral_for_Solution__c, Partner_BU_Agree_to_proceed_Validate__c, Completion_of_Partner_Spotlight__c, Completion_of_Solution_Catalog_Submissio__c, Completion_of_a_Press_Release__c, Completion_of_Customer_Success_Story__c, Completion_of_Three_References_of_the_In__c, Technology_Partner_Progress_Rating__c from Account where Id = :prodA1.Related_Account__c];
        List<Account> lstAcc2 = [Select Id, Provide_Partner_Kit__c, RecordTypeId, Agreement__c, Contract_Start_Date__c, Business_Plan__c, Business_Plan_Start_Date__c, PDS_Addendum__c, Partner_Enablement_Addendum__c, Agreement_Number__c, Agreement_Attached__c, Contract_End_Date__c, Business_Plan_Attached__c, Business_Plan_End_Date__c, Portal_Champion__c, Value_Partner_Progress_Rating__c, Completion_of_NDA__c, Completion_of_Partner_Agreement__c, Completion_of_DLA__c, BU_Approval__c, Completion_of_Product_Integration__c, Partner_BU_Agree_to_proceed_Develop__c, Partner_s_Webpage_linked_to_CA_Products__c, Completion_of_Validation__c, Completion_of_a_Self_Running_Demo__c, Completion_of_Collateral_for_Solution__c, Partner_BU_Agree_to_proceed_Validate__c, Completion_of_Partner_Spotlight__c, Completion_of_Solution_Catalog_Submissio__c, Completion_of_a_Press_Release__c, Completion_of_Customer_Success_Story__c, Completion_of_Three_References_of_the_In__c, Technology_Partner_Progress_Rating__c from Account where Id = :prodA2.Related_Account__c];
            
            
        PLM_AccountPercentCompleteForPartner cls = new PLM_AccountPercentCompleteForPartner();
        cls.populatePartnerRating(lstAcc1);
        cls.populatePartnerRating(lstAcc2);
   }  
}