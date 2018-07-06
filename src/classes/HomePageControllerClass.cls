// Controller class for the HomeTab visualforce page
public class HomePageControllerClass {

//----------------------------- class parameters ----------------------------------------------//

    private Date fiscalYrStartDt;
    private Date fiscalYrEndDt;
    private Date QtrStartDt;
    private Date QtrEndDt;
    private static String oppInside = 'Inside';    
   
    private Integer noOfClosingOpportunities=0;
    private Integer noOfOpenOpp_alert3 = 0;
    private Integer noOfOpenOpp_alert4 = 0;
    private Integer noOfOpenOpp_alert5 = 0;
    private Integer noOfNewOpenOpp_alert6 = 0;
    private double totalMFAPrice = 0.0;
    private double tmpTotPrice_qp = 0.0;
    private double tmpTotPrice_cwon = 0.0;
    private Integer qPipelineUnits = 0;
    private Integer cWonUnits = 0;
    public double totQualPlineYTD = 0.0; 
    public double totClosedPlineYTD = 0.0;
    public double totQualClosedPlineYTD = 0.0;
    public Integer totQualUnitsYTD = 0;
    public Integer totClosedUnitsYTD = 0;
    public Integer totQualClosedUnitsYTD = 0;    
    public double tmpTotPrice_qp_prod = 0.0;
    public double tmpTotPrice_closed_prod = 0.0;
    private Integer qPipelineUnits_prod = 0;
    private Integer cWonUnits_prod = 0;
    private Decimal divisor = 1000.00;
        
    private set<Id> accountsWithClosingOpps=new set<Id>();
    private set<Id> accountsWithClosedOpps=new set<Id>();
    private set<Id> accountsWithOpenOpps=new set<Id>();
    private set<Id> accountsWithOpenInsideOpps=new set<Id>();
    private set<Id> totalOppIds = new set<Id>();
    private set<Id> totalOppIds_QT = new set<Id>();

    // this map will contain the YTD Market Focus Area & the product list with the opp. summary as a key/value pair
    private Map<String,List<pipelineYTDWrapper>> plineYTDMap = new Map<String,List<pipelineYTDWrapper>>{};
    // this map will contain the QT Market Focus Area & the product list with the opp. summary as a key/value pair
    private Map<String,List<pipelineYTDWrapper>> plineQTMap = new Map<String,List<pipelineYTDWrapper>>{};
    // this is a temporary map for the YTD & QT values 
    private Map<String,List<pipelineYTDWrapper>> plineMap = new Map<String,List<pipelineYTDWrapper>>{}; 
    // this map will contain the Month & all the opportunities for the month as a key/value pair
    private Map<String,List<OppDetWrapper>> oppMap = new Map<String,List<OppDetWrapper>>{};

    //**** Visibility parameters ****//
    private boolean clInsiVisibleFlag = true;
    private boolean targetVisibleFlag = true;
    private boolean sapImageVisibility = true;
    private boolean salesWBenchVisibility = true;
    private boolean pricingPortalVisility = true;
    private boolean perfMgmtVisibility = true;
    private boolean serviceDeskVisibility = true;
    private boolean leaderBoardVisibility = true;
    private boolean cpmsVisibility = true;
    private boolean custFeedbackVisibility = true;
    public boolean openOppAlertFlag = false;
    public boolean amtBelow5AlertFlag = false;

    public String req_mfaName = '';
    public String view = '';
    public String req_mon = '';
    public String view_oppDet = '';
    public String view_opp = '';    
    public String req_mfaName_QT = '';
    public String view_QT = '';
    public String oppsType;
    public String tmpMFA;
    public String userRoleName {get; set;}
    public String userProfId;
    public String userType = 'direct';
    public String userRegion;
    public String tmpProdId;
    public String monthlyOpportunities ='';
                
    public List<Account> accountDet = new List<Account>();
    public List<opportunityWrapper> newOpenOpps = new List<opportunityWrapper>();
    public List<accountWrapper> accList=new List<accountWrapper>();
    public List<pipelineYTDWrapper> pipelineList = new List<pipelineYTDWrapper>();
    public List<pipelineYTDWrapper> pipelineList_prod = new List<pipelineYTDWrapper>();
    public List<pipelineYTDWrapper> pipelineListYTD = new List<pipelineYTDWrapper>();
    public List<pipelineYTDWrapper> pipelineListYTD_prod = new List<pipelineYTDWrapper>();
    public List<pipelineYTDWrapper> pipelineListQT = new List<pipelineYTDWrapper>();
    public List<pipelineYTDWrapper> pipelineListQT_prod = new List<pipelineYTDWrapper>();
    public List<PopUpWrapper> popUpWrapperList = new List<PopUpWrapper>();
    public List<OppDetWrapper> popUpWrapperList_det = new List<OppDetWrapper>();
    public List<String> summaryTable = new List<String>();
    public List<OpportunityLineItem> pipeLineYTD = new List<OpportunityLineItem>();
    
    public set<String> dirProfileIds = new set<String>();
    public set<String> indirProfileIds = new set<String>();    
    public set<ID> oppRecTypeIds = new set<ID>();    
        
    // returns the account list
    public  List<accountWrapper> getaccList()
    {
        return accList;
    }

    // returns the number of closing opportunities
    public Integer  getnoOfClosingOpportunities()
    {
        return noOfClosingOpportunities;
    }

    //returns the number of open opportunities past closed date
    public Integer getnoOfOpenOpportunities_alert3()
    {
        return noOfOpenOpp_alert3;  
    }

    //returns the number of open opportunities with probability > 10% and Amount <=5
    public Integer getnoOfOpenOpportunities_alert4()
    {
        return noOfOpenOpp_alert4;  
    }

    //returns the number of open opportunities with probability > 10% and has no products
    public Integer getnoOfOpenOpportunities_alert5()
    {
        return noOfOpenOpp_alert5;  
    }
    
    // returns the number of new open opportunities with probability = 10%
    public Integer getnoOfNewOpenOpportunities_alert6()
    {
        return noOfNewOpenOpp_alert6;   
    }
    
    // returns the visibility boolean value for closed/inside column
    public boolean getClInsiVisibleFlag()
    {
        return clInsiVisibleFlag;   
    }
    
    // returns the visibility boolean value for the target column
    public boolean getTargetVisibleFlag()
    {
        return targetVisibleFlag;   
    }

    // returns the visibility boolean value for the SAP image
    public boolean getSapImageVisibility()
    {
        return sapImageVisibility;  
    }
    
    // returns the visibility boolean value for saleswbench image
    public boolean getSalesWBenchVisibility()
    {
        return salesWBenchVisibility;   
    }
    
    // returns the visibility boolean value for pricingPortalVisibility image
    public boolean getPricingPortalVisility()
    {
        return pricingPortalVisility;   
    }
    
    // returns the visibility boolean value for performanceManagementVisibility image
    public boolean getPerfMgmtVisibility()
    {
        return perfMgmtVisibility;  
    }    

    // returns the visibility boolean value for serviceDeskVisibility image
    public boolean getServiceDeskVisibility()
    {
        return serviceDeskVisibility;   
    }
    
    // returns the visibility boolean value for LeaderBoard visibility image
    public boolean getLeaderBoardVisibility()
    {
        return leaderBoardVisibility;   
    }
    
