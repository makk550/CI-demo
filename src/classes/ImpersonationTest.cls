@IsTest
public class ImpersonationTest {
    
    public class L7ImpersonationMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint().contains('/saml/v.1?lookupUser=')) {
                res.setBody('123456');
                res.setStatusCode(200);
                return res;
            }
            return null;
        }
    }
    
  @IsTest
  static void should_start_impersonation() {
      Test.setMock(HttpCalloutMock.class, new L7ImpersonationMock());
      Test.startTest();
      Impersonation i= new Impersonation();
      i.email='cso.enterprise@gmail.com';
      i.impersonate();
      Test.stopTest();
  }
  @IsTest
  static void should_impersonate_user_success(){
      Impersonation i1= new Impersonation();
      i1.email='krivi03@ca.com';
      i1.impersonate();
  }
  @IsTest
  static void should_validate_fail() {
    //Impersonation.email='';
    Impersonation i= new Impersonation();
    Boolean sta=i.validate();
    System.assertEquals(false,sta);
  }
  @IsTest
  static void shoud_set_welcome_msg(){
    String msg= Impersonation.welcomemsg;
    Impersonation.welcomemsg='You are in Impersonation';   
  }
  @IsTest
  static void should_fail_to_validate_for_empty() {
    //Impersonation.email='';
    Impersonation i= new Impersonation();
    i.email='';
    Boolean sta=i.validate();
    System.assertEquals(false,sta);
  }
  @IsTest
  static void should_validate_fail_to_impersonate() {
    //Impersonation.email='';
    Impersonation i= new Impersonation();
    i.email='krivi03@ca.com';
    Boolean sta=i.validate();
    System.assertEquals(false,sta);
  }
  /* @IsTest
  static void should_fail_to_validate_for_invalidemail() {
    //Impersonation.email='';
    Impersonation i= new Impersonation();
    i.email='krivi03@ca.co.m';
    Boolean sta=i.validate();
    System.assertEquals(false,sta);
  } */
  @IsTest
  static void should_validate_pass_to_impersonate() {
    //Impersonation.email='';
    Impersonation i= new Impersonation();
    i.email='vks@gmail.com';
    Boolean sta=i.validate();
    System.assertEquals(true,sta);
  }
  @IsTest
  static void should_validate_email_to_pass() {
    String email='krivi03@ca.com';
    Boolean sta=Impersonation.validateEmail(email);
    System.assertEquals(true,sta);
  }
  @IsTest
  static void should_validate_email_to_fail() {
    String email='krivi03@cacom';
    Boolean sta=Impersonation.validateEmail(email);
    System.assertEquals(false,sta);
  } 
}