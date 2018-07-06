@isTest
global class ValidateExternalRnDMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('<?xml version="1.0" encoding="UTF-8"?><ValidateProbSolResponse><ServiceMessage><Status>0</Status><StatusMessage>Successful</StatusMessage></ServiceMessage><ValidateProbSolData validationStatus="Validated" componentID="INTBKP" referenceID="110" type="Problem"/></ValidateProbSolResponse>');
    return res;
  }
}