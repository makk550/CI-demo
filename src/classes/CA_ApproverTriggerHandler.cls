/** * File Name: CA_ApproverTriggerHandler
* Description : Handler class for Apex Trigger "CA_ApproverTrigger".
* * @author : Garima Shukla
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
public Class CA_ApproverTriggerHandler{

    public void setApprovers(List<Approver__c> newAppList){
        try {
            Set<Id> agrId = new Set<Id>();
            Map<Id, List<Approver__c>> mapAppList = new Map<Id,List<Approver__c>>();
            List<Apttus__APTS_Agreement__c> updateAgreementsList = new List<Apttus__APTS_Agreement__c>();
            List<Approver__c> appList = new List<Approver__c>();
            integer Level1Count = 0;
            integer Level2Count = 0;
            integer Level3Count = 0;
            integer Level4Count = 0;
            integer level = 0;
            
            if(trigger.isAfter) {
                
                for(Approver__c app : newAppList) {
                    
                    if(!agrId.contains(app.CA_Agreement__c))    
                        agrId.add(app.CA_Agreement__c);   
                    
                    if(mapAppList.containsKey(app.CA_Agreement__c)) {
                        appList = mapAppList.get(app.CA_Agreement__c);
                        appList.add(app);
                        mapAppList.put(app.CA_Agreement__c,appList);
                    } else {
                        appList = new List<Approver__c>();
                        appList.add(app);
                        mapAppList.put(app.CA_Agreement__c,appList);
                    }
                }
                
                List<Approver__c> apprList = [Select Id, CA_Level__c from Approver__c where CA_Agreement__c IN: agrId];
                
                if(apprList.size() > 0) {
                    for(Approver__c app : apprList) {
                        if(app.CA_Level__c == '1')
                            Level1Count++;
                        if(app.CA_Level__c == '2')
                            Level2Count++;
                        if(app.CA_Level__c == '3')
                            Level3Count++;
                        if(app.CA_Level__c == '4')
                            Level4Count++;
                    }
                }
                system.debug('Count 1:::'+Level1Count);
                system.debug('Count 2:::'+Level2Count);
                system.debug('Count 3:::'+Level3Count);
                system.debug('Count 4:::'+Level4Count);
                if(Level1Count == 2 || Level2Count == 2 || Level3Count == 2 || Level4Count == 2)
                    throw new TriggerException(Label.Same_Level_Approver_Error_Message);
                
                if((Level1Count == 0 && (Level2Count>0 || Level3Count>0 || Level4Count >0)) || (Level2Count == 0 && (Level3Count>0 || Level4Count >0)) || (Level3Count == 0 &&  Level4Count >0))
                    throw new TriggerException(Label.Approver_Level_Error_Message);
                
                List<Apttus__APTS_Agreement__c> agrList = [Select Id,Agreement_Approver__c,Agreement_Approver2__c, Agreement_Approver3__c, Agreement_Approver4__c, Agreement_Approver1_L2__c, Agreement_Approver2_L2__c, Agreement_Approver3_L2__c, Agreement_Approver4_L2__c,Agreement_Approver1_L3__c, Agreement_Approver2_L3__c, Agreement_Approver3_L3__c, Agreement_Approver4_L3__c,Agreement_Approver1_L4__c, Agreement_Approver2_L4__c, Agreement_Approver3_L4__c, Agreement_Approver4_L4__c, CA_L1_Approver_Count__c, CA_L2_Approver_Count__c, CA_L3_Approver_Count__c, CA_L4_Approver_Count__c,CA_Level__c from Apttus__APTS_Agreement__c where Id IN: agrId];
                
                for(Approver__c apr : apprList) {
                    if(integer.valueof(apr.CA_Level__c) > level && apr.CA_Level__c == '1') 
                        level = 1;
                    if(integer.valueof(apr.CA_Level__c) > level && apr.CA_Level__c == '2')
                        level = 2;
                    if(integer.valueof(apr.CA_Level__c) > level && apr.CA_Level__c == '3') 
                        level = 3;
                    if(integer.valueof(apr.CA_Level__c) > level && apr.CA_Level__c == '4')
                        level = 4;
                }
                
                for(Apttus__APTS_Agreement__c agr: agrList) {
                    if(mapAppList.containsKey(agr.Id)){
                        for(Approver__c appr : mapAppList.get(agr.Id)) {
                            if(appr.CA_Level__c == '1') {
                                if(appr.CA_Approver_1__c != null) {
                                    agr.Agreement_Approver__c = appr.CA_Approver_1__c;
                                    agr.L1_Approver1_Comments__c = appr.CA_Approver_1_Comments__c;
                                    agr.CA_L1_Approver_Count__c = 1;
                                }
                                if(appr.CA_Approver_2__c != null) {    
                                    agr.Agreement_Approver2__c = appr.CA_Approver_2__c;
                                    agr.L1_Approver2_Comments__c = appr.CA_Approver_2_Comments__c;
                                    agr.CA_L1_Approver_Count__c = 2;
                                } else {
                                    agr.Agreement_Approver2__c = null;
                                    agr.L1_Approver2_Comments__c = null;
                                }
                                if(appr.CA_Approver_3__c != null) {
                                    agr.Agreement_Approver3__c = appr.CA_Approver_3__c;
                                    agr.L1_Approver3_Comments__c = appr.CA_Approver_3_Comments__c;
                                    agr.CA_L1_Approver_Count__c = 3;
                                } else {
                                    agr.Agreement_Approver3__c = null;
                                    agr.L1_Approver3_Comments__c = null;
                                }
                                if(appr.CA_Approver_4__c != null) {
                                    agr.Agreement_Approver4__c = appr.CA_Approver_4__c;
                                    agr.L1_Approver4_Comments__c = appr.CA_Approver_4_Comments__c;
                                    agr.CA_L1_Approver_Count__c = 4;
                                } else {
                                    agr.Agreement_Approver4__c = null;
                                    agr.L1_Approver4_Comments__c = null;
                                } 
                                if(agr.CA_Level__c == null || agr.CA_Level__c < 1)
                                    agr.CA_Level__c = 1;  
                                
                            }
                            if(appr.CA_Level__c == '2') {
                                if(appr.CA_Approver_1__c != null) {
                                    agr.Agreement_Approver1_L2__c = appr.CA_Approver_1__c;
                                    agr.L2_Approver1_Comments__c = appr.CA_Approver_1_Comments__c;
                                    agr.CA_L2_Approver_Count__c = 1;    
                                }
                                
                                if(appr.CA_Approver_2__c != null) {
                                    agr.Agreement_Approver2_L2__c = appr.CA_Approver_2__c;
                                    agr.L2_Approver2_Comments__c = appr.CA_Approver_2_Comments__c;
                                    agr.CA_L2_Approver_Count__c = 2;
                                } else {
                                    agr.Agreement_Approver2_L2__c = null;
                                    agr.L2_Approver2_Comments__c = null;
                                }
                                
                                if(appr.CA_Approver_3__c != null) {
                                    agr.Agreement_Approver3_L2__c = appr.CA_Approver_3__c;
                                    agr.L2_Approver3_Comments__c = appr.CA_Approver_3_Comments__c;
                                    agr.CA_L2_Approver_Count__c = 3;
                                } else {
                                    agr.Agreement_Approver3_L2__c = null;
                                    agr.L2_Approver3_Comments__c = null;
                                }
                                
                                if(appr.CA_Approver_4__c != null) {
                                    agr.Agreement_Approver4_L2__c = appr.CA_Approver_4__c;
                                    agr.L2_Approver4_Comments__c = appr.CA_Approver_4_Comments__c;
                                    agr.CA_L2_Approver_Count__c = 4;
                                } else {
                                    agr.Agreement_Approver4_L2__c = null;
                                    agr.L2_Approver4_Comments__c = null;
                                }
                                if(agr.CA_Level__c == null || agr.CA_Level__c < 2)
                                    agr.CA_Level__c = 2;  
                                
                            }
                            if(appr.CA_Level__c == '3') {
                                if(appr.CA_Approver_1__c != null) {
                                    agr.Agreement_Approver1_L3__c = appr.CA_Approver_1__c;
                                    agr.L3_Approver1_Comments__c = appr.CA_Approver_1_Comments__c;
                                    agr.CA_L3_Approver_Count__c = 1;
                                }
                                if(appr.CA_Approver_2__c != null) {
                                    agr.Agreement_Approver2_L3__c = appr.CA_Approver_2__c;
                                    agr.L3_Approver2_Comments__c = appr.CA_Approver_2_Comments__c;
                                    agr.CA_L3_Approver_Count__c = 2;
                                } else {
                                    agr.Agreement_Approver2_L3__c = null;
                                    agr.L3_Approver2_Comments__c = null;
                                }
                                if(appr.CA_Approver_3__c != null) {
                                    agr.Agreement_Approver3_L3__c = appr.CA_Approver_3__c;
                                    agr.L3_Approver3_Comments__c = appr.CA_Approver_3_Comments__c;
                                    agr.CA_L3_Approver_Count__c = 3;
                                } else {
                                    agr.Agreement_Approver3_L3__c = null;
                                    agr.L3_Approver3_Comments__c = null;
                                }
                                if(appr.CA_Approver_4__c != null) {
                                    agr.Agreement_Approver4_L3__c = appr.CA_Approver_4__c;
                                    agr.L3_Approver4_Comments__c = appr.CA_Approver_4_Comments__c;
                                    agr.CA_L3_Approver_Count__c = 4;
                                } else {
                                    agr.Agreement_Approver4_L3__c = null;
                                    agr.L3_Approver4_Comments__c = null;
                                }
                                if(agr.CA_Level__c == null || agr.CA_Level__c < 3)
                                    agr.CA_Level__c = 3;  
                            }
                            if(appr.CA_Level__c == '4') {
                                if(appr.CA_Approver_1__c != null) {
                                    agr.Agreement_Approver1_L4__c = appr.CA_Approver_1__c;
                                    agr.L4_Approver1_Comments__c = appr.CA_Approver_1_Comments__c;
                                    agr.CA_L4_Approver_Count__c = 1;
                                }
                                if(appr.CA_Approver_2__c != null) {
                                    agr.Agreement_Approver2_L4__c = appr.CA_Approver_2__c;
                                    agr.L4_Approver2_Comments__c = appr.CA_Approver_2_Comments__c;
                                    agr.CA_L4_Approver_Count__c = 2;
                                } else {
                                    agr.Agreement_Approver2_L4__c = null;
                                    agr.L4_Approver2_Comments__c = null;
                                }
                                if(appr.CA_Approver_3__c != null) {
                                    agr.Agreement_Approver3_L4__c = appr.CA_Approver_3__c;
                                    agr.L4_Approver3_Comments__c = appr.CA_Approver_3_Comments__c;
                                    agr.CA_L4_Approver_Count__c = 3;
                                } else {
                                    agr.Agreement_Approver3_L4__c = null;
                                    agr.L4_Approver3_Comments__c = null;
                                }
                                if(appr.CA_Approver_4__c != null) {
                                    agr.Agreement_Approver4_L4__c = appr.CA_Approver_4__c;
                                    agr.L4_Approver4_Comments__c = appr.CA_Approver_4_Comments__c;
                                    agr.CA_L4_Approver_Count__c = 4;
                                } else {
                                    agr.Agreement_Approver4_L4__c = null;
                                    agr.L4_Approver4_Comments__c = null;
                                }
                                if(agr.CA_Level__c == null || agr.CA_Level__c < 4)
                                    agr.CA_Level__c = 4;  
                            }
                        }
                        //system.debug('Level Value:::'+level);
                        //agr.CA_Level__c = 5;
                        //system.debug('Level Value:::'+agr.CA_Level__c);
                        updateAgreementsList.add(agr);
                    }
                }
            
            }
            if(updateAgreementsList.size()>0)
                update updateAgreementsList;
        }catch(Exception e) {
            for(Approver__c app : newAppList){
                app.addError(e.getMessage());
            }
            //throw new TriggerException(e.getMessage());
        }    
    
    }
    
    //Update Approvers on Agreement object on deletion
    public static void updateApproversonAgreement (List<Approver__c> apprList) {
        try {
            system.debug('update Approvers on Agreement - old list::::'+apprList);
            Map<Id,List<Approver__c>> mapIdvsApprover = new Map<Id,List<Approver__c>>();
            List<Approver__c> appList = new List<Approver__c>();
            
            for(Approver__c app : apprList) {
                if(mapIdvsApprover.containsKey(app.CA_Agreement__c)) {
                    appList = mapIdvsApprover.get(app.CA_Agreement__c);
                    appList.add(app);
                    mapIdvsApprover.put(app.CA_Agreement__c,appList);
                } else {
                    appList = new List<Approver__c>();
                    appList.add(app);
                    mapIdvsApprover.put(app.CA_Agreement__c,appList);
                }
            }
            
            List<Apttus__APTS_Agreement__c> agreementList = [Select Id,Agreement_Approver__c,Agreement_Approver2__c, Agreement_Approver3__c, Agreement_Approver4__c, Agreement_Approver1_L2__c, Agreement_Approver2_L2__c, Agreement_Approver3_L2__c, Agreement_Approver4_L2__c,Agreement_Approver1_L3__c, Agreement_Approver2_L3__c, Agreement_Approver3_L3__c, Agreement_Approver4_L3__c,Agreement_Approver1_L4__c, Agreement_Approver2_L4__c, Agreement_Approver3_L4__c, Agreement_Approver4_L4__c, L1_Approver1_Comments__c, L1_Approver2_Comments__c, L1_Approver3_Comments__c, L1_Approver4_Comments__c, L2_Approver1_Comments__c, L2_Approver2_Comments__c, L2_Approver3_Comments__c, L2_Approver4_Comments__c, L3_Approver1_Comments__c, L3_Approver2_Comments__c, L3_Approver3_Comments__c, L3_Approver4_Comments__c, L4_Approver1_Comments__c, L4_Approver2_Comments__c, L4_Approver3_Comments__c, L4_Approver4_Comments__c, CA_L1_Approver_Count__c, CA_L2_Approver_Count__c, CA_L3_Approver_Count__c, CA_L4_Approver_Count__c,CA_Level__c from Apttus__APTS_Agreement__c where Id IN: mapIdvsApprover.keySet()];
            
            List<Apttus__APTS_Agreement__c> updateAgrList = new List<Apttus__APTS_Agreement__c>();
            
            system.debug('Agreement list:::'+agreementList);
            for(Apttus__APTS_Agreement__c agr : agreementList) {
                if(mapIdvsApprover.containsKey(agr.Id)) {
                    for(Approver__c app : mapIdvsApprover.get(agr.Id)) {
                        if(app.CA_Level__c == '1') {
                            agr.Agreement_Approver__c = null;
                            agr.Agreement_Approver2__c = null;
                            agr.Agreement_Approver3__c = null; 
                            agr.Agreement_Approver4__c = null;
                            agr.L1_Approver1_Comments__c = '';
                            agr.L1_Approver2_Comments__c = '';
                            agr.L1_Approver3_Comments__c = '';
                            agr.L1_Approver4_Comments__c = '';
                            agr.CA_L1_Approver_Count__c = 0;
                        }
                        
                        if(app.CA_Level__c == '2') {
                            agr.Agreement_Approver1_L2__c = null;
                            agr.Agreement_Approver2_L2__c = null;
                            agr.Agreement_Approver3_L2__c = null; 
                            agr.Agreement_Approver4_L2__c = null;
                            agr.L2_Approver1_Comments__c = '';
                            agr.L2_Approver2_Comments__c = '';
                            agr.L2_Approver3_Comments__c = '';
                            agr.L2_Approver4_Comments__c = '';
                            agr.CA_L2_Approver_Count__c = 0;
                        }
                        
                        if(app.CA_Level__c == '3') {
                            agr.Agreement_Approver1_L3__c = null;
                            agr.Agreement_Approver2_L3__c = null;
                            agr.Agreement_Approver3_L3__c = null; 
                            agr.Agreement_Approver4_L3__c = null;
                            agr.L3_Approver1_Comments__c = '';
                            agr.L3_Approver2_Comments__c = '';
                            agr.L3_Approver3_Comments__c = '';
                            agr.L3_Approver4_Comments__c = '';
                            agr.CA_L3_Approver_Count__c = 0;
                        }
                        
                        if(app.CA_Level__c == '4') {
                            agr.Agreement_Approver1_L4__c = null;
                            agr.Agreement_Approver2_L4__c = null;
                            agr.Agreement_Approver3_L4__c = null; 
                            agr.Agreement_Approver4_L4__c = null;
                            agr.L4_Approver1_Comments__c = '';
                            agr.L4_Approver2_Comments__c = '';
                            agr.L4_Approver3_Comments__c = '';
                            agr.L4_Approver4_Comments__c = '';
                            agr.CA_L4_Approver_Count__c = 0;
                        }
                        agr.CA_Level__c = 0;
                        agr.CA_Remove_All_Original_Approvers__c = false;
                    }
                    updateAgrList.add(agr);
                }   
            }
            system.debug('Update Agreement list size:::'+updateAgrList.size());
            if(updateAgrList.size() > 0)
                update updateAgrList;
            
        } catch(Exception e) {
            system.debug('Error Message:::'+e.getMessage());
        }   
    }
    

}