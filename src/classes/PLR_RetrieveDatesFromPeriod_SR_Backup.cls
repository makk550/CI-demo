///////////////////////////////////////////////
// Class to compute the quarterly & yearly dates from the PERIOD table
// Author: 	Dorel
// Date:	01/02/2018   
///////////////////////////////////////////////
public class PLR_RetrieveDatesFromPeriod_SR_Backup 
{
	Integer Curr_Year  = 0;
    Integer Curr_month = 0;

    Set<integer> Q4 = new Set<integer>{1,2,3};
    Set<integer> Q1 = new Set<integer>{4,5,6};
    Set<integer> Q2 = new Set<integer>{7,8,9};
    Set<integer> Q3 = new Set<integer>{10,11,12};
    
	public void PLR_RetrieveDatesFromPeriod()
    {
        Curr_Year  = Date.Today().Year();
        Curr_month = Date.Today().month();
    }
    
    public void SetYear(Integer nYear)
    {
        Curr_Year = nYear;
		//System.debug('Curr_Year being set: '+Curr_Year);    
    }
    
    public void SetMonth(Integer nMonth)
    {
        Curr_month = nMonth;
		//System.debug('Curr_month being set: '+Curr_month);    
    }
    
    public Date Last4QuartersFirstDate()
    {
    	Date Last4QtrsFirstDate;

		if ( Curr_Year == 0 )
            Curr_Year  = Date.Today().Year();
        
        
		if ( Curr_month == 0 )
            Curr_month  = Date.Today().month();
        
		//System.debug('Curr_month in Last4 method: '+Curr_month);    
		//System.debug('Curr_Year in Last4 method: '+Curr_Year);
        
        // Is today a day in Q1?
        if(Q1.contains(Curr_month))
		{
        	// Four completed quarters back started with the first day of Q1 of the previous year 
           	Last4QtrsFirstDate=Date.newInstance(Curr_Year-1,04,01);
			//System.debug('Last4Date for Q1: '+Last4QtrsFirstDate);
        }
                
        // Is today a day in Q2?
        else if(Q2.contains(Curr_month))
		{
            // Four completed quarters back started with the first day of Q2 of the previous year 
           	Last4QtrsFirstDate=Date.newInstance(Curr_Year-1,07,01);
			//System.debug('Last4Date for Q2: '+Last4QtrsFirstDate);
        }
        
        // Is today a day in Q3?
        else if(Q3.contains(Curr_month))
		{
            // Four completed quarters back started with the first day of Q3 of the previous year 
            Last4QtrsFirstDate=Date.newInstance(Curr_Year-1,10,01);
			//System.debug('Last4Date for Q3: '+Last4QtrsFirstDate);
        }

		// Only Q4 is left from the current fiscal year ...
        else
        {
            // Four completed quarters back started with the first day of Q4 of the previous year 
           	Last4QtrsFirstDate=Date.newInstance(Curr_Year-1,01,01);
			//System.debug('Last4Date for Q4: '+Last4QtrsFirstDate);
        }
        
		//System.debug('Last4Date returned: '+Last4QtrsFirstDate);
        return Last4QtrsFirstDate;
    }
    
    public Date LastQuartersFirstDate()
    {
    	Date LastQtrFirstDate; 
        
		if ( Curr_Year == 0 )
            Curr_Year  = Date.Today().Year();
        
        
		if ( Curr_month == 0 )
            Curr_month  = Date.Today().month();
        
        if(Q1.contains(Curr_month))
        {
        	// Q1 - - CURR YEAR
           	LastQtrFirstDate=Date.newInstance(Curr_Year,01,01);
			//System.debug('LastQDate for Q1: '+LastQtrFirstDate);
        }
        else if(Q2.contains(Curr_month))
        {
            // Q2 - curr year
            LastQtrFirstDate=Date.newInstance(Curr_Year,04,01);
			//System.debug('LastQDate for Q2: '+LastQtrFirstDate);
        }
        else if(Q3.contains(Curr_month))
        {
            // Q3  -curr year
            LastQtrFirstDate=Date.newInstance(Curr_Year,07,01);
			System.debug('LastQDate for Q3: '+LastQtrFirstDate);
        }
        else 
        {
            // Q4 -curr year-1 if(Q4.contains(Curr_month))
            LastQtrFirstDate=Date.newInstance(Curr_Year-1,10,01);
			//System.debug('LastQDate for Q4: '+LastQtrFirstDate);
        }
        //System.debug('LastQtrFirstDate-------'+LastQtrFirstDate);
        
        return LastQtrFirstDate;
    }
}