trigger BPfromParentaccount_bi_bu on Business_Plan__c (before insert) {
set<ID> sid=new set<ID>();
for(Business_Plan__c bp:trigger.new)
{
    sid.add(bp.account__c);
}
Map<ID,Account> m = new Map<ID,Account>([Select Alliance_program_level__c,Service_Provider_Program_level__c,Solution_Provider_Program_Level__c from Account where id=:sid]);
for(Business_Plan__c bp:trigger.new)
{
      if(bp.Plan_Partner_Level__c==null)
      {   
          if(m.get(bp.account__c).alliance_program_level__c != null) 
          bp.Plan_Partner_Level__c=m.get(bp.account__c).Alliance_Program_Level__c;     
          else if(m.get(bp.account__c).Service_Provider_Program_level__c!= null) 
          bp.Plan_Partner_Level__c=m.get(bp.account__c).Service_Provider_Program_level__c;     
          else if(m.get(bp.account__c).Solution_Provider_Program_Level__c != null) 
          bp.Plan_Partner_Level__c=m.get(bp.account__c).Solution_Provider_Program_Level__c ;     
      }     
 }

}