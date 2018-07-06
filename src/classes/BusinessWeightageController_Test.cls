@isTest
public class BusinessWeightageController_Test {
    
    //@isTest (seealldata=true)
    static testMethod void testMethod1() {
        
        //Total Score.. [select LoyalityHistorial__c,PartnerProgramScore__c,ProductCompetency__c from lead__c where name='Total Score'];
         Lead__c record=new Lead__c();
        Lead__c dispRec=new Lead__c(name='Total Score',LoyalityHistorial__c=40,PartnerProgramScore__c=20,ProductCompetency__c=40);
        insert dispRec;
        
         record.LoyalityHistorial__c=40;
         record.PartnerProgramScore__c=20;
         record.ProductCompetency__c=40;
        
        ApexPages.StandardController scl = new ApexPages.StandardController(record);
        
        BusinessWeightageController bwc=new BusinessWeightageController(scl);
        
          string score_LH='10';
          string score_PPS='20';
          string score_PC='40';
        bwc.setscore_LH('10');
        bwc.getscore_LH();
        bwc.setscore_PPS('20');
        bwc.getscore_PPS();
        bwc.setscore_PC('10');
        bwc.getscore_PC();
        
        bwc.UpdateScores();
        
        bwc.setscore_LH('aa');
        bwc.getscore_LH();
        bwc.UpdateScores();
        
        
    }
    

}