    // returns the visibility boolean value for CPMS image visibility
    public boolean getCpmsVisibility()
    {
        return cpmsVisibility;  
    }   
    
    // returns the visibility boolean value for customer feedback visibility
    public boolean getCustFeedbackVisibility()
    {
        return custFeedbackVisibility;  
    }   
    
    // returns the list of pipelineYTD values
    public List<pipelineYTDWrapper> getPipelineYTD()
    {
        if(view == 'prodView')
        {
            return plineYTDMap.get(req_mfaName);    
        }
        else
        {
            return pipelineListYTD;
        }   
    }
    
    //returns the list of pipelineQT values
    public List<pipelineYTDWrapper> getPipelineQT()
    {
        if(view_QT == 'prodView')
        {
            return plineQTMap.get(req_mfaName_QT);  
        }
        else
        {
            return pipelineListQT;
        }       
    }
    
    // returns the monthwise list of opportunities
    public List<PopUpWrapper> getMonthwiseOpps()
    {
        return popUpWrapperList;
    }

    // returns the monthwiseDetailed list of opportunities
    public List<OppDetWrapper> getMonthwiseOppDetail()
    {
        return oppMap.get(req_mon);
    }
    
    // returns the opportunities list
    public List<opportunityWrapper> getNewOpenOppList()
    {
        return newOpenOpps; 
    }
    
    // returns the column style
    public String getColumn1StyleYTD()
    {
        if(view == 'prodView')
        {
            return 'display:none';  
        }
        else
        {
            return 'display:block';
        }   
    }
    
    // returns the column style
    public String getColumn2StyleYTD()
    {
        if(view == 'prodView')
        {
            return 'display:block'; 
        }
        else
        {
            return 'display:none';
        }   
    }

    // returns the column style
    public String getColumn1StyleQT()
    {
        if(view_QT == 'prodView')
        {
            return 'display:none';  
        }
        else
        {
            return 'display:block';
        }   
    }
    
    // returns the column style
    public String getColumn2StyleQT()
    {
        if(view_QT == 'prodView')
        {
            return 'display:block'; 
        }
        else
        {
            return 'display:none';
        }   
    }
        
    // returns the link visibility flag for the reports link
    public boolean getReportLink1Status()
    {
        if(view == 'prodView')
        {
            return true;    
        }
        else
        {
            return false;
        }   
    
    }
    
    // returns the link visibility flag for the reports link
    public boolean getReportLink2Status()
    {
        if(view_QT == 'prodView')
        {
            return true;    
        }
        else
        {
            return false;
        }   
    
    }
    
    // returns the flag for monthTable
    public boolean getMonthTableStatus()
    {
        if(view_oppDet == 'oppDetView')
            return false;
        else
            return true;
    
    }
    
    // returns the flag for pageBlockTitle
    public String getPopUpPageBlockTitle() {
        if(view_oppDet == 'oppDetView')     
            return view_opp+' Opportunities for '+req_mon;
        else
            return view_opp+' Opportunities';
    }

    // returns the flag for a column header
    public String getColumnHeaderYTD()
    {
        if(view == 'prodView')
        {
            return 'Product';   
        }
        else
        {
            return 'Business Unit';
        }           
    }    
    
    // returns the flag for a column header
    public String getColumnHeaderQT()
    {
        if(view_QT == 'prodView')
        {
            return 'Product';   
        }
        else
        {
            return 'Business Unit';
        }                   
    }
    
    // returns the flag for summary table
    public List<String> getSummaryTable()
    {
        return summaryTable;
    }   
    
    // returns the Account title
    public String getAccTitle()
    {
        if(userType == 'direct')
            return 'Account Name';
        else 
            return 'Reseller Name';  
    }
    
    // returns the column name
    public String getAccCol2()
    {
        return 'Closed Opp.(YTD)';
    }
    
    // returns the column name
    public String getAccCol3()
    {
        return 'Open Opp.(YTD)';
    }
    
    // returns the column name
    public String getAccCol4()
    {
        return 'Open & Closed(YTD)';
    }
    
    // returns the column name
    public String getAccCol5()
    {
        return 'Target';                
    }
    
    // returns the column name
    public String getAccCol6()
    {
        return 'Closed & Inside(YTD)';
    }   
    
    // returns the column name
    public String getAccCol7()
    {
        return 'Phone';
    }   
    
    // returns the Qualified pipeline value
    public double getTotQualPlineYTD()
    {
        return totQualPlineYTD; 
    } 
    
    // returns the closed & won pipeline value
    public double getTotClosedPlineYTD()
    {
        return totClosedPlineYTD;   
    }
    
    // returns the total closed & qualified pipeline value
    public double getTotQualClosedPlineYTD()
    {
        return totQualClosedPlineYTD;   
    }
    
    // returns the qualified units value
    public double getTotQualUnitsYTD()
    {
        return totQualUnitsYTD; 
    }
    
    // returns the closed units value
    public double getTotClosedUnitsYTD()
    {
        return totClosedUnitsYTD;   
    }   
    
    // returns the total units value
    public double getTotQualClosedUnitsYTD()
    {
        return totQualClosedUnitsYTD;   
    }
    
    // returns the monthly opportunities value
    public String getMonthlyOpportunities()
    {
        return monthlyOpportunities;    
    }
    
    // returns the Alert flag for open opportunities
    public String getOpenOppAlertStyle()
    {
        if(openOppAlertFlag == true)
            return '';
        else
            return 'display:none';  
    }

    // returns the Alert flag for open opportunities
    public String getAmtBelow5AlertStyle()
    {
        if(amtBelow5AlertFlag == true)
            return '';
        else
            return 'display:none';  
    }
    
    // returns the userrolename
    
