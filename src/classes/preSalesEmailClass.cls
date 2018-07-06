/*
* Uses Test Class = PreSalesEmailClassTest
* Coverage = 100%.
* Updated by SAMTU01
*/  
public class preSalesEmailClass {
    
    public static string emailsubject(String geo, String salesregion, String CBU, String segment,String covmodel){ //added cov model in method as part of US334584 by SAMTU01
        String subject;
        subject = 'Presales Request'+' - '+ geo+', '+ salesregion+', '+ cbu+', '+segment+', '+covmodel;
        return subject;
    }
      public static string emailsubjectAdd(String geo, String salesregion, String CBU, String segment,String covmodel){ //added cov model in method as part of US334584 by SAMTU01
        String subject;
        subject = 'Presales Request for Add'+' - '+ geo+', '+ salesregion+', '+ cbu+', '+segment+', '+covmodel;
        return subject;
    }
    
    public static string emailsubjectcancel(String geo, String salesregion, String CBU, String segment,String covmodel){ //added cov model in method as part of US334584 by SAMTU01
        String subject;
        subject = 'Presales Request for Cancel'+' - '+ geo+', '+ salesregion+', '+ cbu+', '+segment+', '+covmodel;
        return subject;
    }
    
    public static string emailsubjectremoval(String geo, String salesregion, String CBU, String segment,String covmodel){ //added cov model in method as part of US334584 by SAMTU01
        String subject;
        subject = 'Presales Request for Removal'+' - '+ geo+', '+ salesregion+', '+ cbu+', '+segment+', '+covmodel;
        return subject;
    }
    
    public static string emailbody(String oppName, String oppNumber, String oppOwner, String oppAccount,String PreReqNum){ //added presales req number in method as part of US331730 by SAMTU01
        string body;
        body = 'Dear Presales Director,</br><p>A Presales request has been submitted for your approval.</br></br>'+''+'Opportunity Name: '+ oppName+'</br>'+'Opportunity Number: '+oppNumber+'</br>'+'Opportunity Owner Name: '+oppOwner+'</br>'+'Account Name: '+oppAccount+'</br>'+'Presales Request Number: '+PreReqNum+'</br>';
        return body;
    }
    
    public static string presalesrequestpagelink(String recordid,string stringur){
        string pagelink;
        pagelink = 'Please complete the approval process by clicking on the link below:</p></br><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PreSalesEditpage?id='+recordid+'>'+stringur+'</a>'+'</br>'+'</br>'+'Thank You,';
        return pagelink;
    }
    
    public static string presalesremovepagelink(String recordid,string stringur){
        string pagelink;
        pagelink = 'Please complete the approval process by clicking on the link below:</p></br><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RemoveByPresalesDirectorPage?id='+recordid+'>'+stringur+'</a>'+'</br>'+'</br>'+'Thank You,';
        return pagelink;
    }
    
    public static string presalescancelpagelink(String recordid,string stringur){
        string pagelink;
        pagelink = 'Please complete the approval process by clicking on the link below:</p></br><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RemoveByPresalesDirectorPage?id='+recordid+'&'+'cancelApprove'+'='+'true'+'>'+stringur+'</a>'+'</br></br>'+'Thank You';
        return pagelink;
    }

}