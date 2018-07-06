public with sharing class DealCertificateController {
    
    public Opportunity relatedTo{get;set;}
    public Email_Rule__c dealCertificate{get;set;}
    public Email_Rule_Template__c emailTemplate;
    
    
    
    public String showDealNumber1;
    public String showCreatedDate1;
    public String showDealProgram1;
    public String showPartner1;
    public String showEndUser1;
    public String showEstimatedValue1;
    public String showSubmissionDate1;
    public String showExpirationDate1;
    public String showProducts1;
    public String showDealName1;
    public String showDisti1;
    public String showXspPartner1;
    
    
    public Id oppId{get;set;}
    public boolean isEmail{get;set;}
    
    public List<incentivesWrapper> availableIncentives{get;set;}
    public Integer incentiveCount{get;set;}
    public String ruleId{get;set;}
    public Email_Rule_Template__c getemailTemplate()
    {
        if(emailTemplate == null )
            {
                    setvalues();
            }
        return emailTemplate;
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
    
  
    public string getTestId()
    {
        return  (string)oppId;
    }
  
    public string getshowDealNumber()
    {
        if(emailTemplate == null) { setvalues(); }
        if(emailTemplate.Email_Rule__r.Certificate__c)                                
            showDealNumber1 = 'block';
        else
            showDealNumber1 = 'none';
            
        return showDealNumber1;
    }
  
    public String getshowCreatedDate()
    {
        if(emailTemplate == null) { setvalues(); }
        if(emailTemplate.Email_Rule__r.Created_Date__c)                               
            showCreatedDate1 = 'block';
        else
            showCreatedDate1 = 'none';
        
        return showCreatedDate1;
    }
    public String getshowDealProgram(){
        if(emailTemplate == null) { setvalues(); }
        if(emailTemplate.Email_Rule__r.Show_Deal_Program__c)                               
            showDealProgram1 = 'table-row';
        else
            showDealProgram1 = 'none';
        return showDealProgram1;
    }
    public String getshowPartner(){
        if(emailTemplate == null) { setvalues(); }
        if(emailTemplate.Email_Rule__r.Partner_Name__c)                               
            showPartner1 = 'table-row';
        else
            showPartner1 = 'none'; 
        return showPartner1;
    }
    public String getshowXspPartner(){
        if(emailTemplate == null) { setvalues(); }
        if(emailTemplate.Email_Rule__r.Solution_Provider_Client__c)                               
            showXspPartner1 = 'table-row';
        else
            showXspPartner1 = 'none'; 
        return showXspPartner1;
    }
    public String getEmailUsername(){
        String emailreturnName= null;
        if(emailTemplate == null) { setvalues(); }
        if(relatedTo.Type == 'xSP' && relatedTo.Source__c == 'Deal Registration')                               
            emailreturnName = relatedTo.End_User_Contact__r.name;
        else
            emailreturnName = relatedTo.Reseller_Contact_Name_For_Email__c;
        
        return emailreturnName;
    }
    /* Commented as AR has been deferred
        public String getshowDisti(){
        if(emailTemplate == null) { setvalues();}
        if(relatedto.Type=='2 Tier')
            showDisti1= 'table-row';
        else
            showDisti1= 'none';
        return showDisti1;
    }
    */
    
    public String getshowEndUser(){
        if(emailTemplate == null) { setvalues(); }
         if(emailTemplate.Email_Rule__r.End_User__c)                               
            showEndUser1 = 'table-row';
        else
            showEndUser1 = 'none';
        return showEndUser1;
    }
    public String getshowEstimatedValue(){
        if(emailTemplate == null) { setvalues(); }
          if(emailTemplate.Email_Rule__r.Estimated_Value__c)                                
            showEstimatedValue1 = 'table-row';
        else
            showEstimatedValue1 = 'none';
        return showEstimatedValue1;
    }
    public String getshowSubmissionDate(){
        if(emailTemplate == null) { setvalues(); }
        if(emailTemplate.Email_Rule__r.Submission_Date__c)                                
            showSubmissionDate1 = 'table-row';
        else
            showSubmissionDate1 = 'none';   
        return showSubmissionDate1;
    }
    public String getshowExpirationDate(){
        if(emailTemplate == null) { setvalues(); }
          if(emailTemplate.Email_Rule__r.Expiration_Date__c)                                
            showExpirationDate1 = 'table-row';
        else
            showExpirationDate1 = 'none';
        return showExpirationDate1;
    }
    public String getshowProducts(){
        if(emailTemplate == null) { setvalues(); }
          if(emailTemplate.Email_Rule__r.Products__c)                               
            showProducts1 = 'table-row';
        else
            showProducts1 = 'none';
        return showProducts1;
    }
    
    public String getshowDealName(){
        if(emailTemplate == null) { setvalues(); }
         if(emailTemplate.Email_Rule__r.Deal_Registration_Name__c)                                 
            showDealName1 = 'table-row';
        else
            showDealName1 = 'none';
        return showDealName1;
    }
    
   
   public string getLocale()
   {
        return Userinfo.getLocale();
    
   }
    
   
   public string getLanguage()
   {
        Map<string,string> m= PRM_Email_Notifications.getMap();
        return m.get(Userinfo.getLocale());
    
   }
     
   public boolean getshowIncentive()
   {
    
    boolean showIncentive;
      if(emailTemplate == null) { setvalues(); }
        
        getIncentives();
        if(emailTemplate.Email_Rule__r.Incentives__c && incentiveCount > 0)
            showIncentive = true;
        else
            showIncentive = false;
            
    System.debug('showIncentive'+showIncentive);
    return showIncentive;
    
   }
   public void setvalues()
   {
   
   
        system.debug('In the controller>>>' + oppId + '||||' + ruleId );
        if(PRM_Email_Notifications.emailruletemplateid <> null && PRM_Email_Notifications.dealregid <> null)
        {
            relatedTo = [Select Deal_Certificate_Number__c,End_User_Contact__r.name,source__c ,Service_Provider_Client__r.Name, Account.GEO__c, Created_Date_Formula__c,Deal_Program__c, Deal_Registration_Program__c, Name, Reseller_Name_for_Deal__c, Account.Name, 
                                    Reseller_Estimated_Value__c,Deal_program_Formula__c, Deal_Registration_Submitted_Date__c, Deal_Expiration_Date__c, Reseller_Product_Name__c, Type, Distributor_6__c, Distributor_Name__c,
                                    CurrencyIsoCode,ResubmissionProducts__c, Reseller_Contact_Name_For_Email__c, Deal_Registration_Program__r.Name, Deal_Registration_Program__r.Partner_Program_Level__c,Reseller__r.Geo__c, Reseller__r.Segment__c,Account.Segment__c
                                    from Opportunity where id = : PRM_Email_Notifications.dealregid LIMIT 1];
                                    
            emailTemplate = [Select e.View_Email_Template__c, e.Id, e.Email_Template__c, e.Email_Rule__c, 
                            e.Email_Copyright_Text__c, e.Email_Body_Text__c, e.Email_Address_Text__c,
                            e.Certificate_Heading_Text__c,
                            /*e.Certificate_Details_Text__c,
                             e.Certificate_Submission_Text__c, e.Certificate_Heading_Text__c, 
                             e.Certificate_Account_Manager_Text__c, 
                            */
                            
                            e.Email_Rule__r.Certificate__c,e.Email_Rule__r.Solution_Provider_Client__c, e.Email_Rule__r.Created_Date__c, e.Email_Rule__r.Show_Deal_Program__c,
                            e.Email_Rule__r.Deal_Registration_Name__c, e.Email_Rule__r.End_User__c, e.Email_Rule__r.Estimated_Value__c,
                            e.Email_Rule__r.Promo_Code__c, e.Email_Rule__r.Expiration_Date__c, e.Email_Rule__r.Partner_Name__c,
                            e.Email_Rule__r.Products__c, e.Email_Rule__r.Submission_Date__c,Email_Rule__r.Incentives__c
                
                            From Email_Rule_Template__c e where id = : PRM_Email_Notifications.emailruletemplateid
                            ];   
          dealCertificate = emailTemplate.Email_Rule__r;
                                                 
        
        }
        else
         {
                if(relatedTo == null && OppId !=null)
                     relatedTo = [Select Deal_Certificate_Number__c,source__c,End_User_Contact__r.name,Service_Provider_Client__r.Name, Account.GEO__c, Created_Date_Formula__c,Deal_Program__c, Deal_Registration_Program__c, Name, Reseller_Name_for_Deal__c, Account.Name, 
                                    Reseller_Contact_Name_For_Email__c,ResubmissionProducts__c, Reseller_Estimated_Value__c, Deal_Registration_Submitted_Date__c, Deal_Expiration_Date__c, Reseller_Product_Name__c, 
                                    CurrencyIsoCode, Type, Distributor_6__c, Distributor_Name__c, Deal_Registration_Program__r.Name, Deal_Registration_Program__r.Partner_Program_Level__c, Reseller__r.Geo__c, Reseller__r.Segment__c,Account.Segment__c
                                    from Opportunity where id = :oppId LIMIT 1];
                
               
                
                if(dealCertificate == null)                    
                {   
                    if(relatedTo != null && relatedTo.Deal_Registration_Program__c != null)
                    {
                        Email_Rule__c[] er  = [Select Certificate__c,Created_Date__c,Show_Deal_Program__c,
                                              Deal_Registration_Name__c,End_User__c,Estimated_Value__c,
                                              /*
                                              Certificate_Details_Text__c, Certificate_Heading_Text__c,
                                              Certificate_Submission_Text__c, Certificate_Account_Manager_Text__c,
                                              */
                                              Promo_Code__c, 
                                              Expiration_Date__c,Partner_Name__c,Solution_Provider_Client__c,Products__c,Submission_Date__c 
                                              From Email_Rule__c e where id = : PRM_Email_Notifications.emailruleid
                                             
                                             /* from Email_Rule__c 
                                              where 
                                              Deal_Registration_Program__c = :relatedTo.Deal_Registration_Program__c
                                              AND Email_Capability__c = 'Deal Registration'
                                              AND Language__c =: getLanguage()
                                              AND Action__c = 'Approved' */
                                              
                                              //Partner Programk level
                                              //AND region__c = : relatedTo.Account.GEO__c
                                             ];
                                             
                        if(er !=null && er.size() >0 )
                            dealCertificate = er[0];
                        else
                            {   dealCertificate = new   Email_Rule__c();
                                emailTemplate = new Email_Rule_Template__c();
                            }   
                                
                    }
                    else
                    {   dealCertificate = new   Email_Rule__c();
                        emailTemplate = new Email_Rule_Template__c();
                    }
                                           
                }                         //id =: ruleId];  //
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
  public void  getIncentives(){
        
        if(emailTemplate == null) { setvalues(); }
        
        Set<String> prodList = new Set<String>();
        Map<String,Decimal> Incentives = new Map<String,Decimal>();
        List<Deal_Program_Product_Group__c> DealProgramGroupList = [Select Id, Product_Group__c, (Select Id, Incentive_Name__c, Max_Discount__c from Deal_Reg_Program_Incentives__r where Geo__c includes (:relatedTo.Reseller__r.Geo__c) and End_User_Segment__c includes (:relatedTo.Account.Segment__c)) from Deal_Program_Product_Group__c where Deal_Registration_Program__c = :relatedTo.Deal_Registration_Program__c ];
        
        System.debug('DealProgramGroupList'+DealProgramGroupList+relatedTo.Account.Segment__c+relatedTo.Reseller__r.Geo__c);
        List<OpportunityLineItem> oppProd = [select Id,Product_Group__c from OpportunityLineItem where OpportunityId = :relatedTo.Id];
        
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
    
    
    public DealCertificateController() {
            if(OppId == null && ApexPages.currentPage().getParameters().get('oppId') != null)
                    oppId = ApexPages.currentPage().getParameters().get('oppId');
      availableIncentives = new List<incentivesWrapper>();
      incentiveCount =0;
      
          } 
          
    
}