     /*public String getuserRoleName ()
     
      {
      	return this.userRoleName;
      }
    */
    /*
     * Initializes the visualforce pages with data. 
     * Based on the initializing page(home page or pop-up pages), independent methods are called.
     *
     * @return a page reference
     */    
    public PageReference init() { 
        // retrieve the page variables
        String pageState = ApexPages.currentPage().getParameters().get('pageState');
        oppsType = ApexPages.currentPage().getParameters().get('oppsType');
        String accId =  ApexPages.currentPage().getParameters().get('accId');
        
        // retrieve the fiscal year & QT dates
        retrieveDates();
    
        // retrieve the user role
        userRoleName = [Select UserRole.Name from User where Id = : UserInfo.getUserId()].UserRole.Name;        

        // retrieve the profile id
         userProfId = UserInfo.getProfileId();

        // retrieve the profile IDs and opp. recordtype ids for the profile        
        dirProfileIds = SystemIdUtility.getDirectProfileIds();
        indirProfileIds = SystemIdUtility.getInDirectProfileIds();
        // identify what columns are visible for the logged in user
        identifyFieldsVisibility();     

        oppRecTypeIds = SystemIdUtility.getOppsRecTypeIds(userType,userRegion);
        
        
                        
        // if its a pop-up initialization
        if(pageState == 'popsUp')
        {
                pageState = '';
                List<Opportunity> opps_popup = new List<Opportunity>();
                
                // retrieves the list of closed opportunities for the selected account
                if(oppsType == 'closedOpps')
                {
                    opps_popup = [Select StageName,Name,Amount,Id,closeDate,AccountId from Opportunity where AccountId =: accId and RecordTypeId in : oppRecTypeIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed = true and IsWon=true and Amount != null order by CloseDate limit 1000];
                    view_opp = 'Closed';
                }
                // retrieves the list of open opportunities for the selected account
                else if(oppsType == 'openOpps')
                {
                    opps_popup = [Select StageName,Name,Amount,Id,closeDate,AccountId from Opportunity where AccountId =: accId and RecordTypeId in : oppRecTypeIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed = false and Probability > 10 and Amount != null order by CloseDate limit 1000];
                    view_opp = 'Open';
                }
                
                String tempOppId = null;
                double closedOppAm = 0.0;
                Integer tmpMonth;            
                
                for(integer i = 0;i<opps_popup.size();i++)
                {
                        // if its the first record in the list
                        if(i == 0)
                        {
                            tmpMonth = opps_popup.get(i).closeDate.month();
                            if(opps_popup.get(i).Amount != null)
                                closedOppAm = opps_popup.get(i).Amount;
                            popUpWrapperList_det.add(new OppDetWrapper(opps_popup.get(i).Name,closedOppAm,opps_popup.get(i).StageName));                            
                        }
                        else
                        {
                            tempOppId = opps_popup.get(i).Id;
                            if(opps_popup.get(i).closeDate.month() == tmpMonth)
                            {
                                popUpWrapperList_det.add(new OppDetWrapper(opps_popup.get(i).Name,opps_popup.get(i).Amount,opps_popup.get(i).StageName));
                                //if(opps_popup.get(i).Amount != null)
                                    closedOppAm = closedOppAm+opps_popup.get(i).Amount; 
                            }
                            else                        
                            {
                                // add the values to the Map
                                oppMap.put(getMonthValue(tmpMonth),popUpWrapperList_det);
                                popUpWrapperList.add(new PopUpWrapper(getMonthValue(tmpMonth),closedOppAm));
                                tmpMonth = opps_popup.get(i).closeDate.month();
                                closedOppAm = opps_popup.get(i).Amount;
                                resetPopupVariables();
                                popUpWrapperList_det.add(new OppDetWrapper(opps_popup.get(i).Name,closedOppAm,opps_popup.get(i).StageName));
                            }                           
                        }
                        // if its the last record in the list
                        if(i == opps_popup.size()-1)
                        {
                            oppMap.put(getMonthValue(tmpMonth),popUpWrapperList_det);
                            popUpWrapperList.add(new PopUpWrapper(getMonthValue(tmpMonth),closedOppAm));
                        }                                                            
                }
            return null;
          }
        // new open opportunities popUp page initialization
        else if(pageState == 'popsUp2'){
            
            accountDet = getAccounts();
            newOpenOpps = getNewOpenOpps();
            
            return null;
        }          
        // if its a normal page initialization            
        else
        {       
            // get the list of accounts managed by the logged in user
            accountDet= getAccounts();
            
            // list of closed opportunities for YTD    
            List<Opportunity> closedOpps = [Select OwnerId,Amount,Id,closeDate,AccountId from Opportunity where AccountId in :accountDet and RecordTypeId in : oppRecTypeIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed = true and IsWon=true and Amount != null order by AccountId,CloseDate limit 1000];
    
            // list of open opportunities for YTD
            List<Opportunity> openOpps = [Select OwnerId,Amount,Id,AccountId from Opportunity where AccountId in :accountDet and RecordTypeId in : oppRecTypeIds and CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed = false and Probability > 10 and Amount != null limit 1000];

            // get the list of new open opportunities
            newOpenOpps = getNewOpenOpps(); 
                                         
            // list of closed opportunities for the quarter
            List<Opportunity> closedOpps_QT = [Select OwnerId,Amount,Id,AccountId from Opportunity where AccountId in :accountDet and CloseDate>= : QtrStartDt and CloseDate<= :QtrEndDt and RecordTypeId in : oppRecTypeIds and IsClosed = true and IsWon=true and Amount != null limit 1000];
            
            // list of open opportunities for the quarter
            List<Opportunity> openOpps_QT = [Select OwnerId,Amount,Id,AccountId from Opportunity where AccountId in :accountDet and CloseDate>= : QtrStartDt and CloseDate<= :QtrEndDt and RecordTypeId in : oppRecTypeIds and IsClosed = false and Probability > 10 and Amount != null limit 1000];        
    
            // list of closing opportunities
            List<Opportunity> closingOpps=[Select Amount,Id,AccountId from Opportunity where AccountId in :accountDet and CloseDate>=Today and 
            CloseDate< :Date.today().addDays(15) and RecordTypeId in : oppRecTypeIds and Amount != null and ownerId = : UserInfo.getUserId() 
            and IsClosed = false limit 1000];
            
            // list of open opportunities with InsideOutside flag as Inside
            List<Opportunity> openInsideOpps= [Select Amount,Id,AccountId from Opportunity where AccountId in :accountDet and 
            CloseDate>= : fiscalYrStartDt and CloseDate<= :fiscalYrEndDt and IsClosed = false and Probability > 10 and 
            Inside_Outside__c = : oppInside and RecordTypeId in : oppRecTypeIds and Amount != null limit 1000]; 
            
            // list of open opportunities past the closed date
            List<Opportunity> openOpp_alert3 =[Select Amount,Id,AccountId from Opportunity where AccountId in :accountDet and CloseDate>= : fiscalYrStartDt and CloseDate< Today and IsClosed = false and RecordTypeId in : oppRecTypeIds and Amount != null and ownerId = : UserInfo.getUserId() limit 1000];
            
            // list of open opportunities with opportunity amount less than 5
            List<Opportunity> openOpp_alert4 =[Select Amount,Id,AccountId from Opportunity where AccountId in :accountDet and CloseDate>= : fiscalYrStartDt and IsClosed = false and Probability > 10 and Amount <5 and RecordTypeId in : oppRecTypeIds and Amount != null and ownerId = : UserInfo.getUserId() limit 1000];                
            
            // list of open opportunities with out any products
            List<Opportunity> openOpp_alert5 =[Select Amount,Id,AccountId from Opportunity where AccountId in :accountDet and CloseDate>= : fiscalYrStartDt and IsClosed = false and Probability > 10 and HasOpportunityLineItem=false and RecordTypeId in : oppRecTypeIds and Amount != null and ownerId = : UserInfo.getUserId() limit 1000];
            
            noOfClosingOpportunities= closingOpps.size();
            noOfOpenOpp_alert3      = openOpp_alert3.size();
            noOfOpenOpp_alert4      = openOpp_alert4.size();
            noOfOpenOpp_alert5      = openOpp_alert5.size();
            noOfNewOpenOpp_alert6   = newOpenOpps.size();    
            
            for(Opportunity o:ClosedOpps)
            {
                accountsWithClosedOpps.add(o.AccountId);    
            }
            for(Opportunity closingOpp:closingOpps)
            {
                accountsWithClosingOpps.add(closingOpp.AccountId);
            }
            for(Opportunity openOpp:openOpps)
            {
                accountsWithOpenOpps.add(openOpp.AccountId);
            }
            for(Opportunity openInsideOpp:openInsideOpps)
            {
                accountsWithOpenInsideOpps.add(openInsideOpp.AccountId);    
            }
            
            for(integer l=0;l<openOpps.size();l++)
            {   
                // for direct users consider only opportunities whose owner are is the same 
                // as the logged on user id
                if(userType == 'direct')
                {
                    if(openOpps.get(l).ownerId == UserInfo.getUserId())
                    {
                        totalOppIds.add(openOpps.get(l).Id);
                    }
                }
                else
                {
                    totalOppIds.add(openOpps.get(l).Id);
                }
            }
            for(integer m=0;m<closedOpps.size();m++)
            {
                // for direct users consider only opportunities whose owner are is the 
                // same as the logged on user id           
                if(userType == 'direct')
                {
                    if(closedOpps.get(m).ownerId == UserInfo.getUserId())
                    {
                        totalOppIds.add(closedOpps.get(m).Id);
                    }
                }
                else
                {
                    totalOppIds.add(closedOpps.get(m).Id);
                }       
            }
            for(integer p=0;p<openOpps_QT.size();p++)
            {
                // for direct users consider only opportunities whose owner are the 
                // same as the logged on user id           
                if(userType == 'direct')
                {
                    if(openOpps_QT.get(p).ownerId == UserInfo.getUserId())
                    {
		                totalOppIds_QT.add(openOpps_QT.get(p).Id);
                    }
                }
                else
                {
                	totalOppIds_QT.add(openOpps_QT.get(p).Id);
                }           
            }
            for(integer q=0;q<closedOpps_QT.size();q++)
            {
            	// for direct users consider only opportunities whose owner are the 
                // same as the logged on user id                       	
	            if(userType == 'direct')
                {
                    if(closedOpps_QT.get(q).ownerId == UserInfo.getUserId())
                    {
                		totalOppIds_QT.add(closedOpps_QT.get(q).Id);
                    }
                }
                else
                {
                	totalOppIds_QT.add(closedOpps_QT.get(q).Id);
                }
            }
            
            // calculate the opportunity value for each account
            for(Account acc:accountDet)
            {
                double totalOppValue = 0.0;
                double target = 0.0;
                double closedOppAmount = 0.0;
                double openOppAmount = 0.0;
                double openInsideOpp = 0.0;
                double ncvTargetProd = 0.0;
                double ncvTargetServ = 0.0;
    
                // calculate the target value
                try
                {
                    // calculate the target for the account
                    if(acc.NCV_Target_Products__c != null)
                        ncvTargetProd = acc.NCV_Target_Products__c;
                    if(acc.NCV_Target_Services_Education__c != null)
                        ncvTargetServ = acc.NCV_Target_Services_Education__c;
                    target = ncvTargetProd+ncvTargetServ;               
                }
                catch(Exception e)
                {
                    // catch any exception here due to null values in the target values
                }
                
                // calculations for closed opportunities
                for(integer i = 0;i<closedOpps.size();i++)
                {
                    if(closedOpps.get(i).AccountId == acc.Id)
                    {
                        try
                        {
                            // calculate the closed opportunity amount
                            closedOppAmount = closedOppAmount + closedOpps.get(i).Amount;
                        }
                        catch(Exception e)
                        {
                            // catch any exception here due to null values in the target values
                        }                       
                    }                   
                }
                
                // calculations for open opportunities
                for(integer j = 0;j<openOpps.size();j++)
                {
                    try
                    {               
                        if(openOpps.get(j).AccountId == acc.Id)
                        {
                            // calculate the open opportunity amount
                            openOppAmount = openOppAmount + openOpps.get(j).Amount;
                        }
                    }
                    catch(Exception e)
                    {
                        // catch any exception here due to null values in the target values
                    }                       
                }
                
                // calculations for openInsideOppportunities
                for(integer k = 0;k<openInsideOpps.size();k++)
                {
                    try
                    {               
                        if(openInsideOpps.get(k).AccountId == acc.Id)
                        {
                            // calculate the open/inside opp amount
                            openInsideOpp = openInsideOpp + openInsideOpps.get(k).Amount;
                        }
                    }                   
                    catch(Exception e)
                    {
                        // catch any exception here due to null values in the target values
                    }                       
                }
                
                // calculating the totalOpportuniyAmount
                totalOppValue = closedOppAmount+openOppAmount;
                
                // identifying blinking accounts and creating the account wrapper object
                if(accountsWithClosingOpps.contains(acc.Id))
                {
                    accList.add(new accountWrapper('attAccount',acc,closedOppAmount,openOppAmount,totalOppValue,closedOppAmount+openInsideOpp,target));                 
                }
                else
                {
                    accList.add(new accountWrapper('',acc,closedOppAmount,openOppAmount,totalOppValue,closedOppAmount+openInsideOpp,target));                   
                }            
                
            }
            
            System.debug(logginglevel.Debug,'Before building the YTD pipelineReport');
           
            // build pipelineYTD report
            try
            {
                buildPipeLineReport(totalOppIds,'YTD');
            }
            catch(Exception ex) {
                System.debug(logginglevel.Debug,'Exception while building data for the YTD pipeline report : '+ex);
            }     
            
            pipelineListYTD = pipelineList;
            plineYTDMap = plineMap;
            resetAllVariables();
            
            System.debug(logginglevel.Debug,'Before building the QT pipelineReport');
            
            //build pipelineQT report
            try
            {           
                buildPipeLineReport(totalOppIds_QT,'QT');
            }
            catch(Exception ex) {
                System.debug(logginglevel.Debug,'Exception while building data for the QT pipeline report : '+ex);
            }     
            pipelineListQT = pipelineList;
            plineQTMap = plineMap;      
            
            System.debug(logginglevel.Debug,'Built all the data for the home page.Before the return call.');
            
            return null;
        }        
    }

