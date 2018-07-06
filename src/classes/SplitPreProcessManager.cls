public with sharing class SplitPreProcessManager {	
	public class OTMModel {
		public OpportunityTeamMember otm;
		public String reasonForUpdate;
		public String additionalInfo;

		public Datetime prevUpdate;
		public Datetime prevTAQ;
		public Datetime prevSplit;

		public Id oldTAQATAId;
		public Id oldTAQOAId;
	
		public Id newTAQATAId;
		public Id newTAQOAId;				

		public void appendDate(String label, DateTime dt)
		{
			if(dt != null)
			{
				if(this.additionalInfo == null) this.additionalInfo = ''; 				
				this.additionalInfo = this.additionalInfo + ' ' + label + ':' + dt.format();
			}
		}
	}
	
	public Map<Id, OTMModel> otmMap = new Map<Id, OTMModel>();
	
	public Map<String, List<Id>> pmfKeyMap = new Map<String, List<Id>>();
	public Set<String> pmfKeys = new Set<String>();
	public Map<String, List<Id>> acctPmfKeyMap = new Map<String, List<Id>>();
	public Set<Id> acctIds = new Set<Id>(); 
	
	
	
	public void loadAll(List<OpportunityTeamMember> otms)
	{
		loadOtmMap(otms);
		if(this.otmMap.isEmpty()) return;
		loadPMFKeyMap();
		loadAcctPMFKeyMap();
		loadAcctIds();
		loadTAQATA();
		loadTAQOA();
	}
	
	public void loadOtmMap(List<OpportunityTeamMember> otms)
	{
		this.otmMap.clear();
		Split_Settings_Pre__c stgs = Split_Settings_Pre__c.getInstance();
		Boolean x0 = stgs != null && stgs.X0_TotalUpdate__c;				
		Boolean x1 = stgs == null ? true : stgs.X1_NeverUpdated__c;		
		Boolean x2 = stgs == null ? true : stgs.X2_OTM_Updated__c;		
		Boolean x3 = stgs == null ? true : stgs.X3_Opportunity_Updated__c;		
		Boolean x4 = stgs == null ? true : stgs.X4_TAQ_AA_is_not_latest_record__c;		
		Boolean x5 = stgs == null ? true : stgs.X5_TAQ_OA_is_not_latest_record__c;		
		Boolean x6 = stgs == null ? true : stgs.X6_TAQATA_is_not_defined__c;		
		Boolean x7 = stgs == null ? true : stgs.X7_TAQOA_is_not_defined__c;		
		for(OpportunityTeamMember otm: otms)
		{
			if(otm.User.PMFKey__c == null) continue;			
			Boolean y1 = x1 && otm.split0__LastSplitDate__c == null && otm.TAQWhen__c == null;
			Boolean y2 = x2 && (otm.split0__LastSplitDate__c == null || otm.LastModifiedDate > otm.split0__LastSplitDate__c.addMinutes(10))
									&&
							   (otm.TAQWhen__c == null || otm.LastModifiedDate > otm.TAQWhen__c.addMinutes(10));
			Boolean y3 = x3 && otm.split0__LastSplitDate__c != null && otm.Opportunity.LastModifiedDate > otm.split0__LastSplitDate__c.addMinutes(10);
			Boolean y4 = x4 && otm.TAQATA__c != null && otm.TAQATA__r.TAQ_Account_Approved__r.Is_Latest_Record__c == false;
			Boolean y5 = x5 && otm.TAQOA__c != null && otm.TAQOA__r.Is_Latest_Record__c == false;
			Boolean y6 = x6 && otm.TAQATA__c == null;
			Boolean y7 = x7 && otm.TAQOA__c == null;
			if(x0 || y1 || y2 || y3 || y4 || y5 || y6 || y7)
			{
				OTMModel otmm = new OTMModel();
				otmm.otm = otm;
				otmm.additionalInfo = otm.LastModifiedBy.Name;
				otmm.appendDate('LMD', otm.LastModifiedDate);
				otmm.appendDate('TAQ', otm.TAQWhen__c);
				otmm.appendDate('Split', otm.split0__LastSplitDate__c);
				otmm.prevUpdate = otm.LastModifiedDate;
				otmm.prevTAQ = otm.TAQWhen__c;
				otmm.prevSplit = otm.split0__LastSplitDate__c;				
				otmm.oldTAQATAId = otm.TAQATA__c;
				otmm.oldTAQOAId = otm.TAQOA__c;
				otmm.reasonForUpdate = 'N/A';
				
				if(x0)
					otmm.reasonForUpdate = '(0)Initialization';
				else if(y1) 
					otmm.reasonForUpdate = '(1)First time processing. LastSplitDate and TAQWhen both are empty';
				else if(y2)
					otmm.reasonForUpdate = '(2)OTM record modified after LastSplitDate';
				else if(y3)
				{ 
					otmm.reasonForUpdate = '(3)Opportunity modified after LastSplitDate';
					otmm.appendDate('Opp LastModifiedDate', otm.Opportunity.LastModifiedDate);
				}
				else if(y4)
					otmm.reasonForUpdate = '(4)TAQ Account Team Approved is not Latest Record';
				else if(y5)
					otmm.reasonForUpdate = '(5)TAQ Org Approved is not Latest Record';
				else if(y6)
					otmm.reasonForUpdate = '(6)TAQ Account Team Approved is not assigned';
				else if(y7)
					otmm.reasonForUpdate = '(7)TAQ Org Approved is not assigned';
				
				otmMap.put(otm.Id, otmm);
			}
		}						
	}
	
	
	public void loadPMFKeyMap()
	{
		this.pmfKeyMap.clear();
		this.pmfKeys.clear();
		for(Id otmId: this.otmMap.keySet())
		{
			OTMModel otmm = this.otmMap.get(otmId);
			this.pmfKeys.add(otmm.otm.User.PMFKey__c);			 
			String sKey = ((String)otmm.otm.User.PMFKey__c).toLowerCase();
			 
			List<Id> otmLst = this.pmfKeyMap.get(sKey);
			if(otmLst == null)
			{
				otmLst = new List<Id>(); 	
				this.pmfKeyMap.put(sKey, otmLst);
			}
			otmLst.add(otmm.otm.Id);
		}
	}
	  
	  
	public void loadAcctPMFKeyMap()
	{
		this.acctPmfKeyMap.clear();
		for(Id otmId: this.otmMap.keySet())
		{
			OTMModel otmm = this.otmMap.get(otmId);			 
			String sKey = (String)otmm.otm.Opportunity.AccountId + ((String)otmm.otm.User.PMFKey__c).toLowerCase();			 
			List<Id> otmLst = this.acctPmfKeyMap.get(sKey);
			if(otmLst == null)
			{
				otmLst = new List<Id>(); 	
				this.acctPmfKeyMap.put(sKey, otmLst);
			}
			otmLst.add(otmm.otm.Id);
		}
	}
	
	public void loadAcctIds()
	{
		this.acctIds.clear();
		for(Id otmId: this.otmMap.keySet())
		{
			OTMModel otmm = this.otmMap.get(otmId); 
			this.acctIds.add(otmm.otm.Opportunity.AccountId);		
		}
	}

	public void loadTAQATA()
	{
		for(TAQ_Account_Team_Approved__c ata: [Select TAQ_Account_Approved__r.Approved_Date_Time__c, 
													TAQ_Account_Approved__r.Approved_By__c, 
													TAQ_Account_Approved__r.Approval_Process_Status__c,
													TAQ_Account_Approved__r.LastActivityDate, 
													TAQ_Account_Approved__r.LastModifiedDate, 
													TAQ_Account_Approved__c, 
													TAQ_Account_Approved__r.TAQ_Account__c,
													TAQ_Account_Approved__r.TAQ_Account__r.Id,
													TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c,													
													PMFKey__c, 
													Name, 
													LastModifiedDate, 
													Is_Latest_Record__c, 
													Id 
				From TAQ_Account_Team_Approved__c
				WHERE 
				TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in: this.acctIds 
				AND 
				TAQ_Account_Approved__r.Is_Latest_Record__c = true
				AND 
				TAQ_Account_Approved__r.Request_Type__c != 'Account Merge'
				])
		{
			if(ata.PMFKey__c == null) continue;
			Id acctId = ata.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c;
			if(acctIds.contains(acctId))
			{
				String sKey = (String)acctId + ((String)ata.PMFKey__c).toLowerCase();			
				List<Id> otmLst = acctPmfKeyMap.get(sKey);
				if(otmLst != null)
				{
					for(Id otmId: otmLst)
					{						
						OTMModel otmm = otmMap.get(otmId);						
						otmm.newTAQATAId = ata.Id;
					}
				}
			}
		}		
	}


	public void loadTAQOA()
	{
		for(TAQ_Organization_Approved__c oa: [Select Id, PMFKey__c, Is_Latest_Record__c, Position_Id__c, Employee_Status__c 
												From 
												TAQ_Organization_Approved__c
												WHERE
												Is_Latest_Record__c = true 
												AND 
												PMFKey__c in: this.pmfKeys
												AND
												(
												    Employee_Status__c = 'Active'
												    OR 
												    Employee_Status__c = 'Leave of Absence'
												)
												])
		{
			if(oa.PMFKey__c == null) continue;
			Boolean isClosed = oa.Position_Id__c != null && ((String)oa.Position_Id__c).toLowerCase().contains('closed');
			if(!isClosed)
			{
				List<Id> otmLst = pmfKeyMap.get(((String)oa.PMFKey__c).toLowerCase());
				if(otmLst != null)
				{
					for(Id otmId: otmLst)
					{						
						OTMModel otmm = otmMap.get(otmId);						
						otmm.newTAQOAId = oa.Id;
					}
				}
			}
		}				
	}
	
	public void saveChangedRecords()
	{
		Split_Settings_Pre__c stgs = Split_Settings_Pre__c.getInstance();
		Boolean x0 = stgs != null && stgs.X0_TotalUpdate__c;				
		List<OpportunityTeamMember> otms2save = new List<OpportunityTeamMember>(); 
		for(Id otmId: this.otmMap.keySet())
		{
			OTMModel otmm = this.otmMap.get(otmId);
			if(otmm.oldTAQATAId != otmm.newTAQATAId || otmm.oldTAQOAId != otmm.newTAQOAId || x0)
			{
				if(otmm.oldTAQATAId != otmm.newTAQATAId)
					otmm.additionalInfo = otmm.additionalInfo + ' old TAQATA: ' + otmm.oldTAQATAId;
				if(otmm.oldTAQOAId != otmm.newTAQOAId)
					otmm.additionalInfo = otmm.additionalInfo + ' old TAQOA: ' + otmm.oldTAQOAId;

				otmm.otm.TAQATA__c = otmm.newTAQATAId;
				otmm.otm.TAQOA__c  = otmm.newTAQOAId;
				otmm.otm.TAQWhy__c = otmm.reasonForUpdate;
				otmm.otm.TAQAddl__c  = otmm.additionalInfo; 												
				otmm.otm.TAQWhen__c = System.now();
				otms2save.add(otmm.otm);
			}
		}
		
		if(!otms2save.isEmpty())
		{
			update otms2save;
		}		
	}
	
}