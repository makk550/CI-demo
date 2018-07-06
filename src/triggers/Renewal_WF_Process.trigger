trigger Renewal_WF_Process on Renewal__c (before update,after update) {

if(Trigger.isupdate)
{
    if(trigger.isBefore)
    { 
         String strUserId;      
         List<Renewal__c> Ren = new List<Renewal__c>();      
         List<GroupMember> grpMember = new List<GroupMember>();      
         strUserId = userinfo.getUserId(); /// trigger.new[0].LastModifiedById; 

         
         
         grpMember = [Select g.GroupId, g.Group.CreatedById, g.Group.CreatedDate, g.Group.DoesSendEmailToMembers, g.Group.Email, g.Group.Id, g.Group.LastModifiedById, g.Group.LastModifiedDate, g.Group.Name, g.Group.OwnerId, g.Group.RelatedId, g.Group.SystemModstamp, g.Group.Type, g.Id, g.SystemModstamp, g.UserOrGroupId from GroupMember g  where g.Group.Name = 'Renewal Admin Group' and g.UserOrGroupId = : strUserId ];          // g.Group.Id = '00GT0000001vF4H' and g.UserOrGroupId = : strUserId ];         
            
        Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        Date NextFiscalYear;
        integer  month =date.today().month();
        integer  year=date.today().year();
//      NextFiscalYear =    date.newInstance((month < FiscalYearStartMonth ? year : year + 1) , FiscalYearStartMonth , 1);
        // Adding 1 to FiscalYearStartMonth to make the period start on 5/1 instead of 4/1 
        NextFiscalYear =    date.newInstance((month < FiscalYearStartMonth + 1 ? year : year + 1) , FiscalYearStartMonth , 1);
        
        integer indx=0;
        
        for(Renewal__c r: trigger.New)
        {            
             if(r.Renewal_Date__c   <  NextFiscalYear )
            {
                 if(grpMember.size() == 0 && trigger.old[indx].IsRecordLocked__c != true )
                 {
                    r.addError('Renewal cannot be saved as Quota Setting is closed for that Fiscal Year.'); 
                 }
            }
             /*if(grpMember.size() == 0 && trigger.old[indx].IsRecordLocked__c != true )
             {
               r.addError('You are not authorized to edit/save renewal.'); 
             }
             else 
             {           
                 if(r.Renewal_Date__c   >=  NextFiscalYear )
                  {
                     r.addError('Renewal Can not be saved as the Renewal date is less than the Renewal Fiscal Year.'); 
                  }
             }*/
        indx++;    
        }
       
        
        try{       
        for(Integer i=0;i<Trigger.new.size();i++){
        
           //new change
            //Trigger.new[i].Old_Proj_Renewal_LC__c=Trigger.old[i].Projected_Renewal__c;
            
            if(Trigger.new[i].Projected_Renewal__c <> Trigger.old[i].Projected_Renewal__c)            
                    Trigger.new[i].Unapproved_Projected_Renewal_amount__c=Trigger.old[i].Projected_Renewal__c;
                    
            if(Trigger.new[i].Segmentation__c <> Trigger.old[i].Segmentation__c)
            {
                    Trigger.new[i].Old_Segmentation__c=Trigger.old[i].Segmentation__c;
                    Trigger.new[i].Unapprove_Segmentation__c=Trigger.old[i].Segmentation__c;                        
            }        
                    system.debug('------Trigger.new[i].Old_Segmentation__c----------'+Trigger.new[i].Old_Segmentation__c);
                    system.debug('------Trigger.old[i].Segmentation__c----------'+Trigger.old[i].Segmentation__c);
                    
                    if(Trigger.new[i].Annual_Projected_Renewal__c <> Trigger.old[i].Annual_Projected_Renewal__c)
                    {                    
                        if((Trigger.old[i].Projected_Time_Duration_Months__c <> 0) || (Trigger.old[i].Projected_Time_Duration_Months__c <> NULL))
                        {
                            Trigger.new[i].Old_Annual_Projected_Renewal__c = (Trigger.old[i].Projected_Renewal__c / Trigger.old[i].Projected_Time_Duration_Months__c) * 12;
                        }
                        else
                        {
                            Trigger.new[i].Old_Annual_Projected_Renewal__c = 0;
                        }
                    }
                    

                    
           if(trigger.new[i].Is_Rejected_Recalled__c == true)//Condition for populating back the values when the record is rejected or recalled
            {
                Renewals_Util.processedRenewals.add(trigger.new[i].Id);
                
                if(trigger.new[i].Unapproved_Projected_Renewal_amount__c !=0 && trigger.new[i].Unapproved_Projected_Renewal_amount__c !=null)// && trigger.new[i].Projected_Renewal__c <> trigger.Old[i].Projected_Renewal__c 
                {          
                    trigger.new[i].Projected_Renewal__c = trigger.new[i].Unapproved_Projected_Renewal_amount__c;
                }
                if(trigger.new[i].Unapproved_Duration_of_months__c !=0 && trigger.new[i].Unapproved_Duration_of_months__c !=null){ 
                                     
                    trigger.new[i].Projected_Time_Duration_Months__c = trigger.new[i].Unapproved_Duration_of_months__c;
                }
                if(trigger.new[i].Unapprove_Segmentation__c != null)
                {
                    trigger.new[i].Name = trigger.new[i].Name.replace(trigger.new[i].Segmentation__c,trigger.new[i].Unapprove_Segmentation__c);
                    trigger.new[i].Segmentation__c =trigger.new[i].Unapprove_Segmentation__c;
                }         
                //if(trigger.new[i].Unapproved_Potential_Pull_Forward__c  != false)
                //{
                    trigger.new[i].Potential_Pull_Forward__c =trigger.new[i].Unapproved_Potential_Pull_Forward__c;
                //}
                trigger.new[i].Change_Of_Projected_Renewal__c = 0; //Check for firing the trigger wf
                trigger.new[i].Is_Segmentation_Changed__c = false;  //Check for firing the trigger wf                
                       
                trigger.new[i].Unapproved_Duration_of_months__c=0;
                trigger.new[i].Unapproved_Projected_Renewal_amount__c = 0;
                trigger.new[i].Unapprove_Segmentation__c=null;
                trigger.new[i].Is_Rejected_Recalled__c = false;
                //trigger.new[i].Potential_Pull_Forward__c = false; // needs corrected logic: ANY rejection causes PPF flag to be set to false
            }
            else if(trigger.old[i].IsRecordLocked__c==true && trigger.new[i].IsRecordLocked__c==false)
            {
                trigger.new[i].Unapproved_Potential_Pull_Forward__c = trigger.new[i].Potential_Pull_Forward__c;            
                       
                trigger.new[i].Unapproved_Duration_of_months__c=0;
                trigger.new[i].Unapproved_Projected_Renewal_amount__c = 0;
                trigger.new[i].Unapprove_Segmentation__c=null;
            }
            else
            {   
                //if(trigger.New[i].Annual_Projected_Renewal__c != null && trigger.old[i].Annual_Projected_Renewal__c !=null)
                
                    if(trigger.New[i].Annual_Projected_Renewal__c != trigger.old[i].Annual_Projected_Renewal__c)
                    {
                         if(trigger.old[i].Annual_Projected_Renewal__c != null 
                         && trigger.old[i].Annual_Projected_Renewal__c != 0 )
                         {
                            Decimal new_annual_projected_renewal = trigger.New[i].Annual_Projected_Renewal__c;
                            if(new_annual_projected_renewal==null)
                                new_annual_projected_renewal=0;
                         
                            //trigger.new[i].Change_Of_Projected_Renewal__c = (trigger.New[i].Annual_Projected_Renewal__c-trigger.old[i].Annual_Projected_Renewal__c)/trigger.old[i].Annual_Projected_Renewal__c*100;
                            trigger.new[i].Change_Of_Projected_Renewal__c = (new_annual_projected_renewal-trigger.old[i].Annual_Projected_Renewal__c)/trigger.old[i].Annual_Projected_Renewal__c*100;
                                if(trigger.new[i].Change_Of_Projected_Renewal__c <=-5)
                                    trigger.new[i].ChangeDate__c=System.Today();
                         }
                         else if(trigger.new[i].Potential_Pull_Forward__c==false)
                         {
                            trigger.new[i].Change_Of_Projected_Renewal__c =  100;
                            trigger.new[i].ChangeDate__c=System.Today();                    
                         }else if((trigger.old[i].Annual_Projected_Renewal__c == null || 
                                    trigger.old[i].Annual_Projected_Renewal__c == 0)&& trigger.new[i].Annual_Projected_Renewal__c !=0
                                    && trigger.new[i].Potential_Pull_Forward__c==true)
                         {
                            trigger.new[i].Change_Of_Projected_Renewal__c =  100;
                            trigger.new[i].ChangeDate__c=System.Today(); 
                         } 
                    }
                
                if(trigger.new[i].Projected_Renewal__c != trigger.old[i].Projected_Renewal__c)
                {
                    trigger.new[i].Unapproved_Projected_Renewal_amount__c=trigger.old[i].Projected_Renewal__c ;
                }
                if(trigger.new[i].Projected_Time_Duration_Months__c != trigger.old[i].Projected_Time_Duration_Months__c)
                {
                    trigger.new[i].Unapproved_Duration_of_months__c =trigger.old[i].Projected_Time_Duration_Months__c;
                }
                if(trigger.new[i].Segmentation__c !=trigger.old[i].Segmentation__c)
                {
                  //  trigger.new[i].Unapprove_Segmentation__c=trigger.old[i].Segmentation__c;
                    trigger.new[i].Is_Segmentation_Changed__c=true;         
                }
                //potential pull foward
                if(trigger.new[i].Potential_Pull_Forward__c != trigger.old[i].Potential_Pull_Forward__c)
                {
                   trigger.new[i].Unapproved_Potential_Pull_Forward__c=trigger.old[i].Potential_Pull_Forward__c ;
                }
                if(((trigger.new[i].Potential_Pull_Forward__c==true && trigger.old[i].Potential_Pull_Forward__c == false) ||
                    trigger.new[i].Change_Of_Projected_Renewal__c <=-5 || 
                    trigger.new[i].Proj_Realization_Rate_ATTRF__c < 95 || 
                    (trigger.new[i].Is_Segmentation_Changed__c==true  && 
                     ((trigger.new[i].Segmentation__c=='MT' && trigger.new[i].Unapprove_Segmentation__c<>'LT') || 
                      (trigger.new[i].Segmentation__c=='LT' && trigger.new[i].Unapprove_Segmentation__c<>'MT') ||
                      (trigger.new[i].Unapprove_Segmentation__c=='MT' && !(trigger.new[i].Segmentation__c=='LT')) ||
                      (trigger.new[i].Unapprove_Segmentation__c=='LT' && !(trigger.new[i].Segmentation__c=='MT'))) )) && 
                   (trigger.new[i].Projected_Renewal_USD__c >= 200000 || 
                    (trigger.new[i].Unapproved_Projected_Renewal_amount__c / trigger.new[i].Renewal_Currency_Conversion_Rate__c) >= 200000))
                {
                    trigger.new[i].Approval_Process_Submitted_By__c=UserInfo.getUserId();
                }
                
            }
            System.debug(trigger.new+'<<<<<<<<<<<<<<Trigger New Renwal Data-------------Trigger Old Renewal Data'+trigger.old);
        }
       }
       catch(Exception e)
       {
           
       }
    }
    if(trigger.isAfter)
    {
        try{
        List<Renewal__c> renewal =new List<Renewal__c>();       
        renewal =[Select Id,Change_Of_Projected_Renewal__c,Proj_Realization_Rate_ATTRF__c ,Is_Rejected_Recalled__c,Renewal_Currency_Conversion_Rate__c,
                                    Potential_Pull_Forward__c,Unapproved_Potential_Pull_Forward__c,
                                    Projected_Renewal_USD__c,Projected_Renewal__c,Unapproved_Projected_Renewal_amount__c,
                                    Segmentation__c,Unapprove_Segmentation__c,Is_Segmentation_Changed__c,
                                    Projected_Time_Duration_Months__c,Unapproved_Duration_of_months__c
                  FROM Renewal__c 
                  WHERE Id IN :Trigger.New];
        for(Integer i=0;i<renewal.size();i++){
             System.debug('______________Anitha Test'+trigger.new[i].IsRecordLocked__c);                      
            // we are only interested in value above USD 200K
            if(trigger.new[i].IsRecordLocked__c==false && 
               (renewal[i].Projected_Renewal_USD__c >= 200000 || (renewal[i].Unapproved_Projected_Renewal_amount__c / renewal[i].Renewal_Currency_Conversion_Rate__c) >= 200000) &&
              !Renewals_Util.processedRenewals.contains(renewal[i].Id) 
              )
            {
                Renewals_Util.processedRenewals.add(renewal[i].Id);
                
                // HT approval process, no seg change
                if((renewal[i].Is_Segmentation_Changed__c==false && renewal[i].Segmentation__c=='HT') && 
                   (renewal[i].Change_Of_Projected_Renewal__c <=-5 || (renewal[i].Proj_Realization_Rate_ATTRF__c < 95 && renewal[i].Change_Of_Projected_Renewal__c <> 0) || 
                    (renewal[i].Potential_Pull_Forward__c==true &&  trigger.old[i].Potential_Pull_Forward__c == false ))  
                   )
                {        
                    Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();

                    // Potential Pull Forward
                    if(renewal[i].Potential_Pull_Forward__c==true && trigger.old[i].Potential_Pull_Forward__c == false)
                    {
                        // PPF and Chg <-5%
                        if(renewal[i].Change_Of_Projected_Renewal__c <=-5)
                            submitRequest.setComments('Submitted for HT approval with '+renewal[i].Change_Of_Projected_Renewal__c.setScale(2) +'% change in Annual Projected Renewal and Potential Pullforward Checked. Please Review and Approve.');

                        // PPF and Projected Realization Rate (ATTRF) < 95%
                        else if(renewal[i].Proj_Realization_Rate_ATTRF__c < 95)
                            submitRequest.setComments('Submitted for HT approval with '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF) and Potential Pullforward Checked. Please Review and Approve.');

                        // PPF Only
                        else
                            submitRequest.setComments('Submitted for HT approval with Potential Pullforward Checked. Please Review and Approve.');
                    }
                    // Not Potential Pull Forward
                    else
                    {
                        // Chg <-5%
                        if(renewal[i].Change_Of_Projected_Renewal__c <=-5)
                            submitRequest.setComments('Submitted for HT approval with '+renewal[i].Change_Of_Projected_Renewal__c.setScale(2) +'% change in Annual Projected Renewal. Please Review and Approve.');

                        // Projected Realization Rate (ATTRF) < 95%
                        else if(renewal[i].Proj_Realization_Rate_ATTRF__c < 95)
                            submitRequest.setComments('Submitted for HT approval with '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF). Please Review and Approve.');

                        // Catch-all
                        else
                            submitRequest.setComments('Submitted for HT approval. Please Review and Approve.');
                    }

                    submitRequest.setObjectId(renewal[i].Id);
                    submitRequest.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    Approval.ProcessResult result = Approval.process(submitRequest);
                }
                // MT/LT approval process, no seg change
                else if((renewal[i].Is_Segmentation_Changed__c==false && renewal[i].Segmentation__c!='HT') && 
                        (renewal[i].Change_Of_Projected_Renewal__c <=-5 || 
                         (renewal[i].Proj_Realization_Rate_ATTRF__c < 95 && renewal[i].Change_Of_Projected_Renewal__c <> 0) || //&& (trigger.old[i].Proj_Realization_Rate_ATTRF__c != trigger.new[i].Proj_Realization_Rate_ATTRF__c)) ||  
                         (renewal[i].Potential_Pull_Forward__c==true &&  trigger.old[i].Potential_Pull_Forward__c == false )))
                {        
                    Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();

                    // Potential Pull Forward
                    if(renewal[i].Potential_Pull_Forward__c==true && trigger.old[i].Potential_Pull_Forward__c == false)
                    {
                        // PPF and Chg <-5%
                        if(renewal[i].Change_Of_Projected_Renewal__c <=-5)
                            submitRequest.setComments('Submitted for MT/LT approval with '+renewal[i].Change_Of_Projected_Renewal__c.setScale(2) +'% change in Annual Projected Renewal and Potential Pullforward Checked. Please Review and Approve.');

                        // PPF and Projected Realization Rate (ATTRF) < 95%
                        else if(renewal[i].Proj_Realization_Rate_ATTRF__c < 95)
                            submitRequest.setComments('Submitted for MT/LT approval with '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF) and Potential Pullforward Checked. Please Review and Approve.');

                        // PPF Only
                        else
                            submitRequest.setComments('Submitted for MT/LT approval with Potential Pullforward Checked. Please Review and Approve.');
                    }
                    // Not Potential Pull Forward
                    else
                    {
                        // Chg <-5%
                        if(renewal[i].Change_Of_Projected_Renewal__c <=-5)
                            submitRequest.setComments('Submitted for MT/LT approval with '+renewal[i].Change_Of_Projected_Renewal__c.setScale(2) +'% change in Annual Projected Renewal. Please Review and Approve.');

                        // Projected Realization Rate (ATTRF) < 95%
                        else if(renewal[i].Proj_Realization_Rate_ATTRF__c < 95)
                            submitRequest.setComments('Submitted for MT/LT approval with '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF). Please Review and Approve.');

                        // Catch-all
                        else
                            submitRequest.setComments('Submitted for MT/LT approval. Please Review and Approve.');
                    }

                    submitRequest.setObjectId(renewal[i].Id);
                    submitRequest.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    Approval.ProcessResult result = Approval.process(submitRequest);
                }
                // Segmentation change
                else if(renewal[i].Is_Segmentation_Changed__c==true && 
                        ((renewal[i].Segmentation__c=='MT' && renewal[i].Unapprove_Segmentation__c<>'LT') || 
                         (renewal[i].Segmentation__c=='LT' && renewal[i].Unapprove_Segmentation__c<>'MT') ||
                         (renewal[i].Unapprove_Segmentation__c=='MT' && !(renewal[i].Segmentation__c=='LT')) ||
                         (renewal[i].Unapprove_Segmentation__c=='LT' && !(renewal[i].Segmentation__c=='MT'))) )
                {        
                    Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();

                    // Potential Pull Forward
                    if(renewal[i].Potential_Pull_Forward__c==true && trigger.old[i].Potential_Pull_Forward__c == false)
                    {
                        // PPF and Chg <-5%
                        if(renewal[i].Change_Of_Projected_Renewal__c <=-5)
                            submitRequest.setComments('Submitted for approval for Segmentation Change from '+trigger.old[i].Segmentation__c +' to '+renewal[i].Segmentation__c+', '+renewal[i].Change_Of_Projected_Renewal__c.setScale(2) +'% change in Annual Projected Renewal, and Potential Pullforward Checked. Please Review and Approve.');

                        // PPF and Projected Realization Rate (ATTRF) < 95%
                        else if(renewal[i].Proj_Realization_Rate_ATTRF__c < 95)
                            submitRequest.setComments('Submitted for approval for Segmentation Change from '+trigger.old[i].Segmentation__c +' to '+renewal[i].Segmentation__c+', '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF), and Potential Pullforward Checked. Please Review and Approve.');

                        // PPF Only
                        else
                            submitRequest.setComments('Submitted for approval for Segmentation Change from '+trigger.old[i].Segmentation__c +' to '+renewal[i].Segmentation__c+' and Potential Pullforward Checked. Please Review and Approve.');
                    }
                    // Not Potential Pull Forward
                    else
                    {
                        // Chg <-5%
                        if(renewal[i].Change_Of_Projected_Renewal__c <=-5)
                            submitRequest.setComments('Submitted for approval for Segmentation Change from '+trigger.old[i].Segmentation__c +' to '+renewal[i].Segmentation__c+' and '+renewal[i].Change_Of_Projected_Renewal__c.setScale(2) +'% change in Annual Projected Renewal. Please Review and Approve.');

                        // Projected Realization Rate (ATTRF) < 95%
                        else if(renewal[i].Proj_Realization_Rate_ATTRF__c < 95)
                        {
                            submitRequest.setComments('Submitted for approval for Segmentation Change from '+trigger.old[i].Segmentation__c +' to '+renewal[i].Segmentation__c+' and '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF). Please Review and Approve.');
                            submitRequest.setComments('Submitted for MT/LT approval with '+renewal[i].Proj_Realization_Rate_ATTRF__c.setScale(2) +'% Projected Realization Rate (ATTRF). Please Review and Approve.');
                        }                         
                        // Catch-all
                        else
                            submitRequest.setComments('Submitted for approval for Segmentation Change from '+trigger.old[i].Segmentation__c +' to '+renewal[i].Segmentation__c+'. Please Review and Approve.');
                    }

                    submitRequest.setObjectId(renewal[i].Id);
                    submitRequest.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    Approval.ProcessResult result = Approval.process(submitRequest);
                }
                System.debug('_______Inside Of If Record Locjed');
            }
            System.debug('_______Out Of If Record Locjed');
        }
        
        
        }
        catch(Exception e)
        {
            
        }                
    }
}
}