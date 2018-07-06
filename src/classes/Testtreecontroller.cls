public class Testtreecontroller {

    Public list<SFDC_Budget__c> Fparec{get;set;}
    public list<Datawrapper> wrappers{get;set;}
    Public list<Fund_Programs_Admin__c> fpa{get;set;}
    Public list<SFDC_MDF_Claim__c> Fclaims{get;set;}
    Public list<SFDC_MDF__c> Fundrequests{get;set;}
    public set<id> Frequestids{get;set;}
    public set<id> partnerfundids{get;set;}
    public Boolean hasData{get;set;}
    public Testtreecontroller(ApexPages.StandardController controller){
        wrappers=New list<Datawrapper>();
        Frequestids=New set<id>();
        hasData=true;
        fpa=[select id, name from Fund_Programs_Admin__c limit 5];
        Fparec=[SELECT Account__c,Active__c,Approved_Claims__c,Approved_Requests__c,Available_Budget2__c,Available_Budget__c,
                Closed_Requests__c,CreatedById,CreatedDate,CurrencyIsoCode,Eligible_For_MDF__c,End_Date__c,Fund_Manager_Email__c,
                Fund_Manager_Name_For_Email__c,Fund_Program__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                LastReferencedDate,LastViewedDate,Last_Refresh_Date__c,Name,OwnerId,Paid_Claims__c,RecordTypeId,Start_Date__c,
                SystemModstamp,Total_Active_Budget__c,Type__c,Unclaimed__c,
				(SELECT Account__c,Activity_End_Date__c,Activity_Start_Date__c,Activity_Subtype__c,Activity_Type__c,
                      Age_Days__c,Amount__c,Approval_Funds_Expiry_Days__c,Approved_Date__c,Approved__c,Approver_1__c,Approver_2__c,
                      Approver_3__c,Budget_Currency__c,Budget__c,CA_Share_inc_tax__c,CA_Share__c,Count_Of_Outstanding_Claims__c,
                      CreatedById,CreatedDate,CurrencyIsoCode,Distrbutor_ID__c,Expected_Result__c,Expiry_Date__c,Fund_Manager_Email__c,
                      Historical_Created_Date__c,Historical_PA_NU__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                      MDF_Program__c,MDF_Request_Approval_Status__c,Name,Other_Activity_Type__c,OwnerId,Partner_Email__c,
                      Partner_Name_for_Email__c,Partner_Owner__c,Partner_Share__c,Program_Owner_Email__c,Program_Owner_Name_For_Email__c,
                      RecordTypeId,Rejection_Reason_Instructions__c,Rejection_Reason__c,Request_Details__c,Request_Expiration_Date__c,
                      Request_ID__c,Select_Budget_Warning__c,Status__c,SystemModstamp,Target_Audience__c,Total_Claim_Amount__c,
                      Total_Number_Of_Claims__c from R00N30000002DjDHEA0),
				(SELECT Account_Type__c,Account__c,Actual_End_Date__c,Actual_Result__c,Actual_Start_Date__c,
                      Age_Days__c,Amount__c,Approved_Date__c,Approved__c,Approver_1__c,Approver_2__c,Approver_3__c,
                      Budget_Currency__c,Budget__c,CA_Reimbursement_Formulae__c,CA_Reimbursement__c,Claim_Details__c,
                      Claim_ID__c,Claim_Paid_Date__c,CreatedById,CreatedDate,CurrencyIsoCode,Expenditure_Type__c,
                      Finance_Email__c,Fund_Champion_Name_for_Email__c,Fund_Manager_Email__c,Fund_Request_Status__c,
                      Fund_Request__c,Historical_Created_Date__c,Historical_Transaction_Id__c,Id,Invoice_Date__c,
                      Invoice_Details__c,Invoice_Number__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                      localAmount__c,Mail_Proof_of_Performance__c,MDF_Claim_Approval_Status__c,Name,
                      Other_Expenditure_Type__c,Other_Proof_of_Performance__c,Paid_Check_Credit_Reference_Number__c,
                      Partner_Email__c,Partner_Owner__c,Partner_Share_Formulae__c,Partner_Share__c,Payment_Method__c,
                      Performance_Attached__c,Performance_Verified__c,Program_Owner_Email__c,Program_Owner_Name_for_Email__c,
                      Proof_of_Performance_Received__c,Proof_of_Performance__c,Rejection_Reason_Instructions__c,
                      Rejection_Reason__c,Status__c,SystemModstamp,TransactionDate__c,Transaction_Type__c from R00N30000002DjDZEA0) 
				from SFDC_Budget__c limit 5];
        for(SFDC_Budget__c sbud:Fparec){
            Datawrapper dtw=New Datawrapper(sbud);
            wrappers.add(dtw);
        }
	
    }
     public Testtreecontroller(){
        wrappers=New list<Datawrapper>();
        Frequestids=New set<id>();
        hasData=true;
        fpa=[select id, name from Fund_Programs_Admin__c limit 5];
        Fparec=[SELECT Account__c,Active__c,Approved_Claims__c,Approved_Requests__c,Available_Budget2__c,Available_Budget__c,
                Closed_Requests__c,CreatedById,CreatedDate,CurrencyIsoCode,Eligible_For_MDF__c,End_Date__c,Fund_Manager_Email__c,
                Fund_Manager_Name_For_Email__c,Fund_Program__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                LastReferencedDate,LastViewedDate,Last_Refresh_Date__c,Name,OwnerId,Paid_Claims__c,RecordTypeId,Start_Date__c,
                SystemModstamp,Total_Active_Budget__c,Type__c,Unclaimed__c,
				(SELECT Account__c,Activity_End_Date__c,Activity_Start_Date__c,Activity_Subtype__c,Activity_Type__c,
                      Age_Days__c,Amount__c,Approval_Funds_Expiry_Days__c,Approved_Date__c,Approved__c,Approver_1__c,Approver_2__c,
                      Approver_3__c,Budget_Currency__c,Budget__c,CA_Share_inc_tax__c,CA_Share__c,Count_Of_Outstanding_Claims__c,
                      CreatedById,CreatedDate,CurrencyIsoCode,Distrbutor_ID__c,Expected_Result__c,Expiry_Date__c,Fund_Manager_Email__c,
                      Historical_Created_Date__c,Historical_PA_NU__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                      MDF_Program__c,MDF_Request_Approval_Status__c,Name,Other_Activity_Type__c,OwnerId,Partner_Email__c,
                      Partner_Name_for_Email__c,Partner_Owner__c,Partner_Share__c,Program_Owner_Email__c,Program_Owner_Name_For_Email__c,
                      RecordTypeId,Rejection_Reason_Instructions__c,Rejection_Reason__c,Request_Details__c,Request_Expiration_Date__c,
                      Request_ID__c,Select_Budget_Warning__c,Status__c,SystemModstamp,Target_Audience__c,Total_Claim_Amount__c,
                      Total_Number_Of_Claims__c from R00N30000002DjDHEA0),
				(SELECT Account_Type__c,Account__c,Actual_End_Date__c,Actual_Result__c,Actual_Start_Date__c,
                      Age_Days__c,Amount__c,Approved_Date__c,Approved__c,Approver_1__c,Approver_2__c,Approver_3__c,
                      Budget_Currency__c,Budget__c,CA_Reimbursement_Formulae__c,CA_Reimbursement__c,Claim_Details__c,
                      Claim_ID__c,Claim_Paid_Date__c,CreatedById,CreatedDate,CurrencyIsoCode,Expenditure_Type__c,
                      Finance_Email__c,Fund_Champion_Name_for_Email__c,Fund_Manager_Email__c,Fund_Request_Status__c,
                      Fund_Request__c,Historical_Created_Date__c,Historical_Transaction_Id__c,Id,Invoice_Date__c,
                      Invoice_Details__c,Invoice_Number__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                      localAmount__c,Mail_Proof_of_Performance__c,MDF_Claim_Approval_Status__c,Name,
                      Other_Expenditure_Type__c,Other_Proof_of_Performance__c,Paid_Check_Credit_Reference_Number__c,
                      Partner_Email__c,Partner_Owner__c,Partner_Share_Formulae__c,Partner_Share__c,Payment_Method__c,
                      Performance_Attached__c,Performance_Verified__c,Program_Owner_Email__c,Program_Owner_Name_for_Email__c,
                      Proof_of_Performance_Received__c,Proof_of_Performance__c,Rejection_Reason_Instructions__c,
                      Rejection_Reason__c,Status__c,SystemModstamp,TransactionDate__c,Transaction_Type__c from R00N30000002DjDZEA0) 
				from SFDC_Budget__c limit 5];
        for(SFDC_Budget__c sbud:Fparec){
            Datawrapper dtw=New Datawrapper(sbud);
            wrappers.add(dtw);
        }
	
    }
		Public List<Datawrapper> hierarchy;
    	public class Datawrapper
        {
            
            public SFDC_Budget__c PRfund{get;set;}
            
            public list<SFDC_MDF__c> funreq{get;set;}
            public list<SFDC_MDF_Claim__c> funclaims{get;set;}
            
            public Datawrapper(SFDC_Budget__c  gp)
 			{
                	this.PRfund = gp;
    			 	funreq = gp.R00N30000002DjDHEA0;
     				funclaims=gp.R00N30000002DjDZEA0;
 			}
            
        }
}