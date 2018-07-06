/*
The class is used to get all the Partner accounts that has EAI errors and submits the records to EAI

From Trigger :

	There has to be check whether the Schedule job is running
	
Schedule: (Initial Run)
Sch_Batch_ResendPAccountForEAIMDMSync temp = new Sch_Batch_ResendPAccountForEAIMDMSync;
Datetime dt = Datetime.now().addMinutes(5);
String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
System.Schedule('temp',timeForScheduler,temp);
 

*/

global class Sch_Batch_ResendPAccountForEAIMDMSync implements Schedulable {
	
	global void execute(SchedulableContext sc)
	{
		PartnerProfileUtil.executePartnerProfileSync('TAQ_Account__c','Sch_Batch_ResendPAccountForEAIMDMSync');
	}

}