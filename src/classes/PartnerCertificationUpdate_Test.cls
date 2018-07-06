@istest
class PartnerCertificationUpdate_Test 
{
    static testmethod void testApexJobPartnerCertificationUpdate() 
    {
		Test.startTest();

        system.debug('Before system.schedule');
        
	    // Schedule the test job
	    String jobId = System.schedule('testApexJobPartnerCertificationUpdate',
	    								PartnerCertificationUpdate.CRON_EXP,
										new PartnerCertificationUpdate());

        system.debug('After system.schedule');

        // Get the information from the CronTrigger API object
	    CronTrigger ct = [	SELECT Id, CronExpression, TimesTriggered, NextFireTime
	         				FROM CronTrigger 
                          	WHERE id = :jobId];

        system.debug(ct.CronExpression);

	    // Verify the expressions are the same
	    System.assertEquals(PartnerCertificationUpdate.CRON_EXP, ct.CronExpression);

	   Test.stopTest();

        system.debug('After stop test');
    }
}