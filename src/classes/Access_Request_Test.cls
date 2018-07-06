@isTest(seealldata=true)
public class Access_Request_Test {
    
   public static testmethod void createAR(){
        string url;
        user u1=new user(id='00530000003rQuJ');
        user u2 = new user(id='00530000003rQuJ');
        system.debug('user role is'+u1.UserRoleId);
        system.debug('user profile is'+u1.ProfileId);
        system.runas(u1){
            test.starttest();
            /*
            
            Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true);
            acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
            insert acc;
            
            url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + acc.Id;
                
            Access_Request__c accreq = new Access_Request__c();
            accreq.Type__c = 'Create Access Request';
            accreq.Access_for_URL__c = url;
            accreq.Request_For__c = u2.id;
            accreq.Region__c = 'APJ';
            accreq.Reason_for_the_request__c = 'Additional Access';
            accreq.Mirror__c = u1.Id;
            accreq.Description__c = 'test';
            
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accreq);
            
            AccessRequestSubmitCtlr arctrl = new AccessRequestSubmitCtlr(stdCtrl);
            
            arctrl.ContinueAR();
            arctrl.SaveSubmitAR();
            arctrl.toRequestPage();
            
            accreq.Approver__c = u1.id;
            
            ApexPages.StandardController stdCtrl2 = new ApexPages.StandardController(accreq);
            
            AccessReqReassignController areqreasgn = new AccessReqReassignController(stdCtrl);
            
            areqreasgn.saveapprover();
            
            ApexPages.StandardController standctrl = new ApexPages.StandardController(accreq);
            AccessRequest acreqinstance = new AccessRequest(standctrl);
            
            MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
            multimock.setStaticResource('https://csmstaging.serviceaide.com/servicedesk/webservices/ChangeRequest.ChangeRequestHttpSoap11Endpoint/', 'Access_Req_SD_Response');
            multimock.setStatusCode(200);
            multimock.setHeader('content-type', 'text/xml; charset=utf-8');
            Test.setMock(HttpCalloutMock.class, multimock);
            
            
            acreqinstance.createSDTicket();
            
            
            ApexPages.StandardController stdCtrl8 = new ApexPages.StandardController(accreq);
            
            AccessRequestSubmitCtlr arctrl4 = new AccessRequestSubmitCtlr(stdCtrl8);
            
            arctrl4.ContinueAR();
            arctrl4.SaveSubmitAR();
            arctrl4.toRequestPage();
            
            AccessRequest acreqinstance5 = new AccessRequest(stdctrl8);
            acreqinstance5.getSolutionsList();
*/
            
            List <MetadataService.FolderShare> FolderShareDetails = new List <MetadataService.FolderShare>();
            SolutionWhyList tempwhylist = new SolutionWhyList(FolderShareDetails);
            String key = '001';
            
           
              /*
            SolutionWhyList tempwhylist2 = new SolutionWhyList(acc.Id, u1.Id, key);
            List<Id> territoryIdList = new List<Id>();
            territoryIdList.addAll(SolutionWhyList.TerritoryList(u1.Id));

            
            
          
            Id recordid;
            recordid = [select id from report limit 1].id; 
            url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + recordid;

            
            Access_Request__c accreq0 = new Access_Request__c();
            accreq0.Type__c = 'Create Access Request';
            accreq0.Access_for_URL__c = url;
            accreq0.Request_For__c = u2.id;
            accreq0.Region__c = 'EMEA';
            accreq0.Reason_for_the_request__c = 'Additional Access';
            accreq0.Mirror__c = u1.Id;

            
            ApexPages.StandardController stdCtrlreport = new ApexPages.StandardController(accreq0);
            
            AccessRequestSubmitCtlr arctrlreport = new AccessRequestSubmitCtlr(stdCtrlreport);
            
            arctrlreport.ContinueAR();
            arctrlreport.SaveSubmitAR();
            arctrlreport.toRequestPage();
            
            
            Id dashbid;
            dashbid = [select id from dashboard limit 1].id; 
            url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + dashbid;

            
            Access_Request__c accreq6 = new Access_Request__c();
            accreq6.Type__c = 'Create Access Request';
            accreq6.Access_for_URL__c = url;
            accreq6.Request_For__c = u2.id;
            accreq6.Region__c = 'GLOBAL';
            accreq6.Reason_for_the_request__c = 'Additional Access';
            accreq6.Mirror__c = u1.Id;

            
            ApexPages.StandardController stdCtrldashboard = new ApexPages.StandardController(accreq6);
            
            AccessRequestSubmitCtlr arctrldashboard = new AccessRequestSubmitCtlr(stdCtrldashboard);
            
            arctrldashboard.ContinueAR();
            arctrldashboard.SaveSubmitAR();
            arctrldashboard.toRequestPage();
            
            PendingRequestCtrl pendingreq = new PendingRequestCtrl();
            
            SchedulableContext sch;
            scheduleApproverNotification testschedule = new scheduleApproverNotification();
            testschedule.execute(sch);
            
            
            url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + acc.Id;
            
            Access_Request__c accrequest = new Access_Request__c();
            accrequest.Type__c = 'Create Access Request';
            accrequest.Access_for_URL__c = url;
            accrequest.Request_For__c = u2.id;
            accrequest.Region__c = 'APJ';
            accrequest.Reason_for_the_request__c = 'Additional Access';
            accrequest.Mirror__c = u1.Id;
            accrequest.Description__c = 'test';
            
            ApexPages.StandardController arstdCtrl = new ApexPages.StandardController(accrequest);
            
            AccessRequestSubmitCtlr areqctrl = new AccessRequestSubmitCtlr(arstdCtrl);
            
            areqctrl.ContinueAR();
            areqctrl.SaveSubmitAR();
            areqctrl.toRequestPage();
            
            
            AccessRequest acreqinstance2 = new AccessRequest(arstdCtrl);
            acreqinstance2.cancel();
            acreqinstance2.GrantAccess();
            acreqinstance2.territoryApproval();
            List<String> SharedToList = new List <String> {'test','test1'};
            AccessRequest.UpdateUserRole(u1.UserRoleId, u1.Id);
            Group gm = new Group(id='00Ga0000003sPhg',name='testgroup');
            AccessRequest.insertGrpMember(gm.Id, u1.id);
            
            SolutionWrapper tempwrap = new SolutionWrapper();
            tempwrap.AccessLevel = 'test';
            tempwrap.Frequency = 1;
            tempwrap.Reason = 'test';
            tempwrap.AccessLevel = 'test';
            tempwrap.selected = true;
            
            SolutionWrapper tempwrap9 = new SolutionWrapper();
            tempwrap9.AccessLevel = 'test';
            tempwrap9.Frequency = 2;
            tempwrap9.Reason = 'test';
            tempwrap9.AccessLevel = 'test';
            tempwrap9.selected = true;
            
            List<SolutionWrapper> templist = new List<SolutionWrapper>();
            templist.add(tempwrap);
            templist.add(tempwrap9);
            acreqinstance2.solnList.addall(templist);
            acreqinstance2.SolutionSelected();
            
            AccessRequest.approveRequest(accrequest.Id, 'test', SharedToList);
            
            */
            
            test.stoptest();
        }
    }
    
