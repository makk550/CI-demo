public with sharing class SplitStatusController {
	public class SplitStatusLine{
		public Integer cnt          {get;set;}
		public String taqReason     {get;set;} 
		public String splitReason   {get;set;} 
		public String expl          {get;set;} 
		public List<OpportunityTeamMember> samples {get;set;}
		public SplitStatusLine()
		{
			this.samples = new List<OpportunityTeamMember>(); 
		} 
	} 
	
	public static String JOB1_CLASS_NAME = 'SplitPreProcessBatch'; 
	public static String JOB2_CLASS_NAME = 'SplitProcessorBatch'; 

	public AsyncApexJob job1 {get;set;}
	public AsyncApexJob job2 {get;set;}
	public List<SplitStatusLine> lines {get;set;} 

	public SplitStatusController()
	{		
		this.lines = new List<SplitStatusLine>();		
	}
	public void loadAll()
	{
		loadJobs();
		loadLines();
	}
	
	public String getETA1()
	{
		return getETA(this.job1).format();
	}
	
	public String getETA2()
	{
		return getETA(this.job2).format();
	}
	
	public Datetime getETA(AsyncApexJob job)
	{
		if(job == null || job.CompletedDate != null || job.JobItemsProcessed == null || job.JobItemsProcessed == 0 || job.TotalJobItems == null || job.TotalJobItems == 0) return System.now();		
		Long msPerBatch = (System.now().getTime() - job.CreatedDate.getTime()) / job.JobItemsProcessed;
		Long itemsRemaining = job.TotalJobItems - job.JobItemsProcessed;				
		Long minutesRemaining = (itemsRemaining * msPerBatch) / (60 * 1000);		
		return System.now().addMinutes(Integer.valueOf(minutesRemaining));		
	}
	
	public void loadJobs()
	{
		this.job1 = null;
		this.job2 = null;
        for(AsyncApexJob j: [Select Id, 
                                    Status, 
                                    ExtendedStatus,
                                    NumberOfErrors, 
                                    JobItemsProcessed, 
                                    CompletedDate, 
                                    CreatedDate, 
                                    TotalJobItems, 
                                    CreatedBy.Email, 
                                    CreatedById, 
                                    ApexClass.Name                                  
                          From AsyncApexJob 
                          Where JobType = 'BatchApex'
                          and (ApexClass.Name =: JOB1_CLASS_NAME or ApexClass.Name =: JOB2_CLASS_NAME) 
                          order by CreatedDate desc
                          LIMIT 10])
        {
        	if(j.ApexClass.Name == JOB1_CLASS_NAME)
        	{
        		if(this.job1 == null || this.job1.CreatedDate < j.CreatedDate)
        		{
        			this.job1 = j;
        		}
        	}
        	else if(j.ApexClass.Name == JOB2_CLASS_NAME)
        	{
        		if(this.job2 == null || this.job2.CreatedDate < j.CreatedDate)
        		{
        			this.job2 = j;
        		}
        	}
        }
	}
	
	public void loadLines()
	{
		try
		{
			this.lines.clear();
			String soql = 'SELECT COUNT(ID) cnt, TAQWhy__c, split0__LastSplitReason__c FROM OpportunityTeamMember WHERE LastModifiedDate >= LAST_YEAR GROUP BY TAQWhy__c, split0__LastSplitReason__c'; 
			for(AggregateResult ar: Database.query(soql))
			{
				SplitStatusLine line = new SplitStatusLine();
				line.cnt = Integer.valueOf(ar.get('cnt'));  									
				line.taqReason = String.valueOf(ar.get('TAQWhy__c'));			
				line.splitReason = String.valueOf(ar.get('split0__LastSplitReason__c'));
				line.expl    = explain(line.taqReason, line.splitReason);
				this.lines.add(line);
			}
			sortLines();
			loadAllSamples();
			
		}
		catch(Exception e)
		{
			ApexPages.addMessages(e);
		}
	}
	
	public void sortLines()
	{
		Boolean doMore = true;
    	while (doMore) 
    	{
        	doMore = false;
        	for (Integer i = 0; i < this.lines.size() - 1; i++) 
        	{
            	if (this.lines[i].cnt < this.lines[i + 1].cnt) 
            	{
               		SplitStatusLine temp = this.lines[i];  
               		this.lines[i] = this.lines[i+1];  
               		this.lines[i+1] = temp;
               		doMore = true; 
            	}
        	}
    	} 		
	}
	
	public void loadAllSamples()
	{
    	for (Integer i = 0; i < this.lines.size() && i < 50; i++) 
    	{
    		loadOneSetOfSamples(this.lines[i]);
    	}
	}
	
	public void loadOneSetOfSamples(SplitStatusLine line)
	{
		
		line.samples.clear();
		for(OpportunityTeamMember otm: [SELECT id, User.Name, LastModifiedDate FROM OpportunityTeamMember WHERE LastModifiedDate >= LAST_YEAR
											AND TAQWhy__c =: line.taqReason 
											AND split0__LastSplitReason__c =: line.splitReason
											ORDER BY LastModifiedDate desc
											LIMIT 5])
		{
			line.samples.add(otm);
		}			           		
	}
	
	public void startFirstBatch()
	{
		SplitPreProcessBatch b = new SplitPreProcessBatch();
		if(!Test.isRunningTest()) Database.executeBatch(b, 200);
		this.job1 = null;		
	}
	
	public Boolean getRenderButtons()
	{
		return (job1 == null && job2 == null) || (job1 != null && job2 != null && job1.Status != 'Processing' && job2.Status != 'Processing' && job1.Status != 'Preparing' && job2.Status != 'Preparing') ;		
	}
	
	public void startSecondBatch()
	{
		Type t = Type.forName('split0.SplitProcessorBatch');		
		Database.Batchable<sObject> b = (Database.Batchable<sObject>)t.newInstance();
		if(!Test.isRunningTest()) Database.executeBatch(b, 50);
		this.job2 = null;		
		
	}
	
	public String explainSplitReason(String splitReason)
	{
		if(splitReason == null) 
			return ' Split batch did not update these records, maybe opportunity has no products';								
		if(splitReason.contains('(1)') || splitReason.startsWith('1')) 
			return 'Split batch updated these records because LastSplitDate field was empty.';
		if(splitReason.contains('(2)') || splitReason.startsWith('2')) 
			return 'Split batch updated these records because record was modified after LastSplitDate.';
		if(splitReason.contains('(3)') || splitReason.startsWith('3')) 
			return 'Split batch updated these records because OLI (product lines) were modified after LastSplitDate.';
		if(splitReason.contains('(4)') || splitReason.startsWith('4')) 
			return 'Split batch updated these records because Product records were modified after LastSplitDate.';
		if(splitReason.contains('(5)') || splitReason.startsWith('5')) 
			return 'Split batch updated these records because Opportunity was changed after LastSplitDate.';
			
		return null;
	}
	
	public String explain(String taqReason, String splitReason)
	{
		if(taqReason == null)
		{
			String r1 = 'TAQ fields were not updated because they were populated before and nothing has changed after that. ';			
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(0)') || taqReason.startsWith('0'))
		{
			return explainSplitReason(splitReason);
		}
		else
		if(taqReason.contains('(1)') || taqReason.startsWith('1'))
		{
			String r1 = 'TAQ fields updated because LastSplitDate field was empty which caused TAQ fields update. ';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(2)') || taqReason.startsWith('2'))
		{
			String r1 = 'OTM Records were manually modified after LastSplitDate which caused TAQ fields update. ';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(3)') || taqReason.startsWith('3'))
		{
			String r1 = 'Opportunity was changed after LastSplitDate which caused TAQ fields update. ';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(4)') || taqReason.startsWith('4'))
		{
			String r1 = 'TAQ ATA was not latest record, TAQ batch attempted to update TAQ ATA field. ';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(5)') || taqReason.startsWith('5'))
		{
			String r1 = 'TAQ OA was not latest record, TAQ batch attempted to update TAQ OA field. ';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(6)') || taqReason.startsWith('6'))
		{
			String r1 = 'TAQ ATA was not populated, TAQ batch attempted to populate TAQ ATA field.';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		else
		if(taqReason.contains('(7)') || taqReason.startsWith('7'))
		{
			String r1 = 'TAQ OA was not populated, TAQ batch attempted to populate TAQ OA field.';						
			String r2 = explainSplitReason(splitReason);
			if(r2 != null) return r1 + r2;
		}
		
		return 'N/A';
	}
}