trigger Account_MIPSupdate on Active_Contract_Line_Item__c (after insert, after update) {

Set<ID> acliID = new Set<ID>();
Set<ID> accID = new Set<ID>();
Integer Prev;
List<Account> accMIPSUpdt = new List<Account>(); 
List<Active_Contract_Line_Item__c>  activeProduct1 = new List<Active_Contract_Line_Item__c>();
public set<ID>  ActiveContratID  = new set<Id>(); 
public Integer Cost_Per_MIPs =0;

if(Trigger.isUpdate)
{
 
    ActiveContratID.AddAll(Trigger.OldMap.KeySet());   
}
if ( Trigger.isInsert)
{
     ActiveContratID.AddAll(Trigger.NewMap.KeySet());
}

 

For( active_contract_line_item__c  activeProduct :[select id,Authorized_Use_Model_text__c,contract_product__r.Active_Contract__c,contract_product__r.Active_Contract__r.Account__c  from active_contract_line_item__c where id in :ActiveContratID] )
{
    accID.add(activeProduct.contract_product__r.Active_Contract__r.Account__c) ;
}

                    activeProduct1  = [select id,Authorized_Use_Model_text__c,Licensed_MIPS_Quantity__c,contract_product__r.Active_Contract__c,contract_product__r.Active_Contract__r.Account__c,contract_product__r.Active_Contract__r.AOCV__c 
                    from active_contract_line_item__c where contract_product__r.Active_Contract__r.Account__c in :accID  and  contract_product__r.Active_Contract__r.Account__c != null
                    and Authorized_Use_Model_text__c = 'MIPS LICENSE'    order by   contract_product__r.Active_Contract__r.Account__c
                    ,contract_product__r.Active_Contract__c,Licensed_MIPS_Quantity__c desc];            


                    accMIPSUpdt = [select id,Authorized_Use_Model__c,Max_Licensed_MIPS__c,Cost_Per_MIPS__c from Account where id in :accID  order by id];  
    
     if(trigger.isinsert  || trigger.isupdate)
        {                
             
               //ActiveContract_Prev = activeProduct1[0].Active_Contract__c ;
            for(integer j=0 ; j < accMIPSUpdt.size() ; j++  ) 
            {
                Prev = 0; 
                //accMIPSUpdt[j].Max_Licensed_MIPS__c = 0 ; ---***---Commented for CR:191138508    
                accMIPSUpdt[j].Cost_Per_MIPS__c  =0;
                Cost_Per_MIPs = 0 ;
                if(activeProduct1.size()!=0)
                {
                    for(integer i=0; i < activeProduct1.size();i++ )
                        {
                            
                            if((activeProduct1.size() > 0) && (activeProduct1[i].contract_product__r.Active_Contract__r.Account__c == accMIPSUpdt[j].id))
                            {                                         
                                accMIPSUpdt[j].Authorized_Use_Model__c = 'MIPS';                                                        
                                if(i == 0)
                                {                               
                                   //accMIPSUpdt[j].Max_Licensed_MIPS__c = accMIPSUpdt[j].Max_Licensed_MIPS__c  +  activeProduct1[i].Licensed_MIPS_Quantity__c;---***---Commented for CR:191138508

                                   accMIPSUpdt[j].Cost_Per_MIPS__c =  accMIPSUpdt[j].Cost_Per_MIPS__c + activeProduct1[i].contract_product__r.Active_Contract__r.AOCV__c  ;//(activeProduct1[i].contract_product__r.Active_Contract__r.AOCV__c / activeProduct1[i].Licensed_MIPS_Quantity__c);                                
                                   Prev = i;
                                }
                                else if(activeProduct1[i].contract_product__r.Active_Contract__c != activeProduct1[Prev].contract_product__r.Active_Contract__c) 
                                {
                                  //accMIPSUpdt[j].Max_Licensed_MIPS__c = accMIPSUpdt[j].Max_Licensed_MIPS__c  +  activeProduct1[i].Licensed_MIPS_Quantity__c;---***---Commented for CR:191138508                              
                                  accMIPSUpdt[j].Cost_Per_MIPS__c =  accMIPSUpdt[j].Cost_Per_MIPS__c +activeProduct1[i].contract_product__r.Active_Contract__r.AOCV__c ; //(activeProduct1[i].contract_product__r.Active_Contract__r.AOCV__c / activeProduct1[i].Licensed_MIPS_Quantity__c);                                                            
                                  Prev = i; 
                                }                                                        
                            }
                           
                        }
                    }
                    else
                        {
                          accMIPSUpdt[j].Authorized_Use_Model__c = 'Non-MIPS';
                          //accMIPSUpdt[j].Max_Licensed_MIPS__c= 0;---***---Commented for CR:191138508  
                        }
                    
                    if(accMIPSUpdt[j].Authorized_Use_Model__c == 'MIPS')  
                    {
                     
                        if(accMIPSUpdt[j].Max_Licensed_MIPS__c!=0)
                        accMIPSUpdt[j].Cost_Per_MIPS__c = accMIPSUpdt[j].Cost_Per_MIPS__c / accMIPSUpdt[j].Max_Licensed_MIPS__c ; 
                    }
             }                   
                 update accMIPSUpdt;
        }                    
  }