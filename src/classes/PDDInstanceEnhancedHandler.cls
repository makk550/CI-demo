public without sharing class PDDInstanceEnhancedHandler implements ITrigger {
    
    public void bulkBefore(){}    
    public void bulkAfter(){
        if (Trigger.isInsert || Trigger.isUpdate) {
            updatePDDEnhancedObject(false);
        } 
        if (Trigger.isDelete) {
            updatePDDEnhancedObject(true);
        }
    }
    
    public void beforeInsert(SObject so){}
    public void beforeUpdate(SObject oldSo, SObject so){}
    public void beforeDelete(SObject so){}
    public void afterInsert(SObject so){}
    public void afterUpdate(SObject oldSo, SObject so){}
    public void afterDelete(SObject so){}
    public void andFinally(){}    
    /*
    private String fetchHighestReleaseLevelFromInstanceList(List<PDD_Instance_Enhanced__c> pddInstanceList){
        String highestReleaseLevel = null;
        for(PDD_Instance_Enhanced__c instanceRec : pddInstanceList ){
            if(highestReleaseLevel == null){
                highestReleaseLevel = instanceRec.Instance_Client_Release_Level__c ;
            }  else {
                highestReleaseLevel = versionCompareSFDC(highestReleaseLevel ,instanceRec.Instance_Client_Release_Level__c );
            }            
        }
        return highestReleaseLevel;
    }
    
	 private String versionCompareSFDC(String first, String second){
        String[] fstArr = first.split('\\.');
        String[] secArr = second.split('\\.');
        Integer fstArrLen = fstArr.size();
        Integer secArrLen = secArr.size();
        System.debug('first:'+first + ';fstArrLen:'+fstArrLen);
        System.debug('second:'+second+';secArrLen:'+secArrLen);
        
        Version v1,v2;
        if(fstArrLen == 1 && fstArr[0].isNumeric() ){        
            v1 = new Version(Integer.valueOf(fstArr[0]),0);     
        } else if( fstArrLen == 2 && fstArr[0].isNumeric() && fstArr[1].isNumeric()){            
            v1 = new Version(Integer.valueOf(fstArr[0]),Integer.valueOf(fstArr[1]));            
        } else if( fstArrLen == 3 && fstArr[0].isNumeric() && fstArr[1].isNumeric() && fstArr[2].isNumeric())  {            
            v1 = new Version(Integer.valueOf(fstArr[0]),Integer.valueOf(fstArr[1]),Integer.valueOf(fstArr[2]));
        }
        
        if(secArrLen == 1 && secArr[0].isNumeric()){
            v2 = new Version(Integer.valueOf(secArr[0]),0);
        } else if( secArrLen == 2 && secArr[0].isNUmeric() && secArr[1].isNUmeric()){
            v2 = new Version(Integer.valueOf(secArr[0]),Integer.valueOf(secArr[1]));
        } else if( secArrLen == 3 && secArr[0].isNUmeric() && secArr[1].isNUmeric() && secArr[2].isNumeric()) {
            v2 = new Version(Integer.valueOf(secArr[0]),Integer.valueOf(secArr[1]),Integer.valueOf(secArr[2]));
        } 
        
        if( v1!= null && v2!=null){
            if(  v1.compareTo(v2) > 0){  
                System.debug('Highest:'+ v1);
                return first;
                
            } else {
                System.debug('Highest:'+ v2);
                return second;
            }
        } else {
            return 'NotComparable';
        }    
	}
	
	*/
    private PDD_Instance_Enhanced__c fetchProdInstanceWithHighestRelease(List<PDD_Instance_Enhanced__c> pddInstanceList){
        PDD_Instance_Enhanced__c prodInstanceWithHighestReleaseLevel = null;
        for(PDD_Instance_Enhanced__c instanceRec : pddInstanceList ){            
            if(instanceRec.Environment_Type__c.equalsIgnoreCase('Production')){
                if(prodInstanceWithHighestReleaseLevel == null){
                    prodInstanceWithHighestReleaseLevel = instanceRec ;
                }  else {
                    prodInstanceWithHighestReleaseLevel = instanceVersionCompare(prodInstanceWithHighestReleaseLevel ,instanceRec );
                }   
            }        
        }
        return prodInstanceWithHighestReleaseLevel;
    }
    
    /*
    */
    private PDD_Instance_Enhanced__c instanceVersionCompare(PDD_Instance_Enhanced__c first, PDD_Instance_Enhanced__c second){
        String[] fstArr = first.Instance_Client_Release_Level__c != null ? first.Instance_Client_Release_Level__c.split('\\.') : new List<String>(); 
        String[] secArr = second.Instance_Client_Release_Level__c != null ? second.Instance_Client_Release_Level__c.split('\\.'): new List<String>();
        Integer fstArrLen = fstArr.size();
        Integer secArrLen = secArr.size();
        System.debug('first:'+first + ';fstArrLen:'+fstArrLen);
        System.debug('second:'+second+';secArrLen:'+secArrLen);
        
        Version v1,v2;
        if(fstArrLen == 1 && fstArr[0].isNumeric() ){        
            v1 = new Version(Integer.valueOf(fstArr[0]),0);     
        } else if( fstArrLen == 2 && fstArr[0].isNumeric() && fstArr[1].isNumeric()){            
            v1 = new Version(Integer.valueOf(fstArr[0]),Integer.valueOf(fstArr[1]));            
        } else if( fstArrLen == 3 && fstArr[0].isNumeric() && fstArr[1].isNumeric() && fstArr[2].isNumeric())  {            
            v1 = new Version(Integer.valueOf(fstArr[0]),Integer.valueOf(fstArr[1]),Integer.valueOf(fstArr[2]));
        }
        
        if(secArrLen == 1 && secArr[0].isNumeric()){
            v2 = new Version(Integer.valueOf(secArr[0]),0);
        } else if( secArrLen == 2 && secArr[0].isNUmeric() && secArr[1].isNUmeric()){
            v2 = new Version(Integer.valueOf(secArr[0]),Integer.valueOf(secArr[1]));
        } else if( secArrLen == 3 && secArr[0].isNUmeric() && secArr[1].isNUmeric() && secArr[2].isNumeric()) {
            v2 = new Version(Integer.valueOf(secArr[0]),Integer.valueOf(secArr[1]),Integer.valueOf(secArr[2]));
        } 
        
        if( v1!= null && v2!=null){
            if(  v1.compareTo(v2) > 0){  
                System.debug('Highest-v1:'+ v1);
                return first;
                
            } else {
                System.debug('Highest-v2:'+ v2);
                return second;
            }
        } else {
            return null;
        }    
}

    
    public void updatePDDEnhancedObject(boolean isDel){ 
        
        List<PDD_Instance_Enhanced__c> newRecList =  isDel ? Trigger.old : Trigger.New;
       
            Set<Id> pddEnhancedIdSet = new Set<Id>();    
            String highestReleaseLevel = null;
            List<PDD_Enhanced__c> pddEnhancedListToUpdate = new List<PDD_Enhanced__c>();
            //Map<Id,PDD_Instance_Enhanced__c> pddEnhancedAndInstanceNewMap = new Map<Id,PDD_Instance_Enhanced__c>();
            Map<Id, List<PDD_Instance_Enhanced__c> > pddRelatedInstancesNewMap = new Map<Id, List<PDD_Instance_Enhanced__c> >();
            
            for(PDD_Instance_Enhanced__c  pddInstanceRec : newRecList){
                pddEnhancedIdSet.add(pddInstanceRec.PDD_Enhanced__c);
                if(pddRelatedInstancesNewMap.containsKey(pddInstanceRec.PDD_Enhanced__c)){
                    List<PDD_Instance_Enhanced__c> tempList = pddRelatedInstancesNewMap.get(pddInstanceRec.PDD_Enhanced__c);
                    tempList.add(pddInstanceRec);
                    pddRelatedInstancesNewMap.put(pddInstanceRec.PDD_Enhanced__c, tempList);
                } else {
                    pddRelatedInstancesNewMap.put(pddInstanceRec.PDD_Enhanced__c, new List<PDD_Instance_Enhanced__c> { pddInstanceRec });
                }
            }
        
        	System.debug('pddRelatedInstancesNewMap:'+pddRelatedInstancesNewMap);
            
            List<PDD_Enhanced__c> pddEnhancedList = new List<PDD_Enhanced__c>(
                [select id,Name,Max_Scale_of_Adoption__c,GA_Level__c,Highest_Production_Rel_Level__c
                 ,(select id,Scale_of_Adoption__c,Instance_Client_Release_Level__c,Instance_GA_Level__c,Name,Environment_Type__c from PDD_Instance_Enhanced__r )
                 from PDD_Enhanced__c where id IN :pddEnhancedIdSet ]); 
        	   //Instance Client Release Level
       		PDD_Instance_Enhanced__c instanceToUse = null; 
        
            for(PDD_Enhanced__c pddEnhancedRec : pddEnhancedList ){
                if(!isDel){ 
                    List<PDD_Instance_Enhanced__c> instanceRecList = pddEnhancedRec.PDD_Instance_Enhanced__r;
                    instanceRecList.addAll(pddRelatedInstancesNewMap.get(pddEnhancedRec.Id));
                    instanceToUse = fetchProdInstanceWithHighestRelease(instanceRecList);
                } else {
                    //List<PDD_Instance_Enhanced__c> instanceRecList = pddEnhancedRec.PDD_Instance_Enhanced__r;
                    Set<PDD_Instance_Enhanced__c> instanceRecSet = new Set<PDD_Instance_Enhanced__c>(pddEnhancedRec.PDD_Instance_Enhanced__r);
                    instanceRecSet.removeAll(pddRelatedInstancesNewMap.get(pddEnhancedRec.Id));
                    instanceToUse = fetchProdInstanceWithHighestRelease(new List<PDD_Instance_Enhanced__c>(instanceRecSet));
                } 
                System.debug('instanceToUse:'+instanceToUse);
                pddEnhancedRec.Highest_Production_Rel_Level__c = instanceToUse != null ? instanceToUse.Instance_Client_Release_Level__c : '';
                pddEnhancedRec.Max_Scale_of_Adoption__c = instanceToUse != null ? instanceToUse.Scale_of_Adoption__c : '' ;    
                pddEnhancedRec.GA_Level__c = instanceToUse != null ? instanceToUse.Instance_GA_Level__c : '' ;
                //pddEnhancedRec.Instance_Name__c = instanceToUse != null ? instanceToUse.Name : '' ;
               
                
                pddEnhancedListToUpdate.add(pddEnhancedRec);
                
                System.debug('pddEnhancedListToUpdate:'+ pddEnhancedListToUpdate);
                update pddEnhancedListToUpdate; //TODO : Use Database.update - partial success as well.
                
            }
    }

}