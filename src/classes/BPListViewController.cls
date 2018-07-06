public class BPListViewController {

    
public Integer curYear;
public Integer curMonth;
public Integer curFYear;
public Date curDate;

    
    public BPListViewController(){      
        curDate = Date.today();
        curYear = curDate.year();
        curMonth = curDate.month();
        if(curMonth >3)
            curFYear = curYear+1;
        else
            curFYear =curYear;       
    }


    public List<Business_Plan_New__c> getRelatedBPs(){        
        List <Business_Plan_New__c> reqBPList = new List<Business_Plan_New__c>();       
        List<Business_Plan_New__c> allBPList = [SELECT Id, Name, Status__c, UserAttachmentExternalLink__c, CreatedDate, lastModifiedDate,Plan_Fiscal_Year__c from Business_Plan_New__c where Account__c IN (select AccountId from User where id =:UserInfo.getUserId())];
        String bpFiscalYear;
        for(Business_Plan_New__c bp : allBPList){
            bpFiscalYear = bp.Plan_Fiscal_Year__c;
            bpFiscalYear = bpFiscalYear.removeStart('FY ');          
            Integer bpFYear = integer.valueof(bpFiscalYear);
            if( (bpFYear == curFYear)|| (bpFYear == curFYear-1)|| (bpFYear == curFYear+1) )
                reqBPList.add(bp);
        }    
        return reqBPList;
    }   
    
}