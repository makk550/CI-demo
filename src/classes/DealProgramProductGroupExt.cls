public with sharing class DealProgramProductGroupExt {
    
    public List<SelectOption> buValues{get;set;}
    public List<SelectOption> availableList{get;set;}
    public List<SelectOption> chosenList{get;set;}
    public List<SelectOption> chosenListOld{get;set;}
    public String buSelected{get;set;}
    public String selectedListName{get;set;}
    private final Deal_Program_Product_Group__c dealProgramProductGroup;
    
    public DealProgramProductGroupExt(ApexPages.StandardController controller) {
        this.dealProgramProductGroup = (Deal_Program_Product_Group__c)controller.getrecord();
        buValues = new List<SelectOption>();
        availableList = new List<SelectOption>();
        chosenList = new List<SelectOption>();
        chosenListOld = new List<SelectOption>();
        buValues = getBUValues();
        selectedListName = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Selected Product Groups';
        if(dealProgramProductGroup.Id != null) {
            Deal_Program_Product_Group__c dealPPG = [Select BU__c,Product_Group__c from Deal_Program_Product_Group__c where Id = :dealProgramProductGroup.Id LIMIT 1];
            buSelected = dealPPG.BU__c;
            setProductGroups(dealProgramProductGroup.Deal_Registration_Program__c);
        }
    }
    
    public void setProductGroups(Id dealRegProgramId) {
        Set<String> prdGrpSet = new Set<String>();
        chosenList.clear();
        availableList.clear();
        chosenListOld.clear();
        List<Product2> productsList = [Select Product_Group__c from Product2 where Salesforce_CPQ_Product__c=false and Market_Focus_Area__c = :buSelected and Product_Group__c != null and IsActive=:true order by Product_Group__c];
        List<Deal_Program_Product_Group__c> dealPrgGroupsList = [Select Product_Group__c,Id from Deal_Program_Product_Group__c where Deal_Registration_Program__c = :dealRegProgramId and BU__c = :buSelected order by Product_Group__c];
        for(Deal_Program_Product_Group__c temp : dealPrgGroupsList) {
            chosenList.add(new SelectOption(temp.Product_Group__c,temp.Product_Group__c));
            chosenListOld.add(new SelectOption(temp.Id,temp.Product_Group__c));
            prdGrpSet.add(temp.Product_Group__c);
        }
        for(Product2 prd : productsList) {
            if(!prdGrpSet.contains(prd.Product_Group__c)) {
                prdGrpSet.add(prd.Product_Group__c);
                availableList.add(new SelectOption(prd.Product_Group__c,prd.Product_Group__c));
            }
        }
    }
    
    public PageReference getProductGroups() {
        Set<String> prdGrpSet = new Set<String>();
        chosenList.clear();
        availableList.clear();
        chosenListOld.clear();
        List<Product2> productsList = [Select Product_Group__c from Product2 where Salesforce_CPQ_Product__c=false and Market_Focus_Area__c = :buSelected and Product_Group__c != null and IsActive=:true order by Product_Group__c];
        List<Deal_Program_Product_Group__c> dealPrgGroupsList = [Select Product_Group__c,Id from Deal_Program_Product_Group__c where Deal_Registration_Program__c = :dealProgramProductGroup.Deal_Registration_Program__c and BU__c = :buSelected order by Product_Group__c];
        for(Deal_Program_Product_Group__c temp : dealPrgGroupsList) {
            chosenList.add(new SelectOption(temp.Product_Group__c,temp.Product_Group__c));
            chosenListOld.add(new SelectOption(temp.Id,temp.Product_Group__c));
            prdGrpSet.add(temp.Product_Group__c);
        }
        for(Product2 prd : productsList) {
            if(!prdGrpSet.contains(prd.Product_Group__c)) {
                prdGrpSet.add(prd.Product_Group__c);
                availableList.add(new SelectOption(prd.Product_Group__c,prd.Product_Group__c));
            }
        }
        return null;
    }
    
    public PageReference saveDealProgramProductGroupsAndAddMore() {
        if(dealProgramProductGroup.Deal_Registration_Program__c == null || buSelected == '--Select--' || (chosenList.size() == 0 && chosenListOld.size() == 0)) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill in all required fields.');            
            ApexPages.addMessage(msg);
            return null;
        }
        Map<String,List<String>> itemsToDeleteOrSave = new Map<String,List<String>>();
        itemsToDeleteOrSave = getItemsToSaveOrDelete(chosenList,chosenListOld);
        List<String> itemsToInsert = itemsToDeleteOrSave.get('INSERT');
        List<String> itemsToDelete = itemsToDeleteOrSave.get('DELETE');
        List<Deal_Program_Product_Group__c> insertList = new List<Deal_Program_Product_Group__c>();
        List<Deal_Program_Product_Group__c> deleteList = new List<Deal_Program_Product_Group__c>();
        Deal_Program_Product_Group__c temp = null; 
        for(String tempStr : itemsToInsert) {
            temp = new Deal_Program_Product_Group__c();
            temp.Deal_Registration_Program__c = dealProgramProductGroup.Deal_Registration_Program__c;
            temp.BU__c = buSelected;
            temp.Product_Group__c = tempStr.trim();
            insertList.add(temp);
        }
        for(String tempStr : itemsToDelete) {
            temp = new Deal_Program_Product_Group__c(Id = tempStr);
            deleteList.add(temp);
        }
        try {
            if(insertList.size() > 0)
                insert(insertList);
            if(deleteList.size() > 0)
                delete(deleteList);    
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured while inserting the data.');            
            ApexPages.addMessage(msg);
            return null;        
        }
        
        buSelected = '';
        chosenList.clear();
        chosenListOld.clear();
        availableList.clear();
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product Groups are added successfully.');            
        ApexPages.addMessage(msg);        
        return null;
    }
    
    private Map<String,List<String>> getItemsToSaveOrDelete(List<SelectOption> chosenList, List<SelectOption> chosenListOld) {
        List<String> insertList = new List<String>();
        List<String> deleteList = new List<String>();
        Map<String,List<String>> insertDeleteMap = new Map<String,List<String>>();
        boolean found = false;
        for(SelectOption temp1 : chosenListOld) {
            found = false;
            for(SelectOption temp2 : chosenList) {
                if(temp1.getLabel() == temp2.getLabel()) {
                    found = true;
                }
            }
            if(!found) {
                deleteList.add(temp1.getValue());
            }
        }
        
        for(SelectOption temp1 : chosenList) {
            found = false;
            for(SelectOption temp2 : chosenListOld) {
                if(temp1.getLabel() == temp2.getLabel()) {
                    found = true;
                }
            }
            if(!found) {
                insertList.add(temp1.getValue());
            }
        }
        
        insertDeleteMap.put('INSERT',insertList);
        insertDeleteMap.put('DELETE',deleteList);
        return insertDeleteMap;
    }

    public PageReference saveDealProgramProductGroup() {
        if(dealProgramProductGroup.Deal_Registration_Program__c == null || buSelected == '--Select--' || (chosenList.size() == 0 && chosenListOld.size() == 0)) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill in all required fields.');            
            ApexPages.addMessage(msg);
            return null;
        }
        Map<String,List<String>> itemsToDeleteOrSave = new Map<String,List<String>>();
        itemsToDeleteOrSave = getItemsToSaveOrDelete(chosenList,chosenListOld);
        List<String> itemsToInsert = itemsToDeleteOrSave.get('INSERT');
        List<String> itemsToDelete = itemsToDeleteOrSave.get('DELETE');
        List<Deal_Program_Product_Group__c> insertList = new List<Deal_Program_Product_Group__c>();
        List<Deal_Program_Product_Group__c> deleteList = new List<Deal_Program_Product_Group__c>();
        Deal_Program_Product_Group__c temp = null; 
        for(String tempStr : itemsToInsert) {
            temp = new Deal_Program_Product_Group__c();
            temp.Deal_Registration_Program__c = dealProgramProductGroup.Deal_Registration_Program__c;
            temp.BU__c = buSelected;
            temp.Product_Group__c = tempStr.trim();
            insertList.add(temp);
        }
        for(String tempStr : itemsToDelete) {
            temp = new Deal_Program_Product_Group__c(Id = tempStr);
            deleteList.add(temp);
        }
        try {
            if(insertList.size() > 0)
                insert(insertList);
            if(deleteList.size() > 0)
                delete(deleteList);    
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured while inserting the data.');            
            ApexPages.addMessage(msg);
            return null;        
        }
        return new PageReference('/'+dealProgramProductGroup.Deal_Registration_Program__c);
    }
    
    public List<SelectOption> getBUValues() {
        List<Product2> prodAlignList = [Select Market_Focus_Area__c from Product2 where Salesforce_CPQ_Product__c=false and (Family =: 'Product' OR Family =: 'Mainframe Capacity') and Market_Focus_Area__c != null and isActive = true order by Market_Focus_Area__c];
        Set<String> buSet = new Set<String>();    
        List<SelectOption> buValuesTemp = new List<SelectOption>();
        buValuesTemp.add(new SelectOption('--Select--','--Select--'));
        for(Product2 temp :prodAlignList) {
            if(!buSet.contains(temp.Market_Focus_Area__c)) {
                buSet.add(temp.Market_Focus_Area__c);
                buValuesTemp.add( new SelectOption(temp.Market_Focus_Area__c,temp.Market_Focus_Area__c));
            }
        }
        return buValuesTemp;
    }
    
    @isTest(SeeAllData=true)
    public static void DealProgramProductGroupExt_test() {
        
        List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];
        
        Deal_Registration_Program__c delPgrm = new Deal_Registration_Program__c();
        delPgrm.name = 'TestDRP';
        delPgrm.Partner_Friendly_Name__c = 'TestDRP';
        delPgrm.Description__c = 'TestDRP';
        delPgrm.Program_Manager__c = approvers[0].Id;
        delPgrm.Program_Queries__c = approvers[1].Id;
        delPgrm.First_Approver__c = approvers[2].Id;
        delPgrm.Second_Approver__c = approvers[3].Id;
        delPgrm.Third_Approver__c = approvers[4].Id; 
        delPgrm.Max_Deal_Value__c = 1000;
        delPgrm.Min_Deal_Value__c = 100;
        delPgrm.Start_Date__c = Date.today();
        delPgrm.End_Date__c = Date.today() + 3;
        delPgrm.Expiry_Days__c = 10;        
        delPgrm.CurrencyIsoCode = 'USD';    
        delPgrm.Finance_Approver_Email__c = 'approver@ca.com';
        delPgrm.Geography__c = 'NA';
        delPgrm.Country2__c = 'IN-INDIA';
        delPgrm.Country1__c = 'US-USA';
        delPgrm.Partner_Program_Level__c = 'Platinum';
        delPgrm.Primary_Business_Functions__c = 'Technology Alliance';
        delPgrm.Secondary_Business_Functions__c = 'OEM';
        delPgrm.Deal_Program_Type__c = 'Alliance';
        insert delPgrm;
        
        Deal_Program_Product_Group__c dppg = new Deal_Program_Product_Group__c();
        dppg.Deal_Registration_Program__c = delPgrm.Id;
        ApexPages.StandardController dppgCtrl = new ApexPages.StandardController(dppg);
        DealProgramProductGroupExt dppgExt = new DealProgramProductGroupExt(dppgCtrl);
        dppgExt.buSelected = 'Security';
        dppgExt.getProductGroups();
        dppgExt.setProductGroups(delPgrm.Id);
        List<SelectOption> temp = new List<SelectOption>();
        temp.add( new SelectOption('ControlMinder','ControlMinder'));
        dppgExt.chosenList = temp;
        dppgExt.saveDealProgramProductGroup();
        dppgExt.chosenListOld = temp;
        List<SelectOption> tempOld = new List<SelectOption>();
        tempOld.add( new SelectOption('ControlMinder','ControlMinder'));
        tempOld.add(new SelectOption('DataMinder','DataMinder'));
        dppgExt.chosenList = tempOld;
        dppgExt.saveDealProgramProductGroupsAndAddMore();
        ApexPages.StandardController dppgCtrl1 = new ApexPages.StandardController(dppg);
        DealProgramProductGroupExt dppgExt1 = new DealProgramProductGroupExt(dppgCtrl1);
    }
}