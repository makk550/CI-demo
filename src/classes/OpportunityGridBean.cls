public class OpportunityGridBean {
    public string BusinessUnit {set; get;}
    public string NCVDriver {set; get;}
    public Integer CALicenseCount {set; get;}
    public string CompetitorLicense {set; get;}
    public string CompetitorLicenseIcon {set; get;}
    public string CustomerInstallRating {set; get;}
    public string Opportunity {set; get;}
    public string PotentialUpsell {set; get;}
    public Integer OpenOppsCount {set; get;}
    public string AccountId {set; get;}
    public string NcvId {set; get;}
    public string pDId {set; get;}
    public Opportunity_Plan_Detail__c pDet {set; get;}
    public List<CA_License__c> licenses = new List<CA_License__c>();

    public List<CA_License__c> getlicenses(){
        return licenses;
    }

    public OpportunityGridBean( Opportunity_Plan_Detail__c pd,
                                List<Opportunity> openOpps,
                                List<OpportunityLineItem> lineItems,
                                List<CA_License__c> caLicenses){
        if(pd!=null){
            BusinessUnit = pd.NCV_Driver_Info__r.Business_Unit__c;
            CompetitorLicense = pd.Competitor_Name_1__c; //pd.Competitor__c;
            CustomerInstallRating = pd.Competitor_Question_1__c;
            NCVDriver = pd.NCV_Driver_Info__r.NCV_Driver__c;
            AccountId = pd.Opportunity_Plan__r.Account__c;
            NcvId = pd.NCV_Driver_Info__c;
            pDId = pd.Id;
            pDet = pd;
        }
        PotentialUpsell = '';
        OpenOppsCount = 0;
        CALicenseCount = 0;
        initCALicenseCountAndPotentialUpsell(caLicenses);
        initCompIcon();
//        initOpenOppsCount(openOpps,lineItems);  
    }
    
    private void initCompIcon(){
        CompetitorLicenseIcon = 'grey';
        if(pDet!=null){
            String strComp1 = pDet.Competitor_Name_1__c;
            String strComp2 = pDet.Competitor_Name_2__c;
            
            if((strComp1==null || strComp1=='Choose one') &&(strComp2==null || strComp2=='Choose one')){
                CompetitorLicenseIcon = 'grey';        
            }else if(strComp1=='No Competitor' && (strComp2==null || strComp2=='Choose one' || strComp2=='No Competitor')){
                CompetitorLicenseIcon = 'green';        
            }else if( 
                    ( strComp1!= null || strComp1!='Choose one' || strComp1!='No Competitor') || 
                    ( strComp2!= null || strComp2!='Choose one' || strComp2!='No Competitor')
                    ){
                CompetitorLicenseIcon = 'red';        
            }
        }
    }
    
    private void initCALicenseCountAndPotentialUpsell(List<CA_License__c> caLicenses){
        integer dayDiff = 0;
        for(CA_License__c cal:caLicenses){
            if(cal.Opportunity_Plan_Detail__c==pDId){
                licenses.add(cal);
                CALicenseCount++;
                if(PotentialUpsell==null || PotentialUpsell==''){
                    dayDiff = -1;
                    if(cal.Contract_End__c!=null)
                        dayDiff = Date.valueOf(cal.Contract_End__c).dayOfYear() - Datetime.now().dayOfYear();
                    
                    if(dayDiff>0 && dayDiff<=90){
                        PotentialUpsell = 'Renewal';
                        continue;
                    }else if(cal.Contract_Version__c!=null && 
                            cal.Support_Version__c!=null){
                        if(decimal.valueOf(cal.Contract_Version__c)>=decimal.valueOf(cal.Support_Version__c)){
                            if(decimal.valueOf(cal.Contract_Version__c)<decimal.valueOf(cal.Latest_Version__c)){
                                PotentialUpsell = 'Product Version';
                                continue;
                            }
                        }else{
                            if(decimal.valueOf(cal.Support_Version__c)<decimal.valueOf(cal.Latest_Version__c)){
                                PotentialUpsell = 'Product Version';
                                continue;
                            }
                        }                        
                    }else{
                        PotentialUpsell = '';
                    }
                }
            }
        }
        System.debug('PotentialUpsell: ' + PotentialUpsell);
        if(PotentialUpsell=='' || PotentialUpsell=='None'){
            if(CompetitorLicense!=null && CompetitorLicense!='' && CustomerInstallRating!=null){
                if(CustomerInstallRating.startsWith('3') || CustomerInstallRating.startsWith('1') || CustomerInstallRating.startsWith('0')){
                    PotentialUpsell = 'Competitive Replacement';
                }
            }
        }
    }
}