    public static testmethod void createMirror(){

        user u1=new user(id='00530000003rQuJ');
         userrole urole = new userrole(id='00E300000018UeM');
         
        user u2 = new user(id='00530000003rQuJ');
        system.runas(u1){
            test.starttest();
            
            
            Access_Request__c accreq2 = new Access_Request__c();
            accreq2.Type__c = 'Mirror a User';

            accreq2.Request_For__c = u2.id;
            accreq2.Region__c = 'NA';
            accreq2.Reason_for_the_request__c = 'Additional Access';
            accreq2.Mirror__c = u1.Id;
            
            ApexPages.StandardController stdCtrl2 = new ApexPages.StandardController(accreq2);
            
            AccessRequestSubmitCtlr arctrl2 = new AccessRequestSubmitCtlr(stdCtrl2);
            
            arctrl2.ContinueAR();
            arctrl2.SaveSubmitMirror();
            arctrl2.toRequestPage();
            
            accreq2.Approver__c = u1.id;
            
            ApexPages.StandardController stdCtrl4 = new ApexPages.StandardController(accreq2);
            AccessReqReassignController areqreasgn = new AccessReqReassignController(stdCtrl4);            
            areqreasgn.saveapprover();
            
            ApexPages.StandardController standctrl = new ApexPages.StandardController(accreq2);
            
            AccessRequest acreqinstance = new AccessRequest(standctrl);
            acreqinstance.approveManually();
            acreqinstance.SharedThrough = 'test';
            acreqinstance.Reason = 'test';
            acreqinstance.ReasonDetail = 'test';
            acreqinstance.SolutionDetail = 'test';
            acreqinstance.approverComments = 'test comments';
            acreqinstance.approveManually();

            /*
            Access_Request__c accreq7 = new Access_Request__c();
            accreq7.Type__c = 'Mirror a User';

            accreq7.Request_For__c = u2.id;
            accreq7.Region__c = 'NA';
            accreq7.Reason_for_the_request__c = 'Additional Access';
            accreq7.Mirror__c = u1.Id;
            
            ApexPages.StandardController stdCtrl5 = new ApexPages.StandardController(accreq7);
            
            AccessRequestSubmitCtlr arctrl5 = new AccessRequestSubmitCtlr(stdCtrl5);
            
            arctrl5.ContinueAR();
            arctrl5.SaveSubmitMirror();
            arctrl5.toRequestPage();


            AccessRequest acreqinstance3 = new AccessRequest(stdCtrl5);
            acreqinstance3.getSolutionsList();
            */
            test.stoptest();
        }
    }
    
    
    public static testmethod void createSD(){

        user u1=new user(id='00530000003rQuJ');
        String rejectComment;
        system.runas(u1){
            test.starttest();
            
            
            Access_Request__c accreq3 = new Access_Request__c();
            accreq3.Type__c = 'Create Service Desk Ticket';

            accreq3.Request_For__c = u1.id;
            accreq3.Region__c = 'LA';
            accreq3.Reason_for_the_request__c = 'Additional Access';
            accreq3.Description__c = 'test';

            
            ApexPages.StandardController stdCtrl3 = new ApexPages.StandardController(accreq3);
            
            AccessRequestSubmitCtlr arctrl3 = new AccessRequestSubmitCtlr(stdCtrl3);
            
            arctrl3.ContinueAR();
            
            //Test.setMock(HttpCalloutMock.class, new AccessReqSDTicket_MockCallout());
            MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
            multimock.setStaticResource('https://csmstaging.serviceaide.com/servicedesk/webservices/ChangeRequest.ChangeRequestHttpSoap11Endpoint/', 'Access_Req_SD_Response');
            multimock.setStatusCode(200);
            multimock.setHeader('content-type', 'text/xml; charset=utf-8');
            Test.setMock(HttpCalloutMock.class, multimock); 
			arctrl3.saveAR();
            //arctrl3.createSDTicket();
            arctrl3.toRequestPage();
            
            
            ApexPages.StandardController stdCtrl5 = new ApexPages.StandardController(accreq3);
            accessRequest ar = new accessRequest(stdCtrl5);
            ar.reject();
            
            ar.rejectComment = 'test';
            ar.reject();
            
            Access_Request__c accreq4 = new Access_Request__c();
            accreq4.Type__c = 'Create Service Desk Ticket';

            accreq4.Request_For__c = u1.id;
            accreq4.Region__c = 'EMEA';
            accreq4.Reason_for_the_request__c = 'Additional Access';

            accreq4.SD_Ticket__c = '200-101010';

            
            ApexPages.StandardController stdCtrl4 = new ApexPages.StandardController(accreq4);
            
            AccessRequestSubmitCtlr arctrl4 = new AccessRequestSubmitCtlr(stdCtrl4);
            
            arctrl4.ContinueAR();
            arctrl4.saveAR();
            
            
            
            test.stoptest();
        }
    }
    
