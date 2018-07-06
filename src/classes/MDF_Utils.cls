/**
*Description :Class to handle MDF functionality.
*Methods PopulateApproversOnFundClaim  , with List of SFDC_MDF_Claim__c as input
*Populate approvers and Partner Email Address
*Client: CA technologies
*Developed By:  Balasaheb Wani Oct 27,2010
*Last Updated On Oct 27,2010
*/
public class MDF_Utils
{
    public static boolean ByPassStampedCurr=false;
    
    public static Map<String,Decimal> mapOfConvesion =new Map<String,Decimal>();
    public static Map<String,Decimal> getCurrencyConversions(){
        if(mapOfConvesion != null && mapOfConvesion.size()>0){
            return mapOfConvesion;
        }
        else{
            
            List<CurrencyType> listOfCurrency=[Select IsoCode, IsActive, Id,ConversionRate From CurrencyType ];
            System.debug('--------list of curr---'+listOfCurrency.size());
            for (CurrencyType thisCurrency : listOfCurrency) {
                 mapOfConvesion.put(thisCurrency.IsoCode,thisCurrency.ConversionRate);
              } 
            return mapOfConvesion;
        }
    } 
       
    public static void PopulateApproversOnFundClaim(List<SFDC_MDF_Claim__c> lstClaims)
    {
         Map<Id,SFDC_MDF__c> mapMDF=new Map<Id,SFDC_MDF__c>();
         Map<Id,Fund_Programs_Admin__c> mapFP = new Map<Id,Fund_Programs_Admin__c>();
         Map<Id,SFDC_MDF__c> mapMDFForEmail=new Map<Id,SFDC_MDF__c>();
         Set<Id> stFundReq=new Set<Id>();
         Set<Id> stMDFs=new Set<Id>();
         
         //added as a part of R2.1 to populate currency.
         Set<Id> listOfBudgetIds = new Set<Id>();
         Map<Id,SFDC_Budget__c> mapOfBudget=new Map<Id,SFDC_Budget__c>();
         
         for (SFDC_MDF_Claim__c claim :lstClaims)
         {
            if(claim.Fund_Request__c!=null)
            stFundReq.add(claim.Fund_Request__c);
         }
         List<SFDC_MDF__C> lstmf=[Select s.Name,s.CurrencyIsoCode, s.Account__c, s.Partner_Email__c, s.MDF_Program__r.MDF_Program__c, 
         s.MDF_Program__r.Id, s.MDF_Program__c,s.Partner_Name_for_Email__c, s.Id From SFDC_MDF__c s where s.Id in : stFundReq];
         for(SFDC_MDF__C mdf :lstmf)
         {
            mapMDF.put(mdf.Id,mdf);
            stMDFs.add(mdf.MDF_Program__r.MDF_Program__c);
         }
        List<Fund_Programs_Admin__c> lstFundProgramAdmin=[Select f.Id, f.Fund_Claim_Level_3_Approver__c, 
            f.Fund_Claim_Level_2_Approver__c, f.Fund_Claim_Level_1_Approver__c,
            f.Finance_Processor_Email__c,f.Program_Owner_for_questions__r.Email, 
            f.Program_Owner_for_questions__r.LastName, f.Program_Owner_for_questions__r.FirstName 
            From Fund_Programs_Admin__c f 
            where f.Id in :stMDFs];
        
        for(Fund_Programs_Admin__c fp :lstFundProgramAdmin)
        {
            mapFP.put(fp.Id,fp);
        }
        for (SFDC_MDF_Claim__c claim :lstClaims)
         {
             for(SFDC_MDF__C md :mapMDF.values())
             {
                for(Fund_Programs_Admin__c fpa:mapFP.values())
                {
                if(claim.Fund_Request__c==md.Id)
                {
                    mapMDFForEmail.put(claim.Id,md);
                    if(fpa.Id==md.MDF_Program__r.MDF_Program__c)
                    {
                        mapFP.put(claim.Id,fpa);
                    }
                }
                }   
             }
         }


          for (SFDC_MDF_Claim__c claim :lstClaims)
         {
            if(mapFP.containsKey(claim.Id))
            {
                Fund_Programs_Admin__c fp=mapFP.get(claim.Id);
                claim.Finance_Email__c=fp.Finance_Processor_Email__c;
                claim.Approver_1__c=fp.Fund_Claim_Level_1_Approver__c;
                claim.Approver_2__c=fp.Fund_Claim_Level_2_Approver__c;
                claim.Approver_3__c=fp.Fund_Claim_Level_3_Approver__c;
                claim.Program_Owner_Email__c=fp.Program_Owner_for_questions__r.Email;
                claim.Program_Owner_Name_for_Email__c=fp.Program_Owner_for_questions__r.FirstName+' '+fp.Program_Owner_for_questions__r.LastName; 
                claim.Account__c=mapMDFForEmail.get(claim.Id).Account__c;
                claim.CurrencyIsoCode=mapMDFForEmail.get(claim.Id).CurrencyIsoCode;
            //commented by Siddharth PRM R2: This is being done by workflow.
            /*  if(mapMDFForEmail.containsKey(claim.Id))
                {
                    claim.Fund_Champion_Name_for_Email__c=mapMDFForEmail.get(claim.Id).Partner_Name_for_Email__c;
                    claim.Partner_Email__c=mapMDFForEmail.get(claim.Id).Partner_Email__c;
                    claim.Account__c=mapMDFForEmail.get(claim.Id).Account__c;
                }  */
            }
         }                    
    }
    
