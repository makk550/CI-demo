/**************************************************************************************************

* Test class to provide coverage for PartnerProfileSearch.cls

**************************************************************************************************/


@isTest 
private class Test_PartnerProfileSearch {


    static testmethod void test_PartnerProfileSearch(){
    
        String accName = 'Profile search Test';
        String country = 'AL - ALBANIA';

        PartnerProfileSearch cont = new PartnerProfileSearch();
        
        cont.req.name = accName ;
        cont.req.country = country ;

               
        cont.callEAIPartnerPofileService();


        HTTPResponse resp = new HTTPResponse();

        String xml = '<?xml version="1.0" encoding="utf-8"?>';
        
        xml += '<accountSearchResponse> <status>OK</status><errordetail /><searchResults>';
        xml +='<account><name>SCM</name><street>1 Ca Plz</street><city>Islandia</city> <state>NY</state><postalCode>11788</postalCode><country>US</country> <accountId>PL01697</accountId><score>900</score><strategy>DUNS</strategy></account>';
        xml +='<account><name>Apple </name><street>200 Brodway St</street><city>NYC</city><state>NY</state><postalCode>10001</postalCode> <country>US</country> <accountId>PE17040</accountId><score>300</score><strategy>DUNS</strategy></account></searchResults>';
        xml += '<dnbResultsNotInMDM> <account><name>IBM</name><street>200 Brodway St</street><city>NYC</city><state>NY</state><postalCode>10001</postalCode><country>US</country><duns>568</duns></account></dnbResultsNotInMDM>';
        xml += '<accountSearchRequest> <source><name>Microsoft</name><street /><!--Optional:--><city>Islandia</city><!--Optional:--><state>NY</state> <!--Optional:--><postalCode /><!--Optional:--><country>US</country></source><!--Optional:--><!--Default to 5--><dunsHitLimit />';
        xml +='<!--Optional:--><thresholdValues><threshold name="AccountName" weight="1" /><threshold name="Sites" weight="2" /><threshold name="DUNS" weight="7" /></thresholdValues><strategies><strategy name="PartnerSearch" /> </strategies></accountSearchRequest></accountSearchResponse>';
        
        resp.setStatusCode(200);
        resp.setBody(xml);        

        cont.parseXML(resp);
        
        List<PartnerProfileSearch.PartnerProfileAccounts> testRes = new List<PartnerProfileSearch.PartnerProfileAccounts>();
        testRes.add(new PartnerProfileSearch.PartnerProfileAccounts('tname','tstreet','tcity','tstate','tcountry','twebsite','tpostalcode','taccountid','taccounttype','tdunsNumber',200,'tstrategy','tglobalUltimateParent',0));
        cont.populateAddress(testRes);
        
    }
    
}