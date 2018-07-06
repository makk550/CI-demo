public class OppPipelineBean
{
    String region ; 
    String bu;
    String ncv;
    String totalPriceQualiPipelines ;
    String totalPriceClosedWonPipelines ;
    String totalPriceCommitPipelines ;
    String totalPriceTargetPipelines ;
    Long percentCommitBudgetPipelines;
    Long percentCommitWonPipelines;
    Long percentBudgetWonPipelines;
	    
    Long totalActiveLoginPipelines;
    Long totalInactiveLoginPipelines;
    Long totalNoLoginPipelines;
    Long totalLoginPipelines;
    
    String totalPriceActivePipelines;
    String totalPriceStalledPipelines;
    String totalPriceCriticalPipelines;
    Decimal percentNotActivePipelines;

    String totalPriceOKPipelinesException;
    String totalPriceStuckPipelinesException;

    Long totalOKPipelinesException = 0;
    Long totalStuckPipelinesException = 0;
    Long totalCycleDays = 0;

    String totalPricePipelinesException;
    String percentstuckPipelinesException;

    Long totalQualiPipelines =0;
    Long totalClosedWonPipelines =0;
    String totalPricePipelines ;
    Long totalPipelines =0;

    String totalSM30Pipelines;
    String totalSM50Pipelines;
    String totalSM70Pipelines;
    String totalSM90Pipelines;
    String totalSMWonPipelines;
    
    String totalQ1PricePipelines;
    String totalQ2PricePipelines;
    String totalQ3PricePipelines;
    String totalQ4PricePipelines;
    Long totalQ1CountPipelines;
    Long totalQ2CountPipelines;
    Long totalQ3CountPipelines;
    Long totalQ4CountPipelines;
    
    String totalAPM;
    String totalAutomation;
    String totalBusiness_Governance;
    String totalInfrastructure_Management;
    String totalIT_Governance;
    String totalSecurity;
    String totalService_Management;
    String totalMainframe;
    String wlReason;
    
    String milestone;
    String begofQtr;
    String totalSMLostPipelines;
    
    String accountname;
    String accountowner;
    
    Decimal total75Q1PricePipelines;
    Decimal total75Q2PricePipelines;
    Decimal total75Q3PricePipelines;
    Decimal total75Q4PricePipelines;
    Decimal total7Q1PricePipelines;
    Decimal total7Q2PricePipelines;
    Decimal total7Q3PricePipelines;
    Decimal total7Q4PricePipelines;    
    
    public String getRegion()
    {
        return this.region;
    }
    public void setRegion(String region)
    {
        this.region = region;
    }

    public String getBu()
    {
        return this.bu;
    }
    public void setBu(String bu)
    {
        this.bu = bu;
    }

	public String getNcv()
    {
        return this.ncv;
    }
    public void setNcv(String ncv)
    {
        this.ncv = ncv;
    }

    public String getTotalPriceQualiPipelines()
    {
        return this.totalPriceQualiPipelines;
    }
    public void setTotalPriceQualiPipelines(String totalPriceQualiPipelines)
    {
        this.totalPriceQualiPipelines = totalPriceQualiPipelines;
    }

    public String getTotalPriceClosedWonPipelines()
    {
        return this.totalPriceClosedWonPipelines;
    }
    public void setTotalPriceClosedWonPipelines(String totalPriceClosedWonPipelines)
    {
        this.totalPriceClosedWonPipelines = totalPriceClosedWonPipelines;
    }

	public String getTotalPriceCommitPipelines()
    {
        return this.totalPriceCommitPipelines;
    }
    public void setTotalPriceCommitPipelines(String totalPriceCommitPipelines)
    {
        this.totalPriceCommitPipelines = totalPriceCommitPipelines;
    }
	
	public String getTotalPriceTargetPipelines()
    {
        return this.totalPriceTargetPipelines;
    }
    public void setTotalPriceTargetPipelines(String totalPriceTargetPipelines)
    {
        this.totalPriceTargetPipelines = totalPriceTargetPipelines;
    }
    
    public Long getPercentCommitBudgetPipelines()
    {
        return this.percentCommitBudgetPipelines;
    }
    public void setPercentCommitBudgetPipelines(Long percentCommitBudgetPipelines)
    {
        this.percentCommitBudgetPipelines = percentCommitBudgetPipelines;
    }
    
    public Long getPercentCommitWonPipelines()
    {
        return this.percentCommitWonPipelines;
    }
    public void setPercentCommitWonPipelines(Long percentCommitWonPipelines)
    {
        this.percentCommitWonPipelines = percentCommitWonPipelines;
    }
    
    public Long getPercentBudgetWonPipelines()
    {
        return this.percentBudgetWonPipelines;
    }
    public void setPercentBudgetWonPipelines(Long percentBudgetWonPipelines)
    {
        this.percentBudgetWonPipelines = percentBudgetWonPipelines;
    }
    
    public Long getTotalActiveLoginPipelines()
    {
        return this.totalActiveLoginPipelines;
    }
    public void setTotalActiveLoginPipelines(Long totalActiveLoginPipelines)
    {
        this.totalActiveLoginPipelines = totalActiveLoginPipelines;
    }
    
    public Long getTotalInactiveLoginPipelines()
    {
        return this.totalInactiveLoginPipelines;
    }
    public void setTotalInactiveLoginPipelines(Long totalInactiveLoginPipelines)
    {
        this.totalInactiveLoginPipelines = totalInactiveLoginPipelines;
    }
    
    public Long getTotalNoLoginPipelines()
    {
        return this.totalNoLoginPipelines;
    }
    public void setTotalNoLoginPipelines(Long totalNoLoginPipelines)
    {
        this.totalNoLoginPipelines = totalNoLoginPipelines;
    }
    
    public Long getTotalLoginPipelines()
    {
        return this.totalLoginPipelines;
    }
    public void setTotalLoginPipelines(Long totalLoginPipelines)
    {
        this.totalLoginPipelines = totalLoginPipelines;
    }
    
    
    public String getTotalPricePipelines()
    {
        return this.totalPricePipelines ;
    }
    public void setTotalPricePipelines(String totalPricePipelines)
    {
        this.totalPricePipelines = totalPricePipelines;
    }

    public Long getTotalQualiPipelines()
    {
        return this.totalQualiPipelines;
    }
    public void setTotalQualiPipelines(Long totalQualiPipelines)
    {
        this.totalQualiPipelines = totalQualiPipelines;
    }

    public Long getTotalClosedWonPipelines()
    {
        return this.totalClosedWonPipelines;
    }
    public void setTotalClosedWonPipelines(Long totalClosedWonPipelines)
    {
        this.totalClosedWonPipelines = totalClosedWonPipelines;
    }
    
    public Long getTotalPipelines()
    {
        return this.totalPipelines;
    }
    public void setTotalPipelines(Long totalPipelines)
    {
        this.totalPipelines = totalPipelines;
    }

    public String getTotalPriceActivePipelines()
    {
        return this.totalPriceActivePipelines;
    }
    public void setTotalPriceActivePipelines(String totalPriceActivePipelines)
    {
        this.totalPriceActivePipelines = totalPriceActivePipelines;
    }

    public String getTotalPriceStalledPipelines()
    {
        return this.totalPriceStalledPipelines;
    }
    public void setTotalPriceStalledPipelines(String totalPriceStalledPipelines)
    {
        this.totalPriceStalledPipelines = totalPriceStalledPipelines;
    }

    public String getTotalPriceCriticalPipelines()
    {
        return this.totalPriceCriticalPipelines;
    }
    public void setTotalPriceCriticalPipelines(String totalPriceCriticalPipelines)
    {
        this.totalPriceCriticalPipelines = totalPriceCriticalPipelines;
    }

    public Decimal getPercentNotActivePipelines()
    {
        return this.percentNotActivePipelines;
    }
    public void setPercentNotActivePipelines(Decimal percentNotActivePipelines)
    {
        this.percentNotActivePipelines = percentNotActivePipelines;
    }

    public String getTotalPriceOKPipelinesException()
    {
        return this.totalPriceOKPipelinesException;
    }
    public void setTotalPriceOKPipelinesException(String totalPriceOKPipelinesException)
    {
        this.totalPriceOKPipelinesException = totalPriceOKPipelinesException;
    }

    public String getTotalPriceStuckPipelinesException()
    {
        return this.totalPriceStuckPipelinesException;
    }
    public void setTotalPriceStuckPipelinesException(String totalPriceStuckPipelinesException)
    {
        this.totalPriceStuckPipelinesException = totalPriceStuckPipelinesException;
    }

    public Long getTotalOKPipelinesException()
    {
        return this.totalOKPipelinesException;
    }
    public void setTotalOKPipelinesException(Long totalOKPipelinesException)
    {
        this.totalOKPipelinesException = totalOKPipelinesException;
    }

    public Long getTotalStuckPipelinesException()
    {
        return this.totalStuckPipelinesException;
    }
    public void setTotalStuckPipelinesException(Long totalStuckPipelinesException)
    {
        this.totalStuckPipelinesException = totalStuckPipelinesException;
    }

    public Long getTotalCycleDays()
    {
        return this.totalCycleDays;
    }
    public void setTotalCycleDays(Long totalCycleDays)
    {
        this.totalCycleDays = totalCycleDays;
    }

    public String getTotalPricePipelinesException()
    {
        return this.totalPricePipelinesException;
    }
    public void setTotalPricePipelinesException(String totalPricePipelinesException)
    {
        this.totalPricePipelinesException = totalPricePipelinesException;
    }

    public String getPercentstuckPipelinesException()
    {
        return this.percentstuckPipelinesException;
    }
    public void setPercentstuckPipelinesException(String percentstuckPipelinesException)
    {
        this.percentstuckPipelinesException = percentstuckPipelinesException;
    }

    public String getTotalSM30Pipelines()
    {
        return this.totalSM30Pipelines;
    }
    public void setTotalSM30Pipelines(String totalSM30Pipelines)
    {
        this.totalSM30Pipelines = totalSM30Pipelines;
    }

    public String getTotalSM50Pipelines()
    {
        return this.totalSM50Pipelines;
    }
    public void setTotalSM50Pipelines(String totalSM50Pipelines)
    {
        this.totalSM50Pipelines = totalSM50Pipelines;
    }

    public String getTotalSM70Pipelines()
    {
        return this.totalSM70Pipelines;
    }
    public void setTotalSM70Pipelines(String totalSM70Pipelines)
    {
        this.totalSM70Pipelines = totalSM70Pipelines;
    }

    public String getTotalSM90Pipelines()
    {
        return this.totalSM90Pipelines;
    }
    public void setTotalSM90Pipelines(String totalSM90Pipelines)
    {
        this.totalSM90Pipelines = totalSM90Pipelines;
    }

    public String getTotalSMWonPipelines()
    {
        return this.totalSMWonPipelines;
    }
    public void setTotalSMWonPipelines(String totalSMWonPipelines)
    {
        this.totalSMWonPipelines = totalSMwonPipelines;
    }
    
    public String getTotalQ1PricePipelines()
    {
        return this.totalQ1PricePipelines;
    }
    public void setTotalQ1PricePipelines(String totalQ1PricePipelines)
    {
        this.totalQ1PricePipelines = totalQ1PricePipelines;
    }
    public String getTotalQ2PricePipelines()
    {
        return this.totalQ2PricePipelines;
    }
    public void setTotalQ2PricePipelines(String totalQ2PricePipelines)
    {
        this.totalQ2PricePipelines = totalQ2PricePipelines;
    }
    public String getTotalQ3PricePipelines()
    {
        return this.totalQ3PricePipelines;
    }
    public void setTotalQ3PricePipelines(String totalQ3PricePipelines)
    {
        this.totalQ3PricePipelines = totalQ3PricePipelines;
    }
    public String getTotalQ4PricePipelines()
    {
        return this.totalQ4PricePipelines;
    }
    public void setTotalQ4PricePipelines(String totalQ4PricePipelines)
    {
        this.totalQ4PricePipelines = totalQ4PricePipelines;
    }
    
    public Long getTotalQ1CountPipelines()
    {
        return this.totalQ1CountPipelines;
    }
    public void setTotalQ1CountPipelines(Long totalQ1CountPipelines)
    {
        this.totalQ1CountPipelines = totalQ1CountPipelines;
    }
    public Long getTotalQ2CountPipelines()
    {
        return this.totalQ2CountPipelines;
    }
    public void setTotalQ2CountPipelines(Long totalQ2CountPipelines)
    {
        this.totalQ2CountPipelines = totalQ2CountPipelines;
    }
    public Long getTotalQ3CountPipelines()
    {
        return this.totalQ3CountPipelines;
    }
    public void setTotalQ3CountPipelines(Long totalQ3CountPipelines)
    {
        this.totalQ3CountPipelines = totalQ3CountPipelines;
    }
    public Long getTotalQ4CountPipelines()
    {
        return this.totalQ4CountPipelines;
    }
    public void setTotalQ4CountPipelines(Long totalQ4CountPipelines)
    {
        this.totalQ4CountPipelines = totalQ4CountPipelines;
    }
    
    public String getTotalAPM()
    {
        return this.totalAPM;
    }
    public void setTotalAPM(String totalAPM)
    {
        this.totalAPM = totalAPM;
    }
    public String getTotalAutomation()
    {
        return this.totalAutomation;
    }
    public void setTotalAutomation(String totalAutomation)
    {
        this.totalAutomation = totalAutomation;
    }
    public String getTotalBusiness_Governance()
    {
        return this.totalBusiness_Governance;
    }
    public void setTotalBusiness_Governance(String totalBusiness_Governance)
    {
        this.totalBusiness_Governance = totalBusiness_Governance;
    }
    public String getTotalInfrastructure_Management()
    {
        return this.totalInfrastructure_Management;
    }
    public void setTotalInfrastructure_Management(String totalInfrastructure_Management)
    {
        this.totalInfrastructure_Management = totalInfrastructure_Management;
    }
    public String getTotalIT_Governance()
    {
        return this.totalIT_Governance;
    }
    public void setTotalIT_Governance(String totalIT_Governance)
    {
        this.totalIT_Governance = totalIT_Governance;
    }
    public String getTotalSecurity()
    {
        return this.totalSecurity;
    }
    public void setTotalSecurity(String totalSecurity)
    {
        this.totalSecurity = totalSecurity;
    }
    public String getTotalService_Management()
    {
        return this.totalService_Management;
    }
    public void setTotalService_Management(String totalService_Management)
    {
        this.totalService_Management = totalService_Management;
    }
    public String getTotalMainframe()
    {
        return this.totalMainframe;
    }
    public void setTotalMainframe(String totalMainframe)
    {
        this.totalMainframe = totalMainframe;
    }
    public String getWlReason()
    {
        return this.wlReason;
    }
    public void setWlReason(String wlReason)
    {
        this.wlReason = wlReason;
    }
    
    public String getMilestone()
    {
        return this.milestone;
    }
    public void setMilestone(String milestone)
    {
        this.milestone = milestone;
    }
    public String getBegofQtr()
    {
        return this.begofQtr;
    }
    public void setBegofQtr(String begofQtr)
    {
        this.begofQtr = begofQtr;
    }
    public String getTotalSMLostPipelines()
    {
        return this.totalSMLostPipelines;
    }
    public void setTotalSMLostPipelines(String totalSMLostPipelines)
    {
        this.totalSMLostPipelines = totalSMLostPipelines;
    }
    public String getAccountname()
    {
        return this.accountname;
    }
    public void setAccountname(String accountname)
    {
        this.accountname = accountname;
    }
    public String getAccountowner()
    {
        return this.accountowner;
    }
    public void setAccountowner(String accountowner)
    {
        this.accountowner = accountowner;
    }
    
    public Decimal getTotal75Q1PricePipelines()
    {
        return this.total75Q1PricePipelines;
    }
    public void setTotal75Q1PricePipelines(Decimal total75Q1PricePipelines)
    {
        this.total75Q1PricePipelines = total75Q1PricePipelines;
    }
    public Decimal getTotal75Q2PricePipelines()
    {
        return this.total75Q2PricePipelines;
    }
    public void setTotal75Q2PricePipelines(Decimal total75Q2PricePipelines)
    {
        this.total75Q2PricePipelines = total75Q2PricePipelines;
    }
    public Decimal getTotal75Q3PricePipelines()
    {
        return this.total75Q3PricePipelines;
    }
    public void setTotal75Q3PricePipelines(Decimal total75Q3PricePipelines)
    {
        this.total75Q3PricePipelines = total75Q3PricePipelines;
    }
    public Decimal getTotal75Q4PricePipelines()
    {
        return this.total75Q4PricePipelines;
    }
    public void setTotal75Q4PricePipelines(Decimal total75Q4PricePipelines)
    {
        this.total75Q4PricePipelines = total75Q4PricePipelines;
    }
    
    public Decimal getTotal7Q1PricePipelines()
    {
        return this.total7Q1PricePipelines;
    }
    public void setTotal7Q1PricePipelines(Decimal total7Q1PricePipelines)
    {
        this.total7Q1PricePipelines = total7Q1PricePipelines;
    }
    public Decimal getTotal7Q2PricePipelines()
    {
        return this.total7Q2PricePipelines;
    }
    public void setTotal7Q2PricePipelines(Decimal total7Q2PricePipelines)
    {
        this.total7Q2PricePipelines = total7Q2PricePipelines;
    }
    public Decimal getTotal7Q3PricePipelines()
    {
        return this.total7Q3PricePipelines;
    }
    public void setTotal7Q3PricePipelines(Decimal total7Q3PricePipelines)
    {
        this.total7Q3PricePipelines = total7Q3PricePipelines;
    }
    public Decimal getTotal7Q4PricePipelines()
    {
        return this.total7Q4PricePipelines;
    }
    public void setTotal7Q4PricePipelines(Decimal total7Q4PricePipelines)
    {
        this.total7Q4PricePipelines = total7Q4PricePipelines;
    }
}