    public static void populateOwnerOnProgramAdmin(List<Fund_Programs_Admin__c> ListOfMDFPrograms){
               for(Fund_Programs_Admin__c thisProgramAdmin: ListOfMDFPrograms){
            thisProgramAdmin.Program_Owner_for_questions__c=thisProgramAdmin.OwnerId;
                 }
    }
    
    public static void populateCAshare(List<Fund_Programs_Admin__c> ListOfMDFPrograms){
        for(Fund_Programs_Admin__c CAs: ListOfMDFPrograms){
            //set CA Share to 100% always MDF- amili01
                   CAs.CA_Share__c=decimal.valueOf(label.MDF_CA_Share);
        }
    }
    
    public static void ValidateClaimAmt_Insert(list<SFDC_MDF_Claim__c> NewClaimLst){
        // FRIds are Partner Fund Request Ids(SFDC_MDF__c) : PARMap is SFDC_MDF__c map 
        set<id> FRids=new set<id>();
        map<id,SFDC_MDF__c> PARMap;
        for(SFDC_MDF_Claim__c pp:NewClaimLst){
               FRids.add(pp.Fund_Request__c);
        }
        
        if(FRids != null && FRids.size()>0){
         PARMap=new Map<id,SFDC_MDF__c>([select id,Amount__c,CurrencyIsoCode,Available_Budget_for_Claim__c from SFDC_MDF__c where id in:FRids]);   
            if(PARMap != null && PARMap.size()>0){
                 Map<String,Decimal> mapOfConvesion = MDF_Utils.getCurrencyConversions();
                
                 for(SFDC_MDF_Claim__c mmd:NewClaimLst){
                      if(MDF_Utils.ByPassStampedCurr==false){
                            // using static variable to make sure only once in a transaction Stamp_ClaimCurrency__c is set 
                              mmd.Stamp_ClaimCurrency__c=mmd.CurrencyIsoCode+' '+mmd.Amount__c ;
                              MDF_Utils.ByPassStampedCurr=true;
                      }
                   
                     if(PARMap.containsKey(mmd.Fund_Request__c) && PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c != null ){ 
                         // If iso codes are same then no USD currency conversion is required 
                    	if(mmd.CurrencyIsoCode == PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode){
                        	if(mmd.Amount__c > PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c ){
                        		mmd.Amount__c.addError('The Claim Amount Cannot be greater than Approved Request Amount ');
                            }
                        }
                   	    else if(mmd.CurrencyIsoCode != PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode ){
                          // pf_amtUSD : Partner fund request amount in USD 
                          // Since the iso codes are different converting to a base currency USD for easy comparisions of amounts
                          // setting to scale 2 since while storing Salesforce takes 2 digits after decimal(.). So that amount comparisions are precise.
                            decimal pf_amtUSD=PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c/mapOfConvesion.get(PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode);
                            	if(pf_amtUSD!= null)
                            	pf_amtUSD=pf_amtUSD.setScale(2);
                        	decimal Claim_amtUSD=mmd.Amount__c/mapOfConvesion.get(mmd.CurrencyIsoCode);
                        		if(Claim_amtUSD != null)
                            	Claim_amtUSD=Claim_amtUSD.setScale(2);
                            decimal LocalClaimAmt;
                        	
                            if(Claim_amtUSD > pf_amtUSD){
                                mmd.Amount__c.addError('The Claim Amount Cannot be greater than Approved Request Amount ');  
                            }
                            else{
                                // pf curr = amt in usd * conversion
                                LocalClaimAmt=Claim_amtUSD * mapOfConvesion.get(PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode);
                                	if(LocalClaimAmt != null)
                                	LocalClaimAmt=LocalClaimAmt.setScale(2);
                                if(PARMap.get(mmd.Fund_Request__c).Amount__c < LocalClaimAmt){
                                    
                                    mmd.Amount__c=PARMap.get(mmd.Fund_Request__c).Amount__c;
                                }
                                else{
                                mmd.Amount__c=LocalClaimAmt;
                                }
                                 mmd.CurrencyIsoCode=PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode;
                            }    
                    }
                     }
                }
            }
        }
    }
    
