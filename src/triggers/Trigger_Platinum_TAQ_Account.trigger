trigger Trigger_Platinum_TAQ_Account on TAQ_Account__c (before Update) {

/* US483878 LEEAN04 5-22-2018 trigger Trigger_Platinum_TAQ_Account on TAQ_Account__c (before insert,before Update) { //US483878 LEEAN04 5-22-2018 */
 
    
    set<id> taqaccid = new set<id>();

    if(trigger.isUpdate){
        for(TAQ_Account__c taq:trigger.new){
            //sunji03 - FY19 Account Segment change, T1 becomes Platinum and Gold
            //if(taq.segment__c == Label.SegmentVal1 && taq.RecordTypeId=='01230000000cogU')  {
            if((taq.segment__c == Label.SegmentVal1 || taq.segment__c == Label.SegmentVal4) && taq.RecordTypeId=='01230000000cogU')  {
                taqaccid.add(taq.id);
            }
        }
            
        if(taqaccid.size()!=0&&taqaccid!=null){
        
            List<TAQ_Account_Team__c> taqAccTeamRecs = [select TAQ_Account__c,PMFKey__c,Is_Account_Owner__c from TAQ_Account_Team__c where TAQ_Account__c IN: taqaccid];
              
            Map<Id,Integer> TAQId_TAQAccountTeamSize_map = new Map<Id,Integer>();
            for(TAQ_Account_Team__c TAT:taqAccTeamRecs){       
                if(!TAQId_TAQAccountTeamSize_map.containsKey(TAT.TAQ_Account__c)){
                    TAQId_TAQAccountTeamSize_map.put(TAT.TAQ_Account__c,1);
                }else{
                    TAQId_TAQAccountTeamSize_map.put(TAT.TAQ_Account__c,TAQId_TAQAccountTeamSize_map.get(TAT.TAQ_Account__c)+1);
                }
            }
            
            /* US483878 LEEAN04 5-22-2018
            
            for(TAQ_Account__c ta:trigger.new){
                //sunji03 - FY19 Account Segment change, T1 becomes Platinum and Gold
                //if(ta.segment__c == Label.SegmentVal1 && ta.RecordTypeId=='01230000000cogU')
                if((ta.segment__c == Label.SegmentVal1 || ta.segment__c == Label.SegmentVal4) && ta.RecordTypeId=='01230000000cogU')
                {
                        System.debug('Platinum TAQ ID :: ' + ta.Id + ' :: Approval Process Status :: ' + ta.Approval_Process_Status__c + ' :: Approval Status 2 :: ' + ta.Approval_Status__c);
                     if((ta.Approval_Process_Status__c =='Send For Approval' ||
                         (ta.Approval_Process_Status__c == null && ta.Approval_Status__c == 'Send For Approval') ||
                         (ta.Approval_Process_Status__c == null && ta.Approval_Status__c == 'Approved') || 
                         ta.Approval_Process_Status__c =='Approved') && !TAQId_TAQAccountTeamSize_map.containsKey(ta.Id))
                     {
                        ta.addError('TAQ Account should have at least one TAQ Account Team with an account owner');
                     }
                }
            }
            
            US483878 LEEAN04 5-22-2018 */ 
       } 
    }
   
   
 }

/* US483878 LEEAN04 5-22-2018

    if(trigger.isInsert){
        for(TAQ_Account__c ta:trigger.new){

US483878 LEEAN04 5-22-2018 */
      
/*         if((ta.Approval_Process_Status__c =='Send For Approval' || ta.Approval_Process_Status__c =='Approved') && ta.Segment__c=='Platinum' && ta.RecordTypeId=='01230000000cogU'){
                  ta.addError('TAQ Account should have at least one TAQ Account Team with an account owner');
         }*/
        //sunji03 - FY19 Account Segment change, T1 becomes Platinum and Gold
       //if(ta.segment__c == Label.SegmentVal1 && ta.RecordTypeId=='01230000000cogU')
       
/* US483878 LEEAN04 5-22-2018
 
        if((ta.segment__c == Label.SegmentVal1 || ta.segment__c == Label.SegmentVal4) && ta.RecordTypeId=='01230000000cogU')
        {
                System.debug('Insert Platinum TAQ ID :: ' + ta.Id + ' :: Approval Process Status :: ' + ta.Approval_Process_Status__c + ' :: Approval Status 2 :: ' + ta.Approval_Status__c);
             if((ta.Approval_Process_Status__c =='Send For Approval' ||
                 (ta.Approval_Process_Status__c == null && ta.Approval_Status__c == 'Send For Approval') ||
                 (ta.Approval_Process_Status__c == null && ta.Approval_Status__c == 'Approved') || 
                 ta.Approval_Process_Status__c =='Approved'))
             {
                ta.addError('TAQ Account should have at least one TAQ Account Team with an account owner');
             }
        }
    }
        
        }
 

//US483878 LEEAN04 5-22-2018 */