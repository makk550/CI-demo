public class EscalationsReportExtension{
public String currentRecordId {get;set;}
public String parameterValue {get;set;}
public DateTime date_time { get; set; } //property that reads the datetime value from component attribute tag
public String defined_format { get; set;}
public String datetimeVal {get;set;}
public String usertimeZone {get; set;}
public Escalation__c Esc{get;set;}
 
    public EscalationsReportExtension(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
 //       returnPage = ApexPages.currentPage().getParameters().get('retURL');
        list<Escalation__c> Esc = [select id ,Escalation_Number__c, escalation_start_date__c from Escalation__c where id =: currentRecordId ];
        date_time = Esc[0].escalation_start_date__c;
        parameterValue = ApexPages.CurrentPage().getparameters().get('nameParam');
        datetimeVal=getFormattedDatetime();
        TimeZOne tz = UserInfo.getTimeZone();
        usertimeZone = tz.getDisplayName();
        datetimeVal= datetimeVal+' '+usertimeZone;
    }
    public PageReference returnToEscalation() {
        PageReference pr = new PageReference('/' + currentRecordId);
        pr.setRedirect(true);
        return pr;
    }

public String getFormattedDatetime()
{
       if (date_time == null) 
         {
          return ''; 
          }
        else { 

            if (defined_format == null) {
               return date_time.format(); //return the full date/time in user's locale and time zone
            }
          else 
             { 
             return date_time.format(defined_format,'IST');  //Specify Time zone like IST,CST
            }
        }

        }

}