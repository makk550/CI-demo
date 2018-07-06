public class Renewal_editContractHeaderInfo {
    public static boolean isRespread {get;set;}
    public Decimal AOCVLC {get;set;}
    public Decimal AOCVLC_Input {get;set;}
    public Decimal TARRLC {get;set;}
    public Decimal OldTARRLC {get;set;}
    public Decimal OCVLC {get;set;}
    public Decimal ATTRFCRV {get;set;}
    public Decimal ATTRFCRV_Input {get;set;}
    public Decimal ContractualCapPerc {get;set;}
    public Decimal TotalRawMaintCalc {get;set;}
    public Decimal TotalRawMaintCalc_Input {get;set;}
    public Decimal TotalCurrAnnExistMaint {get;set;}
    public Decimal AdjATRRF {get;set;}
 
    public Decimal ContractedRenewalAmnt{get;set;}
    public String RenewalValuationType {get;set;}
    public Active_Contract__c  contract {get;set;}   
    public Decimal TotalATTRF {get;set;}   
    public Decimal TotalAOCVLC {get;set;}
    public string chkOCV_OCV {get;set;}
    public string chkTRR_TRR {get;set;}
    public string chkContrRen_RawMaint {get;set;}
    public Decimal TotalOCVCalc {get;set;}  //danva01
    public Decimal TotalOriginalATTRF {get;set;}  //danva01
    
    public List<Active_Contract_Line_Item__c> activecontractlineItems;
    String contractid; 
    
    //fromPage
    
    public Renewal_editContractHeaderInfo(ApexPages.StandardController controller) {
        this.contract=(Active_Contract__c)controller.getRecord(); 
        //contract = ;
        //System.debug('contract$$$ '+contract);      
        activecontractlineItems =new List<Active_Contract_Line_Item__c>();
        for(Active_Contract_Line_Item__c ACL: [Select Id,Name,AOCV__c,ATTRF_CRV__c,Contracted_Renewal_Amount__c,Orig_ATTRF_LC__c,
                                                    Contractual_Cap_Percentage__c,Current_Annu_Existing_Maintenance__c,
                                                    OCV__c,Raw_Maint_Calc_LC__c,Revenue_Per_Day__c,Raw_Maintenance_LC__c,
                                                    Renewal_Valuation_Type__c,Adjusted_ATTRF_LC__c,
                                                    Distribution_Option_TRR__c,Distribution_Option_OCV__c, Material_TARR_LC__c, //merha02
                                                    Distribution_Opotion_CntrRenAmt__c,
                                                    Contract_Product__r.Active_Contract__r.ATTRF_CRV__c,
                                                    Contract_Product__r.Active_Contract__r.OCV__c,
                                                    Contract_Product__r.Active_Contract__r.AOCV__c,
                                                    Contract_Product__r.Active_Contract__r.Raw_Maint_Calc_LC__c,
                                                    Contract_Product__r.Active_Contract__r.Financed_TRR_LC__c,
                                                    Contract_Product__r.Active_Contract__r.Finance_ATTRF__c,
                                                    Contract_Product__r.Active_Contract__r.Revenue_Per_Day__c,
                                                    Contract_Product__r.Active_Contract__r.Contracted_Renewal_Amount_LC__c,
                                                    Contract_Product__r.Active_Contract__r.Contractual_Cap_Percentage__c,
                                                    Contract_Product__r.Active_Contract__r.Renewal_Valuation_Type__c,
                                                    Contract_Product__r.Active_Contract__r.In_Progress__c,
                                                    Contract_Product__r.Active_Contract__r.Comments__c,
                                                    Contract_Product__r.Active_Contract__r.CRV_Process_completed__c,
                                                    Contract_Product__r.Active_Contract__r.Adjusted_ATTRF_LC__c,
                                                   
                                               		Contract_Product__r.Active_Contract__r.Total_TARR_LC__c, //merha02
                                                    Contract_Product__r.Active_Contract__r.Financed_OCV__c,
                                                    Contract_Product__r.Active_Contract__r.Current_Ann_Existing_Maintenance_LC__c                                                    
                                                    from Active_Contract_Line_Item__c where  Contract_Product__r.Active_Contract__r.Id =:contract.Id])
        {                           
            activecontractlineItems.add(ACL);
        }
        if(activecontractlineItems.size()>0){
           chkOCV_OCV =  activecontractlineItems.get(0).Distribution_Option_OCV__c;
           chkTRR_TRR =  activecontractlineItems.get(0).Distribution_Option_TRR__c;
           chkContrRen_RawMaint= activecontractlineItems.get(0).Distribution_Opotion_CntrRenAmt__c;
           
            TARRLC = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Total_TARR_LC__c;
            if(TARRLC== null)
                TARRLC=0;
            OldTARRLC = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Total_TARR_LC__c;
            
            OCVLC = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.OCV__c;
            if(OCVLC == null)
                OCVLC = 0;
                
            AdjATRRF = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Adjusted_ATTRF_LC__c;
               
            ATTRFCRV = (activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.ATTRF_CRV__c);
            if(ATTRFCRV == null)
                ATTRFCRV = 0;
            ATTRFCRV_Input = ATTRFCRV;            
            AOCVLC = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.AOCV__c;
            if(AOCVLC == null)
                AOCVLC = 0;
            AOCVLC_Input = AOCVLC;
                                  
            TotalRawMaintCalc = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Raw_Maint_Calc_LC__c;  
            //danva01
            TotalOCVCalc  = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.OCV__c; 
            TotalAOCVLC  =  activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.AOCV__c; 
                              
            if(TotalRawMaintCalc == null)
                TotalRawMaintCalc = 0;
            
             //danva01
            if(TotalOCVCalc == null)
                TotalOCVCalc = 0;
                        
            TotalRawMaintCalc_Input = TotalRawMaintCalc;
            //AdjATRRF = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Adjusted_ATTRF_LC__c;
            TotalATTRF  = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.ATTRF_CRV__c;

            if(AdjATRRF == null)
                AdjATRRF = 0;
             
            TotalCurrAnnExistMaint = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Current_Ann_Existing_Maintenance_LC__c;                          
            contract.Financed_OCV__c= activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Financed_OCV__c;
            ContractedRenewalAmnt = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Contracted_Renewal_Amount_LC__c;
            contract.Contractual_Cap_Percentage__c = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Contractual_Cap_Percentage__c;
            contract.Renewal_Valuation_Type__c = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Renewal_Valuation_Type__c;
            contract.CRV_Process_completed__c = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.CRV_Process_completed__c;
            contract.In_Progress__c = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.In_Progress__c;
            contract.Finance_ATTRF__c = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Finance_ATTRF__c;
            contract.Financed_TRR_LC__c = activecontractlineItems.get(0).Contract_Product__r.Active_Contract__r.Financed_TRR_LC__c;
            }

    }
    
    public pageReference UpdateContractValues()
    {
        try
        { 
            if(TotalRawMaintCalc == null || TotalRawMaintCalc  ==0)
                TotalRawMaintCalc = TotalRawMaintCalc_Input;
            /*danva01*/
             if(TotalOCVCalc == null || TotalOCVCalc  ==0)
                TotalOCVCalc = OCVLC;
          
            for(Active_Contract_Line_Item__c lineitem :activecontractlineItems)
            {
                       if(lineItem.AOCV__c != null)
                {

                 /*OCV -- done*/

                  if (chkOCV_OCV == 'OCV' && TotalOCVCalc != 0)
                  {
                      lineItem.OCV__c=(lineItem.OCV__c/TotalOCVCalc)*OCVLC ;                     
                  }
                  else if (chkOCV_OCV == 'RawMaintenance') 
                  {
                      lineItem.OCV__c=(lineItem.Raw_Maintenance_LC__c/TotalRawMaintCalc)*OCVLC ;                   
                  }
                 
                  lineItem.Distribution_Option_OCV__c = chkOCV_OCV;
                  System.debug ('lineItem.OCV__c --> ' + lineItem.OCV__c) ;
                  System.debug ('TotalOCVCalc --> ' + TotalOCVCalc); 
                  System.debug ('OCVLC --> ' + OCVLC); 

                    if (OldTARRLC !=null && OldTARRLC !=0 && lineItem.Material_TARR_LC__c!=null)
                    {
                         lineItem.Material_TARR_LC__c= (lineItem.Material_TARR_LC__c/OldTARRLC) * TARRLC;  
                    }
                   
                   System.debug ('lineItem.AOCV__c--> ' + lineItem.AOCV__c) ;
                   System.debug ('TotalAOCVLC --> ' + TotalAOCVLC); 
             
                    /*AOCV (TRR) --done*/
                   if (chkTRR_TRR == 'TRR')
                   {
                       if (TotalAOCVLC != 0 )
                       {
                        lineItem.AOCV__c=(lineItem.AOCV__c/TotalAOCVLC)*AOCVLC_Input;                                      
                       }
                   }
                   else if(chkTRR_TRR == 'RawMaintenance')
                   {
                       lineItem.AOCV__c= (lineItem.Raw_Maintenance_LC__c/TotalRawMaintCalc)*AOCVLC_Input;
                   }                                

                   lineItem.Distribution_Option_TRR__c = chkTRR_TRR ;

                  System.debug ('lineItem.AOCV__c--> ' + lineItem.AOCV__c) ;
                  System.debug ('TotalAOCVLC --> ' + TotalAOCVLC); 
                  System.debug ('AOCVLC_Input --> ' + AOCVLC_Input); 
                       
                                 
                 /*Contracted Renewal Amount --done */
                    if(chkContrRen_RawMaint   == 'RawMaintenance')
                    {
                        lineItem.Contracted_Renewal_Amount__c=(lineItem.Raw_Maintenance_LC__c/TotalRawMaintCalc)*ContractedRenewalAmnt ;
                    }
                    else if(chkContrRen_RawMaint ==  'CurrentExistAnnualMaint')
                    {
                        if(TotalCurrAnnExistMaint != null && TotalCurrAnnExistMaint>0)
                        {
                                Decimal currAnnExtMaint = 0;                    
                               if(lineItem.Current_Annu_Existing_Maintenance__c != null)
                                  currAnnExtMaint=lineItem.Current_Annu_Existing_Maintenance__c;                 
                               lineItem.Contracted_Renewal_Amount__c=(currAnnExtMaint/TotalCurrAnnExistMaint)*ContractedRenewalAmnt ;                                           
                         }                                                  
                    }
                                           
                    lineItem.Distribution_Opotion_CntrRenAmt__c = chkContrRen_RawMaint ;

                   System.debug ('lineItem.AOCV__c--> ' + lineItem.AOCV__c) ;
                   System.debug ('TotalAOCVLC --> ' + TotalAOCVLC); 
                   System.debug ('AOCVLC_Input --> ' + AOCVLC_Input); 
                 
                                   /*Raw Maintenance  -- not done */
                   if(TotalRawMaintCalc > 0 )
                     {
                      lineItem.Raw_Maintenance_LC__c = (lineItem.Raw_Maintenance_LC__c/TotalRawMaintCalc)* TotalRawMaintCalc_Input ;
                     }
                                    
                   System.debug ('lineItem.Raw_Maintenance_LC__c--> ' + lineItem.Raw_Maintenance_LC__c) ;
                   System.debug ('TotalRawMaintCalc --> ' + TotalRawMaintCalc); 

                   //lineItem.Financed_TRR__c= (TotalRawMaintCalc == 0 ?0:(lineItem.Raw_Maint_Calc_LC__c/TotalRawMaintCalc)*TRRLC);
                   
                    /*Adjusted ATTRF*/
                     if (TotalATTRF > 0 && lineItem.Orig_ATTRF_LC__c > 0 )
                     {
                       lineItem.Adjusted_ATTRF_LC__c  = (lineItem.Orig_ATTRF_LC__c/TotalATTRF)*AdjATRRF ; 
                     }
                   System.debug ('lineItem.Orig_ATTRF_LC__c  ' + lineItem.Orig_ATTRF_LC__c) ;
                   System.debug ('TotalATTRF --> ' + TotalATTRF); 
                   System.debug ('AdjATRRF --> ' + AdjATRRF);

                   lineItem.Contractual_Cap_Percentage__c = contract.Contractual_Cap_Percentage__c;                   
                   lineItem.Renewal_Valuation_Type__c=contract.Renewal_Valuation_Type__c;                   
                   //lineItem.description__c = contract.comments__c;
                  
            }
            }
            update activecontractlineItems;
            update contract;
            TotalRawMaintCalc =TotalRawMaintCalc_Input;
            ATTRFCRV = ATTRFCRV_Input; 
            AOCVLC = AOCVLC_Input;

        }
        catch(DMLException e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
            e.getMessage().subString(e.getMessage().indexOf('_EXCEPTION')+11,e.getMessage().length()));
            ApexPages.addMessage(msg); 
            return null;
        }
        PageReference pageRef;
        if(System.currentPageReference().getParameters().get('fromPage') != null && System.currentPageReference().getParameters().get('fromPage') == 'finVal')
            pageRef = new PageReference('/apex/Renewal_CRV_Process?id='+contract.Id);     
        else
            pageRef = new PageReference('/'+contract.Id);
        
        pageRef.setRedirect(true);
        return pageRef;   
        
    }  
    
   
    public pagereference goback()
    {
        PageReference pageRef;
        if(System.currentPageReference().getParameters().get('fromPage') != null && System.currentPageReference().getParameters().get('fromPage') == 'finVal')
            pageRef = new PageReference('/apex/Renewal_CRV_Process?id='+contract.Id);     
        else
            pageRef = new PageReference('/'+contract.Id);
        
        pageRef.setRedirect(true);
        return pageRef;  
    }
}