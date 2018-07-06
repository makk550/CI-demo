trigger UpdateOwnerManager on Lead (before update) 
{
    Set<ID> leadownerid = new Set<ID>();
    //Set<ID> leadId = new Set<ID>();
    List<Lead> updleads = new List<Lead>();
    //Get all the lead owners in a Set
    for(Integer leadcount=0;leadcount<Trigger.new.size();leadcount++)
    {
    	//adding condition.
        //if(Trigger.new[leadcount].RouteLeads__c == false){
        if(Trigger.new[leadcount].RouteLeads__c!=Trigger.old[leadcount].RouteLeads__c && Trigger.new[leadcount].RouteLeads__c == false
           || Trigger.new[leadcount].OwnerID!=Trigger.old[leadcount].OwnerID){
            leadownerid.add(Trigger.new[leadcount].OwnerID);
            //leadId.add(Trigger.new[leadcount].ID);
            updleads.add(Trigger.new[leadcount]);
        
        }
    }
    if(leadownerid.size()>0)
    {
        
        List<User> lstuser = new List<User>();
        try{
        //Query users on basis of IDs contained in the owner set
        lstuser = [select Profile.Name, ManagerID from User where ID in: leadownerid];
        }catch(QueryException qex){
            System.debug(qex.getMessage()); 
        }
        if(lstuser.size()>0)
        {
            
                for(Integer leadcnt=0;leadcnt<updleads.size();leadcnt++)
                {
                    for(Integer usercnt=0;usercnt<lstuser.size();usercnt++)
                    {
                        if(updleads[leadcnt].OwnerID == lstuser[usercnt].ID)
                        {
                            //assign the owners' manager to the lead record
                            if(lstuser[usercnt].ManagerID != null)
                                updleads[leadcnt].Lead_Owner_s_Manager__c = lstuser[usercnt].ManagerID;
                                //ADDED BY AFZAL, CR:189475066 
                                updleads[leadcnt].Lead_Owner_s_Profile__c = lstuser[usercnt].Profile.Name;
                                //
                                System.debug(updleads[leadcnt].Lead_Owner_s_Manager__c);
                        }    
                    }
                }
               
        }
    }
    
}