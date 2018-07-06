@isTest
private class PRMHeaderTest {
    static testMethod void TestPRMHeader() {
        PRMHeader header = new PRMHeader();
        boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        string RegisterUrl = header.RegisterUrl;
        
        if (isSandbox)
        {
           System.assertEquals(RegisterUrl, 'http://profile-qa.ca.com/us/register/createprofile.aspx?returnURL=https://samlgwsm-qa.ca.com/affwebservices/public/saml2sso?SPID=http://forms.vlistaging.com/ca-sso/sso/relay-2');
        }
        else 
        {
            System.assertEquals(RegisterUrl, 'http://www.ca.com/us/register/createprofile.aspx?returnURL=https://samlgwsm.ca.com/affwebservices/public/saml2sso?SPID=http://forms.webinfinity.com/ca-sso/sso/relay-2');
        }
    }
}