    public static void ValidateClaimAmt_Update(list<SFDC_MDF_Claim__c> NewClaimLst,Map<id,SFDC_MDF_Claim__c> OldClaimMap){
        // FRIds are Partner Fund Request Ids(SFDC_MDF__c) : PARMap is SFDC_MDF__c map  
        set<id> FRids=new set<id>();
        map<id,SFDC_MDF__c> PARMap;
        for(SFDC_MDF_Claim__c pp:NewClaimLst){
            //If Status is rejected, the Rejection Reason should be mandatory
            if(pp.Status__c=='Rejected' && (string.isEmpty(pp.Rejection_Reason__c) || string.isBlank(pp.Rejection_Reason__c))){
                pp.Rejection_Reason__c.addError('Rejection Reason can not be blank, when Approval Status is Rejected'); 
            }
            if(OldClaimMap.get(pp.id).Status__c=='Submitted' && pp.Status__c=='Approved' && pp.CA_Reimbursement__c==null){
                pp.CA_Reimbursement__c.addError('Please enter CA Reimbursement value');
            }
                
            FRids.add(pp.Fund_Request__c);
        }
        
        if(FRids != null && FRids.size()>0){
            
         PARMap=new Map<id,SFDC_MDF__c>([select id,Amount__c,CurrencyIsoCode,Available_Budget_for_Claim__c from SFDC_MDF__c where id in:FRids]);
            
            if(PARMap != null && PARMap.size()>0){
                 
        		 Map<String,Decimal> mapOfConvesion = MDF_Utils.getCurrencyConversions();
        		
                 for(SFDC_MDF_Claim__c mmd:NewClaimLst){
                     
                      if(MDF_Utils.ByPassStampedCurr==false){
                          // using static variable to make sure only once in a transaction Stamp_ClaimCurrency__c is set 
                          // change the Stamp_ClaimCurrency__c value only if it is not equal to old value
                          
                          if(OldClaimMap != null && OldClaimMap.size()>0 && OldClaimMap.containsKey(mmd.id)){
                              System.debug('---old map is not done---');
                              if(OldClaimMap.get(mmd.id).Amount__c != mmd.Amount__c || mmd.CurrencyIsoCode != OldClaimMap.get(mmd.id).CurrencyIsoCode){
                                    mmd.Stamp_ClaimCurrency__c=mmd.CurrencyIsoCode+' '+mmd.Amount__c ;
                              }
                          }
                          
                      MDF_Utils.ByPassStampedCurr=true;
                      }
                     
                  if(PARMap.containsKey(mmd.Fund_Request__c) && PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c != null){
                    // If iso codes are same then no USD currency conversion is required                    
                    if(mmd.CurrencyIsoCode == OldClaimMap.get(mmd.id).CurrencyIsoCode && mmd.CurrencyIsoCode == PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode ){
                      /*  if(mmd.Amount__c != OldClaimMap.get(mmd.id).Amount__c ){
                            Decimal ActualAmt = PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c + OldClaimMap.get(mmd.id).Amount__c;
                             	if(ActualAmt != null)
                            	ActualAmt=ActualAmt.setScale(2);
							System.debug('+++++++++++++++++ amounts +++actual amt+++'+ActualAmt +'+++mmd.Amount__c ++'+mmd.Amount__c );                            
                        	if(mmd.Amount__c > ActualAmt ){
                        		mmd.Amount__c.addError('The Claim Amount Cannot be greater than Approved Request Amount ');
                            }
                        }*/
                        if(mmd.Amount__c > PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c ){
                        		mmd.Amount__c.addError('The Claim Amount Cannot be greater than Approved Request Amount ');
                            }
                        
                    }
                    else {
                           // pf_amtUSD : Partner fund request amount in USD 
                          // Since the iso codes are different converting to a base currency USD for easy comparisions of amounts
                          // setting to scale 2 since while storing Salesforce takes 2 digits after decimal(.). So that amount comparisions are precise.
                            decimal pf_amtUSD=PARMap.get(mmd.Fund_Request__c).Available_Budget_for_Claim__c/mapOfConvesion.get(PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode);
                            	if(pf_amtUSD != null)
                        		pf_amtUSD=pf_amtUSD.setScale(2);
                        	decimal oldClaim_amtUSD=OldClaimMap.get(mmd.id).Amount__c/mapOfConvesion.get(OldClaimMap.get(mmd.id).CurrencyIsoCode);
                            	if(oldClaim_amtUSD != null)
                        		oldClaim_amtUSD=oldClaim_amtUSD.setScale(2);
                            decimal FClaim_amtUSD=mmd.Amount__c/mapOfConvesion.get(mmd.CurrencyIsoCode);
                            	if(FClaim_amtUSD != null)
                        		FClaim_amtUSD=FClaim_amtUSD.setScale(2);
                            decimal LocalClaimAmt;
                            decimal ActualAmt=pf_amtUSD + oldClaim_amtUSD;
                            	if(ActualAmt != null)
                        		ActualAmt= ActualAmt.setScale(2);
                        	
                          /*  if(FClaim_amtUSD > ActualAmt){
                                mmd.Amount__c.addError('The Claim Amount Cannot be greater than Approved Request Amount ');  
                            } */
                        	if(FClaim_amtUSD > pf_amtUSD){
                            	mmd.Amount__c.addError('The Claim Amount Cannot be greater than Approved Request Amount ');  
                        	}
                            else{
                                // pf curr = amt in usd * conversion
                                LocalClaimAmt=FClaim_amtUSD * mapOfConvesion.get(PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode);
                                	if(LocalClaimAmt!= null)
                                	LocalClaimAmt=LocalClaimAmt.setScale(2);
                                if(PARMap.get(mmd.Fund_Request__c).Amount__c < LocalClaimAmt){
                                    
                                    mmd.Amount__c=PARMap.get(mmd.Fund_Request__c).Amount__c;
                                }
                                else{
                                mmd.Amount__c=LocalClaimAmt;
                                }
                                 mmd.CurrencyIsoCode=PARMap.get(mmd.Fund_Request__c).CurrencyIsoCode;
                            }
                          
                            
                    }
                     }
                }
            }
        }
    }
    
  /*     
    @isTest(SeeAllData=true)
    public static void MDF_Utils_test() {
    	List<SFDC_MDF_Claim__c> listClaims = [Select Id, Fund_Request__c from SFDC_MDF_Claim__c LIMIT 1];
    	MDF_Utils.PopulateApproversOnFundClaim(listClaims);
    	Fund_Programs_Admin__c prg = new Fund_Programs_Admin__c(OwnerId = UserInfo.getUserId());
    	List<Fund_Programs_Admin__c> listProg = new List<Fund_Programs_Admin__c>();
    	listProg.add(prg);
        //Map<id,Fund_Programs_Admin__c> MapProg = new Map<id,Fund_Programs_Admin__c>(listProg);
    	MDF_Utils.populateOwnerOnProgramAdmin(listProg); 
    }
 */
}