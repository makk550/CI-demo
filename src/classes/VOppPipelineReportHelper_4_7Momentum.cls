public class VOppPipelineReportHelper_4_7Momentum 
{
	public String selectedDate = 'select';
    public List<OppPipelineBean> oppNewPipeLineBeanForMomentum ;
    Boolean showDataTable = false;
    Map<String,Decimal> datemap = new Map<String,Decimal>();
    Map<Integer,String> datedropdownmap = new Map<Integer,String>();
    
    //Getter-Setter Methods For all  variables
    public String getSelectedDate()
    {
        return this.selectedDate;
    }
    public void setSelectedDate(String selectedDate)
    {
        System.debug('Selected Date :'+selectedDate);
        this.selectedDate = selectedDate;
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
    
    public List<OppPipelineBean> processMomentumData(List<List<Pipeline_Report_Mapping__c>> oppMasterList)
    {
        List<OppPipelineBean> oppPipelineBeanList = new List<OppPipelineBean>();    
        for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
		{
	        for(Pipeline_Report_Mapping__c buObj : buList)
	        {	        	
	        	if((!(buObj.Milestone__c).contains('100')) && buObj.Milestone__c != 'Additions' && buObj.Milestone__c != 'Clo')
	        	{		        	
		            OppPipelineBean bean = new OppPipelineBean();
		            bean.setMilestone(buObj.Milestone__c);
		            bean.setBegofQtr(convert(convertthousands(buObj.Opt_beginning_qtr__c).round()));
		            bean.setTotalSM30Pipelines(convert(convertthousands(buObj.X30_Milestone__c).round()));
		            bean.setTotalSM50Pipelines(convert(convertthousands(buObj.X50_Milestone__c).round()));
		            bean.setTotalSM70Pipelines(convert(convertthousands(buObj.X70_Milestone__c).round()));
		            bean.setTotalSM90Pipelines(convert(convertthousands(buObj.X90_Milestone__c).round()));
		            bean.setTotalSMWonPipelines(convert(convertthousands(buObj.X100_Milestone__c).round()));
		            bean.setTotalSMLostPipelines(convert(convertthousands(buObj.Lost_Milestone__c).round()));
		            oppPipelineBeanList.add(bean);
	        	}		            
	        }
		}
		for(List<Pipeline_Report_Mapping__c> buList : oppMasterList)
		{
	        for(Pipeline_Report_Mapping__c buObj : buList)
	        {	        	
	        	if((buObj.Milestone__c).contains('100') || buObj.Milestone__c == 'Additions' || buObj.Milestone__c == 'Clo')
	        	{		        	
		            OppPipelineBean bean = new OppPipelineBean();
		            bean.setMilestone(buObj.Milestone__c);
		            bean.setBegofQtr(convert(convertthousands(buObj.Opt_beginning_qtr__c).round()));
		            bean.setTotalSM30Pipelines(convert(convertthousands(buObj.X30_Milestone__c).round()));
		            bean.setTotalSM50Pipelines(convert(convertthousands(buObj.X50_Milestone__c).round()));
		            bean.setTotalSM70Pipelines(convert(convertthousands(buObj.X70_Milestone__c).round()));
		            bean.setTotalSM90Pipelines(convert(convertthousands(buObj.X90_Milestone__c).round()));
		            bean.setTotalSMWonPipelines(convert(convertthousands(buObj.X100_Milestone__c).round()));
		            bean.setTotalSMLostPipelines(convert(convertthousands(buObj.Lost_Milestone__c).round()));
		            oppPipelineBeanList.add(bean);
	        	}		            
	        }
		}
		System.debug('processTeriotoryData: Raj returns oppPipelineBeanList: '+oppPipelineBeanList);
        return  oppPipelineBeanList;
    }
    public List<OppPipelineBean> getOppNewPipeLineBeanForMomentum()
    {
        return this.oppNewPipeLineBeanForMomentum;
    }
    public Boolean getShowDataTable()
    {
        return showDataTable;
    }
    public PageReference populateData()
    {
    	Decimal data_pull_date = datemap.get(selectedDate);
		System.debug('Raj: In PopulateData');
        //System.debug('Selected Date :'+selectedDate);
        //System.debug('Selected Region :'+selectedRegion);
        //System.debug('Selected Country :'+selectedCountry);
        showDataTable = true;
        VOppPipelineMainHelper.index = 7; 

        // Start Build Reports 4.7
    	List<List<Pipeline_Report_Mapping__c>> oppMasterList = new List<List<Pipeline_Report_Mapping__c>>();
        for(List<Pipeline_Report_Mapping__c> oppPipeLineList: [Select p.Data_Pull_Date__c,p.Report_Name__c, p.Milestone__c, p.Opt_beginning_qtr__c, p.X30_Milestone__c, p.X50_Milestone__c, p.X70_Milestone__c, p.X90_Milestone__c, p.X100_Milestone__c, p.Lost_Milestone__c from Pipeline_Report_Mapping__c p Where p.Report_Name__c = '4.7' and p.Data_Pull_Date__c = :data_pull_date order by p.Milestone__c])
        {
            oppMasterList.add(oppPipeLineList);
        }
        
        oppNewPipeLineBeanForMomentum = processMomentumData(oppMasterList);
        // End Build Reports 4.7
        return null;
    }    
}