trigger aiau_UpdateHVNFields on HVN_Touchpoint__c (after insert, after update, after delete) {
    HVN_Touchpoint__c tpntNew = new HVN_Touchpoint__c(); 
    if(Trigger.isDelete)
        tpntNew = Trigger.old[0];
    else
        tpntNew = Trigger.new[0];
            
//    for(HVN_Touchpoint__c tpntNew:Trigger.new){
        if(tpntNew!=null){
            List<HVN_Touchpoint__c> tpntList = [select HVN_Contact__c,Contacted_by__c,Touch_Point__c,Date__c from HVN_Touchpoint__c where HVN_Contact__c=:tpntNew.HVN_Contact__c order by Date__c desc limit 1];

            //check if touchpoints exists
            if(!tpntList.isEmpty()){  

                HVN_Touchpoint__c tpnt = tpntList[0];
                if(tpnt.HVN_Contact__c !=null){
                    HVN__c hvn = [select Id,Last_Touchpoint__c,Last_Touchpoint_Date__c,Last_Touchpoint_Contact_by__c from HVN__c where id=:tpnt.HVN_Contact__c];
                    if(hvn!=null){
                        hvn.Last_Touchpoint__c = tpnt.Touch_Point__c;
                        hvn.Last_Touchpoint_Date__c = tpnt.Date__c;
                        if(tpnt.Contacted_by__c!=null){
                            String contactedBy = [Select Name from User where id=:tpnt.Contacted_by__c].Name;
                            if(contactedBy!=null && contactedBy!='')
                                hvn.Last_Touchpoint_Contact_by__c = contactedBy;
                        }else{
                            hvn.Last_Touchpoint_Contact_by__c = '';
                        }
                        hvn.Next_Touchpoint_2__c = tpnt.Date__c + 30;
                        try{
                        update hvn;
                        }catch(Exception e){}
                    }
                }

            }else{

                //set hvn fields to blank if there are no touchpoints
                if(tpntNew.HVN_Contact__c !=null){
                    HVN__c hvn = [select Id,Last_Touchpoint__c,Last_Touchpoint_Date__c,Last_Touchpoint_Contact_by__c from HVN__c where id=:tpntNew.HVN_Contact__c];
                    if(hvn!=null){
                        hvn.Last_Touchpoint__c = null;
                        hvn.Last_Touchpoint_Date__c = null;
                        hvn.Last_Touchpoint_Contact_by__c = null;
                        hvn.Next_Touchpoint_2__c = null;
                        try{
                        update hvn;
                        }catch(Exception e){}
                    }
                }
                
            }
        }
//    }
}