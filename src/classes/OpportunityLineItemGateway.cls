/* SAMAP01      21/8/2017       US384301          Optimized Trigger to avoid SOQL 101 error
* ********************************************************************************************/
public class OpportunityLineItemGateway{
    public static Map<Id,Opportunity> opportunitiesToUpdate = new Map<Id,Opportunity>();
    public static Map<Id,PricebookEntry> pbeMap;
    public static Map<Id,Opportunity> oppMap;
    public static List<String> xmlStrings;
    public static decimal oppSalesPrice;
    public static Map<Id,List<String>> oppId_ProductGroup_Map = new Map<Id,List<String>>();
    public static Map<String,Decimal> isoCodeToConversionRate=new Map<String,Decimal>();
    
     public static Map<Id,Product2> sbProductMap;
    public static Set<Id> sbProductIDSet = new Set<Id>();
    public static set<Id> updateOppIds = new Set<Id>();
    
    public static string steelBrickRecType;
  

    
    public static void loadOpportunityLineItemBulkValues(){
        List<OpportunityLineItem> lstTrigger;
        Set<Id> priceBookEntryIdSet=new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        Map<Id,String> acpIdMap = new Map<Id,String>();
        Set<Id> oliDelOppIds = new Set<Id>();
        List<OpportunityLineItem> bpOliList = new List<OpportunityLineItem>();
        RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
        
        if(sbRecType!=null)
            steelBrickRecType = sbRecType.RecordType_Id__c;
        
        if(trigger.isDelete)
            lstTrigger = Trigger.Old;
        else
            lstTrigger = Trigger.New;
        for(OpportunityLineItem oli: lstTrigger){
            system.debug('TestlstTrigger'+lstTrigger);
            system.debug('testOppId'+oli.opportunityId);
            OpportunityLineItem oldOli;
            if(Trigger.isUpdate)
                oldOli = (OpportunityLineItem)Trigger.OldMap.get(oli.id);
            
            priceBookEntryIdSet.add(oli.PricebookEntryId);
            
            system.debug('TestbeforeOppIds'+oppIds);
            oppIds.add(oli.opportunityId);
            system.debug('TestafterOppIds'+oppIds);
            
            //OppLIAttachDetachRenewals
            if(Trigger.isDelete && Trigger.isAfter){
                
                if(oli.Business_Type__C == 'Renewal'){
                    oliDelOppIds.add(oli.OpportunityId);
                    if(oli.Active_Contract_Product__c != null)
                        acpIdMap.put(oli.Active_Contract_Product__c,'Renewal');
                }
                else if(oli.Active_Contract_Product__c != null){
                    acpIdMap.put(oli.Active_Contract_Product__c,'Non Renewal');
                }
            }
            if(Trigger.isAfter && (Trigger.isInsert || (Trigger.isUpdate  && (oli.business_type__c != oldOli.business_type__c || oli.TotalPrice != oldOli.TotalPrice || oli.Stretch_Corporate_ARR__c!=oldOli.Stretch_Corporate_ARR__c||oli.Corporate_ARR__c!=oldOli.Corporate_ARR__c|| oli.UF_License_Fee__c!=oldOli.UF_License_Fee__c||oli.License__c!=oldOli.License__c)) || Trigger.isDelete))
            {
                updateOppIds.add(oli.OpportunityId);
            }
            if(Trigger.isBefore && (Trigger.isInsert || (Trigger.isUpdate  && oli.Product_Group__c != oldOli.Product_Group__c)))
            {
                bpOliList.add(oli);
                
            }
            
			//BAJPI01 - for Tensor - whenever line items are inserted from SF CPQ Quote Line items.
            if(Trigger.isBefore && (Trigger.isInsert||Trigger.isUpdate) && oli.SBQQ__QuoteLine__c!=null){
                sbProductIDSet.add(oli.Product2Id);
            }
            //BAJPI01 - for Tensor - whenever line items are inserted from SF CPQ Quote Line items.
            
        }
        system.debug('---------------------'+pricebookentryidset);
        if(priceBookEntryIdSet!=null && priceBookEntryIdSet.size()>0)
          pbeMap = new Map<id,PricebookEntry>([Select id,name,Product2Id,Product2.Upfront_Revenue_Eligible__c,Product2.name,Product2.CSU2__c,Product2.Product_Group__c,Product2.Market_Focus_Area__c from PricebookEntry where id in :priceBookEntryIdSet]);//Product2.Market_Focus_Area__c  Added in Query for ILT for FY16 by YEDRA01
        system.debug('pbeMap---------------'+pbeMap);
         System.debug(LoggingLevel.ERROR, 'samap01 2 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
  if(oppIds!=null && oppIds.size()>0)
        oppMap = new Map<id,Opportunity>([Select Id,Deal_Registration_Program__c,Source__C,Deal_Registration_Program__r.Partner_Friendly_Name__c,Deal_Program__c,CurrencyIsoCode,
                                          AccountID,CloseDate,CreatedDate,Type,Account.GU_DUNS_NUMBER__c,Projected_renewal__C,Partner_Sales_Price__c,Sales_Coverage_Business_Unit__c,
                                          Deal_Registration_Status__c,Driving_Sales_Coverage_Business_Unit__c,Reseller_Product_Name__c,Reseller_Estimated_Value__c,RecordTypeId,
                                          Reseller__c,Partner__c,StageName,Rpt_Country__c, SBQQ__Renewal__c,SBQQ__PrimaryQuote__c,Slipped_Deal__c,Finance_Valuation_Status__c,//chajo30
                                          MinMaxError__c,Deal_Registration_Program__r.Min_Deal_Value__c,Deal_Registration_Program__r.Max_Deal_Value__c,Deal_Registration_Program__r.CurrencyIsoCode,
                                          Has_Primary_Quote__c,Total_ARR_License_Fee__c,Account.Account_Type__c,Rpt_Area__c,Stretch_Deal_Term_Months__c,ARR_Capacity_Upsell__c,Header_TARR_Old_SFDC__c,ARR_New_Product__c,ARR_Renewal__c,Start_Date__c,End_Date__c,TotalARRStretch__c,HasOpportunityLineItem
                                          FROM Opportunity where id IN :oppIds]);
        system.debug('oppMap---------------'+oppMap);
         System.debug(LoggingLevel.ERROR, 'samap01 3 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
         if(sbProductIDSet!=null && sbProductIDSet.size()>0){
             if(sbProductMap==null)
              sbProductMap = new Map<Id,Product2>([Select id,Commissionable_BU__c,Market_Focus_Area__c,Maintenance_Product__c,
                                                     CA_License_Type__c from Product2 where Id in:sbProductIDSet]);
        }
        
        //Adding for 3186 -
        
            System.debug('$$$5 Entering 4');
            for(Opportunity o : oppMap.values()){
                if(opportunitiesToUpdate.containsKey(o.Id)){
                    Opportunity o1 = opportunitiesToUpdate.get(o.Id);
                    System.debug('o1:'+o1);
                    String o1_dealRegPgmName = o1.Deal_Registration_Program__r.Partner_Friendly_Name__c;
                    if(o.Deal_Program__c != o1_dealRegPgmName){
                        System.debug('$$$5 Adding opp o to map opportunitiesToUpdate');
                        opportunitiesToUpdate.put(o.id,o);
                    }
                }
            }
            //Ponse01===============Start======================
        if((Trigger.isAfter && Trigger.isInsert) || (Trigger.isBefore && Trigger.isDelete)){
            
            Map<id,id> oppIdprodNameMap=new Map<id,id>();
            
            
            Set<id> dealRegOppId=new Set<id>();
            
            List<DealRegProductHistory__c> prodhistlist=new List<DealRegProductHistory__c>();

            for(Opportunitylineitem opl: lstTrigger){
                
                oppIdprodNameMap.put(opl.Opportunityid,opl.Product2Id);
                if(oppMap.get(opl.opportunityid)!=null&&(oppMap.get(opl.opportunityid).Source__C=='Deal Registration' || oppMap.get(opl.opportunityid).Source__C=='Partner')&&DealRegHistoryFlag.delRegDeleteFlag==false){
                    dealRegOppId.add(opl.opportunityid);
                    
                }
                
            }
            
            
            if(dealRegOppId.size()>0){
                System.debug(LoggingLevel.ERROR, 'samap01 5 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
                for(DealRegistrationApproved__c dlra:[select id,IsLatest__c,Opportunity_Name__c from DealRegistrationApproved__c where Opportunity_Name__c=:dealRegOppId]){
                    if(dlra.IsLatest__c== true){
                        DealRegProductHistory__c drprodhistory= new DealRegProductHistory__c();
                        drprodhistory.DealRegistrationApprovedHistory__c=dlra.id;
                        drprodhistory.Product__c=oppIdprodNameMap.get(dlra.Opportunity_Name__c );
                        if(Trigger.isInsert){
                            drprodhistory.Operation__c='Added';
                        }else if(Trigger.isDelete){
                            
                            drprodhistory.Operation__c='Removed';
                        }
                        prodhistlist.add(drprodhistory);
                        
                    }
                    
                }
                System.debug(LoggingLevel.ERROR, 'samap01 6 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
                if(prodhistlist.size()>0){
                    insert prodhistlist;
                    
                }
                
            }
            
        }
     //Ponse01===============End======================   
       
        //to populate the map to update opportunity, after every insertion/deletion of line items.
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isDelete)){
            for(Opportunity o : oppMap.values()){
                
                if(!opportunitiesToUpdate.containsKey(o.Id))
                    opportunitiesToUpdate.put(o.id,o);
                
            }
        }
        
        //NewLogoTrigger
        if(Trigger.isInsert && Trigger.isAfter){
            Map<Id,List<OpportunityLineItem>> oppOliMap = new Map<Id,List<OpportunityLineItem>>();
            for(OpportunityLineItem oli: lstTrigger){
            
            
            
            System.debug('Opportunity Created Today---------'+oppMap.get(oli.OpportunityId).createdDate+'============='+Date.today()+'---------'+oppMap.get(oli.OpportunityId).createdDate.date().isSameDay(Date.today()));                     System.debug('Opportunity Created Today---------'+oppMap.get(oli.OpportunityId).createdDate+'============='+Date.today()+'---------'+oppMap.get(oli.OpportunityId).createdDate.isSameDay(Date.today()));
                if(oppMap.get(oli.OpportunityId).createdDate.date().isSameDay(Date.today())){
               
                    if(!oppOliMap.containsKey(oli.OpportunityId)){
                        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                        oliList.add(oli);
                        oppOliMap.put(oli.OpportunityId,oliList);
                    }else{
                        List<OpportunityLineItem> oliList = oppOliMap.get(oli.OpportunityId);
                        oliList.add(oli);
                        oppOliMap.put(oli.OpportunityId,oliList);
                    }
                }
            }
            xmlStrings = new List<String>();
            for(Id oppId : oppOliMap.keySet()){
                Opportunity prepOpp = oppMap.get(oppId);
                String createdDate = ''+prepOpp.CreatedDate.date();
                String closedDate = ''+prepOpp.CloseDate;
                createdDate = createdDate.replace(' 00:00:00', '');            
                closedDate = closedDate.replace(' 00:00:00', '');            
                String xmlString = '<opportunity><id>'+prepOpp.Id+'</id><createDate>'+createdDate+'</createDate>';
                xmlString = xmlString + '<closeDate>'+closedDate+'</closeDate><opportunityProducts>';
                List<OpportunityLineItem> oliList = oppOliMap.get(oppId);
                for(OpportunityLineItem oli : oliList)
                    xmlString = xmlString + '<opportunityProduct><id>'+oli.id+'</id><gbu2>'+pbeMap.get(oli.PricebookEntryId).Product2.CSU2__c+'</gbu2></opportunityProduct>';
                xmlString = xmlString + '</opportunityProducts><accountId>';
                xmlString = xmlString + prepOpp.AccountId + '</accountId><globalParentId>';
                xmlString = xmlString + prepOpp.Account.GU_DUNS_NUMBER__c + '</globalParentId></opportunity>';
                xmlStrings.add(xmlString);
                System.debug('xmlString is ' + xmlString);
            }
        }
        
        //UniqueValue_BusinessUnit_Oppr
        //BAJPI01 US454113 - Missing SCBU on Opp header
        if(Trigger.isAfter){
            if(updateOppIds.size()>0){
               
                for(Id oppId : updateOppIds){
					if(!opportunitiesToUpdate.containsKey(oppId))
						opportunitiesToUpdate.put(oppid,getOpportunitytoUpdate(oppId));
                    
                }
            }
        }
        //BAJPI01 US454113 - Missing SCBU on Opp header
        
        //BusinessPlanFocus
        if(Trigger.isBefore && !Trigger.isDelete){
            if(bpOliList.size()>0){
                Set<String> openOppStageNameSet = new Set<String>{Label.Opp_Stage_10_Percent,Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,
                                                                Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent};
                List<Opportunity> oppList = new List<Opportunity>();
                for(OpportunityLineItem oli : bpOliList){
                    
                    System.debug('test1------------'+pbeMap+'test2------------------'+oli.Pricebookentryid+'test3'+oli);
                    system.debug('TestoppMap'+oppMap);
                          system.debug('samap01 oli.OpportunityId' +oli);
                    if(openOppStageNameSet.contains((oppMap.get(oli.OpportunityId).StageName)))
                        oppList.add(oppMap.get(oli.OpportunityId));
                    if(pbeMap.size()>0){
                        if(!oppId_ProductGroup_Map.containsKey(oli.OpportunityId)){
                            oppId_ProductGroup_Map.put(oli.OpportunityId,new List<String>());
                            
                            oppId_ProductGroup_Map.get(oli.OpportunityId).add(pbeMap.get(oli.PriceBookEntryId).Product2.Product_Group__c);
                        }else{
                            oppId_ProductGroup_Map.get(oli.OpportunityId).add(pbeMap.get(oli.PriceBookEntryId).Product2.Product_Group__c);
                        }
                    }
                }
                if(oppList.size()>0){
                    processOpportunityLineItems(oppList,bpOliList);
                }
            }
        }
    }
    
    public static Opportunity getOpportunitytoUpdate(Id oppId){
        Opportunity opp;
        if(opportunitiesToUpdate.containsKey(oppId))
            opp = opportunitiesToUpdate.get(oppId);
        else    
            opp = oppMap.get(oppId);
        return opp;    
    }
    
    public static string calculateOpportunityType(set<string> setType)
    {
    system.debug('TestsetType:'+setType);

        if(setType == null || setType.size() == 0) //Empty StrType if no family -type associated
            return '';
        string strtype = '';
                system.debug('Teststrtype:'+strtype);
        if(setType.size() == 1)
        { 
            system.debug('TestsetType1:'+setType);
            if(setType.contains('Product'))
                strtype = 'PNCV';
            else if(setType.contains('Renewal'))
                strtype = 'Renewal';
            else if(setType.contains('Services'))
                strtype = 'Services';
            else if(setType.contains('Support'))
                strtype = 'Support';
            else if(setType.contains('Education'))
                strtype = 'Standalone Education';
                                system.debug('TestFinalstrtype:'+strtype);
        }
        else if(setType.size() == 2)
        {
                system.debug('TestsetType2:'+setType);

                if(setType.contains('Product') && setType.contains('Renewal'))
                     strtype = 'Renewal w/Products';
                else if(setType.contains('Product') && setType.contains('Services'))
                     strtype = 'PNCV w/Services';
                else if(setType.contains('Product') && setType.contains('Support'))
                     strtype = 'PNCV w/Support';
                else if(setType.contains('Product') && setType.contains('Education'))
                     strtype = 'PNCV w/Education';
                else if(setType.contains('Renewal') && setType.contains('Services'))
                     strtype = 'Renewal w/Services';
                else if(setType.contains('Renewal') && setType.contains('Support'))
                     strtype = 'Renewal w/Support';
                else if(setType.contains('Renewal') && setType.contains('Education'))
                     strtype = 'Renewal w/Education';
                else if(setType.contains('Services') && setType.contains('Education'))
                     strtype = 'Services w/Education';
                else if(setType.contains('Education') && setType.contains('Support'))
                     strtype = 'Education w/Support';
                else if(setType.contains('Services') && setType.contains('Support'))
                     strtype = 'Services w/Support';
                        system.debug('Teststrtype2:'+strtype);
        }
       else if(setType.size() == 3)
       { 
                system.debug('TestsetType3:'+setType);       

                if(setType.contains('Product') && setType.contains('Renewal') && setType.contains('Services'))
                    strtype = 'Renewal w/Products & Services';
                else if(setType.contains('Product') && setType.contains('Renewal') && setType.contains('Support'))
                    strtype = 'Renewal w/Products & Support';
                else if(setType.contains('Product') && setType.contains('Renewal') && setType.contains('Education'))
                    strtype = 'Renewal w/Products & Education';
                else if(setType.contains('Product') && setType.contains('Services') && setType.contains('Support'))
                    strtype = 'PNCV w/Services & Support';
                else if(setType.contains('Product') && setType.contains('Services') && setType.contains('Education'))
                    strtype = 'PNCV w/Services & Education';
                else if(setType.contains('Product') && setType.contains('Support') && setType.contains('Education'))
                    strtype = 'PNCV w/Education & Support';
                else if(setType.contains('Renewal') && setType.contains('Services') && setType.contains('Support'))
                    strtype = 'Renewal w/Services & Support';
                else if(setType.contains('Renewal') && setType.contains('Services') && setType.contains('Education'))
                    strtype = 'Renewal w/Services & Education';
                else if(setType.contains('Renewal') && setType.contains('Support') && setType.contains('Education'))
                    strtype = 'Renewal w/Education & Support';
                else if(setType.contains('Services') && setType.contains('Support') && setType.contains('Education'))
                    strtype = 'Services w/Education & Support';
                        system.debug('Teststrtype3:'+strtype);
        }
        else
        { 
                system.debug('TestsetType4:'+setType);   

                if(setType.contains('Product') && setType.contains('Services') && setType.contains('Support') && setType.contains('Education') && !setType.contains('Renewal'))
                    strtype = 'PNCV w/Services, Education & Support';
                else if(setType.contains('Renewal') && setType.contains('Services') && setType.contains('Support') && setType.contains('Education') && !setType.contains('Product'))
                    strtype = 'Renewal w/Services, Education & Support';
                else if(setType.contains('Renewal') && setType.contains('Services') && setType.contains('Product') && setType.contains('Education') && !setType.contains('Support'))
                    strtype = 'Renewal w/Products, Services & Education';
                else if(setType.contains('Renewal') && setType.contains('Support') && setType.contains('Product') && setType.contains('Education')&& !setType.contains('Services'))
                    strtype = 'Renewal w/Products, Education & Support';
                else if(setType.contains('Renewal') && setType.contains('Support') && setType.contains('Product') && setType.contains('Services')&& !setType.contains('Education'))
                    strtype = 'Renewal w/Products, Services & Support';
                else if(setType.contains('Product') && setType.contains('Renewal') && setType.contains('Services') && setType.contains('Support') && setType.contains('Education'))
                    strtype = 'Renewal w/Products, Services, Education & Support';
                system.debug('Teststrtype4:'+strtype);    
        }
        return strType;      
    }
    
    public static void processOpportunityLineItems(List<Opportunity> oppList,List<OpportunityLineItem> oliList){
        //List<opportunity> oppList = [select Id,Type,Reseller__c,AccountId,Partner__c from opportunity where Id IN: OppIds AND StageName IN: OpenOppStageNameSet];
        //Set<Id> Account_Id_Set = new Set<Id>();
        Map<Id,String> AccountId_RTM_Map = new Map<Id,String>();
        Map<Id,List<Opportunity>> AccountId_OppList_Map = new Map<Id,List<Opportunity>>();
        
        
        if(oppList != null && oppList.size()>0){
            System.debug('+++++oppList++++++'+oppList);
            for(Opportunity opp:oppList){
                if((opp.Type == '1 Tier' || opp.Type == '2 Tier') && opp.Reseller__c != null){
                    //Account_Id_Set.add(opp.Reseller__c);
                    AccountId_RTM_Map.put(opp.Reseller__c,'Solution Provider');
                    if(!AccountId_OppList_Map.containskey(opp.Reseller__c)){
                        AccountId_OppList_Map.put(opp.Reseller__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Reseller__c).add(opp);
                    }else{
                        AccountId_OppList_Map.put(opp.Reseller__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Reseller__c).add(opp);
                    }
                        
                }
                if(opp.Type == 'xSP' && opp.AccountId != null){
                    //Account_Id_Set.add(opp.AccountId);
                    AccountId_RTM_Map.put(opp.AccountId,'Service Provider');
                    if(!AccountId_OppList_Map.containskey(opp.AccountId)){
                        AccountId_OppList_Map.put(opp.AccountId,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.AccountId).add(opp);
                    }else{
                        AccountId_OppList_Map.put(opp.AccountId,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.AccountId).add(opp);
                    }
                }
                if(opp.Type == 'Direct' && opp.Partner__c != null){
                    //Account_Id_Set.add(opp.Partner__c);
                    AccountId_RTM_Map.put(opp.Partner__c,'Service Provider');
                    if(!AccountId_OppList_Map.containskey(opp.Partner__c)){
                        AccountId_OppList_Map.put(opp.Partner__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Partner__c).add(opp);
                    }else{
                        AccountId_OppList_Map.put(opp.Partner__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Partner__c).add(opp);
                    }
                }
                       if(!AccountId_OppList_Map.containskey(opp.Reseller__c)){
                        AccountId_OppList_Map.put(opp.Reseller__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Reseller__c).add(opp);
                    }
                    else{
                        AccountId_OppList_Map.put(opp.Reseller__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Reseller__c).add(opp);
                    }
            }
            
            
            System.debug('+++++AccountId_OppList_Map++++++'+AccountId_OppList_Map);
             System.debug(LoggingLevel.ERROR, ' 11 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
            List<Route_To_Market__c> RTMList = [select Id,Account__c,RTM__c from Route_To_Market__c where RTM__c IN: AccountId_RTM_Map.values() AND Account__c IN: AccountId_RTM_Map.keySet()];
            System.debug('+++++RTMList++++++'+RTMList);
            Set<Id> RTMIdSet = new Set<Id>();
            if(RTMList != null && RTMList.size()>0){
                for(Route_To_Market__c rtm:RTMList){
                    if(AccountId_RTM_Map.get(rtm.Account__c)==rtm.RTM__c){
                        RTMIdSet.add(rtm.Id);
                    }
                }
            }
            
            System.debug('+++++RTMIdSet++++++'+RTMIdSet);
             System.debug(LoggingLevel.ERROR, ' 12 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
            Map<Id,Map<String,boolean>> OppId_ProductGroup_BPF_Map = new Map<Id,Map<String,boolean>>();
            List<Product_Alignment__c> productAlignmentList = [select Id,Business_Plan__c,Related_Account__c,Product_Group__c from Product_Alignment__c where Route_To_Market__c IN: RTMIdSet];
            System.debug('+++++productAlignmentList++++++'+productAlignmentList);
            if(productAlignmentList != null && productAlignmentList.size()>0){
                for(Product_Alignment__c PA:productAlignmentList){
                    System.debug('+++++PA++++++'+PA);
                    if(AccountId_OppList_Map.containsKey(PA.Related_Account__c)){
                        System.debug('+++++111++++++');
                        for(Opportunity op:AccountId_OppList_Map.get(PA.Related_Account__c)){
                            System.debug('+++++op.Id++++++'+op.Id);
                            if(oppId_ProductGroup_Map.containsKey(op.Id)){
                                System.debug('+++++222++++++');
                                for(String prodGroup:oppId_ProductGroup_Map.get(op.Id)){
                                    System.debug('+++++prodGroup++++++'+prodGroup);
                                    System.debug('+++++PA.Business_Plan__c++++++'+PA.Business_Plan__c);
                                    System.debug('++++++++PA.Product_Group__c+++++++'+PA.Product_Group__c);
                                    if(prodGroup.equalsIgnoreCase(PA.Product_Group__c) && PA.Business_Plan__c){
                                        System.debug('+++++333++++++');
                                        if(!OppId_ProductGroup_BPF_Map.containsKey(op.Id)){
                                            OppId_ProductGroup_BPF_Map.put(op.Id,new Map<String,boolean>());
                                            OppId_ProductGroup_BPF_Map.get(op.Id).put(prodGroup,PA.Business_Plan__c);
                                            System.debug('+++++JJJ++++++'+OppId_ProductGroup_BPF_Map);
                                        }else{                                        
                                            OppId_ProductGroup_BPF_Map.get(op.Id).put(prodGroup,PA.Business_Plan__c);
                                            System.debug('+++++KKK++++++'+OppId_ProductGroup_BPF_Map);
                                        }                                
                                    }
                                }
                            }
                        }                
                    }
                }
            }
             System.debug(LoggingLevel.ERROR, ' 13 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
            System.debug('+++++OppId_ProductGroup_BPF_Map++++++'+OppId_ProductGroup_BPF_Map);
            if(oliList != null && oliList.size()>0){
                for(OpportunityLineItem oli:oliList){
                    if(OppId_ProductGroup_BPF_Map.containsKey(oli.OpportunityId)){
                        System.debug('+++++444++++++');
                        if(OppId_ProductGroup_BPF_Map.get(oli.OpportunityId).containsKey(pbeMap.get(oli.PriceBookEntryId).Product2.Product_Group__c)){
                            System.debug('+++++555++++++');
                            oli.Business_Plan_Focus__c = OppId_ProductGroup_BPF_Map.get(oli.OpportunityId).get(pbeMap.get(oli.PriceBookEntryId).Product2.Product_Group__c);
                        }else
                            oli.Business_Plan_Focus__c = false;
                    }else{
                        oli.Business_Plan_Focus__c = false;
                    }
                }
           }
         System.debug(LoggingLevel.ERROR, ' 14 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
          
        }
         
    }


    public static Opportunity updateFinanceValuation(Opportunity Opp, List<OpportunityLineItem> oliList){
        Set<String> StatusFormValue = new Set<String>();
        boolean isValidated=true;
        if(oliList!=null && oliList.size()>0){
            for(OpportunityLineItem oli:oliList){
                StatusFormValue.add(oli.Active_Contract_Product__r.Active_Contract__r.Status_Formula__c);
            }
        }
        
        if(StatusFormValue != null && StatusFormValue.size() > 0){
            System.debug('status_value - '+StatusFormValue);     
            if(StatusFormValue.contains('In Progress') || StatusFormValue.contains('Assigned') || StatusFormValue.contains('In Scope')){
                isValidated =  false;   
            }
            
            if(isValidated){
                opp.Finance_Valuation_Status__c ='Validated';  
            }else if(!isValidated){
                opp.Finance_Valuation_Status__c ='Not Validated';     
            }          
        }else{
            opp.Finance_Valuation_Status__c ='';  
        }
        
        return opp;
    }    
     
}