    public static testmethod void metadataservicetest(){

        user u1=new user(id='00530000003rQuJ');
        
        system.runas(u1){
            test.starttest();
            
            MetadataService.SharedTo obj = new MetadataService.SharedTo();
            MetadataService.ReportFolder obj1  = new MetadataService.ReportFolder();
            MetadataService.DashboardFolder obj2 = new MetadataService.DashboardFolder();
            MetadataService.FolderShare obj3 = new MetadataService.FolderShare();
            MetadataService.LogInfo obj4 = new MetadataService.LogInfo();
            MetadataService.SessionHeader_element obj5 = new MetadataService.SessionHeader_element();
            MetadataService.ListMetadataQuery obj6 = new MetadataService.ListMetadataQuery();
            MetadataService.FileProperties obj7 = new MetadataService.FileProperties();
            MetadataService.MetadataPort obj8 = new MetadataService.MetadataPort();
            MetadataService.readMetadata_element obj9 = new MetadataService.readMetadata_element();
            MetadataService.listMetadata_element obj10 = new MetadataService.listMetadata_element();
            MetadataService.listMetadataResponse_element obj11 = new MetadataService.listMetadataResponse_element();
            MetadataService.readReportFolderResponse_element obj12 = new MetadataService.readReportFolderResponse_element();
            MetadataService.ReadDashboardFolderResult obj13 = new MetadataService.ReadDashboardFolderResult();
            MetadataService.readDashboardFolderResponse_element obj14 = new MetadataService.readDashboardFolderResponse_element();
            MetadataService.SaveResult obj15 = new MetadataService.SaveResult();
            MetadataService.Error obj16 = new MetadataService.Error();
            MetadataService.updateMetadata_element obj17 = new MetadataService.updateMetadata_element();
            MetadataService.updateMetadataResponse_element obj18 = new MetadataService.updateMetadataResponse_element();
            MetadataService.ReadReportFolderResult obj19 = new MetadataService.ReadReportFolderResult();
            
            test.stoptest();
        }
    }
    
