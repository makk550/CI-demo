public class VOppPipelineReportHelper_3_0CoreHQAging 
{
	public String[] selectedRegion = new String[]{}; 
    public String selectedDate = 'select';
    public String[] selectedArea = new String[]{};
    public String[] selectedTerritory = new String[]{};
    public List<OppPipelineBean> oppPipeLineBeanForAvgAgeRegion;
    public List<OppPipelineBean> oppPipeLineBeanForAvgAgeBU;
    public List<OppPipelineBean> oppPipeLineBeanForAvgPriceRegion;
    public List<OppPipelineBean> oppPipeLineBeanForAvgPriceBU;
    public String selectedField = 'select';
    public String selectedColumn = '';
    public String monthFirstPull = '';
    Boolean showDataTable = false;
    Boolean showRegionList = false;
    Boolean showAreaList = false;
    Boolean showTerritoryList = false;
    Map<String,String> ncvbuMap = new Map<String,String>();    
    Map<String,Decimal> datemap = new Map<String,Decimal>();
    Map<String,Decimal> bucycledaysmap = new Map<String,Decimal>();
    Map<Decimal,DateTime> oppagingmap = new Map<Decimal,DateTime>();
    Map<Integer,String> datedropdownmap = new Map<Integer,String>();
    
    //Getter-Setter Methods For all  variables
    
    public String[] getSelectedRegion()
    {
        return this.selectedRegion;
    }
    public void setSelectedRegion(String[] selectedRegion)
    {
        System.debug('Selected Region :'+selectedRegion);
        this.selectedRegion = selectedRegion;
    }
    

    public String[] getSelectedTerritory()
    {
        return this.selectedTerritory;
    }
    public void setSelectedTerritory(String[] selectedTerritory)
    {
        System.debug('selectedTerritory :'+selectedTerritory);
        this.selectedTerritory = selectedTerritory;
    }

    
    public String getSelectedDate()
    {
        return this.selectedDate;
    }
    public void setSelectedDate(String selectedDate)
    {
        System.debug('Selected Date :'+selectedDate);
        this.selectedDate = selectedDate;
    }
    
    
    public String[] getSelectedArea()
    {
 
       return this.selectedArea;
    }
    public void setSelectedArea(String[] selectedArea)
    {
        System.debug('selectedArea :'+selectedArea);
        this.selectedArea = selectedArea;
    }
    
    public String getSelectedField()
    {
        return this.selectedField;
    }
    public void setSelectedField(String selectedField)
    {
        System.debug('selectedField :'+selectedField);
        this.selectedField = selectedField;
    }

    //End Getters-Setters
    
    private String convert(Long l)
    {
        String str = String.valueOf(l);
        String result ='';
        for (Integer i= str.length() ; i >= 1  ; i = i-3 )
        {
            if(i-3 >= 1)
            {
                String subStr = ',' + str.subString((i-3),i);
                result = subStr + result ;
            }
            else
            {
                String subStr =  str.subString(0,i);
                result = subStr + result ;
            }
        }
        return result;
    }
    private Decimal convertthousands(Decimal d)
    {
        Decimal dec = d.divide(1000,2,System.RoundingMode.UP); 
        return dec;
    }
    public List<SelectOption> getDateItems() 
    {
        String sdt;
        Integer year = 0;
        Integer month = 0;
        Integer day = 0;
        Datetime dt;
        Integer count = 0;
        List<SelectOption> options = new List<SelectOption>();
        datemap.clear();
        oppagingmap.clear();
        for(List<Pipeline_Report__c> oppDateList: [Select p.Data_Pull_Date__c From Pipeline_Report__c p Where p.Report_Name__c = 'DatePull' Order by p.Data_Pull_Date__c desc])       
        {
           for(Pipeline_Report__c obj : oppDateList)
           {
           	   sdt = (obj.Data_Pull_Date__c.format()).substring(0,2)+(obj.Data_Pull_Date__c.format()).substring(3,6)+(obj.Data_Pull_Date__c.format()).substring(7);
           	   year = integer.valueOf((sdt).substring(0,4));
           	   month = integer.valueOf((sdt).substring(4,6));
           	   day = integer.valueOf((sdt).substring(6));
           	   
               dt =  datetime.newinstance(year,month,day);
               datemap.put(dt.format('EEE, MMM d, yy'),obj.Data_Pull_Date__c);
               oppagingmap.put(month,dt);
               datedropdownmap.put(count,dt.format('EEE, MMM d, yy'));
			   count++;
           }
        }
        options.add(new SelectOption('-','Select'));
        for(Integer ct: datedropdownmap.keySet())
        {
            options.add(new SelectOption(datedropdownmap.get(ct),datedropdownmap.get(ct)));   
        }    
        return options;
    }
    public List<SelectOption> getFieldItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('select','Select'));
        options.add(new SelectOption('Region','Region'));
        options.add(new SelectOption('Area','Sales Area'));
        options.add(new SelectOption('Territory','Territory/Country'));
        return options;
    }
    public List<SelectOption> getRegionItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('select','Select'));
        options.add(new SelectOption('NA','NA'));
        options.add(new SelectOption('EMEA','EMEA'));
        options.add(new SelectOption('APJ','APJ'));
        options.add(new SelectOption('LA','LA'));
        return options;
    }
    public List<SelectOption> getAreaItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult F = Account.Sales_Area__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        options.add(new SelectOption('select','Select'));
        for(Integer i=0 ; i < P.size() ; i++)
        { 
            options.add(new SelectOption(P[i].getValue(),P[i].getValue()));
        }

        return options;
    }
    public List<SelectOption> getTerritoryItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult F = Account.Sales_Region__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
         options.add(new SelectOption('select','Select'));
        for(Integer i=0 ; i < P.size() ; i++)
        { 
            options.add(new SelectOption(P[i].getValue(),P[i].getValue()));
        }

        return options;
    }
    public PageReference populateFieldList()
    {
    VOppPipelineMainHelper.index = 5;

        if(selectedField == 'Region')
        {
            showRegionList = true;
            showAreaList = false;
            showTerritoryList = false;

        }
        if(selectedField == 'Area')
        {
            showRegionList = false;
            showAreaList = true;
            showTerritoryList = false;

        }
        if(selectedField == 'Territory')
        {
            showRegionList = false;
            showAreaList = false;
            showTerritoryList = true;

        }
        return null;
    }    
    private String[] convertSetToArray()
    {
        String[] keysncvbu = new String[ncvbuMap.size()];
        Integer counter = 0;
        for(String ncvName: ncvbuMap.keySet())
        {
            keysncvbu[counter] = ncvName; 
            counter ++ ;
        }
        return keysncvbu;
    }
    private String[] sortArray(String[] str)
    {
        String[] strNew = str ;
        String temp ;
        for(Integer i=0; i< strNew.size(); i++)
        {
            for(Integer j=i+1; j<strNew.size(); j++)
            {
                Integer k = strNew[i].compareTo(strNew[j]);
                if (k>0)
                {
                    temp = strNew[i];
                    strNew[i] = strNew[j];
                    strNew[j] = temp;
                }
            }
        }
        return strNew;
    }
    
    //Start "3.5 Region Aging by Milestone - Avg Oppty Age Days and Total Price" Report Calculation
    //Start Group by Region
    private List<OppPipelineBean> processRegionAvgAgePriceData(List<List<Pipeline_Report__c>> oppMasterList, String cal)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
        Decimal totalSM30Pipelines =0;
        Decimal totalSM30CountPipelines =0;
        Decimal totalSM50Pipelines =0;
        Decimal totalSM50CountPipelines =0;
        Decimal totalSM70Pipelines =0;
        Decimal totalSM70CountPipelines =0;
        Decimal totalSM90Pipelines =0;
        Decimal totalSM90CountPipelines =0;
        Decimal totalSMWonPipelines =0;
        Decimal totalSMWonCountPipelines =0;
        Integer count =0;
        Integer rowcount =0;

        //Clears the old Map
        ncvbuMap.clear();        
        
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
            	Pipeline_Report__c obj =  oppBuList[j];
                ncvbuMap.put((obj.Business_Unit__c+'+'+obj.NCV_Driver_6__c).toLowerCase(),obj.Business_Unit__c);
                
                String currentField ;
                if(selectedField == 'Region')
                {   currentField = obj.Region__c;}
                else if(selectedField == 'Area')
                {   currentField = obj.Area__c; }
                else if(selectedField == 'Territory')
                {   currentField = obj.Territory_Country__c; }
                if(currentField !=  previousField)
                {
                    if(count == 0)
                    {
                        rowcount = 1;
                        totalSM30Pipelines = totalSM30Pipelines + obj.SM_30__c;
                        totalSM50Pipelines = totalSM50Pipelines + obj.SM_50__c;
                        totalSM70Pipelines = totalSM70Pipelines + obj.SM_70__c;
                        totalSM90Pipelines = totalSM90Pipelines + obj.SM_90__c;
                        totalSMWonPipelines = totalSMWonPipelines + obj.SM_Won__c;
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                        if(cal == 'avg')
                		{
                    		//Start Get the Count Values of 3.5.7
                    	    Decimal data_pull_date = datemap.get(selectedDate);
                    		if(selectedField == 'Region')
                    		{
	             				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :previousField order by p.Region__c])
					            {
					                for(Pipeline_Report__c objCount : oppPipeLineListCount)
					            	{
				                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
				                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
				                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
				                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
				                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
					            	}
					            }
				            }
       						if(selectedField == 'Area')
                    		{
	             				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c = :previousField order by p.Area__c])
					            {
					                for(Pipeline_Report__c objCount : oppPipeLineListCount)
					            	{
				                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
				                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
				                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
				                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
				                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
					            	}
					            }
				            }
				            if(selectedField == 'Territory')
                    		{
	             				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c = :previousField order by p.Territory_Country__c])
					            {
					                for(Pipeline_Report__c objCount : oppPipeLineListCount)
					            	{
				                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
				                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
				                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
				                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
				                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
					            	}
					            }
				            }
                    		//End Get the Count Values of 3.5.7
							if(totalSM30CountPipelines == 0)
								bean.setTotalSM30Pipelines('0');	
							else
								bean.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
		                    if(totalSM50CountPipelines == 0)
								bean.setTotalSM50Pipelines('0');	
							else
								bean.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
							if(totalSM70CountPipelines == 0)
								bean.setTotalSM70Pipelines('0');	
							else
								bean.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
							if(totalSM90CountPipelines == 0)
								bean.setTotalSM90Pipelines('0');	
							else
								bean.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
							if(totalSMWonCountPipelines == 0)
								bean.setTotalSMWonPipelines('0');	
							else
								bean.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
		            	}
            			else
            			{
		                    bean.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
		                    bean.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
		                    bean.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
		                    bean.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
		                    bean.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));		                    
		            	}
                        oppPipelineBeanList.add(bean);
                    
                        totalSM30Pipelines =0;
				        totalSM30CountPipelines =0;
				        totalSM50Pipelines =0;
				        totalSM50CountPipelines =0;
				        totalSM70Pipelines =0;
				        totalSM70CountPipelines =0;
				        totalSM90Pipelines =0;
				        totalSM90CountPipelines =0;
				        totalSMWonPipelines =0;
				        totalSMWonCountPipelines =0;
                        
                        totalSM30Pipelines = totalSM30Pipelines + obj.SM_30__c;
                        totalSM50Pipelines = totalSM50Pipelines + obj.SM_50__c;
                        totalSM70Pipelines = totalSM70Pipelines + obj.SM_70__c;
                        totalSM90Pipelines = totalSM90Pipelines + obj.SM_90__c;
                        totalSMWonPipelines = totalSMWonPipelines + obj.SM_Won__c;
                        
                    }
                    count ++;
                }
                else
                {
                    totalSM30Pipelines = totalSM30Pipelines + obj.SM_30__c;
                    totalSM50Pipelines = totalSM50Pipelines + obj.SM_50__c;
                    totalSM70Pipelines = totalSM70Pipelines + obj.SM_70__c;
                    totalSM90Pipelines = totalSM90Pipelines + obj.SM_90__c;
                    totalSMWonPipelines = totalSMWonPipelines + obj.SM_Won__c;
                                        
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
            		if(cal == 'avg')
            		{
                		//Start Get the Count Values of 3.5.7
                	    Decimal data_pull_date = datemap.get(selectedDate);
                		if(selectedField == 'Region')
                		{
             				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :currentField order by p.Region__c])
				            {
				                for(Pipeline_Report__c objCount : oppPipeLineListCount)
				            	{
			                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
			                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
			                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
			                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
			                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
				            	}
				            }
			            }
   						if(selectedField == 'Area')
                		{
             				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c = :currentField order by p.Area__c])
				            {
				                for(Pipeline_Report__c objCount : oppPipeLineListCount)
				            	{
			                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
			                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
			                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
			                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
			                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
				            	}
				            }
			            }
			            if(selectedField == 'Territory')
                		{
             				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c = :currentField order by p.Territory_Country__c])
				            {
				                for(Pipeline_Report__c objCount : oppPipeLineListCount)
				            	{
			                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
			                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
			                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
			                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
			                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
				            	}
				            }
			            }
                		//End Get the Count Values of 3.5.7
						if(totalSM30CountPipelines == 0)
							bean.setTotalSM30Pipelines('0');	
						else
							bean.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
	                    if(totalSM50CountPipelines == 0)
							bean.setTotalSM50Pipelines('0');	
						else
							bean.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
						if(totalSM70CountPipelines == 0)
							bean.setTotalSM70Pipelines('0');	
						else
							bean.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
						if(totalSM90CountPipelines == 0)
							bean.setTotalSM90Pipelines('0');	
						else
							bean.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
						if(totalSMWonCountPipelines == 0)
							bean.setTotalSMWonPipelines('0');	
						else
							bean.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
	            	}
		            else
		            {
		                bean.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
		                bean.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
		                bean.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
		                bean.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
		                bean.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));		                
		            }                    
                    oppPipelineBeanList.add(bean);
                }
                previousField = currentField;
            }           
            
        }
        //Start Totals of Group by Region
        totalSM30Pipelines =0;
        totalSM30CountPipelines =0;
        totalSM50Pipelines =0;
        totalSM50CountPipelines =0;
        totalSM70Pipelines =0;
        totalSM70CountPipelines =0;
        totalSM90Pipelines =0;
        totalSM90CountPipelines =0;
        totalSMWonPipelines =0;
        totalSMWonCountPipelines =0;
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
        	List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];

                totalSM30Pipelines = totalSM30Pipelines + obj.SM_30__c;
                totalSM50Pipelines = totalSM50Pipelines + obj.SM_50__c;
                totalSM70Pipelines = totalSM70Pipelines + obj.SM_70__c;
                totalSM90Pipelines = totalSM90Pipelines + obj.SM_90__c;
                totalSMWonPipelines = totalSMWonPipelines + obj.SM_Won__c;
            }
        }
    	OppPipelineBean bean = new OppPipelineBean();
    	if(cal == 'avg')
    	{
	    	bean.setRegion('Avg');    
            //Start Get the Count Values of 3.5.7
    	    Decimal data_pull_date = datemap.get(selectedDate);
    		if(selectedField == 'Region')
    		{
 				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion order by p.Region__c])
	            {
	                for(Pipeline_Report__c objCount : oppPipeLineListCount)
	            	{
                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            	}
	            }
            }
   			if(selectedField == 'Area')
            {
            	for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea order by p.Area__c])
				{
					for(Pipeline_Report__c objCount : oppPipeLineListCount)
				    {
			        	totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
			            totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
			            totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
			            totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
			            totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
			    	}
				}
	        }
            if(selectedField == 'Territory')
    		{
 				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory order by p.Territory_Country__c])
	            {
	                for(Pipeline_Report__c objCount : oppPipeLineListCount)
	            	{
                        totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                        totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                        totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                        totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                        totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            	}
	            }
            }
    		//End Get the Count Values of 3.5.7
			if(totalSM30CountPipelines == 0)
				bean.setTotalSM30Pipelines('0');	
			else
				bean.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
            if(totalSM50CountPipelines == 0)
				bean.setTotalSM50Pipelines('0');	
			else
				bean.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
			if(totalSM70CountPipelines == 0)
				bean.setTotalSM70Pipelines('0');	
			else
				bean.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
			if(totalSM90CountPipelines == 0)
				bean.setTotalSM90Pipelines('0');	
			else
				bean.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
			if(totalSMWonCountPipelines == 0)
				bean.setTotalSMWonPipelines('0');	
			else
				bean.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
	    }
	    else
	    {
            bean.setRegion('Total');
            bean.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
            bean.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
            bean.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
            bean.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
            bean.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
    	}
        oppPipelineBeanList.add(bean);
        
        //End Totals of Group by Region
        System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    } 

    //End Group by Region

    //Start Group by BU 
	private List<OppPipelineBean> processBUAvgAgePriceData(List<List<Pipeline_Report__c>> oppMasterList , String cal)
	{
		Decimal totalSM30Pipelines =0;
        Decimal totalSM30CountPipelines =0;
        Decimal totalSM50Pipelines =0;
        Decimal totalSM50CountPipelines =0;
        Decimal totalSM70Pipelines =0;
        Decimal totalSM70CountPipelines =0;
        Decimal totalSM90Pipelines =0;
        Decimal totalSM90CountPipelines =0;
        Decimal totalSMWonPipelines =0;
        Decimal totalSMWonCountPipelines =0;
        Integer rowcount =0;
		Integer Count = 0;
		String buname = '';
        String bu = '';
        String ncv;
        String currentbu = '';


        List<OppPipelineBean> beanList = new List<OppPipelineBean>();
        for(String ncvbuName: sortArray(convertSetToArray()))
        {
	        totalSM30Pipelines =0;
	        totalSM30CountPipelines =0;
	        totalSM50Pipelines =0;
	        totalSM50CountPipelines =0;
	        totalSM70Pipelines =0;
	        totalSM70CountPipelines =0;
	        totalSM90Pipelines =0;
	        totalSM90CountPipelines =0;
	        totalSMWonPipelines =0;
	        totalSMWonCountPipelines =0;
			Count =0;
			buname = '';
			ncv = '';
            
            
            //Start Total by each Business Unit
	        if(currentbu != ncvbuMap.get(ncvbuName))	         
            {
            	if (currentbu != '')
              	{	             
	            	//Start total of "Other" in NCV Driver
	             	for(List<Pipeline_Report__c> buList : oppMasterList)
		            {
		               	for(Pipeline_Report__c buObj : buList)
		               	{
			               	if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
			               	{   
		               			Count++;
								totalSM30Pipelines = totalSM30Pipelines + buObj.SM_30__c;
		                        totalSM50Pipelines = totalSM50Pipelines + buObj.SM_50__c;
		                        totalSM70Pipelines = totalSM70Pipelines + buObj.SM_70__c;
		                        totalSM90Pipelines = totalSM90Pipelines + buObj.SM_90__c;
		                        totalSMWonPipelines = totalSMWonPipelines + buObj.SM_Won__c;
                        		ncv = buobj.NCV_Driver_6__c;
								buname = buobj.Business_Unit__c;
			                }
		                }	
		            }   			
					
					if(Count != 0)
					{
		            	OppPipelineBean beanother = new OppPipelineBean();
	                	beanother.setBu('');
	                	beanother.setNcv(ncv);
	                
			        	if(cal == 'avg')
            			{
							Decimal data_pull_date = datemap.get(selectedDate);
					        if(selectedField == 'Region')
	        				{
     							for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Region__c])
		            			{
		                			for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            				{
                    					totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    					totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    					totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    					totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    					totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
            						}
            					}
        					}
	   						if(selectedField == 'Area')
	            			{
	 							for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Area__c])
		            			{
	                				for(Pipeline_Report__c objCount : oppPipeLineListCount)
	            					{
	                    					totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
	                    					totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
	                    					totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
	                    					totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
	                    					totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            					}
		            			}
			    			}
		            		if(selectedField == 'Territory')
	        				{
	     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Territory_Country__c])
			            		{
	                				for(Pipeline_Report__c objCount : oppPipeLineListCount)
	            					{
	                					totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
	                					totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
	                					totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
	                					totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
	                					totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            					}
			            		}
		            		}
							if(totalSM30CountPipelines == 0)
								beanother.setTotalSM30Pipelines('0');	
							else
								beanother.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
	           				if(totalSM50CountPipelines == 0)
								beanother.setTotalSM50Pipelines('0');	
							else
								beanother.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
							if(totalSM70CountPipelines == 0)
								beanother.setTotalSM70Pipelines('0');	
							else
								beanother.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
							if(totalSM90CountPipelines == 0)
								beanother.setTotalSM90Pipelines('0');	
							else
								beanother.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
							if(totalSMWonCountPipelines == 0)
								beanother.setTotalSMWonPipelines('0');	
							else
								beanother.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
	        			}
	        			else
	        			{
            				beanother.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
            				beanother.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
            				beanother.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
            				beanother.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
            				beanother.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
        				}
		                if(totalSM30Pipelines.round() == 0 && totalSM50Pipelines.round() == 0 && totalSM70Pipelines.round() == 0 && totalSM90Pipelines.round() == 0 && totalSMWonPipelines.round() == 0)
		            	{
		            		//Dummy
		            		bu = bu;
		            	}
		            	else
		            	{
		            		beanList.add(beanother);
		            	}
						totalSM30Pipelines =0;
				        totalSM30CountPipelines =0;
				        totalSM50Pipelines =0;
				        totalSM50CountPipelines =0;
				        totalSM70Pipelines =0;
				        totalSM70CountPipelines =0;
				        totalSM90Pipelines =0;
				        totalSM90CountPipelines =0;
				        totalSMWonPipelines =0;
				        totalSMWonCountPipelines =0;
						buname = '';
						ncv = '';
			           	Count =0;
					}
             		//End total of "Other" in NCV Driver
		            
	             	for(List<Pipeline_Report__c> buList : oppMasterList)
	                {
	                	for(Pipeline_Report__c buObj : buList)
                		{
                    		if(currentbu == buobj.Business_Unit__c)
                    		{   
                      			totalSM30Pipelines = totalSM30Pipelines + buObj.SM_30__c;
		                        totalSM50Pipelines = totalSM50Pipelines + buObj.SM_50__c;
		                        totalSM70Pipelines = totalSM70Pipelines + buObj.SM_70__c;
		                        totalSM90Pipelines = totalSM90Pipelines + buObj.SM_90__c;
		                        totalSMWonPipelines = totalSMWonPipelines + buObj.SM_Won__c;	                     	                            	                            
                    		}                        
                		}
	                }
	                OppPipelineBean bean = new OppPipelineBean();
	                bean.setNcv('');
			        if(cal == 'avg')
           			{
						Decimal data_pull_date = datemap.get(selectedDate);
						if(selectedField == 'Region')
	        			{
     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion and p.Business_Unit__c =:currentbu order by p.Region__c])
		            		{
		                		for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            			{
                    				totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    				totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    				totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    				totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    				totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            				}
	            			}
            			}
   						if(selectedField == 'Area')
                		{
     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea and p.Business_Unit__c =:currentbu order by p.Area__c])
		            		{
		                		for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            			{
                    				totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    				totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    				totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    				totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    				totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            				}
	            			}
			    		}
	            		if(selectedField == 'Territory')
        				{
     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory and p.Business_Unit__c =:currentbu order by p.Territory_Country__c])
		            		{
	                			for(Pipeline_Report__c objCount : oppPipeLineListCount)
	            				{
                    				totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    				totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    				totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    				totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    				totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            				}
	            			}
	            		}
						bean.setBu(currentbu+' Avg');
						if(totalSM30CountPipelines == 0)
							bean.setTotalSM30Pipelines('0');	
						else
							bean.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
		            			if(totalSM50CountPipelines == 0)
							bean.setTotalSM50Pipelines('0');	
						else
							bean.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
						if(totalSM70CountPipelines == 0)
							bean.setTotalSM70Pipelines('0');	
						else
							bean.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
						if(totalSM90CountPipelines == 0)
							bean.setTotalSM90Pipelines('0');	
						else
							bean.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
						if(totalSMWonCountPipelines == 0)
							bean.setTotalSMWonPipelines('0');	
						else
							bean.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
	        		}
	        		else
	        		{
            			bean.setBu(currentbu+' Total');
						bean.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
            			bean.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
            			bean.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
            			bean.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
            			bean.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
        			}
	                beanList.add(bean);
	                
					totalSM30Pipelines =0;
			        totalSM30CountPipelines =0;
			        totalSM50Pipelines =0;
			        totalSM50CountPipelines =0;
			        totalSM70Pipelines =0;
			        totalSM70CountPipelines =0;
			        totalSM90Pipelines =0;
			        totalSM90CountPipelines =0;
			        totalSMWonPipelines =0;
			        totalSMWonCountPipelines =0;
					buname = '';
					ncv = '';
			        Count =0;		         	
             	}
             }	
	    	// End Total by each Business Unit
            // Start Total by each Business Unit and NCV Driver
	        if(!(ncvbuName.contains('other')))
	        {
	            for(List<Pipeline_Report__c> buList : oppMasterList)
	            {
	                for(Pipeline_Report__c buObj : buList)
	                {
		                if(ncvbuName == (buobj.Business_Unit__c+'+'+buobj.NCV_Driver_6__c).toLowerCase())
		                {   
	                  		Count++;
							totalSM30Pipelines = totalSM30Pipelines + buObj.SM_30__c;
				    	    totalSM50Pipelines = totalSM50Pipelines + buObj.SM_50__c;
				        	totalSM70Pipelines = totalSM70Pipelines + buObj.SM_70__c;
				        	totalSM90Pipelines = totalSM90Pipelines + buObj.SM_90__c;
				        	totalSMWonPipelines = totalSMWonPipelines + buObj.SM_Won__c;
		                    ncv = buobj.NCV_Driver_6__c;
							buname = buobj.Business_Unit__c;
		                }
	                }
	            }
	            
	            if (currentbu  == ncvbuMap.get(ncvbuName))
	            	currentbu = '';
	            else
	         		currentbu = ncvbuMap.get(ncvbuName);
	            
	            if (Count != 0)
	            {
	            	OppPipelineBean bean = new OppPipelineBean();
	                bean.setBu(currentbu);
	                bean.setNcv(ncv);
					if(cal == 'avg')
            		{
						Decimal data_pull_date = datemap.get(selectedDate);
			        	if(selectedField == 'Region')
	        			{
     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Region__c])
		        			{
		                		for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            			{
                        			totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                        			totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                        			totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                        			totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                        			totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
		            			}
		            		}
	            		}
   						if(selectedField == 'Area')
                		{
     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Area__c])
		            		{
		                		for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            			{
                        			totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                        			totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                        			totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                        			totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                        			totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
		            			}
		            		}
			    		}
	            		if(selectedField == 'Territory')
        				{
     						for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Territory_Country__c])
		            		{
		                		for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            			{
                        			totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                        			totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                        			totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                        			totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                        			totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
		            			}
		            		}
	            		}

						if(totalSM30CountPipelines == 0)
							bean.setTotalSM30Pipelines('0');	
						else
							bean.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
			            		if(totalSM50CountPipelines == 0)
							bean.setTotalSM50Pipelines('0');	
						else
							bean.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
						if(totalSM70CountPipelines == 0)
							bean.setTotalSM70Pipelines('0');	
						else
							bean.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
						if(totalSM90CountPipelines == 0)
							bean.setTotalSM90Pipelines('0');	
						else
							bean.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
						if(totalSMWonCountPipelines == 0)
							bean.setTotalSMWonPipelines('0');	
						else
							bean.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
		        	}
	       			else
	       			{
              			bean.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
                		bean.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
                		bean.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
                		bean.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
                		bean.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
	        		}

	                if(totalSM30Pipelines.round() == 0 && totalSM50Pipelines.round() == 0 && totalSM70Pipelines.round() == 0 && totalSM90Pipelines.round() == 0 && totalSMWonPipelines.round() == 0)
	                {
	                	bu = currentbu;
	                }
	                else
	                {
	                	if(bu == ncvbuMap.get(ncvbuName))
	                	{
	                		bean.setBu(bu);
	                		bu = '';	
	                	} 
	                	beanList.add(bean);
	                }
	                currentbu = ncvbuMap.get(ncvbuName);                
	            }
	        }
	        else
	        {
	        	currentbu = ncvbuMap.get(ncvbuName);
	        	if(currentbu == 'Application Performance Management')
	        		bu = currentbu;
        		if(currentbu == 'AUTOMATION')
        			bu = currentbu;
        		if(currentbu == 'BUSINESS GOVERNANCE')
        			bu = currentbu;	
	        }
        	// End Total by each Business Unit and NCV Driver            
        }
        
		//Start get the Last "Other" of NCV Driver
		totalSM30Pipelines =0;
		totalSM30CountPipelines =0;
		totalSM50Pipelines =0;
		totalSM50CountPipelines =0;
		totalSM70Pipelines =0;
		totalSM70CountPipelines =0;
		totalSM90Pipelines =0;
		totalSM90CountPipelines =0;
		totalSMWonPipelines =0;
		totalSMWonCountPipelines =0;
		buname = '';
		ncv = '';
		Count =0;
        for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
                {   
              		Count++;
					totalSM30Pipelines = totalSM30Pipelines + buObj.SM_30__c;
					totalSM50Pipelines = totalSM50Pipelines + buObj.SM_50__c;
					totalSM70Pipelines = totalSM70Pipelines + buObj.SM_70__c;
					totalSM90Pipelines = totalSM90Pipelines + buObj.SM_90__c;
					totalSMWonPipelines = totalSMWonPipelines + buObj.SM_Won__c;
				    ncv = buobj.NCV_Driver_6__c;
					buname = buobj.Business_Unit__c;
                }
            }
        }
		
		if(Count != 0)
		{
        	OppPipelineBean beanother = new OppPipelineBean();
            beanother.setBu('');
            beanother.setNcv(ncv);
			if(cal == 'avg')
            {
				Decimal data_pull_date = datemap.get(selectedDate);
		        if(selectedField == 'Region')
	        	{
     				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Region__c])
		        	{
		            	for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            	{
                    		totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    		totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    		totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    		totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    		totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            		}
	            	}
	       		}
   				if(selectedField == 'Area')
                {
     				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Area__c])
					{
						for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            	{
                    		totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    		totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    		totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    		totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    		totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            		}
	       			}
    			}
	            if(selectedField == 'Territory')
        		{
     				for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory and p.Business_Unit__c =:buName and p.NCV_Driver_6__c =:ncv order by p.Territory_Country__c])
         			{
	                	for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            	{
                    		totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    		totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    		totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    		totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    		totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            		}
		            }
	       		}

				if(totalSM30CountPipelines == 0)
					beanother.setTotalSM30Pipelines('0');	
				else
					beanother.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
				if(totalSM50CountPipelines == 0)
					beanother.setTotalSM50Pipelines('0');	
				else
					beanother.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
				if(totalSM70CountPipelines == 0)
					beanother.setTotalSM70Pipelines('0');	
				else
					beanother.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
				if(totalSM90CountPipelines == 0)
					beanother.setTotalSM90Pipelines('0');	
				else
					beanother.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
				if(totalSMWonCountPipelines == 0)
					beanother.setTotalSMWonPipelines('0');	
				else
					beanother.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
	        }
	        else
	        {
                	beanother.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
                	beanother.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
                	beanother.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
                	beanother.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
                	beanother.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
        	}
           	if(totalSM30Pipelines.round() == 0 && totalSM50Pipelines.round() == 0 && totalSM70Pipelines.round() == 0 && totalSM90Pipelines.round() == 0 && totalSMWonPipelines.round() == 0)
				bu = bu;
			else
				beanList.add(beanother);

		}
     	//End get the Last Other of NCV Driver
        // Start Total last Business Unit and NCV Driver
		totalSM30Pipelines =0;
		totalSM30CountPipelines =0;
		totalSM50Pipelines =0;
		totalSM50CountPipelines =0;
		totalSM70Pipelines =0;
		totalSM70CountPipelines =0;
		totalSM90Pipelines =0;
		totalSM90CountPipelines =0;
		totalSMWonPipelines =0;
		totalSMWonCountPipelines =0;
		buname = '';
		ncv = '';
		Count =0;
	        
		for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c)
                {   
		    		totalSM30Pipelines = totalSM30Pipelines + buObj.SM_30__c;
	                totalSM50Pipelines = totalSM50Pipelines + buObj.SM_50__c;
					totalSM70Pipelines = totalSM70Pipelines + buObj.SM_70__c;
					totalSM90Pipelines = totalSM90Pipelines + buObj.SM_90__c;
					totalSMWonPipelines = totalSMWonPipelines + buObj.SM_Won__c;			
                }                        
            }
        }
        OppPipelineBean bean = new OppPipelineBean();
        bean.setNcv('');
		if(cal == 'avg')
        {
			Decimal data_pull_date = datemap.get(selectedDate);
			if(selectedField == 'Region')
	        {
     			for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion and p.Business_Unit__c =:currentbu order by p.Region__c])
				{
		        	for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            {
                    	totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    	totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    	totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    	totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    	totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	            	}
				}
			}
   			if(selectedField == 'Area')
           	{
     			for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea and p.Business_Unit__c =:currentbu order by p.Area__c])
		        {
		        	for(Pipeline_Report__c objCount : oppPipeLineListCount)
		           	{
                    	totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    	totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    	totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    	totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    	totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
		            }
				}
			}
			if(selectedField == 'Territory')
        	{
     			for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory and p.Business_Unit__c =:currentbu order by p.Territory_Country__c])
		        {
		        	for(Pipeline_Report__c objCount : oppPipeLineListCount)
		            {
                    	totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
                    	totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
                    	totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
                    	totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
                    	totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
		            }
       			}
			}

			bean.setBu(currentbu+' Avg');
			if(totalSM30CountPipelines == 0)
				bean.setTotalSM30Pipelines('0');	
			else
				bean.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
			if(totalSM50CountPipelines == 0)
				bean.setTotalSM50Pipelines('0');	
			else
				bean.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
			if(totalSM70CountPipelines == 0)
				bean.setTotalSM70Pipelines('0');	
			else
				bean.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
			if(totalSM90CountPipelines == 0)
				bean.setTotalSM90Pipelines('0');	
			else
				bean.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
			if(totalSMWonCountPipelines == 0)
				bean.setTotalSMWonPipelines('0');	
			else
				bean.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
		}
		else
		{
        	bean.setBu(currentbu+' Total');
			bean.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
            bean.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
            bean.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
            bean.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
            bean.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
       	}
        beanList.add(bean);
        
		//End Total last Business Unit and NCV Driver
		//Start Totals of Group by BU
		totalSM30Pipelines =0;
	    totalSM30CountPipelines =0;
	    totalSM50Pipelines =0;
	    totalSM50CountPipelines =0;
	    totalSM70Pipelines =0;
	    totalSM70CountPipelines =0;
	    totalSM90Pipelines =0;
	    totalSM90CountPipelines =0;
	    totalSMWonPipelines =0;
	    totalSMWonCountPipelines =0;
	        
		for(List<Pipeline_Report__c> buList : oppMasterList)
	    {
	    	for(Pipeline_Report__c buObj : buList)
	    	{
	        	totalSM30Pipelines = totalSM30Pipelines + buObj.SM_30__c;
	        	totalSM50Pipelines = totalSM50Pipelines + buObj.SM_50__c;
	        	totalSM70Pipelines = totalSM70Pipelines + buObj.SM_70__c;
	        	totalSM90Pipelines = totalSM90Pipelines + buObj.SM_90__c;
	        	totalSMWonPipelines = totalSMWonPipelines + buObj.SM_Won__c;
	    	}
	    }
	        
	    OppPipelineBean beanTotal = new OppPipelineBean();
	    if(cal == 'avg')
	    {
	        	
	    	beanTotal.setBu('Avg');
	    	Decimal data_pull_date = datemap.get(selectedDate);
		    if(selectedField == 'Region')
		    {
		 		for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in :selectedRegion order by p.Region__c])
				{
			    	for(Pipeline_Report__c objCount : oppPipeLineListCount)
			        {
		        		totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
		        		totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
		        		totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
		        		totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
		        		totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
		    		}
				}
			}
		   	if(selectedField == 'Area')
	        {
	        	for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in :selectedArea order by p.Area__c])
				{
					for(Pipeline_Report__c objCount : oppPipeLineListCount)
					{
			        	totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
		            	totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
		            	totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
		            	totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
		            	totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
			    	}
				}
	        }
	       	if(selectedField == 'Territory')
	    	{
	 			for(List<Pipeline_Report__c> oppPipeLineListCount: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7CountHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in :selectedTerritory order by p.Territory_Country__c])
		       	{
	            	for(Pipeline_Report__c objCount : oppPipeLineListCount)
	        		{
	            		totalSM30CountPipelines = totalSM30CountPipelines + objCount.SM_30__c;
	            		totalSM50CountPipelines = totalSM50CountPipelines + objCount.SM_50__c;
	            		totalSM70CountPipelines = totalSM70CountPipelines + objCount.SM_70__c;
	            		totalSM90CountPipelines = totalSM90CountPipelines + objCount.SM_90__c;
	            		totalSMWonCountPipelines = totalSMWonCountPipelines + objCount.SM_Won__c;
	        		}
		        }
	       	}
	    	//End Get the Count Values of 3.5.7
			if(totalSM30CountPipelines == 0)
				beanTotal.setTotalSM30Pipelines('0');	
			else
				beanTotal.setTotalSM30Pipelines(convert((totalSM30Pipelines/totalSM30CountPipelines).round()));	
	        if(totalSM50CountPipelines == 0)
				beanTotal.setTotalSM50Pipelines('0');	
			else
				beanTotal.setTotalSM50Pipelines(convert((totalSM50Pipelines/totalSM50CountPipelines).round()));	
			if(totalSM70CountPipelines == 0)
				beanTotal.setTotalSM70Pipelines('0');	
			else
				beanTotal.setTotalSM70Pipelines(convert((totalSM70Pipelines/totalSM70CountPipelines).round()));	
			if(totalSM90CountPipelines == 0)
				beanTotal.setTotalSM90Pipelines('0');	
			else
				beanTotal.setTotalSM90Pipelines(convert((totalSM90Pipelines/totalSM90CountPipelines).round()));	
			if(totalSMWonCountPipelines == 0)
				beanTotal.setTotalSMWonPipelines('0');	
			else
				beanTotal.setTotalSMWonPipelines(convert((totalSMWonPipelines/totalSMWonCountPipelines).round()));	
    	}
    	else
    	{
        	beanTotal.setBu('Total');
        	beanTotal.setTotalSM30Pipelines(convert(convertthousands(totalSM30Pipelines).round()));
        	beanTotal.setTotalSM50Pipelines(convert(convertthousands(totalSM50Pipelines).round()));
        	beanTotal.setTotalSM70Pipelines(convert(convertthousands(totalSM70Pipelines).round()));
        	beanTotal.setTotalSM90Pipelines(convert(convertthousands(totalSM90Pipelines).round()));
        	beanTotal.setTotalSMWonPipelines(convert(convertthousands(totalSMWonPipelines).round()));
    	}
        beanList.add(beanTotal);
		//End Totals of Group by BU
        System.debug('processBUData: Raj returns oppPipelineBeanList: '+beanList);
        return beanList;
    }
    //End Group by BU
    //End "3.5.8 Region Aging by Milestone - Avg Oppty Age Days Price Total" Report Calculation
    
    public List<OppPipelineBean> getOppPipeLineBeanForAvgAgeRegion()
    {
        return this.oppPipeLineBeanForAvgAgeRegion;
    }

    public List<OppPipelineBean> getOppPipeLineBeanForAvgAgeBU()
    {
        return this.oppPipeLineBeanForAvgAgeBU;
    }

    public List<OppPipelineBean> getOppPipeLineBeanForAvgPriceRegion()
    {
        return this.oppPipeLineBeanForAvgPriceRegion;
    }

    public List<OppPipelineBean> getOppPipeLineBeanForAvgPriceBU()
    {
        return this.oppPipeLineBeanForAvgPriceBU;
    }

    public Boolean getShowDataTable()
    {
        return showDataTable;
    }
    public Boolean getShowRegionList()
    {
        return showRegionList;
    }
    public Boolean getShowAreaList()
    {
        return showAreaList;
    }
    public Boolean getShowTerritoryList()
    {
        return showTerritoryList;
    }
    public String getSelectedColumn()
    {
        return selectedColumn;
    }
    public String getMonthFirstPull()
    {
        return monthFirstPull;
    }
    public PageReference populateData()
    {
    	Decimal data_pull_date = datemap.get(selectedDate);
		System.debug('Raj: In PopulateData');
        //System.debug('Selected Date :'+selectedDate);
        //System.debug('Selected Region :'+selectedRegion);
        //System.debug('Selected Country :'+selectedCountry);
        showDataTable = true;
        selectedColumn = selectedField;
        VOppPipelineMainHelper.index = 5; 

		// Start Build Reports 3.5 and 3.7
    	List<List<Pipeline_Report__c>> oppMasterListAvgAge = new List<List<Pipeline_Report__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7SumHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
	            {
	                oppMasterListAvgAge.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c,  p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7SumHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterListAvgAge.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c,  p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.5.7SumHQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterListAvgAge.add(oppPipeLineList);
            }            
        }
        oppPipeLineBeanForAvgAgeRegion = processRegionAvgAgePriceData(oppMasterListAvgAge,'avg');
        oppPipeLineBeanForAvgAgeBU = processBUAvgAgePriceData(oppMasterListAvgAge ,'avg' );
        // End Build Reports 3.5 and 3.7

        // Start Build Reports 3.6 and 3.8
    	List<List<Pipeline_Report__c>> oppMasterListAvgPrice = new List<List<Pipeline_Report__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.6.8HQ' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
	            {
	                oppMasterListAvgPrice.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c,  p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.6.8HQ' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterListAvgPrice.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c,  p.SM_20__c, p.SM_30__c, p.SM_40__c, p.SM_50__c, p.SM_60__c, p.SM_70__c, p.SM_80__c, p.SM_90__c, p.SM_Won__c , p.SM_50_Proposal_Created__c from Pipeline_Report__c p Where p.Report_Name__c = '3.6.8HQ' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterListAvgPrice.add(oppPipeLineList);
            }
        }
        oppPipeLineBeanForAvgPriceRegion = processRegionAvgAgePriceData(oppMasterListAvgPrice,'sum');
        oppPipeLineBeanForAvgPriceBU = processBUAvgAgePriceData(oppMasterListAvgPrice,'sum');
        // End Build Reports 3.6 and 3.8		
        return null;
    }
}