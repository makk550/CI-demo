public  class VOppPipelineReportHelper_1_0Core 
{
    public String[] selectedRegion = new String[]{}; 
    public String selectedDate = 'select';
    public String[] selectedArea = new String[]{};
    public String[] selectedTerritory = new String[]{};
    public List<OppPipelineBean> oppPipeLineBean ;
    public List<OppPipelineBean> oppPipeLineBeanForBU ;
    public String selectedField = 'select';
    public String selectedColumn = '';
    Boolean showDataTable = false;
    Boolean showRegionList = false;
    Boolean showAreaList = false;
    Boolean showTerritoryList = false;
    Map<String,String> ncvbuMap = new Map<String,String>();
    Map<String,Decimal> datemap = new Map<String,Decimal>();
    Map<String,Decimal> mapCommit = new Map<String,Decimal>();
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
        VOppPipelineMainHelper.index = 0 ;
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
    private List<OppPipelineBean> processTeriotoryData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
        Decimal totalPriceQualiPipelines =0;
        Decimal totalPriceClosedWonPipelines =0;
        Decimal totalPriceTargetPipelines =0;
        Decimal totalPriceCommitPipelines =0;
       
        Double totalQualiPipelines =0;
        Double totalClosedWonPipelines = 0 ;
        Integer count =0;
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
                        totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                        totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;
                
                        totalQualiPipelines = totalQualiPipelines + obj.Qualified_Pipeline_Count__c;
                        totalClosedWonPipelines = totalClosedWonPipelines + obj.Closed_Pipeline_Count__c;
                        totalPriceTargetPipelines = totalPriceTargetPipelines + obj.Target__c;
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                        bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
                        bean.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
                        bean.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
                
                        bean.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));
                
                        if(mapCommit.get(previousField) == NULL)
                        { 
                        	totalPriceCommitPipelines =0;
                        }
                        else
                        {
		                	totalPriceCommitPipelines =mapCommit.get(previousField);
		                }
						bean.setTotalPriceCommitPipelines(convert(totalPriceCommitPipelines.round()));
						
						if(totalPriceCommitPipelines == 0)
	                    { 
	                    	bean.setPercentCommitWonPipelines(0);
	                    }
	                    else
	                    {
	    					Decimal decCommitWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceCommitPipelines,2,System.RoundingMode.UP);
	                    	bean.setPercentCommitWonPipelines(decCommitWon.round());
	                    }
	                    
						if(totalPriceTargetPipelines.round() == 0)
	                    {
	                        bean.setPercentCommitBudgetPipelines(0);
	                        bean.setPercentBudgetWonPipelines(0);
	                    }
	                    else
	                    {
	                        Decimal decCommitBudget = (totalPriceCommitPipelines).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);
	                        Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
							bean.setPercentCommitBudgetPipelines((decCommitBudget*100).round());
	                        bean.setPercentBudgetWonPipelines(decBudgetWon.round());                            
	                    }
                        
						bean.setTotalQualiPipelines(totalQualiPipelines.round());
                        bean.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
                        bean.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
                        oppPipelineBeanList.add(bean);
                    
                        totalPriceQualiPipelines =0;
                        totalPriceClosedWonPipelines =0;
                        totalQualiPipelines =0;
                        totalClosedWonPipelines = 0 ;
                        totalPriceTargetPipelines =0;
                        totalPriceCommitPipelines =0;
                        
                        totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                        totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;
                        totalQualiPipelines = totalQualiPipelines + obj.Qualified_Pipeline_Count__c;
                        totalClosedWonPipelines = totalClosedWonPipelines + obj.Closed_Pipeline_Count__c;
                        totalPriceTargetPipelines = totalPriceTargetPipelines + obj.Target__c;
                    }
                    count ++;
                }
                else
                {
                    totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                    totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;

                    totalQualiPipelines = totalQualiPipelines + obj.Qualified_Pipeline_Count__c;
                    totalClosedWonPipelines = totalClosedWonPipelines + obj.Closed_Pipeline_Count__c;
                    totalPriceTargetPipelines = totalPriceTargetPipelines + obj.Target__c;
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
                    bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
                    bean.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
                    bean.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
                    
                    bean.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));
                    if(mapCommit.get(currentField) == NULL)
                    { 
                    	totalPriceCommitPipelines =0;
                    }
                    else
                    {
	                	totalPriceCommitPipelines =mapCommit.get(currentField);
	                }
					bean.setTotalPriceCommitPipelines(convert(totalPriceCommitPipelines.round()));
					
					if(totalPriceCommitPipelines == 0)
                    { 
                    	bean.setPercentCommitWonPipelines(0);
                    }
                    else
                    {
    					Decimal decCommitWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceCommitPipelines,2,System.RoundingMode.UP);
                    	bean.setPercentCommitWonPipelines(decCommitWon.round());
                    }
                    
					if(totalPriceTargetPipelines.round() == 0)
                    {
                        bean.setPercentCommitBudgetPipelines(0);
                        bean.setPercentBudgetWonPipelines(0);
                    }
                    else
                    {
                        Decimal decCommitBudget = (totalPriceCommitPipelines).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);
                        Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
						bean.setPercentCommitBudgetPipelines((decCommitBudget*100).round());
                        bean.setPercentBudgetWonPipelines(decBudgetWon.round());                            
                    }
                    
                    bean.setTotalQualiPipelines(totalQualiPipelines.round());
                    bean.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
                    bean.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
                    oppPipelineBeanList.add(bean);
                }
                previousField = currentField;
            }
        }
        //Start Total Data
        totalPriceQualiPipelines =0;
        totalPriceClosedWonPipelines =0;
        totalQualiPipelines =0;
        totalClosedWonPipelines = 0 ;
        totalPriceTargetPipelines =0;
        totalPriceCommitPipelines =0;
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];
				totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;
                totalQualiPipelines = totalQualiPipelines + obj.Qualified_Pipeline_Count__c;
                totalClosedWonPipelines = totalClosedWonPipelines + obj.Closed_Pipeline_Count__c;
                totalPriceTargetPipelines = totalPriceTargetPipelines + obj.Target__c;             

                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion('Total');
                    bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
                    bean.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
                    bean.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
                    
                    bean.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));
                    
                    for(String commitName: mapCommit.keySet())
        			{
            			if (mapCommit.get(commitName) != NULL)
            			{
            				totalPriceCommitPipelines = totalPriceCommitPipelines +  mapCommit.get(commitName);
            			}
            				
        			}
        			
                    bean.setTotalPriceCommitPipelines(convert(totalPriceCommitPipelines.round()));
					
					if(totalPriceCommitPipelines == 0)
                    { 
                    	bean.setPercentCommitWonPipelines(0);
                    }
                    else
                    {
    					Decimal decCommitWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceCommitPipelines,2,System.RoundingMode.UP);
                    	bean.setPercentCommitWonPipelines(decCommitWon.round());
                    }
                    
					if(totalPriceTargetPipelines.round() == 0)
                    {
                        bean.setPercentCommitBudgetPipelines(0);
                        bean.setPercentBudgetWonPipelines(0);
                    }
                    else
                    {
                        Decimal decCommitBudget = (totalPriceCommitPipelines).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);
                        Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
						bean.setPercentCommitBudgetPipelines((decCommitBudget*100).round());
                        bean.setPercentBudgetWonPipelines(decBudgetWon.round());                            
                    }
                    
                    bean.setTotalQualiPipelines(totalQualiPipelines.round());
                    bean.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
                    bean.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
                    oppPipelineBeanList.add(bean);
                }
            }
        }        
        //End Total Data 
        
        System.debug('processTeriotoryData: Kunal returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    } 

    private String[] convertSetToArray()
    {
    	Integer counter = 0;
    	String[] keysncvbu = new String[ncvbuMap.size()];
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
    private List<OppPipelineBean> processBUData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        Decimal totalPriceQualiPipelines =0;
        Decimal totalPriceClosedWonPipelines =0;
        Double totalQualiPipelines =0;
        Double totalClosedWonPipelines = 0 ;
        Decimal totalPriceTargetPipelines =0;
        Integer Count = 0;
        String bu = '';
        String ncv;
        String currentbu = '';
        
        List<OppPipelineBean> beanList = new List<OppPipelineBean>();
        for(String ncvName: sortArray(convertSetToArray()))
        {
        	 totalPriceQualiPipelines =0;
	         totalPriceClosedWonPipelines =0;
	         totalQualiPipelines =0;
	         totalClosedWonPipelines = 0 ;
	         totalPriceTargetPipelines =0;
	         Count = 0;
	         //ncv = '';
	         
	         //Start Total by each Business Unit
	         if(currentbu != ncvbuMap.get(ncvName))	         
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
		                        totalPriceQualiPipelines = totalPriceQualiPipelines + buObj.Qualified_Pipeline_Amount__c;
		                        totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + buObj.Closed_Pipeline_Amount__c;
		                        totalQualiPipelines = totalQualiPipelines + buObj.Qualified_Pipeline_Count__c;
		                        totalClosedWonPipelines = totalClosedWonPipelines + buObj.Closed_Pipeline_Count__c;
			                    totalPriceTargetPipelines = totalPriceTargetPipelines + buObj.Target__c;
		                        ncv = buobj.NCV_Driver_6__c;	                            	                            
			                }
		                }	
		            }   			
					
					if(Count != 0)
					{
		             	OppPipelineBean beanother = new OppPipelineBean();
		                beanother.setBu('');
		                beanother.setNcv(ncv);
		                beanother.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
		                beanother.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
		                beanother.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
						beanother.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));
		    
		    			if(totalPriceTargetPipelines.round() == 0)
	                    {
	                        beanother.setPercentBudgetWonPipelines(0);
	                    }
	                    else
	                    {
	                        Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
							beanother.setPercentBudgetWonPipelines(decBudgetWon.round());                            
	                    }
		    
		                beanother.setTotalQualiPipelines(totalQualiPipelines.round());
		                beanother.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
		                beanother.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
		                if(totalPriceQualiPipelines.round() == 0 && totalPriceClosedWonPipelines.round() == 0 && totalPriceTargetPipelines.round() == 0 && totalQualiPipelines.round() == 0 && totalClosedWonPipelines.round() == 0)
			            {
			            	//Dummy
			            	bu = bu;
			            }
			            else
			            {
			            	beanList.add(beanother);
			            }
		                totalPriceQualiPipelines =0;
			         	totalPriceClosedWonPipelines =0;
			         	totalQualiPipelines =0;
			         	totalClosedWonPipelines = 0 ;
			         	totalPriceTargetPipelines =0;
			         	Count = 0;
					}
	             	//End total of "Other" in NCV Driver
		            
	             	for(List<Pipeline_Report__c> buList : oppMasterList)
	                {
	                    for(Pipeline_Report__c buObj : buList)
	                    {
	                        if(currentbu == buobj.Business_Unit__c)
	                        {   
		                      		totalPriceQualiPipelines = totalPriceQualiPipelines + buObj.Qualified_Pipeline_Amount__c;
		                            totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + buObj.Closed_Pipeline_Amount__c;
		                            totalQualiPipelines = totalQualiPipelines + buObj.Qualified_Pipeline_Count__c;
		                            totalClosedWonPipelines = totalClosedWonPipelines + buObj.Closed_Pipeline_Count__c;
		                            totalPriceTargetPipelines = totalPriceTargetPipelines + buObj.Target__c;	                     	                            	                            
	                        }                        
	                    }
	                }
	                OppPipelineBean bean = new OppPipelineBean();
	                bean.setBu(currentbu+' Total');
	                bean.setNcv('');
	                bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
	                bean.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
	                bean.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
					bean.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));
	    
	    			if(totalPriceTargetPipelines.round() == 0)
                    {
                        bean.setPercentBudgetWonPipelines(0);
                    }
                    else
                    {
                        Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
						bean.setPercentBudgetWonPipelines(decBudgetWon.round());                            
                    }
	    
	                bean.setTotalQualiPipelines(totalQualiPipelines.round());
	                bean.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
	                bean.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
	                beanList.add(bean);
	                totalPriceQualiPipelines =0;
		         	totalPriceClosedWonPipelines =0;
		         	totalQualiPipelines =0;
		         	totalClosedWonPipelines = 0 ;
		         	totalPriceTargetPipelines =0;		         	
             	}
             }	
	        // End Total by each Business Unit
	        // Start Total by each Business Unit and NCV Driver
	        if(!(ncvName.contains('other')))
	        {
	            for(List<Pipeline_Report__c> buList : oppMasterList)
	            {
	                for(Pipeline_Report__c buObj : buList)
	                {
		                if(ncvName == (buobj.Business_Unit__c+'+'+buobj.NCV_Driver_6__c).toLowerCase())
		                {   
	                  		Count++;
	                        totalPriceQualiPipelines = totalPriceQualiPipelines + buObj.Qualified_Pipeline_Amount__c;
	                        totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + buObj.Closed_Pipeline_Amount__c;
	                        totalQualiPipelines = totalQualiPipelines + buObj.Qualified_Pipeline_Count__c;
	                        totalClosedWonPipelines = totalClosedWonPipelines + buObj.Closed_Pipeline_Count__c;
		                    totalPriceTargetPipelines = totalPriceTargetPipelines + buObj.Target__c;
	                        ncv = buobj.NCV_Driver_6__c;	                            	                            
		                }
	                }	
	            }
	            
	            if (currentbu  == ncvbuMap.get(ncvName))
	            	currentbu = '';
	            else
	         		currentbu = ncvbuMap.get(ncvName);
	            
	            if (Count != 0)
	            {
	                OppPipelineBean bean = new OppPipelineBean();
	                bean.setBu(currentbu);
	                bean.setNcv(ncv);
	                bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
	                bean.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
	                bean.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
					bean.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));
	       			if(totalPriceTargetPipelines.round() == 0)
	                {
	                    bean.setPercentBudgetWonPipelines(0);
	                }
	                else
	                {
	                    Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
						bean.setPercentBudgetWonPipelines(decBudgetWon.round());                            
	                }
	                bean.setTotalQualiPipelines(totalQualiPipelines.round());
	                bean.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
	                bean.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
	                if(totalPriceQualiPipelines.round() == 0 && totalPriceClosedWonPipelines.round() == 0 && totalPriceTargetPipelines.round() == 0 && totalQualiPipelines.round() == 0 && totalClosedWonPipelines.round() == 0)
	                {
	                	bu = currentbu;
	                }
	                else
	                {
	                	if(bu == ncvbuMap.get(ncvName))
	                	{
	                		bean.setBu(bu);
	                		bu = '';	
	                	} 
	                	beanList.add(bean);
	                }
	                currentbu = ncvbuMap.get(ncvName);                
	            }
	        }
	        else
	        {
	        	currentbu = ncvbuMap.get(ncvName);
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
		 totalPriceQualiPipelines =0;
	     totalPriceClosedWonPipelines =0;
	     totalQualiPipelines =0;
	     totalClosedWonPipelines = 0 ;
	     totalPriceTargetPipelines =0;
	     Count = 0;
        for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
                {   
              		Count++;
                    totalPriceQualiPipelines = totalPriceQualiPipelines + buObj.Qualified_Pipeline_Amount__c;
                    totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + buObj.Closed_Pipeline_Amount__c;
                    totalQualiPipelines = totalQualiPipelines + buObj.Qualified_Pipeline_Count__c;
                    totalClosedWonPipelines = totalClosedWonPipelines + buObj.Closed_Pipeline_Count__c;
                    totalPriceTargetPipelines = totalPriceTargetPipelines + buObj.Target__c;
                    ncv = buobj.NCV_Driver_6__c;	                            	                            
                }
            }	
        }   			
		
		if(Count != 0)
		{
         	OppPipelineBean beanother = new OppPipelineBean();
            beanother.setBu('');
            beanother.setNcv(ncv);
            beanother.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
            beanother.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
            beanother.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
			beanother.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));

			if(totalPriceTargetPipelines.round() == 0)
            {
                beanother.setPercentBudgetWonPipelines(0);
            }
            else
            {
                Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
				beanother.setPercentBudgetWonPipelines(decBudgetWon.round());                            
            }

            beanother.setTotalQualiPipelines(totalQualiPipelines.round());
            beanother.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
            beanother.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
            if(totalPriceQualiPipelines.round() == 0 && totalPriceClosedWonPipelines.round() == 0 && totalPriceTargetPipelines.round() == 0 && totalQualiPipelines.round() == 0 && totalClosedWonPipelines.round() == 0)
            {
            	bu = bu;
            }
            else
            {
            	beanList.add(beanother);
            }
		}
     	//End get the Last Other of NCV Driver
        // Start Total last Business Unit and NCV Driver
        totalPriceQualiPipelines =0;
     	totalPriceClosedWonPipelines =0;
     	totalQualiPipelines =0;
     	totalClosedWonPipelines = 0 ;
        totalPriceTargetPipelines =0;
        for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c)
                {   
                  		totalPriceQualiPipelines = totalPriceQualiPipelines + buObj.Qualified_Pipeline_Amount__c;
                        totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + buObj.Closed_Pipeline_Amount__c;
                        totalQualiPipelines = totalQualiPipelines + buObj.Qualified_Pipeline_Count__c;
                        totalClosedWonPipelines = totalClosedWonPipelines + buObj.Closed_Pipeline_Count__c;
						totalPriceTargetPipelines = totalPriceTargetPipelines + buObj.Target__c;                        	                     	                            	                            
                }                        
            }
        }
        OppPipelineBean bean = new OppPipelineBean();
        bean.setBu(currentbu+' Total');
        bean.setNcv('');
        bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
        bean.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
        bean.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
		bean.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));

		if(totalPriceTargetPipelines.round() == 0)
        {
            bean.setPercentBudgetWonPipelines(0);
        }
        else
        {
            Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
			bean.setPercentBudgetWonPipelines(decBudgetWon.round());                            
        }

        bean.setTotalQualiPipelines(totalQualiPipelines.round());
        bean.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
        bean.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
        beanList.add(bean);
        //End Total last Business Unit and NCV Driver

		//Start Total of all the Fields
        totalPriceQualiPipelines =0;
     	totalPriceClosedWonPipelines =0;
     	totalQualiPipelines =0;
     	totalClosedWonPipelines = 0 ;
        totalPriceTargetPipelines =0;
        for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
              		totalPriceQualiPipelines = totalPriceQualiPipelines + buObj.Qualified_Pipeline_Amount__c;
                    totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + buObj.Closed_Pipeline_Amount__c;
                    totalQualiPipelines = totalQualiPipelines + buObj.Qualified_Pipeline_Count__c;
                    totalClosedWonPipelines = totalClosedWonPipelines + buObj.Closed_Pipeline_Count__c;
					totalPriceTargetPipelines = totalPriceTargetPipelines + buObj.Target__c;                        	                     	                            	                            
                                    
            }
        }
        OppPipelineBean beanTotal = new OppPipelineBean();
        beanTotal.setBu('Total');
        beanTotal.setNcv('');
        beanTotal.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
        beanTotal.setTotalPriceClosedWonPipelines(convert(convertthousands(totalPriceClosedWonPipelines).round()));
        beanTotal.setTotalPricePipelines(convert(convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines).round()));
		beanTotal.setTotalPriceTargetPipelines(convert(totalPriceTargetPipelines.round()));

		if(totalPriceTargetPipelines.round() == 0)
        {
            beanTotal.setPercentBudgetWonPipelines(0);
        }
        else
        {
            Decimal decBudgetWon = (convertthousands(totalPriceClosedWonPipelines+totalPriceQualiPipelines)).divide(totalPriceTargetPipelines,2,System.RoundingMode.UP);                            
			beanTotal.setPercentBudgetWonPipelines(decBudgetWon.round());                            
        }

        beanTotal.setTotalQualiPipelines(totalQualiPipelines.round());
        beanTotal.setTotalClosedWonPipelines(totalClosedWonPipelines.round());
        beanTotal.setTotalPipelines((totalQualiPipelines+totalClosedWonPipelines).round());
        beanList.add(beanTotal);
        //End Total of all the Fields
		
        
        System.debug('processMFAData: Kunal returns oppPipelineBeanList: '+beanList);
        return beanList;
    }

    public List<OppPipelineBean> getOppPipeLineBean()
    {
        return this.oppPipeLineBean;
    }
    
    public List<OppPipelineBean> getOppPipeLineBeanForBU()
    {
        return this.oppPipeLineBeanForBU;
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
    public PageReference populateData()
    {
        Decimal data_pull_date = datemap.get(selectedDate); 
        System.debug('Raj: In PopulateData');
        //System.debug('Selected Date :'+selectedDate);
        //System.debug('Selected Region :'+selectedRegion);
        //System.debug('Selected Country :'+selectedCountry);
        List<List<Pipeline_Report__c>> oppMasterList = new List<List<Pipeline_Report__c>>();
		showDataTable = true;
		selectedColumn = selectedField;
		 
        VOppPipelineMainHelper.index = 0 ;
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c , p.Business_Unit__c, p.NCV_Driver_6__c, p.Qualified_Pipeline_Amount__c, p.Qualified_Pipeline_Count__c, p.Closed_Pipeline_Amount__c, p.Closed_Pipeline_Count__c, p.Target__c from Pipeline_Report__c p Where p.Report_Name__c = '1.0 Core' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c ,p.Business_Unit__c, p.NCV_Driver_6__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
            
            //Commit Data
            mapCommit.clear();
            for(List<Pipeline_Report__c> oppCommitList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Commit__c from Pipeline_Report__c p Where p.Report_Name__c = 'Commit'and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in:selectedRegion order by p.Region__c ])       
        	{
        		for(Pipeline_Report__c commitmapobj : oppCommitList)
            	{
            		mapCommit.put(commitmapobj.Region__c,commitmapobj.Commit__c);
            	}
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c , p.Business_Unit__c, p.NCV_Driver_6__c, p.Qualified_Pipeline_Amount__c, p.Qualified_Pipeline_Count__c, p.Closed_Pipeline_Amount__c, p.Closed_Pipeline_Count__c, p.Target__c from Pipeline_Report__c p Where p.Report_Name__c = '1.0 Core'and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c, p.NCV_Driver_6__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            
            //Commit Data
            mapCommit.clear();
            for(List<Pipeline_Report__c> oppCommitList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Area__c, p.Commit__c from Pipeline_Report__c p Where p.Report_Name__c = 'Commit'and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ])       
        	{
        		for(Pipeline_Report__c commitmapobj : oppCommitList)
            	{
            		mapCommit.put(commitmapobj.Area__c,commitmapobj.Commit__c);
            	}
        	}
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c , p.Business_Unit__c, p.NCV_Driver_6__c, p.Qualified_Pipeline_Amount__c, p.Qualified_Pipeline_Count__c, p.Closed_Pipeline_Amount__c, p.Closed_Pipeline_Count__c, p.Target__c from Pipeline_Report__c p Where p.Report_Name__c = '1.0 Core'and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c, p.NCV_Driver_6__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            
            //Commit Data
            mapCommit.clear();
            for(List<Pipeline_Report__c> oppCommitList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Commit__c from Pipeline_Report__c p Where p.Report_Name__c = 'Commit'and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ])       
        	{
        		for(Pipeline_Report__c commitmapobj : oppCommitList)
            	{
            		mapCommit.put(commitmapobj.Territory_Country__c,commitmapobj.Commit__c);
            	}
        	}
        }

        oppPipeLineBean = processTeriotoryData(oppMasterList);
        oppPipeLineBeanForBU = processBUData(oppMasterList);
        return null;
    }   
}