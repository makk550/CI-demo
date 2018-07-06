@isTest
public class DealRegApprovalRejectionController_Test {
        
        @testSetup static void setup() {
            Id profileId = [select Id from profile where Name = '1.0 CA Sys Admin Commit & PR' limit 1].Id;

                User adminUser = new User(alias = 'admin', email='TestAdminUser@ca.com',emailencodingkey='UTF-8',
                                        lastname='Test Admin User Last Name', languagelocalekey='en_US',localesidkey='en_US',
                                        profileid = profileId, country='United States',IsActive =true,
                                        timezonesidkey='America/Los_Angeles', username='TestAdminUser@noemail.com',firstName= 'Test Admin User First Name');
                
                insert adminUser;   
        }
  
        static testMethod void test_Approval()
        {
            string oppId = '';

            SystemIdUtility.skipOpportunityTriggers = true;
            SystemIdUtility.skipOpportunityLineItemTriggers  = true;      
            User pUser = Test_CreateOpportunity.createPartnerUser();
            
            /*Id profileId = [select Id from profile where Name = '1.0 CA Sys Admin Commit & PR' limit 1].Id;

            User adminUser = new User(alias = 'admin', email='TestAdminUser@ca.com',emailencodingkey='UTF-8',
                                    lastname='Test Admin User Last Name', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = profileId, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='TestAdminUser@noemail.com',firstName= 'Test Admin User First Name');
            
            insert adminUser;
*/
            User adminUser = [select id from user where email='TestAdminUser@ca.com'];
            
            Test.startTest();
            System.runAs(pUser){
                Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
                oppId = opp.Id;

                List<OpportunityLineItem> oliList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);
               
                RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='Deal Registration'];
                opp.RecordTypeId = recopp.Id;
                opp.initiated_by__c = 'Partner';
                opp.deal_registration_status__c = 'New';
                opp.has_no_deal_reg_program__c = false;
                opp.deal_reg_initially_approved__c = false;
                opp.First_Approver__c = adminUser.id;
                update opp;
                
                //submitForApproval
                 try{
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                  req.setComments('Submitted for approval. Please approve.');
                  req.setObjectId(opp.Id);
                  Approval.ProcessResult result = Approval.process(req);

                  // Verify the result
                System.assert(result.isSuccess());

                System.assertEquals(
                    'Pending', result.getInstanceStatus(), 
                    'Instance Status'+result.getInstanceStatus());

                   if (!result.isSuccess())
                  {
                    string error = '';
                    for ( Database.error strError : result.getErrors() )
                    {
                        error += '<br/>' + strError.getMessage();
                    }

                      System.debug(' sun Submit for Approval failes :'+ result.getErrors() + ', opp.id ' + opp.id );
                  }
              }
              catch(Exception e){
                  System.debug(' sun Submit for Approval failes :'+e.getMessage() + ', opportunity id ' + opp.id );
                }

                //Test Approve failure
                Test.setCurrentPageReference(new PageReference('Page.DealRegApprovalRejection'));
                System.currentPageReference().getParameters().put('OppId', oppId);
                DealRegApprovalRejectionController controller = new DealRegApprovalRejectionController();
                controller.testApprovalException = true;
                controller.Approve();
            }

            //Test Approve
            System.runAs(adminUser)
            {
                Test.setCurrentPageReference(new PageReference('Page.DealRegApprovalRejection'));
                System.currentPageReference().getParameters().put('OppId', oppId);
                DealRegApprovalRejectionController controller = new DealRegApprovalRejectionController();
                controller.testApprovalException = false;
                //system.assertEquals(controller.Approve().getUrl(),new PageReference('/'+oppId).getUrl());

                //system.assertEquals(controller.Cancel().getUrl(),new PageReference('/'+oppId).getUrl());
            }

            Test.stopTest();
        }

        static testMethod void test_Reject()
        {
            string oppId = '';

            SystemIdUtility.skipOpportunityTriggers = true;
            SystemIdUtility.skipOpportunityLineItemTriggers  = true;      
            User pUser = Test_CreateOpportunity.createPartnerUser();
            
          /*  Id profileId = [select Id from profile where Name = '1.0 CA Sys Admin Commit & PR' limit 1].Id;

            User adminUser = new User(alias = 'admin', email='TestAdminUser@ca.com',emailencodingkey='UTF-8',
                                    lastname='Test Admin User Last Name', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = profileId, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='TestAdminUser@noemail.com',firstName= 'Test Admin User First Name');
            
            insert adminUser;
*/
            
            User adminUser = [select id from user where email='TestAdminUser@ca.com'];
            
            Test.startTest();
            System.runAs(pUser){
                Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
                oppId = opp.Id;

                List<OpportunityLineItem> oliList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);
               
                RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='Deal Registration'];
                opp.RecordTypeId = recopp.Id;
                opp.initiated_by__c = 'Partner';
                opp.deal_registration_status__c = 'New';
                opp.has_no_deal_reg_program__c = false;
                opp.deal_reg_initially_approved__c = false;
                opp.First_Approver__c = adminUser.id;
                update opp;
                
                //submitForApproval
                 try{
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                  req.setComments('Submitted for approval. Please approve.');
                  req.setObjectId(opp.Id);
                  Approval.ProcessResult result = Approval.process(req);

                  // Verify the result
                System.assert(result.isSuccess());

                System.assertEquals(
                    'Pending', result.getInstanceStatus(), 
                    'Instance Status'+result.getInstanceStatus());

                  if (!result.isSuccess())
                  {
                    string error = '';
                    for ( Database.error strError : result.getErrors() )
                    {
                        error += '<br/>' + strError.getMessage();
                    }

                      System.debug(' sun Submit for Approval failes :'+ result.getErrors() + ', opp.id ' + opp.id );
                  }
              }
              catch(Exception e){
                  System.debug(' sun Submit for Approval failes :'+e.getMessage() + ', opportunity id ' + opp.id );
                }
            }

            Test.setCurrentPageReference(new PageReference('Page.DealRegApprovalRejection'));
            System.currentPageReference().getParameters().put('OppId', oppId);

            //Test reject failure
            System.runAs(pUser)
            {
                DealRegApprovalRejectionController controller = new DealRegApprovalRejectionController();
                controller.testApprovalException = true;
                system.assertEquals(controller.Reject(),null);
            }

            //Test reject
           System.runAs(adminUser)
            {

                DealRegApprovalRejectionController controller = new DealRegApprovalRejectionController();
                //opp.Deal_Rejection_Reason__c is null
                system.assertEquals(controller.Reject(),null);

                Opportunity Opp = [select id from opportunity where id =: oppId];
                opp.Deal_Rejection_Reason__c = 'Deal Previously Registered By Another Partner';
                update opp;

                controller = new DealRegApprovalRejectionController();
                controller.testApprovalException = false;
                system.assertEquals(controller.Reject().getUrl(),new PageReference('/'+oppId).getUrl());

            }

            Test.stopTest();
        }
}