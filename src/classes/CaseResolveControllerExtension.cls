public class CaseResolveControllerExtension {
        public Case caseRec {get;set;}
        public boolean isVDA {get;set;}
        public boolean VDAProductController{get;set;}
        public boolean VDAProductComponent{get;set;}
        public boolean VDAFunction{get;set;}
        public Case objCase {get;set;}
        public  String caseId {get;set;}
        public Map<String,String> functionMap{get;set;}
        public Map<String,String> categoryMap{get;set;}
        public Map<String,String> subCategoryMap{get;set;}
        public static Map<String,String> stageStatusMap=new Map<String,String>{
            '5. Solution Provided'=>'Solution Provided',
            '6. Solution Deferred'=>'Solution Deferred',
            '7. Closed'=>'Closed',
            '5. Barrier Removed'=>'Closed',
            '6. End Engagement'=>'Closed' , 
            '7. End Engagement'=>'Closed'  
        };
        
        public CaseResolveControllerExtension(ApexPages.StandardController stdController) {
            objCase = new Case();
            this.caseRec = (Case)stdController.getRecord();
            caseId = ApexPages.currentPage().getParameters().get('Id');
            objCase = [SELECT Id,Case_Type__c,Troubleshooting_Stage__c,Next_Action__c,Next_Action_Due_Date__c,VDAStage__c,VDANextActionOwner__c,
                        Status,Resolution__c,Reason,Additional_Info__c,
                        CA_Product_Controller__c,CA_Product_Component__c,Product_Material__c,
                        Product_Release_Selection__c,Function__c,Function_text__c,Category__c,Subcategory__c,Root_Cause_Category_vda__c,Root_Cause_Sub_Category__c,Root_Cause_Category_Text__c,Root_Cause_Sub_Category_Text__c,Reason_for_Reopen__c,CaseResolvePageHidden__c FROM Case WHERE Id =:caseId];
            
            if(stageStatusMap.get(objCase.Troubleshooting_Stage__c)!=null){
                objCase.VDAStage__c=objCase.Troubleshooting_Stage__c ;
                objCase.VDANextActionOwner__c =objCase.Next_Action__c;
            }else{
                objCase.VDAStage__c= null;
                objCase.VDANextActionOwner__c= null;   
            }   
            if(objCase.Case_Type__c=='Proactive'){
                objCase.VDAStage__c='7. End Engagement';
            }
        }
        
        public void checkVDA(){
            isVDA=false;
            if(objCase.CA_Product_Controller__c!=null){
                VDAProductController = [SELECT VDA_Product__c FROM CA_Product_Controller__c where id=:objCase.CA_Product_Controller__c].VDA_Product__c;
            }if(objCase.CA_Product_Component__c!=null){
                VDAProductComponent = [SELECT VDA_Product_Component__c  FROM CA_Product_Component__c where id=:objCase.CA_Product_Component__c].VDA_Product_Component__c;
            }
            system.debug('VDAProductController-->'+VDAProductController);
            system.debug('VDAProductComponent-->'+VDAProductComponent);
            if(VDAProductController==true && VDAProductComponent==true){
                isVDA=true;
            }
            system.debug('isVDA-->'+isVDA);
        }
        
         public PageReference checkVDAOnLoad(){
            checkVDA();
            if(isVDA==true && objCase.Case_Type__c!='Proactive'){
                objCase.Category__c=null;
                objCase.Subcategory__c=null;
            }else{
                objCase.Function__c=null;
                objCase.Root_Cause_Category_vda__c=null;
                objCase.Root_Cause_Sub_Category__c=null;
            }
            getFunctionList();
            return null;
        }
        public PageReference checkVDAOnChange(){
            checkVDA();
            objCase.Category__c=null;
            objCase.Subcategory__c=null;
            objCase.Function__c=null;
            objCase.Root_Cause_Category_vda__c=null;
            objCase.Root_Cause_Sub_Category__c=null;
            getFunctionList();
            return null;
        }
        
        public List<SelectOption> getFunctionList() {
                List<SelectOption> options = new List<SelectOption>();
                options.clear();
                options.add(new SelectOption('', '--None--'));
                functionMap = new Map<String,String>(); 
                for (Function__c function_c : [SELECT Id, Name FROM Function__c where CA_Product_Controller__c=:objCase.CA_Product_Controller__c and CA_Product_Component__c=:objCase.CA_Product_Component__c order by Name asc]) {
                    options.add(new SelectOption(function_c.Id, function_c.Name));
                    functionMap.put(function_c.Id,function_c.Name);
                }
                return options;
        }
        
        public List<SelectOption> getRootCauseCategoryList() {
                List<SelectOption> options = new List<SelectOption>();
                options.clear();
                options.add(new SelectOption('', '--None--'));
                if(objCase.Function__c!=null && !String.isBlank(objCase.Function__c)){
                    categoryMap = new Map<String,String>(); 
                    for (Root_Cause_Category__c rootCauseCategory_c : [SELECT Id, Name FROM Root_Cause_Category__c where Function__c =:objCase.Function__c order by Name asc]) {
                         options.add(new SelectOption(rootCauseCategory_c.Id, rootCauseCategory_c.Name));
                         categoryMap.put(rootCauseCategory_c.Id,rootCauseCategory_c.Name);
                    }
                }
             return options;
        }
        public List<SelectOption> getRootCauseSubCategoryList() {
                List<SelectOption> options = new List<SelectOption>();
                options.clear();
                options.add(new SelectOption('', '--None--'));
                String functionName='';
                if(objCase.Function__c!=null && !String.isBlank(objCase.Function__c)){
                    functionName= [SELECT Name FROM Function__c where id =:objCase.Function__c].Name;
                }
                if(objCase.Root_Cause_Category_vda__c!=null && !String.isBlank(objCase.Root_Cause_Category_vda__c) && functionName!=null && !String.isBlank(functionName)){
                subCategoryMap = new Map<String,String>();  
                  for (Root_Cause_Sub_category__c rootCauseSubCategory_c : [SELECT Id, Name FROM Root_Cause_Sub_category__c where Root_Cause_Category__c =:objCase.Root_Cause_Category_vda__c and Function_Name__c=:functionName order by Name asc]) {
                        options.add(new SelectOption(rootCauseSubCategory_c.Id, rootCauseSubCategory_c.Name));
                        subCategoryMap.put(rootCauseSubCategory_c.Id,rootCauseSubCategory_c.Name);
                    }
                    if(options.size()==2){
                        options.remove(0);
                    }
                }
                return options;
        }
        
        public PageReference save()
        {  
            PageReference p = apexPages.currentPage();  
            boolean updateCaseFlag=true;
            try{
                objCase.CaseResolvePageHidden__c='CaseResolvePage';
                objCase.Troubleshooting_Stage__c=objCase.VDAStage__c ;
                objCase.Next_Action__c=objCase.VDANextActionOwner__c ;
                objCase.Status=stageStatusMap.get(objCase.VDAStage__c);
                system.debug('objCase.Troubleshooting_Stage__c-->'+objCase.Troubleshooting_Stage__c);
                system.debug('objCase.Status-->'+objCase.Status);
                
                if(objCase.Status=='Closed'){
                    objCase.Next_Action_Due_Date__c =null;
                }
                
                if(objCase.Troubleshooting_Stage__c == NULL) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Stage field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.Next_Action__c == NULL) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Next Action Owner field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.Next_Action_Due_Date__c == NULL && objCase.Status!='Closed') {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Next Action Due Date field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.CA_Product_Controller__c == NULL) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'CA Product field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.CA_Product_Component__c == NULL ) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'CA Product Component field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.Product_Release_Selection__c == NULL ){
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Product Release field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.Product_Material__c == NULL) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Product Code field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.Resolution__c == NULL) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Resolution field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                if(objCase.Reason == NULL) {
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Reason field is mandatory.');
                    ApexPages.addMessage(msg);
                    updateCaseFlag=false;
                }
                checkVDA();
                if(isVDA==true && objCase.Case_Type__c!='Proactive'){
                    if(objCase.Function__c == NULL ){
                        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Function field is mandatory for VDA product.');
                        ApexPages.addMessage(msg);
                        updateCaseFlag=false;
                    }if(objCase.Root_Cause_Category_vda__c == NULL ){
                        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Root Cause Category field is mandatory for VDA product.');
                        ApexPages.addMessage(msg);
                        updateCaseFlag=false;
                    }if(objCase.Root_Cause_Sub_Category__c == NULL ){
                        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Root Cause Subcategory field is mandatory for VDA product.');
                        ApexPages.addMessage(msg);
                        updateCaseFlag=false;
                    }
                    //Set VDA categories and Subcategories to Category__c picklist fields
                    if(objCase.Function__c!=null && !String.isBlank(objCase.Function__c)){
                        objCase.Function_text__c=functionMap.get(objCase.Function__c);
                    }
                    if(objCase.Root_Cause_Category_vda__c!=null &&!String.isBlank(objCase.Root_Cause_Category_vda__c)){
                        objCase.Root_Cause_Category_Text__c=categoryMap.get(objCase.Root_Cause_Category_vda__c);
                    }
                    if(objCase.Root_Cause_Sub_Category__c!=null &&!String.isBlank(objCase.Root_Cause_Sub_Category__c)){
                        objCase.Root_Cause_Sub_Category_Text__c=subCategoryMap.get(objCase.Root_Cause_Sub_Category__c);
                    }
                }else{
                    if(objCase.Category__c == NULL ){
                        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Root Cause Category field is mandatory.');
                        ApexPages.addMessage(msg);
                        updateCaseFlag=false;
                    }if(objCase.Subcategory__c == NULL ){
                        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Root Cause Subcategory field is mandatory.');
                        ApexPages.addMessage(msg);
                        updateCaseFlag=false;
                    }
                    objCase.Function_text__c='N/A';
                    if(objCase.Category__c!=null &&!String.isBlank(objCase.Category__c)){
                        objCase.Root_Cause_Category_Text__c=objCase.Category__c;
                    }
                    if(objCase.Subcategory__c!=null &&!String.isBlank(objCase.Subcategory__c)){
                        objCase.Root_Cause_Sub_Category_Text__c=objCase.Subcategory__c;
                    }
                }
                system.debug('updateCaseFlag-->'+updateCaseFlag);
               if(updateCaseFlag){
                    update objCase;
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Updated Successfully!');
                    ApexPages.addMessage(msg);
                    p= new pagereference('/'+caseId);
               }
            }catch(Exception ex){
                ApexPages.addMessages(ex);
            }
            return p;
        }
        public PageReference cancel()
        {       
          return new pagereference('/'+caseId);   
        }
    }