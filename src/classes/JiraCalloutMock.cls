@isTest
global class JiraCalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(201);
    res.setBody('{"self":"self", "id":"1234", "key":"key_1234"}');
    return res;
  }
    
  global HttpResponse getResponse(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('[{"name": "Automation.Engine","jira_key": "AE","jira_id": "10910"},{"name": "RA.FTP","jira_key": "RA_FTP","jira_id": "10926"}]');
    return res;
  }
  
  global HttpResponse getJiraResponse(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(201);
    res.setBody('{"id": "0050c00000D2Pw2AAF","name": "reopen","reopen": "true"}');
    return res;
  }  
}