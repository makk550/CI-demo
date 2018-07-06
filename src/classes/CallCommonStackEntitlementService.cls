@RestResource(urlMapping='/getuserservice')

global class CallCommonStackEntitlementService {
    public String result;

    @HttpGet
    global static List<Entitlements> getCERService(){
        String accountId;
        String subId;
        String subType;
        List<Entitlements> ent=new List<Entitlements>();
        try {
            String emailId = RestContext.request.params.get('emailid');
            CC_Layer7Service obj = new CC_Layer7Service();
            String response = obj.callToFetchSitesAndProductsFromEER(emailId);
            Util_JSONParser parserUtil = Util_JSONParser.createParser(response);
            if(parserUtil.get('entitlements').Value != null && Boolean.valueOf(parserUtil.get('user_deleted').Value) == false && Boolean.valueOf(parserUtil.get('user_disabled').Value) == false){
                List<Util_JSONParser> entlList = Util_JSONParser.parseArray(parserUtil.get('entitlements').Value);
                for(Util_JSONParser p: entlList){
                        Entitlements e=new Entitlements();
                        e.accountId=p.get('sfdcaccountid').Value;
                        e.subId = p.get('instanceid').Value;
                        e.entitlement_type=p.get('entitlement_type').Value;
                        ent.add(e);
                }
                return ent;
            }
            else
                return ent;
        } catch (Exception e) {
            return null;
        }   
    }
    global class Entitlements{
        public String accountId{get;set;}
        public String subId {get;set;}
        public String entitlement_type {get;set;}        
    }
}