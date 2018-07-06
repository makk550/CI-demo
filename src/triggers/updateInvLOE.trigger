trigger updateInvLOE on Agile_Application_Inventory__c (before insert, before update) {

    for(Agile_Application_Inventory__c inv : Trigger.new){
        if(System.Trigger.isInsert){
            List<Agile_Estimation_Factor__c> est1 = [select id,Design_LOE__c,Build_Unit_Test_LOE__c,SIT_LOE__c from Agile_Estimation_Factor__c where Type__c = :inv.Type__c and Complexity__c = :inv.Complexity__c];
            if(est1!=null && est1.size()>0){
                inv.Design_LOE__c = ((Agile_Estimation_Factor__c)est1.get(0)).Design_LOE__c;
                inv.Build_LOE__c = ((Agile_Estimation_Factor__c)est1.get(0)).Build_Unit_Test_LOE__c;
            }
    
        }
        if(Trigger.new[0].Override_Estimated_LOE__c ==false){
            List<Agile_Estimation_Factor__c> est = [select id,Design_LOE__c,Build_Unit_Test_LOE__c,SIT_LOE__c from Agile_Estimation_Factor__c where Type__c = :inv.Type__c and Complexity__c = :inv.Complexity__c];
            
            if(est!=null && est.size()>0){
                inv.Estimated_Design_LOE__c = ((Agile_Estimation_Factor__c)est.get(0)).Design_LOE__c;
                inv.Estimated_Build_Unit_Test_LOE__c = ((Agile_Estimation_Factor__c)est.get(0)).Build_Unit_Test_LOE__c;
                inv.Estimated_SIT_LOE__c = ((Agile_Estimation_Factor__c)est.get(0)).SIT_LOE__c;
            }else{
                inv.Estimated_Design_LOE__c = 0;
                inv.Estimated_Build_Unit_Test_LOE__c = 0;
                inv.Estimated_SIT_LOE__c = 0;
          
            }
        }
    }
}