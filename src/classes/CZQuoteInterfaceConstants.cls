public class CZQuoteInterfaceConstants {
    //Object names
    public static final String OPPORTUNITY_OBJECT_NAME = 'Opportunity';
    public static final String QUOTE_OBJECT_NAME = 'SBQQ__Quote__c';
    
    //Stage names
    public static final String OPPORTUNITY_STAGE_INITIAL = '10% - Identification & Qualification';
    public static final String OPPORTUNITY_STAGE_FINAL = 'Closed - Lost';
    public static final String OPPORTUNITY_STAGE_REASON = 'Duplicate';
    public static final String QUOTE_FINAL_STATUS = 'Quote Validated';
    
    //Input status
    public static final Integer SUCCESS_STATUS = 90;
    public static final Integer FAILURE_STATUS = 99;
    public static final Integer START_STATUS = 10;
    public static final Integer PROCESS_READY_STATUS = 11;
    public static final Integer PROCESS_QUOTE_STATUS = 12;
    public static final Integer QUOTE_CALCULATE_STATUS = 13;
    public static final Integer OPP_CONTRACT_STATUS = 14;
    public static final Integer FINAL_PROCESS_STATUS = 15;
    
    //Auth Use Modes
    public static final String INSTANCE_AUTH_USE_MODE = 'I';
    public static final String DURATION_AUTH_USE_MODE = 'D';
}