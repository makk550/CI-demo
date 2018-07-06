public class TSO_ScheduleEventcontroller_New
{
    public Event eventrecord {get;set;}
    public String strRecTypeName {get;set;}
    private ID strRecTypeID;
    public ID TSOReqID {get;set;} 
    public String startDate {get;set;}
    public String strtime {get;set;}
    public String loggedinuserlocale {get;set;}    
    
    TSO_Request__c tsoreq = new TSO_Request__c();   
    TSO_Request_Product_Selection__c[] tsoreqprd; 
    public Relationship relclass {get;set;}
    
    public TSO_ScheduleEventcontroller_New(ApexPages.StandardController stdController)
    {
        eventrecord = (Event)stdController.getRecord();
        relclass = new Relationship();
        
        TSOReqID = ApexPages.currentPage().getParameters().get('tsoId');
        try{ 
            tsoreq = [select CreatedBy.Name,Partner_Name__c,OwnerId,Ent_Comm_Account__c,Duration_Hours__c,Start_Date_Time__c,End_Date__c,Location_Information__c,Account__r.Name,Name,Request_Type__c,Opportunity__r.Name,Coordinator_Name__r.Name from TSO_Request__c where ID =: TSOReqID];
            //eventrecord.TSO_Request_Id__c = TSOReqID;
            if(tsoreq!=null) 
            { 
                eventrecord.Event_Type__c = tsoreq.Request_Type__c;
                //eventrecord.Additional_Request_Details__c = tsoreq.Additional_Request_Details__c;
                eventrecord.Subject = 'TSO Event';
                            
                if(tsoreq.Start_Date_Time__c!=null)
                {
                    eventrecord.temp_StartDateTime__c = tsoreq.Start_Date_Time__c; 
                }
                if(tsoreq.End_Date__c!=null)
                {
                    eventrecord.temp_EndDateTime__c = tsoreq.End_Date__c; 
                }
            }
            
            tsoreqprd = [select Business_Unit__c,ProductId__c,ProductFamily__c,ProductId__r.Name from TSO_Request_Product_Selection__c where TSO_Request_ID__c =: TSOReqID];
            if(tsoreqprd.size()>0)
            {
                if(tsoreqprd[0]!=null)
                {
                    relclass.prod1 = tsoreqprd[0].ProductId__c;
                    relclass.prodname1 = tsoreqprd[0].ProductId__r.Name;
                    relclass.prodfamily1 = tsoreqprd[0].ProductFamily__c;
                    relclass.BU1 = tsoreqprd[0].Business_Unit__c;
                }
                
                if(tsoreqprd.size()>1)
                {
                    relclass.prod2 = tsoreqprd[1].ProductId__c;
                    relclass.prodname2 = tsoreqprd[1].ProductId__r.Name;
                    relclass.prodfamily2 = tsoreqprd[1].ProductFamily__c;
                    relclass.BU2 = tsoreqprd[1].Business_Unit__c;
                }
                if(tsoreqprd.size()>2)
                { 
                    relclass.prod3 = tsoreqprd[2].ProductId__c;
                    relclass.prodname3 = tsoreqprd[2].ProductId__r.Name;
                    relclass.prodfamily3 = tsoreqprd[2].ProductFamily__c;
                    relclass.BU3 = tsoreqprd[2].Business_Unit__c;
                }
            }
             
            RecordType rec = new RecordType();
            rec = [select Id,Name from RecordType where ISActive=true and SObjectType='Event' and Name='TSO Event'];
            strRecTypeName = rec.Name;
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
    public class Relationship
    {
        public String prodfamily1 {get;set;}
        public String prodfamily2 {get;set;}
        public String prodfamily3 {get;set;}
        public String BU1 {get;set;}
        public String BU2 {get;set;}
        public String BU3 {get;set;}
        public ID prod1 {get;set;}
        public ID prod2 {get;set;}
        public ID prod3 {get;set;}
        public String prodname1 {get;set;}
        public String prodname2 {get;set;}
        public String prodname3 {get;set;}
        public String startdatetime {get;set;}
        public String enddatetime {get;set;}
        public String tsostartdatetime {get;set;}
        public String tsoenddatetime {get;set;}
    }
    
    public PageReference saveEvent()
    {
        String eveid = ApexPages.currentPage().getParameters().get('newid');
        Event eve = [select id,IsRecurrence,RecurrenceActivityId,OwnerId,Location,StartDateTime,EndDateTime,Start_Date_Time__c,End_Date__c from Event where id=:eveid];
               
        List<TSO_Event_Product_Selection__c> lsttsoeventprdins = new List<TSO_Event_Product_Selection__c>(); 
        if(relclass.prodfamily1 != null)
        {
            if(relclass.BU1 != null)
            {
                if(relclass.prod1 != null)
                {
                    TSO_Event_Product_Selection__c eventprd1 = new TSO_Event_Product_Selection__c();
                    eventprd1.ProductID__c = relclass.prod1;
                    eventprd1.Event_Id__c = eveid;
                    lsttsoeventprdins.add(eventprd1);
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Warning,'You have selected only Product Family and Business Unit.Please also select the Product.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Warning,'You have selected only Product Family.Please also select Business Unit and Product.');
                ApexPages.addMessage(msg);
                return null;
            }
            
        } 
        if(relclass.prodfamily2 != null)
        {
            if(relclass.BU2 != null)
            {
                if(relclass.prod2 != null)
                {
                    TSO_Event_Product_Selection__c eventprd2 = new TSO_Event_Product_Selection__c();
                    eventprd2.ProductId__c = relclass.prod2;
                    eventprd2.Event_Id__c = eveid;
                    lsttsoeventprdins.add(eventprd2);
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Warning,'You have selected only Product Family and Business Unit.Please also select the Product.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Warning,'You have selected only Product Family.Please also select Business Unit and Product.');
                ApexPages.addMessage(msg);
                return null;
            }
            
        }
        if(relclass.prodfamily3 != null)
        {
            if(relclass.BU3 != null)
            {
                if(relclass.prod3 != null)
                {
                    TSO_Event_Product_Selection__c eventprd3 = new TSO_Event_Product_Selection__c();
                    eventprd3.ProductId__c = relclass.prod3;
                    eventprd3.Event_Id__c = eveid;
                    lsttsoeventprdins.add(eventprd3);
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Warning,'You have selected only Product Family and Business Unit.Please also select the Product.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Warning,'You have selected only Product Family.Please also select Business Unit and Product.');
                ApexPages.addMessage(msg);
                return null;
            }
            
        }
        try{
            if(lsttsoeventprdins.size()>0)
                insert lsttsoeventprdins;
        }catch(DMLException ex){
            System.debug(ex.getMessage());
        }
        List<TSO_Event_Product_Selection__c> lsteveprds = [select Id,ProductId__c,ProductId__r.Name from TSO_Event_Product_Selection__c where Event_Id__c =: eveid];
        System.debug(lsteveprds);
        //Send Email
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            User userassto = [select Id,Email from User where Id =: eve.OwnerId];
            String eveowner='';
            if(userassto!=null)
                eveowner = userassto.Email;
            User userreq = [select Id,Email from User where Id =: tsoreq.CreatedById];
            String everequestor='';
            if(userreq!=null)
                everequestor = userreq.Email;
            
            String[] toaddr = new String[]{eveowner};
            String[] ccaddr;
            if(everequestor != '' && everequestor != null)
            {
                ccaddr = new String[]{everequestor};
                mail.setCCAddresses(ccaddr);
            }
            
            mail.setToAddresses(toaddr);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setReplyTo('noreply@ca.com');
            
            mail.setSubject('*** NEW REQUEST FOR TSO ***');
            
            String strbody = '*** A NEW EVENT HAS BEEN PLACED ON YOUR CALENDAR*** <br><br>';
              
            strbody += 'The following TSO Event Request has been assigned to you from '+tsoreq.Coordinator_Name__r.Name+'<br><br>';
            string accname = '';
            if(tsoreq.Account__r.Name!=null)
                accname = tsoreq.Account__r.Name;
            strbody += 'Request Name: '+tsoreq.Name+' related to the '+accname+' - '+tsoreq.Opportunity__r.Name+' record<br><br>';
            strbody += 'Request Information:<br>';
            strbody += 'Request Type:'+tsoreq.Request_Type__c+'<br><br>';
            if(eve.Start_Date_Time__c <> null)
                strbody += 'Request Start Date & Time: '+eve.Start_Date_Time__c.format()+'<br><br>';
            else
                strbody += 'Request Start Date & Time: <br><br>';    
            if(eve.End_Date__c <> null)    
                strbody += 'Request End Date & Time: '+eve.End_Date__c.format()+'<br><br>';
            else
                strbody += 'Request End Date & Time: s<br><br>';
                
            strbody += 'Request Location:'+eve.Location+'<br><br>';
            //if(eve.Additional_Request_Details__c != null)
            //    strbody += 'Additional Request Details:'+eve.Additional_Request_Details__c+'<br><br><br>';
            //else
            //    strbody += 'Additional Request Details:<br><br><br>';
            //strbody += 'Product Information:<br><br>';
            if(lsteveprds.size()>0)
            {
                //lsttsoeventprdins[0].Product__c = '';
                strbody += 'Product1:'+lsteveprds[0].ProductId__r.Name+'<br><br>';
            }
                
            if(lsteveprds.size()>1)
            {
                //lsttsoeventprdins[1].Product__c = '';
                strbody += 'Product2:'+lsteveprds[1].ProductId__r.Name+'<br><br>';
            }
            if(lsteveprds.size()>2)
            {
                //lsttsoeventprdins[2].Product__c = '';
                strbody += 'Product3:'+lsteveprds[2].ProductId__r.Name+'<br><br><br>';
            }
            strbody += '***Please contact '+tsoreq.CreatedBy.Name+' if you are unable to attend this event.********';
            mail.setHtmlBody(strbody);
            System.debug(mail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            }catch(EmailException ex){
                System.debug(ex.getMessage());
            }
        
        //eveid = eveid.substring(0,eveid.length()-3) + 'D';
        //PageReference pref = new PageReference('/'+ eveid + '?eveid=' + eve.Id);
        String eventdetailpageid='';
        
        PageReference pref = new PageReference('/'+eve.Id);
        pref.setRedirect(true);
        return pref;
        
        //return null;
    } 
    
    public List<SelectOption> level1Items {        
    get {          
    List<SelectOption> options = new List<SelectOption>();            
      
    string sRecordTypeName = ''; 
            if(tsoreq!=null && tsoreq.Opportunity__c!=null){                
                Opportunity opp = [Select Pricebook2Id, Pricebook2.Name,RecordTypeId,RecordType.Name from Opportunity where Id=:tsoreq.Opportunity__c];
                sRecordTypeName = opp.RecordType.Name;                      
            }

            options.add(new SelectOption('','Select Value'));
/*
            if(sRecordTypeName == 'Renewal') { 
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
                options.add(new SelectOption('Services Labor Pool','Services Labor Pool'));
            } else if(sRecordTypeName == 'Med Touch Renewal') { 
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
                options.add(new SelectOption('Services Labor Pool','Services Labor Pool'));
            } else if(sRecordTypeName == 'Indirect') { 
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
                options.add(new SelectOption('Services Labor Pool','Services Labor Pool'));
            } else { 
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
            }
      */
            if(sRecordTypeName == 'New Opportunity')
            {
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
                options.add(new SelectOption('Education','Education'));
                options.add(new SelectOption('Support','Support'));
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
            }
            else
            {
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
                options.add(new SelectOption('Education','Education'));
            }
    return options;                   
    }        
    set;    
    }
    
    public List<SelectOption> level2Items 
    {        
        get {
                       
        List<SelectOption> options = new List<SelectOption>();            
        options.add(new SelectOption('','Select Value'));            
        if(relclass.prodfamily1!=null){        
            Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();        
            List<Schema.PicklistEntry> entries = F.getPicklistValues();          
            for(Schema.PicklistEntry entry : entries)
            {    
                if(relclass.prodfamily1 == 'Time')
                {
                    if(entry.getValue() == 'Future FY Time' || entry.getValue() == 'Current FY Time')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                else if(relclass.prodfamily1 == 'Mainframe Capacity')
                {
                    if(entry.getValue() == 'Mainframe Capacity')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));    
                }
                else if(relclass.prodfamily1 == 'Product' || relclass.prodfamily1 == 'Services' || relclass.prodfamily1 == 'Education' || relclass.prodfamily1 == 'Support')
                {
                    if(entry.getValue() != 'Future FY Time' && entry.getValue() != 'Current FY Time' && entry.getValue() != 'Mainframe Capacity')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                //else           
                    //options.add(new SelectOption(entry.getLabel(),entry.getValue()));        
            }                        
        }         
        return options;                   
        }        
        set;    
     }
     
     public List<SelectOption> level3Items {
        get {
            
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select Value'));
            
            if(relclass.prodfamily1!=null && relclass.BU1!=null){               
                List<Product2> products = [select Name,Id from Product2 where Market_Focus_Area__c=:relclass.BU1 and family=:relclass.prodfamily1 and IsActive=true order by Name];
                for(Product2 prod:products){
                    options.add(new SelectOption(prod.Id,prod.Name));
                    
                }
                    
            }
                  
            return options;           
        }
        set;
    } 
    public List<SelectOption> secondBU 
    {        
        get {
                       
        List<SelectOption> options = new List<SelectOption>();            
        options.add(new SelectOption('','Select Value'));            
        if(relclass.prodfamily2!=null){
        
            Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();        
            List<Schema.PicklistEntry> entries = F.getPicklistValues();          
            for(Schema.PicklistEntry entry : entries)
            {    
                if(relclass.prodfamily2 == 'Time')
                {
                    if(entry.getValue() == 'Future FY Time' || entry.getValue() == 'Current FY Time')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                else if(relclass.prodfamily2 == 'Mainframe Capacity')
                {
                    if(entry.getValue() == 'Mainframe Capacity')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));    
                }
                else if(relclass.prodfamily2 == 'Product' || relclass.prodfamily2 == 'Services' || relclass.prodfamily2 == 'Education' || relclass.prodfamily2 == 'Support')
                {
                    if(entry.getValue() != 'Future FY Time' && entry.getValue() != 'Current FY Time' && entry.getValue() != 'Mainframe Capacity')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }      
                      
            }        
                                    
        }
        
        return options;                   
        }        
        set;    
    }
    public List<SelectOption> secondProducts {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select Value'));

            if(relclass.prodfamily2!=null && relclass.BU2!=null){               
                List<Product2> products = [select Name,Id from Product2 where Market_Focus_Area__c=:relclass.BU2 and family=:relclass.prodfamily2 and IsActive=true order by Name];
                for(Product2 prod:products){
                    options.add(new SelectOption(prod.Id,prod.Name));
                }
            }           
            return options;           
        }
        set;
    }
    public List<SelectOption> thirdBU 
    {        
        get {
                       
        List<SelectOption> options = new List<SelectOption>();            
        options.add(new SelectOption('','Select Value'));            
        if(relclass.prodfamily3!=null)
        {
            Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();        
            List<Schema.PicklistEntry> entries = F.getPicklistValues();          
            for(Schema.PicklistEntry entry : entries)
            {     
                if(relclass.prodfamily3 == 'Time')
                {
                    if(entry.getValue() == 'Future FY Time' || entry.getValue() == 'Current FY Time')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                else if(relclass.prodfamily3 == 'Mainframe Capacity')
                {
                    if(entry.getValue() == 'Mainframe Capacity')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));    
                }
                else if(relclass.prodfamily3 == 'Product' || relclass.prodfamily3 == 'Services' || relclass.prodfamily3 == 'Education' || relclass.prodfamily3 == 'Support')
                {
                    if(entry.getValue() != 'Future FY Time' && entry.getValue() != 'Current FY Time' && entry.getValue() != 'Mainframe Capacity')
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }     
                        
            }                       
        }
                    
        return options;                   
        }        
        set;    
     }
    public List<SelectOption> thirdProducts {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select Value'));

            if(relclass.prodfamily3!=null && relclass.BU3!=null){               
                List<Product2> products = [select Name,Id from Product2 where Market_Focus_Area__c=:relclass.BU3 and family=:relclass.prodfamily3 and IsActive=true order by Name];
                for(Product2 prod:products){
                    options.add(new SelectOption(prod.Id,prod.Name));
                }
            }           
            return options;           
        }
        set;
    }
    
}