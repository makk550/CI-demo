public class TPC_CreateCaseExtension {
    Public Case newCase{get;set;}
    public List<selectOption> siteIds{get;set;}
    public List<selectOption> TPCTeamContacts{get;set;}
    public List<selectOption> owners{get;set;}
    public List<selectOption> TPCTeamComponents{get;set;}
    public String siteIdSelected{get;set;}
    private Map<String,String> componentToControllerMap{get;set;}
    public List<SelectOption> contacts{get;set;}
    public String selectedContactId{get;set;}
    public Boolean isEditing{get;set;}
    private Map<String,String> siteTOPSIdMap;
    public List<SelectOption> CAProducts{get;set;}
    public List<SelectOption> CAComponents{get;set;}
    public List<SelectOption> CAProductRelease{get;set;}
    public List<SelectOption> CAOperatingSys{get;set;}
    Map<String,List<componentWrapper>> CAproductToControllerMap;
    Map<String,String> productIdtoName;
    public String compText {get;set;}
    
    public TPC_CreateCaseExtension(ApexPages.StandardController controller){
        String caseId = ApexPages.currentPage().getParameters().get('Id');
        if(caseId != NULL)
            isEditing = true;
        List<String> fieldsList = new List<String>{'Site_Association__c'};
            if(!test.isRunningTest()){    
                controller.addFields(fieldsList);
            }
        newCase = (case) controller.getRecord();
        siteIdSelected = newCase.Site_Association__c;
        siteIds = new List<SelectOption>();
        TPCTeamContacts = new List<SelectOption>();
        owners = new List<SelectOption>();
        TPCTeamComponents = new List<selectOption>();
        contacts = new List<SelectOption>();
        componentToControllerMap = new Map<String,String>();
        siteTOPSIdMap = new Map<String,String>();
        CAProducts = new List<SelectOption>();
        CAComponents = new List<SelectOption>();
        CAProductRelease = new List<SelectOption>();
        CAOperatingSys = new List<SelectOption>();
        CAproductToControllerMap = new Map<String,List<componentWrapper>>();
        productIdtoName = new Map<String,String>();
        
        User communityUser = [select id,contact.TPC_Team__c,firstName,LastName from user where id=: UserInfo.getUserId()];
        
        //if user contact tpc team is not null, get all the sites associates with that tpc team
        if(communityUser.contact.TPC_Team__c != NULL){
            TPC_Team__c  tpcteam= [select id,Name,Tops_Site_Id__c from TPC_Team__C where id=: communityUser.contact.TPC_Team__c];
            //if there are sites associated with TPC Team, make a pick list from that
            if(tpcteam.Tops_Site_Id__c != NULL && tpcteam.Tops_Site_Id__c.trim() != ''){
                for(Site_Association__c site : [select id,name,SC_TOPS_ID__c from Site_Association__c where SC_TOPS_ID__c IN : tpcteam.Tops_Site_Id__c.split(';')]){
                    siteIds.add(new selectOption(site.Id,site.SC_TOPS_ID__c+'-'+site.Name));
                    siteTOPSIdMap.put(site.Id,site.SC_TOPS_ID__c);
                }
            }
            getSiteContacts();
            TPCTeamContacts.add(new SelectOption('','--None--'));
            owners.add(new SelectOption('','--None--'));
            
            //get All the contacts that belongs to that TPC team and put in a list of selectoption
            for(User TPCCon : [select id,name from USER where  contactId IN (select id from contact where TPC_Team__c =: communityUser.contact.TPC_Team__c)]){
                TPCTeamContacts.add(new SelectOption(TPCCon.id,TPCCon.Name));
                owners.add(new SelectOption(TPCCon.id,TPCCon.Name));
            }
            
            for(Group TPCCon : [select Id,name from Group where Name =: tpcteam.Name  and Type = 'Queue']){
                owners.add(new SelectOption(TPCCon.id,TPCCon.Name));
            }
            
            //get All the CA_Product_Components related to the TPC Team and show them on page.
            for(TPCTeamProductCodeAssociation__c productAssociation : [select id,CA_Product_Component__c,CA_Product_Component__r.Name,CA_Product_Component__r.CA_Product_Text__c,CA_Product_Component__r.Component_Code__c,	CA_Product_Component__r.Component_Text__c,CA_Product_Component__r.CA_Product_Controller__c,CA_Product_Component__r.CA_Product_Controller__r.Name from TPCTeamProductCodeAssociation__c where TPC_Team__c =: communityUser.contact.TPC_Team__c]){
                if((!componentToControllerMap.containsKey(productAssociation.CA_Product_Component__c) || (componentToControllerMap.containsKey(productAssociation.CA_Product_Component__c) && componentToControllerMap.get(productAssociation.CA_Product_Component__c) != productAssociation.CA_Product_Component__r.CA_Product_Controller__c))){
                    TPCTeamComponents.add(new SelectOption(productAssociation.CA_Product_Component__c,productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name+'-'+productAssociation.CA_Product_Component__r.Name));
                    //TPCTeamComponents.add(new SelectOption(productAssociation.CA_Product_Component__c,productAssociation.CA_Product_Component__r.CA_Product_Text__c+'-'+productAssociation.CA_Product_Component__r.Component_Code__c));
                    componentToControllerMap.put(productAssociation.CA_Product_Component__c,productAssociation.CA_Product_Component__r.CA_Product_Controller__c);
                }
            }
            CAProducts.add(new SelectOption('','---None---'));
            for(TPCTeamProductCodeAssociation__c productAssociation : [select id,CA_Product_Component__c,CA_Product_Component__r.Name,CA_Product_Component__r.CA_Product_Text__c,CA_Product_Component__r.Component_Code__c,	CA_Product_Component__r.Component_Text__c,CA_Product_Component__r.CA_Product_Controller__c,CA_Product_Component__r.CA_Product_Controller__r.Name from TPCTeamProductCodeAssociation__c where TPC_Team__c =: communityUser.contact.TPC_Team__c]){
                if(!new Set<String>(productIdtoName.values()).contains(productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name))
                    CAProducts.add(new SelectOption(productAssociation.CA_Product_Component__r.CA_Product_Controller__c,productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name));
                List<componentWrapper> componentsList = CAproductToControllerMap.get(productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name);
                productIdtoName.put(productAssociation.CA_Product_Component__r.CA_Product_Controller__c,productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name);
                if(componentsList == NULL){
                    componentsList = new List<componentWrapper>();
                    CAproductToControllerMap.put(productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name,componentsList);
                }
                system.debug('Wrapper value is here'+productAssociation.CA_Product_Component__r.CA_Product_Controller__c+' other value is '+productAssociation.CA_Product_Component__r.CA_Product_Controller__r.Name);
                componentsList.add(new componentWrapper(productAssociation.CA_Product_Component__c,productAssociation.CA_Product_Component__r.Name,productAssociation.CA_Product_Component__r.Component_Code__c,productAssociation.CA_Product_Component__r.Component_Text__c));
                system.debug('Wrapper value is here'+componentsList);
            }
            getCAComponentList();
            CAComponentText();
            //getCAProductRelease();
            //getOperatingSystems();
        }
        
        
    }
    
    public class componentWrapper{
        public String id;
        public String componentName;
        public String componentCode;
        public String componentText;
        public componentWrapper(String id,String componentName,String componentCode,String componentText){
            this.id = id;
            this.componentName = componentName;
            this.componentCode = componentCode;
            this.componentText = componentText;
        }
    }
    public void getValuesFromController(){
        newCase.Product_Release_Selection__c = NULL;
        getCAComponentList();
        //getCAProductRelease();
        //getOperatingSystems();
    }
    
    public pagereference CAComponentText(){
         system.debug('Text value is here Blank');
        try{
        if(newCase.CA_Product_Controller__c != NULL){
            if(newCase.CA_Product_Component__c != NULL){
                system.debug('Problem value: '+newCase.CA_Product_Controller__c);
                for(componentWrapper component : CAproductToControllerMap.get(productIdtoName.get(newCase.CA_Product_Controller__c))){
                    if(newCase.CA_Product_Component__c == component.id){
                        system.debug('Text value is here'+component.componentText);
                        compText = component.componentCode;
                        
                        
                    }
                }
            }
        }
        }
        catch(exception e){
            compText = '';
        }
        return null;
    }
    public void getCAComponentList(){
        CAComponents = new List<SelectOption>();
        CAComponents.add(new SelectOption('','--None--'));
        if(newCase.CA_Product_Controller__c != NULL){
            if(productIdtoName.containsKey(newCase.CA_Product_Controller__c) && CAproductToControllerMap.containsKey(productIdtoName.get(newCase.CA_Product_Controller__c))){
                for(componentWrapper component : CAproductToControllerMap.get(productIdtoName.get(newCase.CA_Product_Controller__c))){
                    CAComponents.add(new SelectOption(component.id,component.componentText));
                }
            }
        }
    }
    
    /*  public void getCAProductRelease(){
CAProductRelease = new List<SelectOption>();
CAProductRelease.add(new SelectOption('','--None--'));
if(newCase.CA_Product_Controller__c != NULL){
for(Product_Material__c material : [select id,(select id,Name from Product_Releases__r) from Product_Material__c where CA_Product_Controller__c =: newCase.CA_Product_Controller__c]){
for(Product_Release__c release : material.Product_Releases__r){
CAProductRelease.add(new SelectOption(release.Id,release.Name));
}
}
}
}

public void getOperatingSystems(){
CAOperatingSys = new List<SelectOption>();
CAOperatingSys.add(new SelectOption('','--None--'));
if(newCase.Product_Release_Selection__c != NULL){
for(Product_Release_and_Operating_System__c OS : [select id,Name from Product_Release_and_Operating_System__c where Product_Release__c =: newCase.Product_Release_Selection__c]){
CAOperatingSys.add(new SelectOption(OS.Id,OS.Name));
}
}
}

*/
    
    public PageReference createCase(){
        PageReference detailPage;
        newCase.Site_Association__c  = siteIdSelected;
        //newCase.Product_Material__c = 'a2F190000004kB4';
        
        if(newCase.CA_Product_Component__c == NULL){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose CA Product Component');
            ApexPages.addMessage(errorMessage);
            return NULL;
        }
        newCase.BusinessHoursId  = '01ma0000000PSQYAA4';
        System.debug('*** new Case is ***'+newCase);
        try{
           System.debug('####Contact is '+newCase.contactId);
            upsert newCase;
            detailPage = new PageReference('/'+newCase.Id);
        }
        catch(DMLException e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDmlMessage(0));
            ApexPages.addMessage(errorMessage);
            detailPage = NULL;
        }    
        
        return detailpage;
    }
    
    public void getSiteContacts(){
        //reset site contacts list and add contacts related to site selected
        String topsId = siteIdSelected == NULL ? siteTOPSIdMap.get( new List<String>(siteTOPSIdMap.keySet())[0]) : siteTOPSIdMap.get(siteIdSelected);
        newCase.Site_Association__c = NULL;
        contacts = new List<SelectOption>();
        contacts.add(new SelectOption('','--None--'));
        for(Contacts_Site_Association__c contactSite : [select id,SC_CSA_SITE__c,SC_CSA_CONTACTS__r.Name,SC_CSA_CONTACTS__c from Contacts_Site_Association__c  where SC_CSA_SITE__r.SC_TOPS_ID__c =: topsId]){
            contacts.add(new SelectOption(contactSite.SC_CSA_CONTACTS__c,contactSite .SC_CSA_CONTACTS__r.Name));
        }
        System.debug(contacts);
    }
}