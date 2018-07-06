trigger Fund_Program_Admin_BIBU on Fund_Programs_Admin__c (before insert, before update) {
    
    MDF_Utils.populateOwnerOnProgramAdmin(Trigger.new);
    
    if(Trigger.isbefore && Trigger.isInsert){
       // US498557 : Fix Ca share(CA_Share__c) to 100% - amili01
        MDF_Utils.populateCAshare(Trigger.new);
    }
           
}