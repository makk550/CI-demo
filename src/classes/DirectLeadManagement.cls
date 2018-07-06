public class DirectLeadManagement
{
    //*****IMPORTANT: try catch have been removed from the code , since for bulk load the number of executed script statements was crossing the limit.
    public static List<Lead> RouteLeads(Lead[] newleads)
    {
        Id[] UnassignedQueueId = new Id[1];

        try{
            List<Group> groups = [select Id from Group where Type = 'Queue' and Name = 'Enterprise Unassigned Queue'];
            if(!groups.isEmpty())
                UnassignedQueueId[0] = groups[0].Id;
        }
        catch(Exception e){
            UnassignedQueueId[0] = SystemIdUtility.getEnterpriseUnassignedQueueId(); // '00GQ0000000EhNFMA0';
        }

        System.debug('UnassignedQueueId: ' + UnassignedQueueId[0]);
             
        List<Lead> NALeads = new List<Lead>();
        List<Lead> LALeads = new List<Lead>();
        List<Lead> APJLeads = new List<Lead>();
        List<Lead> EMEALeads = new List<Lead>(); 
        Set<String> acceaid = new Set<String>();
        List<Account> lstacc = new List<Account>();
        //Categorize leads according to their Geo
        for(Integer ld=0;ld<newleads.size();ld++){
            if(newleads[ld].GEO__c == 'NA')
                NALeads.add(newleads[ld]);
            else if(newleads[ld].GEO__c == 'LA')
                LALeads.add(newleads[ld]);
            else if(newleads[ld].GEO__c == 'APJ')
                APJLeads.add(newleads[ld]);
            else if(newleads[ld].GEO__c == 'EMEA')
                EMEALeads.add(newleads[ld]);
            //Store all EAIDs in a set for future query purpose
            if(newleads[ld].EAID__c!=null)
                 acceaid.add(newleads[ld].EAID__c);
        }//Query all accounts having Enterprise ID matching the EAIDs
        if(acceaid.size()>0){
            lstacc = [select ID,Enterprise_ID__c,OwnerID from Account where Owner.IsActive=true and Enterprise_ID__c in: acceaid];
            Set<ID> accids = new Set<ID>();    
            Map<String,ID> mapeaidaccowner = new Map<String,ID>();
            Map<String,ID> mapeaidaccid = new Map<String,ID>();
            //Store values in a map for future purpose
            for(Integer accnt=0;accnt<lstacc.size();accnt++){
                if(lstacc[accnt].Enterprise_ID__c!=null){
                    accids.add(lstacc[accnt].ID);
                    mapeaidaccowner.put(lstacc[accnt].Enterprise_ID__c,lstacc[accnt].OwnerID);
                    mapeaidaccid.put(lstacc[accnt].Enterprise_ID__c,lstacc[accnt].ID);}
            }
            List<CombinedRouting> routingclass = new List<CombinedRouting>();
            //Call method for fetching rules from routing tables for each region
            if(NALeads.size()>0)
                routingclass = NaLeadRouting(NALeads);
            /*** if(LALeads.size()>0){  // Code Commented by Rao to Diable the LA lead custom lead rules Cr:190392881
                if(routingclass.size()>0){
                    List<CombinedRouting> temproutingclass = new List<CombinedRouting>();
                    temproutingclass = LaLeadRouting(LALeads);
                    for(Integer leadlistcnt=0;leadlistcnt<temproutingclass.size();leadlistcnt++){
                        routingclass.add(temproutingclass[leadlistcnt]);}
                }else
                    routingclass = LaLeadRouting(LALeads);        
            } **/
            if(APJLeads.size()>0){
                if(routingclass.size()>0){
                    List<CombinedRouting> temproutingclass = new List<CombinedRouting>();
                    temproutingclass = APJLeadRouting(APJLeads);
                    for(Integer leadlistcnt=0;leadlistcnt<temproutingclass.size();leadlistcnt++){
                        routingclass.add(temproutingclass[leadlistcnt]);}
                }else
                    routingclass = APJLeadRouting(APJLeads);        
            }    
            if(EMEALeads.size()>0){
                if(routingclass.size()>0){
                    List<CombinedRouting> temproutingclass = new List<CombinedRouting>();
                    temproutingclass = EMEALeadRouting(EMEALeads);
                    for(Integer leadlistcnt=0;leadlistcnt<temproutingclass.size();leadlistcnt++){
                        routingclass.add(temproutingclass[leadlistcnt]);}
                }else
                    routingclass = EMEALeadRouting(EMEALeads);        
            }  
            Set<String> setteamrole = new Set<String>();
            List<AccountTeamMember> accteam = new List<AccountTeamMember>();
            //If rules in routing object target the user in the account team role (to be assigned as lead owner), fetch the users matching the lead.EAID and routing.AccountTeamRole
            for(Integer rout=0;rout<routingclass.size();rout++){
                CombinedRouting routclass = routingclass[rout];
                if(routclass.strTeamRole!=null)
                    setteamrole.add(routclass.strTeamRole);
            }//Fetch users for each roles from Account Team Role for the particular Lead EAID
            if(setteamrole.size()>0)
                accteam = [select TeamMemberRole,UserID,AccountID,createddate from AccountTeamMember where User.IsActive=true and AccountID in: accids and TeamMemberRole in: setteamrole order by createddate desc];
            string checkCountryValid = '';
            string checkAreaValid = '';
            string checkTerrValid = '';
            string checkTacticValid = '';
            string checkLeadSourceValid = '';
            string checkNCVValid = '';
            string checkSubTacticValid = '';
            string checkAccountClassValid = '';
            Boolean ischeck = false;
            system.debug('????? :: 1');
            for(Integer leadnew=0;leadnew<newleads.size();leadnew++){ 
                if(newleads[leadnew].EAID__c != null){
                    for(Integer rclasscnt=0;rclasscnt<routingclass.size();rclasscnt++){
                        CombinedRouting routclass = routingclass[rclasscnt];
                        if(newleads[leadnew].Geo__c == routclass.strRegionType){
                            if((routclass.strBU == newleads[leadnew].MKT_BU_Category__c)&&((routclass.strSubTactic ==newleads[leadnew].Sub_Tactic__c)||(routclass.strSubTactic ==''||routclass.strSubTactic ==null ))) //Saba 11/17/2010
                            //if(routclass.strBU == newleads[leadnew].MKT_BU_Category__c)//Old condition
                            {
                                system.debug('????? :: 2');
                                //check if lead matches rule country, Area, Territory, Leadsource, Ncv Driver, Tactic and Sub Tactic and Account Class
                                if(routclass.strCountry!=null){
                                    checkCountryValid = checkCountry(newleads[leadnew],routclass);}
                                if(routclass.strArea!=null){
                                    checkAreaValid = checkArea(newleads[leadnew],routclass);}
                                if(routclass.strTerritory!=null){
                                    checkTerrValid = checkTerritory(newleads[leadnew],routclass);}
                                if(routclass.strTactic!=null){
                                    checkTacticValid = checkTactic(newleads[leadnew],routclass);}
                                if(routclass.strLeadSource!=null){
                                    checkLeadSourceValid = checkLeadSource(newleads[leadnew],routclass);}
                                if(routclass.strNCVDriver!=null){
                                    checkNCVValid = checkNCV(newleads[leadnew],routclass);}
                                if(routclass.strSubTactic!=null){
                                    checkSubTacticValid = checkSubTactic(newleads[leadnew],routclass);}
                                if(routclass.strAccountClass!=null){
                                    checkAccountClassValid = checkAccountClass(newleads[leadnew],routclass);}
                                List<String> listvalidate = new List<String>();
                                //add true-false values to list object based on whether lead values match rule values
                                if(checkCountryValid != ''){
                                    listvalidate.add(checkCountryValid);}
                                if(checkAreaValid != ''){
                                    listvalidate.add(checkAreaValid);}
                                if(checkTerrValid != ''){
                                    listvalidate.add(checkTerrValid);}
                                if(checkTacticValid != ''){
                                    listvalidate.add(checkTacticValid);}
                                if(checkLeadSourceValid != ''){
                                    listvalidate.add(checkLeadSourceValid);}
                                if(checkNCVValid != ''){
                                    listvalidate.add(checkNCVValid);}
                                if(checkSubTacticValid != ''){
                                    listvalidate.add(checkSubTacticValid);}
                                if(checkAccountClassValid != ''){
                                    listvalidate.add(checkAccountClassValid);}
                                if(listvalidate.size()>0){
                                    boolean isvalid = true;
                                    for(Integer count=0;count<listValidate.size();count++){
                                        if(listValidate[count] == 'false'){
                                            isvalid = false;
                                            count = listValidate.size();}
                                    }//if the lead matches all conditions of the rule, set the owner
                                    if(isvalid == true){
                                        if(routclass.isAccOwner == true){//if rule targets Account Owner as lead owner
                                            newleads[leadnew].OwnerID = mapeaidaccowner.get(newleads[leadnew].EAID__c);
                                            break;}
                                        else if(routclass.strTeamRole != null || routclass.strTeamRole != ''){
                                            //if rule targets account team role user as lead owner, fetch from the query results returned earlier in the code. Assign lead owner by matching lead EAID with Account EAID
                                            for(Integer teamcnt=0;teamcnt<accteam.size();teamcnt++){
                                                ID accountid = mapeaidaccid.get(newleads[leadnew].EAID__c);
                                                if((routclass.strTeamRole == accteam[teamcnt].TeamMemberRole) && (accteam[teamcnt].AccountID == accountid)){
                                                    newleads[leadnew].OwnerID = accteam[teamcnt].UserID;
                                                    ischeck = true;
                                                    break;}
                                            }
                                            if(ischeck==true)
                                                break;
                                        }
                                    }
                                }//if routing rule does not have any criteria set other than BU, then match leads just on basis of BU value
                                if(routclass.strCountry == null && routclass.strArea == null && routclass.strTerritory == null && routclass.strTactic == null && routclass.strLeadSource == null && routclass.strNCVDriver == null && routclass.strAccountClass == null){
                                    if(routclass.isAccOwner == true){
                                        newleads[leadnew].OwnerID = mapeaidaccowner.get(newleads[leadnew].EAID__c);
                                        break;}
                                    else if(routclass.strTeamRole != null || routclass.strTeamRole != ''){
                                        for(Integer teamcnt=0;teamcnt<accteam.size();teamcnt++){
                                            ID accountid = mapeaidaccid.get(newleads[leadnew].EAID__c);
                                            if((routclass.strTeamRole == accteam[teamcnt].TeamMemberRole) && (accteam[teamcnt].AccountID == accountid)){
                                                newleads[leadnew].OwnerID = accteam[teamcnt].UserID;
                                                ischeck = true;
                                                break;}
                                        }
                                        if(ischeck == true){
                                            break;
                                        }else{
                                            newleads[leadnew].OwnerID = UnassignedQueueId[0];
                                            System.debug('newleads[leadnew].OwnerID: ' + newleads[leadnew].OwnerID);
                                            ischeck = true;                                         
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }//send the owner assigned leads back to trigger for updation.
        return newleads;
    }
    public static string checkCountry(Lead ld,CombinedRouting rout)
    {//validate Lead country with Routing rule country
        string chkcountry = '';
        if(rout.strCountry!=null){
            if(ld.Country_Picklist__c!=null){
                if(ld.Country_Picklist__c.tolowercase().trim() == rout.strCountry.tolowercase().trim())
                    chkcountry = 'true';
                else
                    chkcountry = 'false';
            }
        }
        return chkcountry;
    }
    public static string checkArea(Lead ld,CombinedRouting rout)
    {//validate Lead area with Routing rule area
        string chkarea = '';
        if(rout.strArea!=null){
            if(ld.MKT_Territory__c!=null){
                if(ld.MKT_Territory__c.tolowercase().trim() == rout.strArea.tolowercase().trim())
                    chkarea = 'true';
                else
                    chkarea = 'false';  
             }
        }
        return chkarea;
    }
    public static string checkTerritory(Lead ld,CombinedRouting rout)
    {//validate Lead territory with Routing rule territory
        string chkterr = '';
        if(rout.strTerritory!=null){
            if(ld.Sales_Territory__c!=null){
                if(ld.Sales_Territory__c.tolowercase().trim() == rout.strTerritory.tolowercase().trim())
                    chkterr = 'true';
                else
                    chkterr = 'false';
            }
        }
        return chkterr;
    }
    public static string checkTactic(Lead ld,CombinedRouting rout)
    {//validate Lead tactic with Routing rule tactic
        string chktactic = '';
        if(rout.strTactic!=null){
            if(ld.Tactic__c!=null){
                if(ld.Tactic__c.tolowercase().trim() == rout.strTactic.tolowercase().trim())
                    chktactic = 'true';
                else
                    chktactic = 'false';
            }
        }
        return chktactic;
    }
    public static string checkLeadSource(Lead ld,CombinedRouting rout)
    {//validate Lead leadsource with Routing rule leadsource
        string chkleadsource = '';
        if(rout.strLeadSource!=null){
            if(ld.LeadSource!=null){
                if(ld.LeadSource.tolowercase().trim() == rout.strLeadSource.tolowercase().trim())
                    chkleadsource = 'true';
                else
                    chkleadsource = 'false';
            }
        }
        return chkleadsource;
    }
    public static string checkNcv(Lead ld,CombinedRouting rout)
    {//validate Lead ncv driver with Routing rule ncv driver
        string chkncv = '';
        if(rout.strNCVDriver!=null){
            if(ld.MKT_Solution_Set__c!=null){
                if(ld.MKT_Solution_Set__c.tolowercase().trim() == rout.strNCVDriver.tolowercase().trim())
                    chkncv = 'true';
                else
                    chkncv = 'false';
             }
        }
        return chkncv;
    }
    public static string checkSubTactic(Lead ld,CombinedRouting rout)
    {//validate Lead sub-tactic with Routing rule sub-tactic
        string chksubtactic = '';
        if(rout.strSubTactic!=null){
            if(ld.Sub_Tactic__c!=null){
                if(ld.Sub_Tactic__c.tolowercase().trim() == rout.strSubTactic.tolowercase().trim())
                    chksubtactic = 'true';
                else
                    chksubtactic = 'false';
             }
        }
        return chksubtactic;
    }
    public static string checkAccountClass(Lead ld,CombinedRouting rout)
    {//validate Lead Account Class with Routing rule Account Class
        string chkaccountclass = '';
        if(rout.strAccountClass!=null){
            if(ld.Account_Class__c!=null){
                if(ld.Account_Class__c.tolowercase().trim() == rout.strAccountClass.tolowercase().trim())
                    chkaccountclass = 'true';
                else
                    chkaccountclass = 'false';
             }
        }
        return chkaccountclass;
    }
    public class CombinedRouting
    {//temporary rule container class
        String strBU = '';
        String strTerritory = '';
        String strArea = '';
        String strCountry = '';
        String strRegionType = '';
        Boolean isAccOwner = false;
        String strTeamRole = '';
        String strTactic = '';
        String strNCVDriver = '';
        String strLeadSource = '';
        String strSubTactic = '';
        String strAccountClass = '';
    }
    public static List<CombinedRouting> NaLeadRouting(List<Lead> lstNALeads)
    {//Get NA rules matching Lead BU and Country
        Set<String> setBU = new Set<String>();
        Set<String> setCo = new Set<String>();
        for(Integer bucount=0;bucount<lstNALeads.size();bucount++){
            if(lstNALeads[bucount].MKT_BU_Category__c != null)
                setBU.add(lstNALeads[bucount].MKT_BU_Category__c);
            if(lstNALeads[bucount].Country_Picklist__c != null)
                setCo.add(lstNALeads[bucount].Country_Picklist__c);
        }
        String strgeo = lstNALeads[0].Geo__c;
        List<NA_Direct_Lead_Routing__c> lstNAroute = new List<NA_Direct_Lead_Routing__c>();
        lstNAroute = [select Account_Class__c,Sub_Tactic__c,Lead_Source__c,Area__c,Territory__c,Country__c,Business_Unit__c,Account_Owner__c,Account_Team_Role__c,Tactic__c,NCV_Driver__c from NA_Direct_Lead_Routing__c where Business_Unit__c in: setBU and (Country__c = '' or Country__c in: setCo)];
        List<CombinedRouting> lstroutingclass = new List<CombinedRouting>();
        for(Integer nacount=0;nacount<lstNAroute.size();nacount++){
            CombinedRouting route = new CombinedRouting();
            route.strBU = lstNAroute[nacount].Business_Unit__c;
            route.strTerritory = lstNAroute[nacount].Territory__c;
            route.strArea = lstNAroute[nacount].Area__c;
            route.strCountry = lstNAroute[nacount].Country__c;
            route.strRegionType = strgeo;
            route.isAccOwner = lstNAroute[nacount].Account_Owner__c;
            route.strTeamRole = lstNAroute[nacount].Account_Team_Role__c;
            route.strTactic = lstNAroute[nacount].Tactic__c;
            route.strLeadSource = lstNAroute[nacount].Lead_Source__c;
            route.strNCVDriver = lstNAroute[nacount].NCV_Driver__c;
            route.strSubTactic = lstNAroute[nacount].Sub_Tactic__c;
            route.strAccountClass = lstNAroute[nacount].Account_Class__c;
            lstroutingclass.add(route);}
        return lstroutingclass;
    }  
    public static List<CombinedRouting> LALeadRouting(List<Lead> lstLALeads)
    {//Get LA rules matching Lead BU and Country
        Set<String> setBU = new Set<String>();
        Set<String> setCo = new Set<String>();
        for(Integer bucount=0;bucount<lstLALeads.size();bucount++){
            if(lstLALeads[bucount].MKT_BU_Category__c != null)
                setBU.add(lstLALeads[bucount].MKT_BU_Category__c);  
            if(lstLALeads[bucount].Country_Picklist__c != null)
                setCo.add(lstLALeads[bucount].Country_Picklist__c); 
        }
        String strgeo = lstLALeads[0].Geo__c;
        List<LA_Direct_Lead_Routing__c> lstLAroute = new List<LA_Direct_Lead_Routing__c>();
        lstLAroute = [select Account_Class__c,Sub_Tactic__c,Lead_Source__c,Tactic__c,NCV_Driver__c,Area__c,Territory__c,Country__c,Business_Unit__c,Account_Owner__c,Account_Team_Role__c from LA_Direct_Lead_Routing__c where Business_Unit__c in: setBU and (Country__c = '' or Country__c in: setCo)];
        List<CombinedRouting> lstroutingclass = new List<CombinedRouting>();
        for(Integer lacount=0;lacount<lstLAroute.size();lacount++){
            CombinedRouting route = new CombinedRouting();
            route.strBU = lstLAroute[lacount].Business_Unit__c;
            route.strTerritory = lstLAroute[lacount].Territory__c;
            route.strArea = lstLAroute[lacount].Area__c;
            route.strCountry = lstLAroute[lacount].Country__c;
            route.strRegionType = strgeo;
            route.isAccOwner = lstLAroute[lacount].Account_Owner__c;
            route.strTeamRole = lstLAroute[lacount].Account_Team_Role__c;
            route.strTactic = lstLAroute[lacount].Tactic__c;
            route.strLeadSource = lstLAroute[lacount].Lead_Source__c;
            route.strNCVDriver = lstLAroute[lacount].NCV_Driver__c;
            route.strSubTactic = lstLAroute[lacount].Sub_Tactic__c;
            route.strAccountClass = lstLAroute[lacount].Account_Class__c;
            lstroutingclass.add(route);}
        return lstroutingclass;
    }
    public static List<CombinedRouting> APJLeadRouting(List<Lead> lstAPJLeads)
    {//Get APJ rules matching Lead BU and Country
        Set<String> setBU = new Set<String>();
        Set<String> setCo = new Set<String>();
        for(Integer bucount=0;bucount<lstAPJLeads.size();bucount++){
            if(lstAPJLeads[bucount].MKT_BU_Category__c != null)
                setBU.add(lstAPJLeads[bucount].MKT_BU_Category__c);
            if(lstAPJLeads[bucount].Country_Picklist__c != null)
                setCo.add(lstAPJLeads[bucount].Country_Picklist__c);   
        }
        String strgeo = lstAPJLeads[0].Geo__c;
        List<APJ_Direct_Lead_Routing__c> lstAPJroute = new List<APJ_Direct_Lead_Routing__c>();
        lstAPJroute = [select Account_Class__c,Sub_Tactic__c,Lead_Source__c,Tactic__c,NCV_Driver__c,Area__c,Territory__c,Country__c,Business_Unit__c,Account_Owner__c,Account_Team_Role__c from APJ_Direct_Lead_Routing__c where Business_Unit__c in: setBU and (Country__c = '' or Country__c in: setCo)];
        List<CombinedRouting> lstroutingclass = new List<CombinedRouting>();
        for(Integer apjcount=0;apjcount<lstAPJroute.size();apjcount++){
            CombinedRouting route = new CombinedRouting();
            route.strBU = lstAPJroute[apjcount].Business_Unit__c;
            route.strTerritory = lstAPJroute[apjcount].Territory__c;
            route.strArea = lstAPJroute[apjcount].Area__c;
            route.strCountry = lstAPJroute[apjcount].Country__c;
            route.strRegionType = strgeo;
            route.isAccOwner = lstAPJroute[apjcount].Account_Owner__c;
            route.strTeamRole = lstAPJroute[apjcount].Account_Team_Role__c;
            route.strTactic = lstAPJroute[apjcount].Tactic__c;
            route.strLeadSource = lstAPJroute[apjcount].Lead_Source__c;
            route.strNCVDriver = lstAPJroute[apjcount].NCV_Driver__c;
            route.strSubTactic = lstAPJroute[apjcount].Sub_Tactic__c;
            route.strAccountClass = lstAPJroute[apjcount].Account_Class__c;
            lstroutingclass.add(route);}
        return lstroutingclass;
    }
    public static List<CombinedRouting> EMEALeadRouting(List<Lead> lstEMEALeads)
    {//Get EMEA rules matching Lead BU and Country
        Set<String> setBU = new Set<String>();
        Set<String> setCo = new Set<String>();
        for(Integer bucount=0;bucount<lstEMEALeads.size();bucount++){
            if(lstEMEALeads[bucount].MKT_BU_Category__c != null)
                setBU.add(lstEMEALeads[bucount].MKT_BU_Category__c);   
            if(lstEMEALeads[bucount].Country_Picklist__c != null)
                setCo.add(lstEMEALeads[bucount].Country_Picklist__c);    
        }
        String strgeo = lstEMEALeads[0].Geo__c;
        List<EMEA_Direct_Lead_Routing__c> lstEMEAroute = new List<EMEA_Direct_Lead_Routing__c>();
        lstEMEAroute = [select Account_Class__c,Sub_Tactic__c,Lead_Source__c,NCV_Driver__c,Tactic__c,Area__c,Territory__c,Country__c,Business_Unit__c,Account_Owner__c,Account_Team_Role__c from EMEA_Direct_Lead_Routing__c where Business_Unit__c in: setBU and (Country__c = '' or Country__c in: setCo)];
        List<CombinedRouting> lstroutingclass = new List<CombinedRouting>();
        for(Integer emeacount=0;emeacount<lstEMEAroute.size();emeacount++){
            CombinedRouting route = new CombinedRouting();
            route.strBU = lstEMEAroute[emeacount].Business_Unit__c;
            route.strTerritory = lstEMEAroute[emeacount].Territory__c;
            route.strArea = lstEMEAroute[emeacount].Area__c;
            route.strCountry = lstEMEAroute[emeacount].Country__c;
            route.strRegionType = strgeo;
            route.isAccOwner = lstEMEAroute[emeacount].Account_Owner__c;
            route.strTeamRole = lstEMEAroute[emeacount].Account_Team_Role__c;
            route.strTactic = lstEMEAroute[emeacount].Tactic__c;
            route.strLeadSource = lstEMEAroute[emeacount].Lead_Source__c;
            route.strNCVDriver = lstEMEAroute[emeacount].NCV_Driver__c;
            route.strSubTactic = lstEMEAroute[emeacount].Sub_Tactic__c;
            route.strAccountClass = lstEMEAroute[emeacount].Account_Class__c;
            lstroutingclass.add(route);}
        return lstroutingclass;
    }
    
    @isTest(SeeAllData=true)
    public static void DealRegistrationEdit_Test(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Enterprise_ID__c = '1234';
        acc.BillingStreet = 'Arlington';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'VA';
        insert acc;
        
        //User tempUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        
        List<lead> lstLead = new List<Lead>();
        
        APJ_Direct_Lead_Routing__c objAPJ = new APJ_Direct_Lead_Routing__c();
        objAPJ.Country__c = 'test';
        objAPJ.Business_Unit__c = 'test';
        objAPJ.Sub_Tactic__c = 'test';
        objAPJ.Account_Class__c = 'test';
        objAPJ.Sub_Tactic__c = 'test';
        objAPJ.Lead_Source__c ='test';
        objAPJ.NCV_Driver__c ='test';
        objAPJ.Tactic__c = 'test';
        objAPJ.Area__c ='test';
        objAPJ.Territory__c ='test';
        objAPJ.Account_Team_Role__c='test';
        objAPJ.Account_Owner__c= true;
        insert objAPJ;
      
        
        NA_Direct_Lead_Routing__c objNA = new NA_Direct_Lead_Routing__c();
        objNA.Country__c = 'test';
        objNA.Business_Unit__c = 'test';
        objNA.Sub_Tactic__c = 'test';
        objNA.Account_Class__c = 'test';
        objNA.Sub_Tactic__c = 'test';
        objNA.Lead_Source__c ='test';
        objNA.NCV_Driver__c ='test';
        objNA.Tactic__c = 'test';
        objNA.Area__c ='test';
        objNA.Territory__c ='test';
        objNA.Account_Team_Role__c='test';      
        objNA.Account_Owner__c= true;
        insert objNA;
      
        
        EMEA_Direct_Lead_Routing__c objEMEA = new EMEA_Direct_Lead_Routing__c();
        objEMEA.Business_Unit__c = 'testEMEA';
        insert objEMEA;
     
                
        List<Lead> objLeads = new List<Lead>();
        Lead objLead = new Lead();
        objLead.LastName = 'test';
        objLead.Company = 'test';
        objLead.GEO__c = 'EMEA';
        objLead.MKT_BU_Category__c = objAPJ.Business_Unit__c;
        objLead.EAID__c = acc.Enterprise_ID__c;         
        //insert objLead;
        lstLead.add(objLead);
        
        objLeads.add(objLead);
        objLead = new Lead();
        objLead.LastName = 'test';
        objLead.Company = 'test';
        objLead.GEO__c = 'LA';
        objLead.MKT_BU_Category__c= objAPJ.Business_Unit__c;
        objLead.Country_Picklist__c = objAPJ.Country__c;
        objLead.Sub_Tactic__c = objAPJ.Sub_Tactic__c;
        objLead.EAID__c = acc.Enterprise_ID__c;         
       // insert objLead;
       lstLead.add(objLead);
       
        objLeads.add(objLead);
        
        objLeads.add(objLead);
        objLead = new Lead();
        objLead.LastName = 'test';
        objLead.Company = 'test';
        objLead.GEO__c = 'APJ';
        objLead.MKT_BU_Category__c= objAPJ.Business_Unit__c;
        objLead.Country_Picklist__c = objAPJ.Country__c;
        objLead.Sub_Tactic__c = objAPJ.Sub_Tactic__c;
        objLead.EAID__c = acc.Enterprise_ID__c;
        //insert objLead;
        lstLead.add(objLead);
        objLeads.add(objLead);
        
        objLeads.add(objLead);
        objLead = new Lead();
        objLead.LastName = 'test';
        objLead.Company = 'test';
        objLead.GEO__c = 'NA';
        objLead.MKT_BU_Category__c= objNA.Business_Unit__c;
        objLead.Country_Picklist__c = objNA.Country__c;
        objLead.Sub_Tactic__c = objNA.Sub_Tactic__c;
        objLead.EAID__c = acc.Enterprise_ID__c;
        lstLead.add(objLead);
        //insert objLead;
        objLeads.add(objLead);
        
        insert lstLead;
        
        CombinedRouting objCR = new CombinedRouting();
        objCR.strCountry = 'IN - INDIA';
        objCR.strArea = 'IN';
        objCR.strTerritory = 'test';
        objCR.strTactic = 'test';
        objCR.strLeadSource = 'test';
        objCR.strNCVDriver = 'test';
        objCR.strSubTactic = 'test';
        objCR.strAccountClass = 'test';
        objCR.strBU = 'test';
        
        DirectLeadManagement.NaLeadRouting(objLeads);
        DirectLeadManagement.LALeadRouting(objLeads);
        DirectLeadManagement.APJLeadRouting(objLeads);
        DirectLeadManagement.EMEALeadRouting(objLeads);
        DirectLeadManagement.RouteLeads(objLeads);
    }
}