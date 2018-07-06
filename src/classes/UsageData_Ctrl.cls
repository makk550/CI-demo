/**
 * Class UsageData_Ctrl
 *
 * Used to Dispaly Usage Data and Configuration Data based on Instance Id from Product Instance View
 */
public without sharing class UsageData_Ctrl { 
    
   public ALMConfigurationView__x almConfigView{get;set;}           // Variable to hold AdminConfigView record
   public UsageDataView__x usageViewRecord{get;set;}
   public UsageDataWrapper usageRecord{get;set;}                    // Wrapper class instance to show the usage data instead of exposing the fields directly
   
   @Testvisible String prodinstanceId;                                        // Variable to hold the product instance Id passed on from ProductInstageUI page
   @Testvisible String instanceId;                                            // Variable to hold the instance Id passed on from ProductInstageUI page
    
   public Decimal rallyTotalSeats{set;get;}                               // Variable to hold the rally total seats (Paid + Unpaid)
   public string duValue{set;get;}                                         // Variable to hold The entitlement type value
   List<string> ModulesField;                                              // Variable to hold all the checkbox entities to be displayed on page
   public Map<string,CheckValue> mapModulesF{set;get;}                     // Variable to hold the entities which need to be shown as checked
   public Boolean usageDataAvail{get;set;}                                 // Variable to confirm availability of Usage data record for the instance Id  
   public Boolean configDataAvail{get;set;}                                // Variable to confirm availability of AdminConfigView record for the instance Id
   public String redirectString{get;set;}                                  // Variable to prepare the redirect string ( to go to ProductInstance Lead,Contact Page or Product Instance Opp,Acc Page)
   static Map<String,String> paramMap;                                     // Variable to hold the page parameters
   public String accName{get;set;}                                         // Variable to display the Account name if passed in the parameters
   
   @TestVisible Decimal thirtyDaySeatUtilization;
   @TestVisible Decimal percentSeatsAtRisk;
   @TestVisible Decimal thirtyDayUserUtilization;
   @TestVisible Decimal percentUserProvisioned;
   @TestVisible Decimal percentVacancy;
   @TestVisible String health; 
    
   public class CheckValue{
       public boolean checkV{set;get;}
   }

   public UsageData_Ctrl(){
    
        mapModulesF=new Map<string,CheckValue>();
        ModulesField=new List<string>{'Integration Hub','Utility Billing','Premium Support','SSO','RPM','RSM','RQM','RTT','HP','IBM','IP Restriction','Extension Whitelist','HTML Tabs','Managed Mashups','RIM'};
        
        usageDataAvail = false;
        configDataAvail = false;
       
        usageRecord = new UsageDataWrapper();
        
       // Extracting Page Parameters (Instance Id , Account Name) , Preparing the redirect String
       
        paramMap = ApexPages.currentPage().getParameters();
        
        if(paramMap.get('prod_instance')!=null){
           prodinstanceId = paramMap.get('prod_instance');
        }
        else{
           ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no Product instance ID associated'));
        }
       
        if(paramMap.get('instance')!=null){
           instanceId = paramMap.get('instance');
        }
        else{
           ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no instance ID associated'));
        }
       
        redirectString = '?';
       
        for(String param : paramMap.keySet()){
           if(param != 'prod_instance' && param != 'instance'){
               redirectString += param+'='+paramMap.get(param)+'&';
           }
        }
        if( redirectString.endsWith('&')){
           redirectString = redirectString.removeEnd('&');
        }
       
        if( paramMap.get('accName') != null){
            accName = paramMap.get('accName');  
        }
       
        thirtyDaySeatUtilization = 0.00;
   		percentSeatsAtRisk = 0.00;
   		thirtyDayUserUtilization = 0.00;
   		percentUserProvisioned = 0.00;
   		percentVacancy = 0.00;
   		health = ''; 
  } 
  
    // Method to redirect back to ProductInstance Lead,Contact Page or Product Instance Opp,Acc Page
    public PageReference redirectBack(){
        
        if( ApexPages.currentPage().getParameters().containsKey('emailId')){
            return new PageReference('/apex/ProdInstanceContactLead'+redirectString);        
        }
        else {
            return new PageReference('/apex/ProdInstanceUIOppAcc'+redirectString);        
        }
    }
 
    /**
     * externalData
     *
     * Page Action method which executes on page load and fetch the usage and Configuration Data from extrenal objects.
     */
    public void  externalData(){
     
    if(instanceId!=null){
            
        if(!Test.isRunningTest()){
            for( ALMConfigurationView__x almView : [Select Id,edition__c,paidseats__c,unpaidseats__c,entitlement_type__c,maximumprojects__c,created_date__c,is_active__c,object_id__c ,
                                                    maximumsharedtabs__c,expirationdate__c,projecthierarchyenabled__c,maximumprivatetabs__c,software_type__c,entitlement_end_date__c,entitlement_start_date__c,
                                                    license_type__c,modules__c,product_instance_id__c from ALMConfigurationView__x where instance_id__c =:instanceId 
                                                    order by transaction_start_date__c DESC LIMIT 1]){
                 almConfigView = almView;   
                 configDataAvail = true;                                       
            }
        }
        else {
            almConfigView = returnDummyConfig(instanceId);
        }
        
        
        if(almConfigView != null){  
            
            duValue = almConfigView.entitlement_type__c == 'Paid' ? 'Paid' : 'Trail';
            
            rallyTotalSeats = almConfigView.paidseats__c + almConfigView.unpaidseats__c; 
            
            // Preparing map to display the config data for which checkbox needs to be displayed
            if(! String.isBlank(almConfigView.modules__c) ){
                
                Set<String> checkboxesToDisplay = new Set<String>();
                checkboxesToDisplay.addAll(almConfigView.modules__c.split(','));
                 
                for(string mf:ModulesField){
                    CheckValue chek=new CheckValue();
                    if(checkboxesToDisplay.contains(mf)){
                         chek.checkV=true;
                         mapModulesF.put(mf,chek);
                    }else{
                         chek.checkV=false;
                         mapModulesF.put(mf,chek);
                    }
                }   
            
            }
        }
    }
    if(prodinstanceId != null){    
        
        if(!Test.isRunningTest()){
            for(UsageDataView__x usageRec :  [select Enabled_users__c,Disabled_users__c,paidseats__c,unpaidseats__c,
                                                        Health_Index__c,Daily_active_users__c,Weekly_active_users__c,
                                                        Thirty_day_active_users__c,Monthly_users__c,Sample_date__c,Subscription_Id__c,
                                                        Subscription_OID__c  from UsageDataView__x where product_instance_id__c =:prodinstanceId and Sample_date__c!=null order by Sample_date__c desc Limit 1]){
            	usageViewRecord = usageRec;
                usageDataAvail = true;                                            
            }	                                         
        }
        else{	
            	usageViewRecord = returnDummyUsageRecord(prodInstanceId);
        }
        		
        if( usageViewRecord != null){
        	calculateFormulaFields(usageViewRecord);
                
            usageRecord.enabledUsers = Decimal.valueOf(usageViewRecord.Enabled_users__c);
            usageRecord.percentUserProvisioned = percentUserProvisioned;
            usageRecord.disabledUsers = Decimal.valueOf(usageViewRecord.Disabled_Users__c);
            usageRecord.thirtyDaySeatUtilization = thirtyDaySeatUtilization;
            usageRecord.sampleDate = Date.valueOf(usageViewRecord.Sample_Date__c);
            usageRecord.thirtyDayUserUtilization = thirtyDayUserUtilization;
            usageRecord.dailyActiveUsers = Decimal.valueOf(usageViewRecord.Daily_Active_Users__c);
            usageRecord.percentSeatsAtRisk = percentSeatsAtRisk;
            usageRecord.weeklyActiveUsers = Decimal.valueOf(usageViewRecord.Weekly_Active_Users__c);
            usageRecord.percentVacancy = percentVacancy;
            usageRecord.monthlyActiveUsers = Decimal.valueOf(usageViewRecord.Monthly_Users__c);
            usageRecord.thirtyDayActiveUsers = Decimal.valueOf(usageViewRecord.Thirty_Day_Active_Users__c);
            usageRecord.healthIndex = Decimal.valueOf(usageViewRecord.Health_Index__c);
        	usageRecord.health = health; 	 	  
        }
   }
   }
   
   public class UsageDataWrapper{
   
       public Decimal enabledUsers{get;set;}
       public Double percentUserProvisioned{get;set;}
       public Decimal disabledUsers{get;set;}
       public Double  thirtyDaySeatUtilization{get;set;}
       public Date sampleDate{get;set;}
       public Double thirtyDayUserUtilization{get;set;}
       public Decimal dailyActiveUsers{get;set;}
       public Double percentSeatsAtRisk{get;set;}
       public Decimal weeklyActiveUsers{get;set;}
       public Double percentVacancy{get;set;}
       public Decimal monthlyActiveUsers{get;set;}
       public Decimal thirtyDayActiveUsers{get;set;}
       public Double healthIndex{get;set;}
       public String health{get;set;}
       public String subscriptionId{get;set;}   
       public String subscriptionOId{get;set;}
   }
   
   @Testvisible
    private static ALMConfigurationView__x returnDummyConfig(String instanceId){
        
        ALMConfigurationView__x almconfig = new ALMConfigurationView__x();
        almconfig.edition__c = 'UE';
        almconfig.instance_id__c = instanceId; //'I0040238039000050nXhtzvwX7jQNmozrdRFDbm';
        almconfig.paidseats__c = 34;
        almconfig.unpaidseats__c = 500;
        almconfig.entitlement_type__c = 'Paid';
        almconfig.entitlement_end_date__c = datetime.newInstance(2019, 9, 15, 12, 30, 0);
        almconfig.maximumprojects__c = 1.0;
        almconfig.created_date__c = datetime.newInstance(2016, 9, 15, 12, 30, 0);
        almconfig.maximumsharedtabs__c = 1.0;
        almconfig.expirationdate__c = datetime.newInstance(2019, 9, 15, 12, 30, 0);
        almconfig.projecthierarchyenabled__c = true;
        almconfig.maximumprivatetabs__c = 1.0;
        almconfig.software_type__c = 'Other';
        almconfig.license_type__c = 'Subscription';
        almconfig.modules__c = 'Integration Hub,Utility Billing,SSO,RSM,RQM,RTT,HP,IBM,IP Restriction,Extension Whitelist,HTML Tabs,Managed Mashups';
        
        return almconfig;
    } 
    
   @Testvisible
    private static UsageDataView__x returnDummyUsageRecord(String productInstanceId){
        
        UsageDataView__x usageRecord = new UsageDataView__x();
        usageRecord.Daily_active_users__c = '18';
        usageRecord.Disabled_users__c = '108'; 
        usageRecord.Enabled_users__c = '824';
        usageRecord.Health_Index__c = '7.11';
        usageRecord.Monthly_users__c = '559';
        usageRecord.paidseats__c = 714.0;
        usageRecord.product_id__c = '19462703947';
        usageRecord.product_instance_id__c = productInstanceId;
        usageRecord.Sample_date__c = '2016-09-17';
        usageRecord.subscriptiontype__c = 'Unlimited';
        usageRecord.Subscription_id__c = '55789';
        usageRecord.Subscription_OID__c = '19462703947';
        usageRecord.Thirty_day_active_users__c = '607';
        usageRecord.unpaidseats__c = 2145;
        usageRecord.Weekly_active_users__c = '472';
        
        return usageRecord;
    }
    
    private void calculateFormulaFields(UsageDataView__x usageRecord){
		
		Decimal totalSeats;
		
        If(usageRecord.paidseats__c !=null && usageRecord.unpaidseats__c != null){
			totalSeats  = usageRecord.paidseats__c + usageRecord.unpaidseats__c;
		}
   		
	    if( totalSeats != null && !String.isBlank(usageRecord.Thirty_day_active_users__c) && !String.isBlank(usageRecord.Enabled_Users__c)){
		
			thirtyDaySeatUtilization = totalSeats > 0 ? (Decimal.valueOf(usageRecord.Thirty_day_active_users__c)/totalSeats) : (Decimal.valueOf(usageRecord.Thirty_day_active_users__c)/Decimal.valueOf(usageRecord.Enabled_Users__c));
			
			thirtyDaySeatUtilization = thirtyDaySeatUtilization *100;
			
			thirtyDaySeatUtilization = thirtyDaySeatUtilization.setScale(2);
		}
		
        if(!String.isBlank(usageRecord.Sample_Date__c) && totalSeats != null && !String.isBlank(usageRecord.Thirty_day_active_users__c) && !String.isBlank(usageRecord.Enabled_Users__c)){
		
			if( Date.today().daysBetween(Date.valueOf(usageRecord.Sample_Date__c)) > 30){
			
				percentSeatsAtRisk = 0;
			
			}
			else{
			
				percentSeatsAtRisk = totalSeats > 0 ? (totalSeats - Decimal.valueOf(usageRecord.Thirty_day_active_users__c)) / totalSeats : (Decimal.valueOf(usageRecord.Enabled_Users__c) - Decimal.valueOf(usageRecord.Thirty_day_active_users__c) )/ Decimal.valueOf(usageRecord.Enabled_Users__c);
				
				percentSeatsAtRisk = percentSeatsAtRisk * 100;
				
				percentSeatsAtRisk = percentSeatsAtRisk.setScale(2);
			}
		}
		
		if(!String.isBlank(usageRecord.Sample_Date__c) && !String.isBlank(usageRecord.Thirty_day_active_users__c) && !String.isBlank(usageRecord.Enabled_Users__c)){
			
			thirtyDayUserUtilization = ( Date.today().daysBetween(Date.valueOf(usageRecord.Sample_Date__c)) > 30) ? 0.00 : (Decimal.valueOf(usageRecord.Thirty_day_active_users__c) / Decimal.valueOf(usageRecord.Enabled_Users__c));
			
			thirtyDayUserUtilization = thirtyDayUserUtilization * 100;
			
			thirtyDayUserUtilization = thirtyDayUserUtilization.setScale(2);
		}
		
		if(!String.isBlank(usageRecord.Enabled_Users__c) && totalSeats != null){
			
			percentUserProvisioned = (totalSeats > 0) ? (Decimal.valueOf(usageRecord.Enabled_Users__c)/totalSeats) : 1.00;
			
			percentUserProvisioned = percentUserProvisioned * 100;
			percentUserProvisioned = percentUserProvisioned.setScale(2);
		
			percentVacancy = (totalSeats > 0) ? (totalSeats-Decimal.valueOf(usageRecord.Enabled_Users__c))/totalSeats : 1.00;
			
			percentVacancy = percentVacancy * 100;
			percentVacancy = percentVacancy.setScale(2);
			
		}
		
		
		if(!String.isBlank(usageRecord.Sample_Date__c) != null){
			
			if(Date.today().daysBetween(Date.valueOf(usageRecord.Sample_Date__c)) >= 10){
				health = 'Stagnant';
			}
		    
			else if( usageRecord.Health_Index__c == null){
				health = 'No Data';
			}
			
			else if(Decimal.valueOf(usageRecord.Health_Index__c) >= 6){
				health = 'Green';
			}
			
			else if(Decimal.valueOf(usageRecord.Health_Index__c) >= 4){
				health = 'Yellow';
			}
			
            else {
				health = 'Red';
			}
		}
	}	
}