public abstract class MintigoTests_AbstractBase {

    public class InternalRequestMock implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String body;
    
        public InternalRequestMock(Integer code, String status, String body) {
            this.code = code;
            this.status = status;
            this.body = body;
        }
    
        public HTTPResponse respond(HTTPRequest req) {
            System.debug('HTTP Mock is Running and will return fake response');
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(code);
            resp.setStatus(status);
            resp.setBody(body);
    
            return resp;
        }       
    }

}