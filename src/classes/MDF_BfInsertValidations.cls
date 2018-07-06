/****
 * user stories :  US498557,US505382
 * Author : amili01 
****/
public class MDF_BfInsertValidations {
    
     public void Validate_Bfins(list<SFDC_MDF__c> NewMdfList){
         // PFIds contain the BudgetIds : PFMap is the Budget Map(SFDC_Budget__c) : PFE_PFList is the list of Budget entries which have related Budget
         //ExpdateMap is a map to avoid creation of SFDC_MDF__c(Fund Request) after expiration dates.
         
        map<id,SFDC_Budget__c> PFMap;
        list<SFDC_Budget_Entry__c> PFE_PFList;   
        map<id,date> ExpdateMap=new map<id,date>();
        set<id> PFIds=new set<id>();
        
        //  Currency Type is having conversion rates with respect to USD, so in calculations below amounts are converted to usd for conversions
        //  then are converted back if required.  usd= amount/conversionRate. 
        
        Map<String,Decimal> mapOfConvesion = MDF_Utils.getCurrencyConversions();
         
        for(SFDC_MDF__c pp:NewMdfList){
            System.debug('++++++++++++++++ '+pp.Budget__c);
            PFIds.add(pp.Budget__c);
        }
         
        if(PFIds != null && PFIds.size()>0){
            
            // SFDC_Budget__c - Partner Fund; SFDC_Budget_Entry__c - Partner Fund Entry;
            PFMap=new Map<id,SFDC_Budget__c>([select CurrencyIsoCode,Available_Budget__c,Total_Active_Budget__c from SFDC_Budget__c where id in:PFIds]);
            PFE_PFList=[select Budget__c,Expiration_Date__c from SFDC_Budget_Entry__c where Budget__c in :PFIds];

            // Validation - Fund request should not be created after expiration date
            if(PFE_PFList != null && PFE_PFList.size()>0){
                
                for(SFDC_Budget_Entry__c pfe:PFE_PFList){
               		ExpdateMap.put(pfe.Budget__c,pfe.Expiration_Date__c); 
                }
                
                if(ExpdateMap != null && ExpdateMap.size()>0){
                	for(SFDC_MDF__c mp:NewMdfList){
                    	date createdt=system.today();
                    	if(createdt > ExpdateMap.get(mp.Budget__c)){
                        mp.addError('Partner Fund Entry is expired. Fund Request cannot be created');
                    	}
                	}
                 }
            }
            
            //US505382: Currency Conversion 
            if(PFMap != null && PFMap.size()>0){
                
                for(SFDC_MDF__c mmd:NewMdfList){
                    // using static variable to make sure only once in a transaction Stamped_Currency__c is set 
                   // change the Stamped_Currency__c value only if it is not equal to old value
                    if(MDF_Utils.ByPassStampedCurr==false){
                    mmd.Stamped_Currency__c=mmd.CurrencyIsoCode+' '+mmd.Amount__c;
                        MDF_Utils.ByPassStampedCurr=true;
                    }
                    
                    if(PFMap.containsKey(mmd.Budget__c) && PFMap.get(mmd.Budget__c).Available_Budget__c!= null ){
                        if(PFMap.get(mmd.Budget__c).Total_Active_Budget__c >0){
                     		if(mmd.CurrencyIsoCode == PFMap.get(mmd.Budget__c).CurrencyIsoCode){
                         //If fund request and SFDC_Budget__c iso codes are equal then no conversion is needed
                       	 if(mmd.Amount__c > PFMap.get(mmd.Budget__c).Available_Budget__c ){
                        mmd.Amount__c.addError('The activity amount cannot exceed the available fund amount');
                         }
                     }
                    		else if(mmd.CurrencyIsoCode != PFMap.get(mmd.Budget__c).CurrencyIsoCode ){
                        // Since the iso codes are different converting to a base currency USD for easy comparisions of amounts
                       // setting to scale 2 since while storing Salesforce takes 2 digits after decimal(.). So that amount comparisions are precise.
                       
                            decimal pf_amtUSD=PFMap.get(mmd.Budget__c).Available_Budget__c/mapOfConvesion.get(PFMap.get(mmd.Budget__c).CurrencyIsoCode);
                            	if(pf_amtUSD != null)
                        		pf_amtUSD=pf_amtUSD.setScale(2);
                        	decimal fr_amtUSD=mmd.Amount__c/mapOfConvesion.get(mmd.CurrencyIsoCode);
                        		if(fr_amtUSD != null)
                        		fr_amtUSD=fr_amtUSD.setScale(2);
                            decimal fr_pfamt;
                        	
                            if(fr_amtUSD > pf_amtUSD){
                                mmd.Amount__c.addError('The activity amount cannot exceed the available fund amount');  
                            }
                            else{
                                // pf curr = amt in usd * conversion
                                fr_pfamt=fr_amtUSD * mapOfConvesion.get(PFMap.get(mmd.Budget__c).CurrencyIsoCode);
                                	if(fr_pfamt != null)
                                	fr_pfamt=fr_pfamt.setScale(2);
                                if(PFMap.get(mmd.Budget__c).Available_Budget__c < fr_pfamt){
                                    
                                    mmd.Amount__c=PFMap.get(mmd.Budget__c).Available_Budget__c;
                                }
                                else{
                                mmd.Amount__c=fr_pfamt;
                                }
                                 mmd.CurrencyIsoCode=PFMap.get(mmd.Budget__c).CurrencyIsoCode;
                            }
                          
                    }
                        }
                        else{
                            mmd.adderror('Insuffcient Funds request cannot be created');
                        }
                    }
                }
            }
            
        }
       
    }

}