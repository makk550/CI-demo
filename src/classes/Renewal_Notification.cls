public class Renewal_Notification 
{
    Map<String,Ruletable_for_Approval_notification__c> ReportMap = new MAp<String,Ruletable_for_Approval_notification__c>();
    public void EmailReportNotification()
    {
        List<Ruletable_for_Approval_notification__c> rules ;
        String toaddress='';
        rules =[Select Id,Name,Market__c,Account_Type__c,Segmentation__c,User_To_Be_Notified__c,Useremail__c from Ruletable_for_Approval_notification__c];
        System.Debug('date----'+System.today());
        List<Renewal__c> lstRen = [Select Id,Name,Segmentation__c,Account__r.Name,
                         Account__r.Market__c,Account__r.Customer_Category__c,Is_Segmentation_Changed__c from Renewal__c
                         where (Change_Of_Projected_Renewal__c >=:5 OR Is_Segmentation_Changed__c=:true) and ChangeDate__c>=:System.today()-7];
                                   
        system.Debug(lstRen);
        map<string,List<Renewal__c>> MapByArea = new map<string, List<Renewal__c>>();
        map<string,List<Renewal__c>> MapByRegion = new map<string, List<Renewal__c>>();
        map<string,List<Renewal__c>> MapBySegmentation = new map<string, List<Renewal__c>>();
        map<string,List<Renewal__c>> MapByTerritory = new map<string, List<Renewal__c>>();
        map<string,List<Renewal__c>> MapByAccountType = new map<string, List<Renewal__c>>();
        map<string,List<Renewal__c>> MapByMarket = new map<string, List<Renewal__c>>();
        
        for(Renewal__c r: lstRen)
        {
            List<Renewal__c> lsttemp;
                       
                       
             if(r.Segmentation__c != null)
            {
                lstTemp = MapBySegmentation .get(r.Segmentation__c.toUpperCase());
                if(lstTemp == null) { lstTemp = new List<Renewal__c>(); }
                lstTemp.add(r);
                MapBySegmentation .put(r.Segmentation__c.toUpperCase(), lstTemp);
            }
            
                        
             if(r.Account__r.Customer_Category__c != null)
            {
                lstTemp = MapByAccountType .get(r.Account__r.Customer_Category__c.toUpperCase());
                if(lstTemp == null) { lstTemp = new List<Renewal__c>(); }
                lstTemp.add(r);
                MapByAccountType .put(r.Account__r.Customer_Category__c.toUpperCase(), lstTemp);
            }
            
            if(r.Account__r.Market__c != null)
            {
                lstTemp = MapByMarket .get(r.Account__r.Market__c.toUpperCase());
                if(lstTemp == null) { lstTemp = new List<Renewal__c>(); }
                lstTemp.add(r);
                MapByMarket .put(r.Account__r.Market__c.toUpperCase(), lstTemp);
            }
            
            
        }
        
        
      if(lstRen.size()>0)
         for(Ruletable_for_Approval_notification__c rule :rules)
                {
                    String market = '';
                    String region = '';
                    String area = '';
                    String territory = '';
                    String Segmentation='';
                    String AccountType='';
                                    
                    if(rule.market__c != null)
                    {
                        if(MapByMarket.get(rule.market__c.toUpperCase()) != null)
                          market =  rule.market__c;
                        else
                         continue;  
                    }
                                       if(rule.Segmentation__c !=null)
                    {
                        if(MapByArea.get(rule.Segmentation__c.toUpperCase())!=null)
                        Segmentation=rule.Segmentation__c;
                        else
                        continue;
                    }
                    if(rule.Account_Type__c !=null)
                    {
                        if(MapByArea.get(rule.Account_Type__c.toUpperCase())!=null)
                        AccountType=rule.Account_Type__c;
                        else
                        continue;
                    }                   
                    string queryparams = '';
                    if(area != '')
                        queryparams += 'pv1=' + EncodingUtil.urlEncode(area,'UTF-8');
                    if(region != '')    
                        queryparams += (queryparams==''?'':'&') + 'pv2=' + EncodingUtil.urlEncode(region,'UTF-8');
                    if(AccountType != '')     
                         queryparams += (queryparams==''?'':'&') + 'pv3='+EncodingUtil.urlEncode(AccountType,'UTF-8');
                    if(market != '')  
                         queryparams += (queryparams==''?'':'&') + 'pv4='+EncodingUtil.urlEncode(market,'UTF-8');
                    if(Segmentation != '')
                            queryparams += (queryparams==''?'':'&') + 'pv6='+EncodingUtil.urlEncode(Segmentation,'UTF-8');
                    
                    sendEmail(queryparams,rule.Useremail__c);// 'anssa01@ca.com');
                    
        }
    }
    
    public void sendEmail(string querypar, string emailid)
    {
        Report report =[Select r.Name,r.Id,DeveloperName From Report r where DeveloperName =:'Renewal_Report_for_Notifications'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {emailid};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Notification for Percentage Change in Annual Projected Renewal');
        mail.setPlainTextBody ('https://na1.salesforce.com/'+ report.Id +'?'+ querypar);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       
    }   
    
}