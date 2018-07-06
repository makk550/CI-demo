@isTest
private class Renewal_MoveACPController_Test {
  public static testmethod void testMoveRenewals(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        Renewals_Util.fromAfterTrigger = true;
        Renewal_ConvertActiveContracts.fromClass = true;


        try 
        {
        Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert ac;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        
        Product2 prod = new Product2(Name = 'TestProd');
        insert prod;      
                
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        insert activeContract;   
        
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=ac.Id,Projected_Renewal__c=200, segmentation__c='HT');
        insert renewal;
            
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);
        insert rnwlProdct;        
        
        List<Active_Contract_Product__c> acpList = new List<Active_Contract_Product__c>();
        
        
        Active_Contract_Product__c actvContPrd1 = new Active_Contract_Product__c(name='TestACP1',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id );
       // insert actvContPrd1;
       acpList.add(actvContPrd1);
                
        Active_Contract_Product__c actvContPrd2a = new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd2a;
       acpList.add(actvContPrd2a); 
               
        Active_Contract_Product__c actvContPrd3 = new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd3;
       acpList.add(actvContPrd3); 
               
        Active_Contract_Product__c actvContPrd4 = new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id, Pre_Segmentation__c='LT');
       // insert actvContPrd4;
       acpList.add(actvContPrd4); 
               
        Active_Contract_Product__c actvContPrd5 = new Active_Contract_Product__c(name='TestACP5',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd5;
       acpList.add(actvContPrd5);
        
        Active_Contract_Product__c actvContPrd6 = new Active_Contract_Product__c(name='TestACP6',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd6;
        acpList.add(actvContPrd6);
        
        Active_Contract_Product__c actvContPrd7 = new Active_Contract_Product__c(name='TestACP7',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd7;      
        acpList.add(actvContPrd7);
        
        Active_Contract_Product__c actvContPrd8 = new Active_Contract_Product__c(name='TestACP8',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd8;      
        acpList.add(actvContPrd8);
        
        Active_Contract_Product__c actvContPrd9 = new Active_Contract_Product__c(name='TestACP9',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd9;
        acpList.add(actvContPrd9); 
               
        Active_Contract_Product__c actvContPrd10 = new Active_Contract_Product__c(name='TestACP10',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd10;
        acpList.add(actvContPrd10);
        
        Active_Contract_Product__c actvContPrd11 = new Active_Contract_Product__c(name='TestACP11',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
       // insert actvContPrd11; 
        acpList.add(actvContPrd11);
               
        insert acpList;
                  
        Active_Contract_Line_Item__c acli = new Active_Contract_Line_Item__c(Name='Test',Contract_Product__c=actvContPrd1.Id,AOCV__c=10,ATTRF_CRV__c=10,OCV__c=10,Raw_Maint_Calc_LC__c=10);
        insert acli;
       
        
      
       
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        insert rnwlContrct;
                
        Product2 prod2 = new Product2(Name = 'TestProd2');
        insert prod2;       
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=ac.Id);
        insert renewal2;
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac.Id);
        insert activeContract2;
        Renewal_Product__c rnwlProdct2= new Renewal_Product__c(name='TestRnwlPrdct2',Product__c=prod2.Id,Renewal__c=renewal2.Id);
        insert rnwlProdct2;
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct2.Id,Product__c=prod2.Id);
        insert actvContPrd2;
                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        insert rnwlContrct2;
        ApexPages.StandardController acctPage = new ApexPages.StandardController(activeContract);
        Renewal_MoveACPController ctrl = new Renewal_MoveACPController(acctPage);
        if(!ctrl.lstACP.isEmpty()){
           ctrl.lstACP[0].sel = true;
           ctrl.selectedRenewal = renewal2.Id;
           ctrl.moveRenewals();
           ctrl.reasonForInvalidate = 'Invalid - Education';
           ctrl.InvalidateACP();
           ctrl.UnAttachACP(); 
           ctrl.fetchRenewals(ac.Id);
        }
        
        if(!ctrl.lstACP.isEmpty()){
           ctrl.lstACP[0].sel = false;
           ctrl.selectedRenewal = renewal2.Id;
           ctrl.moveRenewals();
           ctrl.reasonForInvalidate = '';
           ctrl.InvalidateACP();
           ctrl.UnAttachACP(); 
           ctrl.fetchRenewals(ac.Id);
        }

        if(!ctrl.lstACP.isEmpty()){
           ctrl.lstACP[0].sel = true;
           ctrl.selectedRenewal ='';
           ctrl.moveRenewals();
           ctrl.reasonForInvalidate = 'Invalid - Education';
           ctrl.InvalidateACP();
           ctrl.UnAttachACP(); 
           ctrl.fetchRenewals(ac.Id);
        }

        if(!ctrl.lstACP.isEmpty()){
           ctrl.lstACP[0].sel = true;
           ctrl.selectedRenewal ='';
           ctrl.moveRenewals();
           ctrl.reasonForInvalidate = '';
           ctrl.InvalidateACP();
           ctrl.UnAttachACP(); 
           ctrl.fetchRenewals(ac.Id);
           
       }
       
       if(!ctrl.lstACP.isEmpty()){
       ctrl.getPageSize();
       ctrl.setPageSize(1);
       ctrl.gethasnext();
       ctrl.next();
       ctrl.gethasprevious();
       ctrl.previous();
      
       }
       
       if(!ctrl.lstACP.isEmpty()){
        ctrl.getlstACP();      
       }
       
       if(!ctrl.lstACP.isEmpty()){
          ctrl.lstACP[0].sel = true;
          ctrl.UnAttachACP();      
          ctrl.SegChangeReason='None';
          ctrl.moveRenewals();          
       }
       
       
        try{
        //update for Projected Renewal
        renewal.Projected_Renewal__c = 100;
        Renewals_Util.fromRenewals_RollupRPToRenewal = false;
        update renewal;

         
        
           // statement to call trigger Renewals_UpdateProRenOnRP 
            //update renewal;
          
          // statement to call trigger Renewals_PreventToDelete
          delete renewal2;
        }catch(Exception ex){}
        
        }
        catch(Exception ex){
        
        
        }
        
                
        
        // class methods
       }
       
        
     }