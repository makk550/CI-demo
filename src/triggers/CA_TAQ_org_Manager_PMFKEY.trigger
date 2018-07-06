trigger CA_TAQ_org_Manager_PMFKEY on TAQ_Organization__c (before insert, before update) 
{
    if(SystemIdUtility.skipTAQ_Organization && Label.Calculate_Manager_TAQ_Org <> 'Yes' ) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
    
    //FY14 - CR:193978292 - Employee status date should be changed when below fields are modified.
    if(trigger.isUpdate)
    	for(TAQ_Organization__c to: trigger.new){
    		if(TAQ_OrgActions.MGR_PMFCHANGECHECK_REQ && to.Process_Step__c !=  'Open Headcount' && trigger.oldMap.get(to.id).Employee_Status_Date__c == to.Employee_Status_Date__c &&
    		   	(trigger.oldMap.get(to.id).Cost_Center_Desc__c != to.Cost_Center_Desc__c ||
    		   	 trigger.oldMap.get(to.id).JobTitle__c  != to.JobTitle__c  ||
    		     trigger.oldMap.get(to.id).Manager_PMF_Key__c  != to.Manager_PMF_Key__c  
    		    )
    		  )
    		  {
    		  	to.addError('Employee Status date must be updated if cost center, job title, or Manager PMFKey is changed');
    		  }
    		
    	} 
    
    
  //Added by Saba FY12
    if(FutureProcessor_TAQ.skiporgtriggers) //This trigger is being called from future method for subordinate manager info updation - FutureProcessor_TAQ.UpdateSubordinate
        return;
      
    if(SystemIdUtility.isneeded==true)//---****---TO SKIP THIS TRIGGER WHEN TRYING TO UPDATE SUBORDINATE'S RECORDS IF THEIR RESPECTIVE MANAGER IS TERMINATED OR  HIRED
        return;   
      
      
      
      
    Set<string> pmfKeys = new Set<string>();
    integer i =0;
    for(TAQ_Organization__c  t:Trigger.new)
    {
        if( (Trigger.isInsert && t.Manager_PMF_Key__c!=null) || (trigger.isUpdate && trigger.Old[i].Manager_PMF_Key__c != t.Manager_PMF_Key__c))
                pmfkeys.add(t.Manager_PMF_Key__c);
   
        i++;
    }

   i =0;  


    if(pmfkeys.size() > 0)
     {
         List<User> userRecords = [select id,name,firstname, lastname,pmfkey__c from user where pmfkey__c in:pmfkeys];
         List<TAQ_Organization__c> orgRecords = [select Process_Step__c,Id,PMFKey__c from TAQ_Organization__c where pmfkey__c in: pmfkeys and Process_Step__c != 'Term / Transfer'];
            map<String,user> userMap= new Map<String,user>();
            for(user u:userRecords ){            
                userMap.put(u.pmfkey__c.toUpperCase(), u);
            }
            
            Map<String,Id> orgMap = new Map<String,Id>();
            for(TAQ_Organization__c o: orgRecords){
                orgMap.put(o.PMFKey__c,o.Id);
            }
        for(TAQ_Organization__c  t:Trigger.new)
        {
            string mgrName = '';
                  if( (Trigger.isInsert && t.Manager_PMF_Key__c!=null) || (trigger.isUpdate && trigger.Old[i].Manager_PMF_Key__c != t.Manager_PMF_Key__c))
                  {    User mgr= userMap.get(t.Manager_PMF_Key__c.toUpperCase());
                        if(mgr != null)
                             t.Manager_Name__c = mgr.LastName + ', ' + mgr.FirstName;
                        else if (t.Manager_PMF_Key__c.length() >7)
                             t.Manager_Name__c = 'Open_' + t.Manager_PMF_Key__c;                          
                        else
                            t.addError('Invalid Manager PMF Key. No Manager Record Found ');   
                 
                        if(t.Manager_PMF_Key__c != null){ 
                         t.Manager_org__c = NULL;           
                         if(orgMap.containsKey(t.Manager_PMF_Key__c))  
                              t.Manager_org__c = orgMap.get(t.Manager_PMF_Key__c);
                        }
                  }
          i++;
        }   
        
    }
     i =0; 
    }