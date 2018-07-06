public class VOppPipelineReportHelper_2_0Adoption {
	public String[] selectedRegion = new String[]{}; 
    public String selectedDate = 'select';
    public String[] selectedArea = new String[]{};
    public String[] selectedTerritory = new String[]{};
    public List<OppPipelineBean> oppPipeLineAdoptionADAM ;
    public List<OppPipelineBean> oppPipeLineAdoptionCPM ;
    public List<OppPipelineBean> oppPipeLineAdoptionSS ;
    public List<OppPipelineBean> oppPipeLineAdoptionTSO ;
    public List<OppPipelineBean> oppInvalidPipeLine ;
    public List<OppPipelineBean> oppShortClosePipeLineBeanForRegion ;
    public List<OppPipelineBean> oppShortSalesPipeLineBeanForRegion ;
    public String selectedField = 'select';
	public String selectedColumn = '';
    Boolean showDataTable = false;
    Boolean showRegionList = false;
    Boolean showAreaList = false;
    Boolean showTerritoryList = false;
    Map<String,Decimal> datemap = new Map<String,Decimal>();
    Map<Integer,String> datedropdownmap = new Map<Integer,String>();
    Map<String,String> regionmap = new Map<String,String>();
    Map<String,Decimal> TotalPipelinemap = new Map<String,Decimal>();
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
        VOppPipelineMainHelper.index = 1 ;
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
    private List<OppPipelineBean> processRegionData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        Double totalActiveLogin =0;
        Double totalInactiveLogin = 0 ;
        Double totalNoLogin = 0 ;
        Double totalLogin = 0 ;
        String currentField ;
        
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppRegionList = oppMasterList[i];
            for (Integer j = 0;j< oppRegionList.size() ; j++ )
            {
        		Pipeline_Report__c obj =  oppRegionList[j];
				
				if(selectedField == 'Region')
		        {   currentField = obj.Region__c;}
		        else if(selectedField == 'Area')
		        {   currentField = obj.Area__c; }
		        else if(selectedField == 'Territory')
		        {   currentField = obj.Territory_Country__c; }
				
				OppPipelineBean bean = new OppPipelineBean();
        		bean.setRegion(currentField);
        		bean.setTotalActiveLoginPipelines((obj.Active_Login__c).round());
        		bean.setTotalInactiveLoginPipelines((obj.Inactive_Login__c).round());
        		bean.setTotalNoLoginPipelines((obj.No_Login__c).round());
        		bean.setTotalLoginPipelines((obj.Active_Login__c + obj.Inactive_Login__c + obj.No_Login__c).round());
        		
        		if((obj.Active_Login__c + obj.Inactive_Login__c + obj.No_Login__c).round() == 0)
                {
                    bean.setPercentNotActivePipelines(0);                    
                }
                else
                {
                    Decimal dec = (decimal.valueOf(obj.Inactive_Login__c+obj.No_Login__c)).divide((decimal.valueOf(obj.Active_Login__c + obj.Inactive_Login__c + obj.No_Login__c)),3,System.RoundingMode.UP);                            
                    bean.setPercentNotActivePipelines(dec*100);                                       
                }       		
        		
        		oppPipelineBeanList.add(bean);
        		
				totalActiveLogin = totalActiveLogin + obj.Active_Login__c;
                totalInactiveLogin = totalInactiveLogin + obj.Inactive_Login__c;
                totalNoLogin = totalNoLogin + obj.No_Login__c;
				totalLogin = totalLogin + obj.Active_Login__c + obj.Inactive_Login__c + obj.No_Login__c;
            }
        }
        
        OppPipelineBean bean = new OppPipelineBean();
        bean.setRegion('Total');
        bean.setTotalActiveLoginPipelines(totalActiveLogin.round());
        bean.setTotalInactiveLoginPipelines(totalInactiveLogin.round());
        bean.setTotalNoLoginPipelines(totalNoLogin.round());
        bean.setTotalLoginPipelines(totalLogin.round());
        		
		if(totalLogin.round() == 0)
	    {
	        bean.setPercentNotActivePipelines(0);                    
	    }
	    else
	    {
	        Decimal dec = (decimal.valueOf(totalInactiveLogin + totalNoLogin)).divide((decimal.valueOf(totalLogin)),3,System.RoundingMode.UP);                            
	        bean.setPercentNotActivePipelines(dec*100);                                       
	    }
        
        oppPipelineBeanList.add(bean);
        
        System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    
    private List<OppPipelineBean> processInvalidOppData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
       	Decimal invalidPipeline =0;
        Decimal qualifiedPipeline =0;
        //String currentField ;
        
        Integer count =0;
        
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
            	Pipeline_Report__c obj =  oppBuList[j];
                                
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
                        if(obj.Report_Name__c == '2.5')
                        	invalidPipeline = invalidPipeline + obj.Stalled_Pipeline__c;
                        else
                        {
                        	qualifiedPipeline = qualifiedPipeline + obj.Active_Pipeline__c + obj.Stalled_Pipeline__c + obj.Critical_Pipeline__c;
                        }
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                                                
                        bean.setTotalPriceStalledPipelines(convert(convertthousands(invalidPipeline).round()));
                        bean.setTotalPriceQualiPipelines(convert(convertthousands(qualifiedPipeline).round()));

                        if(qualifiedPipeline.round() == 0)
                        {
                            bean.setPercentNotActivePipelines(0);
                        }
                        else
                        {
                            Decimal dec = (invalidPipeline).divide(qualifiedPipeline,3,System.RoundingMode.UP);                            
                            bean.setPercentNotActivePipelines(dec*100);                        
                        } 
                        
                        oppPipelineBeanList.add(bean);
				       	invalidPipeline =0;
        				qualifiedPipeline =0;
                        
                        if(obj.Report_Name__c == '2.5')
                        	invalidPipeline = invalidPipeline + obj.Stalled_Pipeline__c;
                        else
                        {
                        	qualifiedPipeline = qualifiedPipeline + obj.Active_Pipeline__c + obj.Stalled_Pipeline__c + obj.Critical_Pipeline__c;
                        }
                        
                    }
                    count ++;
                }
                else
                {
                    if(obj.Report_Name__c == '2.5')
                       	invalidPipeline = invalidPipeline + obj.Stalled_Pipeline__c;
                    else
                    {
                    	qualifiedPipeline = qualifiedPipeline + obj.Active_Pipeline__c + obj.Stalled_Pipeline__c + obj.Critical_Pipeline__c;
                    }                    
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
                    
                    bean.setTotalPriceStalledPipelines(convert(convertthousands(invalidPipeline).round()));
                    bean.setTotalPriceQualiPipelines(convert(convertthousands(qualifiedPipeline).round()));

                    if(qualifiedPipeline.round() == 0)
                    {
                        bean.setPercentNotActivePipelines(0);
                    }
                    else
                    {
                        Decimal dec = (invalidPipeline).divide(qualifiedPipeline,3,System.RoundingMode.UP);                            
                        bean.setPercentNotActivePipelines(dec*100);                        
                    } 
                    
                    oppPipelineBeanList.add(bean);
                }               
              previousField = currentField;                
           }          
            
        }
        //Start Totals of Invalid Territory Data
        invalidPipeline =0;
        qualifiedPipeline =0;
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];

                if(obj.Report_Name__c == '2.5')
                   	invalidPipeline = invalidPipeline + obj.Stalled_Pipeline__c;
                else
                {
                	qualifiedPipeline = qualifiedPipeline + obj.Active_Pipeline__c + obj.Stalled_Pipeline__c + obj.Critical_Pipeline__c;
                }
                
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                        OppPipelineBean bean = new OppPipelineBean();                       
						bean.setRegion('Total');
                        bean.setTotalPriceStalledPipelines(convert(convertthousands(invalidPipeline).round()));
                    	bean.setTotalPriceQualiPipelines(convert(convertthousands(qualifiedPipeline).round()));

                    	if(qualifiedPipeline.round() == 0)
                    	{
                        	bean.setPercentNotActivePipelines(0);
                    	}
                    	else
                    	{
                        	Decimal dec = (invalidPipeline).divide(qualifiedPipeline,3,System.RoundingMode.UP);                            
                        	bean.setPercentNotActivePipelines(dec*100);                        
                    	}
                        oppPipelineBeanList.add(bean);
                }
            }
        }
        
        //End Totals of Invalid Territory Data
        System.debug('processInvalidPipeline: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    //Start Calculating PipelineWon values for 2.6
    private void processPipelineWonData(List<List<Pipeline_Report__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
        Decimal totalPriceQualiPipelines =0;
        Decimal totalPriceClosedWonPipelines =0;
        Integer count =0;
		TotalPipelinemap.clear();
                        
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];
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
                
                    }
                    else
                    {
                        TotalPipelinemap.put(previousField,(totalPriceClosedWonPipelines+totalPriceQualiPipelines));
                    
                        totalPriceQualiPipelines =0;
                        totalPriceClosedWonPipelines =0;
                        
                        totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                        totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;
                    }
                    count ++;
                }
                else
                {
                    totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                    totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;
                }
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                    TotalPipelinemap.put(currentField,(totalPriceClosedWonPipelines+totalPriceQualiPipelines));
                }
                previousField = currentField;
            }
        }
        //Start Total Data
        totalPriceQualiPipelines =0;
        totalPriceClosedWonPipelines =0;
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report__c obj =  oppBuList[j];
				totalPriceQualiPipelines = totalPriceQualiPipelines + obj.Qualified_Pipeline_Amount__c;
                totalPriceClosedWonPipelines = totalPriceClosedWonPipelines + obj.Closed_Pipeline_Amount__c;

                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
					TotalPipelinemap.put('Total',(totalPriceClosedWonPipelines+totalPriceQualiPipelines));
                }
            }
        }        
        //End Total Data     
    }
    //End Calculating PipelineWon values for 2.6 
	//Start 2.6
	public List<OppPipelineBean> processStageTeriotoryData(List<List<Pipeline_Report_Mapping__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        String previousField = '-';
        Decimal totalQ1_75Pipelines =0;
        Decimal totalQ2_75Pipelines =0;
        Decimal totalQ3_75Pipelines =0;
        Decimal totalQ4_75Pipelines =0;
        
        //Decimal totalQ1_7Pipelines =0;
        //Decimal totalQ2_7Pipelines =0;
        //Decimal totalQ3_7Pipelines =0;
        //Decimal totalQ4_7Pipelines =0;
        
        Integer count =0;
        
        for(Integer p = 0 ; p < oppMasterList.size() ; p++ )
        {
            List<Pipeline_Report_Mapping__c> oppBuList = oppMasterList[p];
            for (Integer q = 0;q< oppBuList.size() ; q++ )
            {
            	Pipeline_Report_Mapping__c obj =  oppBuList[q];
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
                        totalQ1_75Pipelines = totalQ1_75Pipelines + obj.Q1_Opp_Count__c;
                        totalQ2_75Pipelines = totalQ2_75Pipelines + obj.Q2_Opp_Count__c;
                        totalQ3_75Pipelines = totalQ3_75Pipelines + obj.Q3_Opp_Count__c;
                        totalQ4_75Pipelines = totalQ4_75Pipelines + obj.Q4_Opp_Count__c;
                        
						//totalQ1_7Pipelines = totalQ1_7Pipelines + obj.Q1_Opp_Amount__c;
                        //totalQ2_7Pipelines = totalQ2_7Pipelines + obj.Q2_Opp_Amount__c;
                        //totalQ3_7Pipelines = totalQ3_7Pipelines + obj.Q3_Opp_Amount__c;
                        //totalQ4_7Pipelines = totalQ4_7Pipelines + obj.Q4_Opp_Amount__c;
                    }
                    else
                    {
                        OppPipelineBean bean = new OppPipelineBean();
                        bean.setRegion(previousField);
                        
                        if(TotalPipelinemap.get(previousField) != NULL && TotalPipelinemap.get(previousField) != 0)
                        {                        
	                        //bean.setTotal7Q1PricePipelines((totalQ1_7Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	     					//bean.setTotal7Q2PricePipelines((totalQ2_7Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	                        //bean.setTotal7Q3PricePipelines((totalQ3_7Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	                        //bean.setTotal7Q4PricePipelines((totalQ4_7Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	
							bean.setTotal75Q1PricePipelines((totalQ1_75Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	     					bean.setTotal75Q2PricePipelines((totalQ2_75Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	                        bean.setTotal75Q3PricePipelines((totalQ3_75Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
	                        bean.setTotal75Q4PricePipelines((totalQ4_75Pipelines.divide(TotalPipelinemap.get(previousField),3))*100);
                        }
                        else
                        {
                        	//bean.setTotal7Q1PricePipelines(0);
	     					//bean.setTotal7Q2PricePipelines(0);
	                        //bean.setTotal7Q3PricePipelines(0);
	                        //bean.setTotal7Q4PricePipelines(0);
	
							bean.setTotal75Q1PricePipelines(0);
	     					bean.setTotal75Q2PricePipelines(0);
	                        bean.setTotal75Q3PricePipelines(0);
	                        bean.setTotal75Q4PricePipelines(0);
                        }
                        oppPipelineBeanList.add(bean);
                        
				        totalQ1_75Pipelines =0;
        				totalQ2_75Pipelines =0;
        				totalQ3_75Pipelines =0;
        				totalQ4_75Pipelines =0;
        
        				//totalQ1_7Pipelines =0;
        				//totalQ2_7Pipelines =0;
        				//totalQ3_7Pipelines =0;
        				//totalQ4_7Pipelines =0;
                        
                        totalQ1_75Pipelines = totalQ1_75Pipelines + obj.Q1_Opp_Count__c;
                        totalQ2_75Pipelines = totalQ2_75Pipelines + obj.Q2_Opp_Count__c;
                        totalQ3_75Pipelines = totalQ3_75Pipelines + obj.Q3_Opp_Count__c;
                        totalQ4_75Pipelines = totalQ4_75Pipelines + obj.Q4_Opp_Count__c;
                        
						//totalQ1_7Pipelines = totalQ1_7Pipelines + obj.Q1_Opp_Amount__c;
                        //totalQ2_7Pipelines = totalQ2_7Pipelines + obj.Q2_Opp_Amount__c;
                        //totalQ3_7Pipelines = totalQ3_7Pipelines + obj.Q3_Opp_Amount__c;
                        //totalQ4_7Pipelines = totalQ4_7Pipelines + obj.Q4_Opp_Amount__c;
                        
                    }
                    count ++;
                }
                else
                {
					totalQ1_75Pipelines = totalQ1_75Pipelines + obj.Q1_Opp_Count__c;
                    totalQ2_75Pipelines = totalQ2_75Pipelines + obj.Q2_Opp_Count__c;
                    totalQ3_75Pipelines = totalQ3_75Pipelines + obj.Q3_Opp_Count__c;
                    totalQ4_75Pipelines = totalQ4_75Pipelines + obj.Q4_Opp_Count__c;
                    
					//totalQ1_7Pipelines = totalQ1_7Pipelines + obj.Q1_Opp_Amount__c;
                    //totalQ2_7Pipelines = totalQ2_7Pipelines + obj.Q2_Opp_Amount__c;
                    //totalQ3_7Pipelines = totalQ3_7Pipelines + obj.Q3_Opp_Amount__c;
                    //totalQ4_7Pipelines = totalQ4_7Pipelines + obj.Q4_Opp_Amount__c;                    
                }
                if(q == (oppBuList.size()-1) && p == (oppMasterList.size()-1))
                {
                    OppPipelineBean bean = new OppPipelineBean();
                    bean.setRegion(currentField);
                    
					if(TotalPipelinemap.get(currentField) != NULL && TotalPipelinemap.get(currentField) != 0)
                    {                        
                        //bean.setTotal7Q1PricePipelines((totalQ1_7Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
     					//bean.setTotal7Q2PricePipelines((totalQ2_7Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
                        //bean.setTotal7Q3PricePipelines((totalQ3_7Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
                        //bean.setTotal7Q4PricePipelines((totalQ4_7Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);

						bean.setTotal75Q1PricePipelines((totalQ1_75Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
     					bean.setTotal75Q2PricePipelines((totalQ2_75Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
                        bean.setTotal75Q3PricePipelines((totalQ3_75Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
                        bean.setTotal75Q4PricePipelines((totalQ4_75Pipelines.divide(TotalPipelinemap.get(currentField),3))*100);
                    }
                    else
                    {
                    	//bean.setTotal7Q1PricePipelines(0);
     					//bean.setTotal7Q2PricePipelines(0);
                        //bean.setTotal7Q3PricePipelines(0);
                        //bean.setTotal7Q4PricePipelines(0);

						bean.setTotal75Q1PricePipelines(0);
     					bean.setTotal75Q2PricePipelines(0);
                        bean.setTotal75Q3PricePipelines(0);
                        bean.setTotal75Q4PricePipelines(0);
                    } 
                    
                    oppPipelineBeanList.add(bean);
                }               
              previousField = currentField;                
           }          
            
        }
        //Start Totals of Territory Data
        totalQ1_75Pipelines =0;
		totalQ2_75Pipelines =0;
		totalQ3_75Pipelines =0;
		totalQ4_75Pipelines =0;

		//totalQ1_7Pipelines =0;
		//totalQ2_7Pipelines =0;
		//totalQ3_7Pipelines =0;
		//totalQ4_7Pipelines =0;
		
        for(Integer i = 0 ; i < oppMasterList.size() ; i++ )
        {
            List<Pipeline_Report_Mapping__c> oppBuList = oppMasterList[i];
            for (Integer j = 0;j< oppBuList.size() ; j++ )
            {
                Pipeline_Report_Mapping__c obj =  oppBuList[j];

				totalQ1_75Pipelines = totalQ1_75Pipelines + obj.Q1_Opp_Count__c;
                totalQ2_75Pipelines = totalQ2_75Pipelines + obj.Q2_Opp_Count__c;
                totalQ3_75Pipelines = totalQ3_75Pipelines + obj.Q3_Opp_Count__c;
                totalQ4_75Pipelines = totalQ4_75Pipelines + obj.Q4_Opp_Count__c;
                
				//totalQ1_7Pipelines = totalQ1_7Pipelines + obj.Q1_Opp_Amount__c;
                //totalQ2_7Pipelines = totalQ2_7Pipelines + obj.Q2_Opp_Amount__c;
                //totalQ3_7Pipelines = totalQ3_7Pipelines + obj.Q3_Opp_Amount__c;
                //totalQ4_7Pipelines = totalQ4_7Pipelines + obj.Q4_Opp_Amount__c;

                
                if(j == (oppBuList.size()-1) && i == (oppMasterList.size()-1))
                {
                        OppPipelineBean bean = new OppPipelineBean();                       
						bean.setRegion('Total');
						
						if(TotalPipelinemap.get('Total') != NULL && TotalPipelinemap.get('Total') != 0)
	                    {                        
	                        //bean.setTotal7Q1PricePipelines((totalQ1_7Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	     					//bean.setTotal7Q2PricePipelines((totalQ2_7Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	                        //bean.setTotal7Q3PricePipelines((totalQ3_7Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	                        //bean.setTotal7Q4PricePipelines((totalQ4_7Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	
							bean.setTotal75Q1PricePipelines((totalQ1_75Pipelines.divide((TotalPipelinemap.get('Total')),3))*100);
	     					bean.setTotal75Q2PricePipelines((totalQ2_75Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	                        bean.setTotal75Q3PricePipelines((totalQ3_75Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	                        bean.setTotal75Q4PricePipelines((totalQ4_75Pipelines.divide(TotalPipelinemap.get('Total'),3))*100);
	                    }
	                    else
	                    {
	                    	//bean.setTotal7Q1PricePipelines(0);
	     					//bean.setTotal7Q2PricePipelines(0);
	                        //bean.setTotal7Q3PricePipelines(0);
	                        //bean.setTotal7Q4PricePipelines(0);
	
							bean.setTotal75Q1PricePipelines(0);
	     					bean.setTotal75Q2PricePipelines(0);
	                        bean.setTotal75Q3PricePipelines(0);
	                        bean.setTotal75Q4PricePipelines(0);
	                    }
                    
                        oppPipelineBeanList.add(bean);
                }
            }
        }
        
        //End Totals of Territory Data
        System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    //End 2.6
    //Start 2.7
    public List<OppPipelineBean> processShortSalesData(List<List<Pipeline_Report_Mapping__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();
        String currentField ;    
        for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
		{
	        for(Pipeline_Report_Mapping__c buObj : buList)
	        {
			    if(selectedField == 'Region')
                {   currentField = buObj.Region__c;}
                else if(selectedField == 'Area')
                {   currentField = buObj.Area__c; }
                else if(selectedField == 'Territory')
                {   currentField = buObj.Territory_Country__c; }

	        	OppPipelineBean bean = new OppPipelineBean();
	            bean.setRegion(currentField);
	            bean.setAccountname(buObj.Account_Name__c);
	            bean.setAccountowner(buObj.Account_Owner__c);
	            bean.setTotalQ1PricePipelines(convert(convertthousands(buobj.Total_Pipeline_Amount_1__c).round()));
	            
	            oppPipelineBeanList.add(bean);	
	            currentField = '';            
	        }
		}
		System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    //End 2.7
    public List<OppPipelineBean> getOppPipeLineAdoptionADAM()
    {
        return this.oppPipeLineAdoptionADAM;
    }
    
    public List<OppPipelineBean> getOppPipeLineAdoptionCPM()
    {
        return this.oppPipeLineAdoptionCPM;
    }
    
    public List<OppPipelineBean> getOppPipeLineAdoptionSS()
    {
        return this.oppPipeLineAdoptionSS;
    }
    
    public List<OppPipelineBean> getOppPipeLineAdoptionTSO()
    {
        return this.oppPipeLineAdoptionTSO;
    }
    public List<OppPipelineBean> getOppInvalidPipeLine()
    {
        return this.oppInvalidPipeLine;
    }
    public List<OppPipelineBean> getOppShortClosePipeLineBeanForRegion()
    {
        return this.oppShortClosePipeLineBeanForRegion;
    }
    public List<OppPipelineBean> getOppShortSalesPipeLineBeanForRegion()
    {
        return this.oppShortSalesPipeLineBeanForRegion;
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
		
        VOppPipelineMainHelper.index = 1 ;
        if(selectedField == 'region')
        {
            //ADAM
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.1' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
            oppPipeLineAdoptionADAM = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //CPM
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.2' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
            oppPipeLineAdoptionCPM = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //SS
			for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.3' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
            oppPipeLineAdoptionSS = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //TSO
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.4' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterList.add(oppPipeLineList);
	            }
        	}
            oppPipeLineAdoptionTSO = processRegionData(oppMasterList);
            oppMasterList.clear();
            
        }
        else if(selectedField == 'area')
        {
            //ADAM
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Area__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.1' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionADAM = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //CPM
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Area__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.2' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionCPM = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //SS
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Area__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.3' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionSS = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //TSO
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Area__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.4' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionTSO = processRegionData(oppMasterList);
            oppMasterList.clear();

        }
        else if(selectedField == 'territory')
        {
            //ADAM
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Territory_Country__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.1' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionADAM = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //CPM
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Territory_Country__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.2' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionCPM = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //SS
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Territory_Country__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.3' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionSS = processRegionData(oppMasterList);
            oppMasterList.clear();
            
            //TSO
           for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Territory_Country__c, p.Active_Login__c, p.Inactive_Login__c, p.No_Login__c from Pipeline_Report__c p Where p.Report_Name__c = '2.4' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterList.add(oppPipeLineList);
            }
            oppPipeLineAdoptionTSO = processRegionData(oppMasterList);
            oppMasterList.clear();

        }
        
        //Start calculations of 2.5
		List<List<Pipeline_Report__c>> oppInvalidList = new List<List<Pipeline_Report__c>>();
		if(selectedField == 'region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Active_Pipeline__c, p.Critical_Pipeline__c, p.Stalled_Pipeline__c from Pipeline_Report__c p Where (p.Report_Name__c = '3.1.4' OR p.Report_Name__c = '2.5') and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppInvalidList.add(oppPipeLineList);
	            }
        	}
            oppInvalidPipeLine = processInvalidOppData(oppInvalidList);
            oppInvalidList.clear();
        }
        else if(selectedField == 'area')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Active_Pipeline__c, p.Critical_Pipeline__c, p.Stalled_Pipeline__c from Pipeline_Report__c p Where (p.Report_Name__c = '3.1.4' OR p.Report_Name__c = '2.5') and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppInvalidList.add(oppPipeLineList);
            }        	
            oppInvalidPipeLine = processInvalidOppData(oppInvalidList);
            oppInvalidList.clear();
        }
        else if(selectedField == 'territory')
        {
            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Active_Pipeline__c, p.Critical_Pipeline__c, p.Stalled_Pipeline__c from Pipeline_Report__c p Where (p.Report_Name__c = '3.1.4' OR p.Report_Name__c = '2.5') and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppInvalidList.add(oppPipeLineList);
            }        	
            oppInvalidPipeLine = processInvalidOppData(oppInvalidList);
            oppInvalidList.clear();
        }        
        //End calculations of 2.5
        // Start Build Reports 2.6
	        //Start Get the Pipeline Won data for Calculating % value in 2.6
	        	if(selectedField == 'Region')
		        {
		            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c , p.Business_Unit__c, p.NCV_Driver_6__c, p.Qualified_Pipeline_Amount__c, p.Qualified_Pipeline_Count__c, p.Closed_Pipeline_Amount__c, p.Closed_Pipeline_Count__c, p.Target__c from Pipeline_Report__c p Where p.Report_Name__c = '1.0 Core' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c in:selectedRegion order by p.Region__c ,p.Business_Unit__c, p.NCV_Driver_6__c])
		            {
		                oppMasterList.add(oppPipeLineList);
		            }		        	
		        }
		        else if(selectedField == 'Area')
		        {
		            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c , p.Business_Unit__c, p.NCV_Driver_6__c, p.Qualified_Pipeline_Amount__c, p.Qualified_Pipeline_Count__c, p.Closed_Pipeline_Amount__c, p.Closed_Pipeline_Count__c, p.Target__c from Pipeline_Report__c p Where p.Report_Name__c = '1.0 Core'and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c ,p.Business_Unit__c, p.NCV_Driver_6__c])
		            {
		                oppMasterList.add(oppPipeLineList);
		            }         
		        }
		         else if(selectedField == 'Territory')
		        {
		            for(List<Pipeline_Report__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c , p.Business_Unit__c, p.NCV_Driver_6__c, p.Qualified_Pipeline_Amount__c, p.Qualified_Pipeline_Count__c, p.Closed_Pipeline_Amount__c, p.Closed_Pipeline_Count__c, p.Target__c from Pipeline_Report__c p Where p.Report_Name__c = '1.0 Core'and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c ,p.Business_Unit__c, p.NCV_Driver_6__c])
		            {
		                oppMasterList.add(oppPipeLineList);
		            }         
		        }		
				processPipelineWonData(oppMasterList);
	        
	        //End Get the Pipeline Won data for Calculating % value in 2.6
    	List<List<Pipeline_Report_Mapping__c>> oppMasterListShortCloseRegion = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '2.6' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                if(oppPipeLineList.size() > 0)
	                	oppMasterListShortCloseRegion.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '2.6' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterListShortCloseRegion.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c, p.Area__c, p.Territory_Country__c, p.Q1_Opp_Count__c , p.Q1_Opp_Amount__c, p.Q2_Opp_Count__c , p.Q2_Opp_Amount__c, p.Q3_Opp_Count__c , p.Q3_Opp_Amount__c, p.Q4_Opp_Count__c , p.Q4_Opp_Amount__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '2.6' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterListShortCloseRegion.add(oppPipeLineList);
            }
        }
        oppShortClosePipeLineBeanForRegion = processStageTeriotoryData(oppMasterListShortCloseRegion);
        // End Build Reports 2.6
        // Start Build Reports 2.7
    	List<List<Pipeline_Report_Mapping__c>> oppMasterListShortSalesRegion = new List<List<Pipeline_Report_Mapping__c>>();
        if(selectedField == 'Region')
        {
            for(Integer i=0; i< selectedRegion.size(); i++)
        	{
	            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Region__c,p.Account_Name__c , p.Account_Owner__c, p.Total_Pipeline_Amount_1__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '2.7' and p.Data_Pull_Date__c = :data_pull_date and p.Region__c = :selectedRegion[i] order by p.Region__c])
	            {
	                oppMasterListShortSalesRegion.add(oppPipeLineList);
	            }
        	}
        }
        else if(selectedField == 'Area')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Area__c, p.Account_Name__c , p.Account_Owner__c, p.Total_Pipeline_Amount_1__c  from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '2.7' and p.Data_Pull_Date__c = :data_pull_date and p.Area__c in:selectedArea order by p.Area__c])
            {
                oppMasterListShortSalesRegion.add(oppPipeLineList);
            }
        }
         else if(selectedField == 'Territory')
        {
            for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c, p.Report_Name__c, p.Territory_Country__c, p.Account_Name__c, p.Account_Owner__c, p.Total_Pipeline_Amount_1__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '2.7' and p.Data_Pull_Date__c = :data_pull_date and p.Territory_Country__c in:selectedTerritory order by p.Territory_Country__c])
            {
                oppMasterListShortSalesRegion.add(oppPipeLineList);
            }
        }
        oppShortSalesPipeLineBeanForRegion = processShortSalesData(oppMasterListShortSalesRegion);
        // End Build Reports 2.7
        return null;
    }
}