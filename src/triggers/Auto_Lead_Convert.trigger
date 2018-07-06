// Trigger for Auto lead conversion
// This trigger would use a maximum of 5 SOQL calls, 1 DML statement and a Database call
trigger Auto_Lead_Convert on Lead (after update,after insert) {

    List<Lead> leadList = new List<Lead>();
    // instantiate the AutoLeadConversion utility class
    AutoLeadConversion alConversion = new AutoLeadConversion();
    boolean condition1;
    boolean condition2;
    boolean condition3;
    boolean condition4;
    boolean condition5;
    boolean condition6;
    boolean condition7;
    boolean condition8;

    String BU; 
    
    // identify the lead type 
    for(Lead ld:Trigger.New) {  
        condition1 = (ld.Reseller_Qualified__c==1) ? true : false;
        system.debug('condition1='+condition1);
        condition2 = (ld.GEO__c !=  null) ? true : false;
        system.debug('condition2='+condition2);

        BU = ld.BU__c;
        condition3 = (BU != '' && BU != null && (BU.equalsIgnoreCase('RMDM') || BU.equalsIgnoreCase('ISBU') || BU.equalsIgnoreCase('Value'))) ? true : false;
        system.debug('condition3='+condition3);

        condition4 = (ld.Reseller__c != null) ? true : false;
        system.debug('condition4='+condition4);

        condition5 = (ld.isconverted == false) ? true : false;
        system.debug('condition5='+condition5);

        condition6 = SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId); 
        system.debug('condition6='+condition6);
        
        // condition added by Heena for PRM R2 Deal Reg Auto Conversion
        condition7 = SystemIdUtility.IsDeal_RegistrationRecordType(ld.recordTypeId); 
        system.debug('condition7='+condition7);
        
        // condition added by Heena for PRM R2 Deal Reg Auto Conversion
        condition8 = (ld.Deal_Registration_Status__c == SystemIdUtility.Deal_Registration_STATUS) ? true : false;
        system.debug('condition8='+condition8);


        // if all the above conditions pass, add the lead to the list for conversion    
        if(condition1 && condition2 && condition3 && condition4 && condition5 && condition6)
        {
            leadList.add(ld);       
        }  
        // condition added by Heena for PRM R2 Deal Reg Auto Conversion
        else if(condition5 && condition7 && condition8){
            leadList.add(ld);
        } 
    }
    // call the leads datasetup process
    if(leadList.size()>0)
    {
        system.debug('going inside convert class with list'+leadList);
        alConversion.setupData(leadList);   
    }
}