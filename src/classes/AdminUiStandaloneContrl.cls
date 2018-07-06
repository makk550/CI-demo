public class AdminUiStandaloneContrl {
    public string cemail {get;set;}
    public string selectedVale{set;get;}
    public string prodId{set;get;}
    Public string contractNumber{set;get;}
    Public string subScriptionName{set;get;}
    public AdminUiStandaloneContrl(){
        
    }
    public PageReference validateAndSearch()
    {
                                 // Added as part of US340517  

        if(String.isNotBlank(cemail)&&cemail.contains('@') && cemail.contains('.') )
        {
            cemail=EncodingUtil.urlEncode(cemail, 'UTF-8');

            return new PageReference('/apex/AdminUiPage?cemail='+cemail+'&'+'checkCon='+'true');
        }else if(String.isNotBlank(prodId)){
                        prodId=EncodingUtil.urlEncode(prodId, 'UTF-8');
            return new PageReference('/apex/AdminUiPage?prodId='+prodId+'&'+'checkCon='+'true');
            
        }else if(String.isNotBlank(contractNumber)){
               contractNumber=EncodingUtil.urlEncode(contractNumber, 'UTF-8');
            return new PageReference('/apex/AdminUiPage?contractNumber='+contractNumber+'&'+'checkCon='+'true');
            
        }else if(String.isNotBlank(subScriptionName)){
             subScriptionName=EncodingUtil.urlEncode(subScriptionName, 'UTF-8');
          return new PageReference('/apex/AdminUiPage?subScriptionName='+subScriptionName+'&'+'checkCon='+'true');  
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,Label.Search_Criteria_Error_Message));
        }
        return null;
    }
}