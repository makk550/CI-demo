public class VOppPipelineReportHelper_3_0Core 
{
    public String[] selectedRegion = new String[]{}; 
    public String selectedDate = 'select';
    public String[] selectedArea = new String[]{};
    public String[] selectedTerritory = new String[]{};
    public List<OppPipelineBean> oppPipeLineBeanForRegion ;
    public List<OppPipelineBean> oppPipeLineBeanForBU ;
    public List<OppPipelineBean> oppPipeLineBeanForAgingRegion ;
    public List<OppPipelineBean> oppPipeLineBeanForExceptionBU ;
    public List<OppPipelineBean> oppPipeLineBeanForAvgAgeRegion;
    public List<OppPipelineBean> oppPipeLineBeanForAvgAgeBU;
    public List<OppPipelineBean> oppPipeLineBeanForAvgPriceRegion;
    public List<OppPipelineBean> oppPipeLineBeanForAvgPriceBU;
    public String selectedField = 'select';
    public String selectedColumn = '';
    public String monthFirstPull = '';
    public String monthSecondPull = '';
    public String monthThirdPull = '';
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
    VOppPipelineMainHelper.index = 2;

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
    public List<OppPipelineBean> processStageTeriotoryData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();
        String previousField = '-';
        Decimal totalPriceQualiPipelines =0;
        Decimal totalPriceActivePipelines =0;
        Decimal totalPriceStalledPipelines =0;
        Decimal totalPriceCriticalPipelines =0;
             
        Integer count =0;
        
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
                        totalPriceActivePipelines = totalPriceActivePipelines + obj.Active_Pipeline__c;
                        totalPriceStalledPipelines = totalPriceStalledPipelines + obj.Stalled_Pipeline__c;
                        totalPriceCriticalPipelines = totalPriceCriticalPipelines + obj.Critical_Pipeline__c;

                        totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                                                
                        bean.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
                        bean.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
                        bean.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));
                        bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));

                        if(totalPriceQualiPipelines.round() == 0)
                        {
                            bean.setPercentNotActivePipelines(0);
                        }
                        else
                        {
                            Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
                            bean.setPercentNotActivePipelines(dec*100);                        

                        } 
                        
                        oppPipelineBeanList.add(bean);
                        
                        totalPriceQualiPipelines =0;
                        totalPriceActivePipelines =0;
                        totalPriceStalledPipelines =0;
                        totalPriceCriticalPipelines =0;
                        
                        totalPriceActivePipelines = totalPriceActivePipelines + obj.Active_Pipeline__c;
                        totalPriceStalledPipelines = totalPriceStalledPipelines + obj.Stalled_Pipeline__c;
                        totalPriceCriticalPipelines = totalPriceCriticalPipelines + obj.Critical_Pipeline__c;

                        totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
                        
                    }
                    count ++;
                }
                else
                {

                    totalPriceActivePipelines = totalPriceActivePipelines + obj.Active_Pipeline__c;
                    totalPriceStalledPipelines = totalPriceStalledPipelines + obj.Stalled_Pipeline__c;
                    totalPriceCriticalPipelines = totalPriceCriticalPipelines + obj.Critical_Pipeline__c;

                    totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
                    
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
                    
                    bean.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
                    bean.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
                    bean.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));

                    bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
            
                    if(totalPriceQualiPipelines.round() == 0)
                    {
                        bean.setPercentNotActivePipelines(0);
                    }
                    else
                    {
                        Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
                        bean.setPercentNotActivePipelines(dec*100);                    
                    } 
                    
                    oppPipelineBeanList.add(bean);
                }
               
              previousField = currentField;
                
           }          
            
        }
        //Start Totals of Territory Data
        totalPriceQualiPipelines =0;
        totalPriceActivePipelines =0;
        totalPriceStalledPipelines =0;
        totalPriceCriticalPipelines =0;
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];

                totalPriceActivePipelines = totalPriceActivePipelines + obj.Active_Pipeline__c;
                totalPriceStalledPipelines = totalPriceStalledPipelines + obj.Stalled_Pipeline__c;
                totalPriceCriticalPipelines = totalPriceCriticalPipelines + obj.Critical_Pipeline__c;

                totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;

                
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                        OppPipelineBean bean = new OppPipelineBean();                       
						bean.setRegion('Total');
                        bean.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
                        bean.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
                        bean.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));

                        bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
            
                        if(totalPriceQualiPipelines.round() == 0)
                        {
                            bean.setPercentNotActivePipelines(0);
                        }
                        else
                        {
                            Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
                            bean.setPercentNotActivePipelines(dec*100);                    
                        } 
                    
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
    private List<OppPipelineBean> processStageBUData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        Decimal totalPriceQualiPipelines =0;
        Decimal totalPriceActivePipelines =0;
        Decimal totalPriceStalledPipelines =0;
        Decimal totalPriceCriticalPipelines =0;
        Integer Count = 0;
        String bu = '';
        String ncv;
        String currentbu = '';        

        List<OppPipelineBean> beanList = new List<OppPipelineBean>();
        for(String ncvbuName: sortArray(convertSetToArray()))
        {
            totalPriceQualiPipelines =0;
            totalPriceActivePipelines =0;
            totalPriceStalledPipelines =0;
            totalPriceCriticalPipelines =0;
            Count =0;
            
            
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
		                        totalPriceActivePipelines = totalPriceActivePipelines + buObj.Active_Pipeline__c;
		                        totalPriceStalledPipelines = totalPriceStalledPipelines + buObj.Stalled_Pipeline__c;
        		                totalPriceCriticalPipelines = totalPriceCriticalPipelines + buObj.Critical_Pipeline__c;

                		        totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
		                        ncv = buobj.NCV_Driver_6__c;	                            	                            
			                }
		                }	
		            }   			
					
					if(Count != 0)
					{
		             	OppPipelineBean beanother = new OppPipelineBean();
		                beanother.setBu('');
		                beanother.setNcv(ncv);
		                
			        	beanother.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
			            beanother.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
			            beanother.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));
			
			            beanother.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
			            
			            if(totalPriceQualiPipelines.round() == 0)
			            {
			                beanother.setPercentNotActivePipelines(0);
			            }
			            else
			            {
			                Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
			                beanother.setPercentNotActivePipelines(dec*100);
			            }
		                if(totalPriceActivePipelines.round() == 0 && totalPriceStalledPipelines.round() == 0 && totalPriceCriticalPipelines.round() == 0 && totalPriceQualiPipelines.round() == 0)
			            {
			            	//Dummy
			            	bu = bu;
			            }
			            else
			            {
			            	beanList.add(beanother);
			            }
		                totalPriceQualiPipelines =0;
			            totalPriceActivePipelines =0;
			            totalPriceStalledPipelines =0;
			            totalPriceCriticalPipelines =0;
			            Count =0;
					}
	             	//End total of "Other" in NCV Driver
		            
	             	for(List<Pipeline_Report__c> buList : oppMasterList)
	                {
	                    for(Pipeline_Report__c buObj : buList)
	                    {
	                        if(currentbu == buobj.Business_Unit__c)
	                        {   
		                      	totalPriceActivePipelines = totalPriceActivePipelines + buObj.Active_Pipeline__c;
		                        totalPriceStalledPipelines = totalPriceStalledPipelines + buObj.Stalled_Pipeline__c;
        		                totalPriceCriticalPipelines = totalPriceCriticalPipelines + buObj.Critical_Pipeline__c;

                		        totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;	                     	                            	                            
	                        }                        
	                    }
	                }
	                OppPipelineBean bean = new OppPipelineBean();
	                bean.setBu(currentbu+' Total');
	                bean.setNcv('');
	                bean.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
		            bean.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
		            bean.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));
		
		            bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
		            
		            if(totalPriceQualiPipelines.round() == 0)
		            {
		                bean.setPercentNotActivePipelines(0);
		            }
		            else
		            {
		                Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
		                bean.setPercentNotActivePipelines(dec*100);
		            }
	                beanList.add(bean);
	                
					totalPriceQualiPipelines =0;
		            totalPriceActivePipelines =0;
		            totalPriceStalledPipelines =0;
		            totalPriceCriticalPipelines =0;
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
							totalPriceActivePipelines = totalPriceActivePipelines + buObj.Active_Pipeline__c;
		                    totalPriceStalledPipelines = totalPriceStalledPipelines + buObj.Stalled_Pipeline__c;
        		            totalPriceCriticalPipelines = totalPriceCriticalPipelines + buObj.Critical_Pipeline__c;

                		    totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
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
	                bean.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
		            bean.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
		            bean.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));
		
		            bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
		            
		            if(totalPriceQualiPipelines.round() == 0)
		            {
		                bean.setPercentNotActivePipelines(0);
		            }
		            else
		            {
		                Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
		                bean.setPercentNotActivePipelines(dec*100);
		            }
	                if(totalPriceActivePipelines.round() == 0 && totalPriceStalledPipelines.round() == 0 && totalPriceCriticalPipelines.round() == 0 && totalPriceQualiPipelines.round() == 0)
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
		totalPriceQualiPipelines =0;
        totalPriceActivePipelines =0;
        totalPriceStalledPipelines =0;
        totalPriceCriticalPipelines =0;
        Count =0;
        for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
                {   
              		Count++;
					totalPriceActivePipelines = totalPriceActivePipelines + buObj.Active_Pipeline__c;
		            totalPriceStalledPipelines = totalPriceStalledPipelines + buObj.Stalled_Pipeline__c;
        		    totalPriceCriticalPipelines = totalPriceCriticalPipelines + buObj.Critical_Pipeline__c;

                	totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
                    ncv = buobj.NCV_Driver_6__c;	                            	                            
                }
            }	
        }   			
		
		if(Count != 0)
		{
         	OppPipelineBean beanother = new OppPipelineBean();
            beanother.setBu('');
            beanother.setNcv(ncv);
        	beanother.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
            beanother.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
            beanother.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));

            beanother.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
            
            if(totalPriceQualiPipelines.round() == 0)
            {
                beanother.setPercentNotActivePipelines(0);
            }
            else
            {
                Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
                beanother.setPercentNotActivePipelines(dec*100);
            }
            if(totalPriceActivePipelines.round() == 0 && totalPriceStalledPipelines.round() == 0 && totalPriceCriticalPipelines.round() == 0 && totalPriceQualiPipelines.round() == 0)
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
		totalPriceQualiPipelines =0;
        totalPriceActivePipelines =0;
        totalPriceStalledPipelines =0;
        totalPriceCriticalPipelines =0;
        Count =0;
        for(List<Pipeline_Report__c> buList : oppMasterList)
        {
            for(Pipeline_Report__c buObj : buList)
            {
                if(currentbu == buobj.Business_Unit__c)
                {   
					totalPriceActivePipelines = totalPriceActivePipelines + buObj.Active_Pipeline__c;
		            totalPriceStalledPipelines = totalPriceStalledPipelines + buObj.Stalled_Pipeline__c;
        		    totalPriceCriticalPipelines = totalPriceCriticalPipelines + buObj.Critical_Pipeline__c;

                	totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;                        	                     	                            	                            
                }                        
            }
        }
        OppPipelineBean bean = new OppPipelineBean();
        bean.setBu(currentbu+' Total');
        bean.setNcv('');
		bean.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
        bean.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
        bean.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));

        bean.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));
            
        if(totalPriceQualiPipelines.round() == 0)
        {
        	bean.setPercentNotActivePipelines(0);
        }
        else
        {
        	Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
            bean.setPercentNotActivePipelines(dec*100);
        }
        beanList.add(bean);
        //End Total last Business Unit and NCV Driver
		//Start Totals of BU Data
		totalPriceQualiPipelines =0;
        totalPriceActivePipelines =0;
        totalPriceStalledPipelines =0;
        totalPriceCriticalPipelines =0;
        
		for(List<Pipeline_Report__c> buList : oppMasterList)
        {
        	for(Pipeline_Report__c buObj : buList)
            {
                
            	totalPriceActivePipelines = totalPriceActivePipelines + buObj.Active_Pipeline__c;
                totalPriceStalledPipelines = totalPriceStalledPipelines + buObj.Stalled_Pipeline__c;
                totalPriceCriticalPipelines = totalPriceCriticalPipelines + buObj.Critical_Pipeline__c;
                totalPriceQualiPipelines = totalPriceActivePipelines + totalPriceStalledPipelines + totalPriceCriticalPipelines;
            }
        }
                    
        OppPipelineBean beanTotal = new OppPipelineBean();
        beanTotal.setBu('Total');
    	beanTotal.setTotalPriceActivePipelines(convert(convertthousands(totalPriceActivePipelines).round()));
        beanTotal.setTotalPriceStalledPipelines(convert(convertthousands(totalPriceStalledPipelines).round()));
        beanTotal.setTotalPriceCriticalPipelines(convert(convertthousands(totalPriceCriticalPipelines).round()));

        beanTotal.setTotalPriceQualiPipelines(convert(convertthousands(totalPriceQualiPipelines).round()));

        if(totalPriceQualiPipelines.round() == 0)
        {
            beanTotal.setPercentNotActivePipelines(0);
        }
        else
        {
            Decimal dec = (totalPriceStalledPipelines+totalPriceCriticalPipelines).divide(totalPriceQualiPipelines,3,System.RoundingMode.UP);                            
            beanTotal.setPercentNotActivePipelines(dec*100);
        }
            
        beanList.add(beanTotal);
				
		//End Totals of BU Data          
        System.debug('processBUData: Raj returns oppPipelineBeanList: '+beanList);
        return beanList;
    }
    
    //Start "3.3 Opportunity Aging - Region" Report Calculation
    private List<OppPipelineBean> processAgingRegionData(List<List<Pipeline_Report_Mapping__c>> oppMasterList)
    {
    	List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
        //Decimal totalPriceQualiPipelines =0;
        Decimal totalQ1PricePipelines =0;
        Decimal totalQ2PricePipelines =0;
        Decimal totalQ3PricePipelines =0;
        Integer count =0;
                        
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report_Mapping__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report_Mapping__c obj =  oppBuList[j];
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
                        System.debug('Reddy');
                        totalQ1PricePipelines = totalQ1PricePipelines + obj.Total_Pipeline_Amount_1__c;
                        System.debug('Aging Data1:'+obj.Total_Pipeline_Amount_1__c.format());
                        totalQ2PricePipelines = totalQ2PricePipelines + obj.Total_Pipeline_Amount_2__c;
                        totalQ3PricePipelines = totalQ3PricePipelines + obj.Total_Pipeline_Amount_3__c;
                        
                        System.debug('Aging Data2:'+obj.Total_Pipeline_Amount_2__c.format());
                        System.debug('Aging Data3:'+obj.Total_Pipeline_Amount_3__c.format());
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                        bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
     					bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                        bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
                        oppPipelineBeanList.add(bean);
                    
                        totalQ1PricePipelines =0;
        				totalQ2PricePipelines =0;
        				totalQ3PricePipelines =0;
        				
                        totalQ1PricePipelines = totalQ1PricePipelines + obj.Total_Pipeline_Amount_1__c;
                        totalQ2PricePipelines = totalQ2PricePipelines + obj.Total_Pipeline_Amount_2__c;
                        totalQ3PricePipelines = totalQ3PricePipelines + obj.Total_Pipeline_Amount_3__c;
                        
                    }
                    count ++;
                }
                else
                {
                    totalQ1PricePipelines = totalQ1PricePipelines + obj.Total_Pipeline_Amount_1__c;
                    totalQ2PricePipelines = totalQ2PricePipelines + obj.Total_Pipeline_Amount_2__c;
                    totalQ3PricePipelines = totalQ3PricePipelines + obj.Total_Pipeline_Amount_3__c;
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
                    bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
 					bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                    bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));
                    
                    oppPipelineBeanList.add(bean);
                }
                previousField = currentField;
            }
        }
        //Start Total Data
        totalQ1PricePipelines =0;
		totalQ2PricePipelines =0;
		totalQ3PricePipelines =0;
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report_Mapping__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report_Mapping__c obj =  oppBuList[j];
				totalQ1PricePipelines = totalQ1PricePipelines + obj.Total_Pipeline_Amount_1__c;
                totalQ2PricePipelines = totalQ2PricePipelines + obj.Total_Pipeline_Amount_2__c;
                totalQ3PricePipelines = totalQ3PricePipelines + obj.Total_Pipeline_Amount_3__c;

                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion('Total');
                    bean.setTotalQ1PricePipelines(convert(convertthousands(totalQ1PricePipelines).round()));
 					bean.setTotalQ2PricePipelines(convert(convertthousands(totalQ2PricePipelines).round()));
                    bean.setTotalQ3PricePipelines(convert(convertthousands(totalQ3PricePipelines).round()));


                    oppPipelineBeanList.add(bean);
                }
            }
        }        
        //End Total Data 
        
        System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    //End "3.3 Opportunity Aging - Region" Report Calculation
    
    //Start "3.4 Opportunity Aging - BU" Report Calculation
	private List<OppPipelineBean> processExceptionBUData(List<List<Pipeline_Report__c>> oppMasterList)
    {
		Decimal totalPriceOKPipelinesException =0;
        Decimal totalPriceStuckPipelinesException =0;
        Double totalOKPipelinesException =0;
        Double totalStuckPipelinesException = 0;
        Double totalCycleDays = 0;
		Integer Count = 0;
        String bu = '';
        String bucycledays='';
        String ncv;
        String currentbu = '';
        Decimal lastdate = 0;
        Decimal data_pull_date = datemap.get(selectedDate);
        
        // Start get the ncvbuMap
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];
                ncvbuMap.put((obj.Business_Unit__c+'+'+obj.NCV_Driver_6__c).toLowerCase(),obj.Business_Unit__c);
            }
        }
        // End get the ncvbuMap
        

		//Start Get the Average Cycle Days per BU
		Pipeline_Report_Mapping__c[] retdate = [SELECT p.Data_Pull_Date__c From Pipeline_Report_Mapping__c p Where p.Report_Name__c = '3.4' and p.Data_Pull_Date__c  <= :data_pull_date order by p.Data_Pull_Date__c DESC NULLS LAST limit 1];
		if (retdate.size() > 0)
			lastdate = retdate[0].Data_Pull_Date__c;
		else
		 	lastdate = 0;
		
	    for(List<Pipeline_Report_Mapping__c> oppBUMappingList: [Select p.Business_Unit__c,p.NCV_Driver_6__c, p.Average_cycle_days__c From Pipeline_Report_Mapping__c p Where p.Report_Name__c = '3.4' and p.Data_Pull_Date__c  = :lastdate])       
        {
        	for(Pipeline_Report_Mapping__c bumapobj : oppBUMappingList)
            {
                bucycledaysmap.put((bumapobj.Business_Unit__c+'+'+bumapobj.NCV_Driver_6__c).toLowerCase() ,bumapobj.Average_cycle_days__c);                                
            }
        } 
		//End Get the Average Cycle Days per BU
        
        List<OppPipelineBean> beanList = new List<OppPipelineBean>();
        for(String ncvbuName: sortArray(convertSetToArray()))
        {
	        totalPriceOKPipelinesException =0;
        	totalPriceStuckPipelinesException =0;
	        totalOKPipelinesException =0;
        	totalStuckPipelinesException = 0;
	        totalCycleDays = 0;
			Count =0;
            
            
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
								totalPriceOKPipelinesException = totalPriceOKPipelinesException + buObj.Pipeline_Exception_OK_Amount__c;
                                totalPriceStuckPipelinesException = totalPriceStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Amount__c;
                
                				totalOKPipelinesException = totalOKPipelinesException + buObj.Pipeline_Exception_OK_Count__c;
                				totalStuckPipelinesException = totalStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Count__c;
                    			ncv = buobj.NCV_Driver_6__c;	                            	                            
			                }
		                }	
		            }   			
					
					if(Count != 0)
					{
		            	OppPipelineBean beanother = new OppPipelineBean();
		                beanother.setBu('');
		                beanother.setNcv(ncv);
		                
			        	beanother.setTotalPriceOKPipelinesException(convert(convertthousands(totalPriceOKPipelinesException).round()));
            			beanother.setTotalPriceStuckPipelinesException(convert(convertthousands(totalPriceStuckPipelinesException).round()));
            
            			beanother.setTotalOKPipelinesException(totalOKPipelinesException.round());
            			beanother.setTotalStuckPipelinesException(totalStuckPipelinesException.round());
            
            			if (bucycledaysmap.get((currentbu+'+'+ncv).toLowerCase()) != NULL)
				        	beanother.setTotalCycleDays((bucycledaysmap.get((currentbu+'+'+ncv).toLowerCase())).round());
				        else
            				beanother.setTotalCycleDays(0);
            				
        				//System.debug('Current BU+NCV Value: '+currentbu+'+'+ncv);
        				//System.debug('BU Value: '+bucycledaysmap.get((currentbu+'+'+ncv).toLowerCase()));    			

            			beanother.setTotalPricePipelinesException(convert(convertthousands(totalPriceOKPipelinesException+totalPriceStuckPipelinesException).round()));
            			if((totalPriceOKPipelinesException + totalPriceStuckPipelinesException).Round() == 0)
            			{
                			beanother.setPercentstuckPipelinesException('-');
            			}
            			else
            			{
                			beanother.setPercentstuckPipelinesException(convert((((totalPriceStuckPipelinesException/(totalPriceOKPipelinesException + totalPriceStuckPipelinesException))*100).round())));
            			}
		                if(totalPriceOKPipelinesException.round() == 0 && totalPriceStuckPipelinesException.round() == 0 && totalOKPipelinesException.round() == 0 && totalStuckPipelinesException.round() == 0)
			            {
			            	//Dummy
			            	bu = bu;
			            }
			            else
			            {
			            	beanList.add(beanother);
			            }
		                totalPriceOKPipelinesException =0;
        				totalPriceStuckPipelinesException =0;
	        			totalOKPipelinesException =0;
        				totalStuckPipelinesException = 0;
	        			totalCycleDays = 0;
			            Count =0;
					}
             		//End total of "Other" in NCV Driver
		            
	             	for(List<Pipeline_Report__c> buList : oppMasterList)
	                {
	                	for(Pipeline_Report__c buObj : buList)
	                    {
	                    	if(currentbu == buobj.Business_Unit__c)
	                        {   
		                    	totalPriceOKPipelinesException = totalPriceOKPipelinesException + buObj.Pipeline_Exception_OK_Amount__c;
                                totalPriceStuckPipelinesException = totalPriceStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Amount__c;
                
                				totalOKPipelinesException = totalOKPipelinesException + buObj.Pipeline_Exception_OK_Count__c;
                				totalStuckPipelinesException = totalStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Count__c;	                     	                            	                            
	                        }                        
	                   	}
	                }
	                OppPipelineBean bean = new OppPipelineBean();
	                bean.setBu(currentbu+' Total');
	                bean.setNcv('');
	             	bean.setTotalPriceOKPipelinesException(convert(convertthousands(totalPriceOKPipelinesException).round()));
            		bean.setTotalPriceStuckPipelinesException(convert(convertthousands(totalPriceStuckPipelinesException).round()));
            
            		bean.setTotalOKPipelinesException(totalOKPipelinesException.round());
            		bean.setTotalStuckPipelinesException(totalStuckPipelinesException.round());
            
            		if (bucycledaysmap.get((currentbu+'+total').toLowerCase()) != NULL)
						bean.setTotalCycleDays((bucycledaysmap.get((currentbu+'+total').toLowerCase())).round());
					else
            			bean.setTotalCycleDays(0);

         			bean.setTotalPricePipelinesException(convert(convertthousands(totalPriceOKPipelinesException+totalPriceStuckPipelinesException).round()));
            		if((totalPriceOKPipelinesException + totalPriceStuckPipelinesException).Round() == 0)
            		{
                		bean.setPercentstuckPipelinesException('-');
            		}
            		else
            		{
                		bean.setPercentstuckPipelinesException(convert((((totalPriceStuckPipelinesException/(totalPriceOKPipelinesException + totalPriceStuckPipelinesException))*100).round())));
            		}
	                beanList.add(bean);
	                
					totalPriceOKPipelinesException =0;
        			totalPriceStuckPipelinesException =0;
	        		totalOKPipelinesException =0;
        			totalStuckPipelinesException = 0;
	        		totalCycleDays = 0;
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
					    	totalPriceOKPipelinesException = totalPriceOKPipelinesException + buObj.Pipeline_Exception_OK_Amount__c;
			                totalPriceStuckPipelinesException = totalPriceStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Amount__c;
                            
                          	totalOKPipelinesException = totalOKPipelinesException + buObj.Pipeline_Exception_OK_Count__c;
                            totalStuckPipelinesException = totalStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Count__c;
	                        ncv = buobj.NCV_Driver_6__c;
	                        bucycledays = buobj.Business_Unit__c; 	                            	                            
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
	                bean.setTotalPriceOKPipelinesException(convert(convertthousands(totalPriceOKPipelinesException).round()));
            		bean.setTotalPriceStuckPipelinesException(convert(convertthousands(totalPriceStuckPipelinesException).round()));
            
            		bean.setTotalOKPipelinesException(totalOKPipelinesException.round());
            		bean.setTotalStuckPipelinesException(totalStuckPipelinesException.round());
            
            		if (bucycledaysmap.get((bucycledays+'+'+ncv).toLowerCase()) != NULL)
						bean.setTotalCycleDays((bucycledaysmap.get((bucycledays+'+'+ncv).toLowerCase())).round());
					else
            			bean.setTotalCycleDays(0);

       				bean.setTotalPricePipelinesException(convert(convertthousands(totalPriceOKPipelinesException+totalPriceStuckPipelinesException).round()));
       				if((totalPriceOKPipelinesException + totalPriceStuckPipelinesException).Round() == 0)
            		{
                		bean.setPercentstuckPipelinesException('-');
            		}
            		else
            		{
                		bean.setPercentstuckPipelinesException(convert((((totalPriceStuckPipelinesException/(totalPriceOKPipelinesException + totalPriceStuckPipelinesException))*100).round())));
            		}
	                if(totalPriceOKPipelinesException.round() == 0 && totalPriceStuckPipelinesException.round() == 0 && totalOKPipelinesException.round() == 0 && totalStuckPipelinesException.round() == 0)
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
		totalPriceOKPipelinesException =0;
	    totalPriceStuckPipelinesException =0;
		totalOKPipelinesException =0;
	    totalStuckPipelinesException = 0;
		totalCycleDays = 0;
		Count =0;
	    for(List<Pipeline_Report__c> buList : oppMasterList)
	    {
	    	for(Pipeline_Report__c buObj : buList)
	        {
	        	if(currentbu == buobj.Business_Unit__c && ((buobj.NCV_Driver_6__c).toLowerCase()).contains('other'))
	            {   
	            	Count++;
			    	totalPriceOKPipelinesException = totalPriceOKPipelinesException + buObj.Pipeline_Exception_OK_Amount__c;
		            totalPriceStuckPipelinesException = totalPriceStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Amount__c;
	                            
	               	totalOKPipelinesException = totalOKPipelinesException + buObj.Pipeline_Exception_OK_Count__c;
	                totalStuckPipelinesException = totalStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Count__c;
	                ncv = buobj.NCV_Driver_6__c;	                            	                            
	             }
	         }	
	     }   			
			
		if(Count != 0)
		{
	    	OppPipelineBean beanother = new OppPipelineBean();
	        beanother.setBu('');
	        beanother.setNcv(ncv);
			beanother.setTotalPriceOKPipelinesException(convert(convertthousands(totalPriceOKPipelinesException).round()));
	        beanother.setTotalPriceStuckPipelinesException(convert(convertthousands(totalPriceStuckPipelinesException).round()));
	            
	        beanother.setTotalOKPipelinesException(totalOKPipelinesException.round());
	        beanother.setTotalStuckPipelinesException(totalStuckPipelinesException.round());
	            
	        if (bucycledaysmap.get((currentbu+'+'+ncv).toLowerCase()) != NULL)
				beanother.setTotalCycleDays((bucycledaysmap.get((currentbu+'+'+ncv).toLowerCase())).round());
		    else
	  			beanother.setTotalCycleDays(0);
	
			beanother.setTotalPricePipelinesException(convert(convertthousands(totalPriceOKPipelinesException+totalPriceStuckPipelinesException).round()));
			if((totalPriceOKPipelinesException + totalPriceStuckPipelinesException).Round() == 0)
	        {
	        	beanother.setPercentstuckPipelinesException('-');
	       	}
	        else
	        {
	        	beanother.setPercentstuckPipelinesException(convert((((totalPriceStuckPipelinesException/(totalPriceOKPipelinesException + totalPriceStuckPipelinesException))*100).round())));
	       	}
			if(totalPriceOKPipelinesException.round() == 0 && totalPriceStuckPipelinesException.round() == 0 && totalOKPipelinesException.round() == 0 && totalStuckPipelinesException.round() == 0)
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
		totalPriceOKPipelinesException =0;
	    totalPriceStuckPipelinesException =0;
		totalOKPipelinesException =0;
	    totalStuckPipelinesException = 0;
		totalCycleDays = 0;
		Count =0;
	        
		for(List<Pipeline_Report__c> buList : oppMasterList)
	    {
	    	for(Pipeline_Report__c buObj : buList)
	        {
	        	if(currentbu == buobj.Business_Unit__c)
	            {   
			    	totalPriceOKPipelinesException = totalPriceOKPipelinesException + buObj.Pipeline_Exception_OK_Amount__c;
		            totalPriceStuckPipelinesException = totalPriceStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Amount__c;
	                            
	               	totalOKPipelinesException = totalOKPipelinesException + buObj.Pipeline_Exception_OK_Count__c;
	                totalStuckPipelinesException = totalStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Count__c;
	             }                        
	         }
	    }
	    OppPipelineBean bean = new OppPipelineBean();
	    bean.setBu(currentbu+' Total');
	    bean.setNcv('');
		bean.setTotalPriceOKPipelinesException(convert(convertthousands(totalPriceOKPipelinesException).round()));
	    bean.setTotalPriceStuckPipelinesException(convert(convertthousands(totalPriceStuckPipelinesException).round()));
	            
	   	bean.setTotalOKPipelinesException(totalOKPipelinesException.round());
	    bean.setTotalStuckPipelinesException(totalStuckPipelinesException.round());
	        
	    if (bucycledaysmap.get((currentbu+'+total').toLowerCase()) != NULL)
			bean.setTotalCycleDays((bucycledaysmap.get((currentbu+'+total').toLowerCase())).round());
		else
	  		bean.setTotalCycleDays(0);
	
		bean.setTotalPricePipelinesException(convert(convertthousands(totalPriceOKPipelinesException+totalPriceStuckPipelinesException).round()));
		if((totalPriceOKPipelinesException + totalPriceStuckPipelinesException).Round() == 0)
	    {
		   	bean.setPercentstuckPipelinesException('-');
	    }
	    else
	    {
	       	bean.setPercentstuckPipelinesException(convert((((totalPriceStuckPipelinesException/(totalPriceOKPipelinesException + totalPriceStuckPipelinesException))*100).round())));
	    }
	    beanList.add(bean);
	    
		//End Total last Business Unit and NCV Driver
		//Start Totals of BU Data
		totalPriceOKPipelinesException =0;
	    totalPriceStuckPipelinesException =0;
		totalOKPipelinesException =0;
	    totalStuckPipelinesException = 0;
		totalCycleDays = 0;
	        
		for(List<Pipeline_Report__c> buList : oppMasterList)
	    {
	    	for(Pipeline_Report__c buObj : buList)
	        {
	        	totalPriceOKPipelinesException = totalPriceOKPipelinesException + buObj.Pipeline_Exception_OK_Amount__c;
	            totalPriceStuckPipelinesException = totalPriceStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Amount__c;
	                    
	       		totalOKPipelinesException = totalOKPipelinesException + buObj.Pipeline_Exception_OK_Count__c;
	            totalStuckPipelinesException = totalStuckPipelinesException + buObj.Pipeline_Exception_Stuck_Count__c;
	        }
	    }
	                    
	    OppPipelineBean beanTotal = new OppPipelineBean();
	    beanTotal.setBu('Total');
		beanTotal.setTotalPriceOKPipelinesException(convert(convertthousands(totalPriceOKPipelinesException).round()));
	    beanTotal.setTotalPriceStuckPipelinesException(convert(convertthousands(totalPriceStuckPipelinesException).round()));
	        
	   	beanTotal.setTotalOKPipelinesException(totalOKPipelinesException.round());
	    beanTotal.setTotalStuckPipelinesException(totalStuckPipelinesException.round());
	        
		beanTotal.setTotalPricePipelinesException(convert(convertthousands(totalPriceOKPipelinesException+totalPriceStuckPipelinesException).round()));
		if((totalPriceOKPipelinesException + totalPriceStuckPipelinesException).Round() == 0)
	    {
	    	beanTotal.setPercentstuckPipelinesException('-');
	    }
	    else
	    {
	    	beanTotal.setPercentstuckPipelinesException(convert((((totalPriceStuckPipelinesException/(totalPriceOKPipelinesException + totalPriceStuckPipelinesException))*100).round())));
	    }
	        
	    beanList.add(beanTotal);
					
		//End Totals of BU Data          
	    System.debug('processBUData: Raj returns oppPipelineBeanList: '+beanList);
	    return beanList;
    }
    //End "3.4 Opportunity Aging - BU" Report Calculation
    
    public List<OppPipelineBean> getOppPipeLineBeanForRegion()
    {
        return this.oppPipeLineBeanForRegion;
    }
    
    public List<OppPipelineBean> getOppPipeLineBeanForBU()
    {
        return this.oppPipeLineBeanForBU;
    }
    
    public List<OppPipelineBean> getOppPipeLineBeanForAgingRegion()
    {
        return this.oppPipeLineBeanForAgingRegion;
    }
 
    public List<OppPipelineBean> getOppPipeLineBeanForExceptionBU()
    {
        return this.oppPipeLineBeanForExceptionBU;
    }

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
    public String getMonthSecondPull()
    {
        return monthSecondPull;
    }
    public String getMonthThirdPull()
    {
        return monthThirdPull;
    }
    
    //Start Google Chart Test
 /*
    public String getChartData() 
	{ 
		GoogleViz gv = new GoogleViz();
        gv.cols = new list<GoogleViz.col> 
		{ 
			new GoogleViz.Col('col1','Region','t'),
		    new GoogleViz.Col('col2','Total Price','n')
        }; 

		List<OppPipelineBean> bean = getOppPipeLineBeanForRegion(); 
		for(OppPipelineBean b : bean)
        {	
        	Integer i = integer.valueOf((b.getTotalPriceQualiPipelines()).replace(',',''));
        	GoogleViz.row r = new GoogleViz.row();
            r.cells.add ( new GoogleViz.cell( b.getRegion() ) );
            r.cells.add ( new GoogleViz.cell( i ) );
        	
        	if(b.getRegion() != 'Total')
        		gv.addRow( r );
        		
		} 		 
		return gv.toJsonString();
	} 
*/
    //End Google Chart Test
    
    public PageReference populateData()
    {
    	Decimal data_pull_date = datemap.get(selectedDate);
		System.debug('Raj: In PopulateData');
        //System.debug('Selected Date :'+selectedDate);
        //System.debug('Selected Region :'+selectedRegion);
        //System.debug('Selected Country :'+selectedCountry);
        showDataTable = true;
        selectedColumn = selectedField;
        VOppPipelineMainHelper.index = 2; 

        // Start Build Reports 3.1, 3.2 and 3.4
    	List<List<Pipeline_Report__c>> oppMasterList = new List<List<Pipeline_Report__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Active_Pipeline__c, p.Critical_Pipeline__c, p.Stalled_Pipeline__c, p.Pipeline_Exception_OK_Amount__c, p.Pipeline_Exception_OK_Count__c, p.Pipeline_Exception_Stuck_Amount__c, p.Pipeline_Exception_Stuck_Count__c from Pipeline_Report__c p Where p.Report_Name__c = '3.1.4' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Active_Pipeline__c, p.Critical_Pipeline__c, p.Stalled_Pipeline__c, p.Pipeline_Exception_OK_Amount__c, p.Pipeline_Exception_OK_Count__c, p.Pipeline_Exception_Stuck_Amount__c, p.Pipeline_Exception_Stuck_Count__c from Pipeline_Report__c p Where p.Report_Name__c = '3.1.4' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Business_Unit__c,p.NCV_Driver_6__c, p.Active_Pipeline__c, p.Critical_Pipeline__c, p.Stalled_Pipeline__c, p.Pipeline_Exception_OK_Amount__c, p.Pipeline_Exception_OK_Count__c, p.Pipeline_Exception_Stuck_Amount__c, p.Pipeline_Exception_Stuck_Count__c from Pipeline_Report__c p Where p.Report_Name__c = '3.1.4' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c,p.NCV_Driver_6__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
        }
        oppPipeLineBeanForRegion = processStageTeriotoryData(oppMasterList);
        oppPipeLineBeanForBU = processStageBUData(oppMasterList);
        oppPipeLineBeanForExceptionBU = processExceptionBUData(oppMasterList);
        // End Build Reports 3.1, 3.2 and 3.4

		// Start Build Reports 3.3
    	List<List<Pipeline_Report_Mapping__c>> oppMasterListAging = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Total_Pipeline_Amount_1__c, p.Total_Pipeline_Amount_2__c, p.Total_Pipeline_Amount_3__c, p.Total_Pipeline_Amount_4__c, p.Total_Pipeline_Amount_5__c, p.Total_Pipeline_Amount_6__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '3.3' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterListAging.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Total_Pipeline_Amount_1__c, p.Total_Pipeline_Amount_2__c, p.Total_Pipeline_Amount_3__c, p.Total_Pipeline_Amount_4__c, p.Total_Pipeline_Amount_5__c, p.Total_Pipeline_Amount_6__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '3.3' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterListAging.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Total_Pipeline_Amount_1__c, p.Total_Pipeline_Amount_2__c, p.Total_Pipeline_Amount_3__c, p.Total_Pipeline_Amount_4__c, p.Total_Pipeline_Amount_5__c, p.Total_Pipeline_Amount_6__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '3.3' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterListAging.add(oppPipeLineList);
            }
        }
        oppPipeLineBeanForAgingRegion = processAgingRegionData(oppMasterListAging);
        // End Build Reports 3.3

		//Start Get the Aging Date of first pull of month
		if(data_pull_date != NULL)
		{
			//String sdt = (data_pull_date.format()).substring(0,2)+(data_pull_date.format()).substring(3,6)+(data_pull_date.format()).substring(7);
			//Integer mon = integer.valueOf((sdt).substring(4,6));
			String sdt;
        	Integer year = 0;
        	Integer mon = 0;
        	Integer day = 0;
        	Datetime dt;
        	List<Integer> agelist = new List<Integer>();
			
			oppagingmap.clear();
        	for(List<Pipeline_Report__c> oppAgingDateList: [Select p.Data_Pull_Date__c From Pipeline_Report__c p Where p.Report_Name__c = 'DatePull' and p.Data_Pull_Date__c <= :data_pull_date Order by p.Data_Pull_Date__c asc])       
        	{
           		for(Pipeline_Report__c obj : oppAgingDateList)
           		{
           	   		sdt = (obj.Data_Pull_Date__c.format()).substring(0,2)+(obj.Data_Pull_Date__c.format()).substring(3,6)+(obj.Data_Pull_Date__c.format()).substring(7);
           	   		year = integer.valueOf((sdt).substring(0,4));
           	   		mon = integer.valueOf((sdt).substring(4,6));
           	   		day = integer.valueOf((sdt).substring(6));
           	   
               		dt =  datetime.newinstance(year,mon,day);
               		if(oppagingmap.get(mon) == NULL)
               		{    
               			oppagingmap.put(mon,dt);
               			agelist.add(mon);
               		}                	
           		}
        	}
        	Integer mapCount = oppagingmap.size();
        	agelist.sort();
        	Integer i = 1; 					
	    	//for(Decimal Month: oppagingmap.keySet())
	    	for(Integer Month: agelist)
	        {
	        	if (mapCount == 1)
	        	{
					monthFirstPull = '$ As of '+(oppagingmap.get(Month)).format('MM/dd/yyyy');
					monthSecondPull = '';
					monthThirdPull = '';
	        	}
	        	else if (mapCount == 2)
	        	{
					if(i==1)
					{
						monthFirstPull = '$ As of '+(oppagingmap.get(Month)).format('MM/dd/yyyy');
						i++;
					}
					else
					{ 
						monthSecondPull = '$ As of '+(oppagingmap.get(Month)).format('MM/dd/yyyy');
						monthThirdPull = '';
					}
	        	}
	        	else if (mapCount == 3)
	        	{
					if(i==1)
					{
						monthFirstPull = '$ As of '+(oppagingmap.get(Month)).format('MM/dd/yyyy');
						i++;
					}
					else if(i==2)
					{ 
						monthSecondPull = '$ As of '+(oppagingmap.get(Month)).format('MM/dd/yyyy');
					}
					else 
					{ 
						monthThirdPull = '$ As of '+(oppagingmap.get(Month)).format('MM/dd/yyyy');
					}
	        	}
	        }
	    }
		else
			monthFirstPull = '$ As of';
        //End Get the Aging Date of first pull of month
        //String s1 = getChartData(); 
        return null;
    }    
}