trigger SetProductMaterialId on Quote_Product_Report__c (before insert, after insert,before Update,after update) {
    if(trigger.isinsert){
    System.debug('++++Inside Quote Product Trigger+++');
    
    //Exising code. Added Context switching
    if(trigger.isInsert && trigger.isBefore){
        
        System.debug('++++Inside Existing Trigger block+++');
        set<id> compset=new set<id>();
        
        Set<String> ProductMaterialNameSet = new Set<String>();
        for(Quote_Product_Report__c QPR:trigger.New){
            if(QPR.EAI_Product_Material__c != null){
                ProductMaterialNameSet.add(QPR.EAI_Product_Material__c);
            }     
                //Yedra01 For Pricing Project All Fields N/A if they Target_SMA_Floor_NA_Flag__c=='Y'
              if(QPR.Target_SMA_Floor_NA_Flag__c=='Y'){
                    QPR.Target_Disc_Percent__c='N/A';
                    QPR.Target_License_Sub_Price__c='N/A';
                    QPR.Target_Maintenance_Price__c='N/A';
                    QPR.Sales_Mgmt_Approval_Percent__c='N/A';
                    QPR.Floor_Disc_Percent__c='N/A';
                    QPR.Floor_License_Sub_Price__c='N/A';
                    QPR.Floor_Maint_Price__c='N/A'; 
                }
                //Yedra01 For Pricing Project For Competetor Related List on opp
                if(QPR.Competitor__c!=null)
                {
                    if(QPR.Reason_for_Discount__c=='Competitive Situation'||QPR.Reason_for_Discount__c=='Competitive Replacement')
                    {
                        if(QPR.Sterling_Quote__c!=null)
                        compset.add(QPR.Sterling_Quote__c);
                    }
                    
                }
        }
        List<Product_Material__c> PMList = [select Id,Name from Product_Material__c where Name IN: ProductMaterialNameSet];
        Map<String,Id> ProductMaterialNameAndIdMap = new Map<String,Id>();
        if(PMList != null && PMList.size()>0){
            for(Product_Material__c PM:PMList){
                ProductMaterialNameAndIdMap.put(PM.Name,PM.Id);
            } 
        }
         //Yedra01 For Pricing Project For Competetor Related List on opp
        Map<id,id> Oppmap=new Map<id,id>();
         if(compset.size()>0)
             for(scpq__SciQuote__c SQ:[select id,scpq__OpportunityId__c from scpq__SciQuote__c where id in:compset limit 50000])
             Oppmap.put(SQ.id,SQ.scpq__OpportunityId__c);
                
        for(Quote_Product_Report__c QPR:trigger.New){
            if(ProductMaterialNameAndIdMap.containsKey(QPR.EAI_Product_Material__c)){
                QPR.Product_Material__c = ProductMaterialNameAndIdMap.get(QPR.EAI_Product_Material__c);
            }
              //Yedra01 For Pricing Project For Competetor Related List on opp
            if(Oppmap.get(QPR.Sterling_Quote__c)!=null){
            if(QPR.Competitor__c!=null)
               if(QPR.Reason_for_Discount__c=='Competitive Situation'||QPR.Reason_for_Discount__c=='Competitive Replacement')                  
                QPR.Opportunity__c=Oppmap.get(QPR.Sterling_Quote__c);
            }
        }
    
      

        
    }    
    
    //Education QQ - Code for rollup count of royalty flag and migration/upgrade
    if(trigger.isInsert && trigger.isAfter)
    {
        
        System.debug('++++Inside New Trigger block+++');
        Set<Id>  quoteIdSet = new Set<Id>();
        
   		// to update the quote with count fields-----merha02 US441911
        List<scpq__SciQuote__c>  quoteListUpdatable = new List<scpq__SciQuote__c>();
                  
        for(Quote_Product_Report__c qpr : Trigger.new)
        {
            System.debug('++++Inside Trigger Quote is going to added+++'+qpr.Sterling_Quote__c);
            quoteIdSet.add(qpr.Sterling_Quote__c);
        }
       Map<ID,scpq__SciQuote__c> quoteMap = new Map<ID,scpq__SciQuote__c> ([Select Id,Royalties__c,Migration_Upgrade__c,Special_Metric_Count__c from scpq__SciQuote__c WHERE ID IN :quoteIdSet]);
      
       
        //AR 3813 Changing the Aggregate Query
        
	   /*Commenting the breaking code --  for(scpq__SciQuote__c quoteObj : [Select ID,name,(Select ID FROM Quote_Products_Reporting__r where Royalty_Product__c = True) from scpq__SciQuote__c WHERE ID IN :quoteIdSet])
	    { 
	        quoteMap.get(quoteObj.ID).Royalties__c = quoteObj.Quote_Products_Reporting__r.size();     
	        System.debug('++++Inside Trigger Royalty Size+++'+quoteObj.Quote_Products_Reporting__r.size());   
	        quoteListUpdatableForRoyalty.add(quoteMap.get(quoteObj.id));
	    }
	    for(scpq__SciQuote__c quoteObj1 : [Select ID,name,(Select ID FROM Quote_Products_Reporting__r where Bus_Transaction_Type__c = 'Time - Product Migration') from scpq__SciQuote__c WHERE ID IN :quoteIdSet])
	    {         
	        quoteMap.get(quoteObj1.ID).Migration_Upgrade__c = quoteObj1.Quote_Products_Reporting__r.size();
	        System.debug('++++Inside Trigger BTType Size+++'+quoteObj1.Quote_Products_Reporting__r.size()); 
	        quoteListUpdatableForUpgrade.add(quoteMap.get(quoteObj1.id));
	    } */
	     
        //Adding the same functionality with changed Query
        //MERHA02
        Map<Id,List<Quote_Product_Report__c>> lineitemMap_Royalty = new Map<Id,List<Quote_Product_Report__c>>();
       Map<Id,List<Quote_Product_Report__c>> lineitemMap_Bus = new Map<Id,List<Quote_Product_Report__c>>(); 
        Map<Id,List<Quote_Product_Report__c>> lineitemMap_SM = new Map<Id,List<Quote_Product_Report__c>>(); // US441911
        // to query quote line items
        List<Quote_Product_Report__c> productList = [Select ID,Sterling_Quote__r.Id,Bus_Transaction_Type__c,Auth_Use_Model__c,Royalty_Product__c FROM Quote_Product_Report__c where
                                                     (Royalty_Product__c = True or Bus_Transaction_Type__c = 'Time - Product Migration' or Auth_Use_Model__c = 'Special Metric') 
                                                     and Sterling_Quote__r.Id in :quoteIdSet ];
        System.debug('--------'+productList+'---------');
        
        for (Quote_Product_Report__c line : productList ){
			
            // map of Sterling Quote Id and its line items if Royalty Product is true
			if(line.Royalty_Product__c = True){
				if(!lineitemMap_Royalty.containsKey(line.Sterling_Quote__r.Id)){
					lineitemMap_Royalty.put(line.Sterling_Quote__r.Id, new List<Quote_Product_Report__c>());
					lineitemMap_Royalty.get(line.Sterling_Quote__r.Id).add(line);
				}
				else 
					lineitemMap_Royalty.get(line.Sterling_Quote__r.Id).add(line);
			}
            
            // map of Sterling Quote Id and its line items if Business Transaction Type is 'Time-Product Migration'
			if(line.Bus_Transaction_Type__c == 'Time - Product Migration'){
                
				if(!lineitemMap_Bus.containsKey(line.Sterling_Quote__r.Id)){
					lineitemMap_Bus.put(line.Sterling_Quote__r.Id, new List<Quote_Product_Report__c>());
					lineitemMap_Bus.get(line.Sterling_Quote__r.Id).add(line);
				}
				else 
					lineitemMap_Bus.get(line.Sterling_Quote__r.Id).add(line);
			}
            // to update QQ special metric count field-----merha02 US441911 
            if(line.Auth_Use_Model__c == 'Special Metric'){
                
                // map of Sterling Quote Id and its line items if Auth_Use_Model is 'Special Metric'
                if(!lineitemMap_SM.containsKey(line.Sterling_Quote__r.Id)){
					lineitemMap_SM.put(line.Sterling_Quote__r.Id, new List<Quote_Product_Report__c>());
					lineitemMap_SM.get(line.Sterling_Quote__r.Id).add(line);
				}
				else 
					lineitemMap_SM.get(line.Sterling_Quote__r.Id).add(line);
            }
               
            
        }
        
        // for each quote 
        for(Id quoteObj : quoteIdSet ){
            
            // to update Royalty Product count field on Sterling Quote
            if(lineitemMap_Royalty.get(quoteObj) != null){
              quoteMap.get(quoteObj).Royalties__c = lineitemMap_Royalty.get(quoteObj).size(); //quoteObj.Quote_Products_Reporting__r.size(); 
               System.debug('++++Inside Trigger Royalty Size+++'+lineitemMap_Royalty.get(quoteObj).size());
            }
            else {
                quoteMap.get(quoteObj).Royalties__c = 0;
            System.debug('++++Inside Trigger Royalty Size+++  is 0');   
            }
            // to update Migration/Upgrade count filed on Sterling Quote
			 if(lineitemMap_Bus.get(quoteObj) !=null){                 
              quoteMap.get(quoteObj).Migration_Upgrade__c = lineitemMap_Bus.get(quoteObj).size(); //quoteObj.Quote_Products_Reporting__r.size(); 
                System.debug('++++Inside Trigger BTType Size+++'+lineitemMap_Bus.get(quoteObj).size());
            }
            else{
                quoteMap.get(quoteObj).Migration_Upgrade__c =0;
            System.debug('++++Inside Trigger BTType Size+++ is 0');  
            }
            
             // to update QQ special metric count field on Sterling Quote-----merha02 US441911
            if(lineitemMap_SM.get(quoteObj) !=null){                 
              quoteMap.get(quoteObj).Special_Metric_Count__c = lineitemMap_SM.get(quoteObj).size(); //quoteObj.Quote_Products_Reporting__r.size(); 
                System.debug('++++Inside Trigger Special Metric Size+++'+lineitemMap_SM.get(quoteObj).size());
            }
            else{
                quoteMap.get(quoteObj).Special_Metric_Count__c =0;
            System.debug('++++Inside Trigger Special Metric Size+++ is 0');  
            }
            
            quoteListUpdatable.add(quoteMap.get(quoteObj));
            
        }
        // update the count fields on Sterling Quote
         if(quoteListUpdatable != NULL && quoteListUpdatable.size() > 0)
            UPDATE quoteListUpdatable;
        
       
        
    } 
    
    }
    //Yedra01 For Pricing Project Competetor Related List on opp and make N/A
    if(trigger.isupdate&&Trigger.isBefore){
     set<id> compset=new set<id>();
           for(Quote_Product_Report__c QPR:trigger.New){
        
              if(QPR.Target_SMA_Floor_NA_Flag__c=='Y'&&Trigger.oldmap.get(Qpr.id).Target_SMA_Floor_NA_Flag__c!=QPR.Target_SMA_Floor_NA_Flag__c){
                    QPR.Target_Disc_Percent__c='N/A';
                    QPR.Target_License_Sub_Price__c='N/A';
                    QPR.Target_Maintenance_Price__c='N/A';
                    QPR.Sales_Mgmt_Approval_Percent__c='N/A';
                    QPR.Floor_Disc_Percent__c='N/A';
                    QPR.Floor_License_Sub_Price__c='N/A';
                    QPR.Floor_Maint_Price__c='N/A';  
                }
                if(QPR.Competitor__c!=Trigger.oldmap.get(Qpr.id).Competitor__c||QPR.Reason_for_Discount__c!=Trigger.oldmap.get(Qpr.id).Reason_for_Discount__c)
                if(QPR.Competitor__c!=null)
                {
                    if(QPR.Reason_for_Discount__c=='Competitive Situation'||QPR.Reason_for_Discount__c=='Competitive Replacement')
                    {
                        if(QPR.Sterling_Quote__c!=null)
                        compset.add(QPR.Sterling_Quote__c);
                    }
                    else
                    QPR.Opportunity__c=null;
                    
                }
                else
                QPR.Opportunity__c=null;
                
                
                }
                 Map<id,id> Oppmap=new Map<id,id>();
         if(compset.size()>0)
             for(scpq__SciQuote__c SQ:[select id,scpq__OpportunityId__c from scpq__SciQuote__c where id in:compset limit 50000])
             Oppmap.put(SQ.id,SQ.scpq__OpportunityId__c);
                
        for(Quote_Product_Report__c QPR:trigger.New){
         
            if(Oppmap.get(QPR.Sterling_Quote__c)!=null){
             if(QPR.Competitor__c!=Trigger.oldmap.get(Qpr.id).Competitor__c||QPR.Reason_for_Discount__c!=Trigger.oldmap.get(Qpr.id).Reason_for_Discount__c)               
                    if(QPR.Reason_for_Discount__c=='Competitive Situation'||QPR.Reason_for_Discount__c=='Competitive Replacement')               
                        QPR.Opportunity__c=Oppmap.get(QPR.Sterling_Quote__c);
            }
        }
        }
    
    // ALLHA02 CPQ Services 		
    		
   if(trigger.isAfter&&(trigger.isInsert||trigger.isUpdate)){  
        system.debug('After Trigger --->');
        Set<Id> oppset = new Set<Id>();   
        Set<Id> qliset = new Set<Id>();
        Map<Id,List<Quote_Product_Report__c>> opQLIMap = new Map<Id,List<Quote_Product_Report__c>>(); 
       Map<Id,String> phaseLinetemMap=new Map<Id,String>();
		
        for(Quote_Product_Report__c QLI1:trigger.New){ 
            qliset.add(QLI1.id);
		}
        for(Quote_Product_Report__c QLI:[select id,Phase_In_Out__c,Sterling_Quote__r.scpq__OpportunityId__c,Project_Number__c from  Quote_Product_Report__c where id in :qliset]){ 
            oppset.add(QLI.Sterling_Quote__r.scpq__OpportunityId__c);     		
            if(QLI.Project_Number__c!=null){    
                if(opQLIMap.containsKey(QLI.Sterling_Quote__r.scpq__OpportunityId__c)){    
                    opQLIMap.get(QLI.Sterling_Quote__r.scpq__OpportunityId__c).add(QLI);                        
                } else{    
                    List<Quote_Product_Report__c> li = new List<Quote_Product_Report__c>();    
                    li.add(QLI);    
                   opQLIMap.put(QLI.Sterling_Quote__r.scpq__OpportunityId__c,li);     
                }     
            }    
         } 
		 
		 for(Quote_Product_Report__c quoteLine : [select id,Phase_In_Out__c,Sterling_Quote__r.scpq__OpportunityId__c,Project_Number__c from  Quote_Product_Report__c where Sterling_Quote__r.scpq__OpportunityId__c in :oppset and Sterling_Quote__r.CA_Primary_Flag__c=true ]){
			
             if(String.isNotBlank(quoteLine.Phase_In_Out__c)){
                phaseLinetemMap.put(quoteLine.Sterling_Quote__r.scpq__OpportunityId__c,quoteLine.Phase_In_Out__c);    
               }
            			
			 
		   }
       
       System.debug('phaseLinetemMap======'+phaseLinetemMap);
		 
		 Boolean PhaseInOut_Flag;
		 Set<Id> checkSet=new Set<Id>();
        List<Opportunity> opp=[select id,Project_Number__c,Phase_In_Out__c from opportunity where id in :oppset];	 
        for(opportunity o : opp){
                 PhaseInOut_Flag=false;
         if(opQLIMap.containsKey(o.id)){
            for(Quote_Product_Report__c qpl : opQLIMap.get(o.id)){    
                if(o.Project_Number__c==null && qpl.Project_Number__c!=null){
                    o.Project_Number__c = qpl.Project_Number__c;
					checkSet.add(o.id);
                }else if(qpl.Project_Number__c!=null&& !o.Project_Number__c.contains(qpl.Project_Number__c))    
                {    
                    o.Project_Number__c+=','+qpl.Project_Number__c;   
                     checkSet.add(o.id);
					
                }    
            }
        }
           
		       if(phaseLinetemMap.containsKey(o.id)&&
		          (phaseLinetemMap.get(o.id)=='Phase In'||phaseLinetemMap.get(o.id)=='Phase Out'||phaseLinetemMap.get(o.id)=='Both')){
						 PhaseInOut_Flag=true;		 
			    }

          if(o.Phase_In_out__c==true&&PhaseInOut_Flag==false){
               o.Phase_In_out__c=PhaseInOut_Flag;
              checkSet.add(o.id); 
            }else if(o.Phase_In_out__c==false&&PhaseInOut_Flag==true){
              o.Phase_In_out__c=PhaseInOut_Flag;
               checkSet.add(o.id);   
                
            }  				
                
        }     
        try{ 
          if(checkSet.size()>0)		
              update opp;
	   }catch(Exception e){    
            System.debug(e);    
        }    
            
    }    		
}