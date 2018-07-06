//Created as part of US489975 by BAJPI01, for email functionality,
//for site selected from duplicate search results.

public class leanCustomerEmailFunctionalityClass {
    
    public static List<Messaging.SingleEmailMessage> messages;
	
    //called from Quote_CustomerDetails_Controller. It checks for various conditions and sends email accoridngly.
    public static void userEmailMethod(String searchType, String selectedAccGroup, String selectedAccId, String selectedSiteId, String selectedEdmAction, String selectedAction, SBQQ__Quote__c quote){
        String accGroup = Quote_MDMSiteSearchController.getAccountGroup(searchType);
        system.debug('----account group sold to-----'+accGroup);
        
        Boolean userEmailFormed = false;		//boolean to form user email only once, as email format for blocked site
        										//and different account group is the same.
        Boolean stewardEmailFormed = false;		//boolean to form steward email only once, as email format for blocked site
        										//and different account group is the same.
        
        Boolean isPartnerQuote = false;
        
        if(quote.Transaction_Type__c=='1 Tier'){
            isPartnerQuote = true;		//Partner Quote only when transcaction type is 1 Tier.
        }
        else{
            isPartnerQuote = false;
        }
        
        List<User> userDetail = new List<User>();
        userDetail = [select Name,PMFKey__c from user where id=:UserInfo.getUserId()];
        String userName = '';
        String accountName = quote.SBQQ__Account__r.Name + ', ' + quote.SBQQ__Account__r.Enterprise_ID__c;
        if(userDetail!=null && userDetail.size()==1)
            userName = userDetail[0].Name + ', ' + userDetail[0].PMFKey__c;
        
        //if account groups are different, sends an email.
        if(String.isNotBlank(accGroup) && String.isNotBlank(selectedAccGroup)){
            system.debug('--acc groups not blank sold to--');
            String tempselectedAccGroup = selectedAccGroup.substring(0, 4);
            if(accGroup!=tempselectedAccGroup){
                system.debug('-----diff acc group sold to-----');
                userEmailFormed = true;
                stewardEmailFormed = true;
                formDiffAccountGroupUserEmail(quote.SBQQ__Account__r.Name,quote.Name,selectedSiteId);
                formDiffAccountGroupStewardEmail(selectedEdmAction,accountName,quote.Name,selectedSiteId,selectedAccGroup,searchType,accGroup,selectedAction,userName,quote.Transaction_Type__c);
            }
                
        }
        
        //US489975 blank account email - (only for non partner quote - BAJPI01, US513837)
        if(isPartnerQuote==false && stewardEmailFormed==false && String.isBlank(selectedAccId)){
            stewardEmailFormed = true;
            formDiffAccountGroupStewardEmail(selectedEdmAction,accountName,quote.Name,selectedSiteId,selectedAccGroup,searchType,accGroup,selectedAction,userName,quote.Transaction_Type__c);
        }
        
		//blocked site email
        if(String.isNotBlank(selectedAction) && selectedAction.containsIgnoreCase('Block')){
            if(userEmailFormed==false)
	            formDiffAccountGroupUserEmail(quote.SBQQ__Account__r.Name,quote.Name,selectedSiteId);
            if(stewardEmailFormed==false)
            	formDiffAccountGroupStewardEmail(selectedEdmAction,accountName,quote.Name,selectedSiteId,selectedAccGroup,searchType,accGroup,selectedAction,userName,quote.Transaction_Type__c);
        }
    }
    
    
    //different account group/blocked site email for sales rep
    public static void formDiffAccountGroupUserEmail(String accName, String quoteNumber, String siteId){
        
        if(messages==null)
            messages = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String subject = '';
        String body = '';
        List<String> emailList = new List<String>();
        

        emailList.add(UserInfo.getUserEmail());
        
        
        subject = Label.Diff_Acc_Group_Email_User_Subject + ' '+siteId + ', Quote: '+quoteNumber;
        body = Label.Diff_Acc_Group_Email_User_Body;
        body = body + '<table>';
        body = body + '<tr><td>Quote Number: '+'<td>'+quoteNumber+'<tr/>';
        body = body + '<tr><td>SAP Site ID: '+'<td>'+siteId+'<tr/>';
        body = body + '</table><br/>';
        //body = body + '<tr><td>Quote Number: '+'<td>'+quoteNumber+'<br/>SAP Site ID: '+siteId+'<br/><br/>';
        body = body + Label.Diff_Acc_Group_Email_User_Body_2;
        message.setSubject(subject);
        message.setHTMLBody(body);
        message.setToAddresses(emailList);
        messages.add(message);
        
        system.debug('----email list-----'+messages);
    }
    
    //different account group/blocked site email for Steward
    public static void formDiffAccountGroupStewardEmail(String edmAction, String accName, String quoteNumber, String siteId, String siteAccGrp, String searchType, String searchTypeAccGrp, String action, String userName, String oppTransType){
        
        if(messages==null)
            messages = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String subject = '';
        String body = '';
        List<String> emailList = new List<String>();
        
        emailList.addAll(Label.Lean_Customer_Steward_Email_List.split(';'));
        
        if(searchType=='RESELLER'||searchType=='ENDUSERID')
            searchType='SOLDTO';
        
        subject = 'SAP Site: '+siteId +' ' + Label.Diff_Acc_Group_Email_Steward_Subject;
        body = Label.Diff_Acc_Group_Email_Steward_Body+siteId +' ' +Label.Diff_Acc_Group_Email_Steward_Body_2+'<br/><br/>';
        body = body + '<table>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_3 + '<td>' + edmAction +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_10 + '<td>' + userName +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_4 + '<td>' + quoteNumber +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_11 + '<td>' + oppTransType +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_5 + '<td>' + accName +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_6 + '<td>' + siteId +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_7 + '<td>' + siteAccGrp +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_8 + '<td>' + searchTypeAccGrp + ', ' +searchType +'</tr>';
        body = body + '<tr><td>' +Label.Diff_Acc_Group_Email_Steward_Body_9 + '<td>' + action +'</tr>';
        body = body + '</table><br/>';
        body = body + 'Thanks,<br/>Salesforce';
        message.setSubject(subject);
        message.setHTMLBody(body);
        message.setToAddresses(emailList);
        messages.add(message);
        
        system.debug('----email list-----'+messages);
    }
    
}