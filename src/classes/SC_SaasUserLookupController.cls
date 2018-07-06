public with sharing class SC_SaasUserLookupController  {

    @RemoteAction
    public static String search(Map<String, Object> searchCriteria) {
        String url = 'callout:Agile_Central_WSAPI/admin/user?fetch=true&query=';
        String query = '';
        String username = (String)searchCriteria.get('username');
        String email =  (String)searchCriteria.get('emailAddress');
        String firstName =  (String)searchCriteria.get('firstName');
        String lastName =  (String)searchCriteria.get('lastName');
        String type = (String)searchCriteria.get('searchType');
        if (type == 'username' && !String.isBlank(username)) {
            query = '(UserName = "' + username + '")';
        }else if(type == 'email' && !String.isBlank(email)) {
            query = '(EmailAddress = "' + email + '")';
        }else if(type =='firstlast' && !String.isBlank(firstname) && ! String.isBlank(lastName)){
            query = '((FirstName contains "' + firstname + '") and (LastName = "' + lastname.capitalize() + '"))';  
        }
        url += EncodingUtil.urlEncode(query, 'UTF-8');
        return callAlm(url).getBody();
    }

    @RemoteAction
    public static String fetchSubscriptionInfo(Integer subId) {
       String url = 'callout:Agile_Central_WSAPI/subscription?fetch=true&query=';
       String query = '';
       query += '(SubscriptionID = "' + subId + '")';
       url += EncodingUtil.urlEncode(query, 'UTF-8');
       return callAlm(url).getBody();
    }
 
    @RemoteAction
    public static String fetchSubscriptionAdminInfo(Integer subId) {
        String url = 'callout:Agile_Central_WSAPI/user?fetch=true&query=';
        String query = '';
        query += '((WorkspacePermission = "Subscription Admin") and (SubscriptionID = "' + subId + '"))';  
        url += EncodingUtil.urlEncode(query, 'UTF-8');
        return callAlm(url).getBody();
    }

    private static HttpResponse callAlm(String url) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('zsessionid', '{!$Credential.Password}');
        req.setEndpoint(url);
        HttpResponse resp = new Http().send(req);
        return resp;
    }

}