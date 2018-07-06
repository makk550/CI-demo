trigger Update_OpportunityOnLeadConversion_Trigger on Lead (after update) {

        if(SystemIdUtility.isLeadUpdate1 != true)
        {
            List<Lead> leadList = new List<Lead>();
            List<String> lstLead = new List<String>();
            List<Opportunity> oppsList = new List<Opportunity>();
            set<String> convertedOppIds = new set<String>();
            // instantiate the AutoLeadConversion utility class 
            
           
            boolean condition1;
            boolean condition2;
            boolean condition3;  
            boolean condition_old;
            integer i=0;        
            // create the leads list
            for(Lead ld:Trigger.New) {
                condition1 = ld.IsConverted;
                system.debug('condition1='+condition1);
                system.debug('ld.isconverted='+ld.isconverted);
                
                condition2 = (ld.ConvertedOpportunityId != null) ? true:false;
                system.debug('ld.ConvertedOpportunityId='+ld.ConvertedOpportunityId);
                condition3 = SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId)||SystemIdUtility.IsDeal_RegistrationRecordType(ld.recordTypeId);
                condition_old = (trigger.old[i].isconverted  != true) ;
          
                System.debug(logginglevel.Debug,'Printing lead details : '+ld.IsConverted+','+ld.Name+','+ld.ConvertedOpportunityId);
                
                // if all the above conditions pass, then add the lead to the list and update its converted opps.  
                if(condition1 && condition2 && condition3 && condition_old)
                {
                    convertedOppIds.add(ld.ConvertedOpportunityId);
                    leadList.add(ld);
                    lstLead.add(ld.Id);
                    
                } 
                i++;              
            }
            if(convertedOppIds.size()>0)  
            {                
                //Moved the logic to future method to minimize queries                
                FutureProcessor.UpdateOpportunity_OnLeadConversion(lstLead,convertedOppIds);
                SystemIdUtility.isLeadUpdate1 = true;
            }   
        
        }
         
}