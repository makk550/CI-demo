trigger BPTaqUpdate on Business_Plan_New__c (after update) 
{
    for(Business_Plan_New__c bp : Trigger.new)
    {
        if(Trigger.oldmap.get(bp.Id).Status__c != 'Approved' && bp.Status__c == 'Approved')
        {
            Account myAccount = [Select Id,Alliance__c,Service_Provider__c,Solution_Provider__c,Velocity_Seller__c from Account where Id=:bp.Account__c][0];
            
            TAQ_Account__c taqAccount = [Select Id, Alliance__c, Alliance_Designation__c, Alliance_CAM_PMFKey__c,
                     Alliance_Program_Level__c, Alliance_Type__c, Velocity_Seller__c, Velocity_Seller_Designation__c,
                     Velocity_Seller_CAM_PMFKey__c, Velocity_Seller_Program_Level__c, Velocity_Seller_Type__c, 
                     Service_Provider__c, Service_Provider_Designation__c, Service_Provider_CAM_PMFKey__c, Service_Provider_Program_Level__c,
                     Service_Provider_Type__c, Solution_Provider__c, Solution_Provider_Designation__c, Solution_Provider_CAM_PMFKey__c,
                     Solution_Provider_Program_Level__c, Solution_Provider_Type__c, Primary_RTM_Alliance__c, Primary_RTM_Data_Management__c,
                     Primary_RTM_Service_Provider__c, Primary_RTM_Solution_Provider__c  from TAQ_Account__c where View_Acc_Record__c=:myAccount.Id and Process_Step__c!='Account Merge'][0];
            //added and Process_Step__c!='Account Merge' to identify the Merged TAQ Account
                     
            User CABPOwner = [Select PMFKey__c from User where Id=:bp.CA_Business_Plan_Owner__c][0];
            String pmfKey = CABPOwner.PMFKey__c;

            if(taqAccount.Alliance__c != bp.Alliance__c)
            {
                if(bp.Alliance__c)
                {
                    taqAccount.Alliance_CAM_PMFKey__c = pmfKey;
                }
                else
                {
                    taqAccount.Alliance_CAM_PMFKey__c = '';
                }
            }   
            
            if(taqAccount.Velocity_Seller__c != bp.Data_Management__c)
            {
                if(bp.Data_Management__c)
                {
                    taqAccount.Velocity_Seller_CAM_PMFKey__c = pmfKey;
                }
                else
                {
                    taqAccount.Velocity_Seller_CAM_PMFKey__c = '';
                }
            } 
            
            if(taqAccount.Service_Provider__c != bp.Service_Provider__c)
            {
                if(bp.Service_Provider__c)
                {
                    taqAccount.Service_Provider_CAM_PMFKey__c = pmfKey;
                }
                else
                {
                   taqAccount.Service_Provider_CAM_PMFKey__c = ''; 
                }
            } 
            
            if(taqAccount.Solution_Provider__c != bp.Solution_Provider__c)
            {
                if(bp.Solution_Provider__c)
                {
                    taqAccount.Solution_Provider_CAM_PMFKey__c = pmfKey;
                }
                else
                {
                    taqAccount.Solution_Provider_CAM_PMFKey__c = '';
                }
            } 
                     
            taqAccount.Physical_Zip_Postal_Code__c = bp.Account_Billing_Zip__c; 
            taqAccount.Physical_Street__c = bp.Account_Billing_Street__c; 
            taqAccount.Physical_State_Province__c = bp.Account_Billing_State__c; 
            taqAccount.Physical_City__c = bp.Account_Billing_City__c;
            taqAccount.Website__c=bp.Website__c;            
            taqAccount.Update_from_BP__c = 'Y';
            taqAccount.Alliance__c = bp.Alliance__c;
            taqAccount.Alliance_Designation__c = bp.Alliance_Designation__c;
            taqAccount.Alliance_Program_Level__c = bp.Alliance_Program_Level__c;
            taqAccount.Alliance_Type__c = bp.Alliance_Type__c;
            taqAccount.Velocity_Seller__c = bp.Data_Management__c;
            taqAccount.Velocity_Seller_Designation__c = bp.DM_Designation__c;
            taqAccount.Velocity_Seller_Program_Level__c = bp.DM_Program_Level__c;
            taqAccount.Velocity_Seller_Type__c = bp.DM_Type__c;
            taqAccount.Service_Provider__c = bp.Service_Provider__c;
            taqAccount.Service_Provider_Designation__c = bp.Service_Provider_Designation__c;
            taqAccount.Service_Provider_Program_Level__c = bp.Service_Provider_Program_Level__c;
            taqAccount.Service_Provider_Type__c = bp.Service_Provider_Type__c;
            taqAccount.Solution_Provider__c = bp.Solution_Provider__c;
            taqAccount.Solution_Provider_Designation__c = bp.Solution_Provider_Designation__c;
            taqAccount.Solution_Provider_Program_Level__c = bp.Solution_Provider_Program_Level__c;
            taqAccount.Solution_Provider_Type__c = bp.Solution_Provider_Type__c;  
            taqAccount.Primary_RTM_Alliance__c = bp.Primary_RTM_Alliance__c;
            taqAccount.Primary_RTM_Service_Provider__c = bp.Primary_RTM_Servide_Provider__c;
            taqAccount.Primary_RTM_Solution_Provider__c = bp.Primary_RTM_Solution_Provider__c;
            taqAccount.Primary_RTM_Data_Management__c = bp.Primary_RTM_DM__c;       
            
                                    
            taqAccount.Process_Step__c = 'Account Update';  
            taqAccount.Approval_Process_Status__c = 'Send For Approval';     
            
            System.debug('TAQ Account before update : ' + taqAccount);
            
            update taqAccount;    

        }
    }
}