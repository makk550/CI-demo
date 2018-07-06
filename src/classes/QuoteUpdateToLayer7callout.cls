public class QuoteUpdateToLayer7callout implements Queueable, Database.AllowsCallouts {
              private list<scpq__SciQuote__c> quotelist;
    public QuoteUpdateToLayer7callout(List<scpq__SciQuote__c> qlist){
        this.quotelist=qlist;
    }
    
    public void execute(QueueableContext queCont) {
       List<String> requestPayload = new List<String>();
        for(scpq__SciQuote__c q: quotelist){
             //String xmlStructure = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:yan="http://yantra.com/yantrawebservices"><soapenv:Header/><soapenv:Body><yan:updateCAWorkflowDetails><String_1><Environment userId="admin" progId="EAI"/></String_1><String_2><Order OrderNo="'+q.CA_CPQ_Quote_Number__c+'" EnterpriseCode="CA" EnteredBy=""><Extn ExtnCaQuoteStatus="'+q.Oubound_Status__c+'" ExtnCaDdrName="'+q.CA_DDR_Name__c +'"/></Order></String_2></yan:updateCAWorkflowDetails></soapenv:Body></soapenv:Envelope>';
            String xmlStructure = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ejb="http://ejb.rpc.webservices.services.interop.yantra.com/"><soapenv:Header/><soapenv:Body><ejb:updateCAWorkflowDetails><!--Optional:--><arg0>   &lt;Environment userId=&quot;cpqintegrationuser&quot; progId=&quot;EAI&quot;/&gt; </arg0><!--Optional:--><arg1>&lt;Order OrderNo=&quot;'+q.CA_CPQ_Quote_Number__c+'&quot; EnterpriseCode=&quot;CA&quot; EnteredBy=&quot;&quot;&gt;&lt;Extn ExtnCaQuoteStatus=&quot;'+q.Oubound_Status__c+'&quot; ExtnCaDdrName=&quot;'+q.CA_DDR_Name__c+'&quot;/&gt;&lt;/Order&gt;</arg1></ejb:updateCAWorkflowDetails></soapenv:Body></soapenv:Envelope>';  
            system.debug('xmlStructure : ' + xmlStructure);
            requestPayload.add(xmlStructure);
        }
    QuoteUpdateToLayer7.callQuoteUpdatefromFutureMethod(requestPayload);

    }
}