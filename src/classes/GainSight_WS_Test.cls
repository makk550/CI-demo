@istest
public class GainSight_WS_Test {
    
    
 public static testMethod void testGainSight(){
        RestRequest req=new RestRequest();
        RestResponse res=new RestResponse();
        
  String jsoninput='{"sfdc_account_id":"ABSGST1234568","instance_id":"7868","product_instance_id":"7886","entitlement_type":"String","email":"Test@gmail.com","entitlement_start_date":"1-18-2018 00:54:54","entitlement_end_date":"1-19-2019 00:54:54","material_id":"7865rt545","event_id":"67789"}';
     //String jsoninput='{'sfdc_account_id'=>'String','instance_id'=>'String','product_instance_id'=>'String','entitlement_type'=>'String','email'=>'String','entitlement_start_date'=>'DateTime','entitlement_end_date'=>'DateTime','material_id'=>'String','event_id'=>'String'}';
        req.requestURI='/services/apexrest/GainSight';
        req.httpMethod='POST';
        req.requestBody=Blob.valueOf(jsoninput);
        RestContext.request=req;
        RestContext.response=res;

        System.debug('======res.responseBody'+res.responseBody);
        Test.startTest();
         GainSight_WS.createGainSightRecords();
       // GainSight_WS.verifyJSONRequest(jsoninput);

        test.stopTest();
        
       //String testresp=res.responseBody.toString();
        
        
    }

}