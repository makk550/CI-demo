@isTest
private class PLR_RetrieveDatesFromPeriod_Test 
{
    private static testMethod void Test_Last4QuartersFirstDate() 
    {
    	PLR_RetrieveDatesFromPeriod quarterDates = new PLR_RetrieveDatesFromPeriod();
            
        // Test Q4    
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(2);
        Date	DateRetrievedFromMethod = quarterDates.Last4QuartersFirstDate();
		System.Assert(Date.newInstance(2017,01,01) == DateRetrievedFromMethod); 
        
        // Test Q1
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(5);
        DateRetrievedFromMethod = quarterDates.Last4QuartersFirstDate();
		System.Assert(Date.newInstance(2017,04,01) == DateRetrievedFromMethod); 
        
        // Test Q2
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(8);
        DateRetrievedFromMethod = quarterDates.Last4QuartersFirstDate();
		System.Assert(Date.newInstance(2017,07,01) == DateRetrievedFromMethod); 
        
        // Test Q3
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(11);
        DateRetrievedFromMethod = quarterDates.Last4QuartersFirstDate();
		System.Assert(Date.newInstance(2017,10,01) == DateRetrievedFromMethod); 
    }

    private static testMethod void Test_LastQuartersFirstDate() 
    {
    	PLR_RetrieveDatesFromPeriod quarterDates = new PLR_RetrieveDatesFromPeriod();

        // Test Q4    
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(2);
        Date DateRetrievedFromMethod = quarterDates.LastQuartersFirstDate();
		System.Assert(Date.newInstance(2017,10,01) == DateRetrievedFromMethod); 
        
        // Test Q1
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(5);
        DateRetrievedFromMethod = quarterDates.LastQuartersFirstDate();
		System.Assert(Date.newInstance(2018,01,01) == DateRetrievedFromMethod); 
        
        // Test Q2
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(8);
        DateRetrievedFromMethod = quarterDates.LastQuartersFirstDate();
		System.Assert(Date.newInstance(2018,04,01) == DateRetrievedFromMethod); 
        
        // Test Q3
		quarterDates.SetYear(2018);
		quarterDates.SetMonth(11);
        DateRetrievedFromMethod = quarterDates.LastQuartersFirstDate();
		System.Assert(Date.newInstance(2018,07,01) == DateRetrievedFromMethod); 
    }
}