global class ScheduledCBRCertificationsJOB implements Schedulable {
	global void execute(SchedulableContext sc) {
		System.enqueueJob(new ScheduledCBRCertificationsQueuable()); 
	}
}