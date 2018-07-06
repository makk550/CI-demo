/****************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       09/09/2017      us377325        RevRec: SFDC Opportunity Prices Likely to Close
* ********************************************************************************************/


trigger SyncPrimaryRobust on scpq__SciQuote__c (after insert, after update) { 
if(userinfo.getuserid()=='00530000003rQuJ') return;
    for(scpq__SciQuote__c quote: Trigger.new) 
    { 
        if(quote.CA_Primary_Flag__c == true) 
        { 
            for(List<scpq__SciQuote__c> oldPrimaries: [select Id, CA_Primary_Flag__c from scpq__SciQuote__c 
                                             where (CA_Primary_Flag__c = true) AND 
                                             (scpq__OpportunityId__c = :quote.scpq__OpportunityId__c) AND 
                                             (Id != :quote.Id)]) 
            { 
                for(scpq__SciQuote__c oldPrimary: oldPrimaries) 
                { 
                    oldPrimary.CA_Primary_Flag__c = false; 
                } 
            
                update oldPrimaries; 
            } 
        } 
    } // end for 
    
    /*// ---------- The following code was added for CR: 193720506 ---------- (begin)
    // Trigger.new does not contain the data of fields in related objects so we must query it
    Map<Id, Decimal> quoteToRate = new map<Id, Decimal>();
    for (scpq__SciQuote__c quote : [SELECT Id, scpq__OpportunityId__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c 
                                     FROM scpq__SciQuote__c
                                     WHERE Id IN :trigger.new
                                         AND scpq__OpportunityId__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c != null 
                                         AND scpq__OpportunityId__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c != 0
                                         AND CA_Primary_Flag__c = True] )
    {
        quoteToRate.put(quote.Id, quote.scpq__OpportunityId__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c);                                      
    }
    // -------------------------------------------------------------------- (End)*/
     //AMASA03
    ///*********Begin Rally Partner**********/
    Map<String,Site_Association__c> SiteaccMap = new Map<String,Site_Association__c>();
    Map<Id,opportunity> ReferralOpportunitiesMap = new Map<Id,opportunity>();
    set<String> SterlingQuoteSoldID = new set<String>();
    set<ID> ReferralOppIds =new set<ID>();
    set<ID> ReferralOppAccountIds = new set<ID>();
    List<Site_Association__c> siteassSoldList;
    /*getting the opportunity Id's from sterling quote where soldtoid is not and isprimary flag is true*/ 
    for(scpq__SciQuote__c q:Trigger.new ){
         if(q.CA_Primary_Flag__c == True){
             System.debug('assss-----**'+q.CA_Sold_To_ID__c);
             SterlingQuoteSoldID.add(q.CA_Sold_To_ID__c);
             ReferralOppIds.add(q.scpq__OpportunityId__c);
         }
    } 
    System.debug('1)-sterling quote Sold to ID set --->'+ SterlingQuoteSoldID);
    System.debug('2)-Referral Opp Set --->' +ReferralOppIds);
    /*fetching the opportunity records , creating opportunity map and the accounts set*/
    if(ReferralOppIds.size() > 0){
        List<Opportunity> ReferralOpportunityList =[select id,Referral_Partner_Account__c,Account.ID,Referral_Date__c,IsReferral_UpSellUpdate__c,Createddate,type from opportunity where id in :ReferralOppIds];
        for(Opportunity op :ReferralOpportunityList){
            ReferralOpportunitiesMap.put(op.id, op);
            ReferralOppAccountIds.add(op.AccountId);
        }
    }
    System.debug('3)-Referral Opportunity Map created --->'+ReferralOpportunitiesMap);
    System.debug('4)-Referral opportunity Accounts ---->'+ ReferralOppAccountIds);
    if(SterlingQuoteSoldID.size() >0 && ReferralOppAccountIds.size() > 0){
        siteassSoldList = [select id,SAP_Site_ID__c,Referral_Partner_Account__c,Referral_Date__c from Site_Association__c where SAP_Site_ID__c != null and SAP_Site_ID__c in :SterlingQuoteSoldID and Enterprise_ID__c in :ReferralOppAccountIds];
        for(Site_Association__c s : siteassSoldList){
            if(!SiteaccMap.containsKey(s.SAP_Site_ID__c)){
                System.debug('matched ');
                SiteaccMap.put(s.SAP_Site_ID__c, s);
            }
            
        }
        
    }
    System.debug('5)siteassSoldList ->' +siteassSoldList +'---------------'+SiteaccMap);
    System.debug('6)SterlingQuoteSoldID -->'+SterlingQuoteSoldID);
    /*********End Rally Partner**********/
    //End referral upsell and lead flow requirement change
    
    //update the oppty  field based on the primary quote field  
    List<Opportunity> opplist = new List<Opportunity>();
        for(scpq__SciQuote__c q:Trigger.new ){
        if(q.CA_Primary_Flag__c == True){
            Opportunity opp = new Opportunity(id=q.scpq__OpportunityId__c);
                if(q.CA_Revenue_Per_day_Old__c<>null ){
                    opp.Old_RPD_Cpq__c = q.CA_Revenue_Per_day_Old__c ;

                }
                if(q.CA_Revenue_Per_Day_New__c<>null ){
                opp.New_RPD_Cpq__c = q.CA_Revenue_Per_Day_New__c ;

                }
                
                
            /*

             LEEAN04 US477755 Removed Fields no longer required on Opportunity
             OLD TRR, New TRR, TRR %, ATTRF, Baseline ATTRF(LC), New Annual Time, RR%

                if (q.CA_Total_ATTRF__c <> null &&  q.CA_Realization_Rate__c <> null)
                    opp.New_Annual_Time__c = (q.CA_Total_ATTRF__c * q.CA_Realization_Rate__c )/100;
                else 
                    opp.New_Annual_Time__c=0; 
            opp.RR_Percentage__c = q.CA_Realization_Rate__c;      
            opp.New_TRR__c = q.CA_New_TRR__c; 
            opp.TRR_Percentage__c = q.CA_TRR_Percent__c;      
               
            */

            // LEEAN04 US477755 add new fields from Sterling Quote to Opportunity
            
            opp.Renewable_ARR_Renewal__c = q.ARR_Renewal__c;
            opp.Commissionable_Renewal_ARR__c = q.Renewal_ARR_percent__c;
            opp.Commissionable_Total_ARR__c = q.Total_ARR_percent__c;            

            opp.CPQ_Quote_Total__c = q.CA_CPQ_Quote_Total__c ;    //samap01 -377325 -RevRec: SFDC Opportunity Prices Likely to Close   
            //merha02 US424524
            opp.TARR_Old_CPQ__c = q.HeaderTARROld__c;
            opp.TARR_New_CPQ__c = q.Total_TARR__c;
            opp.TARR__c = q.TARR__c;
           
            /*// ---------- The following code was added for CR: 193720506 ---------- (begin)
            Decimal conversionRate = quoteToRate.get(q.Id);
            if(conversionRate != null)
            {
              if(opp.New_TRR__c != null)
                opp.New_TRR_USD__c = opp.New_TRR__c / conversionRate;
              if(opp.New_Annual_Time__c != null)
                opp.New_Annual_Time_USD__c = opp.New_Annual_Time__c / conversionRate;
            }
            // -------------------------------------------------------------------- (End)*/
            

          
            //AMASA03- adding site association ID on opportunity for Upsell and referral Lead management flow -Rally Partner Change
            
           Opportunity referralopp = ReferralOpportunitiesMap.get(q.scpq__OpportunityId__c);
            System.debug('referralopp' + referralopp);
            System.debug('siteassignRec****' + q.ARR_Total__c + q.CA_Sold_To_ID__c + SiteaccMap.containsKey(q.CA_Sold_To_ID__c) + referralopp);
            if(q.ARR_Total__c > 0 && q.CA_Sold_To_ID__c!= null && SiteaccMap.containsKey(q.CA_Sold_To_ID__c) && referralopp != null){
                Site_Association__c siteassignRec = SiteaccMap.get(q.CA_Sold_To_ID__c);
                //opp.Referral_Site_Association__c = siteassignRec.id;
                System.debug('inside Referral -->');
                if(referralopp.Referral_Partner_Account__c != null && referralopp.Referral_Date__c != null && siteassignRec.Referral_Partner_Account__c == null && referralopp.IsReferral_UpSellUpdate__c == false && siteassignRec.Referral_Date__c == null){
                    opp.Referral_Site_Association__c = siteassignRec.id;
                    System.debug('inside Referral --> Lead Flow');
                }
                
                if(referralopp.Referral_Partner_Account__c == null && referralopp.Referral_Date__c == null && referralopp.IsReferral_UpSellUpdate__c == false && siteassignRec.Referral_date__c <= referralopp.createddate   && referralopp.createddate < (siteassignRec.Referral_date__c + 365) && referralopp.Type =='Direct'){
                    opp.Referral_Partner_Account__c =siteassignRec.Referral_Partner_Account__c;
                    opp.Referral_Date__c    = siteassignRec.Referral_Date__c;
                    opp.IsReferral_UpSellUpdate__c = true;
                    opp.Referral_Site_Association__c = siteassignRec.id;
                    System.debug('Upsell flow first scenario');
                }else if(referralopp.Referral_Partner_Account__c != null && referralopp.Referral_Date__c != null && referralopp.IsReferral_UpSellUpdate__c == true && siteassignRec.Referral_date__c <= referralopp.createddate  && referralopp.createddate < (siteassignRec.Referral_date__c + 365) && referralopp.Type == 'Direct'){
                    opp.Referral_Partner_Account__c =siteassignRec.Referral_Partner_Account__c;
                    opp.Referral_Date__c    = siteassignRec.Referral_Date__c;
                    opp.Referral_Site_Association__c = siteassignRec.id;
                    System.debug('Upsell flow second scenario');
                }
            }
            else{
                if(referralopp != null && referralopp.IsReferral_UpSellUpdate__c == true){
                    opp.Referral_Partner_Account__c = null;
                    opp.Referral_Date__c    = null;
                    opp.IsReferral_UpSellUpdate__c = false;
                    opp.Referral_Site_Association__c = null;
                    System.debug('Upsell flow third scenario');
                }else{
                    opp.Referral_Site_Association__c = null;
                }
            }
            
            
            //allha02 for CPQ Services -populating values on opp  
            if(q.SAP_Contract_Number__c!= null && q.SAP_Contract_Balance__c!=null)
              {
                opp.SAP_Contract_Number__c = q.SAP_Contract_Number__c;
                opp.SAP_Contract_Balance__c = q.SAP_Contract_Balance__c;
              }   
            opplist.add(opp);
        } // end if 
            //allha02 for CPQ Services -populating values on opp
            else if(q.SAP_Contract_Number__c!= null && q.SAP_Contract_Balance__c!=null){
                Opportunity opp1 = new Opportunity(id=q.scpq__OpportunityId__c);
                opp1.SAP_Contract_Number__c = q.SAP_Contract_Number__c;
                opp1.SAP_Contract_Balance__c = q.SAP_Contract_Balance__c;
            /*  //samap01 -377325 -RevRec: SFDC Opportunity Prices Likely to Close
            if(opp1.amount != q.CA_CPQ_Quote_Total__c && q.CA_Primary_Flag__c == true )
                opp1.Price_Difference__c = True ;
            else
                opp1.Price_Difference__c = False ;            
            //samap01 end*/
                opplist.add(opp1);
            }   
            //samap01 -377325 -RevRec: SFDC Opportunity Prices Likely to Close
            /*else  if(q.CA_Primary_Flag__c == false )
            {
               Opportunity opp2 = new Opportunity(id=q.scpq__OpportunityId__c);
              opp2.Price_Difference__c = False ;            
               opplist.add(opp2)  ;
            }*/
             
            
            
        
    } //end for
    System.debug('oppList:'+opplist);    
    Database.SaveResult[] sr =database.update(opplist,false);
 }