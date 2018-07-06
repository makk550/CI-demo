/* class to validate the rejection reason during MDF Request approval process
Created by - Jon Holato
*/
public with sharing class MDF_RejectionReasonMandatoryOnRequest {
    SFDC_MDF__c OldRequest=new SFDC_MDF__c();
    SFDC_MDF__c NewRequest=new SFDC_MDF__c();
  
    /**** 
    * US498557 : amili01
    * validation to enter MDF_MFM_ID__c if MDF_Request_Approval_Status__c is First Approval 
    * validation to enter PO id 
    * Rejection code and reason validations 
   ****/
    
    public void validationMDFId_PoID(Map<id,SFDC_MDF__c> NewRequestMap,Map<id,SFDC_MDF__c> OldRequestMap){
    list<SFDC_MDF__c> mdflist=New list<SFDC_MDF__c>();
        for(id mdf:NewRequestMap.keySet()){
            
            if( OldRequestMap.get(mdf).Status__c=='Sent To Finance' && (NewRequestMap.get(mdf).Status__c=='Rejected' )){ 
                if(string.isBlank(NewRequestMap.get(mdf).Finance_Reason_code__c) && string.isBlank(NewRequestMap.get(mdf).FinanceRejectionReason__c) ){
                    NewRequestMap.get(mdf).Finance_Reason_code__c.addError('Finance Rejection Code and Finance Rejection Reason cannot be blank');
                }
                if(string.isBlank(NewRequestMap.get(mdf).Finance_Reason_code__c))
                     NewRequestMap.get(mdf).Finance_Reason_code__c.addError('Finance Rejection Code cannot be blank, when Approval status is rejected');
                
                if(string.isBlank(NewRequestMap.get(mdf).FinanceRejectionReason__c))
                NewRequestMap.get(mdf).FinanceRejectionReason__c.addError('Finance Rejection Reason can not be blank, when Approval Status is Rejected'); 
            }
            else if(NewRequestMap.get(mdf).Status__c=='Rejected'){
                if(string.isBlank(NewRequestMap.get(mdf).Rejection_Reason__c) && string.isBlank(NewRequestMap.get(mdf).PMM_Reason_Code__c) ){
                    NewRequestMap.get(mdf).Rejection_Reason__c.addError('Rejection Reason and Partner Marketer Reason Code can not be blank');
                }
                else if(string.isBlank(NewRequestMap.get(mdf).Rejection_Reason__c)){      NewRequestMap.get(mdf).Rejection_Reason__c.addError('Rejection Reason can not be blank, when Approval Status is Rejected'); 
                    }   
                    else if(string.isBlank(NewRequestMap.get(mdf).PMM_Reason_Code__c)){   NewRequestMap.get(mdf).PMM_Reason_Code__c.addError('Partner Marketer Reason Code can not be blank, when Approval Status is Rejected');
                    }
            }
            
            if( OldRequestMap.get(mdf).MDF_Request_Approval_Status__c == 'Submitted' && string.isBlank(NewRequestMap.get(mdf).MDF_MFM_ID__c) ){
                if(NewRequestMap.get(mdf).MDF_Request_Approval_Status__c != 'Submitted'){
                NewRequestMap.get(mdf).MDF_MFM_ID__c.addError('Please enter MFM ID #'); 
                }
            } 
            
            if( string.isBlank(NewRequestMap.get(mdf).CA_Purchase_Order_Number__c) && OldRequestMap.get(mdf).Status__c == 'PO Clearance Obtained' ){
                if(NewRequestMap.get(mdf).Status__c != 'PO Clearance Obtained' && NewRequestMap.get(mdf).Status__c == 'Approved'){
                		NewRequestMap.get(mdf).CA_Purchase_Order_Number__c.addError('Please enter CA Purchase Order Number:');
                }
            }
        
        }
    
    }
    
 
    
    public void BfUpdate_CurrVal(Map<id,SFDC_MDF__c> NewMdfMap,Map<id,SFDC_MDF__c> OldMdfMap){
        
        map<id,SFDC_Budget__c> BudgetMap;       
        set<id> BudgetIds=new set<id>();
        
        //  Currency Type is having conversion rates with respect to USD, so in calculations below amounts are converted to usd for conversions
        //  then are converted back if required.  usd= amount/conversionRate. 
        
        Map<String,Decimal> mapOfConvesion = MDF_Utils.getCurrencyConversions();
        
        if(mapOfConvesion != null && mapOfConvesion.size()>0){    
        	for(id pp:NewMdfMap.keySet()){
              BudgetIds.add(NewMdfMap.get(pp).Budget__c);
        }
        
        	if(BudgetIds != null && BudgetIds.size()>0){
            BudgetMap=new Map<id,SFDC_Budget__c>([select CurrencyIsoCode,Available_Budget__c from SFDC_Budget__c where id in:BudgetIds]);
                       
            if(BudgetMap != null && BudgetMap.size()>0){
                for(id mmd:NewMdfMap.keySet()){
                    if(MDF_Utils.ByPassStampedCurr==false){
                        // using static variable to make sure only once in a transaction Stamped_Currency__c is set 
                        // change the Stamped_Currency__c value only if it is not equal to old value
                        if(OldMdfMap.containsKey(mmd)){
                            if(OldMdfMap.get(mmd).Amount__c != NewMdfMap.get(mmd).Amount__c || NewMdfMap.get(mmd).CurrencyIsoCode != OldMdfMap.get(mmd).CurrencyIsoCode){
                                    NewMdfMap.get(mmd).Stamped_Currency__c=NewMdfMap.get(mmd).CurrencyIsoCode +' '+NewMdfMap.get(mmd).Amount__c;
                            }
                        }
                        MDF_Utils.ByPassStampedCurr=true;
                    }
                    
                    if(BudgetMap.containsKey(NewMdfMap.get(mmd).Budget__c) ){
                        if(BudgetMap.get(NewMdfMap.get(mmd).Budget__c).Available_Budget__c != null ){
                        // The old and new iso curr codes of SFDC_MDF__c are same and are equal to SFDC_Budget__c iso code as well then no conversion to USD is done.
                    	if(NewMdfMap.get(mmd).CurrencyIsoCode == OldMdfMap.get(mmd).CurrencyIsoCode && NewMdfMap.get(mmd).CurrencyIsoCode == BudgetMap.get(NewMdfMap.get(mmd).Budget__c).CurrencyIsoCode){
                            // if new amount entered is different than old amount then check with available amount from budget
                            if(NewMdfMap.get(mmd).Amount__c != OldMdfMap.get(mmd).Amount__c ){
                                Decimal ActualAmt = BudgetMap.get(NewMdfMap.get(mmd).Budget__c).Available_Budget__c + OldMdfMap.get(mmd).Amount__c;
                                if(ActualAmt != null){
                                    ActualAmt=ActualAmt.setScale(2);
                                }
                                
                                if(NewMdfMap.get(mmd).Amount__c > ActualAmt){ NewMdfMap.get(mmd).Amount__c.addError('The activity amount cannot exceed the available fund amount'); 
                                }
                                
                            }
                            
                        }
                    	else{
                             // SFDC_MDF_c variable as : oldMDF_amtUSD and MDF_amtUSD
                             // Since the iso codes are different converting to a base currency USD for easy comparisions of amounts
                             // setting to scale 2 since while storing Salesforce takes 2 digits after decimal(.). So that amount comparisions are precise.
                            decimal Budget_amtUSD=BudgetMap.get(NewMdfMap.get(mmd).Budget__c).Available_Budget__c/mapOfConvesion.get(BudgetMap.get(NewMdfMap.get(mmd).Budget__c).CurrencyIsoCode);
                            	if(Budget_amtUSD != null)
                            	Budget_amtUSD=Budget_amtUSD.setScale(2);
                            decimal oldMDF_amtUSD=OldMdfMap.get(mmd).Amount__c/mapOfConvesion.get(OldMdfMap.get(mmd).CurrencyIsoCode);
                            	if(oldMDF_amtUSD != null)
                            	oldMDF_amtUSD=oldMDF_amtUSD.setScale(2);
                            decimal MDF_amtUSD=NewMdfMap.get(mmd).Amount__c/mapOfConvesion.get(NewMdfMap.get(mmd).CurrencyIsoCode);
                            	if(MDF_amtUSD != null)
                            	MDF_amtUSD=MDF_amtUSD.setScale(2);
                            decimal LocalMdfAmt;
                            decimal ActualAmt=Budget_amtUSD + oldMDF_amtUSD;
                            	if(ActualAmt != null)
                            	ActualAmt= ActualAmt.setScale(2);
                            if(MDF_amtUSD > ActualAmt){ NewMdfMap.get(mmd).Amount__c.addError('The activity amount cannot exceed the available fund amount');  
                            }
                            else{
                                
                                // local curr = amt in usd * conversion
                                LocalMdfAmt=MDF_amtUSD * mapOfConvesion.get(BudgetMap.get(NewMdfMap.get(mmd).Budget__c).CurrencyIsoCode);
                                	if(LocalMdfAmt != null)
                                	LocalMdfAmt=LocalMdfAmt.setScale(2);
                                if(BudgetMap.get(NewMdfMap.get(mmd).Budget__c).Available_Budget__c < LocalMdfAmt){ NewMdfMap.get(mmd).Amount__c=BudgetMap.get(NewMdfMap.get(mmd).Budget__c).Available_Budget__c;
                                }
                                else{
                                NewMdfMap.get(mmd).Amount__c=LocalMdfAmt;
                                }
                                NewMdfMap.get(mmd).CurrencyIsoCode=BudgetMap.get(NewMdfMap.get(mmd).Budget__c).CurrencyIsoCode;
                                
                            }
                        }
                    } } 
                    }
                   
                }
            }
        }
        }  
}