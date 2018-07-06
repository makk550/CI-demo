/**
*Description :Class to handle Enabled Partner Accounts functionality.
*Method enableTechPartnerAccounts  , with List of TAQ_Account__c as input
*SOQl: 1
* DML Updates: 1
*Client: CA technologies
*Developed By:  Heena bhatnagar Nov 15,2010
*Last Updated On Nov 26,2010
*/
public class CA_TAQ_EnablePartnerAccounts {
    /*
     * on Approval of a Partner TAQ Account for Request type Account Add enables 
     * the corresponding Partner Account for Partner Portal
     */
    public void enableTechPartnerAccounts(List<TAQ_Account__c> TAQAcc,Map<id,TAQ_Account__c> TAQAcc_Old){ 
        Set<String> ids= new Set<String>();
        //FY13 - List<Account> accList=new List<Account>();
    Set<String> stpmfkey=new set<String>();
        
        for(TAQ_Account__c TAQAcc_New:TAQAcc)
        {

                     stpmfkey.add(TAQAcc_New.View_Acc_Record__c);        
                     //FY13 - accList = [Select a.SLED_Area__c,a.Account_Owner_Name__c, a.Id from Account a  where id =: stpmfkey ];
                     /* //FY13 -    start
                      if (accList.size() > 0)
                      {
                         accList[0].SLED_Area__c = TAQAcc_New.sled_Area__c ;
                         Update accList;
                      }    
                    //FY13 - end */
               //system.debug('TAQ Record='+TAQAcc);
              // system.debug('current user '+userinfo.getUserid() + 'systemutility=' +SystemIdUtility.getSFDCDATA_USER_ID());
               if((TAQAcc_New.View_Acc_Record__c!=TAQAcc_Old.get(TAQAcc_new.id).View_Acc_Record__c && TAQAcc_Old.get(TAQAcc_new.id).View_Acc_Record__c==null)
                && ( TAQAcc_New.Approval_Status__c=='Approved' || TAQAcc_New.Approval_Process_Status__c=='Approved' || TAQAcc_New.Approval_Process_Status__c=='Approved-Updated')
                && TAQAcc_New.Process_Step__c=='Account Add'
                && (TAQAcc_New.recordtypeid==Label.TAQ_Partner_Recordtype))
                {               
                ids.add(TAQAcc_New.View_Acc_Record__c);
                }
                
                else if((userinfo.getUserid()==SystemIdUtility.getSFDCDATA_USER_ID())
                && ( TAQAcc_New.Approval_Status__c=='Approved' || TAQAcc_New.Approval_Process_Status__c=='Approved' || TAQAcc_New.Approval_Process_Status__c=='Approved-Updated')
                && (TAQAcc_New.Process_Step__c=='Account Update' || TAQAcc_New.Process_Step__c=='Account Add')
                && (TAQAcc_New.recordtypeid==Label.TAQ_Partner_Recordtype))
                {               
                ids.add(TAQAcc_New.View_Acc_Record__c);
                }
        } 
        //System.debug('ids of TAQ Account view acc record='+ids);
        if(ids.size()>0){
            list<Account> partnerAcc=[select ispartner,id,name from Account where id in:ids and ispartner=false];         
            for(Account a: partnerAcc){    
                a.ispartner=true;    
            }        
            if(partnerAcc.size()>0)
                update partnerAcc; 
       }        
    }    

}