    /*
     * Builds the data for YTD & QT pipeline reports 
     * 
     * @param the list of Opportunity Ids
     * @param the report type
     * Modified by Arun B on 04/04 to fix the prod. issue
     */ 
    public void buildPipeLineReport(set<Id> pTotalOppIds,String repType)
    {   
    	Set<Id> oppIdsSet = new set<Id>();
        // code snippet to generate pipeline coverage YTD report
          pipeLineYTD = [Select TotalPrice,Id,OpportunityId,Opportunity.Name,Opportunity.IsClosed,PricebookEntryId,PricebookEntry.Name,PricebookEntry.Product2Id,PricebookEntry.Product2.Market_Focus_Area__c,PricebookEntry.Product2.Name from OpportunityLineItem where OpportunityId in :pTotalOppIds and PricebookEntry.Product2.Market_Focus_Area__c != null order by PricebookEntry.Product2.Market_Focus_Area__c,PricebookEntry.Product2.Name limit 1000];

        for(integer n=0;n<pipeLineYTD.size();n++)
        {   
            // if this is the 1st opportunity to be processed 
            if(n == 0)
            {
                // assign the market focus area to a temp. var
                tmpMFA = pipeLineYTD.get(n).PricebookEntry.Product2.Market_Focus_Area__c;
                initializeTempValues(n);
                checkMFA(n);    
            }
            else
            {
                // if the market focus area of the current entry same as the market focus area of the previous entry
                if(pipeLineYTD.get(n).PricebookEntry.Product2.Market_Focus_Area__c == tmpMFA)
                {
                    // check whether the opporunity is a open opportunity
                    if(pipeLineYTD.get(n).Opportunity.IsClosed == false)
                    {

                        tmpTotPrice_qp = tmpTotPrice_qp+pipeLineYTD.get(n).TotalPrice;  

                        System.debug(logginglevel.Debug,'Printing the qPipelineUnits,opp. id & MFA : '+qPipelineUnits+','+pipeLineYTD.get(n).PricebookEntry.Product2.Market_Focus_Area__c+','+pipeLineYTD.get(n-1).Opportunity.Name+','+pipeLineYTD.get(n).Opportunity.Name);  
                         System.debug(logginglevel.Debug,'Printing the PB names : '+tmpProdId+','+pipeLineYTD.get(n).PricebookEntry.Product2.Name);
						
						oppIdsSet.add(pipeLineYTD.get(n-1).OpportunityId);
						
                        // check whether the current product & the previous one are the same
                        if(tmpProdId != pipeLineYTD.get(n).PricebookEntry.Product2.Name)
                        {    
                        	if(!oppIdsSet.contains(pipeLineYTD.get(n).OpportunityId))
                        	{
                        		qPipelineUnits = qPipelineUnits + 1;
                        	}                            
                            updateProdPipelineList();
                            initializeTempValues(n);
                        }
                        else
                        {
	                        tmpTotPrice_qp_prod = tmpTotPrice_qp_prod+pipeLineYTD.get(n).TotalPrice;

                            //if(pipeLineYTD.get(n).OpportunityId != pipeLineYTD.get(n-1).OpportunityId)
                            if(!oppIdsSet.contains(pipeLineYTD.get(n).OpportunityId))
                            {         
                            	qPipelineUnits = qPipelineUnits + 1;                       
                                qPipelineUnits_prod = qPipelineUnits_prod+1;
                            }
                        }
                         // if its a open opp. then the qualified pipeline unit should be set to 1                   
    		                if(qPipelineUnits == 0)
            		        	qPipelineUnits = 1;
                    }                    
                    // check whether the opportunity is a closed opportunity
                    if(pipeLineYTD.get(n).Opportunity.IsClosed == true)
                    {
                        tmpTotPrice_cwon = tmpTotPrice_cwon + pipeLineYTD.get(n).TotalPrice;
                     	
                     	oppIdsSet.add(pipeLineYTD.get(n-1).OpportunityId);
                     
                        System.debug(logginglevel.Debug,'Printing the cWonUnits,opp. id & MFA : '+cWonUnits+','+pipeLineYTD.get(n).PricebookEntry.Product2.Market_Focus_Area__c+','+pipeLineYTD.get(n-1).Opportunity.Name+','+pipeLineYTD.get(n).Opportunity.Name);  
                         System.debug(logginglevel.Debug,'Printing the PB names : '+tmpProdId+','+pipeLineYTD.get(n).PricebookEntry.Product2.Name);

                        //for product
                        if(tmpProdId != pipeLineYTD.get(n).PricebookEntry.Product2.Name)
                        {
                            updateProdPipelineList();
                            initializeTempValues(n);
                            if(!oppIdsSet.contains(pipeLineYTD.get(n).OpportunityId))
                        	{
	                           cWonUnits = cWonUnits + 1;
                        	}                            
                        }
                        else
                        {
                            tmpTotPrice_closed_prod = tmpTotPrice_closed_prod+pipeLineYTD.get(n).TotalPrice;
//                            if(pipeLineYTD.get(n).OpportunityId != pipeLineYTD.get(n-1).OpportunityId)                            
                            if(!oppIdsSet.contains(pipeLineYTD.get(n).OpportunityId))
                            {
                            	cWonUnits = cWonUnits + 1;
                                cWonUnits_prod = cWonUnits_prod+1;
                            }                            
                        }
                        // if its a closed opp. then the closed & won unit should be set to 1                   
    	                if(cWonUnits == 0)
        	             	cWonUnits = 1;                                                                        
                    } 
                    checkMFA(n);
                }
                // if the market focus area of the current entry is NOT the same as that of the previous entry
                else
                {
                    calculatePlineYTDProdSummary();
                    plineMap.put(tmpMFA,pipelineList_prod);
                    resetProdVariables();
                    updatePipelineList();
                    calculatePlineYTDSummary();
                    resetTempVars();
                    oppIdsSet = new set<Id>();
                    tmpMFA = pipeLineYTD.get(n).PricebookEntry.Product2.Market_Focus_Area__c;
                    calculateDistinctMFARecord(n);
                }
        
            }
            
            // if this is the last record
            if(n == pipeLineYTD.size()-1)
            {
                updateProdPipelineList();
                calculatePlineYTDProdSummary();
                plineMap.put(tmpMFA,pipelineList_prod);
                updatePipelineList();
                calculatePlineYTDSummary();
                addPlineYTDSummary();                      
            }                                                      
        }           
    }   
    
