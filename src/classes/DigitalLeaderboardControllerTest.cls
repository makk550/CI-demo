@isTest(seealldata = true)
public class DigitalLeaderboardControllerTest {
    
    @isTest static void testtickerdata(){
        testDatacreation();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/00Oa0000008e2AU', 'testDigitalsalesLeaderboardTicker');
        //multimock.setStaticResource('https://login.salesforce.com/services/oauth2/token', 'testDigitalsalesLeaderboardoauth');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
 		Test.setMock(HttpCalloutMock.class, multimock);
        DigitalLeaderboardController.GetTickerData('NA');
        //DigitalLeaderboardMainController.getSFDCReportsID('NA','topISRsbySAOsID');
        
    } 
    @isTest static void testdealsdata(){
        testDatacreation();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/00Oa0000008e2Vr/describe', 'testDigitalsalesLeaderboardDeal1');
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/00Oa0000008e2Vr?includeDetails=true', 'testDigitalsalesLeaderboardDeal2');
       
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
 		Test.setMock(HttpCalloutMock.class, multimock);
        DigitalLeaderboardController.GetDealsData('bookedDealsByQuarter','NA');
        //DigitalLeaderboardMainController.getSFDCReportsID('NA','topISRsbySAOsID'); DigitalLeaderboardMainController.SaveTeamPhotos('NA');
        
    } 
     @isTest static void testsavephotos(){
        testDatacreation( );
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        //multimock.setStaticResource('https://ca.my.salesforce.com/services/data/v29.0/analytics/reports/00Oa0000008e2Vr/describe', 'testDigitalsalesLeaderboardsavephotos');
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/00Oa0000008qn0A?includeDetails=true', 'testDigitalsalesLeaderboardsavephotos');
        //multimock.setStaticResource('https://login.salesforce.com/services/oauth2/token', 'testDigitalsalesLeaderboardoauth');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
 		Test.setMock(HttpCalloutMock.class, multimock);
        DigitalLeaderboardController.SaveTeamPhotos('NA');
        //DigitalLeaderboardMainController.getSFDCReportsID('NA','topISRsbySAOsID'); DigitalLeaderboardMainController.SaveTeamPhotos('NA');
        
    } 
    @isTest static void testdashboard(){
        /*StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('testDigitalsalesLeaderboardoauth');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);*/
        testDatacreation();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        //multimock.setStaticResource('https://ca.my.salesforce.com/services/data/v29.0/analytics/reports/00Oa0000008e2Vr/describe', 'testDigitalsalesLeaderboardsavephotos');testDigitalsalesLeaderboardDashfilter
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v31.0/analytics/dashboards/01Za000000171eG', 'testDigitalsalesLeaderboardDash1');
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v31.0/analytics/dashboards/01Za000000171eG?filter1=0ICa000000052awGAA', 'testDigitalsalesLeaderboardDashfilter');
        //multimock.setStaticResource('https://login.salesforce.com/services/oauth2/token', 'testDigitalsalesLeaderboardoauth');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
 		Test.setMock(HttpCalloutMock.class, multimock);
        DigitalLeaderboardController.RefreshDashboardAndFilters('NA');
        //DigitalLeaderboardMainController.getSFDCReportsID('NA','topISRsbySAOsID'); DigitalLeaderboardMainController.SaveTeamPhotos('NA');
      
    }
    @isTest static void testemail( ){
        try{
            List<String> testList;
            testList.add('test');
        }catch(Exception e){
           DigitalLeaderboardController.sendEmailonException(e,'xxx'); 
        }
        
    }
     @isTest static void testDatacreation( ){
         List<DigitalLeaderbaordID__c> listData =[SELECT id,Name FROM DigitalLeaderbaordID__c where Name ='NA'];
         if(listData.size() == 0){
              DigitalLeaderbaordID__c d =new DigitalLeaderbaordID__c(bookedDealsByQuarter__c = '00Oa0000008e2Vr',Booked_Deals_componentID__c ='01aa0000003II3uAAG',	dashboardID__c='01Za000000171eG',insideSalesUsers__c='00Oa0000008qn0A',likelyDealsByQuarter__c='00Oa0000008e2y0',Name='NA',Pipeline_Added_ComponentId__c='01aa0000003II3zAAG',SAO_ComponentID__c='01aa0000003II3fAAG',topISRsbySAOsID__c='00Oa0000008e2AU');
	  		  upsert d;
         }
     

    }
  

}