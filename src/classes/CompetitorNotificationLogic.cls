public class CompetitorNotificationLogic {
    
    public static void competitorNotification(Opportunity opp)
    {
        System.debug('Inside competitorNotification');
         //sunji03 - FY19 Account Segement change:  
          //String segment1,segment2,segment3;    
          //segment1='Enterprise - T1';   
          //segment2='Enterprise - T2';   
          //segment3='Commercial';        
          String segment1,segment2,segment3,segment4;     
          segment1=Label.SegmentVal1;     
          segment2=Label.SegmentVal2;     
          segment3=Label.SegmentVal3;     
          segment4=Label.SegmentVal4;

        List<Opportunity> tempList;
        if((opp.competitor__c != 'No Competitor' && opp.Competitor__c!='Other' && opp.Competitor__c!='Unknown' && opp.competitor__c !=null )
           && opp.StageName != Label.Opp_Stage_Closed_Lost //US150086
           && (opp.Opportunity_Type__c!=null && opp.Opportunity_Type__c.contains('PNCV'))
           && opp.recordTypeId != Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Deal Registration').RecordTypeId
           && !(opp.Source__c =='Partner')
           && !(opp.Source__c == 'Deal Registration') 
           && !(opp.Source__c == 'Lead' && opp.Partner_Engagement__c == 'Incremental' ))
        {
            System.debug('Entered the logic for Competitor Notification');
            List<Opportunity> opportunityList = new List<Opportunity>();
            DateTime temp = opp.LastModifiedDate;
            Date lastmodified = Date.newinstance(temp.year(), temp.month(),temp.day());
            Date d = lastmodified.addMonths(-3);
            System.debug('Last Modified date: '+lastmodified+'---'+d);
            
            //Platinum, Gold, Silver
            if(opp.Segment__c == segment1 || opp.Segment__c == segment2 || opp.Segment__c == segment4){
                tempList = [select Name,Rpt_Region__c,CurrencyIsoCode,Owner.Name,Account.Name,Id,Segment__c,Rpt_Country__c,ReasonField__c,closedate,Competitor__c,Amount,Driving_Sales_Coverage_Business_Unit__c,Source__c,Pulldown__c,Type 
                            from Opportunity 
                            where closedate < :lastmodified and closedate > :d
                            and Competitor__c = :opp.Competitor__c
                            and Opportunity_Type__c like 'PNCV%'
                            and Sales_Milestone_Search__c=:Label.Opp_Stage_Closed_Won
                            and segment__c in (:segment1,:segment2,:segment4) //US166462
                            order by closedate Desc]; //US150096
            }else If (opp.Segment__c == segment3){
                //Commercial
                tempList = [select Name,Rpt_Region__c,CurrencyIsoCode,Owner.Name,Account.Name,Id,Segment__c,Rpt_Country__c,ReasonField__c,closedate,Competitor__c,Amount,Driving_Sales_Coverage_Business_Unit__c,Source__c,Pulldown__c,Type 
                            from Opportunity 
                            where closedate < :lastmodified and closedate > :d
                            and Competitor__c = :opp.Competitor__c
                            and Opportunity_Type__c like 'PNCV%'
                            and Sales_Milestone_Search__c=:Label.Opp_Stage_Closed_Won
                            and segment__c in (:segment3) //US166462
                            order by closedate Desc]; //US150096
            }
            
               
            System.debug('Opportunity being updated :' + opp);
            if(tempList != null && tempList.size() > 0)
            {
                System.debug('tempList size :' + tempList.size());
                //check for opps in same region
                for(Opportunity o:tempList)
                {
                    System.debug('Opportunity : ' + o);
                    if(opportunityList.size()<3)
                    {
                        if(o.Driving_Sales_Coverage_Business_Unit__c == opp.Driving_Sales_Coverage_Business_Unit__c 
                           //&& o.Segment__c == opp.Segment__c //US166462
                           && o.Rpt_Region__c == opp.Rpt_Region__c //US235713
                           && o.AccountId != opp.AccountId && o.Type != '1 Tier' && o.Type != '2 Tier'
                           && (o.Source__c == 'CA Internal' || o.Source__c == 'Lead') && o.Pulldown__c == FALSE)
                        {
                            opportunityList.add(o);
                        }
                    }
                }
                
                //check for other regions if opportunityList size < 3
                if(opportunityList.size()<3)
                {
                    for(Opportunity o:tempList)
                    {
                        
                        if(o.Driving_Sales_Coverage_Business_Unit__c == opp.Driving_Sales_Coverage_Business_Unit__c
                           //&& o.Segment__c == opp.Segment__c //US166462
                           && o.Rpt_Region__c != opp.Rpt_Region__c //US235713
                           && o.AccountId != opp.AccountId && o.Type != '1 Tier' && o.Type != '2 Tier' 
                           && (o.Source__c == 'CA Internal' || o.Source__c == 'Lead') && o.Pulldown__c == FALSE)
                        {
                            opportunityList.add(o);
                        }
                    }
                }
                
                System.debug('Opp list: '+opportunityList);
                if(opportunityList!=null && opportunityList.size() > 0)
                {
                    System.debug('OpportunityList Contents: '+opportunityList);
                    sendEmail(opp,opportunityList);
                }
            }
        }
    }
    
    public static void sendEmail(Opportunity opp,List<Opportunity> opportunityList)
    {
        System.debug('Inside sendEmail');
        // US150086 - Email should not be sent for inactive users
        boolean uStatus = false;
        List<User>  oppowner = [Select Id, Isactive from User where Id =:opp.ownerID LIMIT 1] ;
        if(oppowner.size()>0)
        {
            ustatus = oppowner[0].Isactive;
        }
        // US150086 - Email should not be sent for inactive users
        if (ustatus == TRUE){
            //Updated Email Template - Crust the Competition
            String message = '';
            List<Document> l = [select Id,Name from Document where Name = 'crush_header' or Name = 'crush_battlecards' or Name='crush_workspace' or Name='crush_wins' or Name='crush_contacts'];
            system.debug('Document List Size : ' + l.size());
            String baseurl = URL.getSalesforceBaseUrl().toExternalForm();
            Map<String,String> m = new Map<String,String>();
            for(integer i = 0; i< l.size();i++)
            {
                string url = baseurl+'/servlet/servlet.ImageServer?id='+l[i].Id+'&oid='+UserInfo.getOrganizationId();
                m.put(l[i].Name,url);
            }
            String Opplink = baseurl+'/'+opp.id;
            String OpportunityName = '<a href="'+Opplink+'" style="color:#47BFDD; text-decoration:none"><i>'+opp.Name+'</i></a>';
            for(Opportunity o : opportunityList)
            { 
                String closedate = String.valueOf(o.closedate);
                message +=  '<tr><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">'
                    +o.Name
                    +'</td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;"> '
                    +o.Account.Name+' </td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;"> '
                    +o.Segment__c+'</td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">'
                    +closedate+' </td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;"> '
                    +o.CurrencyIsoCode+' '+o.Amount+' </td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;"> '
                    +o.ReasonField__c+' </td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;"> '
                    +o.Owner.Name+' </td><td style="text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;"> '
                    +o.Rpt_Country__c+'</td></tr>';
            }
            message +='';
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.sethtmlbody('<html><body style="margin: 0; padding: 0;"><table cellpadding="10" cellspacing="10" width="100%" bgcolor="#C6C6C6"><tr><td>'
                            +'<table align="center" cellpadding="10" cellspacing="10" width="600" bgcolor="white"><tr><td><img src="'+m.get('crush_header')+'" alt="Header"/>'
                            +'</td></tr><tr><td style="margin-top: 5px;font-family:Calibri,Verdana;font-size:14;"><span style="font-size:18;color:#000000">Crush Competition on:</span>'
                            +'<span style="font-size:18;color:#47BFDD"> '+OpportunityName+' </span>'
                            +'<p>Collaborate with the winning teams of these opportunities that share your competitor and learn about CA\'s competitive advantage!'
                            +' Share this with those on your opportunity team.</p></td></tr><tr><td>'
                            +'<table width = "100%" border="0" style="font-weight:bold;font-family:Calibri,Verdana;font-size:18;">'
                            +'<tr><td rowspan="7" style="color:black;font-size:14">Latest Wins Against Your Competitor:</td></tr></table><br/>'
                            +'<table width = "100%" style="border-collapse:collapse;font-family:Calibri,Verdana;display:inline-block;font-size:12;padding:.2cm;">'
                            +'<tr style="background-color:#877593;">'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Opportunity Name</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Acct Name</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Segment</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Close Date</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Amount</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">W/L Reason</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Opp Owner</th>'
                            +'<th width="75px" style="color:white;text-align:left;border-bottom-style:solid;border-bottom-color:black;border-bottom-width:1px;">Territory</th>'
                            +'</tr><!-- Data rows will be here-->'+message+'</table>'
                            +'<p style= "font-family:Calibri,Verdana;font-size:15;font-weight:bold;font-size:14;margin-top:25px;">Additional Resources:</p>'
                            +'</td></tr><tr><td><table cellpadding="0" cellspacing="0" width="100%" border="0; style="margin-top:30px;"><tr>'
                            +'<td width="25%" style="float:left;font-size:14;position:relative;font-family:Calibri,Verdana;font-weight:bold" align="center">'
                            +'<a href="https://caone.sharepoint.com/sites/Sales/solutions/Pages/Competitive.aspx" style="color:#0066CC"> <img src="'+m.get('crush_battlecards')+'" align="center" height="156" width="137"/></a></td>'
                            +'<td width="25%" style="float:left;position:relative;font-size:14;font-family:Calibri,Verdana;font-weight:bold" align="center">'
                            +'<a href="https://caone.sharepoint.com/sites/Sales/SalesApp/home.aspx#/" style="color:#0066CC"> <img src="'+m.get('crush_workspace')+'" height="156" width="137"/></a></td>'
                            +'<td width="25%" style="float:left;position:relative;font-size:14;font-family:Calibri,Verdana;font-weight:bold" align="center">'
                            +'<a href="https://caone.sharepoint.com/sites/marketing/field/Pages/Sales-Kits.aspx" style="color:#0066CC">'
                            +'<img src="'+m.get('crush_wins')+'" height="156" width="137"/></a></td>'
                            +'<td width="25%" style="float:left;position:relative;font-size:14;font-family:Calibri,Verdana;font-weight:bold" align="center">'
                            +'<a href="https://caone.sharepoint.com/sites/Sales/Lists/Internal%20Contact%20by%20BU/AllItems.aspx" style="color:#0066CC"><img src="'+m.get('crush_contacts')+'" height="156" width="137"/></a></td>'
                            +'</tr></table></td></tr><tr><td style="font-size:9;color:#808080;font-family:Calibri,Verdana;padding-top:35px;">'
                            +'Copyright &copy; 2016 CA. All rights reserved. <br/>CA Confidential and proprietary information for CA internal use only.'
                            +' No unauthorized copying or distribution permitted.<br/></td></tr></table></td></tr></table></body></html>');
            msg.setSubject('Crush the Competition');
            msg.setSaveAsActivity(false);
            msg.setTargetObjectId(opp.ownerId);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
            
            
            //Create task to log that email was sent
            Task tskNew = new Task();
            tskNew.OwnerId = opp.ownerID;
            tskNew.Subject = 'Competitor Notification Email for Opportunity: ' + opp.Name;
            tskNew.Type = 'Email';
            tskNew.Status = 'Completed';
            tskNew.WhatId = opp.Id;
            
            try{
                insert tskNew;
            } catch(System.DMLException e) {
                System.debug(e.getMessage());
            }
            
        }
    }
    
}