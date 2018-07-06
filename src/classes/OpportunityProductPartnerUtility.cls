global class OpportunityProductPartnerUtility {
    /*
     * This is the test method that checks for the code coverage requirements for all 
     * methods in this class.
     */
    public static testMethod void testopportunityPartnerProductMethods() 
    {
        
        SystemIdUtility.skipOpportunityTriggers = true;
SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        //get valid record types for opportunity
        RecordType[] recordTypes = [Select Id from RecordType where SobjectType =: 'Opportunity' and (Name=:'NCV' or Name=:'NCV-MQL')];
        //create account
        Account a=new Account();
        a.Name='Test Account';
        a.Commercial_Id__c = 'test';
        a.BillingStreet = 'Arlington';
        a.BillingCountry = 'US';
        a.BillingCity = 'VA';
        insert a;
        
        //add rad to the account team       
        AccountTeamMember atm=new AccountTeamMember();
        atm.AccountId=a.Id;
        atm.TeamMemberRole='Regional Alliance Director (RAD)';
        atm.UserId=[Select Id from User where IsActive=true Limit 1].Id;
        insert atm;
        
        
        //create opportunity and call method
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.AccountId=a.Id;
         o.Reseller__c=a.Id;
        o.StageName = '20%-Qualified Opp.';
        o.CloseDate = Date.newInstance(2008,06,18); 
        o.Initial_Billing__c = 20;      
        //o.NCV_Transaction_Type__c = 'Free Standing';
        o.New_Deal_Term_months__c = 5;
        
        insert o;       
        opportunityValidForPartnerConfirmation(o.Id);
        
        //update opportunity with valid probabilty and call method 
        o.StageName = '70%-Technical Win';
        update o;       
        opportunityValidForPartnerConfirmation(o.Id);
        
        //update opportunity with valid Record type and call method 
        if(recordTypes.size()>0)
        {
            o.RecordTypeId = recordTypes[0].Id;
            o.Initial_Billing__c=1000;
            //o.NCV_Transaction_Type__c='Renewals';
            o.New_Deal_Term_months__c=12;
            update o;           
            opportunityValidForPartnerConfirmation(o.Id);
        }
        
        //create new product
        Product2 newProduct=new Product2();     
        newProduct.IsActive=true;
        newProduct.Name='test Product';
        newProduct.PRODUCT_BASE_NAME_C__c='test Product';
        newProduct.PRODUCT_SUBTYPE_C__c ='NEW';
        insert newProduct;          
        
        //create implementaion product      
        Product2 impProduct=new Product2();     
        impProduct.IsActive=true;
        impProduct.Name='test Product';
        impProduct.PRODUCT_BASE_NAME_C__c='test Product';
        impProduct.PRODUCT_SUBTYPE_C__c ='IMPLEMENTATION';
        insert impProduct;  
        
        //add new product to standard price book            
        PricebookEntry newPBE=new PricebookEntry();         
        newPBE.IsActive=true;
        newPBE.Pricebook2Id=[Select Id from Pricebook2 where IsStandard=true].Id;
        newPBE.Product2Id =newProduct.Id;
        newPBE.UnitPrice =100;
        insert newPBE;
        
        //add new product to standard price book            
        PricebookEntry impPBE=new PricebookEntry();         
        impPBE.IsActive=true;
        impPBE.Pricebook2Id=[Select Id from Pricebook2 where IsStandard=true].Id;
        impPBE.Product2Id =impProduct.Id;
        impPBE.UnitPrice =100;
        insert impPBE;
        
        //add new product to opportunity
        OpportunityLineItem newLineItem = new OpportunityLineItem();
        newLineItem.OpportunityId = o.Id;
        newLineItem.PricebookEntryId = newPBE.Id;
        newLineItem.UnitPrice = 200;        
        insert newLineItem;
        
        //add implementaion product to opportunity
        OpportunityLineItem impLineItem = new OpportunityLineItem();
        impLineItem.OpportunityId = o.Id;
        impLineItem.PricebookEntryId = impPBE.Id;
        impLineItem.UnitPrice = 200;    
        //impLineItem.Are_Partners_Involved__c='Yes'; 
        insert impLineItem; 
        
        opportunityValidForPartnerConfirmation(o.Id);
        createSingleOpportunityPartnerDetailMissingTask(o.Id);
    }
    /*
     * checks if an opportunity is qulified for Partner confirmation. In order to be qualified, 
     * an Opportunity should have a probability greater than 60%, "NCV" or "NCV ? MQL"  record type 
     * and at least one pair of new and implementation product pair.
     *
     * @param oppId the salesforce id of the opportunity
     *
     * @return true if opportunity is qulified, false otherwise
     */
    webservice static boolean opportunityValidForPartnerConfirmation(ID oppId)
    {
        boolean isValid=false;
        Opportunity opp=[Select Id,Probability,RecordTypeId from Opportunity Where Id=:oppId];
        
        //return false if Probability <60
        if(opp.Probability<60)
        {
            return false;
        }   
        
        //return false if the record type is not "NCV" or "NCV ? MQL" 
        Map<ID,RecordType> recordTypeMap = new Map<ID,RecordType>([Select Id from RecordType r where SobjectType =: 'Opportunity' and (Name=:'NCV' or Name=:'NCV-MQL')]);
        if(recordTypeMap.get(opp.RecordTypeId)==null)
        {
            return false;
        }
        //check if there is at least one NEW/IMPLEMENTATION pair
        OpportunityLineItem[] lineItems=[Select Id,PriceBookEntry.Product2.PRODUCT_BASE_NAME_C__c,
            PriceBookEntry.Product2.PRODUCT_SUBTYPE_C__c from OpportunityLineItem where
            OpportunityId=: oppId and PriceBookEntry.Product2.PRODUCT_BASE_NAME_C__c!=: null 
            and (PriceBookEntry.Product2.PRODUCT_SUBTYPE_C__c=:'NEW' or PriceBookEntry.Product2.PRODUCT_SUBTYPE_C__c=:'IMPLEMENTATION')];
        
        Map<string,List<OpportunityLineItem>> productMapByBaseName=new Map<string,List<OpportunityLineItem>>();
        for(OpportunityLineItem  lItem:lineItems)
        {
            //add opportunity line item to map
            if(productMapByBaseName.get(lItem.PriceBookEntry.Product2.PRODUCT_BASE_NAME_C__c)==null)
            {
                productMapByBaseName.put(lItem.PriceBookEntry.Product2.PRODUCT_BASE_NAME_C__c,new List<OpportunityLineItem>{lItem});
            }
            else
            {
                productMapByBaseName.get(lItem.PriceBookEntry.Product2.PRODUCT_BASE_NAME_C__c).add(lItem);
            }
        } 
        
        for(string baseName:productMapByBaseName.keySet())
        {
            Integer newCount=0;
            Integer implementationCount=0;
            List<OpportunityLineItem> currentLineItem=productMapByBaseName.get(baseName);
            for(OpportunityLineItem li:currentLineItem)
            {
                if(li.PriceBookEntry.Product2.PRODUCT_SUBTYPE_C__c.toUpperCase()=='NEW')
                {
                    newCount++;
                }
                else
                {
                    implementationCount++;
                }
            }
            if(newCount>0 && implementationCount>0)
            {
                return true;
            }           
        }       
        return isValid;
    }
    /*
     * creates a "Partner Detail Missing" Task for an opportunity when an opportunity has one or more 
     * opportunity line items  of implementaion product with "Are Partners Involved" checked, which do 
     * not have a corresponding SAO partner product records. The method calls the batch version with 
     * an array containg the current opportunity.
     *
     * @param oppId the salesforce id of the opportunity
     *
     * @return a string showing if the process completed successfuly or not
     */
    webservice static string createSingleOpportunityPartnerDetailMissingTask(string oppId)
    {
        string errorMessage='Success!';
        try
        {
            createPartnerDetailMissingTask(new ID[]{oppId});    
        }
        catch(Exception ex)
        {
            errorMessage='Error: '+ex;
        }
        return errorMessage;
    }
    /*
     * creates a "Partner Detail Missing" Task for a set of  opportunities.A task is greated for an opportunity when it has one or more 
     * opportunity line items  of implementaion product with "Are Partners Involved" checked, which do not have 
     * a corresponding SAO partner product records. 
     *
     * @param opts an array of opportunity Ids
     */
    webservice static void createPartnerDetailMissingTask(ID[] opts)
    {
        List<Task> tasksCreated=new List<Task>();
        List<ID> priceBookEntryIdList=new List<ID>();
        Map<ID,Opportunity> oppMap=new Map<ID,Opportunity>([Select Id,Name,OwnerId,AccountId,Owner.IsActive from Opportunity where Id in : opts]);  
        List<Opportunity> oppList=oppMap.values();      
        List<ID> accountList=new List<ID>();
        for(Opportunity o:oppList)
        {
            if(o.AccountId!=null)
            {
                accountList.add(o.AccountId);
            }
        }   
        AccountTeamMember[] teamMembers=[Select AccountId, Id, UserId from AccountTeamMember where User.IsActive=true and 
                                        AccountId in :accountList and TeamMemberRole=: 'Regional Alliance Director (RAD)'];
        Map<ID,ID> teamMemberMap=new Map<ID,ID>();
        for(AccountTeamMember atm:teamMembers)
        {
            teamMemberMap.put(atm.AccountId,atm.UserId);
        }
        
        Map<ID,List<OpportunityLineItem>> lineItemMap=new Map<ID,List<OpportunityLineItem>>();  
        //prepare line item map 
        OpportunityLineItem[] lineItems=[Select Id,OpportunityId,Opportunity.Name,PricebookEntryId,PricebookEntry.Product2Id,PricebookEntry.Product2.Name from 
                                        OpportunityLineItem where OpportunityId in: opts 
                                        and PricebookEntry.Product2.PRODUCT_SUBTYPE_C__c =:'IMPLEMENTATION'];
        for(OpportunityLineItem li : lineItems)
        {
            //add opportunity line item to map
            if(lineItemMap.get(li.OpportunityId)==null)
            {
                lineItemMap.put(li.OpportunityId,new List<OpportunityLineItem>{li});
            }
            else
            {
                lineItemMap.get(li.OpportunityId).add(li);
            }
            
        }       
        
        //prepare partner product map
        SAO_Partner_Product__c[] saoPartnerProducts=[Select Id,Product__c,SAO_Partner__r.Opportunity__c from 
                                                    SAO_Partner_Product__c where SAO_Partner__r.Opportunity__c in :opts];
        Map<string,ID> saoPartnerProductMap=new Map<string,ID>();
        for(SAO_Partner_Product__c pp:saoPartnerProducts)
        {
            //can't concatinate id fields using +
            //had to change one of them to string type
            string oppId=pp.SAO_Partner__r.Opportunity__c;
            saoPartnerProductMap.put(oppId+pp.Product__c,pp.Id);
        }
        //process each opportunity
        for(ID opId:opts)
        {
            Set<String> productNameList = new Set<String>();
            Opportunity currentOpportunity=oppMap.get(opId);
            if(lineItemMap.get(opId)!=null)
            {
                boolean createTask=false;
                List<OpportunityLineItem> currrentItems=lineItemMap.get(opId);
                for(OpportunityLineItem lItem:currrentItems)
                {
                    string ProductId=lItem.PricebookEntry.Product2Id;
                    string productName=lItem.PricebookEntry.Product2.Name;
                    if(saoPartnerProductMap.get(opId+ProductId)==null)
                    {
                        createTask=true;
                        productNameList.add(productName);
                    }
                }
                //create task if necessary
                if(createTask)
                {
                    Task task=new Task();                   
                    task.ActivityDate=System.today();
                    //task.Description='Please create Strategic Alliance Records and align the Partners to their respective products for this opportunity.';
                    task.Description=getMissingPartnerProductActivityDescription(productNameList);
                    task.IsReminderSet=true;
                    if(currentOpportunity.Owner.IsActive)
                    {                   
                        task.OwnerId=currentOpportunity.OwnerId;
                    }
                    if(currentOpportunity.AccountId!=null)
                    {
                        if(teamMemberMap.get(currentOpportunity.AccountId)!=null)
                        {
                            task.OwnerId=teamMemberMap.get(currentOpportunity.AccountId);
                        }
                    }
                    task.Priority='High';
                    task.ReminderDateTime=System.now()+3;
                    task.Status='In Progress';
                    task.Subject=currentOpportunity.Name+' ? Partner Details missing';
                    task.WhatId=opId;
                    tasksCreated.add(task);                 
                }
            }
        }
        //do creat tasks
        if(tasksCreated.size()>0)
        {
            insert tasksCreated;
        }       
    }
    /*
     * Prepares a description for a "Partner Detail Missing" Task
     *
     * @param productNameList a set conating the list of product names that do not have a coressponding 
     *        SAO Partner Product
     *
     * @return a string conating a description for the task 
     */
    private static string getMissingPartnerProductActivityDescription(Set<String> productNameList)
    {
        string description='Please create Strategic Alliance Records and align the Partners to their respective products for the following products:\n';
        
        for(string s:productNameList)
        {
            description+='\n'+s+'\n';   
        }
        return description;
    }
}