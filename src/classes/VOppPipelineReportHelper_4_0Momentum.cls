public class VOppPipelineReportHelper_4_0Momentum 
{
	public String[] selectedRegion = new String[]{}; 
    public String selectedDate = 'select';
    public String[] selectedArea = new String[]{};
    public String[] selectedTerritory = new String[]{};
    public List<OppPipelineBean> oppNewPipeLineBeanForRegion ;
    public List<OppPipelineBean> oppNewPipeLineBeanForBU ;
    public List<OppPipelineBean> oppSlippedPipeLineBeanForRegion ;
    public List<OppPipelineBean> oppSlippedPipeLineBeanForBU ;
    public List<OppPipelineBean> oppLostPipeLineBeanForRegion ;
    public List<OppPipelineBean> oppLostPipeLineBeanForWinLoss ;
    public String selectedField = 'select';
    public String selectedColumn = '';
    public String monthFirstPull = '';
    Boolean showDataTable = false;
    Boolean showRegionList = false;
    Boolean showAreaList = false;
    Boolean showTerritoryList = false;
    Map<String,String> ncvbuMap = new Map<String,String>();
    Map<String,Decimal> datemap = new Map<String,Decimal>();
    Map<String,String> WLmap = new Map<String,String>();
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
    	VOppPipelineMainHelper.index = 6;

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
    public List<OppPipelineBean> processStageTeriotoryData(List<List<Pipeline_Report_Mapping__c>> oppMasterList,String cal)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
        Decimal totalQ1PricePipelines =0;
        Decimal totalQ2PricePipelines =0;
        Decimal totalQ3PricePipelines =0;
        Decimal totalQ4PricePipelines =0;
        
        Double totalQ1CountPipelines =0;
        Double totalQ2CountPipelines =0;
        Double totalQ3CountPipelines =0;
        Double totalQ4CountPipelines =0;
        
        Integer count =0;
        ncvbuMap.clear();
        
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report_Mapping__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
            	Pipeline_Report_Mapping__c obj =  oppBuList[j];
            	if(cal == 'New')
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
                        totalQ1PricePipelines = totalQ1PricePipelines + obj.Q1_Opp_Amount__c;
                        totalQ2PricePipelines = totalQ2PricePipelines + obj.Q2_Opp_Amount__c;
                        totalQ3PricePipelines = totalQ3PricePipelines + obj.Q3_Opp_Amount__c;
                        totalQ4PricePipelines = totalQ4PricePipelines + obj.Q4_Opp_Amount__c;
                        
						totalQ1CountPipelines = totalQ1CountPipelines + obj.Q1_Opp_Count__c;
                        totalQ2CountPipelines = totalQ2CountPipelines + obj.Q2_Opp_Count__c;
                        totalQ3CountPipelines = totalQ3CountPipelines + obj.Q3_Opp_Count__c;
                        totalQ4CountPipelines = totalQ4CountPipelines + obj.Q4_Opp_Count__c;
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                                                
                        bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
     					bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                        bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
                        bean.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

						bean.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
     					bean.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
                        bean.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
                        bean.setTotalQ4CountPipelines((totalQ4CountPipelines).round());

                        oppPipelineBeanList.add(bean);
				        
				        totalQ1PricePipelines =0;
        				totalQ2PricePipelines =0;
        				totalQ3PricePipelines =0;
        				totalQ4PricePipelines =0;
        
        				totalQ1CountPipelines =0;
        				totalQ2CountPipelines =0;
        				totalQ3CountPipelines =0;
        				totalQ4CountPipelines =0;
                        
                        totalQ1PricePipelines = totalQ1PricePipelines + obj.Q1_Opp_Amount__c;
                        totalQ2PricePipelines = totalQ2PricePipelines + obj.Q2_Opp_Amount__c;
                        totalQ3PricePipelines = totalQ3PricePipelines + obj.Q3_Opp_Amount__c;
                        totalQ4PricePipelines = totalQ4PricePipelines + obj.Q4_Opp_Amount__c;
                        
						totalQ1CountPipelines = totalQ1CountPipelines + obj.Q1_Opp_Count__c;
                        totalQ2CountPipelines = totalQ2CountPipelines + obj.Q2_Opp_Count__c;
                        totalQ3CountPipelines = totalQ3CountPipelines + obj.Q3_Opp_Count__c;
                        totalQ4CountPipelines = totalQ4CountPipelines + obj.Q4_Opp_Count__c;
                        
                    }
                    count ++;
                }
                else
                {
					totalQ1PricePipelines = totalQ1PricePipelines + obj.Q1_Opp_Amount__c;
                    totalQ2PricePipelines = totalQ2PricePipelines + obj.Q2_Opp_Amount__c;
                    totalQ3PricePipelines = totalQ3PricePipelines + obj.Q3_Opp_Amount__c;
                    totalQ4PricePipelines = totalQ4PricePipelines + obj.Q4_Opp_Amount__c;
                    
					totalQ1CountPipelines = totalQ1CountPipelines + obj.Q1_Opp_Count__c;
                    totalQ2CountPipelines = totalQ2CountPipelines + obj.Q2_Opp_Count__c;
                    totalQ3CountPipelines = totalQ3CountPipelines + obj.Q3_Opp_Count__c;
                    totalQ4CountPipelines = totalQ4CountPipelines + obj.Q4_Opp_Count__c;                    
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
                    
					bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
     				bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                    bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
                    bean.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

					bean.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
     				bean.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
                    bean.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
                    bean.setTotalQ4CountPipelines((totalQ4CountPipelines).round()); 
                    
                    oppPipelineBeanList.add(bean);
                }               
              previousField = currentField;                
           }          
            
        }
        //Start Totals of Territory Data
        totalQ1PricePipelines =0;
		totalQ2PricePipelines =0;
		totalQ3PricePipelines =0;
		totalQ4PricePipelines =0;

		totalQ1CountPipelines =0;
		totalQ2CountPipelines =0;
		totalQ3CountPipelines =0;
		totalQ4CountPipelines =0;
		
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report_Mapping__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report_Mapping__c obj =  oppBuList[j];

                totalQ1PricePipelines = totalQ1PricePipelines + obj.Q1_Opp_Amount__c;
                totalQ2PricePipelines = totalQ2PricePipelines + obj.Q2_Opp_Amount__c;
                totalQ3PricePipelines = totalQ3PricePipelines + obj.Q3_Opp_Amount__c;
                totalQ4PricePipelines = totalQ4PricePipelines + obj.Q4_Opp_Amount__c;
                
				totalQ1CountPipelines = totalQ1CountPipelines + obj.Q1_Opp_Count__c;
                totalQ2CountPipelines = totalQ2CountPipelines + obj.Q2_Opp_Count__c;
                totalQ3CountPipelines = totalQ3CountPipelines + obj.Q3_Opp_Count__c;
                totalQ4CountPipelines = totalQ4CountPipelines + obj.Q4_Opp_Count__c;

                
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                        OppPipelineBean bean = new OppPipelineBean();                       
						bean.setRegion('Total');
						
						bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
	     				bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
	                    bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
	                    bean.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));
	
						bean.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
	     				bean.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
	                    bean.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
	                    bean.setTotalQ4CountPipelines((totalQ4CountPipelines).round()); 
                    
                        oppPipelineBeanList.add(bean);
                }
            }
        }
        
        //End Totals of Territory Data
        System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
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
    private List<OppPipelineBean> processStageBUData(List<List<Pipeline_Report_Mapping__c>> oppMasterList)
    {
        Decimal totalQ1PricePipelines =0;
        Decimal totalQ2PricePipelines =0;
        Decimal totalQ3PricePipelines =0;
        Decimal totalQ4PricePipelines =0;
        
        Double totalQ1CountPipelines =0;
        Double totalQ2CountPipelines =0;
        Double totalQ3CountPipelines =0;
        Double totalQ4CountPipelines =0;
        Integer Count = 0;
        String bu = '';
        String ncv;
        String currentbu = '';        

        List<OppPipelineBean> beanList = new List<OppPipelineBean>();
        for(String ncvbuName: sortArray(convertSetToArray()))
        {
            totalQ1PricePipelines =0;
			totalQ2PricePipelines =0;
			totalQ3PricePipelines =0;
			totalQ4PricePipelines =0;
	
			totalQ1CountPipelines =0;
			totalQ2CountPipelines =0;
			totalQ3CountPipelines =0;
			totalQ4CountPipelines =0;
			
            Count =0;
            
            
            //Start Total by each Business Unit
	         if(currentbu != ncvbuMap.get(ncvbuName))	         
             {
             	if (currentbu != '')
              	{	             
	             	//Start total of "Other" in NCV Driver
	             	for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
		            {
		                for(Pipeline_Report_Mapping__c buObj : buList)
		                {
			                if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
			                {   
		                  		Count++;
								totalQ1PricePipelines = totalQ1PricePipelines + buobj.Q1_Opp_Amount__c;
				                totalQ2PricePipelines = totalQ2PricePipelines + buobj.Q2_Opp_Amount__c;
				                totalQ3PricePipelines = totalQ3PricePipelines + buobj.Q3_Opp_Amount__c;
				                totalQ4PricePipelines = totalQ4PricePipelines + buobj.Q4_Opp_Amount__c;
				                
								totalQ1CountPipelines = totalQ1CountPipelines + buobj.Q1_Opp_Count__c;
				                totalQ2CountPipelines = totalQ2CountPipelines + buobj.Q2_Opp_Count__c;
				                totalQ3CountPipelines = totalQ3CountPipelines + buobj.Q3_Opp_Count__c;
				                totalQ4CountPipelines = totalQ4CountPipelines + buobj.Q4_Opp_Count__c;
		                        ncv = buobj.NCV_Driver_6__c;	                            	                            
			                }
		                }	
		            }   			
					
					if(Count != 0)
					{
		             	OppPipelineBean beanother = new OppPipelineBean();
		                beanother.setBu('');
		                beanother.setNcv(ncv);
		                
						beanother.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
	     				beanother.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
	                    beanother.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
	                    beanother.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));
	
						beanother.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
	     				beanother.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
	                    beanother.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
	                    beanother.setTotalQ4CountPipelines((totalQ4CountPipelines).round());
	                    
		                if(totalQ1PricePipelines.round() == 0 && totalQ2PricePipelines.round() == 0 && totalQ3PricePipelines.round() == 0 && totalQ4PricePipelines.round() == 0 && totalQ1CountPipelines.round() == 0 && totalQ2CountPipelines.round() == 0 && totalQ3CountPipelines.round() == 0 && totalQ4CountPipelines.round() == 0)
			            {
			            	//Dummy
			            	bu = bu;
			            }
			            else
			            {
			            	beanList.add(beanother);
			            }
			            totalQ1PricePipelines =0;
						totalQ2PricePipelines =0;
						totalQ3PricePipelines =0;
						totalQ4PricePipelines =0;
				
						totalQ1CountPipelines =0;
						totalQ2CountPipelines =0;
						totalQ3CountPipelines =0;
						totalQ4CountPipelines =0;
			            Count =0;
					}
	             	//End total of "Other" in NCV Driver
		            
	             	for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
	                {
	                    for(Pipeline_Report_Mapping__c buObj : buList)
	                    {
	                        if(currentbu == buobj.Business_Unit__c)
	                        {   
								totalQ1PricePipelines = totalQ1PricePipelines + buobj.Q1_Opp_Amount__c;
				                totalQ2PricePipelines = totalQ2PricePipelines + buobj.Q2_Opp_Amount__c;
				                totalQ3PricePipelines = totalQ3PricePipelines + buobj.Q3_Opp_Amount__c;
				                totalQ4PricePipelines = totalQ4PricePipelines + buobj.Q4_Opp_Amount__c;
				                
								totalQ1CountPipelines = totalQ1CountPipelines + buobj.Q1_Opp_Count__c;
				                totalQ2CountPipelines = totalQ2CountPipelines + buobj.Q2_Opp_Count__c;
				                totalQ3CountPipelines = totalQ3CountPipelines + buobj.Q3_Opp_Count__c;
				                totalQ4CountPipelines = totalQ4CountPipelines + buobj.Q4_Opp_Count__c;	                     	                            	                            
	                        }                        
	                    }
	                }
	                OppPipelineBean bean = new OppPipelineBean();
	                bean.setBu(currentbu+' Total');
	                bean.setNcv('');
					bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
     				bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                    bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
                    bean.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

					bean.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
     				bean.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
                    bean.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
                    bean.setTotalQ4CountPipelines((totalQ4CountPipelines).round());
	                beanList.add(bean);
	                
		            totalQ1PricePipelines =0;
					totalQ2PricePipelines =0;
					totalQ3PricePipelines =0;
					totalQ4PricePipelines =0;
			
					totalQ1CountPipelines =0;
					totalQ2CountPipelines =0;
					totalQ3CountPipelines =0;
					totalQ4CountPipelines =0;
		            Count =0;		         	
             	}
             }	
	        // End Total by each Business Unit
            // Start Total by each Business Unit and NCV Driver
	        if(!(ncvbuName.contains('other')))
	        {
	            for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
	            {
	                for(Pipeline_Report_Mapping__c buObj : buList)
	                {
		                if(ncvbuName == (buobj.Business_Unit__c+'+'+buobj.NCV_Driver_6__c).toLowerCase())
		                {   
	                  		Count++;
							totalQ1PricePipelines = totalQ1PricePipelines + buobj.Q1_Opp_Amount__c;
			                totalQ2PricePipelines = totalQ2PricePipelines + buobj.Q2_Opp_Amount__c;
			                totalQ3PricePipelines = totalQ3PricePipelines + buobj.Q3_Opp_Amount__c;
			                totalQ4PricePipelines = totalQ4PricePipelines + buobj.Q4_Opp_Amount__c;
			                
							totalQ1CountPipelines = totalQ1CountPipelines + buobj.Q1_Opp_Count__c;
			                totalQ2CountPipelines = totalQ2CountPipelines + buobj.Q2_Opp_Count__c;
			                totalQ3CountPipelines = totalQ3CountPipelines + buobj.Q3_Opp_Count__c;
			                totalQ4CountPipelines = totalQ4CountPipelines + buobj.Q4_Opp_Count__c;
	                        ncv = buobj.NCV_Driver_6__c;	                            	                            
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
					bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
     				bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                    bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
                    bean.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

					bean.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
     				bean.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
                    bean.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
                    bean.setTotalQ4CountPipelines((totalQ4CountPipelines).round());
	            
	                if(totalQ1PricePipelines.round() == 0 && totalQ2PricePipelines.round() == 0 && totalQ3PricePipelines.round() == 0 && totalQ4PricePipelines.round() == 0 && totalQ1CountPipelines.round() == 0 && totalQ2CountPipelines.round() == 0 && totalQ3CountPipelines.round() == 0 && totalQ4CountPipelines.round() == 0)
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
        totalQ1PricePipelines =0;
		totalQ2PricePipelines =0;
		totalQ3PricePipelines =0;
		totalQ4PricePipelines =0;

		totalQ1CountPipelines =0;
		totalQ2CountPipelines =0;
		totalQ3CountPipelines =0;
		totalQ4CountPipelines =0;
        Count =0;
        for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
        {
            for(Pipeline_Report_Mapping__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
                {   
              		Count++;
					totalQ1PricePipelines = totalQ1PricePipelines + buobj.Q1_Opp_Amount__c;
	                totalQ2PricePipelines = totalQ2PricePipelines + buobj.Q2_Opp_Amount__c;
	                totalQ3PricePipelines = totalQ3PricePipelines + buobj.Q3_Opp_Amount__c;
	                totalQ4PricePipelines = totalQ4PricePipelines + buobj.Q4_Opp_Amount__c;
	                
					totalQ1CountPipelines = totalQ1CountPipelines + buobj.Q1_Opp_Count__c;
	                totalQ2CountPipelines = totalQ2CountPipelines + buobj.Q2_Opp_Count__c;
	                totalQ3CountPipelines = totalQ3CountPipelines + buobj.Q3_Opp_Count__c;
	                totalQ4CountPipelines = totalQ4CountPipelines + buobj.Q4_Opp_Count__c;
                    ncv = buobj.NCV_Driver_6__c;	                            	                            
                }
            }	
        }   			
		
		if(Count != 0)
		{
         	OppPipelineBean beanother = new OppPipelineBean();
            beanother.setBu('');
            beanother.setNcv(ncv);
			beanother.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
 			beanother.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
            beanother.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
            beanother.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

			beanother.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
 			beanother.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
            beanother.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
            beanother.setTotalQ4CountPipelines((totalQ4CountPipelines).round());

            if(totalQ1PricePipelines.round() == 0 && totalQ2PricePipelines.round() == 0 && totalQ3PricePipelines.round() == 0 && totalQ4PricePipelines.round() == 0 && totalQ1CountPipelines.round() == 0 && totalQ2CountPipelines.round() == 0 && totalQ3CountPipelines.round() == 0 && totalQ4CountPipelines.round() == 0)
            {
            	//Dummy
            	bu = bu;
            }
            else
            {
            	beanList.add(beanother);
            }
		}
     	//End get the Last Other of NCV Driver
        // Start Total last Business Unit and NCV Driver
        totalQ1PricePipelines =0;
		totalQ2PricePipelines =0;
		totalQ3PricePipelines =0;
		totalQ4PricePipelines =0;

		totalQ1CountPipelines =0;
		totalQ2CountPipelines =0;
		totalQ3CountPipelines =0;
		totalQ4CountPipelines =0;
        Count =0;
        for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
        {
            for(Pipeline_Report_Mapping__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c)
                {   
					totalQ1PricePipelines = totalQ1PricePipelines + buobj.Q1_Opp_Amount__c;
	                totalQ2PricePipelines = totalQ2PricePipelines + buobj.Q2_Opp_Amount__c;
	                totalQ3PricePipelines = totalQ3PricePipelines + buobj.Q3_Opp_Amount__c;
	                totalQ4PricePipelines = totalQ4PricePipelines + buobj.Q4_Opp_Amount__c;
	                
					totalQ1CountPipelines = totalQ1CountPipelines + buobj.Q1_Opp_Count__c;
	                totalQ2CountPipelines = totalQ2CountPipelines + buobj.Q2_Opp_Count__c;
	                totalQ3CountPipelines = totalQ3CountPipelines + buobj.Q3_Opp_Count__c;
	                totalQ4CountPipelines = totalQ4CountPipelines + buobj.Q4_Opp_Count__c;                        	                     	                            	                            
                }                        
            }
        }
        OppPipelineBean bean = new OppPipelineBean();
        bean.setBu(currentbu+' Total');
        bean.setNcv('');
		bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
 		bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
        bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
        bean.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

		bean.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
 		bean.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
        bean.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
        bean.setTotalQ4CountPipelines((totalQ4CountPipelines).round());
        beanList.add(bean);
        //End Total last Business Unit and NCV Driver
		//Start Totals of BU Data
		totalQ1PricePipelines =0;
		totalQ2PricePipelines =0;
		totalQ3PricePipelines =0;
		totalQ4PricePipelines =0;

		totalQ1CountPipelines =0;
		totalQ2CountPipelines =0;
		totalQ3CountPipelines =0;
		totalQ4CountPipelines =0;
        
		for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
        {
        	for(Pipeline_Report_Mapping__c buObj : buList)
            {
                
            	totalQ1PricePipelines = totalQ1PricePipelines + buObj.Q1_Opp_Amount__c;
                totalQ2PricePipelines = totalQ2PricePipelines + buObj.Q2_Opp_Amount__c;
                totalQ3PricePipelines = totalQ3PricePipelines + buObj.Q3_Opp_Amount__c;
                totalQ4PricePipelines = totalQ4PricePipelines + buObj.Q4_Opp_Amount__c;
                
				totalQ1CountPipelines = totalQ1CountPipelines + buObj.Q1_Opp_Count__c;
                totalQ2CountPipelines = totalQ2CountPipelines + buObj.Q2_Opp_Count__c;
                totalQ3CountPipelines = totalQ3CountPipelines + buObj.Q3_Opp_Count__c;
                totalQ4CountPipelines = totalQ4CountPipelines + buObj.Q4_Opp_Count__c;
            }
        }
                    
        OppPipelineBean beanTotal = new OppPipelineBean();
        beanTotal.setBu('Total');
		beanTotal.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
 		beanTotal.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
        beanTotal.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
        beanTotal.setTotalQ4PricePipelines(convert(convertthousands(totalQ4PricePipelines).round()));

		beanTotal.setTotalQ1CountPipelines((totalQ1CountPipelines).round());
 		beanTotal.setTotalQ2CountPipelines((totalQ2CountPipelines).round());
        beanTotal.setTotalQ3CountPipelines((totalQ3CountPipelines).round());
        beanTotal.setTotalQ4CountPipelines((totalQ4CountPipelines).round());
            
        beanList.add(beanTotal);
				
		//End Totals of BU Data          
        System.debug('processBUData: Raj returns oppPipelineBeanList: '+beanList);
        return beanList;
    }
	
	public List<OppPipelineBean> processLostOpportunityBUData(List<List<Pipeline_Report_Mapping__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        Decimal APM =0;
        Decimal Automation =0;
        Decimal Business_Governance =0;
        Decimal Infrastructure_Management =0;
        Decimal IT_Governance =0;
        Decimal Security =0;
        Decimal Service_Management =0;
        Decimal Mainframe =0;
        
        Integer count =0;
        
        for(List<Pipeline_Report_Mapping__c> WLList : oppMasterList)
	    {
	    	for(Pipeline_Report_Mapping__c WLObj : WLList)
	        {
				WLmap.put(WLObj.Win_Loss_Reason__c,WLObj.Win_Loss_Reason__c);        	
	        }
	    }
        
        String[] keyswl = new String[WLmap.size()];
        for(String wlName: WLmap.keySet())
        {
            keyswl[count] = wlName; 
            count ++ ;
        }
        
		for(String wlName: sortArray(keyswl))
        {
        	if(wlName != 'Duplicate')	         
            {
	        	for(List<Pipeline_Report_Mapping__c> WLList : oppMasterList)
			    {
	                for(Pipeline_Report_Mapping__c WLObj : WLList)
	                {
		                if(wlName == WLobj.Win_Loss_Reason__c)
		                {
		            		APM = APM + WLobj.APPLICATION_PERFORMANCE_MANAGEMENT__c;
	 						Automation = Automation + WLobj.AUTOMATION__c;
	 						Business_Governance = Business_Governance + WLobj.BUSINESS_GOVERNANCE__c;
							Infrastructure_Management = Infrastructure_Management + WLobj.INFRASTRUCTURE_MANAGEMENT__c;
							IT_Governance = IT_Governance + WLobj.IT_GOVERNANCE__c;
							Security = Security + WLobj.SECURITY__c;
							Service_Management = Service_Management + WLobj.SERVICE_MANAGEMENT__c;
							Mainframe = Mainframe + WLobj.MAINFRAME__c;    	
		                }
	                }
			    }
	            OppPipelineBean bean = new OppPipelineBean();
	            
	            bean.setWlReason(wlName);
	            bean.setTotalAPM(convert(convertthousands(APM).round()));
	            bean.setTotalAutomation(convert(convertthousands(Automation).round()));
	            bean.setTotalBusiness_Governance(convert(convertthousands(Business_Governance).round()));
	            bean.setTotalInfrastructure_Management(convert(convertthousands(Infrastructure_Management).round()));
	            bean.setTotalIT_Governance(convert(convertthousands(IT_Governance).round()));
	            bean.setTotalSecurity(convert(convertthousands(Security).round()));
	            bean.setTotalService_Management(convert(convertthousands(Service_Management).round()));
	            bean.setTotalMainframe(convert(convertthousands(Mainframe).round()));
	 			
	            oppPipelineBeanList.add(bean);
	            
	            APM =0;
	        	Automation =0;
	        	Business_Governance =0;
	        	Infrastructure_Management =0;
	        	IT_Governance =0;
	        	Security =0;
	        	Service_Management =0;
	        	Mainframe =0;
            }
        }        
        //Start Get the Totals with out Duplicate
        for(List<Pipeline_Report_Mapping__c> WLList : oppMasterList)
		{
        	for(Pipeline_Report_Mapping__c WLObj : WLList)
            {
            	if(WLObj.Win_Loss_Reason__c != 'Duplicate')	         
            	{
	            	APM = APM + WLobj.APPLICATION_PERFORMANCE_MANAGEMENT__c;
	 				Automation = Automation + WLobj.AUTOMATION__c;
	 				Business_Governance = Business_Governance + WLobj.BUSINESS_GOVERNANCE__c;
					Infrastructure_Management = Infrastructure_Management + WLobj.INFRASTRUCTURE_MANAGEMENT__c;
					IT_Governance = IT_Governance + WLobj.IT_GOVERNANCE__c;
					Security = Security + WLobj.SECURITY__c;
					Service_Management = Service_Management + WLobj.SERVICE_MANAGEMENT__c;
					Mainframe = Mainframe + WLobj.MAINFRAME__c;
            	}
            }
		}
		OppPipelineBean subbean = new OppPipelineBean();
            
        subbean.setWlReason('Sub-Total');
        subbean.setTotalAPM(convert(convertthousands(APM).round()));
        subbean.setTotalAutomation(convert(convertthousands(Automation).round()));
        subbean.setTotalBusiness_Governance(convert(convertthousands(Business_Governance).round()));
        subbean.setTotalInfrastructure_Management(convert(convertthousands(Infrastructure_Management).round()));
        subbean.setTotalIT_Governance(convert(convertthousands(IT_Governance).round()));
        subbean.setTotalSecurity(convert(convertthousands(Security).round()));
        subbean.setTotalService_Management(convert(convertthousands(Service_Management).round()));
        subbean.setTotalMainframe(convert(convertthousands(Mainframe).round()));
 			
        oppPipelineBeanList.add(subbean);
        
        APM =0;
    	Automation =0;
    	Business_Governance =0;
    	Infrastructure_Management =0;
    	IT_Governance =0;
    	Security =0;
    	Service_Management =0;
    	Mainframe =0;
		
        //End Get the Totals with out Duplicate
        //Start Sum of Duplicate
        for(List<Pipeline_Report_Mapping__c> WLList : oppMasterList)
		{
        	for(Pipeline_Report_Mapping__c WLObj : WLList)
            {
            	if(WLObj.Win_Loss_Reason__c == 'Duplicate')	         
            	{
	            	APM = APM + WLobj.APPLICATION_PERFORMANCE_MANAGEMENT__c;
	 				Automation = Automation + WLobj.AUTOMATION__c;
	 				Business_Governance = Business_Governance + WLobj.BUSINESS_GOVERNANCE__c;
					Infrastructure_Management = Infrastructure_Management + WLobj.INFRASTRUCTURE_MANAGEMENT__c;
					IT_Governance = IT_Governance + WLobj.IT_GOVERNANCE__c;
					Security = Security + WLobj.SECURITY__c;
					Service_Management = Service_Management + WLobj.SERVICE_MANAGEMENT__c;
					Mainframe = Mainframe + WLobj.MAINFRAME__c;
            	}
            }
		}
		OppPipelineBean dupbean = new OppPipelineBean();
            
        dupbean.setWlReason('Duplicate');
        dupbean.setTotalAPM(convert(convertthousands(APM).round()));
        dupbean.setTotalAutomation(convert(convertthousands(Automation).round()));
        dupbean.setTotalBusiness_Governance(convert(convertthousands(Business_Governance).round()));
        dupbean.setTotalInfrastructure_Management(convert(convertthousands(Infrastructure_Management).round()));
        dupbean.setTotalIT_Governance(convert(convertthousands(IT_Governance).round()));
        dupbean.setTotalSecurity(convert(convertthousands(Security).round()));
        dupbean.setTotalService_Management(convert(convertthousands(Service_Management).round()));
        dupbean.setTotalMainframe(convert(convertthousands(Mainframe).round()));
 			
        oppPipelineBeanList.add(dupbean);
        
        APM =0;
    	Automation =0;
    	Business_Governance =0;
    	Infrastructure_Management =0;
    	IT_Governance =0;
    	Security =0;
    	Service_Management =0;
    	Mainframe =0;
		
        //End Sum of Duplicate 
        //Start Get the Totals
        for(List<Pipeline_Report_Mapping__c> WLList : oppMasterList)
		{
        	for(Pipeline_Report_Mapping__c WLObj : WLList)
            {
        		APM = APM + WLobj.APPLICATION_PERFORMANCE_MANAGEMENT__c;
 				Automation = Automation + WLobj.AUTOMATION__c;
 				Business_Governance = Business_Governance + WLobj.BUSINESS_GOVERNANCE__c;
				Infrastructure_Management = Infrastructure_Management + WLobj.INFRASTRUCTURE_MANAGEMENT__c;
				IT_Governance = IT_Governance + WLobj.IT_GOVERNANCE__c;
				Security = Security + WLobj.SECURITY__c;
				Service_Management = Service_Management + WLobj.SERVICE_MANAGEMENT__c;
				Mainframe = Mainframe + WLobj.MAINFRAME__c;            	
            }
		}
		OppPipelineBean bean = new OppPipelineBean();
            
        bean.setWlReason('Grand-Total');
        bean.setTotalAPM(convert(convertthousands(APM).round()));
        bean.setTotalAutomation(convert(convertthousands(Automation).round()));
        bean.setTotalBusiness_Governance(convert(convertthousands(Business_Governance).round()));
        bean.setTotalInfrastructure_Management(convert(convertthousands(Infrastructure_Management).round()));
        bean.setTotalIT_Governance(convert(convertthousands(IT_Governance).round()));
        bean.setTotalSecurity(convert(convertthousands(Security).round()));
        bean.setTotalService_Management(convert(convertthousands(Service_Management).round()));
        bean.setTotalMainframe(convert(convertthousands(Mainframe).round()));
 			
        oppPipelineBeanList.add(bean);
        
        APM =0;
    	Automation =0;
    	Business_Governance =0;
    	Infrastructure_Management =0;
    	IT_Governance =0;
    	Security =0;
    	Service_Management =0;
    	Mainframe =0;
		
        //End Get the Totals
        System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    
    public List<OppPipelineBean> getOppNewPipeLineBeanForRegion()
    {
        return this.oppNewPipeLineBeanForRegion;
    }    
    public List<OppPipelineBean> getOppNewPipeLineBeanForBU()
    {
        return this.oppNewPipeLineBeanForBU;
    }
    public List<OppPipelineBean> getOppSlippedPipeLineBeanForRegion()
    {
        return this.oppSlippedPipeLineBeanForRegion;
    }    
    public List<OppPipelineBean> getOppSlippedPipeLineBeanForBU()
    {
        return this.oppSlippedPipeLineBeanForBU;
    }    
    public List<OppPipelineBean> getOppLostPipeLineBeanForRegion()
    {
        return this.oppLostPipeLineBeanForRegion;
    }
    public List<OppPipelineBean> getOppLostPipeLineBeanForWinLoss()
    {
        return this.oppLostPipeLineBeanForWinLoss;
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
        System.debug('Selected Date :'+selectedDate);
        System.debug('Selected Decimal Date :'+data_pull_date.format());
        System.debug('Selected Region :'+selectedRegion);
        //System.debug('Selected Country :'+selectedCountry);
        showDataTable = true;
        selectedColumn = selectedField;
        VOppPipelineMainHelper.index = 6; 

        // Start Build Reports 4.1 and 4.2
        List<List<Pipeline_Report_Mapping__c>> oppMasterList = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.1.2' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.1.2' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.1.2' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
        }
        oppNewPipeLineBeanForRegion = processStageTeriotoryData(oppMasterList,'New');
        oppNewPipeLineBeanForBU = processStageBUData(oppMasterList);
        // End Build Reports 4.1 and 4.2
        // Start Build Reports 4.3 and 4.4
        List<List<Pipeline_Report_Mapping__c>> oppMasterListSlipped = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.3.4' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
	            {
	                oppMasterListSlipped.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.3.4' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterListSlipped.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.3.4' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterListSlipped.add(oppPipeLineList);
            }
        }
        oppSlippedPipeLineBeanForRegion = processStageTeriotoryData(oppMasterListSlipped,'New');
        oppSlippedPipeLineBeanForBU = processStageBUData(oppMasterListSlipped);
        // End Build Reports 4.3 and 4.4
        
        // Start Build Reports 4.5
    	List<List<Pipeline_Report_Mapping__c>> oppMasterListLostRegion = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.5' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterListLostRegion.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.5' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterListLostRegion.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.5' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterListLostRegion.add(oppPipeLineList);
            }
        }
        oppLostPipeLineBeanForRegion = processStageTeriotoryData(oppMasterListLostRegion,'Lost');
        // End Build Reports 4.5
        // Start Build Reports 4.6
    	List<List<Pipeline_Report_Mapping__c>> oppMasterListLostBU = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.APPLICATION_PERFORMANCE_MANAGEMENT__c, p.AUTOMATION__c, p.BUSINESS_GOVERNANCE__c, p.INFRASTRUCTURE_MANAGEMENT__c, p.IT_GOVERNANCE__c, p.SECURITY__c, p.SERVICE_MANAGEMENT__c, p.MAINFRAME__c, p.Win_Loss_Reason__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.6' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Win_Loss_Reason__c])
	            {
	                oppMasterListLostBU.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.APPLICATION_PERFORMANCE_MANAGEMENT__c, p.AUTOMATION__c, p.BUSINESS_GOVERNANCE__c, p.INFRASTRUCTURE_MANAGEMENT__c, p.IT_GOVERNANCE__c, p.SECURITY__c, p.SERVICE_MANAGEMENT__c, p.MAINFRAME__c, p.Win_Loss_Reason__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.6' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Win_Loss_Reason__c])
            {
                oppMasterListLostBU.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.APPLICATION_PERFORMANCE_MANAGEMENT__c, p.AUTOMATION__c, p.BUSINESS_GOVERNANCE__c, p.INFRASTRUCTURE_MANAGEMENT__c, p.IT_GOVERNANCE__c, p.SECURITY__c, p.SERVICE_MANAGEMENT__c, p.MAINFRAME__c, p.Win_Loss_Reason__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.6' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Win_Loss_Reason__c])
            {
                oppMasterListLostBU.add(oppPipeLineList);
            }
        }
        oppLostPipeLineBeanForWinLoss = processLostOpportunityBUData(oppMasterListLostBU);
        // End Build Reports 4.6
        return null;
    }
}