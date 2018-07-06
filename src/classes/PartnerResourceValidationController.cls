public class PartnerResourceValidationController {
    
    public Partner_Resource_Validation__c partnerResourceValidationRec { get; set; }
    private ApexPages.StandardController controller;
    public User currentUser { get; set; }
    public String validationCode{ get;set;}
    public String ownerName {get;set;}    
    public boolean isTechVal1 {get;set; }
    public boolean isTechVal2 {get;set; }
    public boolean isTechVal3 {get;set; }
    public boolean vcodeexists{get;set;}
    public boolean showVtypeDesc{get;set;}
    public string novcodemsg{get;set;}
    
    public PartnerResourceValidationController(ApexPages.StandardController controller){        
        this.partnerResourceValidationRec = (Partner_Resource_Validation__c)controller.getRecord();
        this.controller = controller;
        currentUser = [Select Id,Name From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        ownerName = currentUser.Name;
        isTechVal1 = isTechVal2 = isTechVal3 = showVtypeDesc = vcodeexists = false;        
		
        if(partnerResourceValidationRec.Id != null){            
            Partner_Resource_Validation__c curRec = [select Id,OwnerId,Owner.Name,Validation_Code__c from Partner_Resource_Validation__c where id = :partnerResourceValidationRec.Id];
            ownerName = curRec.Owner.Name;
            validationCode = curRec.Validation_Code__c;
            checkVTypes(); 
        } 
        
    }    
     
    public List<SelectOption> getValidationTypes(){
    	List<SelectOption> validationTypes = new List<SelectOption>(); 
    	if(!Test.isRunningTest()){	        
	        validationTypes.add(new SelectOption(System.label.Select,System.label.Select));
	        List<AggregateResult> validationTypesList = [select Validation_Type__c from Partner_Resource_XREF__c group by Validation_Type__c];
	        for(AggregateResult res : validationTypesList){
	            validationTypes.add(new SelectOption(String.valueOf(res.get('Validation_Type__c')),String.valueOf(res.get('Validation_Type__c'))));
	        }	            		
    	}
    	else{
			Partner_Resource_XREF__c xrefRec = new Partner_Resource_XREF__c(name = '76AAA30020',Fiscal_Year__c = '2015',Product_Group__c = 'TestPG',Validation_Type__c='TestVType');
			insert xrefRec;			
			validationTypes.add(new SelectOption(xrefRec.Validation_Type__c,xrefRec.Validation_Type__c));
    	}
    	return validationTypes;
    }
    
    public String getvtypeDesc(){
        String vtypeDesc = '';
        if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Implementer_Validation_1)
        {
			vtypeDesc = System.Label.Architect_and_Deliver ; 
        }
        else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Implementer_Validation_2)
        {
			vtypeDesc = System.label.Architect_Deliver_with_CA_Solution_Delivery_Methodology;
        }        
        else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Sales_Validation)
        {
            vtypeDesc = System.label.Position_and_Present_the_Product;
        }
        else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Technical_Sales_Validation_1)
        {
            vtypeDesc = System.label.Present;
        }
        else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Technical_Sales_Validation_2)
        {
            vtypeDesc = System.label.Demo;
        }
        else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Technical_Sales_Validation_3)
        {
            vtypeDesc = System.label.Proof_of_concept;
        }
        return vtypeDesc;
    }
    
    public List<SelectOption> getProductGroups(){
        String selvalidationType = partnerResourceValidationRec.Validation_Type__c;
        List<SelectOption> productGroups = new List<SelectOption>(); 
        productGroups.add(new SelectOption(System.label.Select,System.label.Select));
        List<AggregateResult> productGroupsList = [select Product_Group__c from Partner_Resource_XREF__c where Validation_Type__c= :selvalidationType  group by Product_Group__c ];
        for(AggregateResult res : productGroupsList){
            productGroups.add(new SelectOption(String.valueOf(res.get('Product_Group__c')),String.valueOf(res.get('Product_Group__c'))));
        }   
        return productGroups;
    }
    
 public void populateValidationCode(){
        
        vcodeexists = false;
        String selvalidationType = partnerResourceValidationRec.Validation_Type__c;
        String selProductGroup = partnerResourceValidationRec.Product_Group__c;
        //String currentFYear = getCurrentFYear();
        AggregateResult  argYear= [select Fiscal_Year__c from Partner_Resource_XREF__c
                               where Validation_Type__c = :selvalidationType and Product_Group__c = :selProductGroup
                               group by Fiscal_Year__c order by Fiscal_Year__c desc limit 1];
        
        String currentFYear = String.valueOf(argYear.get('Fiscal_Year__c'));
        
        Partner_Resource_XREF__c partnerResXREF ;        
        for(Partner_Resource_XREF__c curPartnerResXREF : [select Name from Partner_Resource_XREF__c where Validation_Type__c = :selvalidationType and Product_Group__c = :selProductGroup and Fiscal_Year__c = :currentFYear limit 1] ){
        	partnerResXREF = curPartnerResXREF;
        }
        System.debug('partnerResXREF:'+partnerResXREF);
        if(partnerResXREF == null){
            validationCode = '';
            vcodeexists = true;
            novcodemsg = System.label.No_Code_found_in_Learning_Plan;
        }
        else{
            validationCode = partnerResXREF.Name;
            partnerResourceValidationRec.Validation_Code__c = partnerResXREF.Name;
        }
        System.debug('validationCode:'+validationCode);
        checkVTypes();
        if(partnerResourceValidationRec.Id == null){
            assignDefaultValues();
        }
        
    }
    
    public void checkVTypes(){
        System.debug('In checkVTypes(): validationCode:'+validationCode);
        if( validationCode != '' && validationCode != null)
        {
            if(	(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Sales_Validation) ||
                (partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Technical_Sales_Validation_1))
            {
                       isTechVal1 = true;   
            }        
            else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Technical_Sales_Validation_2)
            {
                       isTechVal2 = true;
            }
            else if(partnerResourceValidationRec.Validation_Type__c == System.label.Partner_Technical_Sales_Validation_3)
            {
                       isTechVal3 = true;   
            }
        }
        
    }
    
    public void assignDefaultValues(){
        if(isTechVal1){
            partnerResourceValidationRec.Industry_Knowledge__c = System.label.Capable;
			partnerResourceValidationRec.Solution_Knowledge__c = System.label.Capable;
            partnerResourceValidationRec.Delivery__c = System.label.Capable;
            partnerResourceValidationRec.Organization__c = System.label.Capable;
            partnerResourceValidationRec.Visual_Aids__c = System.label.Capable;
            partnerResourceValidationRec.Presence__c = System.label.Capable;
            partnerResourceValidationRec.Summary__c = System.label.Capable;
        }
        else if(isTechVal2){
            partnerResourceValidationRec.Business_Strategy__c = System.label.Capable;
			partnerResourceValidationRec.Product_Solution_Knowledge__c = System.label.Capable;
            partnerResourceValidationRec.Delivery__c = System.label.Capable;
            partnerResourceValidationRec.Organization__c = System.label.Capable;
            partnerResourceValidationRec.Impact__c = System.label.Capable;
            partnerResourceValidationRec.Presence__c = System.label.Capable;
            partnerResourceValidationRec.Summary__c = System.label.Capable;            
        }
        else if(isTechVal3){
            partnerResourceValidationRec.Business_Strategy__c = System.label.Capable;
			partnerResourceValidationRec.Solution_Knowledge__c = System.label.Capable;
            partnerResourceValidationRec.Delivery__c = System.label.Capable;
            partnerResourceValidationRec.Organization__c = System.label.Capable;
            partnerResourceValidationRec.Impact__c = System.label.Capable;
            partnerResourceValidationRec.Presence__c = System.label.Capable;
            partnerResourceValidationRec.Summary__c = System.label.Capable;             
        }


    }
    
    public void resetPG(){
        partnerResourceValidationRec.Product_Group__c = System.label.Select;
        partnerResourceValidationRec.Validation_Code__c = '';
        ValidationCode = '';
        isTechVal1 = false;
        isTechVal2 = false;
        isTechVal3 = false;
        showVtypeDesc = true;
        novcodemsg = '';
    }
    
    /*
    public String getCurrentFYear(){
        Date curDate = Date.today();
        Integer curYear = curDate.year();
        Integer curMonth = curDate.month();
        Integer curFYear;
        if(curMonth >3)
            curFYear = curYear+1;
        else
            curFYear =curYear;
        
        return 'FY'+curFYear;
    } 
    */
    
    public List<String> performValidations(){
        List<String> errorMessages = new List<String>();
        if(this.partnerResourceValidationRec.Validation_Type__c == System.label.Select ||
           this.partnerResourceValidationRec.Validation_Type__c == ''){
               errorMessages.add(System.label.Please_select_a_Validation_Type); //TODO: create a custom label
           }
        if(this.partnerResourceValidationRec.Product_Group__c == System.label.Select ||
           this.partnerResourceValidationRec.Product_Group__c == '') {
               errorMessages.add(System.label.Please_select_a_Product_Group); //TODO: create a custom label
           }        
        return errorMessages;
    }

    public static void populateLDAPID(Partner_Resource_Validation__c pResValidation){
        try{
            User partnerUser = [select LDAP_Id__c from User where ContactId = :pResValidation.Partner_Resource__c];
            pResValidation.LDAP_ID__c = partnerUser.LDAP_Id__c;                    
        }
        catch(Exception e){                    
            System.debug('Exception Message:'+e.getMessage());
            System.debug('Exception :'+e.getStackTraceString());
        }        
    }
    
    public PageReference Save(){
        List<String> errorMessages = performValidations();
        if(!errorMessages.isEmpty()){
            for(String errorMsg : errorMessages){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,errorMsg));
            }
            return null;
        } 
        else{
            PageReference pageRef = controller.save();
            return pageRef;
        }
    }
    

    
}