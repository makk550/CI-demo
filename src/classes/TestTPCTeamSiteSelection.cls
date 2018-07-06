@isTest
public class TestTPCTeamSiteSelection {
    public static testMethod void TPCTeamSiteSelectionTest(){
        TPC_Team__c tpcTeam = new TPC_Team__c();
        insert tpcteam;
        TPCTeamSiteSelection controller   =  new TPCTeamSiteSelection(new ApexPages.StandardController(tpcteam));
        controller.filterResult();
        controller.save();
        
        Site_Association__c site = new Site_Association__c();
        
        TPCTeamSiteSelection.SiteAssociationWrapper innerC = new TPCTeamSiteSelection.SiteAssociationWrapper(site);
    }
}