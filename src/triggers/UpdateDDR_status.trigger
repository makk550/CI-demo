/*
 * Test class - OppUpdateDealDeskTestClass 
 * Coverage - 75%
 * Updated by - BAJPI01
*/ 

trigger UpdateDDR_status on Deal_Desk_Review__c (before insert,before update,after insert,after update) {
    

    
    Set<Id> usersSet = new Set<Id>();
    Set<Id> usersSet1 = new Set<Id>();
    set<Id> ownerIdSet = new set<Id>();
    set<Id> oldOwnerIdSet = new set<Id>();
    Map<id,id> mapid=new map<id,id>();
    Set<Id> oppid = new Set<Id>();
    Map<id,Opportunity> oppMap = new map<id,Opportunity>();
    Set<Id> accid = new Set<Id>();
    Map<id,Account> accMap = new map<id,Account>();
    Set<Id> quoteid = new Set<Id>();
     Set<Id> salesforceQuoteIds = new Set<Id>(); //chajo30
    Map<id, SBQQ__Quote__c> salesforceQuoteMap = new Map<id, SBQQ__Quote__c>();//chajo30
    Map<id,scpq__SciQuote__c> quoteMap = new map<id,scpq__SciQuote__c >();
    Set<Id> siteids = new Set<Id>();
    Map<id,Site_Association__c> siteMap = new map<id,Site_Association__c>();
  
    if(Trigger.isBefore){
        
        for(Deal_Desk_Review__c ddr:trigger.new){
        if(ddr.Opportunity_Name__c!=null)
          oppid.add(ddr.Opportunity_Name__c);
        if(ddr.Account__c!=null)
          accid.add(ddr.Account__c);
        if(ddr.Sterling_Quote__c!=null)
          quoteid.add(ddr.Sterling_Quote__c);
        if(ddr.Site_Association__c!=null)
          siteids.add(ddr.Site_Association__c);
        if(ddr.Salesforce_Quote__c!=null)//chajo30
          salesforceQuoteIds.add(ddr.Salesforce_Quote__c);  
      }
            
              
      if(oppid.size()>0){
            oppMap=new map<id,Opportunity>();
			 quoteMap=new map<id,scpq__SciQuote__c >();
			 salesforceQuoteMap = new map<id, SBQQ__Quote__c>();								 								 
			List<scpq__SciQuote__c> sterlingquotelist=new List<scpq__SciQuote__c>();
			List<SBQQ__Quote__c> SFCPQlist=new List<SBQQ__Quote__c>();
			 for(Opportunity opp:[select id,Rpt_Region__c,(select id,CA_Effective_Date__c,CA_Contract_End_Date__c,CA_CPQ_Quote_Total__c,CA_Customer_Name_Sold_To__c,CA_Sold_To_Id__c,CreatedById,CPQ_Quote_Creator_Id__c,CA_Brief_Deal_Desc__c from scpq__sci_quotes__r where id IN:quoteid),(select id, SoldTo_BPID__c, SBQQ__ExpirationDate__c, End_Date_form__c from SBQQ__Quotes2__r where id IN: salesforceQuoteIds),Opportunity_Number__c,Rpt_Area__c,Rpt_Territory_Country__c,Rpt_Country__c,AccountId,CurrencyIsoCode,Amount,Account.Name,Type from Opportunity where id IN:oppId]){
			   if(opp.scpq__sci_quotes__r!=null)
				sterlingquotelist.addAll(opp.scpq__sci_quotes__r);
               if(opp.SBQQ__Quotes2__r!=null)			
				 SFCPQlist.addAll(opp.SBQQ__Quotes2__r);
			    oppMap.put(opp.id,opp);
				 
			    }
			 
			 
			 
		 for(scpq__SciQuote__c sterl:sterlingquotelist){
			
			quoteMap.put(sterl.id,sterl);
			
		   }
         	 
		 for(SBQQ__Quote__c SFCpq:SFCPQlist){
			salesforceQuoteMap.put(SFCpq.id,SFCpq);
			
		   }
			
	   }
      
      if(accId.size()>0){              
        accMap=new map<id,Account>();
		siteMap = new map<id,Site_Association__c>();											  
	   List<Site_Association__c> listsitassoca=new List<Site_Association__c>();
	  for(Account acc:[select id,BillingCity,BillingCountry,(select id,Name,City__c,Country_Picklist__c,SAP_Site_ID__c,State__c,Street2__c,Street3__c,
                                               Street__c,Postal_Code__c from Site_Association__r where id IN: siteids),BillingState,BillingStreet,BillingPostalCode,GEO__c,Sales_Area__c,
                                              Sales_Region__c,Region_Country__c,Name, segment__c from Account where id IN:accId]){
		   if(acc.Site_Association__r!=null)
			   listsitassoca.addAll(acc.Site_Association__r);
		 
	        accMap.put(acc.id,acc);
	     }

	   for(Site_Association__c siteassco:listsitassoca){		   
		   siteMap.put(siteassco.id,siteassco);
		   
	     }
		
	  }
    agreementsOnddrUpdation.agreementlist = new List<Apttus__APTS_Agreement__c>();

    if(Trigger.isInsert){         
      for(Deal_Desk_Review__c ddr:trigger.new){
        Opportunity opp;
        Account acc;
        Site_association__c site;
        scpq__SciQuote__c quote;
        if(ddr.Opportunity_Name__c!=null && oppMap!=null && oppMap.size()>0 && oppMap.containsKey(ddr.Opportunity_Name__c))
          opp = oppMap.get(ddr.Opportunity_Name__c);
        if(ddr.Account__c!=null  && accMap!=null && accMap.size()>0 && accMap.containsKey(ddr.Account__c))
          acc = accMap.get(ddr.Account__c);
                if(ddr.Site_Association__c!=null  && siteMap!=null && siteMap.size()>0 && siteMap.containsKey(ddr.Site_Association__c))
          site = siteMap.get(ddr.Site_Association__c);
          //added by samtu01 - US348460
          String s;
            if(quotemap!=null && quotemap.size()>0 && quotemap.get(ddr.Sterling_Quote__c )!=null)
            {
                if(quotemap.get(ddr.Sterling_Quote__c ).CA_Brief_Deal_Desc__c !=null)
                s=quotemap.get(ddr.Sterling_Quote__c ).CA_Brief_Deal_Desc__c;
                
                
                if(s!=null && s.containsIgnorecase('veracode')){ 
                    ddr.IsVeracode__c=true;
                    System.debug('---samtu01 - true ---'+ddr.IsVeracode__c); 
                }
               
                   
            }
        //added by samtu01 -US348460 --ends here
        //DDR - New Deal Desk Request - Queue-EMEA starts here.
        //if(ddr.CreatedBy!=null && opp!=null && opp.Rpt_Region__c=='EMEA'){
        if(opp!=null && opp.Rpt_Region__c=='EMEA'){  
                  system.debug('--entered emea queue---');
                    ddr.OwnerId = Label.DDR_EMEA_Queue_01;
        }
        //DDR - New Deal Desk Request - Queue-EMEA ends here.
        
        //DDR - Update Start Date starts
        //if(ddr.CreatedBy!=null){
                //    system.debug('--entered start date---');
          ddr.Start_Date__c = System.now();
        //}
        //DDR - Update Start Date ends
        
        //territory update with opp starts here
        if(opp!=null && opp.Opportunity_Number__c!=null){
                    system.debug('---entered territory update with opp----');
          ddr.Apttus_Geo__c = opp.Rpt_Region__c;
          ddr.Apttus_Operating_Area__c = opp.Rpt_Area__c;
          ddr.Apttus_Sales_Region__c = opp.Rpt_Territory_Country__c;
          ddr.Apttus_Territory__c = opp.Rpt_Country__c;
        }
        //territory update with opp ends here
        
        
        //
        if(ddr.Deal_Desk_Status__c!=null && ddr.Deal_Desk_Status__c=='Pending Sales Update - DD'){    
          ddr.Deal_Desk_Status__c='Updated – DD';
        }
        //salman
        if(ddr.Sales_Milestone__c!=null && (ddr.Sales_Milestone__c==Label.Opp_Stage_Closed_Won||ddr.Sales_Milestone__c==Label.Opp_Stage_Closed_Lost)){
          ddr.Deal_Desk_Status__c='Closed';
        }
        else if(ddr.Sales_Milestone__c!=null && (ddr.Sales_Milestone__c!=Label.Opp_Stage_Closed_Won||ddr.Sales_Milestone__c!=Label.Opp_Stage_Closed_Lost) && ddr.Deal_Desk_Status__c=='Closed'){
          ddr.Deal_Desk_Status__c='Updated – DD';
        }
        //salman
        
        
        
        //genise
        if(ddr.Approval_Start_Time__c==null && ddr.DDR_Approval_Count__c!=null && ddr.DDR_Approval_Count__c==1 && ddr.Previous_Hours_in_DDR__c!=null && ddr.Previous_Hours_in_DDR__c==0){
          ddr.Approval_Start_Time__c = system.now();
        }        
        //genise
        
        
        //process builder starts here.
        if(ddr.Sterling_Quote__c!=null){
            if(quoteMap!=null && quoteMap.size()>0 && quoteMap.containsKey(ddr.Sterling_Quote__c))
                quote = quoteMap.get(ddr.Sterling_Quote__c);
          if(opp!=null){
              ddr.Account__c = opp.AccountId;
              ddr.CurrencyIsoCode = opp.CurrencyIsoCode;
          }          
          ddr.Agreement_Category__c = 'Non-NDA Agreement';
          ddr.Street__c = 'Please refer to Sold To Address field for full address';
          if(quote!=null){
            ddr.Effective_Date__c = quote.CA_Effective_Date__c;
            ddr.Expiration_Date__c = quote.CA_Contract_End_Date__c;      
            ddr.Oppty_Amount__c = quote.CA_CPQ_Quote_Total__c;
            ddr.Sold_To_Name__c = quote.CA_Customer_Name_Sold_To__c;
            ddr.Sold_To__c = quote.CA_Sold_To_Id__c;
            
          }
          ddr.Account_Name3__c = ddr.Sold_To_Name__c;

          //sunji03 - territory change of operating area names in of "COMM" to "NA", using account's segment field to distinguish COMM and ENT
            if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Northeast;
                    }
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Southeast;
                    } 
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_West;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Northeast;
                    }   
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Southeast;
                    }     
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_West;
                    }
          //sunji03 - FY19 PS/CAN GEO is added. NA_PS/CAN operating area is split into "Public Sector", "Canada" and "PS_HQ"
          else if(ddr.Apttus_Operating_Area__c!=null && (ddr.Apttus_Operating_Area__c=='Public Sector' || ddr.Apttus_Operating_Area__c=='Canada' || ddr.Apttus_Operating_Area__c=='PS_HQ') && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){ 
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NA_PS/CAN' && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Public_Sector;
          } 
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Canada;
                    }                      
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_HQ' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_NA_HQ;
                    }                    
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Andean' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Andean;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_GCA;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Brazil' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Brazil;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Mexico' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Mexico_Caribbean_Cen_Amer;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='CEN' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_Central;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='STH' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            if (ddr.Apttus_Sales_Region__c=='France') //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
            {
                ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
            }
            else 
            {
              ddr.OwnerId = Label.DDR_Legal_EMEA_South;
            }
          }
          //sunji03 - FY19 UKI is moved to NTH operation area, so this condition is of no use
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='UKI' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            //ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          //}
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NTH' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          }
          //sunji03 - FY19, operating area "ASIA SOUTH" is changed to ASEAN
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ASEAN' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Asia_South;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ANZ' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Australia;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='GREATER CHINA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Greater_China;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='India' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_India;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Japan' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Japan;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Korea' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Korea;
          }
           //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='France' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
          //}
          
        }
        else if(ddr.Sterling_Quote__c==null && opp!=null && opp.Opportunity_Number__c!=null){
                                                                                
          ddr.Account__c=opp.AccountId;
          if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA'){
            ddr.Agreement_Category__c='NDA Agreement';
          }
          if((ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c!='NDA')||ddr.Deal_Desk_Request_Type__c==null){
            ddr.Agreement_Category__c='Non-NDA Agreement';
          }
          ddr.CurrencyIsoCode=opp.CurrencyIsoCode;
          ddr.Oppty_Amount__c=opp.Amount;
          ddr.Street__c='Please refer to Sold To Address field for full address';
          ddr.Account_Name3__c = opp.Account.Name;

          //sunji03 - territory change of operating area names in of "COMM" to "NA", using account's segment field to distinguish COMM and ENT
          if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Northeast;
                    }
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Southeast;
                    } 
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_West;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Northeast;
                    }   
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Southeast;
                    }     
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_West;
                    }
          //sunji03 - FY19 PS/CAN GEO is added. NA_PS/CAN operating area is split into "Public Sector", "Canada" and "PS_HQ"      
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NA_PS/CAN' && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          else if(ddr.Apttus_Operating_Area__c!=null && (ddr.Apttus_Operating_Area__c=='Public Sector' || ddr.Apttus_Operating_Area__c=='Canada' || ddr.Apttus_Operating_Area__c=='PS_HQ') && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Public_Sector;
          } 
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Canada;
                    }                      
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_HQ' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_NA_HQ;
                    }                                        
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Andean' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Andean;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_GCA;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Brazil' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Brazil;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Mexico' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Mexico_Caribbean_Cen_Amer;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='CEN' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_Central;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='STH' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            if (ddr.Apttus_Sales_Region__c=='France') //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
            {
                ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
            }
            else 
            {
              ddr.OwnerId = Label.DDR_Legal_EMEA_South;
            }
          }
          //sunji03 - FY19 UKI is moved to NTH operation area, so this condition is of no use
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='UKI' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          //}
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NTH' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          }
          //sunji03 FY19, operating area "ASIA SOUTH" is changed to ASEAN
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ASEAN' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Asia_South;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ANZ' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Australia;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='GREATER CHINA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Greater_China;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='India' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_India;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Japan' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Japan;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Korea' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Korea;
          }
          //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='France' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
          //}      
        }    
        else if(ddr.Sterling_Quote__c==null && ddr.Opportunity_Name__c==null && acc!=null){
          ddr.City__c = acc.BillingCity;
          ddr.Country__c = acc.BillingCountry;
          ddr.State__c = acc.BillingState;
          ddr.Street__c = acc.BillingStreet;
          ddr.Zip_Postal_Code__c = acc.BillingPostalCode;
          if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA'){
            ddr.Agreement_Category__c='NDA Agreement';
          }
          ddr.Apttus_Geo__c = acc.GEO__c;
          ddr.Apttus_Operating_Area__c = acc.Sales_Area__c;
          ddr.Apttus_Sales_Region__c = acc.Sales_Region__c;
          ddr.Apttus_Territory__c = acc.Region_Country__c;
          if((ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c!='NDA')||ddr.Deal_Desk_Request_Type__c==null){
            ddr.Agreement_Category__c='Non-NDA Agreement';
          }
          ddr.Account_Name3__c = acc.Name;
          ddr.DDR_field_update_complete__c = true;

          //sunji03 - territory change of operating area names in of "COMM" to "NA", using account's segment field to distinguish COMM and ENT
          if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Northeast;
                    }
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Southeast;
                    } 
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c == Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Commercial_West;
                    }
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Northeast;
                    }   
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Southeast;
                    }     
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c != Label.segmentVal3 && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_West;
                    }
          //sunji03 - FY19 PS/CAN GEO is added.
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NA_PS/CAN' && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          else if(ddr.Apttus_Operating_Area__c!=null && (ddr.Apttus_Operating_Area__c=='Public Sector' || ddr.Apttus_Operating_Area__c=='Canada' || ddr.Apttus_Operating_Area__c=='PS_HQ') && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){ 
          
            ddr.OwnerId = Label.DDR_Legal_Public_Sector;
          } 
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='PS_CANADA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_Canada;
                    }                      
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_HQ' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_NA_HQ;
                    }                                        
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Andean' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Andean;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_GCA;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Brazil' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Brazil;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Mexico' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_LA_Mexico_Caribbean_Cen_Amer;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='CEN' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_Central;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='STH' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            if (ddr.Apttus_Sales_Region__c=='France') //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
            {
                ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
            }
            else 
            {
              ddr.OwnerId = Label.DDR_Legal_EMEA_South;
            }
          }
          //sunji03 - FY19 UKI is moved to NTH operation area, so this condition is of no use
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='UKI' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          //}
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NTH' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          }
          //sunji03 - FY19 operating area "ASIA SOUTH" is changed to ASEAN
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ASEAN' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Asia_South;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ANZ' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Australia;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='GREATER CHINA' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Greater_China;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='India' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_India;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Japan' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Japan;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Korea' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Korea;
          }
          //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='France' && ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='NDA' && ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
          //}

        }
        
          
          //chajo30
          if(ddr.Salesforce_Quote__c != null){
              SBQQ__Quote__c sbquote = salesforceQuoteMap.get(ddr.Salesforce_Quote__c);
              ddr.Sold_To__c = sbquote.SoldTo_BPID__c;
              ddr.Expiration_Date__c = sbquote.End_Date_form__c;
          }
          //chajo30
        
        //update based on site association starts here
        if(site!=null && ddr.Sterling_Quote__c==null){
          ddr.Account_Name3__c = site.Name;
          ddr.City__c = site.City__c;
          ddr.Country__c = site.Country_Picklist__c;
          ddr.Sold_To__c = site.SAP_Site_ID__c;
          ddr.State__c = site.State__c;
          ddr.Street_2__c = site.Street2__c;
          ddr.Street_3__c = site.Street3__c;
          ddr.Street__c = site.Street__c;
          ddr.Zip_Postal_Code__c = site.Postal_Code__c;
        }    //update based on site association ends here
        else if(ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Non-Standard NDA'){

          //sunji03 - territory change of operating area names in of "COMM" to "NA", using account's segment field to distinguish COMM and ENT
          if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Northeast;
                    }
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Southeast;
                    } 
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_West;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Northeast;
                    }   
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Southeast;
                    }     
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_West;
                    }
          //sunji03 - FY19 PS/CAN GEO is added. NA_PS/CAN operating area is split into "Public Sector", "Canada" and "PS_HQ"
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NA_PS/CAN' && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA'){
          else if(ddr.Apttus_Operating_Area__c!=null && (ddr.Apttus_Operating_Area__c=='Public Sector' || ddr.Apttus_Operating_Area__c=='Canada' || ddr.Apttus_Operating_Area__c=='PS_HQ') && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA'){
            ddr.OwnerId = Label.DDR_Legal_Public_Sector;
          } 
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='PS_CANADA'){
            ddr.OwnerId = Label.DDR_Legal_Canada;
                    }                      
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_HQ'){
            ddr.OwnerId = Label.DDR_Legal_NA_HQ;
                    }                                        
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Andean'){
            ddr.OwnerId = Label.DDR_Legal_LA_Andean;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Brazil'){
            ddr.OwnerId = Label.DDR_Legal_LA_Brazil;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Mexico'){
            ddr.OwnerId = Label.DDR_Legal_LA_Mexico_Caribbean_Cen_Amer;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='LA_HQ'){
            ddr.OwnerId = Label.DDR_Legal_LA_HQ;
          }          
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='CEN'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_Central;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='STH'){
            if (ddr.Apttus_Sales_Region__c=='France') //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
            {
                ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
            }
            else 
            {
              ddr.OwnerId = Label.DDR_Legal_EMEA_South;
            }
          }
          //sunji03 - FY19 UKI is moved to NTH operation area, so this condition is of no use
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='UKI'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          //}
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NTH'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='EMEA_HQ'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_HQ;
          }
          //sunji03 FY19 operating area "ASIA SOUTH" is changed to ASEAN
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ASEAN'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Asia_South;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ANZ'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Australia;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='GREATER CHINA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Greater_China;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='India'){
            ddr.OwnerId = Label.DDR_Legal_APJ_India;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Japan'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Japan;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Korea'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Korea;
          }
        }
        else if(ddr.NDA_Type__c!=null && ddr.NDA_Type__c=='Standard NDA'){
          ddr.OwnerId = Label.DDR_GCA;
        }
        else if(ddr.SoldToAddress__c!=null && ddr.Sterling_Quote__c!=null){
            if(quoteMap!=null && quoteMap.size()>0 && quoteMap.containsKey(ddr.Sterling_Quote__c))
                quote = quoteMap.get(ddr.Sterling_Quote__c);
            if(quote!=null){
                ddr.Sold_To_Name__c = quote.CA_Customer_Name_Sold_To__c;
                ddr.Sold_To__c = quote.CA_Sold_To_Id__c;
            }         
        }
        //process builder ends
        
        //DDR -Deal Review - DDR NA Queue starts
        //sunji03 FY19 PS/CAN GEO is added, Joyce Harding confirms that we can use the same "DDR NA All" queue.
        if(ddr.Apttus_Geo__c!=null && (ddr.Apttus_Geo__c=='NA' || ddr.Apttus_Geo__c == 'PS/CAN') && ((ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c!='NDA') || ddr.Deal_Desk_Request_Type__c==null)){
          system.debug('--entered NA Queue---');
                    ddr.OwnerId = Label.DDR_NA_All;
        }
        //DDR -Deal Review - DDR NA Queue ends
        
        //DDR Status LA starts
        if(opp!=null && (opp.Rpt_Region__c=='LA' || (opp.Rpt_Territory_Country__c!=null && opp.Rpt_Territory_Country__c.contains('_LA')))){
          ddr.OwnerId = Label.DDR_LA_ALL;
        }
        //DDR Status LA ends
        
        //DDR – New Deal Desk Request – DDR APJ All starts
        if(opp!=null && (opp.Rpt_Region__c=='Asia-Pacific' || opp.Rpt_Region__c=='Japan' ||opp.Rpt_Region__c=='APJ')){
          system.debug('--------------------------'+ddr.OwnerId);
                    ddr.OwnerId = Label.DDR_APJ_ALL;
        }
        //DDR – New Deal Desk Request – DDR APJ All ends
                
                
      }
    }  
    
    
  
        if(Trigger.isUpdate){
            Site_Association__c site;  
            set<id> groupId=new Set<id>();
            Long Days;
            Double milliseconds,seconds;
            Decimal totaltime,Hours,minutes;

            for ( Deal_Desk_Review__c tmp : Trigger.New){
                accid.add(tmp.Account__c);
                if(Trigger.OldMap.get(tmp.Id).OwnerId <> Trigger.NewMap.get(tmp.Id).OwnerId) {
                    ownerIdSet.add (tmp.OwnerId);
                    //oldOwnerIdSet.add(Trigger.oldMap.get(tmp.Id).OwnerId);
                    mapid.put(Trigger.oldMap.get(tmp.Id).OwnerId,tmp.OwnerId);
                    
                }
                //added by samtu01 --US348460
                String s;
                if(quotemap!=null && quotemap.size()>0 && quotemap.get(tmp.Sterling_Quote__c )!=null)
                {
                if(quotemap.get(tmp.Sterling_Quote__c ).CA_Brief_Deal_Desc__c!=null)
                s=quotemap.get(tmp.Sterling_Quote__c ).CA_Brief_Deal_Desc__c;
                if(s!=null && s.containsIgnorecase('veracode')){ 
                    tmp.IsVeracode__c=true;
                    System.debug('---samtu01 - true ---'+tmp.IsVeracode__c);
                   
                }
                    else
                        tmp.IsVeracode__c=false;
                }
                //added by samtu01--US348460--ends here
            }


            if(mapid.size()>0){
                for(User tmpUser : [Select Id from User where Id IN :mapid.keySet() OR id IN:mapid.values()]) {
                    if(mapid.containsKey(tmpUser.id))
                        usersSet1.add(tmpUser.id);
                    if(ownerIdSet.contains(tmpUser.id))
                        usersSet.add(tmpUser.id);
                }
            }
            // List<User> usersList1 = [Select Id from User where Id IN :oldOwnerIdSet];
            
            for ( Deal_Desk_Review__c ddr : Trigger.New){
                
                if(ddr.Site_Association__c!=null && siteMap!=null && siteMap.size()>0 && siteMap.containsKey(ddr.Site_Association__c))
                    site = siteMap.get(ddr.Site_Association__c);
        
        //salman
        //BAJPI01 - US371878 - Fix error when sales milestone is blank
        if(ddr.Sales_Milestone__c!=null && ((ddr.Sales_Milestone__c==Label.Opp_Stage_Closed_Won && ((trigger.oldMap.get(ddr.Id).Sales_Milestone__c!=null &&
                                                     trigger.oldMap.get(ddr.Id).Sales_Milestone__c!=Label.Opp_Stage_Closed_Won)||
                                                     trigger.oldMap.get(ddr.Id).Sales_Milestone__c==null))||
        (ddr.Sales_Milestone__c==Label.Opp_Stage_Closed_Lost && trigger.oldMap.get(ddr.Id).Sales_Milestone__c!=Label.Opp_Stage_Closed_Lost))){
          ddr.Deal_Desk_Status__c='Closed';
        }
        else if(ddr.Sales_Milestone__c!=null && ddr.Deal_Desk_Status__c!=null && (ddr.Deal_Desk_Status__c=='Closed' && trigger.oldMap.get(ddr.Id).Sales_Milestone__c!=null &&
                        ((ddr.Sales_Milestone__c!=Label.Opp_Stage_Closed_Won && trigger.oldMap.get(ddr.Id).Sales_Milestone__c==Label.Opp_Stage_Closed_Won)|| 
                         (ddr.Sales_Milestone__c!=Label.Opp_Stage_Closed_Lost && trigger.oldMap.get(ddr.Id).Sales_Milestone__c==Label.Opp_Stage_Closed_Lost)))){
          ddr.Deal_Desk_Status__c='Updated – DD';
        }
        
        //BAJPI01 - US371878 - Fix error when sales milestone is blank
        //salman
        
                if(ddr.Deal_Desk_Status__c=='Pending Sales Update - DD'&& ddr.Sales_Comments__c!=trigger.oldMap.get(ddr.Id).Sales_Comments__c
                  && trigger.oldMap.get(ddr.Id).Deal_Desk_Status__c=='Pending Sales Update - DD'){    
                    ddr.Deal_Desk_Status__c='Updated – DD';
                }
        
                //genise
        if(ddr.Deal_Desk_Status__c=='Approved – DD' && trigger.oldMap.get(ddr.Id).Deal_Desk_Status__c!='Approved – DD'){
                  //ddr.Previous_Hours_in_DDR__c = ddr.Previous_Hours_in_DDR__c + (Integer.ValueOf(System.Now().date()-ddr.Approval_Start_Time__c.date())*24);
                    //BAJPI01 - adding Null Check.
                    if(ddr.Approval_Start_Time__c!=null){
                        days =  System.Now().date().daysBetween(ddr.Approval_Start_Time__c.date());
                        milliseconds = System.Now().getTime()- ddr.Approval_Start_Time__c.getTime();
                        seconds = milliseconds / 1000;
                        minutes = seconds / 60;
                        hours = minutes / 60;
                        if(ddr.Previous_Hours_in_DDR__c!=null)
                            ddr.Previous_Hours_in_DDR__c = ddr.Previous_Hours_in_DDR__c + hours;
                        else
                            ddr.Previous_Hours_in_DDR__c = hours;
                        
                        ddr.Approval_Start_Time__c = null;
                    }
        }
        else if(ddr.Deal_Desk_Status__c!='Approved – DD' && trigger.oldMap.get(ddr.Id).Deal_Desk_Status__c=='Approved – DD'){
          ddr.Approval_Start_Time__c = System.Now();
                    //BAJPI01 - adding Null Check.
                    if(ddr.DDR_Approval_Count__c!=null)
                  ddr.DDR_Approval_Count__c = ddr.DDR_Approval_Count__c + 1;
                else
                  ddr.DDR_Approval_Count__c = 1;
        }
        //genise
        
        if(Trigger.OldMap.get(ddr.Id).OwnerId <> Trigger.NewMap.get(ddr.Id).OwnerId) {
                    if(usersSet.contains(ddr.OwnerId) && !usersSet1.contains(Trigger.OldMap.get(ddr.Id).OwnerId)) {
                        ddr.Deal_Desk_Status__c = 'Assigned – DD';
                    }                    
                }
        
        //Create NDA Agreement starts here
        if(ddr.Create_Agreement__c==true && ddr.Agreement_Record_Type__c!=null && ddr.Agreement_Record_Type__c=='NDA' && ddr.Agreement__c==null){
          ddr.Create_Agreement__c =  false;
          ddr.Create_Agreement_Lock__c = true;
          
          Apttus__APTS_Agreement__c apptusagrmt = new Apttus__APTS_Agreement__c();
          
          apptusagrmt.Apttus__Account__c = ddr.Account__c;
          apptusagrmt.Apttus__Contract_End_Date__c = ddr.Expiration_Date__c;
          apptusagrmt.Apttus__Contract_Start_Date__c = ddr.Effective_Date__c;
          apptusagrmt.Apttus__Requestor__c = ddr.CreatedById;
          apptusagrmt.CA_Account_Name__c = ddr.Account_Name3__c; 
          apptusagrmt.CA_Is_Legacy_Contract__c=Label.CA_No;
          apptusagrmt.CA_Agreement_End_Date__c = ddr.AgreementEndDateLcl__c;
          apptusagrmt.CA_Agreement_Start_Date_Lcl__c = ddr.AgreementStartDateLcl__c;
          apptusagrmt.CA_Agreement_Sub_Type__c = ddr.Agreement_Sub_Type__c;
          apptusagrmt.CA_Agreement_Type__c = 'NDA';
          apptusagrmt.CA_City_Lcl__c = ddr.City_lcl__c;
          apptusagrmt.CA_City__c = ddr.City__c;
          apptusagrmt.CA_Country_Lcl__c = ddr.Country_lcl__c;
          apptusagrmt.CA_Country__c = ddr.Country__c;
          apptusagrmt.CA_Customer_Name_Lcl__c = ddr.Customer_Name_Lcl__c;
          apptusagrmt.CA_DDR__c =  ddr.id;
          apptusagrmt.CA_Geo__c = ddr.Apttus_Geo__c;
          apptusagrmt.CA_Language__c = ddr.Contract_Language__c;
          apptusagrmt.CA_NDA_Flag__c = ddr.NDA_Type__c;    //NDA Flag which field is this???
          apptusagrmt.CA_Operating_Area__c = ddr.Apttus_Operating_Area__c  ;
          apptusagrmt.CA_Opportunity__c = ddr.Opportunity_Name__c;
          apptusagrmt.CA_Sales_Comments__c = ddr.Sales_Comments__c;
          apptusagrmt.CA_Sales_Region__c = ddr.Apttus_Sales_Region__c;
          apptusagrmt.CA_Sales_Territory__c = ddr.Apttus_Territory__c;
          apptusagrmt.CA_Sold_To_Id__c = ddr.Sold_To__c;
          apptusagrmt.CA_State_Lcl__c   = ddr.Statelcl__c;
          apptusagrmt.CA_State__c = ddr.State__c;
          apptusagrmt.CA_Street_Lcl__c = ddr.Street_lcl__c;
          apptusagrmt.CA_Street__c = ddr.Street__c;
          apptusagrmt.CA_Zip_Code__c = ddr.Zip_Postal_Code__c;
                    if(ddr.Account_Name3__c!=null){
                        if(ddr.Account_Name3__c.length()>80)
                            apptusagrmt.Name = ddr.Account_Name3__c.subString(0,80);
                        else
                            apptusagrmt.Name = ddr.Account_Name3__c;
                    }
          apptusagrmt.OwnerId = ddr.OwnerId;
          apptusagrmt.RecordTypeId = Label.NDA_Record_Type_Id;
          apptusagrmt.Tops_Site_Id_Sold_To_Id__c = ddr.Site_Association__c;
          
          agreementsOnddrUpdation.agreementlist.add(apptusagrmt);
                    system.debug('----size-----'+agreementsOnddrUpdation.agreementlist.size());
        }    //Create NDA Agreement ends here
        
        //Create Master Agreement starts here
        else if(ddr.Create_Agreement__c==true && ddr.Agreement_Record_Type__c!=null && ddr.Agreement_Record_Type__c=='Master' && ddr.Agreement__c==null){
          ddr.Create_Agreement__c =  false;
          ddr.Create_Agreement_Lock__c = true;
          
          Apttus__APTS_Agreement__c apptusagrmt = new Apttus__APTS_Agreement__c();
          
          apptusagrmt.Apttus__Account__c = ddr.Account__c;
          apptusagrmt.Apttus__Contract_End_Date__c = ddr.Expiration_Date__c;
          apptusagrmt.Apttus__Contract_Start_Date__c = ddr.Effective_Date__c;
          apptusagrmt.Apttus__Requestor__c = ddr.CreatedById;
          apptusagrmt.Apttus__Total_Contract_Value__c = ddr.Total_Agreement_Value__c;
          apptusagrmt.CA_Account_Name__c = ddr.Account_Name3__c;
          apptusagrmt.CA_Is_Legacy_Contract__c=Label.CA_No;
          apptusagrmt.CA_Agreement_End_Date__c = ddr.AgreementEndDateLcl__c;
          apptusagrmt.CA_Agreement_Start_Date_Lcl__c = ddr.AgreementStartDateLcl__c;
          apptusagrmt.CA_Agreement_Sub_Type__c = ddr.Agreement_Sub_Type__c;
          apptusagrmt.CA_Agreement_Type__c = 'Foundation/Module';
          apptusagrmt.CA_City_Lcl__c = ddr.City_lcl__c;
          apptusagrmt.CA_City__c = ddr.City__c;          
          apptusagrmt.CA_Country_Lcl__c = ddr.Country_lcl__c;
          apptusagrmt.CA_Country__c = ddr.Country__c;
          apptusagrmt.CA_Customer_Name_Lcl__c = ddr.Customer_Name_Lcl__c;
          apptusagrmt.CA_DDR__c =  ddr.id;
          apptusagrmt.CA_Geo__c = ddr.Apttus_Geo__c;
          apptusagrmt.CA_Language__c = ddr.Contract_Language__c;  
          apptusagrmt.CA_Operating_Area__c = ddr.Apttus_Operating_Area__c  ;
          apptusagrmt.CA_Opportunity__c = ddr.Opportunity_Name__c;
          apptusagrmt.CA_Sales_Comments__c = ddr.Sales_Comments__c;
          apptusagrmt.CA_Sales_Region__c = ddr.Apttus_Sales_Region__c;
          apptusagrmt.CA_Sales_Territory__c = ddr.Apttus_Territory__c;
          apptusagrmt.CA_Sales_Type__c = ddr.Type__c;
          apptusagrmt.CA_Sold_To_Id__c = ddr.Sold_To__c;
          apptusagrmt.CA_State_Lcl__c   = ddr.Statelcl__c;
          apptusagrmt.CA_State__c = ddr.State__c;
          apptusagrmt.CA_Street_Lcl__c = ddr.Street_lcl__c;
          apptusagrmt.CA_Street__c = ddr.Street__c;
          apptusagrmt.CA_Zip_Code__c = ddr.Zip_Postal_Code__c;
                    if(ddr.Account_Name3__c!=null){
                        if(ddr.Account_Name3__c.length()>80)
                            apptusagrmt.Name = ddr.Account_Name3__c.subString(0,80);
                        else
                            apptusagrmt.Name = ddr.Account_Name3__c;
                    }
          apptusagrmt.OwnerId = ddr.OwnerId;
          apptusagrmt.RecordTypeId = Label.Master_Record_Type_Id;
          apptusagrmt.Sterling_Quote__c = ddr.Sterling_Quote__c;
          apptusagrmt.Tops_Site_Id_Sold_To_Id__c = ddr.Site_Association__c;
          
          agreementsOnddrUpdation.agreementlist.add(apptusagrmt);
          
        }    //Create Master Agreement ends here
        
       //Create Transaction Agreement starts here
                //added by Jagan for SAlesfroce quote
                else if(ddr.Create_Agreement__c==true && ddr.Agreement_Record_Type__c!=null && ddr.Agreement_Record_Type__c=='Transaction'
                        && ddr.Agreement__c==null && (ddr.Sterling_Quote__c!=null || ddr.Salesforce_Quote__c !=null)){
                    ddr.Create_Agreement__c =  false;
                    ddr.Create_Agreement_Lock__c = true;
                    scpq__SciQuote__c quote =new scpq__SciQuote__c();
                    if(ddr.Sterling_Quote__c!=null)
                    quote = quoteMap.get(ddr.Sterling_Quote__c);
                    Opportunity opp = oppMap.get(ddr.Opportunity_Name__c);
                    Apttus__APTS_Agreement__c apptusagrmt = new Apttus__APTS_Agreement__c();
                    
                    apptusagrmt.Apttus__Account__c = ddr.Account__c;
                    apptusagrmt.Apttus__Contract_End_Date__c = ddr.Expiration_Date__c;
                    apptusagrmt.Apttus__Contract_Start_Date__c = ddr.Effective_Date__c;
                    if(quote!=null){
                    apptusagrmt.Apttus__Requestor__c = quote.CPQ_Quote_Creator_Id__c;
                    apptusagrmt.Apttus__Total_Contract_Value__c = quote.CA_CPQ_Quote_Total__c;
                            }
                    apptusagrmt.CA_Is_Legacy_Contract__c=Label.CA_No;
                    apptusagrmt.CA_Account_Name__c = ddr.Account_Name3__c;
                    apptusagrmt.CA_Agreement_Sub_Type__c = ddr.Agreement_Sub_Type__c;
                    apptusagrmt.CA_Agreement_Type__c = ddr.Agreement_Type__c;
                    apptusagrmt.CA_City__c = ddr.City__c;
                    apptusagrmt.CA_Country__c = ddr.Country__c;
                    apptusagrmt.CA_DDR__c =  ddr.id;
                    apptusagrmt.CA_Geo__c = ddr.Apttus_Geo__c;
                    apptusagrmt.CA_Language__c = ddr.Contract_Language__c;  
                    apptusagrmt.CA_Operating_Area__c = ddr.Apttus_Operating_Area__c ;
                    apptusagrmt.CA_Opportunity__c = ddr.Opportunity_Name__c;
                    apptusagrmt.CA_Sales_Comments__c = ddr.Sales_Comments__c;
                    apptusagrmt.CA_Sales_Region__c = ddr.Apttus_Sales_Region__c;
                    apptusagrmt.CA_Sales_Territory__c = ddr.Apttus_Territory__c;
                    apptusagrmt.CA_Sales_Type__c = opp.Type;
                    apptusagrmt.CA_State__c = ddr.State__c;
                    apptusagrmt.CA_Street__c = ddr.Street__c;
                    apptusagrmt.CA_Zip_Code__c = ddr.Zip_Postal_Code__c;
                    if(ddr.Opportunity_Name__c!=null)
                        apptusagrmt.CurrencyIsoCode = opp.CurrencyIsoCode;
                    if(ddr.Account_Name3__c!=null){
                        if(ddr.Account_Name3__c.length()>80)
                            apptusagrmt.Name = ddr.Account_Name3__c.subString(0,80);
                        else
                            apptusagrmt.Name = ddr.Account_Name3__c;
                    }   
                    apptusagrmt.OwnerId = ddr.OwnerId;
                    apptusagrmt.RecordTypeId = Label.Transaction_Record_Type_Id;
                    if(ddr.Sterling_Quote__c!=null)
                    apptusagrmt.Sterling_Quote__c = ddr.Sterling_Quote__c;
                            else if(ddr.Salesforce_Quote__c!=null){
                          apptusagrmt.SF_Quote__c = ddr.Salesforce_Quote__c;      
                            }
                    agreementsOnddrUpdation.agreementlist.add(apptusagrmt);
                            
                }       //Create Transaction Agreement ends here
        
        //Create Transaction Trails starts here
        else if(ddr.Create_Agreement__c==true && ddr.Sterling_Quote__c==null && ddr.Agreement_Record_Type__c!=null && ddr.Agreement_Record_Type__c=='Transaction'){
          ddr.Create_Agreement__c =  false;
          ddr.Create_Agreement_Lock__c = true;
          Opportunity opp;
          
          if(oppMap!=null && oppMap.size()>0 && oppMap.containsKey(ddr.Opportunity_Name__c))
            opp = oppMap.get(ddr.Opportunity_Name__c);
        
          Apttus__APTS_Agreement__c apptusagrmt = new Apttus__APTS_Agreement__c();
          
          apptusagrmt.Apttus__Account__c = ddr.Account__c;
          apptusagrmt.Apttus__Contract_End_Date__c = ddr.Expiration_Date__c;
          apptusagrmt.Apttus__Contract_Start_Date__c = ddr.Effective_Date__c;
          apptusagrmt.Apttus__Requestor__c = ddr.Opportunity_Owner__c; 
          apptusagrmt.Apttus__Total_Contract_Value__c = ddr.Oppty_Amount__c;
          apptusagrmt.CA_Account_Name__c = ddr.Account_Name3__c;
          apptusagrmt.CA_Agreement_Sub_Type__c = ddr.Agreement_Sub_Type__c;
            apptusagrmt.CA_Is_Legacy_Contract__c=Label.CA_No;
          apptusagrmt.CA_Agreement_Type__c = 'Trial';
          apptusagrmt.CA_City__c = ddr.City__c;
          apptusagrmt.CA_Country__c = ddr.Country__c;
          apptusagrmt.CA_DDR__c =  ddr.id;
          apptusagrmt.CA_Geo__c = ddr.Apttus_Geo__c;
          apptusagrmt.CA_Language__c = ddr.Contract_Language__c;  
          apptusagrmt.CA_Operating_Area__c = ddr.Apttus_Operating_Area__c  ;
          apptusagrmt.CA_Opportunity__c = ddr.Opportunity_Name__c;
          apptusagrmt.CA_Sales_Comments__c = ddr.Sales_Comments__c;
          apptusagrmt.CA_Sales_Region__c = ddr.Apttus_Sales_Region__c;
          apptusagrmt.CA_Sales_Territory__c = ddr.Apttus_Territory__c;
          apptusagrmt.CA_Sales_Type__c = ddr.Type__c;
          apptusagrmt.CA_Sold_To_Id__c = ddr.Sold_To__c;
          apptusagrmt.CA_State__c = ddr.State__c;
          apptusagrmt.CA_Street__c = ddr.Street__c;
          apptusagrmt.CA_Zip_Code__c = ddr.Zip_Postal_Code__c;
          if(opp!=null)
            apptusagrmt.CurrencyIsoCode = opp.CurrencyIsoCode;
          if(ddr.Account_Name3__c!=null){
            if(ddr.Account_Name3__c.length()>80)
                apptusagrmt.Name = ddr.Account_Name3__c.subString(0,80);
            else
                apptusagrmt.Name = ddr.Account_Name3__c;
          }              
          apptusagrmt.OwnerId = ddr.OwnerId;
          apptusagrmt.RecordTypeId = Label.Transaction_Record_Type_Id;
          apptusagrmt.Tops_Site_Id_Sold_To_Id__c = ddr.Site_Association__c;
          
          agreementsOnddrUpdation.agreementlist.add(apptusagrmt);
        }    //Create Transaction Trials ends here
        
        
        //process builder starts
        //update based on site association starts here
        //chajo30 
        if(ddr.Salesforce_Quote__c != null){
          SBQQ__Quote__c sbquote = salesforceQuoteMap.get(ddr.Salesforce_Quote__c);
          if(sbquote!=null && sbquote.SoldTo_BPID__c!=null)
            ddr.Sold_To__c = sbquote.SoldTo_BPID__c;
        }
        //end chajo30 

        if((site!=null && ddr.Site_Association__c!=null && ddr.Sterling_Quote__c==null)||(ddr.Sterling_Quote__c==null && ((ddr.Site_Association__c!=null && ddr.Site_Association__c!=trigger.oldMap.get(ddr.Id).Site_Association__c) ||(ddr.Site_Association__c!=null && trigger.oldMap.get(ddr.Id).Site_Association__c==null) ))){
          ddr.Account_Name3__c = site.Name;
          ddr.City__c = site.City__c;
          ddr.Country__c = site.Country_Picklist__c;
          //chajo30
          if(ddr.Sold_To__c == null || ddr.Sold_To__c == ''){
            ddr.Sold_To__c = site.SAP_Site_ID__c;
          }
          //end chajo30      
          ddr.State__c = site.State__c;
          ddr.Street_2__c = site.Street2__c;
          ddr.Street_3__c = site.Street3__c;
          ddr.Street__c = site.Street__c;
          ddr.Zip_Postal_Code__c = site.Postal_Code__c;
        }    //update based on site association ends here
        else if(ddr.NDA_Type__c!=null && ddr.NDA_Type__c!=trigger.oldMap.get(ddr.Id).NDA_Type__c && ddr.NDA_Type__c=='Non-Standard NDA'){

        system.debug('update case' + ddr.account_segment__c);

        //sunji03 - territory change of operating area names in of "COMM" to "NA", using account's segment field to distinguish COMM and ENT
          if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Northeast;
                    }
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_Southeast;
                    } 
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c == Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Commercial_West;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_NE' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Northeast;
                    }   
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_CEN' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Central;
                    }  
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_SE' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_Southeast;
                    }     
                    else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_WEST' && ddr.account_segment__c != Label.segmentVal3){
            ddr.OwnerId = Label.DDR_Legal_Enterprise_West;
                    }
          //sunji03 - FY19 PS/CAN GEO is added. NA_PS/CAN operating area is split into "Public Sector", "Canada" and "PS_HQ"
          else if(ddr.Apttus_Operating_Area__c!=null && (ddr.Apttus_Operating_Area__c=='Public Sector' || ddr.Apttus_Operating_Area__c == 'Canada' || ddr.Apttus_Operating_Area__c == 'PS_HQ')  && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA'){
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NA_PS/CAN' && ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c != 'PS_CANADA'){
            ddr.OwnerId = Label.DDR_Legal_Public_Sector;
          } 
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='PS_CANADA'){
            ddr.OwnerId = Label.DDR_Legal_Canada;
                    }                      
          else if(ddr.Apttus_Sales_Region__c !=null && ddr.Apttus_Sales_Region__c =='NA_HQ'){
            ddr.OwnerId = Label.DDR_Legal_NA_HQ;
                    }                                                         
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Andean'){
            ddr.OwnerId = Label.DDR_Legal_LA_Andean;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Brazil'){
            ddr.OwnerId = Label.DDR_Legal_LA_Brazil;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Mexico'){
            ddr.OwnerId = Label.DDR_Legal_LA_Mexico_Caribbean_Cen_Amer;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='LA_HQ'){
            ddr.OwnerId = Label.DDR_Legal_LA_HQ;
          }          
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='CEN'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_Central;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='STH'){
             if (ddr.Apttus_Sales_Region__c=='France') //sunji03 - FY19 France is changed to sales region and not operating area, operating area is STH, so move this logic into STH section
            {
                ddr.OwnerId = Label.DDR_Legal_EMEA_FRA;
            }
            else 
            {
              ddr.OwnerId = Label.DDR_Legal_EMEA_South;
            }
          }
          //sunji03 - FY19 UKI is moved to NTH operation area, so this condition is of no use
          //else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='UKI'){
          //  ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          //}
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='NTH'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_UK_North;
          }
          else if(ddr.Deal_Desk_Request_Type__c!=null && ddr.Deal_Desk_Request_Type__c=='EMEA_HQ'){
            ddr.OwnerId = Label.DDR_Legal_EMEA_HQ;
          }
          //sunji03 FY19 operating area "ASIA SOUTH" to ASEAN
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ASEAN'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Asia_South;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='ANZ'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Australia;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='GREATER CHINA'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Greater_China;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='India'){
            ddr.OwnerId = Label.DDR_Legal_APJ_India;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Japan'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Japan;
          }
          else if(ddr.Apttus_Operating_Area__c!=null && ddr.Apttus_Operating_Area__c=='Korea'){
            ddr.OwnerId = Label.DDR_Legal_APJ_Korea;
          }
        }
        else if(ddr.NDA_Type__c!=null && ddr.NDA_Type__c!=trigger.oldMap.get(ddr.Id).NDA_Type__c && ddr.NDA_Type__c=='Standard NDA'){
          ddr.OwnerId = Label.DDR_GCA;
        }
        else if(ddr.SoldToAddress__c!=trigger.oldMap.get(ddr.Id).SoldToAddress__c && ddr.Sterling_Quote__c!=null){
            scpq__SciQuote__c quote;
            if(quoteMap!=null && quoteMap.size()>0 && quoteMap.containsKey(ddr.Sterling_Quote__c)){
                quote = quoteMap.get(ddr.Sterling_Quote__c);
            }
            if(quote!=null){
                ddr.Sold_To_Name__c = quote.CA_Customer_Name_Sold_To__c;
                ddr.Sold_To__c = quote.CA_Sold_To_Id__c;
            }               
        }               
        }
        
        //process builder ends
            }  
        }
    
    
  if(Trigger.isAfter){
    if(Trigger.isUpdate){
        if(agreementsOnddrUpdation.agreementlist!=null && agreementsOnddrUpdation.agreementlist.size()>0){
            system.debug('----size-----'+agreementsOnddrUpdation.agreementlist.size());
            insert agreementsOnddrUpdation.agreementlist;
        }
          
        }
  }
  
    
}