    /*
     * Function to compare the market focus area of the current records & that of the next 
     * 
     * @param the integer counter for which we need to check the MFA in the list
     *
     */ 
    public void checkMFA(Integer n)
    {   
        try
        {
            if(pipeLineYTD.get(n+1).PricebookEntry.Product2.Market_Focus_Area__c != tmpMFA)
            {
                updateProdPipelineList();
             }  
         }  
        catch(Exception e)
        {
            //catching the exceptional scenario, just in case
        }
    }
    
    /*
     * Function to update the product pipeline list 
     * 
     */ 
    public void updateProdPipelineList()
    {
        pipelineList_prod.add(new pipelineYTDWrapper(tmpProdId,tmpTotPrice_qp_prod,tmpTotPrice_closed_prod,qPipelineUnits_prod,cWonUnits_prod));
        resetProdUnitsVariables();
    }
    
    /*
     * Function to update the pipeline list for Market Focus Area 
     * 
     */ 
    public void updatePipelineList()
    {
        pipelineList.add(new pipelineYTDWrapper(tmpMFA,tmpTotPrice_qp,tmpTotPrice_cwon,qPipelineUnits,cWonUnits));  
    }

     /*
     * Function to initialize the list values for the 1st opportunity record  
     * 
     * @param the integer counter
     */ 
    public void initializeTempValues(integer n)
    {       
        if(pipeLineYTD.get(n).Opportunity.IsClosed == false)
        {                   
            // if its a 1st opportunity record then set the initial values
            if(n == 0)
            {
                tmpTotPrice_qp = tmpTotPrice_qp+pipeLineYTD.get(n).TotalPrice;
                qPipelineUnits = qPipelineUnits + 1;
            }
            // for product view
            tmpTotPrice_qp_prod = pipeLineYTD.get(n).TotalPrice;
            tmpTotPrice_closed_prod = 0;
            qPipelineUnits_prod = 1;
        }
        if(pipeLineYTD.get(n).Opportunity.IsClosed == true)
        {
            // if its a 1st opportunity record then set the initial values
            if(n == 0)
            {
                tmpTotPrice_cwon = tmpTotPrice_cwon + pipeLineYTD.get(n).TotalPrice;
                cWonUnits = cWonUnits + 1;
            }
            tmpTotPrice_closed_prod = pipeLineYTD.get(n).TotalPrice;
            cWonUnits_prod = 1;
            tmpTotPrice_qp_prod = 0;                    
        }
        tmpProdId = pipeLineYTD.get(n).PricebookEntry.Product2.Name;                                        
    }

