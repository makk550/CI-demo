public class PDDSingle {
    
    
    Public String myAction{get; private set;}
    Public String sdunsID {get;set;}
    Public String sentID {get;set;}
    Public String sintID {get;set;}
    public String materialID {get;set;}
    public String saTip {get;set;} // Scale of Adoption Tip
    public String pstatTip {get;set;} // Product Status Tip
    public String cuTip {get;set;} // Capacity Used Tip
    public String crlTip {get;set;} // Client Release level Tip
    Public String btaTip {get;set;} // Barriers to Adoption Tip
    Public String biTip {get;set;} // Business Impact Tip
    Public String cspTip {get;set;} // Customer Success Program Tip
    Public String rrTip {get;set;} // Renewal Risk Tip
    Public String ctdTip {get;set;} //Competitive Technology Tip
    Public String pddComTip {get;set;} // PDD Comments Tip
    Public String baTip {get;set;} // Busienss Alighment Tip
    Public String upStatTip {get;set;} // Upgrade Status Tip
    Public String btupTip {get;set;} // Barriers to Upgrade Tip
    Public String brenewTip {get;set;}// Barriers to Renewal Tip 
    Public String UpPlanTip {get;set;}// Upgrade Plan Tip
    Public String LicUsedTip {get;set;}// Licenses Used Tip
    Public String LicUsdPercTip {get;set;}// Licenses Used Percentage Tip
    Public String ProdGALevTip {get;set;}// Product GA Level Tip    
    public String gaLevelVal{get;set;}
    public String productId{get;set;}
    public String valueStatment{get;set;}
    public String prodName{get;set;}
    public String materialName{get;set;}
    public String selectedAcctId{get;set;}
    public String selectedProdnameId {get;set;}
    Private String soql {get;set;}
    Private String sDefaultSortField;
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public Boolean isCVM {get;set;}
    public Date datename{get;set;}
    
    public List<SelectOption> optionsEnvType { get;set; }
    public List<SelectOption> optionsSoftType { get;set; }
    public List<SelectOption> optionsBI { get;set; }
    public List<SelectOption> optionsBTA { get;set; }
    public List<SelectOption> optionsCT { get;set; }
    public List<SelectOption> optionsCSP { get;set; }
    public List<SelectOption> optionsPS { get;set; }
    public List<SelectOption> optionsRR { get;set; }
    public List<SelectOption> optionsSA { get;set; }
    public List<SelectOption> optionsUP { get;set; } 
    public List<SelectOption> optionsBA { get;set; } 
    public List<SelectOption> optionsUPSTAT { get;set; } //Upgrade Status picklist
    public List<SelectOption> optionsBTU { get;set; } //Barriers to Upgrade picklist
    public List<SelectOption> listProducts {get;set;}
    public List<SelectOption> listProductNames {get;set;}
    
    public Map<String,Object> instMap{get;set;}
    public Map<String,Object> resultMap{get;set;}
    public Map<String,Boolean> instflapMap{get;set;}
    public Map<String,String> instDateMap{get;set;} //MANAR08
    
    public Account account {get;private set;}
    Public InstancePDD__c instA {get; private set;}
    Public InstancePDD__c instB {get; private set;}
    
    Public Active_Contract_Line_Item__c entA{get;set;}
    Public PDD__c pdd {get; private set;}
    Public PDD__c pddB {get; private set;}
    public List<Active_Contract_Line_Item__c> lstActiveItem{get;set;}
    Transient Public List <Active_Contract_Line_Item__c> conLineItemList = New List <Active_Contract_Line_Item__c>();
    Transient Public List <Active_Contract_Line_Item__c> EntList2 = New List <Active_Contract_Line_Item__c>();
    Transient Public List <InstancePDD__c> IntList1 = New List <InstancePDD__c>();
    Transient Public List <InstancePDD__c> IntList2 = New List <InstancePDD__c>();
    
    
    // Method for Constructor is used for Test Class.
    public PDDSingle(){
        
        size=50;
        sdunsID = ApexPages.currentPage().getParameters().get('dID');
        sentID = NULL;
        sintID = NULL;
        getAccount();
        getTips();
        isCVM =false;
    }
    
    /*public List<Active_Contract_Line_Item__c> getEntitlementsList() {
//System.debug('Con======'+con.getRecords());
return con.getRecords();
}*/
    public String versionCompare(String first, String second) {
            String[] fstArr = first.split('\\.');
            String[] secArr = second.split('\\.');
            
            Integer len = ((fstArr.size()>secArr.size())?secArr.size():fstArr.size());
            Integer i=0,t=0;
            while (i<len)
            {
                try{
                    if(Integer.valueOf(fstArr[i])>Integer.valueOf(secArr[i]))
                        {i++;t=1;break;}
                    else if(Integer.valueOf(fstArr[i])==Integer.valueOf(secArr[i]))
                        {t++;i++;}
                    else    
                        {t=0;break;}
                   }
                catch(Exception e)
                    {System.debug('fstArr[i] ==>' + fstArr + ' secArr==>' + secArr + 'len ==> ' +len);}
            }
            if(i>0 && t>0)
                return first;
            else
                return second;  
        }
    private String versionCompareSFDC(String first, String second){
        String[] fstArr = first.split('\\.');
        String[] secArr = second.split('\\.');
        Integer fstArrLen = fstArr.size();
        Integer secArrLen = secArr.size();
        System.debug('fstArrLen:'+fstArrLen);
        System.debug('secArrLen:'+secArrLen);
        
        Version v1,v2;
        if(fstArrLen == 1 && fstArr[0].isNumeric() ){        
            v1 = new Version(Integer.valueOf(fstArr[0]),0);     
        } else if( fstArrLen == 2 && fstArr[0].isNumeric() && fstArr[1].isNumeric()){            
            v1 = new Version(Integer.valueOf(fstArr[0]),Integer.valueOf(fstArr[1]));            
        } else if( fstArrLen == 3 && fstArr[0].isNumeric() && fstArr[1].isNumeric() && fstArr[2].isNumeric())  {            
            v1 = new Version(Integer.valueOf(fstArr[0]),Integer.valueOf(fstArr[1]),Integer.valueOf(fstArr[2]));
        }
        
        if(secArrLen == 1 && secArr[0].isNumeric()){
            v2 = new Version(Integer.valueOf(secArr[0]),0);
        } else if( secArrLen == 2 && secArr[0].isNUmeric() && secArr[1].isNUmeric()){
            v2 = new Version(Integer.valueOf(secArr[0]),Integer.valueOf(secArr[1]));
        } else if( secArrLen == 3 && secArr[0].isNUmeric() && secArr[1].isNUmeric() && secArr[2].isNumeric()) {
            v2 = new Version(Integer.valueOf(secArr[0]),Integer.valueOf(secArr[1]),Integer.valueOf(secArr[2]));
        } 
        
        if( v1!= null && v2!=null){
            if(  v1.compareTo(v2) > 0){  
                System.debug('Highest:'+ v1);
                return first;
                
            } else {
                System.debug('Highest:'+ v2);
                return second;
            }
        } else {
            return 'NotComparable';
        }    
}

    public List<Active_Contract_Line_Item__c> getContItemList() {
        
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> materialSet = new Set<Id>();
               
        
        try{
            con.getRecords();
            
            if(conLineItemList !=null){
                String temp;
                instMap = New Map<String,Object>();
                instDateMap =new Map<String,String>(); //MANAR08
                for(Active_Contract_Line_Item__c recd :conLineItemList){
                    materialSet.add(recd.Product_Material__c);
                    accIdSet.add(recd.Contract_Product__r.Active_Contract__r.Account__c);
                }
                
                for(InstancePDD__c  inst : [SELECT id, Name, Account_ID__c,Product_Material__c,Contact__c,Contact_2__c,Release_Version__c,LastModifiedDate FROM InstancePDD__c 
                                            where Account_ID__c IN :accIdSet and Product_Material__c = :materialSet
                                            and Is_Deleted__c = false])
                {
                    
                    if(instMap.containsKey(inst.Product_Material__c))
                    {
                        PddFetchDetails instFetch = (PddFetchDetails)instMap.get(inst.Product_Material__c);
                        if(String.isBlank(instFetch.relVer))
                            instFetch.relVer = inst.Release_Version__c;
                        else if(!String.isBlank(inst.Release_Version__c) && !String.isBlank(instFetch.relVer)){
                            temp = versionCompareSFDC(instFetch.relVer,inst.Release_Version__c);
                            if(temp != 'NotComparable'){
                                instFetch.relVer = temp;
                            }                            
                            //instFetch.relVer = versionCompare(instFetch.relVer,inst.Release_Version__c);
                        }
                            
                            
                        if(inst.LastModifiedDate>instFetch.lastModified)
                            instFetch.lastModified = inst.LastModifiedDate;
                        instMap.put(inst.Product_Material__c, instFetch);
                    }
                    else
                    {
                        PddFetchDetails instFetch =new PddFetchDetails(inst.LastModifiedDate,inst.Release_Version__c,true);
                        instMap.put(inst.Product_Material__c,instFetch);
                    }
                   
                }
   
                for(Active_Contract_Line_Item__c rec :conLineItemList){
                    if(!instMap.containskey(rec.Product_Material__c)){
                        instMap.put(rec.Product_Material__c,new PddFetchDetails(false) );
                    }
                }
                
                for(String pm : instMap.KeySet()){
                    DateTime dt = ((PddFetchDetails)instMap.get(pm)).lastModified;  
                    if(dt!=null){
                        instDateMap.put(pm, dt.format());
                    } else {
                        instDateMap.put(pm, '');
                    }                                   
                }
                
            }
        }
        catch(Exception e){
            System.debug('===' + e.getMessage() + '===' + e.getLineNumber());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'your profile may not have PDD access. please check with admin team to assign pdd Permission set');
            ApexPages.addMessage(myMsg);
        }
        return con.getRecords();
        
    }
    
    public List<InstancePDD__c> getInstanceList() {
        
        return con.getRecords();
    }
    
    public void getAccount(){
        
        if(sdunsID != null){
            try{
                account = [select id,name, Enterprise_ID__c from Account where ID = :sdunsID limit 1];
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Account for this Entitlement can be found.');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    
    public void getEntitlement(){
        
        if(sentID == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Entitlement passed to this page');
            ApexPages.addMessage(myMsg);
        } else {
            try
            {
                
                if(materialID !=null && productId !=null){
                    lstActiveItem = new List<Active_Contract_Line_Item__c>();
                    
                    for(Active_Contract_Line_Item__c contItem : [SELECT id,CreatedDate,LastModifiedDate,CreatedBy.Name,LastModifiedBy.Name,License_Type_Text__c,Contract_Product__r.Active_Contract__r.Ship_To_Site_Association__r.DUNS_Number__c,Contract_Product__r.Active_Contract__r.Account__r.GU_DUNS_NUMBER__c,OPERATIONAL_BU_F__c,
                                                                 Product_Material__r.CA_Product_Controller__r.name,Product_Material__r.Product__r.Name,Product_Material__r.Material_Text__c,Material__c,Licensed_Quantity__c,Orig_Installation_Date__c,
                                                                 Orig_Dismantle_Date__c, Contract_Product__r.Active_Contract__r.Account__r.Name,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.City__c,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.State__c,
                                                                 Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.Country_Picklist__c,Product_Material__c,Contract_Item__c,ATTRF_CRV__c,Calculated_Orig_ATTRF_USD__c,Orig_ATTRF_LC__c 
                                                                 FROM Active_Contract_Line_Item__c where Product_Material__c= :materialID and Product_Material__r.Product__c =:productId 
                                                                 AND Contract_Product__r.Active_Contract__r.Account__c =:sdunsID and Orig_Dismantle_Date__c > Today]){
                                                                     if(contItem.id == sentID){
                                                                         entA =contItem;
                                                                     }
                                                                     lstActiveItem.add(contItem);
                                                                     System.debug('lstActiveItem====='+lstActiveItem);                                              
                                                                 }                              
                    
                }
                else{
                    
                    entA = [SELECT id,CreatedDate,LastModifiedDate,CreatedBy.Name,LastModifiedBy.Name,License_Type_Text__c,Contract_Product__r.Active_Contract__r.Ship_To_Site_Association__r.DUNS_Number__c,Contract_Product__r.Active_Contract__r.Account__r.GU_DUNS_NUMBER__c,OPERATIONAL_BU_F__c,
                            Product_Material__r.CA_Product_Controller__r.name,Product_Material__r.Product__r.Name,Product_Material__r.Material_Text__c,Material__c,Licensed_Quantity__c,Orig_Installation_Date__c,
                            Orig_Dismantle_Date__c, Contract_Product__r.Active_Contract__r.Account__r.Name,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.City__c,Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.State__c,
                            Contract_Product__r.Active_Contract__r.End_User_Site_Association__r.Country_Picklist__c,Product_Material__c,Contract_Item__c,ATTRF_CRV__c,Calculated_Orig_ATTRF_USD__c,Orig_ATTRF_LC__c
                            FROM Active_Contract_Line_Item__c where  id = :sentID limit 1];
                    //entA = [SELECT Value_Statement__c, Account__c, Is_Auth`orized__c, Dismantle_Date__c, Dunsgp__c, Duns__c, Duns_Source__c, Entitlement_Type__c, Fulfillment_Status__c, Install_Date__c, Material_ID__c, Material_Text__c, Name, Product_Name__c, Product_Release__c, Business_Group__c, Product_Group__c, Ship_To_Name__c, Quantity__c, Sold_To_City__c, Sold_To_Country__c, Sold_To_State__c, Status__c, Type__c, CreatedDate, LastModifiedDate, CreatedBy.Name, LastModifiedBy.Name FROM EntitlementPDD__c where  id = :sentID limit 1];
                }
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Entitlement passed to this page');
                ApexPages.addMessage(myMsg);
            }
        }        
    }
    
    public void getInstance(){
        
        if(sintID != NULL){
            try{
                instA = [select id, Capacity_Used__c, Environment_Type__c, Product_Detail__c, Release_Version__c, Software_Type__c, Name, CreatedDate, LastModifiedDate, CreatedBy.Name, LastModifiedBy.Name,GA_level_Text__c,Contact__c,Contact__r.Name,Contact__r.email,Contact__r.phone,Contact_2__c,Contact_2__r.name,Contact_2__r.phone,Contact_2__r.email From InstancePDD__c where id = :sintID limit 1];
                pdd = [select id, Upgrade_Status__c,BarrierstoRenewal__c, Barriers_to_Upgrade__c, Licenses_Used__c, Licenses_Used_Percentage__c, Business_Alignment__c, Capacity_Used__c, Comments__c, Business_Impact__c, Barriers_to_Adoption__c, Competitive_Technology__c, CSP_Candidate__c, Production_Status__c, Renewal_Risk__c, Name, Scale_of_Adoption__c, Upgrade_Planned__c, CreatedDate, LastModifiedDate, CreatedBy.Name, LastModifiedBy.Name from PDD__c where Instance__c = :instA.id limit 1];    
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Adoption/ Risk information found for this instance!');
                ApexPages.addMessage(myMsg);
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Adoption/ Risk information found for this instance!');
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void copyInstance(){
        
        if (myAction == 'copyInst'){
            try{
                
                // entB = [select Material_ID__c, Product_Name__c, Product_Release__c  From EntitlementPDD__c where id = :sentID limit 1];
                instB = [select id, LastModifiedDate,CreatedBy.Name,LastModifiedBy.Name,Capacity_Used__c, Environment_Type__c, Product_Detail__c, Release_Version__c, Software_Type__c, Entitlement__r.Material_ID__c, Name,GA_level_Text__c,Contact__c,Contact_2__c From InstancePDD__c where id = :sintID limit 1];
                pddB = [select id, Upgrade_Status__c,BarrierstoRenewal__c, Barriers_to_Upgrade__c, Licenses_Used__c, Licenses_Used_Percentage__c, Business_Alignment__c, Capacity_Used__c, Comments__c, Business_Impact__c, Barriers_to_Adoption__c, Competitive_Technology__c, CSP_Candidate__c, Production_Status__c, Renewal_Risk__c, Scale_of_Adoption__c, Upgrade_Planned__c, Name from PDD__c where Instance__c = :instB.id limit 1];
                instA = new InstancePDD__c(Contact__c =instB.Contact__c ,Contact_2__c=instB.Contact_2__c,Account_ID__c= sdunsID ,Product_Material__c=materialID, Capacity_Used__c = instB.Capacity_Used__c, Environment_Type__c = instB.Environment_Type__c, Product_Detail__c = prodName, Release_Version__c = instB.Release_Version__c, Software_Type__c = instB.Software_Type__c, Name = instB.Name,GA_level_Text__c=instB.GA_level_Text__c,Sap_Material_ID__c=materialName );
                pdd = new PDD__c();
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Adoption/ Risk information found for this instance!');
                ApexPages.addMessage(myMsg);
            }
        }        
    }
    
    public void getInstanceEdit(){
        
        system.debug(myAction);
        
        if(myAction == 'newInst'){
            try{
                system.debug('Inside getInstandeEdit-newInst');
                //entB = [select Material_ID__c, Product_Name__c, Product_Release__c  From EntitlementPDD__c where id = :sentID limit 1];
                //instA = new InstancePDD__c(Entitlement__c = sentID, Product_Detail__c = entB.Product_Name__c);
                System.debug('~'+sdunsID+'~~'+materialID+'~~~'+prodName);
                instA = new InstancePDD__c(Account_ID__c= sdunsID ,Product_Material__c=materialID, Product_Detail__c = prodName,Sap_Material_ID__c=materialName);
                pdd = new PDD__c();
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Could not create new instance!');
                ApexPages.addMessage(myMsg);
            }
        }
        
        if (myAction == 'editInst'){
            try{
                pdd = new PDD__c();
                
                //entB = [select Material_ID__c, Product_Name__c, Product_Release__c  From EntitlementPDD__c where id = :sentID limit 1];
                instA = [select id, LastModifiedDate,CreatedBy.Name,LastModifiedBy.Name,Capacity_Used__c, Environment_Type__c, Product_Detail__c, Release_Version__c, Software_Type__c, Entitlement__r.Material_ID__c, Name,GA_level_Text__c,Contact__c,Contact_2__c From InstancePDD__c where id = :sintID limit 1];
                pdd = [select id, Upgrade_Status__c,BarrierstoRenewal__c, Barriers_to_Upgrade__c, Licenses_Used__c, Licenses_Used_Percentage__c, Business_Alignment__c, Capacity_Used__c, Comments__c, Business_Impact__c, Barriers_to_Adoption__c, Competitive_Technology__c, CSP_Candidate__c, Production_Status__c, Renewal_Risk__c, Scale_of_Adoption__c, Upgrade_Planned__c, Name from PDD__c where Instance__c = :instA.id limit 1];
                system.debug('Inside getInstandeEdit-editInst'+pdd);
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Adoption/ Risk information found for this instance!');
                ApexPages.addMessage(myMsg);
            }
        }
        
        //Environment Type Field Select
        optionsEnvType = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = InstancePDD__c.Environment_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsEnvType.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //Software Type Field
        optionsSoftType = new List<SelectOption>();
        fieldResult = InstancePDD__c.Software_Type__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsSoftType.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //Business Impact Field
        optionsBI = new List<SelectOption>();
        fieldResult = PDD__c.Business_Impact__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsBI.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //Barriers to Adoption Field
        optionsBTA = new List<SelectOption>();
        fieldResult = PDD__c.Barriers_to_Adoption__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsBTA.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //Competitive Technology Field
        optionsCT = new List<SelectOption>();
        fieldResult = PDD__c.Competitive_Technology__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsCT.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //CSP Candidate Field
        optionsCSP = new List<SelectOption>();
        fieldResult = PDD__c.CSP_Candidate__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsCSP.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        
        //Product Status Field
        optionsPS = new List<SelectOption>();
        fieldResult = PDD__c.Production_Status__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsPS.add(new SelectOption(f.getLabel(), f.getValue()));
        }         
        
        //Renewal Field
        optionsRR = new List<SelectOption>();
        fieldResult = PDD__c.Renewal_Risk__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsRR.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        
        //Scale of Adoption Field
        optionsSA = new List<SelectOption>();
        fieldResult = PDD__c.Scale_of_Adoption__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsSA.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        
        //Upgrade Planned Field
        optionsUP = new List<SelectOption>();
        fieldResult = PDD__c.Upgrade_Planned__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsUP.add(new SelectOption(f.getLabel(), f.getValue()));
        }   
        
        //Business Alignment Field
        optionsBA = new List<SelectOption>();
        fieldResult = PDD__c.Business_Alignment__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsBA.add(new SelectOption(f.getLabel(), f.getValue()));
        }  
        
        //Barrier to Upgrade Status Field
        optionsBTU = new List<SelectOption>();
        fieldResult = PDD__c.Barriers_to_Upgrade__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsBTU.add(new SelectOption(f.getLabel(), f.getValue()));
        }     
        
        //Upgrade Status Field
        optionsUPSTAT = new List<SelectOption>();
        fieldResult = PDD__c.Upgrade_Status__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            optionsUPSTAT.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        
    }
    
    // Instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                
                // System.debug('$$$'+sdunsID+'@@@'+sentID +'==='+sintID);
                if (sdunsID != NULL && sentID == NULL && sintID == NULL){
                    
                    //sDefaultSortField = 'Product_Group__c, Product_Name__c, Material_Text__c, Material_ID__c';
                    sDefaultSortField ='Product_Material__r.CA_Product_Controller__r.name,Product_Material__r.Product__r.Name,Product_Material__r.Material_Text__c,Material__c';
                    
                    //soql = 'SELECT id, Value_Statement__c, Dismantle_Date__c, Duns__c, Entitlement_Type__c, Install_Date__c, Material_ID__c, Material_Text__c, Product_Name__c, Product_Group__c, Quantity__c, Name, (Select id from Instances__r where Is_Deleted__c = FALSE limit 1) FROM EntitlementPDD__c where SFDC_Account_ID__c = :sdunsID and Dismantle_Date__c > Today and Is_Deleted__c = FALSE';                
                    soql  = 'SELECT id,Contract_Item__c,Contract_Product__r.Active_Contract__r.Ship_To_Site_Association__r.DUNS_Number__c,Product_Material__r.CA_Product_Controller__r.name,' +
                        'Product_Material__r.Product__r.Name,Product_Material__r.Product__c,Product_Material__r.Material_Text__c,Material__c,Licensed_Quantity__c,ATTRF_CRV__c, ' +
                        'Orig_Installation_Date__c,Orig_Dismantle_Date__c,License_Type_Text__c,Product_Material__c,Contract_Product__r.Active_Contract__r.Account__c,Calculated_Orig_ATTRF_USD__c,Orig_ATTRF_LC__c FROM Active_Contract_Line_Item__c ' +
                        ' WHERE Orig_Dismantle_Date__c > Today and Contract_Product__r.Active_Contract__r.Account__c =:sdunsID and Product_Material__c !=null ';
                    
                    
                    // Passing the String array to a list with Selected field sorting.
                    conLineItemList =Database.query(soql + ' order by ' + sDefaultSortField + ' ' + sortDir );
                    System.debug('====='+conLineItemList);
                    //EntList1 = Database.query(soql + ' order by ' + sDefaultSortField + ' ' + sortDir ); 
                    // setting values of List in StandardSetController.
                    List<Active_Contract_Line_Item__c> lstActiveItem =new List<Active_Contract_Line_Item__c>();
                    Set<String> prodSet = new Set<String>();
                    Set<String> prodNameSet = new Set<String>();
                    
                    if(conLineItemList !=null && conLineItemList.size()>0){
                        
                        listProducts = new List<SelectOption>();
                        listProducts.add(new SelectOption('', '-----------None-----------'));
                        
                        listProductNames = new List<SelectOption>();
                        listProductNames.add(new SelectOption('', '-----------None-----------'));
                        
                        
                        Map<String,Active_Contract_Line_Item__c> itemMap = new Map<String,Active_Contract_Line_Item__c>();
                        for(Active_Contract_Line_Item__c newItem : conLineItemList){
                            
                            if(itemMap.containskey(newItem.Product_Material__r.Product__c+'~'+newItem.Product_Material__c)){
                                
                                Active_Contract_Line_Item__c oldItem = itemMap.get(newItem.Product_Material__r.Product__c+'~'+newItem.Product_Material__c);
                                
                                if(newItem.Orig_Dismantle_Date__c <= oldItem.Orig_Dismantle_Date__c){
                                    
                                    itemMap.put(newItem.Product_Material__r.Product__c+'~'+newItem.Product_Material__c,newItem);
                                }
                            }
                            else{
                                
                                itemMap.put(newItem.Product_Material__r.Product__c+'~'+newItem.Product_Material__c,newItem);
                                
                                if(!prodSet.contains(newItem.Product_Material__r.CA_Product_Controller__r.name)){
                                    listProducts.add(new SelectOption(newItem.Product_Material__r.CA_Product_Controller__r.name, newItem.Product_Material__r.CA_Product_Controller__r.name));
                                    prodSet.add(newItem.Product_Material__r.CA_Product_Controller__r.name);
                                }
                                if(!prodNameSet.contains(newItem.Product_Material__r.Product__r.Name)){
                                    
                                    listProductNames.add(new SelectOption(newItem.Product_Material__r.Product__r.Name,newItem.Product_Material__r.Product__r.Name));
                                    prodNameSet.add(newItem.Product_Material__r.Product__r.Name);
                                }
                            }
                            
                            
                        }
                        
                        
                        lstActiveItem.addAll(itemMap.values());
                        
                    }
                    
                    con = new ApexPages.StandardSetController(lstActiveItem);
                    
                } else if (sdunsID != NULL && sentID != NULL && materialID !=null && sintID == NULL){
                    system.debug('inside set intlist');
                    sortField = 'Product_Detail__c';
                    // String Query
                    // soql = 'SELECT id, Name, Capacity_Used__c, Environment_Type__c, Product_Detail__c, Software_Type__c, Release_Version__c,GA_level_Text__c, (Select id, Licenses_Used__c from PDDs__r where Is_Deleted__c = false limit 1) FROM InstancePDD__c where Entitlement__c = :sentID and Is_Deleted__c = false';
                    soql = 'SELECT id, LastModifiedDate,CreatedBy.Name,LastModifiedBy.Name,Name, Capacity_Used__c, Environment_Type__c, Product_Detail__c, Software_Type__c, Release_Version__c,GA_level_Text__c,Contact__c,Contact_2__c, (Select id, Licenses_Used__c from PDDs__r where Is_Deleted__c = false limit 1) FROM InstancePDD__c where  Account_ID__c= :sdunsID and Product_Material__c=:materialID and Is_Deleted__c = false';
                    // Passing the String array to a list with Selected field sorting.
                    IntList1 = Database.query(soql + ' order by ' + sortField + ' ' + sortDir ); 
                    // setting values of List in StandardSetController.
                    con = new ApexPages.StandardSetController(IntList1);
                }
                // sets the number of records in each page set
                con.setPageSize(size);
                // gets the number of total records 
                noOfRecords = con.getResultSize();
            }
            return con;
        }
        set;
    }
    
    // Indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    // Indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // Returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // Returns the first page of records
    public void first() {
        con.first();
    }
    
    // Returns the last page of records
    public void last() {
        con.last();
    }
    
    // Returns the previous page of records
    public void previous() {
        con.previous();
    }
    
    // Returns the next page of records
    public void next() {
        con.next();
    }
    
    // Returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
    
    
    
    public void getTips(){
        
        saTip = PDD__c.Scale_of_Adoption__c.getDescribe().getInlineHelpText(); // Scale of Adoption Tip
        pstatTip = PDD__c.Production_Status__c.getDescribe().getInlineHelpText(); // Product Status Tip
        cuTip = PDD__c.Capacity_Used__c.getDescribe().getInlineHelpText(); // Capacity Used Tip
       
        btaTip = PDD__c.Barriers_to_Adoption__c.getDescribe().getInlineHelpText(); // Barriers to Adoption Tip
        biTip = PDD__c.Business_Impact__c.getDescribe().getInlineHelpText(); // Business Impact Tip
        cspTip = PDD__c.CSP_Candidate__c.getDescribe().getInlineHelpText(); // Customer Success Program Tip
        rrTip = PDD__c.Renewal_Risk__c.getDescribe().getInlineHelpText(); // Renewal Risk Tip
        ctdTip = PDD__c.Competitive_Technology__c.getDescribe().getInlineHelpText(); // Competitive Technology Tip
        pddComTip = PDD__c.Comments__c.getDescribe().getInlineHelpText(); // PDD Comments Tip
        baTip = PDD__c.Business_Alignment__c.getDescribe().getInlineHelpText(); // Business Alignment Tip
        upStatTip = PDD__c.Upgrade_Status__c.getDescribe().getInlineHelpText(); // Upgrade Status Tip
        btupTip = PDD__c.Barriers_to_Upgrade__c.getDescribe().getInlineHelpText(); // Barriers to Upgrade Tip
        brenewTip = PDD__c.BarrierstoRenewal__c.getDescribe().getInlineHelpText(); // Barriers to Renewal Tip
        UpPlanTip = PDD__c.Upgrade_Planned__c.getDescribe().getInlineHelpText(); // Upgrade Planned Tip
        LicUsedTip = PDD__c.Licenses_Used__c.getDescribe().getInlineHelpText(); // Licenses Used Tip
        LicUsdPercTip = PDD__c.Licenses_Used_Percentage__c.getDescribe().getInlineHelpText(); // Licenses Used Percentage Tip
        ProdGALevTip = InstancePDD__c.GA_level_Text__c.getDescribe().getInlineHelpText(); // Product GA level Tip
                        
    }
    
    //Toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        
        if (sdunsID != NULL && sentID == NULL && sintID == NULL){
            // String Query
            // sDefaultSortField  ='Product_Group__c, Product_Name__c, Material_Text__c, Material_ID__c';
            //soql = 'SELECT id, Value_Statement__c, Dismantle_Date__c, Duns__c, Entitlement_Type__c, Install_Date__c, Material_ID__c, Material_Text__c, Product_Name__c, Product_Group__c, Quantity__c, Name, (Select id from Instances__r where Is_Deleted__c = false limit 1) FROM EntitlementPDD__c where SFDC_Account_ID__c = :sdunsID and Dismantle_Date__c > Today and Is_Deleted__c = FALSE';                
            soql  = 'SELECT id,Contract_Product__r.Active_Contract__r.Account__c,Contract_Item__c,ATTRF_CRV__c,Contract_Product__r.Active_Contract__r.Ship_To_Site_Association__r.DUNS_Number__c,Product_Material__r.CA_Product_Controller__r.name,' +
                'Product_Material__r.Product__r.Name,Product_Material__r.Product__c,Product_Material__r.Material_Text__c,Material__c,Licensed_Quantity__c, ' +
                'Orig_Installation_Date__c,Orig_Dismantle_Date__c,License_Type_Text__c,Product_Material__c,Calculated_Orig_ATTRF_USD__c,Orig_ATTRF_LC__c FROM Active_Contract_Line_Item__c ' +
                ' WHERE Orig_Dismantle_Date__c > Today and Contract_Product__r.Active_Contract__r.Account__c =:sdunsID ';
            
            if(selectedAcctId !=null && selectedAcctId !=''){
                
                soql +='AND Product_Material__r.CA_Product_Controller__r.name =\''+selectedAcctId+ '\'';
            }
            
            if(selectedProdnameId !=null && selectedProdnameId !=''){
                
                soql +='AND Product_Material__r.Product__r.Name =\''+selectedProdnameId+ '\'';
            }
            System.debug('datename======'+datename);
            if(datename !=null ){
                
                String s =String.valueOf(datename);
                string[] s1=s.split(' ');
                
                soql +='AND Orig_Dismantle_Date__c ='+s1[0];
            }
            System.debug('sortField ===='+sortField);
            // Passing the String array to a list with Selected field sorting.
            EntList2 = Database.query(soql + ' order by ' + sortField + ' ' + sortDir ); 
            
            List<Active_Contract_Line_Item__c> lstActItem =new List<Active_Contract_Line_Item__c>();
            
            if(EntList2 !=null && EntList2.size()>0){
                
                Map<String,Active_Contract_Line_Item__c> itemMap = new Map<String,Active_Contract_Line_Item__c>();
                for(Active_Contract_Line_Item__c Item : EntList2){
                    
                    if(itemMap.containskey(Item.Product_Material__r.Product__c+'~'+Item.Product_Material__c)){
                        
                        Active_Contract_Line_Item__c oldItem = itemMap.get(Item.Product_Material__r.Product__c+'~'+Item.Product_Material__c);
                        
                        if(Item.Orig_Dismantle_Date__c <= oldItem.Orig_Dismantle_Date__c){
                            
                            itemMap.put(Item.Product_Material__r.Product__c+'~'+Item.Product_Material__c,Item);
                        }
                    }
                    else{
                        
                        itemMap.put(Item.Product_Material__r.Product__c+'~'+Item.Product_Material__c,Item);
                    }
                    
                    
                }
                
                
                lstActItem.addAll(itemMap.values());
                
            }
            // setting values of List in StandardSetController.
            con = new ApexPages.StandardSetController(lstActItem);
        } 
        if (sdunsID != NULL && sentID != NULL && sintID == NULL){
            // String Query
            // soql = 'SELECT id, Name, Capacity_Used__c, Environment_Type__c, Product_Detail__c, Software_Type__c, Release_Version__c,GA_level_Text__c, (Select id,Licenses_Used__c from PDDs__r where Is_Deleted__c = false limit 1) FROM InstancePDD__c where Entitlement__c = :sentID and Is_Deleted__c = FALSE';
            soql = 'SELECT id, Name,LastModifiedDate,CreatedBy.Name,LastModifiedBy.Name, Capacity_Used__c, Environment_Type__c, Product_Detail__c, Software_Type__c, Release_Version__c,GA_level_Text__c,Contact__c,Contact_2__c,(Select id, Licenses_Used__c from PDDs__r where Is_Deleted__c = false limit 1) FROM InstancePDD__c where  Account_ID__c= :sdunsID and Product_Material__c=:materialID ';
            // Passing the String array to a list with Selected field sorting.
            IntList2 = Database.query(soql + ' order by ' + sortField + ' ' + sortDir ); 
            // setting values of List in StandardSetController.
            con = new ApexPages.StandardSetController(IntList2);
        }
        // Set Page Size
        con.setPageSize(size);
        noOfRecords = con.getResultSize();
    }
    
    // the current sort direction. defaults to asc
    public String sortDir {
        // To set a Direction either in ascending order or descending order.
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;}
        set;
    }
    
    // the current field to sort by
    public String sortField {
        get  { if (sortField == null) {sortField = sDefaultSortField; } return sortField;  }
        set;
    } 
    
    public pageReference refresh() {
        if (sdunsID != NULL && sentID == NULL && sintID == NULL){
            con = null;
            // getEntitlementsList();
            getContItemList();
            con.setPageNumber(1);
        }
        if (sdunsID != NULL && sentID != NULL && sintID == NULL){
            con = null;
            getInstanceList();
            con.setPageNumber(1);
        }
        return null;
    }
    
    public PageReference goEntList(){
        
        con = null;
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = NULL;
        sintID = NULL;
        myAction = NULL;
        // getEntitlementsList();
        getContItemList(); //MANAR08
        toggleSort();
       // getContItemList();
        con.setPageNumber(1);
        return null;
    }    
    
    public PageReference goInstList(){
        
        con = null;
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        sintID = ApexPages.currentPage().getParameters().get('myIntId');
        materialID = ApexPages.currentPage().getParameters().get('materialId');
        System.debug('====##'+materialID);
        productId = ApexPages.currentPage().getParameters().get('productId');
        myAction='dispInstList';
        sortField = 'Product_Detail__c';
        getEntitlement();
        getInstanceList();
        getValStatment();
        con.setPageNumber(1);
        
        isCVM =true;
        return null;
    }
    
    public void getValStatment(){
        
        
        Account_Value_Statement__c[] valStmt = [select id,Value_Statement__c from Account_Value_Statement__c where Account__c=: sdunsID  and Product_Material__c=:materialID];
        System.debug(''+valStmt );    
        if(valStmt.size()>0){
            valueStatment =valStmt[0].Value_Statement__c ;
        }
        
    }
    
    public PageReference goSaveRelStatement(){
        
        try {
            //update(entA);
            sdunsID = ApexPages.currentPage().getParameters().get('myDID');
            materialID = ApexPages.currentPage().getParameters().get('materialId');
            Account_Value_Statement__c valStmt =new Account_Value_Statement__c();
            
            Account_Value_Statement__c[] valStmtId = [select id,Product_Material__c,Account__c,Value_Statement__c from Account_Value_Statement__c where Product_Material__c=:materialID and Account__c=: sdunsID];
            
            
            if(valStmtId.size()>0){
                valStmt.id = valStmtId[0].Id;
            }
            else{
                
                valStmt.Account__c = sdunsID;
                valStmt.Product_Material__c =materialID ;
            }
            valStmt.Value_Statement__c  = valueStatment;
            
            upsert valStmt;
            System.debug('======##'+valStmt);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    public PageReference goViewInst(){
        
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        sintID = ApexPages.currentPage().getParameters().get('myIntId');
        myAction='dispInst';
        getEntitlement();
        getInstance();
        return null;
    }
    
    public PageReference goEditInst(){
        
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        sintID = ApexPages.currentPage().getParameters().get('myIntId');
        myAction='editInst';
        getEntitlement();
        getInstanceEdit();
        return null;
    }
    
    public PageReference copyInst(){
        
        
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        sintID = ApexPages.currentPage().getParameters().get('myIntId');
        prodName= ApexPages.currentPage().getParameters().get('prodName');
        materialID = ApexPages.currentPage().getParameters().get('materialId');
        materialName = ApexPages.currentPage().getParameters().get('materialName');
        myAction='copyInst';
        getEntitlement();
        copyInstance();
        try {
            System.debug('====='+instA);
            upsert(instA);
            pdd.Instance__c = instA.id;
           
            pdd.Capacity_Used__c = instA.Capacity_Used__c;
            pdd.Upgrade_Status__c = pddB.Upgrade_Status__c;
            pdd.Barriers_to_Upgrade__c = pddB.Barriers_to_Upgrade__c;
            pdd.Business_Alignment__c = pddB.Business_Alignment__c;
            pdd.Comments__c = pddB.Comments__c;
            pdd.Business_Impact__c = pddB.Business_Impact__c;
            pdd.Competitive_Technology__c = pddB.Competitive_Technology__c;
            pdd.CSP_Candidate__c = pddB.CSP_Candidate__c;
            pdd.Production_Status__c = pddB.Production_Status__c;
            pdd.Renewal_Risk__c = pddB.Renewal_Risk__c;
            pdd.Scale_of_Adoption__c = pddB.Scale_of_Adoption__c;
            pdd.Upgrade_Planned__c = pddB.Upgrade_Planned__c;
            pdd.Licenses_Used__c = pddB.Licenses_Used__c;
            pdd.BarrierstoRenewal__c= pddB.BarrierstoRenewal__c;
            insert(pdd);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
        sintID = null;
        myAction = 'dispInstList';
        con = null;
        getInstanceList();
        con.setPageNumber(1);
        return null;
    }    
    
    public PageReference goNewInst(){
        
        
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        materialID = ApexPages.currentPage().getParameters().get('materialId');
        prodName= ApexPages.currentPage().getParameters().get('prodName');
        materialName = ApexPages.currentPage().getParameters().get('materialName'); 
        sintID = NULL;
        myAction='newInst';
        getEntitlement();
        getInstanceEdit();
        return null;
    }
    
    public PageReference goSaveInst(){
        
        
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        System.debug('sdunsID ==='+sdunsID);
        sintID = NULL;
        myAction='saveInst';
        getEntitlement();
        getInstanceEdit();         
        try {
            System.debug('==='+instA);
            upsert(instA);
            pdd.Instance__c = instA.id;
           
            pdd.Capacity_Used__c = instA.Capacity_Used__c;
            upsert(pdd);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
        con = null;
        getInstanceList();
        con.setPageNumber(1);
        
        return null;
    }
    
    public PageReference goInstCancel(){
        
        
        con = null;
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        sentID = ApexPages.currentPage().getParameters().get('myEntID');
        sintID = NULL;
        myAction='dispInstList';
        sortField = 'Product_Detail__c';
        getEntitlement();
        getInstanceList();
        con.setPageNumber(1);
        return null;
    }
    
    Public PageReference goDelInst(){
        
        // System.debug('Inside goDelInst');
        String delID = ApexPages.currentPage().getParameters().get('intID');
        
        try{
            InstancePDD__c doomedInstances = [Select ID, Name,GA_level_Text__c from InstancePDD__c where id = :delID limit 1];
            doomedInstances.Is_Deleted__c = true;
            update(doomedInstances);
        }catch (DmlException e){
            //Process exception
            System.debug('Installation not deleted');
        }
        con = null;
        getInstanceList();
        con.setPageNumber(1);
        return null;
    }
    
    public PageReference goCustoVersionData(){
        
        PageReference retURL = new PageReference('/apex/PDDCustomerVersion?id='+sdunsID);
        retURL.setRedirect(true);
        return retURL;
        
    }
    
}