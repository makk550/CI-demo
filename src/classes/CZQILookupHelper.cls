public class CZQILookupHelper {
    private Map<String,Site_Association__c> siteAssociationMap;
    private Map<String,Account> accountMap;
    
    private Map<String,Opportunity> opportunityTemplateMap;
    private Map<String,SBQQ__Quote__c> quoteTemplateMap;
    
    private Map<String,Contract> masterContractMap;
    
    private Map<String,Product2> productMap;
    
    private Map<String,Id> bundleProductIdMap;
    private Map<String,Id> productOptionIdMap;
    private Map<String,Id> maintenanceProductIdMap;
    private Map<String,Id> maintenanceProductOptionIdMap;
    private Map<String,Id> requiredProductIdMap;
    private Map<String,Id> requiredProductOptionIdMap;
    
    private List<Id> subscriptionBundleIdList;

    public CZQILookupHelper() {
        
    }
    
    public Account getAccount(String siteId) {
        return accountMap.get(siteId);
    }
    
    public Site_Association__c getSiteAssociation(String siteId) {
        return siteAssociationMap.get(siteId);
    }
    
    public Product2 getProduct(String productCode) {
        return productMap.get(productCode);
    }
    
    public Boolean isSubscriptionBundle(Id bundleId) {
        return subscriptionBundleIdList.contains(bundleId);
    }
    
    public Id getBundleProductId(String productCode) {
        return bundleProductIdMap.get(productCode);
    }
    
    public Id getProductOptionId(Id bundleId, Id optionProductId) {
        return productOptionIdMap.get(String.valueOf(bundleId) + String.valueOf(optionProductId));
    }
    
    public Id getMaintenanceProductId(String productCode) {
        return maintenanceProductIdMap.get(productCode);
    }
    
    public Id getMaintenanceProductOptionId(String productCode) {
        return maintenanceProductOptionIdMap.get(productCode);
    }
    
    public Id getRequiredProductId(String productCode) {
        return maintenanceProductIdMap.get(productCode);
    }
    
    public Id getRequiredProductOptionId(String productCode) {
        return requiredProductOptionIdMap.get(productCode);
    }
    
    public Opportunity cloneOpportunityTemplate(String templateName) {
        Opportunity retVal;
        
        Opportunity template;
        
        if (!String.isBlank(templateName)) {
            template = opportunityTemplateMap.get(templateName);
        }
        
        if (template == null) {
            System.debug('opportunity template is null.');
            retVal = new Opportunity();
            retVal.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SB Record Type').getRecordTypeId();
        } else {
            System.debug('opportunity template is not null.');
            retVal = template.clone(false, false, false, false);
            template.Opportunity_Template__c = null;
            retVal.StageName = '1 - Prospect';
        }
        
        return retVal;
    }
    
    public SBQQ__Quote__c cloneQuoteTemplate(String templateName) {
        SBQQ__Quote__c retVal;
        
        SBQQ__Quote__c template;
        
        if (!String.isBlank(templateName)) {
            template = quoteTemplateMap.get(templateName);
        }
        
        if (template == null) {
            System.debug('quote template is null.');
            retVal = new SBQQ__Quote__c();
            retVal.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Quote - Draft').getRecordTypeId();
        } else {
            System.debug('quote template is not null.');
            retVal = template.clone(false, false, false, false);
            retVal.Quote_Template__c = null;
        }
        
        return retVal;
    }
    
    public Contract getMasterContract(Input_Quote_Header__c header) {
        if (!String.isBlank(header.End_Date__c) && !String.isBlank(header.ShipTo_BPID__c) && !String.isBlank(header.SoldTo_BPID__c)) {
            ContractCriteria crit = new ContractCriteria();
            crit.endDate = Date.parse(header.End_Date__c);
            crit.shipToSiteId = header.ShipTo_BPID__c;
            crit.soldToSiteId = header.SoldTo_BPID__c;
            
            Contract retVal =  masterContractMap.get(crit.getKey());
            
            if (retVal == null) {
                System.debug('Contract was null');
            }
            
            return retVal;
        }
        
        return null;
    }
    
    public void initializeAccounts(Set<String> siteIds) {
        accountMap = CZQILookupHelper.lookupAccounts(siteIds);
    }
    
    public void initializeSiteAssociations(Set<String> siteIds) {
        siteAssociationMap = CZQILookupHelper.lookupSiteAssociations(siteIds);
    }
    
    public void initializeProducts(Set<String> productCodes) {
        productMap = lookupProducts(productCodes);
    }

    public void initializeMasterContracts(List<ContractCriteria> criteria) {
        masterContractMap = lookupMasterContracts(criteria);
    }
    
    public void initializeOpportunityTemplates(Set<String> templateNames) {
        opportunityTemplateMap = lookupOpportunityTemplates(templateNames);
    }
    
    public void initializeQuoteTemplates(Set<String> templateNames) {
        quoteTemplateMap = lookupQuoteTemplates(templateNames);
    }
    
    public void initializeBundles() {
        bundleProductIdMap = new Map<String,Id>();
        productOptionIdMap = new Map<String,Id>();
        
        List<Id> productIds = new List<Id>();
        
        Map<Id,Product2> tempProductMap = new Map<Id,Product2>();
        
        for (Product2 product : productMap.values()) {
            tempProductMap.put(product.Id, product);
        }

        List<SBQQ__ProductOption__c> options = [SELECT SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c from SBQQ__ProductOption__c where SBQQ__OptionalSKU__c in : tempProductMap.keySet()];
        
        Map<Id,Id> bundleMap = new Map<Id,Id>();
        
        Set<Id> alreadyUsed = new Set<Id>();
        for (SBQQ__ProductOption__c option : options) {
            if (alreadyUsed.contains(option.SBQQ__OptionalSKU__c)) {
                bundleMap.remove(option.SBQQ__OptionalSKU__c);
                continue;
            }
            
            alreadyUsed.add(option.SBQQ__OptionalSKU__c);
            bundleMap.put(option.SBQQ__OptionalSKU__c, option.SBQQ__ConfiguredSKU__c);
        }
        
        System.debug('bundleMap.size()=' + bundleMap.size());

        for (Id lineProductId : bundleMap.keySet()) {
            Product2 lineProduct = tempProductMap.get(lineProductId);
            
            if (lineProduct != null) {
                bundleProductIdMap.put(CZQuoteInterfaceUtility.generateProductCode(lineProduct), bundleMap.get(lineProductId));
            }
        }
        
        System.debug('bundleProductIdMap.size()=' + bundleProductIdMap.size());
        
        options = [SELECT Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c from SBQQ__ProductOption__c where SBQQ__ConfiguredSKU__c in : bundleProductIdMap.values()];
        
        for (SBQQ__ProductOption__c option : options) {
            productOptionIdMap.put(String.valueOf(option.SBQQ__ConfiguredSKU__c) + String.valueOf(option.SBQQ__OptionalSKU__c), option.Id);
        }
        
        System.debug('productOptionIdMap.size()=' + productOptionIdMap.size());
        
        if (subscriptionBundleIdList == null) {
            subscriptionBundleIdList = new List<Id>();
        }
        
        List<Product2> bundleProducts = [Select Id, CA_License_Type__c from Product2 where Id in : bundleProductIdMap.values()];
        
        for (Product2 product : bundleProducts) {
            if (product.CA_License_Type__c == 'S') {
                subscriptionBundleIdList.add(product.Id);
            }
        }
    }
    
    public static Map<String,Site_Association__c> lookupSiteAssociations(Set<String> siteIds) {
        List<Site_Association__c> sites = [Select Id, SAP_Site_ID__c from Site_Association__c where SAP_Site_ID__c in : siteIds];

        Map<String,Site_Association__c> retVal = new Map<String,Site_Association__c>();
        
        for (Site_Association__c site : sites) {
            retVal.put(site.SAP_Site_ID__c, site);
        }
        
        return retVal;
    }
    
    public static Map<String,Account> lookupAccounts(Set<String> siteIds) {
        List<Site_Association__c> sites = [Select SAP_Site_ID__c, Enterprise_Id__c from Site_Association__c where SAP_Site_ID__c in : siteIds];

        Map<String,String> siteIdMap = new Map<String,String>();
        Set<String> enterpriseIds = new Set<String>();
        
        for (Site_Association__c site : sites) {
            siteIdMap.put(site.SAP_Site_ID__c + '|' + site.Enterprise_Id__c, site.SAP_Site_ID__c);
            enterpriseIds.add(site.Enterprise_ID__c);
        }
        
        List<Account> results = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry from Account where Id in : enterpriseIds];

        Map<String,Account> retVal = new Map<String,Account>();
        Map<String,Account> accountMap = new Map<String,Account>();
        
        for (Account acct : results) {
            accountMap.put(acct.Id, acct);
        }
        
        for (String key : siteIdMap.keySet()) {
            String siteId = key.substring(0, key.indexOf('|'));
            String id = key.substring(key.indexOf('|')+1);
            Account account = accountMap.get(id);
            retVal.put(siteId, account);
        }

        return retVal;
    }

    private static Map<String,Opportunity> lookupOpportunityTemplates(Set<String> templateNames) {
        System.debug('templateNames.size()=' + templateNames.size());
        String query = 'SELECT Id, RecordTypeId, Opportunity_Template__c, ' + getOpportunityFields() + ' from Opportunity where Opportunity_Template__c in ' + getTemplateNames(templateNames) + ' LIMIT ' + templateNames.size();
        List<Opportunity> opps = Database.query(query);
        
        Map<String,Opportunity> retVal = new Map<String,Opportunity>();
        
        for (Opportunity opp : opps) {
            retVal.put(opp.Opportunity_Template__c, opp);
        }
                
        return retVal;
    }
    
    private static Map<String,SBQQ__Quote__c> lookupQuoteTemplates(Set<String> templateNames) {
        String query = 'SELECT Id, RecordTypeId, Quote_Template__c, ' + getQuoteFields() + ' from SBQQ__Quote__c where Quote_Template__c in ' + getTemplateNames(templateNames) + ' LIMIT ' + templateNames.size();
        List<SBQQ__Quote__c> quotes = Database.query(query);
        
        Map<String,SBQQ__Quote__c> retVal = new Map<String,SBQQ__Quote__c>();
        
        for (SBQQ__Quote__c quote : quotes) {
            retVal.put(quote.Quote_Template__c, quote);
        }
        
        return retVal;
    }
    
    public void initializeRequiredProductOptions(Set<String> productCodes) {
        requiredProductIdMap = new Map<String,Id>();
        requiredProductOptionIdMap = new Map<String,Id>();
        
        Map<Id,String> configuredSKUMap = new Map<Id,String>();
        
        for (String productCode : productCodes) {
            Product2 curProduct = productMap.get(productCode);
            
            if (curProduct != null) {
                configuredSKUMap.put(curProduct.Id, productCode);
            }
        }
        
        List<SBQQ__ProductOption__c> results = [SELECT Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c from SBQQ__ProductOption__c where SBQQ__Required__c = true and SBQQ__ConfiguredSKU__c in : configuredSKUMap.keySet()];
        
        for (SBQQ__ProductOption__c productOption : results) {
            requiredProductIdMap.put(configuredSKUMap.get(productOption.SBQQ__ConfiguredSKU__c), productOption.Id);
            requiredProductOptionIdMap.put(configuredSKUMap.get(productOption.SBQQ__ConfiguredSKU__c), productOption.SBQQ__OptionalSKU__c);
        }
    }
    
    public void initializeMaintenanceProductOptions(Set<String> productCodes) {
        maintenanceProductIdMap = new Map<String,Id>();
        maintenanceProductOptionIdMap = new Map<String,Id>();
        
        Map<Id,String> configuredSKUMap = new Map<Id,String>();
        
        for (String productCode : productCodes) {
            Product2 curProduct = productMap.get(productCode);
            
            if (curProduct != null) {
                configuredSKUMap.put(curProduct.Id, productCode);
            }
        }
        
        List<SBQQ__ProductOption__c> results = [SELECT Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c from SBQQ__ProductOption__c where SBQQ__Required__c = true and SBQQ__ConfiguredSKU__c in : configuredSKUMap.keySet()];
        
        for (SBQQ__ProductOption__c productOption : results) {
            maintenanceProductOptionIdMap.put(configuredSKUMap.get(productOption.SBQQ__ConfiguredSKU__c), productOption.Id);
            maintenanceProductIdMap.put(configuredSKUMap.get(productOption.SBQQ__ConfiguredSKU__c), productOption.SBQQ__OptionalSKU__c);
        }
    }
    
    public Map<String,Product2> lookupProducts(Set<String> productCodes) {
        if (productCodes == null || productCodes.isEmpty()) {
            throw new CZQuoteInterfaceException('No products included in Input Quote Lines');
        }

        Set<String> strippedProductCodes = new Set<String>();
        for (String cur : productCodes) {
            List<String> items = cur.split(',');
            strippedProductCodes.add(items.get(0));
        }

        System.debug('====> strippedProductCodes.size()=' + strippedProductCodes.size());
        List<Product2> products = [Select Id, Name, ProductCode, CA_License_Type__c, Auth_Use_Mode__c from Product2 where ProductCode in : strippedProductCodes];
        System.debug('====> returned ' + products.size() + ' products.');

        Map<String,Product2> retVal = new Map<String,Product2>();
        
        for (Product2 product : products) {
            String productCode = product.ProductCode + ',' + product.Auth_Use_Mode__c;
            
            retVal.put(productCode, product);
        }
        
        return retVal;
    }
        
    public static Map<String,Contract> lookupMasterContracts(List<ContractCriteria> criteria) {
        Map<String,Contract> retVal = new Map<String,Contract>();
        
        if (criteria == null || criteria.isEmpty()) {
            return retVal;
        }
        
        String query = 'SELECT Id, EndDate, SoldTo_BPID__c, ShipTo_BPID__c from Contract where ';
        
        boolean first = true;
        for (ContractCriteria crit : criteria) {
            if (first) {
                first = false;
                query += '(';
            } else {
                query += ') OR (';
            }
            
            Date endDate = crit.endDate;
            String formattedEndDate = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day()).format('YYYY-MM-dd');
            
            query += 'EndDate = ' + formattedEndDate + ' AND SoldTo_BPID__c = \'' + crit.soldToSiteId + '\' AND ShipTo_BPID__c = \'' + crit.shipToSiteId + '\'';
        }
        
        query += ')';
        
        System.debug('query==>' + query);

        List<Contract> results = Database.query(query);
        
        for (Contract contract : results) {
            ContractCriteria thisCriteria = new ContractCriteria();
            thisCriteria.endDate = contract.EndDate;
            thisCriteria.shipToSiteId = contract.ShipTo_BPID__c;
            thisCriteria.soldToSiteId = contract.SoldTo_BPID__c;
            
            retVal.put(thisCriteria.getKey(), contract);
        }
            
        return retVal;
    }
    
    public class ContractCriteria {
        public Date endDate {get; set;}
        public String soldToSiteId {get; set;}
        public String shipToSiteId {get; set;}
        public String getKey() {
            return endDate.format() + '|' + soldToSiteId + '|' + shipToSiteId;
        }
    }
    
    public static String getOpportunityFields() {
        List<Schema.FieldSetMember> fields = SObjectType.Opportunity.FieldSets.Quote_Interface_Fieldset.getFields();
        
        String retVal = '';
        
        boolean first = true;
        for (Schema.FieldSetMember field : fields) {
            if (first) {
                first = false;
            } else {
                retVal += ', ';
            }
            
            retVal += field.getFieldPath();
        }
        
        return retVal;
    }

    public static String getQuoteFields() {
        List<Schema.FieldSetMember> fields = SObjectType.SBQQ__Quote__c.FieldSets.Quote_Interface_Fieldset.getFields();
        
        String retVal = '';
        
        boolean first = true;
        for (Schema.FieldSetMember field : fields) {
            if (first) {
                first = false;
            } else {
                retVal += ', ';
            }
            
            retVal += field.getFieldPath();
        }
        
        return retVal;
    }
    
    public static String getTemplateNames(Set<String> templateNames) {
        String retVal = '(';
        
        boolean first = true;
        for (String templateName : templateNames) {
            if (first) {
                first = false;
            } else {
                retVal += ', ';
            }
            retVal += '\'' + templateName + '\'';
        }
        
        retVal += ')';
        
        return retVal;
        
    }
}