     /*
     * Function to initialize the list values for the 1st opportunity record  
     * Also updates the product pipeline list for distinct markerfocusareas
     *
     * @param the integer counter
     */     
    public void calculateDistinctMFARecord(integer n)
    {
        if(pipeLineYTD.get(n).Opportunity.IsClosed == false)
        {                   
            tmpTotPrice_qp = pipeLineYTD.get(n).TotalPrice;
            qPipelineUnits  = 1;    
            tmpTotPrice_qp_prod = tmpTotPrice_qp_prod+pipeLineYTD.get(n).TotalPrice;
            qPipelineUnits_prod = 1;
            if(tmpProdId != pipeLineYTD.get(n).PricebookEntry.Product2.Name)
            {
                tmpProdId = pipeLineYTD.get(n).PricebookEntry.Product2.Name;
                checkMFA(n);                            
             }
             else
             {
                tmpTotPrice_qp_prod = tmpTotPrice_qp_prod+pipeLineYTD.get(n).TotalPrice;
             } 
         }
         if(pipeLineYTD.get(n).Opportunity.IsClosed == true)
         {
            tmpTotPrice_cwon = pipeLineYTD.get(n).TotalPrice;
            cWonUnits = 1;  
            tmpTotPrice_closed_prod = pipeLineYTD.get(n).TotalPrice;
            cWonUnits_prod = 1;

            if(tmpProdId != pipeLineYTD.get(n).PricebookEntry.Product2.Name)
            {
                tmpProdId = pipeLineYTD.get(n).PricebookEntry.Product2.Name;
                checkMFA(n);                            
            }
              else
              {
                tmpTotPrice_closed_prod = tmpTotPrice_closed_prod+pipeLineYTD.get(n).TotalPrice;
              }           
           } 
           
                                                                                                
    }
        
     /*
     * Wrapper class that contains the account list to be displayed on the UI.  
     *
     */     
    public class accountWrapper
    {
        private Account account;
        private Decimal ClosedOpportunities;
        private Decimal openOpportunities;
        private Decimal totalOppValue;
        private Decimal quarterOpentOpportunites;
        private Decimal closedOpenInsideOpp;
        private Decimal target;
        Decimal divisor = 1000.00;
        
    
        // return the total opportunities value    
        public Integer getTotalOppValue()
        {
            //return totalOppValue.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format();
            return getThousandsValue(totalOppValue);
        }

        // return the target value
        public Integer gettarget()
        {
            //return target.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format();
            return getThousandsValue(target);
        }

        // return the closed opportunities value
        public Integer getClosedOpportunities()
        {
            //return ClosedOpportunities.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format();
            return getThousandsValue(ClosedOpportunities);            
        }

        // return the open opportunities value
        public Integer getopenOpportunities()
        {
             //return openOpportunities.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format();
             return getThousandsValue(openOpportunities);
        }
        
        // return the openInside opportunities value
        public Integer getClosedOpenInsideOpportunities()
        {
              //return closedOpenInsideOpp.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format();
              return getThousandsValue(closedOpenInsideOpp);
        }
                               
        private string style;
        
        // return the relevant account style
        public string getstyle()
        {
            return style;
        }
        
        // return the Account object
        public Account getAccount()
        {
            return account;
        } 
        
        // AccountWrapper object constructor
        public accountWrapper(string style,Account acc,double closedOppAmount,double openOppAmount,double totalOppValue,double closedOpenInsideOpp,double target)
        {
            this.account=acc;
            this.style=style;
            this.ClosedOpportunities=closedOppAmount; 
            this.openOpportunities =openOppAmount;
            this.target = target;
            this.totalOppValue = totalOppValue;
            this.closedOpenInsideOpp = closedOpenInsideOpp;
        }
        
        // function to return integer value in thousands
        private Integer getThousandsValue(Decimal pAmt) {       
            try 
            {
                return pAmt.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue();         
            }
            catch(Exception ex) {
                System.debug(logginglevel.Debug,ex);//catch the exception here .. 
            }
            return 0; // return 0 incase of exception           
        }                
    }
    
    /*
     * Action method to change the YTD report view  
     *
     */     
    public PageReference changeView(){
        req_mfaName = System.currentPageReference().getParameters().get('page:homeForm:mfaName');
        view = System.currentPageReference().getParameters().get('page:homeForm:view');       
        return null;
    }

    /*
     * Action method to change the QT report view  
     *
     */     
    public PageReference changeQTView(){
        req_mfaName_QT = System.currentPageReference().getParameters().get('page:homeForm:mfaName_QT');
        view_QT = System.currentPageReference().getParameters().get('page:homeForm:view_QT');        
        return null;
    }

    /*
     * Action method to change the Opportunity detail view  
     *
     */     
    public PageReference opportunityDetailView() {
        req_mon = System.currentPageReference().getParameters().get('popUpPage:popUpForm:selMonth');
        view_oppDet = 'oppDetView';
        return null;    
    }
    
    /*
     * Action method to reset the view  
     *
     */     
    public PageReference monthlyView() {
        view_oppDet = '';
        return null;    
    }
    
    /*
     * Action method to reset the view  
     *
     */     
    public PageReference showMFAviewYTD(){
        view = 'MFAView';
        return null;    
    }

    /*
     * Action method to reset the view  
     *
     */     
    public PageReference showMFAviewQT(){
        view_QT = 'MFAView_QT';
        return null;    
    }
    
    /*
     * Wrapper class that contains the pipelineYTD report data  
     *
     */     
    public class pipelineYTDWrapper
    {       
        private String MarketFA;
        private Decimal QualifiedPline;
        private Decimal ClosedWon;
        private Decimal PLineAndWon;
        private Integer QualifiedPlineU;
        private Integer ClosedWonU;
        private Integer TotalU; 
        Decimal divisor = 1000.00;
        
        // return the marketFocusArea
        public String getMarketFA()
        {
            return MarketFA;
        }   
        
        // return the Qualified opp. amount in Currency format
        public Integer getQualifiedPline()
        {
            return getThousandsValue(QualifiedPline);
            //return QualifiedPline.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format(); 
        }   
        
        // return the Qualified opp. amount in Double format
        public Double getQualifiedPlineD()
        {
            return QualifiedPline;  
        }
        
        // return the closed opp. amount in Currency format
        public Integer getClosedWon()
        {
            return getThousandsValue(ClosedWon);
            //return ClosedWon.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format();
        }
        
        // return the closed opp. amount in Double format
        public double getClosedWonD()
        {
            return ClosedWon;
        }   
        
        // return the opp. amount sum in Double format
        public Integer getPLineAndWon()
        {
            return getThousandsValue(QualifiedPline+ClosedWon);
            //return (QualifiedPline+ClosedWon).divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue().format(); 
        }   
        
        // return the opp. amount sum in Double format        
        public double getPLineAndWonD()
        {
            return (QualifiedPline+ClosedWon);  
        }   
        
        // return the qualified opp. units
        public Integer getQualifiedPlineU()
        {
            return QualifiedPlineU;
        }
        
        // return the closed opp. units
        public Integer getClosedWonU()
        {
            return  ClosedWonU;
        }
        
        // return the total units
        public Integer getTotalU()
        {
            return (QualifiedPlineU+ClosedWonU);    
        }

