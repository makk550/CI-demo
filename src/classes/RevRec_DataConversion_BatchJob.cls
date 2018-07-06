/* 
 * Batch job to create Opportunity Line Items for existing Active Contract Line Items
 * US410669 
 * merha02
 
*/

global class RevRec_DataConversion_BatchJob implements Database.Batchable<sObject> {
	
    global Database.QueryLocator start(Database.BatchableContext bc){ 
      
        Set<String> opp_type = new Set<String>{'Renewal','Renewal w/Products','Renewal w/Education','Renewal w/Education & Support','Renewal w/Products, Services, Education & Support','Renewal w/Products, Services & Education','Renewal w/Products, Services & Support','Renewal w/Products & Education','Renewal w/Products & Services','Renewal w/Products & Support'};

        Set<String> openStageName =new Set<String>{'10% - Identification & Qualification','20% - Researching','30% - Solution Design','40% - Plan Confirmed','60% - Proposal','60% - Initial Proposal','80% - Preliminary Agreement','90% - Agreement Finalized'};
        Set<String> closedStageName =new Set<String>{'100% - Contract Signed','Closed - Lost'};
         
       List<String> oppids= new List<String>();
    	oppids.addAll(Label.opportunityIds.split(','));
    	Set<Id> oppidSet = new Set<Id>( (List<Id>) oppids );
        String query;
        String recordTypeName ='New Opportunity';
        query = 'SELECT Id, Name,currencyisocode,Opportunity_Type__c,StageName, (SELECT Id,Name,Active_Contract_Product__c,UnitPrice,Start_Date__c,End_Date__c,RevRec_Conversion__c FROM OpportunityLineItems where Active_Contract_Product__c!=null and Active_Contract_Line_Item__c=null and RevRec_Conversion__c=false) FROM Opportunity where ((Opportunity_Type__c IN: opp_type) and ((StageName IN: openStageName) OR (StageName IN: closedStageName and CloseDate>2017-09-30)) and RevRec_BatchJob_Conversion__c = false and RecordType.Name=:recordTypeName and id NOT IN: oppidSet) ';    
        return Database.getQueryLocator(query);
    }
    
    //to do the processing for each chunk of data
    global void execute(Database.BatchableContext bc,List<Opportunity> oppList){
        
        OpportunityHandler.renewalToOppConversion = true; //to skip primary contact validation.
        
        Map<Id,Set<Id>> opportunityACPMap = new Map<Id,Set<Id>>(); // map each opp id with their acp ids
        Set<Id> Active_Contract_Product_Id =new Set<Id>(); 	// acp ids for all opp
        Map<Id,List<date>> DateMap=new Map<Id,List<date>>();	// map of acp and opp line items list of start date,end date
        Set<String> currencyset = new Set<String>();		// set of all currencies in opp
        Map<id,OpportunityLineItem> acpOliMap=new Map<id,OpportunityLineItem>();	// map of acp id and oli details
        List<OpportunityLineItem> newOppLineItem = new List<OpportunityLineItem>(); //list of new OLI
        List<Opportunity> oppsWithNoLineItems = new list<Opportunity>();	// list of Opps with no OLI

        
        if(oppList!=null && oppList.size()>0){
             for(Opportunity o :oppList){	// for each opp
            System.debug('--------opportunity-------'+o);
                List<OpportunityLineItem> oliList = o.OpportunityLineItems; // get the opp line items
                Set<Id> temp_ACP_Id =new Set<Id>();	
                currencyset.add(o.CurrencyIsoCode); // set of all currencies in opp
                
                if(oliList!=null && oliList.size()>0){
                    for(OpportunityLineItem oli : oliList){
                        System.debug('--------'+oli.RevRec_Conversion__c+'-----------');
                        temp_ACP_Id.add(oli.Active_Contract_Product__c); // acp ids for each opp
                       
                        acpOliMap.put(oli.Active_Contract_Product__c,oli); // map of acp id and oli details
                        Active_Contract_Product_Id.add(oli.Active_Contract_Product__c); // acp ids for all opp
                        
                        // map of acp and opp line items list of start date,end date
                        DateMap.put(oli.Active_Contract_Product__c,new List<Date>{oli.Start_Date__c});
                        DateMap.get(oli.Active_Contract_Product__c).add(oli.End_Date__c);
                    }
                
                
               		 opportunityACPMap.put(o.Id, temp_ACP_Id); // map each opp id with their acp ids
               }
                 else{
				   o.RevRec_BatchJob_Conversion__c = true;
				   oppsWithNoLineItems.add(o);
                     System.debug('--------opportunity with no OLI-------'+o);
				   
			   }
               System.debug('---opp maps created-----');
            
       		}
            
            Map<Id,Active_Contract_Product__c> acProd;
            List<Active_Contract_Line_Item__c> acliItems;
            // queries to retrieve Active Contract Product and Active Contract Line Items for ACP ids of all opp 
            if(Active_Contract_Product_Id!=null && Active_Contract_Product_Id.size()>0){
                 acProd=getACP(Active_Contract_Product_Id); // returns map of acp id and it's acp for all opp acp ids
                 System.debug('---acp---'+acProd);
                 acliItems=getACLI(Active_Contract_Product_Id); // returns acli for all acp ids of all opp
                 System.debug('----acli----'+acliItems);
            
            }
            // map of acli id and its acli details
            Map<id,Active_Contract_Line_Item__c> acliMap=new Map<id,Active_Contract_Line_Item__c>(); 
            if(acliItems!=null && acliItems.size()>0){
                for(Active_Contract_Line_Item__c actvli : acliItems){
                	acliMap.put(actvli.id,actvli);
            	}
            }
            
           // set of product ids for all opp acp ids
            Set<Id> prodIds=new Set<Id>(); 
            if(acProd!=null && acProd.size()>0){
                for(Id aId :acProd.keySet()){
                Active_Contract_Product__c a = acProd.get(aId);
                prodIds.add(a.Product__c);
           	 }
                System.debug('-------Product ids-------'+prodIds);
            }
            
            // to retrieve the price book entries for all product ids
            String keyId;
            Map<String,PricebookEntry> ACPProd = new Map<String,PricebookEntry>();  //([Select Id,Name From PricebookEntry where Product2Id  in : prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]);
            if(prodIds!=null && prodIds.size()>0){
                for(PricebookEntry p : [Select Id,Name,Product2Id,CurrencyIsoCode,product2.Commissionable_BU__c From PricebookEntry where Product2Id in :prodIds and Pricebook2.Name='CA Product List' and IsActive =:true  and CurrencyIsoCode IN : currencyset]){
                    keyId=p.Product2Id+p.CurrencyIsoCode;
                    ACPProd.put(keyId,p);
                }  
               System.debug('-------Pricebook entries-------'+ACPProd); 
            } 
            // map of acp id and its list of acli
            Map<Id,List<Active_Contract_Line_Item__c>> acpliMap=new Map<Id,List<Active_Contract_Line_Item__c>>();
            if(acliItems!=null && acliItems.size()>0){
                for(Active_Contract_Line_Item__c acli : acliItems){
                    if(acpliMap.containsKey(acli.Contract_Product__c)){
                        acpliMap.get(acli.Contract_Product__c).add(acli);
                    }
                    else{
                        acpliMap.put(acli.Contract_Product__c,new List<Active_Contract_Line_Item__c> {acli});
                    }
                }
            }
            
            // for each opportunity
            for(Opportunity opp : oppList){ 
                 System.debug('-----for each opp-----'+opp);
                String currencyIsoCode=opp.currencyisocode;
                if(opportunityACPMap!=null && opportunityACPMap.size()>0){
                    
                    // get the set of acp ids for Oppportunity
                      Set<Id> acpIdSet=opportunityACPMap.get(opp.id); 
                    
               		  if(acpIdSet!=null && acpIdSet.size()>0){
                   
                        	for(Id acpId: acpIdSet){ // for each acp id
                                
                                if(acpOliMap!=null && acpOliMap.size()>0 && acpOliMap.containsKey(acpId)){
                                    
                                    OpportunityLineItem OldOppli=acpOliMap.get(acpId); // get its existing oli details
                                    if(acProd!=null && acProd.size()>0){
                                        
                                         Active_Contract_Product__c acp=acProd.get(acpId); // get corresponding acp details of existing oli
                                         if(acp!=null){
                                            String product=acp.Product__c;
                                            //String currencyIsoCode=opp.currencyisocode;
                                            String key=product+currencyIsoCode;
                                            
                                           // String RenewalName= acp.Product__r.Name;
                                            String RenewalName= acp.Name; 
                                            String RenewalproductName= acp.Active_Contract__r.Name;
                                            system.debug('----renewal prod name----'+RenewalproductName);
                                            String segment;
                                            String cbuValue;
                                            If(acp.Segmentation__c =='HT'||acp.Segmentation__c =='MT'||acp.Segmentation__c =='LT'||acp.Segmentation__c =='NT'){
                                                segment=acp.Segmentation__c;  
                                            }
                                            else{ 
                                                segment = acp.Pre_Segmentation__c; 
                                            }
                                            
                                            if(RenewalName!=null && RenewalName.length()>30)
                                                RenewalName = RenewalName.Substring(0,30);
                                            if(RenewalproductName !=null && RenewalproductName.length()>50)
                                                RenewalproductName =RenewalproductName.Substring(0,50);   
                                            
                                            system.debug('----renewal prod name----'+RenewalproductName);
                                            // get cbu value from price book entry
                                           if(ACPProd != null && ACPProd.size() > 0){
                                               if(ACPProd.containsKey(key)){
                                                   if(ACPProd.get(key)!=null){
                                                        cbuValue = ACPProd.get(key).product2.Commissionable_BU__c; 
                                                   }
                                               }
                                               
                                           }
                                            
                                            Date startDate;
                                            Date endDate;
                                             if(DateMap!=null && DateMap.size()>0){
                                                  List<Date> dateList = DateMap.get(acp.id); // get date list for acp
                                                    if(dateList!=null && dateList.size()>0){
                                                        startDate=dateList[0];
                                                        endDate = dateList[1];
                                                    }
                                             }
                                             Decimal Term_Month;
                                             Integer Duration_Days;
                                              if(startDate!=null && endDate!=null){
                                                       Term_Month =ARRandDurationCalculation.monthsbetweendates(startDate,endDate);
                                                        Duration_Days = startDate.daysBetween(endDate)+1;      
                                              }
                                           
                                            if(acpliMap!=null && acpliMap.size()>0){
                                                
                                               // get list of active contract line items for each acp
                                               List<Active_Contract_Line_Item__c> aclList=acpliMap.get(acp.id); 
                                               if(aclList!=null && aclList.size()>0){
                                                
                                                // for each active contract line item
                                                for(Active_Contract_Line_Item__c acli : aclList){ 
                                                    System.debug('----creating new opp-----');
                                                    
                                                    // create new opportunity line item 
                                                    OpportunityLineItem newoppli=new OpportunityLineItem(
                                                        Business_Type__c = 'Renewal',
                                                        CA_Contract_Product_Name__c = RenewalproductName +'-'+RenewalName,
                                                        Active_Contract_Product__c = acli.Contract_Product__c,
                                                        Active_Contract_Line_Item__c =acli.ID,
                                                        Active_Contract__c=acli.Contract_Product__r.Active_Contract__c,
                                                        Opportunityid = opp.id,
                                                        Raw_Maintenance__c=acli.Raw_Maintenance_LC__c,
                                                        ATTRF__c=acli.Orig_ATTRF_LC__c,
                                                        Baseline_ATTRF_LC__c = acli.Baseline_ATTRF_LC__c,        
                                                        Old_TRR__c=acli.AOCV__c,
                                                        License__c = acli.License_Type_Text__c,
                                                        Segmentation__c = segment ,
                                                        Original_Expiration_Date__c = acli.Dismantling_Date__c,
                                                        Original_Deal_Term_Months__c= acli.Install_Dismantle_Duration_months__c,
                                                        New_Deal_Term_Months__c = acli.Contract_Product__r.Renewal_Product__r.Projected_Time_Duration_Months__c,
                                                        Original_CV__c= acli.OCV__c,
                                                        Offerings_Family__c = acli.Contract_Product__r.Product__r.Family, 
                                                       // Original_Contract_IDs__c= acli.Sales_Document__c
                                                        Original_Contract_IDs__c= acli.Contract_Product__r.Active_Contract_Number__c,
                                                        TARR__c =acli.Material_TARR_LC__c,
                                                        List_Price_License_LC__c= acli.List_Price_License_LC__c, //US424951
                           								List_Price_Maintenance_LC__c =acli.List_Price_Maintenance_LC__c //US424951
                                                    );
                                                   
                                               /*     if(acli.Projected_Renewal_Value__c!=null) 
                                                        newoppli.UnitPrice =acli.Projected_Renewal_Value__c;
                                                    else
                                                        newoppli.UnitPrice =0;
                                                */
                                                    
                                                     // if null values, avoid default unit price to be 1
                                                    if(OldOppli.UnitPrice!=null && OldOppli.UnitPrice!=0 && acp.ATTRF_CRV__c!=null && acp.ATTRF_CRV__c!=0 && acli.Orig_ATTRF_LC__c!=null && acli.Orig_ATTRF_LC__c!=0 && acli.Renewal_Valuation_Type__c!='Invalid-EOL-No Replacement Product' && acli.Renewal_Valuation_Type__c!='Invalid - Federal Rebook'){
                                                        newoppli.UnitPrice=(OldOppli.UnitPrice/acp.ATTRF_CRV__c)*acli.Orig_ATTRF_LC__c;
                                                    }
                                                    else{
                                                        newoppli.UnitPrice=0;
                                                    }
                                                    newoppli.Stretch__c=newoppli.UnitPrice;                                                    
                                                    newoppli.Start_Date__c=startDate;
                                                    newoppli.End_Date__c=endDate;
                                                    newoppli.Term_Month__c = Term_Month;
                                                    newoppli.Duration_Days__c = Duration_Days;
                                                    // calculate ARR
                                                    newoppli.Stretch_Duration__c= newoppli.Term_Month__c;
                                                    if(ACPProd != null && ACPProd.size() > 0 && ACPProd.get(key)!=null){
                                                        System.debug('---Pricebook entry id----'+ACPProd.get(key).id);
                                                         System.debug('---Product id----'+ACPProd.get(key).Product2Id);
                                                        newoppli.PricebookEntryId= ACPProd.get(key).id;
                                                    }
                                                    
                                                    
                                                    newOppLineItem.add(newoppli);
                                                   
                                                }
                                                
                                            }
                                               
                                           }
                                            
                                    
                       					}
                                    }
                                }
                                
            		  		}
                    	
                    
                	}
              
                }
              
            }
            Map<id,id> acpMap=new Map<id,id>();
            List<Database.SaveResult> results=new List<Database.SaveResult>();
            // Database.SaveResult[] results = new Database.SaveResult[]{};
           // Set<id> newIds=new Set<id>();
            Boolean resultstatus;
            if(newOppLineItem.size()>0){
                System.debug('-----In insert if block------');
                results = Database.Insert(newOppLineItem, true);
                resultstatus = false;
                for (Database.SaveResult sr : results) {
                    if (sr.isSuccess()) {
                        resultstatus = true;
                       // newIds.add(sr.getId());
                    }
                    else{
                        resultstatus = false;
                    }
                }
            }
            else{
                System.debug('-----In insert else block------');
                resultstatus=true;
            }
            
            if(resultstatus == true){
                System.debug('----In resultstatus----');
               Set<id> acpIds=new Set<id>();
               Set<id> newOppIds=new Set<id>();
                Map<id,id> acliOliMap=new Map<id,id>();
                
                if(newOppLineItem!=null && newOppLineItem.size()>0){
                    System.debug('-----In new oppline item block------');
                    for(OpportunityLineItem ol : newOppLineItem){
                        acpIds.add(ol.Active_Contract_Product__c);
                        newOppIds.add(ol.Opportunityid);
                        if(ol.Active_Contract_Line_Item__c!=null){
                             acliOliMap.put(ol.Active_Contract_Line_Item__c,ol.id);
                        }
                       
               		}
                }
               
                // to update ACLI with Opportunity Product
				List<Active_Contract_Line_Item__c> updatedAcli=new List<Active_Contract_Line_Item__c>();
                if(acliOliMap!=null && acliOliMap.size()>0){
                    System.debug('-----To update opp prod in acli------');
                     for(id acliId : acliOliMap.keySet()){
                        Active_Contract_Line_Item__c acli =acliMap.get(acliId);
                        acli.Opportunity_Product__c=acliOliMap.get(acliId);
                   		updatedAcli.add(acli);
                        
                    }
                    if(updatedAcli!=null && updatedAcli.size()>0){
                        update updatedAcli;
                    }
                }
               
                // to update check box on OLI
                Set<OpportunityLineItem> oldOppLineItemsSet=new Set<OpportunityLineItem>();
                List<OpportunityLineItem> tempoldOppLineItemsList = new List<OpportunityLineItem>();
                if(acpIds!=null && acpIds.size()>0){
                    System.debug('-----In acpIds block------');
                     for(id acpId : acpIds){
                        OpportunityLineItem oli=acpOliMap.get(acpId);
                        oli.RevRec_Conversion__c=true;
                        oldOppLineItemsSet.add(oli);
               		 }
                }
                
                tempoldOppLineItemsList.addAll(oldOppLineItemsSet);
                if(tempoldOppLineItemsList!=null && tempoldOppLineItemsList.size()>0){
                   System.debug('-----To update check box on OLI------');
                    System.debug('--------old opportunity line items list-------'+tempoldOppLineItemsList);
                   update tempoldOppLineItemsList;
                }
                
              // to update check box on Opportunity if all of its OLI are processed  
              List<Opportunity> updatedOppList=new List<Opportunity>();
               Boolean flag;
               List<Opportunity> newOppList=[select Id,RevRec_BatchJob_Conversion__c,(select Id,RevRec_Conversion__c,Active_Contract_Product__c from OpportunityLineItems where Active_Contract_Product__c!=null and Active_Contract_Line_Item__c=null) from Opportunity where id in : newOppIds  ];
               Set<Opportunity> updateOpp = new Set<Opportunity>();
                if(newOppList!=null && newOppList.size()>0){
                    for(Opportunity oppo : newOppList){
                        flag=false;
                        List<OpportunityLineItem> updatedOppliList=oppo.OpportunityLineItems;
                        if(updatedOppliList!=null && updatedOppliList.size()>0){
                        for(OpportunityLineItem oppli : updatedOppliList){
                            if(oppli.RevRec_Conversion__c==true){
                                flag=true;
                            }
                            else{
                                flag=false;
                                break;
                            }
                        }
                        System.debug('---flag value---'+flag);
                        if(flag==true){
                           oppo.RevRec_BatchJob_Conversion__c=true;
                            System.debug('------Opportunity------'+oppo);
                            updateOpp.add(oppo);
                           // updatedOppList.add(oppo);
                        }
                    }
                	}
                }
                if(oppsWithNoLineItems.size()>0){
                    System.debug('----No OLI------');
                    updateOpp.addAll(oppsWithNoLineItems);
                    System.debug('---opps with no OLI----'+oppsWithNoLineItems);
                }  
               
                 System.debug('-----opps to be updated-----'+updatedOppList);
                   // updateOpp.addAll(oppsWithNoLineItems);
				updatedOppList.addAll(updateOpp);
                System.debug('-----opps added to updated-----'+updatedOppList);
                    if(updatedOppList!=null && updatedOppList.size()>0 ){
                         update updatedOppList;
                    }
               
                
               
            }   
           
            
            
           
        }
       
        
    }
    
    
    global Map<Id,Active_Contract_Product__c> getACP(Set<Id> Active_Contract_Product_Id){
        return new Map<Id,Active_Contract_Product__c>([select 	Id,Name,
                Sales_Price__c, 
                Converted_To_Opportunity__c,
                Dismantle_Date__c,
                Active_Contract__c, 
                AOCV__c, 
                OCV__c, 
                ATTRF_CRV__c,
                Product_Baseline_ATTRF_LC__c,  
                Segmentation__c, 
                Pre_Segmentation__c,
                Raw_Maint_Calc_LC__c, 
                Projected_Renewal_Calc__c, 
                Active_Contract_Number__c, 
                Renewal_Product__r.Renewal__r.Name,
                Renewal_Product__r.Projected_Time_Duration_Months__c,
                Active_Contract__r.Name,
                Active_Contract__r.Contract_Term_Months__c, 
                Product__c, 
                Product__r.Name, 
                Product__r.Family
                from Active_Contract_Product__c where Id in: Active_Contract_Product_Id ]);
    }
    global List<Active_Contract_Line_Item__c> getACLI(Set<Id> Active_Contract_Product_Id){
        return [select ID,        Raw_Maintenance_LC__c,
                Orig_ATTRF_LC__c,
                Baseline_ATTRF_LC__c,
                AOCV__c,
                Renewal_Valuation_Type__c,
                Sales_Price__c,
                Dismantling_Date__c,
                List_Price_License_LC__c,
                List_Price_Maintenance_LC__c,
                Opportunity_product__c,
                Install_Dismantle_Duration_months__c,
                OCV__c,
                Sales_Document__c,
                License_Type_Text__c,
                Material_TARR_LC__c,
                Product_Material__c,
                Sales_Document_Item__c,
                Contract_Product__c,                                                                 
                Contract_Product__r.name,
                Projected_Renewal_Value__c,                     
                Contract_Product__r.Converted_To_Opportunity__c,
                Contract_Product__r.Active_Contract__c,
                Contract_Product__r.ATTRF_CRV__c,
                Contract_Product__r.Product_Baseline_ATTRF_LC__c,  
                Contract_Product__r.Segmentation__c, 
                Contract_Product__r.Pre_Segmentation__c,
                Contract_Product__r.Raw_Maint_Calc_LC__c, 
                Contract_Product__r.Projected_Renewal_Calc__c, 
                Contract_Product__r.Active_Contract_Number__c, 
                Contract_Product__r.Renewal_Product__r.Renewal__r.Name,
                Contract_Product__r.Renewal_Product__r.Projected_Time_Duration_Months__c,
                Contract_Product__r.Active_Contract__r.Name,
                Contract_Product__r.Active_Contract__r.Contract_Term_Months__c, 
                //Contract_Product__r.Product__c, 
                Contract_Product__r.Sales_Price__c ,
                Contract_Product__r.Product__r.Name, 
                Contract_Product__r.Product__r.Family
                from Active_Contract_Line_Item__c where Contract_Product__c in: Active_Contract_Product_Id];
    }
    
    // for pre processing operations - called after batch job is finished
    global void finish(Database.BatchableContext bc){
         // Get the ID of the AsyncApexJob representing this batch job
       // from Database.BatchableContext.
       // Query the AsyncApexJob object to retrieve the current job's information.
       AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
          TotalJobItems, CreatedBy.Email
          FROM AsyncApexJob WHERE Id =
          :BC.getJobId()];
       // Send an email to the Apex job's submitter notifying of job completion.
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Apex Sharing Recalculation ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}