/**
*Description :Classs to display the Deal Certificate as a VF page
*Methods DealReg_DealCertificateClass
*SOQl: 1
*Client: CA technologies
*Developed By:  Accenture
*/
public with sharing class DealReg_DealCertificateClass {
    public Id OpptyId;
    public Opportunity This_Oppty{get;set;}
    public OpportunityLineItem Oppty_product{get;set;}
    public Integer CreatedDay{get;set;}
    public String CreatedMonth{get;set;}
    public Integer CreatedYear{get;set;}
    public Integer ExpirationDay{get;set;}
    public String ExpirationMonth{get;set;}
    public Integer ExpirationYear{get;set;}
    public Integer SubmissionDay{get;set;}
    public String SubmissionMonth{get;set;}
    public Integer SubmissionYear{get;set;}
    public string resellerDiscount{get;set;}
    public string showDealCertNumber{get;set;}
    public string showCreatedDate{get;set;}
    public string showDealProgram{get;set;}
    public string showDealRegName{get;set;}
    public string showPartner{get;set;}
    public boolean showIncentive{get;set;}
    public string showEndUser{get;set;}
    public string showEstimatedValue{get;set;}
    public string showSubmitDate{get;set;}
    public string showExpirationDate{get;set;}
    public string showProducts{get;set;}
    public string promoCode{get;set;}
    public string showAmount{get;set;}
    public string isTypeXsp{get;set;}
    public Integer incentiveCount{get;set;}
    public List<incentivesWrapper> availableIncentives {get;set;}
        public string noShowAmount{get;set;}
        public string ProductList{get;set;}
    map<integer,string> MonthMap=new map<integer,string>
                                         {1 => 'January',   
                                          2 => 'February',
                                          3 => 'March',
                                          4 => 'April', 
                                          5 => 'May',
                                          6 => 'June',
                                          7 => 'July',
                                          8 => 'August',
                                          9 => 'September',
                                          10 => 'October',
                                          11 => 'November',
                                          12 => 'December'};

    //Constructor
    public DealReg_DealCertificateClass(){
        showDealCertNumber = 'block';
        showCreatedDate = 'block';
        showDealProgram = 'table-row';
        showDealRegName = 'table-row';
        showPartner = 'table-row';
        showEndUser = 'table-row';
        isTypeXsp = 'table-row';
        showEstimatedValue = 'table-row';
        showSubmitDate = 'table-row';
        showExpirationDate = 'table-row';
        showProducts = 'table-row';
        showIncentive = false;
        incentiveCount = 0;
        promoCode = '';
        availableIncentives = new List<incentivesWrapper>();
        String tempId = ApexPages.currentPage().getParameters().get('id');
        if(tempId.startsWith('006')) {
            This_Oppty=[Select Type,Service_Provider_Client__r.Name,source__c,Deal_Approval_Status__c,Deal_Account_Name__c,Deal_program_Formula__c,Deal_Registration_Name__c,o.Reseller__r.Name, o.Amount, o.Reseller_Estimated_Value__c, o.Account.Name, o.Account.Segment__c,o.AccountId, 
            o.Deal_Certificate_Number__c, o.CreatedDate, o.Reseller_Product_Name__c, o.Deal_Expiration_Date__c, o.Opportunity_Number__c,o.Reseller__r.Geo__c,o.Reseller__r.Segment__c,
            o.Deal_Program__c,o.Name,o.Deal_Registration_Submitted_Date__c, o.Deal_Registration_Program__c, o.Deal_Registration_Program__r.Name,o.Total_Reseller_Discount__c From Opportunity o where id=:tempId];
        }
        else {
            This_Oppty=[Select Type,Service_Provider_Client__r.Name,source__c,o.Account.Segment__c,o.Reseller__r.Name,o.Deal_Account_Name__c,o.Deal_Registration_Name__c,o.Deal_program_Formula__c, o.Amount, o.Reseller_Estimated_Value__c, o.Account.Name, o.AccountId, 
            o.Deal_Certificate_Number__c, o.CreatedDate, o.Reseller_Product_Name__c, o.Deal_Expiration_Date__c, o.Opportunity_Number__c, o.Reseller__r.Geo__c,o.Reseller__r.Segment__c,
            o.Deal_Program__c,o.Name,Deal_Approval_Status__c,o.Deal_Registration_Submitted_Date__c, o.Deal_Registration_Program__r.Name, o.Deal_Registration_Program__c,o.Total_Reseller_Discount__c From Opportunity o where o.Id=:tempId];           
        }
               ProductList = '';
        if(This_Oppty.Deal_Approval_Status__c == 'Approved and Merged')
        {         
            showAmount = 'true';
            noShowAmount= 'none';
        } 
        else
        {
            noShowAmount= 'true';
            showAmount = 'none';
        }
        List<Email_Rule__c> emailRules = null;
        Email_Rule__c emailRule = null;
        if(This_Oppty != null) {
            emailRules = [Select Certificate__c, Created_Date__c, Show_Deal_Program__c, Deal_Registration_Name__c, End_User__c,Solution_Provider_Client__c, Estimated_Value__c, 
                        Expiration_Date__c, Partner_Name__c, Products__c, Submission_Date__c, Promo_Code__c,Incentives__c from Email_Rule__c where Deal_Registration_Program__c = :This_Oppty.Deal_Registration_Program__c and action__c = 'Approved-Deal Certificate'];
        }
        if(emailRules != null && emailRules.size() > 0)
            emailRule = emailRules.get(0);  
        if(emailRule != null) {
            promoCode = emailRule.Promo_Code__c; 
            System.debug('emailrule>>>>>>>>>>>'+emailRule);
            if(emailRule.Certificate__c)
                showDealCertNumber = 'block';
            else    
                showDealCertNumber = 'none';
            
            if(emailRule.Created_Date__c)
                showCreatedDate = 'block';
            else    
                showCreatedDate = 'none';
            
            if(emailRule.Show_Deal_Program__c)
                showDealProgram = 'table-row';
            else    
                showDealProgram = 'none';
            
            if(emailRule.Deal_Registration_Name__c)
                showDealRegName = 'table-row';
            else    
                showDealRegName = 'none';
            
            if(emailRule.Partner_Name__c)
                showPartner = 'table-row';
            else    
                showPartner = 'none';
            
            if(emailRule.End_User__c)
                showEndUser = 'table-row';
            else    
                showEndUser = 'none';
            
            if(emailRule.Solution_Provider_Client__c)
                isTypeXsp = 'table-row';
            else    
                isTypeXsp = 'none';
            
            if(emailRule.Estimated_Value__c)
                showEstimatedValue = 'table-row';
            else    
                showEstimatedValue = 'none';  
                    
            if(emailRule.Submission_Date__c)
                showSubmitDate = 'table-row';
            else    
                showSubmitDate = 'none';

            if(emailRule.Expiration_Date__c)
                showExpirationDate = 'table-row';
            else    
                showExpirationDate = 'none';
            
            if(emailRule.Products__c)
                showProducts = 'table-row';
            else    
                showProducts = 'none'; 
              
            getIncentives();  
            if(emailRule.Incentives__c && incentiveCount > 0)
            	showIncentive = true;
            else
            	showIncentive = false;
            	
                             
        }
        System.debug('-----------showDealCertNumber'+showDealCertNumber);
        System.debug('-----------showDealProgram'+showDealProgram);
        System.debug('-----------showDealRegName'+showDealRegName);
        System.debug('-----------showEndUser'+showEndUser);
        
        System.debug('---------------'+This_Oppty);
        CreatedDay=This_Oppty.CreatedDate.day();
        CreatedMonth=MonthMap.get(This_Oppty.CreatedDate.month());
        CreatedYear=This_Oppty.CreatedDate.year();
        if(This_Oppty.Deal_Expiration_Date__c!=null){
            ExpirationDay=This_Oppty.Deal_Expiration_Date__c.day();
            ExpirationMonth=MonthMap.get(This_Oppty.Deal_Expiration_Date__c.month());
            ExpirationYear=This_Oppty.Deal_Expiration_Date__c.year();   
        }
        if(This_Oppty.Deal_Registration_Submitted_Date__c!=null){
            SubmissionDay=This_Oppty.Deal_Registration_Submitted_Date__c.day();
            SubmissionMonth=MonthMap.get(This_Oppty.Deal_Registration_Submitted_Date__c.month());
            SubmissionYear=This_Oppty.Deal_Registration_Submitted_Date__c.year();   
        }
        
        
    }
    
    public Class incentivesWrapper
	   
	{
	   public String incentiveName{get;set;}
	   public Decimal maxDiscount{get;set;}
	   
	   
	   public incentivesWrapper(String incentive, Decimal discount){
	   	
	   	
	   	incentiveName = incentive;
	   	maxDiscount = discount;
	   	
	   }  	
	}
	 public string getImageURL()
    {
        String imageURL;
        imageURL='/servlet/servlet.FileDownload?file=';
        List< document > documentList=[select name from document where Name='CaLogo_Grey' limit 1];
        if(documentList.size()>0)
           {
              imageURL=imageURL+documentList[0].id;
           }
        
        return imageURL;
    }
	
	public void getIncentives(){
		
		
		
		Set<String> prodList = new Set<String>();
		Map<String,Decimal> Incentives = new Map<String,Decimal>();
		List<Deal_Program_Product_Group__c> DealProgramGroupList = [Select Id, Product_Group__c, (Select Id, Incentive_Name__c, Max_Discount__c from Deal_Reg_Program_Incentives__r where Geo__c includes (:This_Oppty.Reseller__r.Geo__c) and End_User_Segment__c includes (:This_Oppty.Account.Segment__c)) from Deal_Program_Product_Group__c where Deal_Registration_Program__c = :This_Oppty.Deal_Registration_Program__c ];
		
		System.debug('DealProgramGroupList'+DealProgramGroupList+This_Oppty.Account.Segment__c+This_Oppty.Reseller__r.Geo__c);
		List<OpportunityLineItem> oppProd = [select Id,Product_Group__c from OpportunityLineItem where OpportunityId = :This_Oppty.Id];
		
		for(OpportunityLineItem olt : oppProd)
			prodList.add(olt.Product_Group__c);
		
		for(Deal_Program_Product_Group__c dpg : DealProgramGroupList){
			
			System.debug('prodList'+prodList);
			if(prodList.contains(dpg.Product_Group__c)){
				System.debug('dpg.Deal_Reg_Program_Incentives__r'+dpg.Product_Group__c+dpg.Deal_Reg_Program_Incentives__r);
				for(Deal_Reg_Program_Incentives__c drPI : dpg.Deal_Reg_Program_Incentives__r){
					
					if(!Incentives.containskey(drPI.Incentive_Name__c))
						Incentives.put(drPI.Incentive_Name__c,drPI.Max_Discount__c);
					else if(Incentives.containskey(drPI.Incentive_Name__c) && drPI.Max_Discount__c > Incentives.get(drPI.Incentive_Name__c))
						Incentives.put(drPI.Incentive_Name__c,drPI.Max_Discount__c);
				
				System.debug('Incentives'+Incentives);	
				}
			}
		}
		
		for(String incentive: Incentives.keyset()){
			
			availableIncentives.add(new incentivesWrapper(incentive, incentives.get(incentive)));
			incentiveCount++;
		}
		
		
		 
	}
}