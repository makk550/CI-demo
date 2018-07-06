public class SSPBean {
 
    public string AccountId {set; get;}
    public string AccountName {set; get;}
    public Integer Quota {set; get;}

    public Double iPNCV {set; get;}
    public Double iOffering {set; get;}
    public Double iRenewal {set; get;}

    public Double oPNCV {set; get;}
    public Double oOffering {set; get;}
    public Double oRenewal {set; get;}

    public Double wPNCV {set; get;}
    public Double wOffering {set; get;}
    public Double wRenewal {set; get;}

    public Double OpenOpps {set; get;}
    public Double WonOpps {set; get;}
    public Double LostOpps {set; get;}

    public Double TotalValue {set; get;}
    public Double SuccessRate {set; get;}
    public Boolean isEnterpriseAccount {set; get;}

    List<OpportunityLineItem> lstlineItems = new List<OpportunityLineItem>();
    public List<OpportunityLineItem> ssplineitems {set; get;}
     
    public SSPBean(Account acc, List<Opportunity> allOpps,List<OpportunityLineItem> lineItems
            ,Date QtrStartDt, Date QtrEndDt){
        AccountId = acc.Id;
        AccountName = acc.Name;
        lstlineItems = lineItems;
        ssplineitems =  new List<OpportunityLineItem>();
        if(acc.RecordtypeId==SystemIdUtility.getEnterpriseAccountRecordTypeId()){
            isEnterpriseAccount = true;
        }else{
            isEnterpriseAccount = false;
        }
        initCQFYValues(allOpps,QtrStartDt,QtrEndDt);
    }
    
    private void initCQFYValues(List<Opportunity> allOpps, Date QtrStartDt, Date QtrEndDt){
        initCounts();
        if(allOpps!=null && !allOpps.isEmpty()){
            for(Opportunity opp:allOpps){
                if(AccountId==opp.AccountId || AccountId==opp.Reseller__c){
                    if(!opp.IsClosed){
                        OpenOpps = OpenOpps + opp.Amount;
                    }else{
                        if(opp.IsWon){
                            WonOpps = WonOpps + opp.Amount;
                        }else{
                            if(opp.ReasonField__c!='Duplicate'){
                                LostOpps = LostOpps + opp.Amount;
                            }                   
                        }
                    }

                    Date CloseDate = opp.CloseDate;
                    if(CloseDate>=QtrStartDt && CloseDate<=QtrEndDt)
                        initInOutWonValues(opp.Id,opp.IsWon,opp.IsClosed);
                }
            }
            
            convertTo1000();
    
            TotalValue =  OpenOpps + WonOpps + LostOpps;
            SuccessRate = 0;
            if(WonOpps>0)
                SuccessRate = Math.round(WonOpps/TotalValue * 100);
        }
    }
        
    private string checkProductFamily(string strFam){
        string strRet = '';
        if(strFam=='Product'){
                strRet = 'Product';
        }else if(strFam=='Services' || strFam=='Education' || strFam=='Services Labor Pool' || strFam=='Support'){
                strRet = 'Offering';                    
        }else if(strFam=='Renewal' || strFam=='Time' || strFam=='Mainframe Capacity'){
            strRet = 'Renewal';
        }
//        System.debug('strFam :' + strFam);
//        System.debug('strRet :' + strRet);
        return strRet;
    }
    
    private void initInOutWonValues(string strOppId,boolean IsWon,boolean IsClosed){
        string strInOut = '';
        string strProdFamily = '';
//        System.debug('lstlineItems : ' + lstlineItems.size());
//        System.debug('strOppId : ' + strOppId);
        
        for(OpportunityLineItem LineItem:lstlineItems){
//            System.debug('LineItemId: ' + LineItem.Id);
            if(strOppId==LineItem.OpportunityId){
                //strInOut = LineItem.Inside_Outside__c;
                strProdFamily = checkProductFamily(LineItem.PricebookEntry.Product2.Family);
                
//                System.debug('strProdFamily :' + strProdFamily);
//                System.debug('IsWon :' + IsWon);
                if(IsWon){
                    
                    
                    if(strProdFamily=='Product'){
                        wPNCV = wPNCV + LineItem.UnitPrice;
                    }else if(strProdFamily=='Offering'){
                        wOffering = wOffering + LineItem.UnitPrice;                 
                    }else if( strProdFamily=='Renewal'){
                        wRenewal = wRenewal + LineItem.UnitPrice;                   
                    }

                    ssplineitems.add(LineItem);
                }else{

                    if(!IsClosed){
                        ssplineitems.add(LineItem);

                        if(strProdFamily=='Product'){
        
                            if(strInOut=='Inside')
                                iPNCV = iPNCV + LineItem.UnitPrice;
                            else if(strInOut=='Outside')
                                oPNCV = oPNCV + LineItem.UnitPrice;         
        
                        }else if(strProdFamily=='Offering'){
        
                            if(strInOut=='Inside')
                                iOffering = iOffering + LineItem.UnitPrice;                 
                            else if(strInOut=='Outside')
                                oOffering = oOffering + LineItem.UnitPrice;         
        
                        }else if( strProdFamily=='Renewal'){
        
                            if(strInOut=='Inside')
                                iRenewal = iRenewal + LineItem.UnitPrice;                   
                            else if(strInOut=='Outside')
                                oRenewal = oRenewal + LineItem.UnitPrice;           
                        }
                        
                    }
                }
                
            }
        }
    }

    private void convertTo1000(){

        if(OpenOpps>0)
            OpenOpps = OpenOpps/1000;
            
        if(WonOpps>0)
            WonOpps = WonOpps/1000;

        if(LostOpps>0)
            LostOpps = LostOpps/1000;

        if(iPNCV>0)
            iPNCV = iPNCV/1000;

        if(iOffering>0)
            iOffering = iOffering/1000;

        if(iRenewal>0)
            iRenewal = iRenewal/1000;
        
        if(oPNCV>0)
            oPNCV = oPNCV/1000;
        
        if(oOffering>0)
            oOffering = oOffering/1000;

        if(oRenewal>0)
            oRenewal = oRenewal/1000;

        if(wPNCV>0)
            wPNCV = wPNCV/1000;

        if(wOffering>0)
            wOffering = wOffering/1000;

        if(wRenewal>0)
            wRenewal = wRenewal/1000;
            
    }
    
    private void initCounts(){
        OpenOpps = 0;
        WonOpps = 0;
        LostOpps = 0;
        iPNCV = 0;
        iOffering = 0;
        iRenewal = 0;
        oPNCV = 0;
        oOffering = 0;
        oRenewal = 0;
        wPNCV = 0;
        wOffering = 0;
        wRenewal = 0;       
    }   
    
       
   /* @isTest(SeeAllData=true)   
    public static void SSPBean_Test(){    	
    	Account acc = new Account();
    	acc.Name = 'test';
    	acc.Enterprise_ID__c = '1234';
    	insert acc;
    	
    	List<Opportunity> oppList = new List<Opportunity>();
    	Opportunity opp = new Opportunity();
    	opp.Name = 'test';
    	opp.stageName ='test';
    	opp.CloseDate=Date.TODAY();
    	insert opp;
    	oppList.add(opp);
    	
    	opp = new Opportunity();
    	opp.Name = 'test';
    	opp.stageName ='test';
    	opp.CloseDate=Date.TODAY();
    	insert opp;
    	oppList.add(opp);
    	
    	Product2 p = [SELECT Id FROM Product2 LIMIT 1];
    	List<OpportunityLineItem> lstlineItems = new List<OpportunityLineItem>();
    	OpportunityLineItem oppLineItem = new OpportunityLineItem();
    	oppLineItem.UnitPrice = 100.0;
    	oppLineItem.Product2 = p;
    	insert oppLineItem;
    	lstlineItems.add(oppLineItem);
    	
    	SSPBean objSSPBean = new SSPBean(acc,oppList,lstlineItems,Date.TODAY() - 90, Date.TODAY());
    	objSSPBean.initCQFYValues(oppList,Date.TODAY() - 90, Date.TODAY());
    	
    }*/

}