        // constructor for pipelineYTDWrapper class
        public pipelineYTDWrapper(string mfa,double tmpTotPrice_qp,double tmpTotPrice_cwon,Integer qPipelineUnits,Integer cWonUnits)
        {
            this.MarketFA=mfa;
            this.QualifiedPline = tmpTotPrice_qp;
            this.ClosedWon = tmpTotPrice_cwon;
            this.QualifiedPlineU = qPipelineUnits;
            this.ClosedWonU = cWonUnits;
        }
        
        // function to return integer value in thousands
        private Integer getThousandsValue(Decimal pAmt) {       
            try 
            {
                return pAmt.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue();         
            }
            catch(Exception ex) {
                System.debug(logginglevel.Debug,ex);//catch the exception here .. 
            }
            return 0; // return 0 incase of exception           
        }                
    }
    
    /*
     * Wrapper class that contains the Opportunity detail pop-up data  
     *
     */     
    public class opportunityWrapper
    {
        private Opportunity opp;
        private Decimal oppAmt;
        Decimal divisor = 1000.00;
    
        // return the opportunity object    
        public Opportunity getOppObj()
        {
            return opp;
        }

        // return the amount value in currency format
        public Integer getAmt()
        {
            return (oppAmt != null) ? oppAmt.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue(): 0;
        }
        
        // OpportunityWrapper object constructor
        public opportunityWrapper(Opportunity opps)
        {
            this.opp = opps;
            this.oppAmt = opps.Amount;
        }
            
    }

    /*
     * function containing the logic for user/role visibility calculation  
     *
     */            
    public void identifyFieldsVisibility()
    {       
        // identify the user type               
        if(dirProfileIds.contains(userProfId))
            userType = 'direct';
        else if(indirProfileIds.contains(userProfId))
            userType = 'indirect';
                
        // identify the user role
        if(userRoleName.startsWith('APJ_'))
            userRegion = 'APJ';
        else if(userRoleName.startsWith('EMEA_'))
            userRegion = 'EMEA';
        else if(userRoleName.startsWith('LA_'))
            userRegion = 'LA';
        //sunji03 - FY19 PS/CAN is added
        else if (userRoleName.startsWith('PSCAN_'))
            userRegion = 'PS/CAN';
        else 
            userRegion = 'NA';
        
        // identify the visibility for the columns
        if(userType == 'direct' && (userRegion == 'NA' || userRegion == 'PS/CAN')) //sunji03 - FY19 PS/CAN is added
            {
                clInsiVisibleFlag = false;
            }
        else if(userType == 'direct' && userRegion == 'LA')
            {
                clInsiVisibleFlag = false;
            }
        else if(userType == 'indirect' && (userRegion == 'NA' || userRegion == 'PS/CAN'))//sunji03 - FY19 PS/CAN is added
            {
                clInsiVisibleFlag = false;
                targetVisibleFlag = false;  
            }
        else if(userType == 'indirect' && userRegion == 'LA')
            {
                clInsiVisibleFlag = false;
                targetVisibleFlag = false;                  
            }
        else if(userType == 'indirect' && userRegion == 'APJ')              
            {
                targetVisibleFlag = false;                  
            }
        else if(userType == 'indirect' && userRegion == 'EMEA')             
            {
                targetVisibleFlag = false;                  
            }
            
            // Include the logic for image visibility check here ..  
            if(userType == 'direct')
            {
                cpmsVisibility = false; 
            }           
            
            // New Open opportunities alert visibility
            if(userType == 'indirect' && (userRegion == 'NA' || userRegion == 'PS/CAN'))//sunji03 - FY19 PS/CAN is added
            {
                openOppAlertFlag = true;
            }

            // Amount less than 5 alert visibility
            if(userRegion == 'NA' || userRegion == 'PS/CAN')//sunji03 - FY19 PS/CAN is added
            {
                amtBelow5AlertFlag = true;
            }
            
        System.debug(logginglevel.Debug,'The logged on users usertype is : '+userType+' & region is : '+userRegion); 

       }     
    
    /*
     * function to retrieve the quarterly & yearly dates from the PERIOD table  
     *
     */            
    public void retrieveDates()
    {
        try {
            List<Period> yearlyDates = [Select StartDate, EndDate,Type From Period p where Type = 'Year' and StartDate <= TODAY and EndDate >= TODAY];
            fiscalYrStartDt = yearlyDates.get(0).StartDate;
            fiscalYrEndDt = yearlyDates.get(0).EndDate;
            List<Period> qtrlyDates = [Select StartDate, EndDate,Type From Period p where Type = 'Quarter' and StartDate <= TODAY and EndDate >= TODAY];
            QtrStartDt = qtrlyDates.get(0).StartDate;
            QtrEndDt = qtrlyDates.get(0).EndDate;
        }
        catch(Exception ex) {       
            System.debug(logginglevel.Debug,ex);
        }   
    }   

    /*
     * function to calculate the totals for the pipeline report - MarketFocusArea view  
     *
     */            
    public void calculatePlineYTDSummary()
    {
        totQualPlineYTD = totQualPlineYTD+tmpTotPrice_qp;
        totClosedPlineYTD = totClosedPlineYTD+tmpTotPrice_cwon;
        totQualUnitsYTD = totQualUnitsYTD+qPipelineUnits;
        totClosedUnitsYTD = totClosedUnitsYTD+cWonUnits;                
    }
    
    /*
     * function to calculate the totals for the pipeline report - Product view  
     *
     */            
    public void calculatePlineYTDProdSummary()
    {
        double tmpQpline_prod = 0.0;
        double tmpCWon_prod = 0.0;
        Integer tmpQplineU_prod = 0;
        Integer tmpCWonU_prod = 0;
        
        for(integer i=0;i<pipelineList_prod.size();i++)
        {
            tmpQpline_prod = tmpQpline_prod+pipelineList_prod.get(i).getQualifiedPlineD();
            tmpCWon_prod = tmpCWon_prod+pipelineList_prod.get(i).getClosedWonD();
            tmpQplineU_prod = tmpQplineU_prod+pipelineList_prod.get(i).getQualifiedPlineU();
            tmpCWonU_prod = tmpCWonU_prod+pipelineList_prod.get(i).getClosedWonU();
        }   
        //pipelineList_prod.add(new pipelineYTDWrapper('Total',tmpQpline_prod,tmpCWon_prod,tmpQplineU_prod,tmpCWonU_prod));
    }

    /*
     * function to update the pipeline list for the summary/total row.  
     *
     */            
    public void addPlineYTDSummary()
    {
        //pipelineList.add(new pipelineYTDWrapper('Total',totQualPlineYTD,totClosedPlineYTD,totQualUnitsYTD,totClosedUnitsYTD));      
    }
    
    // wrapper class for pop-up data
    public class PopUpWrapper
    {       
        private String month;
        private Decimal oppAmount;
        Decimal divisor = 1000.00;
        
        // return the month
        public String getMonth()
        {
            return month;
        }   
        
        // return the opportunity amount
        public Integer getOppAmount()
        {
            return oppAmount.divide(divisor,0,System.RoundingMode.HALF_EVEN).intValue(); 
        }   

        // constructor for the popUpWrapper class
        public PopUpWrapper(string mon,double oppAmt)
        {
            this.month = mon;
            this.oppAmount = oppAmt;
        }
    }
    
    /*
     * Wrapper class that contains the Opportunity detail pop-up data  
     *
     */     
    public class OppDetWrapper
    {
        private String oppName;
        private Decimal oppAmount;
        private String oppStage;
        
