@isTest(seeAllData='true')
private class TestValidatePlatinumTrigger {
               
                        static testMethod void validatePlatinumAccount(){
                              List<TAQ_Account__c > tacAccList = new List<TAQ_Account__c >();
                              Schema.DescribeSObjectResult taqresult = Schema.SObjectType.TAQ_Account__c;
                              Map<String,Schema.RecordTypeInfo> taqaccRecType = taqresult.getRecordTypeInfosByName();
                              Id taqRecId = taqaccRecType.get('Regional Account').getRecordTypeId();
                              TAQ_Account__c ta = new TAQ_Account__c (RecordTypeId=taqRecId , Name='testtaq',Region__c='EMEA',Area__c='CEN',Territory__c='AUSTRIA',
                                                  Country__c='AUSTRIA',Country_Picklist__c='AT - AUSTRIA',Enterprise_Account_Name__c='testtaq',
                                                  Approval_Process_Status__c='',Segment__c=Label.SegmentVal1);
                              tacAccList .add(ta);                    
                              TAQ_Account__c ta1 = new TAQ_Account__c (RecordTypeId=taqRecId , Name='testtaq',Region__c='APJ',Area__c='INDIA',Territory__c='INDIA',
                                                  Country__c='INDIA',Country_Picklist__c='IN - INDIA',Enterprise_Account_Name__c='testtaq',
                                                  Approval_Process_Status__c='',Segment__c=Label.SegmentVal3); 
                                                                     
                               tacAccList .add(ta1);   
                               TAQ_Account__c ta2 = new TAQ_Account__c (RecordTypeId=taqRecId , Name='testtaq',Region__c='APJ',Area__c='INDIA',Territory__c='INDIA',
                                                  Country__c='INDIA',Country_Picklist__c='IN - INDIA',Enterprise_Account_Name__c='testtaq',
                                                  Approval_Process_Status__c='',Segment__c=Label.SegmentVal1); 
                                                                     
                               tacAccList .add(ta2);
                               system.debug('*********before inserted taq acclist*********');   
                                                 
                              insert tacAccList;
                              system.debug('*********inserted taq acclist*********');
                             
                              TAQ_Organization__c taqOrg =new TAQ_Organization__c();
                                taqOrg.Employee_Name__c='test,user';
                                taqOrg.Process_Step__c='Open Headcount';
                                taqOrg.Manager_Name__c='test,mgr';
                              //  taqOrg.Manager_PMF_Key__c=u[1].PMFKey__c;
                               // taqOrg.PMFKey__c='coucy01';
                                taqOrg.Position_Id__c='testpos1';
                                taqOrg.Role__c='AD/AM';
                                taqOrg.Organization__c='DIRECT';
                                taqOrg.Region__c='EMEA';
                                taqOrg.Area__c='testa';
                                taqOrg.Territory__c='nordics';
                                taqOrg.Country__c='United States';
                                taqOrg.Plan_Type__c='test';
                                taqOrg.Distribute_Plan__c='NO';
                                taqOrg.Plan_Type__c='LOA';
                                taqOrg.ownerid=userinfo.getuserid();
                                
                                taqOrg.Cost_Center_Desc_For_Data_Load__c='test cost';
                                taqOrg.Job_Title_For_Data_Load__c='test job';
                                taqOrg.IC_Currency_For_Data_Load__c='test currency';
                                
                                taqOrg.Organization_for_Data_Load__c='DIRECT';
                                taqOrg.Area_for_Data_Load__c='testa';
                                taqOrg.Territory_For_Data_Load__c='nordics';
                                taqOrg.Country_for_Data_Load__c='United States';
                                taqOrg.Approval_Process_Status__c='Migrated';
                                taqOrg.Employee_Status__c='Active';
                                taqOrg.Position_ID_Status__c='Active';
                                taqOrg.PlanType_Effective_Date__c = date.newinstance(1960, 2, 1);
                                insert taqOrg;
                                
                             TAQ_Organization_Approved__c taqOrgApproved = new TAQ_Organization_Approved__c();
                             taqOrgApproved.Employee_Name__c = 'test emp';
                             taqOrgApproved.Is_Latest_Record__c = true ; 
                             taqOrgApproved.TAQ_Organization__c = taqOrg.Id;
                             insert taqOrgApproved ; 
                              List<TAQ_Account_Team__c > taccAccTeamList= new List<TAQ_Account_Team__c >();
                              
                              TAQ_Account_Team__c tac = new TAQ_Account_Team__c();
                              tac.TAQ_Account__c=tacAccList[0].id;
                              tac.PMFKey__c='HUMJE02';
                              tac.Is_Account_Owner__c=true;
                              taccAccTeamList.add(tac);
                              
                              TAQ_Account_Team__c tac1 = new TAQ_Account_Team__c();
                              tac1.TAQ_Account__c=tacAccList[0].id;
                              tac1.PMFKey__c='HUMJE02';
                              tac1.Is_Account_Owner__c=true;
                              taccAccTeamList.add(tac1);
                              
                              insert taccAccTeamList;
                            
                            List <TAQ_Account_Approved__c> taqAccApproved = new List <TAQ_Account_Approved__c>();
                            TAQ_Account_Approved__c taqAccApprd = new TAQ_Account_Approved__c();
                            taqAccApprd.Is_Latest_Record__c = true ; 
                             taqAccApprd.TAQ_Account__c = tacAccList[0].Id;
                            taqAccApprd.Is_Original__c = true;
                            taqAccApproved.add(taqAccApprd);
                            insert taqAccApproved;
        
                            TAQ_Account_Team_Approved__c taApp = new TAQ_Account_Team_Approved__c();
                            taApp.Is_Latest_Record__c = true ; 
                            taApp.Effective_Date__c = Date.Today();
                            taApp.TAQ_Account_Approved__c = taqAccApproved[0].Id;
                            insert taApp; 
                            
                              system.debug('*********inserted taq acc team list*********');
                            TAQ_ACCOUNT__c taqc = [Select Name,Region__c,Area__c,Territory__c,Approval_Process_Status__c from TAQ_ACCOUNT__c limit 1];
                              taqc.Approval_Process_Status__c='Send For Approval';
                                update taqc;
                              system.debug('*********updated  taq acc*********');
                             


                                                               }


                                             }