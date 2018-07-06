@isTest(SeeAllData=true)
public class CreateOpportunitySalesTeam_UtilTest
{
    
    public static testMethod void OpportunitySalesTeam_Util_test() {
       
      
        Integer i =0;
       Set<ID> oppIds = new Set<ID>();
       
       List<Opportunity> oppList;
       
       oppList = [Select Distributor_6__c from Opportunity where Distributor_6__c != null limit 1000];
       if (oppList != null) for(Opportunity opp: oppList) oppIds.add(opp.Distributor_6__c);
       
       oppList = [Select reseller__c from Opportunity where reseller__c != null limit 1000];
       if (oppList != null) for(Opportunity opp: oppList) oppIds.add(opp.reseller__c);
       
       oppList = [Select partner__c from Opportunity where partner__c != null limit 1000];
       if (oppList != null) for(Opportunity opp: oppList) oppIds.add(opp.partner__c);
       
       oppList = [Select partner_1__c from Opportunity where partner_1__c != null limit 1000];
       if (oppList != null) for(Opportunity opp: oppList) oppIds.add(opp.partner_1__c);
       
       
       List<Account> accList = [Select Id, (Select Id from Opportunities limit 1)  from Account where Id in :oppIds and Id in (Select AccountId from accountteammember) limit 1000];
       
       List<Id> accList_1 = new List<Id>();
        Set<Id> oppSet_1 = new Set<Id>();
        for(Account acc: accList) {
            accList_1.add(acc.Id);
            for(Opportunity op : acc.Opportunities)
            oppSet_1.add(op.Id);
            if(i> 20) break;
            i++;
        }
        List<Id> accList_2 = new List<Id>();
        Set<Id> oppSet_2 = new Set<Id>();
        for(Account acc: accList) {
            accList_2.add(acc.Id);
           for(Opportunity op : acc.Opportunities)
            oppSet_2.add(op.Id);
        }
        List<Id> accList_3 = null;
        Set<Id> oppSet_3 = null;
       
       Test.startTest();
        CreateOpportunitySalesTeam_Util.createOpportunitySalesTeam(accList_1, oppSet_1);
        CreateOpportunitySalesTeam_Util.createOpportunitySalesTeam(accList_2, oppSet_2);
        CreateOpportunitySalesTeam_Util.createOpportunitySalesTeam(accList_3, oppSet_3);
       Test.stopTest();
       
      
      }
}