    public static testmethod void solutionlist(){

        user u1=new user(id='00530000003rQuJ');
        List<AggregateResult> AReqList = new List<AggregateResult>();
        String cause = 'test';
        String through = 'test2';
        String throughname = 'testthrough';
        String access = 'Read Only';
        String with = 'test user';
        system.runas(u1){
            test.starttest();
            SolutionWrapper tempwrap = new SolutionWrapper();
            SolutionWrapper tempwrap2 = new SolutionWrapper(AReqList, cause, through, throughname);
            SolutionWrapper tempwrap3 = new SolutionWrapper(cause, access, through, AReqList);
            SolutionWrapper tempwrap4 = new SolutionWrapper(through, With, Cause, access, AReqList);
            SolutionWrapper tempwrap5 = new SolutionWrapper(cause, through, AReqList);
            access = 'Read/Write';
            SolutionWrapper tempwrap6 = new SolutionWrapper(through, With, Cause, access, AReqList);
            access = 'Private';
            SolutionWrapper tempwrap7 = new SolutionWrapper(through, With, Cause, access, AReqList);
            access = 'Full Access';
            SolutionWrapper tempwrap8 = new SolutionWrapper(through, With, Cause, access, AReqList);
            tempwrap.AccessLevel = 'test';
            tempwrap.Frequency = 1;
            tempwrap.Reason = 'test';
            tempwrap.AccessLevel = 'test';
            
            SolutionWrapper tempwrap9 = new SolutionWrapper();
            tempwrap9.AccessLevel = 'test';
            tempwrap9.Frequency = 2;
            tempwrap9.Reason = 'test';
            tempwrap9.AccessLevel = 'test';
            
            List<SolutionWrapper> templist = new List<SolutionWrapper>();
            templist.add(tempwrap);
            templist.add(tempwrap9);
            
            templist.sort();
            
            
            MetadataService.FolderShare objt1 = new MetadataService.FolderShare();
            objt1.accessLevel = 'View';
            objt1.sharedToType = 'User';
            objt1.sharedTo = 'bajpi01ca.com';
            
            MetadataService.FolderShare objt2 = new MetadataService.FolderShare();
            objt2.accessLevel = 'View';
            objt2.sharedToType = 'Role';
            objt2.sharedTo = 'GIS';
            
            MetadataService.FolderShare objt3 = new MetadataService.FolderShare();
            objt3.accessLevel = 'View';
            objt3.sharedToType = 'Group';
            objt3.sharedTo = 'A10NetworksIncPartnerUserA';
            
            MetadataService.FolderShare objt4 = new MetadataService.FolderShare();
            objt4.accessLevel = 'View';
            objt4.sharedToType = 'Territory';
            objt4.sharedTo = 'ANDEAN_SOUTH_FY18';
            
            MetadataService.FolderShare objt5 = new MetadataService.FolderShare();
            objt5.accessLevel = 'View';
            objt4.sharedToType = 'Territory';
            objt5.sharedTo = 'ANDEAN_SOUTH_FY18';
            
            List <MetadataService.FolderShare> sharedetails = new List<MetadataService.FolderShare>();
            sharedetails.add(objt1);
            sharedetails.add(objt2);
            sharedetails.add(objt3);
            sharedetails.add(objt4);
            sharedetails.add(objt5);
            
            SolutionWhyList tempwhylist = new SolutionWhyList(sharedetails);
            tempwhylist.getSharedList();
            
             SolutionWhyList.rawData = 'No records to display';
            SolutionWhyList tempwhylist2 = new SolutionWhyList(sharedetails);
           
            tempwhylist2.getWhylist();
            
      
            Account acc = [select id,Ownerid from account where Ownerid!=null limit 1];
            User u = [select id,userroleid from user where userroleid!=null limit 1 ];
            user u2 = [select id,profileid,userroleid,username from user where id=: acc.OwnerId limit 1];
            String url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + acc.Id;
            Access_Request__c accreq = new Access_Request__c();
            //accreq.Mirror__c = u.Id;
           //accreq.Access_for_URL__c = url;
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accreq);
            AccessRequest acreqinstance = new AccessRequest(stdctrl);
            acreqinstance.getSolutionsList();
            accreq.Mirror__c = u2.Id;
            accreq.Access_for_URL__c = url;
            accreq.Request_For__c = u.id;
            accreq.Region__c = 'EMEA';
            accreq.Reason_for_the_request__c = 'Additional Access';
            AccessRequestSubmitCtlr acrq = new AccessRequestSubmitCtlr(stdctrl);
            acrq.SaveSubmitAR();
            SolutionWrapper tempwrap10 = new SolutionWrapper();
            tempwrap10.AccessLevel = 'test';
            tempwrap10.Frequency = 2;
            tempwrap10.Reason = 'Manual Sharing';

            SolutionWrapper tempwrap11 = new SolutionWrapper();
            tempwrap11.AccessLevel = 'test';
            tempwrap11.Frequency = 2;
            tempwrap11.SharedThrough = '00Ga0000003sPhg';
            tempwrap11.Reason = 'Owner';
            
            SolutionWrapper tempwrap12 = new SolutionWrapper();
            tempwrap12.AccessLevel = 'test';
            tempwrap12.Frequency = 2;
            tempwrap12.SharedThrough = '00E300000018UeM';
            tempwrap12.Reason = 'Account Sharing Rule';
            
            SolutionWrapper tempwrap13 = new SolutionWrapper();
            tempwrap13.AccessLevel = 'test';
            tempwrap13.Frequency = 2;
            tempwrap13.SharedThrough = '00Ga0000003sPhg';
            tempwrap13.Reason = 'Account Sharing Rule';
            
            SolutionWrapper tempwrap14 = new SolutionWrapper();
            tempwrap14.AccessLevel = 'test';
            tempwrap14.Frequency = 2;
            tempwrap14.SharedThrough = u2.Username;
            tempwrap14.Reason = 'Account Team';
            tempwrap14.SharedWith = 'User: '+u2.Id;

            
            SolutionWrapper tempwrap15 = new SolutionWrapper();
            tempwrap15.AccessLevel = 'test';
            tempwrap15.Frequency = 2;
            tempwrap15.SharedThrough = '00E300000018UeM';
            tempwrap15.Reason = 'Role';
            
            
            SolutionWrapper tempwrap16 = new SolutionWrapper();
            tempwrap16.AccessLevel = 'test';
            tempwrap16.Frequency = 2;
            tempwrap16.SharedThrough = '00e30000000oou3';
            tempwrap16.Reason = 'Profile';
            
            SolutionWrapper tempwrap17 = new SolutionWrapper();
            tempwrap17.AccessLevel = 'test';
            tempwrap17.Frequency = 2;
            tempwrap17.SharedThrough = '0PSa00000003eOy';
            tempwrap17.Reason = 'Permission Set';
            
            
            SolutionWrapper tempwrap18 = new SolutionWrapper();
            tempwrap18.AccessLevel = 'test';
            tempwrap18.Frequency = 2;
            tempwrap18.SharedThrough = '00Ga0000003sPhg';
            tempwrap18.Reason = 'Group';
            
            List<SolutionWrapper> templist2 = new List<SolutionWrapper>();
            templist2.add(tempwrap10);
            templist2.add(tempwrap11);
            templist2.add(tempwrap12);
            templist2.add(tempwrap13);
            templist2.add(tempwrap14);
            templist2.add(tempwrap15);
            templist2.add(tempwrap16);
            templist2.add(tempwrap17);
            templist2.add(tempwrap18);
            processURL pURL = new processURL(accReq.Access_for_URL__c);
            acreqinstance.pURL = pURL;
            acreqinstance.accReq = accreq;
            acreqinstance.selectSolutionList.addall(templist2);
            acreqinstance.GrantAccess();

            
            
            Id dashbid;
            dashbid = [select id from dashboard limit 1].id; 
            url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + dashbid;

            
            Access_Request__c accreq6 = new Access_Request__c();
            accreq6.Type__c = 'Create Access Request';
            accreq6.Access_for_URL__c = url;
            accreq6.Request_For__c = u2.id;
            accreq6.Region__c = 'GLOBAL';
            accreq6.Reason_for_the_request__c = 'Additional Access';
            accreq6.Mirror__c = u1.Id;

            
            ApexPages.StandardController stdCtrldashboard = new ApexPages.StandardController(accreq6);
            
            AccessRequestSubmitCtlr arctrldashboard = new AccessRequestSubmitCtlr(stdCtrldashboard);
            
            arctrldashboard.ContinueAR();
            arctrldashboard.SaveSubmitAR();
            arctrldashboard.toRequestPage();
            
            
            AccessRequest acreqinstance10 = new AccessRequest(stdCtrldashboard);
            String sessionid = userinfo.getSessionId();
            String FolderDevName = acreqinstance10.FolderDevName;
            AccessRequest.updateDashboardShareDetails(FolderDevName, 'AccessLevel', 'userEmail', sessionid);
            
            Id recordfolderid='00l30000000uadM';
            String FolderName = [Select developername from folder where id =:recordfolderid].developername;
            acreqinstance10.reportsharedetails(FolderName);
            
            AccessRequest.updateReportShareDetails(FolderName, 'AccessLevel', 'userEmail', sessionid);
            Id recordid = '00Oa0000008NNTe';
            url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + recordid;

            
            Access_Request__c accreq0 = new Access_Request__c();
            accreq0.Type__c = 'Create Access Request';
            accreq0.Access_for_URL__c = url;
            accreq0.Request_For__c = u2.id;
            accreq0.Region__c = 'EMEA';
            accreq0.Reason_for_the_request__c = 'Additional Access';
            accreq0.Mirror__c = u1.Id;

            
            ApexPages.StandardController stdCtrlreport = new ApexPages.StandardController(accreq0);
            
            AccessRequestSubmitCtlr arctrlreport = new AccessRequestSubmitCtlr(stdCtrlreport);
            
            arctrlreport.ContinueAR();
            arctrlreport.SaveSubmitAR();
            arctrlreport.toRequestPage();
            AccessRequest accreqreport = new AccessRequest(stdCtrlreport);
            
            test.stoptest();
        }
    }
    
    
}