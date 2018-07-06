/************************************************************************************************
 * Created For :  US423678 - XXXL Renewals
 * Created By 	:	SAMAP01
 * Created Date : Nov 16th 2017
 * ***********************************************************************************************/
global class Batch_RenewalAttachContracts implements Database.Batchable<sObject> ,Database.Stateful  {
    global final Set<Id> ActiveContractIds ; 
    global final Map<id, PricebookEntry> mapPBE ;
    global String failedDML = '';
    //global  Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap = new Map<id, LIST<Active_Contract_Line_Item__C >>();
    global final Id oppId;
    global  Opportunity opp = new Opportunity();
    Decimal Term_Month=0;
   
    global List<Active_Contract_Line_Item__c>  AclProduct = new List<Active_Contract_Line_Item__c>(); //samap01 27/10
    global  Map<id,id> mOLIACP = new Map<id,id>();
   // global  Map<id,id> mRCPACP = new Map<id,id>();
   // global  Map<id,id> mACLOLI = new Map<id,id>(); //SAMAP01 27/10 Opportunity_Product__c
    global  List<Active_Contract_Product__c>  ActProduct = new List<Active_Contract_Product__c>();
    global List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
    global List<Active_Contract_Product__c>  ActPdtlst = new List<Active_Contract_Product__c>();
    global List<Active_Contract_Product__c>  updateacplist = new List<Active_Contract_Product__c>();
    public Map <String,Active_Contract_Product__c> ActProductMap =   new Map<String,Active_Contract_Product__c>();
    global Map<id, PricebookEntry> mapPE = new Map<id,PricebookEntry>();
    string strpricebookid;
    global Batch_RenewalAttachContracts(Set<Id> acpIds, Id opportunityId,Map<id, PricebookEntry> mapPricebookentry )
    {
        ActiveContractIds =acpIds;
        oppId=opportunityId;
        mapPBE =mapPricebookentry;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('SAMAP01 -ActiveContractIds'+ActiveContractIds);
        Pricebook2 pbe = new Pricebook2();
        
        pbe = [select Id from Pricebook2 where Name='CA Product List' and IsActive=true];
        if(pbe!=null)
            strpricebookid = pbe.Id;
        mapPE = mapPBE;
        System.debug('samap01' +  mapPE);
        Set<String> acpids = (Set<String>)JSON.deserialize(JSON.serialize(ActiveContractIds), Set<String>.class);
        opp = [Select o.Name,o.Id,o.Account.Name,o.CurrencyIsoCode, o.AccountId,CloseDate,StageName,o.Start_Date__c,o.End_Date__c,Attach_Contracts_Batch_Id__c,o.Probability 
               From Opportunity o where o.Id =: oppId];
        System.debug('samap01 --opp' +  opp);
        Term_Month = ARRandDurationCalculation.monthsbetweendates(opp.Start_Date__c, opp.End_Date__c);
        System.debug('samap01 --Term_Month' +  Term_Month);
        return database.getQueryLocator([SELECT ID,Name,
                                         Product__c,
                                         Active_Contract__c,
                                         Raw_Maint_Calc_LC__c,
                                         AOCV__c,
                                         ATTRF_CRV__c,
                                         Product_Baseline_ATTRF_LC__c,
                                         Projected_Renewal_Calc__c,
                                         Active_Contract__r.Name,
                                         Converted_To_Opportunity__c,
                                         Opportunity__c,
                                         Renewal_Contract_Product__c,
                                         Segmentation__c,
                                         Pre_Segmentation__c,
                                         Sales_Price__c
                                         FROM   active_contract_product__c  
                                         WHERE  id IN :ActiveContractIds ]);
        
        
    }
    
    global void execute(Database.BatchableContext BC, List<Active_Contract_Product__c> scope)
    {
        String RenewalName;
        String segment;
        String cbuValue;
        String RenewalproductName;
        String currencycode ; 
        Boolean flag ;
        Map<id, Decimal> mapACPSalesprice = new Map<id,Decimal>(); //samap01
         List<OpportunityLineItem> oppLineItm = new List<OpportunityLineItem>();
        if(scope != null && scope.size() > 0)
        { 
            // Savepoint sp = Database.setSavepoint();
           flag = createChildObjects(scope, opp.CurrencyIsoCode);
            if(flag== false)
            {
                  failedDML =failedDML + 'There was an error executing this batch' + '\n' ;
            }
           
        }
        
    }
     public boolean createChildObjects(List <Active_Contract_Product__c> ACP, string currencycode)
    {
        set<Id> prod = new set<Id>();    
        Set<Id> actId = new Set<Id>() ; 
        boolean flag = false ;
        Map<id, PricebookEntry> mapPE = new Map<id,PricebookEntry>();
        Savepoint sp = Database.setSavepoint();
        try
        {
            //Get ACP
            if(ACP.size() >0)
            {
                for(Active_Contract_Product__c actvCP : ACP)
                { 
                    prod.add(actvCP.Product__c);                    
                    System.debug('samap01 -actids ' + actvcp.id);
                }
                Map<id,PricebookEntry> ACPProd = new Map<id,PricebookEntry>();  //([Select Id,Name From PricebookEntry where Product2Id  in : prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]);
                if(prod.size()>0){
                    for(PricebookEntry p : [Select Id,Name,Product2Id,product2.Commissionable_BU__c From PricebookEntry where 
                                            Product2Id in :prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode                         =:currencycode]){
                        ACPProd.put(p.Product2Id,p);
                    }       
                }   
                for(Active_Contract_Product__c actvCP : ACP)
                {
                    if(ACPProd.get(actvCP.Product__c)!=null)
                    {
                        actId.add(actvCP.Id); 
                    }
                    else
                    {
                        failedDML =failedDML + 'Price book entry missing for ' +actvCP.Id + '\n';
                        flag =true;
                    }
                }
                
                if(flag==true){
                   System.debug('Error -- Pricebook Entry is not active for selected Contracts!');
                   return false;    
                }
                else{
                    //get Pricbookentry
                  
                    //Get ACL
                    Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap = new Map<id, LIST<Active_Contract_Line_Item__C >>(); 
                    List <Active_Contract_Line_Item__c> aclineitems = new   List <Active_Contract_Line_Item__c> (); 
                    
                    aclmap = Renewal_OpportunityUtilityClass.getActiveContractLineItems(actId,opp.AccountId);
                    aclineitems = Renewal_OpportunityUtilityClass.acllist;
                    
                    //Create CA Prod Rnwl for all ACP
                    
                    Map<id,id> mRCPACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Renewal Contract Product           
                    
                    mRCPACP = Renewal_OpportunityUtilityClass.createProdRenewal(ACP, opp);
                    System.debug('samap01- prod renewal created - loop acp and create oli');
                    
                    Map<id,id> mapACLOLI = new Map<id,id>(); //SAMAP01 27/10 Opportunity_Product__c    
                    mapACLOLI = Renewal_OpportunityUtilityClass.CreateOpportunityproducts(actId, prod,aclmap,opp);
                    List<Active_Contract_Line_Item__c>  aclines = new List<Active_Contract_Line_Item__c>(); 
                    if(aclineitems != null && aclineitems.size()>0)
                    {
                    for(Active_Contract_Line_Item__c acl : aclineitems )
                    {
                        if(mapACLOLI.get(acl.id) != null)
                        {
                      	      acl.Opportunity_Product__c = mapACLOLI.get(acl.id);
                        	aclines.add(acl); 
                        }
                        else
                        {
                           failedDML = failedDML + 'This acl is not mapped to Oli ' +acl.id +  '\n' ;
                        }
                     
                    }
                    if(aclines.size() > 0)
                    {
                        update aclines;
                        System.debug('samap01- acl updated' +aclines);
                    }
                    
                    List<Active_Contract_Product__C> ActProduct = new List<Active_Contract_Product__c>();
                    
                        for(Active_Contract_Product__c actvp : ACP)
                      {       
                          actvp.Converted_To_Opportunity__c = true;
                          actvp.Opportunity__c = opp.id; 
                          actvp.Renewal_Contract_Product__c =mRCPACP.get(actvp.id);//FY13
                          System.debug(' samap01 - Renewal_Contract_Product__c mRCPACP.get(acp.id)'+mRCPACP.get(actvp.id));
                          actvp.Sales_Price__c =Renewal_OpportunityUtilityClass.mapACPSalesprice.get(actvp.id); 
                          ActProduct.add(actvp); 
						  System.debug('samap01 -actvp'+ actvp);
                      }             
                             
                     if(ActProduct.size() > 0)
                     {
                         update ActProduct;
                         System.debug('samap01 -ActProduct'+ ActProduct);
                     }
                    }
                    else
                    {
                        system.debug('samap01 ACL lines dont exist for this acp' +acp);
                        failedDML = failedDML + 'ACL Lines do not exist for this acp' + acp + '\n' ;
                    }
                }    
            }
            return   true;
        }
        catch(System.DmlException e){
            for (Integer index = 0; index < e.getNumDml(); index++){
             failedDML = failedDML + e.getMessage() +e.getLineNumber() + e.getCause() + '\n';
            }
            System.debug('samap01- error occured rollback all the inserts');
            Database.rollback(sp);
            return       false;
        }
        catch(Exception e) {
         	failedDML = failedDML + e.getMessage() +e.getLineNumber() + e.getCause();
            Database.rollback(sp);
            return false;
        } 
        
        return true;
    }
    //Finish method to execute at last.
    global void finish(Database.BatchableContext BC) {
        try
        {
       
      //set the batch number to null after batch finishes
         OpportunityHandler.renewalToOppConversion = true;  //setting this to true so that Primary contact validation doesnt fire
       	 opp.Attach_Contracts_Batch_Id__c = null;
      	 update opp;  
     
        }
     
     	catch(DMLexception e)
        {
              for (Integer index = 0; index < e.getNumDml(); index++){
                  failedDML =   '\n' + failedDML + e.getMessage() +e.getLineNumber() + e.getCause();}
            
        }
        finally
        {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String currentuseremail= UserInfo.getUserEmail();
        String[] toAddresses = new String[] {currentuseremail};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Schedule Job- Attach contract ' + a.Status);
       /* mail.setPlainTextBody
            ('The Attach contract processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.' +  failedDML);*/
             mail.setHtmlBody('<html><body>Hi ' +UserInfo.getFirstName() + ' <br><br>The Attach contract job processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.<br><br>' +  failedDML);
        // If(a.NumberOfErrors>0)
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
        
}