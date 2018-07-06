trigger UpdateRPDvalue on Renewal_Scenario__c (after insert,after update) {
List<Opportunity> opp = new List<Opportunity>();

for(Renewal_Scenario__c rs:Trigger.New){
if(rs.Finance_Approval__c == true){
if(rs.Override_Actual_Old_RPD__c <> null||rs.Override_Actual_New_RPD__c <> null){
 Opportunity rpd = new Opportunity(id= rs.Opportunity__c,Override_Actual_Old_RPD__c = rs.Override_Actual_Old_RPD__c,Override_Actual_New_RPD__c = rs.Override_Actual_New_RPD__c);
 opp.add(rpd);
 }else{
  Opportunity rpd = new Opportunity(id= rs.Opportunity__c,Override_Actual_Old_RPD__c = null,Override_Actual_New_RPD__c = null);
  opp.add(rpd);
 }
}}
update opp; 
}