        // return the opportunity name
        public String getOppName()
        {
            return oppName;
        }   
        
        // return the opportunity amount
        public Integer getOppAmount()
        {
            return oppAmount.divide(1000.00,0,System.RoundingMode.HALF_EVEN).intValue();   
        }
        
        // return the opportunity stage
        public String getOppStage()
        {
            return oppStage;    
        }   
        
        // constructor for opportunityDetailsWrapper class          
        public OppDetWrapper(String oppName,Decimal oppAmt,String oppStage)
        {
            this.oppName = oppName;
            this.oppAmount = oppAmt;
            this.oppStage = oppStage;   
        }   
    }
    
    /*
     * funcion that returns the String name of the month taking the integer month value as input  
     * @param Integer
     * 
     * @return String 
     */     
    public String getMonthValue(Integer pMon)
    {
        if(pMon == 1)
            return 'January';
        else if(pMon == 2) 
            return 'February';
        else if(pMon == 3)
            return 'March';
        else if(pMon == 4)
            return 'April';
        else if(pMon == 5)
            return 'May';   
        else if(pMon == 6)
            return 'June';
        else if(pMon == 7)
            return 'July';
        else if(pMon == 8)
            return 'August';
        else if(pMon == 9)
            return 'September';
        else if(pMon == 10)
            return 'October';
        else if(pMon == 11)
            return 'November';
        else if(pMon == 12)
            return 'December';
        else 
            return null;
    }    

    /*
     * funcion that returns the list containing new open opportunities  
     * 
     * @return List<OpportunityWrapper> 
     */     
    public List<OpportunityWrapper> getNewOpenOpps() { 
        List<Opportunity> openOpp_alert6 =[Select Id,Name,Account.Name,Ent_Comm_Account__r.Name,Amount from Opportunity where AccountId in :accountDet and IsClosed = false and CloseDate>= : fiscalYrStartDt and 
                IsClosed = false and CloseDate<= :fiscalYrEndDt and Probability = 10 and ownerId = : UserInfo.getUserId() and Amount != null and RecordTypeId in : oppRecTypeIds order by Name limit 1000];
        for(Opportunity openNewOpp:openOpp_alert6)
        {
            newOpenOpps.add(new OpportunityWrapper(openNewOpp));
        }       
        return newOpenOpps;
    }
    
    /*
     * funcion that returns the list of accounts that belong to the login user  
     * 
     * @return List<OpportunityWrapper> 
     */     
    public List<Account> getAccounts(){
    	if(userType == 'direct')
    	{
    		 List<Account> accs = [Select a.Name,a.Id,a.Phone,a.Type,a.NCV_Target_Products__c, a.NCV_Target_Services_Education__c from Account a
        	where a.OwnerId = : UserInfo.getUserId() and RecordtypeId in: SystemIdUtility.getHomePageAccountRecordTypes(userType)         
        	order by createddate limit 1000];    
        	return accs;
    	}
    	else
    	{
    		 List<Account> accs = [Select a.Name,a.Id,a.Phone,a.Type,a.NCV_Target_Products__c, a.NCV_Target_Services_Education__c from Account a
        	where a.OwnerId = : UserInfo.getUserId() and RecordtypeId in: SystemIdUtility.getHomePageAccountRecordTypes(userType)         
        	and Customer_Category__c= 'Reseller' and Reseller_Type__c='Value' order by createddate limit 1000];    
        	return accs;
    	}
        //List<Account> accs = [Select a.Name,a.Id,a.Phone,a.Type,a.NCV_Target_Products__c, a.NCV_Target_Services_Education__c from Account a
        //where a.OwnerId = : UserInfo.getUserId() and RecordtypeId in: SystemIdUtility.getHomePageAccountRecordTypes(userType)         
        //and Customer_Category__c!= 'Distributor' order by createddate limit 1000];    
        //return accs;
    }
    
    
    //*********** functions to reset the temporary variables **************//
    /*
     * funcion to reset the variables pertaining pipeLine report  
     * 
     */     
    public void resetTempVars()
    {       
        tmpTotPrice_qp = 0.0;
        tmpTotPrice_cwon = 0.0;
        qPipelineUnits = 0;
        cWonUnits = 0;
    }

     /*
     * funcion to reset the variables pertaining to the product details of the pipeline report  
     * 
     */         
    public void resetProdUnitsVariables()
    {
        qPipelineUnits_prod = 0;
        cWonUnits_prod = 0;     
    }
    
     /*
     * funcion to reset the variables pertaining to the product view of the pipeline report  
     * 
     */         
    public void resetProdVariables()
    {
        pipelineList_prod = new List<pipelineYTDWrapper>();
        tmpTotPrice_closed_prod = 0.0;
        tmpTotPrice_qp_prod = 0.0;
        qPipelineUnits_prod = 0;
        cWonUnits_prod = 0;
    }

     /*
     * funcion to reset the variables pertaining to the popup page  
     * 
     */             
    public void resetPopupVariables()
    {
        popUpWrapperList_det = new List<OppDetWrapper>();
    }
    
    /*
     * funcion to reset the other class variables  
     * 
     */             
    public void resetAllVariables()
    {
        tmpMFA = '';
        totQualPlineYTD = 0;
        totClosedPlineYTD = 0;
        totQualUnitsYTD = 0;
        totClosedUnitsYTD = 0;              
        pipelineList = new List<pipelineYTDWrapper>();
        pipelineList_prod = new List<pipelineYTDWrapper>();
        plineMap = new Map<String,List<pipelineYTDWrapper>>{};
        resetTempVars();
        resetProdUnitsVariables();
        resetProdVariables();
    }  
    
    //*********** test methods on wrapper classes **************//
    /*
     * funcion to unit test the wrapper classes  
     * 
     */             
    static testMethod void testWrapperClasses() {
        
        Test.startTest();
        PopUpWrapper pr = new PopUpWrapper('1',12);
        pr.getMonth();
        pr.getOppAmount();
        
        Account acc = new Account();
        accountWrapper acWrapper = new accountWrapper('att',acc,12.0,12.0,12.0,12.0,12.0);
        acWrapper.getTotalOppValue();
        acWrapper.gettarget();
        acWrapper.getClosedOpportunities();
        acWrapper.getopenOpportunities();
        acWrapper.getClosedOpenInsideOpportunities();
        acWrapper.getstyle();
        acWrapper.getAccount();
        
        pipelineYTDWrapper pytdWrapper = new pipelineYTDWrapper('MFA',100.00,100.00,12,12);
        pytdWrapper.getMarketFA();
        pytdWrapper.getQualifiedPline();
        pytdWrapper.getQualifiedPlineD();
        pytdWrapper.getClosedWon();
        pytdWrapper.getPLineAndWon();
        pytdWrapper.getPLineAndWonD();
        pytdWrapper.getQualifiedPlineU();
        pytdWrapper.getClosedWonU();
        pytdWrapper.getTotalU();
        
        OppDetWrapper oppDetW = new OppDetWrapper('OPP',12.0,'STR');
        oppDetW.getOppName();
        oppDetW.getOppAmount();
        oppDetW.getOppStage();
        
        opportunityWrapper oppW = new opportunityWrapper(new Opportunity());
        oppW.getOppObj();
        oppW.getAmt();
        
        Test.stopTest(); 
    }   
}