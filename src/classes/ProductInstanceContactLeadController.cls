public class ProductInstanceContactLeadController {
    
    @TestVisible string emailrecord; //variable to store emailid from lead/contact
    @TestVisible List<Contact_Instance__x> instid; //variable to store the instance id from contact_instance__x external object
    public Boolean hasalmdetails{get;set;}
    public Boolean hasflowdetails{get;set;}
    @TestVisible List<String> instdetails1;
    @TestVisible List<String> instdetails2;
    @TestVisible List<ProductInstanceView__x> prodinst{get;set;} //variable used to display value on the page.
    Public ProductInstanceView__x almdata{get;set;}
    Public ProductInstanceView__x fdedata{get;set;}
    public string usageredirectString{get;set;}
    public Decimal ALMTotalUnpaidSeats{get;set;}
    public Decimal FD_unpaid_addon_seats{get;set;}
    public Decimal FD_paid_addon_seats{get;set;}
    public Decimal FD_paid_standalone_seats{get;set;}
    static Map<String,String> paramMap;
    
    public ProductInstanceContactLeadController(){
        hasalmdetails = false;
        hasflowdetails = false;
        FD_unpaid_addon_seats = 0;
        FD_paid_addon_seats = 0;
        FD_paid_standalone_seats = 0;
        if(ApexPages.currentPage().getParameters().get('emailId')!=null&&ApexPages.currentPage().getParameters().get('emailId')!=''){
            emailrecord = ApexPages.currentPage().getParameters().get('emailId');
            instid = new List<Contact_Instance__x>();
            prodinst = new List<ProductInstanceView__x>();
            almdata = new ProductInstanceView__x();
            fdedata = new ProductInstanceView__x();
            usageredirectString = '';
            paramMap = ApexPages.currentPage().getParameters();
            for(String eachParam : paramMap.keySet()){
                usageredirectString +='&'+eachParam+'='+paramMap.get(eachParam);
            }
            if(String.isNotBlank(paramMap.get('conid'))){
               String accName = [Select Account.Name from Contact Where Id=:paramMap.get('conid')].Account.Name;
               usageredirectString +='&accName='+accName;
            }
            fetchrecord();
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Info,'There is no email associated with the contact/lead record. Please select a contact/lead that has an email.'));
        }
    }
    
    public void fetchrecord(){
        
        
        if(!String.isBlank(emailrecord)){
            try{
                if(!Test.isRunningTest()){
                    instid = [Select instance_id__c from Contact_Instance__x where email__c =:emailrecord];
                }
                else{
                    instid = dummyinstid();
                }
                
                
                if(instid.size()>0)
                {
                    instdetails1 = new List<String>();
                    instdetails2 = new List<String>();
                    
                    for(Contact_Instance__x c:instid){
                        if(!String.isBlank(c.instance_id__c)){
                            if(instdetails1.size() < 15){
                                instdetails1.add(c.instance_id__c);
                            }
                            else{
                                instdetails2.add(c.instance_id__c);
                            }
                        }
                    }
                    system.debug('--------'+instdetails1);
                    system.debug('--------'+instdetails2);
                    Date todaysdate = System.today();
                    Time defaultendtime = Time.newInstance(0, 0, 0, 0);
                    Time defaultstarttime = Time.newInstance(23,59,59,999);
                    Datetime enddt = Datetime.newInstance(todaysdate,defaultendtime);
                    Datetime startdt = Datetime.newInstance(todaysdate,defaultstarttime);
                    String enddtstring = String.valueOf(enddt);
                    String startdtstring = String.valueOf(startdt);
                    Datetime finaldt = datetime.valueOfGmt(enddtstring);
                    Datetime finalstartdt = datetime.valueOfGmt(startdtstring);
                    if(instdetails1.size()>0){
                        // prodinst = [Select instance_id__c,product_instance_id__c,name__c,product_detail__c,entitlement_start_date__c,entitlement_end_date__c,quantity__c,edition__c,entitlement_type__c,software_type__c,metric__c from ProductInstanceView__x where instance_id__c in:instdetails1];
                        if(!Test.isRunningTest()){
                            prodinst = [Select instance_id__c,product_instance_id__c,name__c,product_detail__c,entitlement_start_date__c,entitlement_end_date__c,quantity__c,edition__c,entitlement_type__c,software_type__c,metric__c from ProductInstanceView__x where instance_id__c in:instdetails1 and (status__c='active' OR status__c='Active') and product_instance_id__c!=null and quantity__c>:0 and entitlement_start_date__c<=:finalstartdt and entitlement_end_date__c>=:finaldt and fulfillment_status__c=:'fulfillment complete'];
                        }
                        else{
                            prodinst = dummyprodinstdata();
                        }
                        
                        if(instdetails2.size() >0){
                         // for(ProductInstanceView__x inst : [Select instance_id__c,product_instance_id__c,name__c,product_detail__c,entitlement_start_date__c,entitlement_end_date__c,quantity__c,edition__c,entitlement_type__c,software_type__c,metric__c from ProductInstanceView__x where instance_id__c in:instdetails2]){
                            for(ProductInstanceView__x inst : [Select instance_id__c,product_instance_id__c,name__c,product_detail__c,entitlement_start_date__c,entitlement_end_date__c,quantity__c,edition__c,entitlement_type__c,software_type__c,metric__c from ProductInstanceView__x where instance_id__c in:instdetails2 and (status__c='active' OR status__c='Active') and product_instance_id__c!=null and quantity__c>:0 and entitlement_start_date__c<=:finalstartdt and entitlement_end_date__c>=:finaldt and fulfillment_status__c=:'fulfillment complete']){

                                prodinst.add(inst);
                            }
                        }
                    }
                    
                    else{
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Info,'There is no Entitlement associated with this contact/lead.'));
                        hasalmdetails = false;
                        hasflowdetails = false;
                    }
                    
                                       
                    
                    
                    if(prodinst.size()>0){
                        almdata.quantity__c = 0;
                        fdedata.quantity__c = 0;
                        ALMTotalUnpaidSeats = 0;
                        
                        for(ProductInstanceView__x temp:prodinst){
                            
                            if(!String.isBlank(temp.metric__c) && !String.isBlank(temp.name__c) && (temp.metric__c=='PaidSeats' || temp.metric__c=='UnpaidSeats' )&&temp.name__c.containsIgnoreCase('Agile Central')){
                                if(temp.product_instance_id__c!=null && temp.product_instance_id__c!='')
                                    almdata.product_instance_id__c = temp.product_instance_id__c;
                                else
                                    almdata.product_instance_id__c = 'Awaiting Provisioning';
                                
                                almdata.instance_id__c = temp.instance_id__c;
                                almdata.product_detail__c = temp.product_detail__c;
                                almdata.name__c = temp.name__c;
                                almdata.entitlement_start_date__c = temp.entitlement_start_date__c;
                                almdata.entitlement_end_date__c = temp.entitlement_end_date__c;
                                if(temp.metric__c=='paidseats' && temp.quantity__c!=null)
                                    almdata.quantity__c += temp.quantity__c;
                                else if(temp.metric__c=='unpaidseats' && temp.quantity__c!=null)
                                    ALMTotalUnpaidSeats += temp.quantity__c;
                                almdata.edition__c = temp.edition__c;
                                almdata.entitlement_type__c = temp.entitlement_type__c;
                                almdata.software_type__c = temp.software_type__c;
                                hasalmdetails = true;
                            }
                                                      
                       
                            
                            if(!String.isBlank(temp.metric__c) && !String.isBlank(temp.name__c) && (temp.metric__c.containsIgnoreCase('max_ue_seats') || temp.metric__c.containsIgnoreCase('unpaid_addon_seats') || temp.metric__c.containsIgnoreCase('paid_addon_seats') || temp.metric__c.containsIgnoreCase('paid_standalone_seats') ) && temp.name__c.containsIgnoreCase('flowdock')){

                                if(temp.product_instance_id__c !=null && temp.product_instance_id__c!='')                                  
                                    fdedata.product_instance_id__c = temp.product_instance_id__c;
                                else
                                    
                                fdedata.product_instance_id__c = 'Awaiting Provisioning';
                                fdedata.instance_id__c = temp.instance_id__c;
                                fdedata.product_detail__c = temp.product_detail__c;
                                fdedata.name__c = temp.name__c;
                                fdedata.entitlement_start_date__c = temp.entitlement_start_date__c;
                                fdedata.entitlement_end_date__c = temp.entitlement_end_date__c;
                                if(temp.metric__c.containsIgnoreCase('max_ue_seats') && temp.quantity__c!= null)
                                    fdedata.quantity__c += temp.quantity__c;
                                if(temp.metric__c.containsIgnoreCase('unpaid_addon_seats') && temp.quantity__c!= null)
                                    FD_unpaid_addon_seats += temp.quantity__c;
                                if(temp.metric__c.containsIgnoreCase('paid_addon_seats') && temp.quantity__c!= null)
                                    FD_paid_addon_seats += temp.quantity__c;
                                if(temp.metric__c.containsIgnoreCase('paid_standalone_seats') && temp.quantity__c!= null)
                                    FD_paid_standalone_seats += temp.quantity__c;
                                fdedata.edition__c = temp.edition__c;
                                fdedata.entitlement_type__c = temp.entitlement_type__c;
                                fdedata.software_type__c = temp.software_type__c;
                                hasflowdetails = true;
                            }
                        }
                        
                        if(hasalmdetails==false && hasflowdetails==false){
                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Info,'There is no Entitlement associated with this customer.'));
                        }
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Info,'There is no Entitlement associated with this customer.'));
                        hasalmdetails = false;
                        hasflowdetails = false;
                    }   
                }
                else{
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Info,'There is no Entitlement associated with this customer.'));
                    hasalmdetails = false;
                    hasflowdetails = false;
                }
            }  
            catch(exception e)
            {
                ApexPages.addMessages(e);
                System.debug('exception is'+e);
            }
        }
        
    }
    
    
    //method to help redirection for Back Button
    public pageReference redirectHelper(){
        
        Map<String,String> pageparams = ApexPages.currentPage().getParameters();
        
        if( pageParams.containsKey('leadId')){
            return new PageReference('/'+pageParams.get('leadId'));
        }
        else
        {
            return new PageReference('/'+pageParams.get('conId'));
        }
       return null;
    }
    
    @TestVisible
    private List<Contact_Instance__x> dummyinstid(){
        List<Contact_Instance__x> dummylist = new List<Contact_Instance__x>();
        
        Contact_Instance__x c1 = new Contact_Instance__x();
        c1.instance_id__c = 'I0040244878000025nAetDmX27kQWcR}0b}{8cW';
        c1.email__c = 'LONNA.HANNAN@KOHLS.COM';
        dummylist.add(c1);
        
        Contact_Instance__x c2 = new Contact_Instance__x();
        c2.instance_id__c = 'I0040244879000025nAetDtGc7jQWcjECjFZTy0';
        c2.email__c = 'LONNA.HANNAN@KOHLS.COM';
        dummylist.add(c2);
        
        return dummylist;
    }
    
    @TestVisible
    private List<ProductInstanceView__x> dummyprodinstdata(){
        List<ProductInstanceView__x> dummylist = new List<ProductInstanceView__x>();
        ProductInstanceView__x t1 = new ProductInstanceView__x();
        t1.ca_site_id__c = '123456789';
        t1.duns__c = '060321254';
        t1.product_instance_id__c = '';
        t1.instance_id__c = 'I0040244878000025nAetDmX27kQWcR}0b}{8cW';
        t1.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t1.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        string year = '2008';
        string month = '10';
        string year2 = '2009';
        string day = '5';
        string hour = '12';
        string minute = '20';
        string second = '20';
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        string stringDate2 = year2 + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        t1.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t1.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t1.quantity__c = 10;
        t1.edition__c = 'UE';
        t1.entitlement_type__c = 'Paid';
        t1.software_type__c = 'Hosted';
        t1.metric__c = 'paidseats';
        dummylist.add(t1);
        ProductInstanceView__x t2 = new ProductInstanceView__x();
        t2.ca_site_id__c = '123456789';
        t2.duns__c = '060321254';
        t2.product_instance_id__c = '5524';
        t2.instance_id__c = 'I0040244878000025nAetDmX27kQWcR}0b}{8cW';
        t2.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t2.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t2.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t2.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t2.quantity__c = 15;
        t2.edition__c = 'UE';
        t2.entitlement_type__c = 'Paid';
        t2.software_type__c = 'Hosted';
        t2.metric__c = 'unpaidseats';
        dummylist.add(t2);
        ProductInstanceView__x t3 = new ProductInstanceView__x();
        t3.ca_site_id__c = '0000007994';
        t3.duns__c = '980455968';
        t3.product_instance_id__c = '5525';
        t3.instance_id__c = 'I0040244878000025nAetDmX27kQWcR}0b}{8cW';
        t3.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t3.name__c = 'CA Agile Central Unlimited Edition PERPETUAL';
        t3.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t3.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t3.quantity__c = 15;
        t3.edition__c = 'UE';
        t3.entitlement_type__c = 'Paid';
        t3.software_type__c = 'Hosted';
        t3.metric__c = 'unpaidseats';
        dummylist.add(t3);
        
        
        ProductInstanceView__x t4 = new ProductInstanceView__x();
        t4.ca_site_id__c = '0000007995';
        t4.duns__c = '189699317';
        t4.product_instance_id__c = '';
        t4.instance_id__c = 'I0040244879000025nAetDtGc7jQWcjECjFZTy0';
        t4.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t4.name__c = 'CA FlowDock';
        t4.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t4.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t4.quantity__c = 15;
        t4.edition__c = 'UE';
        t4.entitlement_type__c = 'Paid';
        t4.software_type__c = 'Hosted';
        t4.metric__c = 'max_ue_seats';
        dummylist.add(t4);
        
        ProductInstanceView__x t5 = new ProductInstanceView__x();
        t5.ca_site_id__c = '0000007996';
        t5.duns__c = '189699317';
        t5.product_instance_id__c = '5525';
        t5.instance_id__c = 'I0040244879000025nAetDtGc7jQWcjECjFZTy0';
        t5.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t5.name__c = 'CA Flowdock';
        t5.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t5.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t5.quantity__c = 15;
        t5.edition__c = 'UE';
        t5.entitlement_type__c = 'UnPaid';
        t5.software_type__c = 'Hosted';
        t5.metric__c = 'unpaid_addon_seats';
        dummylist.add(t5);
        
        ProductInstanceView__x t6 = new ProductInstanceView__x();
        t6.ca_site_id__c = '0000007916';
        t6.duns__c = '791312069';
        t6.product_instance_id__c = '5525';
        t6.instance_id__c = 'I0040244879000025nAetDtGc7jQWcjECjFZTy0';
        t6.product_detail__c = 'OLYMPUS AMERICA, INC.';
        t6.name__c = 'CA FlowDock';
        t6.entitlement_start_date__c = Datetime.valueOf(stringDate);
        t6.entitlement_end_date__c = DateTime.valueOf(stringDate2);
        t6.quantity__c = 15;
        t6.edition__c = 'UE';
        t6.entitlement_type__c = 'Paid';
        t6.software_type__c = 'Hosted';
        t6.metric__c = 'paid_addon_seats';
        dummylist.add(t6);
        
        return dummylist;
        
    }
    

}