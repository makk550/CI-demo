/*
The trigger is written for calculating ATTRF field in Active Contract.
Date: 26/1/2013
Wriiten by: Mari Ganesan

NO of SOQL Used: 1
*/

trigger ATTRFCalculation on Active_Contract__c (after update) {

if (Trigger.isAfter && Trigger.isUpdate)
{
    
    List<Active_Contract_Line_Item__c> FinalAclList = new List<Active_Contract_Line_Item__c> ();
    Set<Active_Contract_Line_Item__c> aclSet = new Set<Active_Contract_Line_Item__c> ();
    Map<ID, List<Double>> cracamSum = new Map<ID, List<Double>> ();
    Map<Id, Set<Active_Contract_Line_Item__c>> IdandAclMap= new Map<Id, Set<Active_Contract_Line_Item__c>>();
    Map<Id, Active_Contract__c> changedACMap = new Map<Id,  Active_Contract__c>();
    
    List<Double> aclTemp2 = new List<Double>();
    
    // Find the list of modified Active Contracts
    System.debug('---size----'+Trigger.new.size());
    for (Integer i=0; i< Trigger.new.size();i++) 
    {
    
    //if((Trigger.new[i].Contracted_Renewal_Amount_LC__c != Trigger.old[i].Contracted_Renewal_Amount_LC__c)||(Trigger.new[i].Current_Ann_Existing_Maintenance_LC__c != Trigger.old[i].Current_Ann_Existing_Maintenance_LC__c))
        changedACMap.put(Trigger.new[i].Id, Trigger.new[i]);
    }
     System.debug('The changedACMap.keySet() Size '+ changedACMap.keySet().size() );
    
    // Query All the ACL that will be under the modified AC
    List<Active_Contract_Product__c> acpList = [select Id, ATTRF_CRV__c,Contracted_Renewal_Amount_LC__c,Current_Ann_Existing_Maintenance_LC__c,Active_Contract__c,Active_Contract__r.Id,
                                      (select Id, Orig_ATTRF_LC__c,Contracted_Renewal_Amount__c,Current_Annu_Existing_Maintenance__c,Contract_Product__c,Contract_Product__r.Active_Contract__r.Id,Renewal_Valuation_Type__c from Active_Contract_Line_Items__r)
        from Active_Contract_Product__c where Active_Contract__r.Id in :changedACMap.keySet()];//US266794-Added Renewal Valuation Type in query by SAMTU01
    System.debug('The acpList Size '+acpList.size() );
    
    if(acpList.size() > 0)
    {
   
    Double CRA,CAM;
   
        for(Active_Contract_Product__c a: acpList)
        {
           CRA=0;
           CAM =0;
           
            for(Active_Contract_Line_Item__c b: a.Active_Contract_Line_Items__r)
            {
                
                // ACL with 0 or null in Contracted_Renewal_Amount__c and Current_Annu_Existing_Maintenance__c
              
                  if((b.Contracted_Renewal_Amount__c == 0 || b.Contracted_Renewal_Amount__c == null) && (b.Current_Annu_Existing_Maintenance__c == null || b.Current_Annu_Existing_Maintenance__c == 0 ))
                  {
                  if (b.Orig_ATTRF_LC__c != 0){ b.Orig_ATTRF_LC__c =0; FinalAclList.add(b); }
                  }
                  else if((b.Contracted_Renewal_Amount__c == 0 || b.Contracted_Renewal_Amount__c == null)&&(b.Current_Annu_Existing_Maintenance__c != b.Orig_ATTRF_LC__c)) 
                  {
                  b.Orig_ATTRF_LC__c =b.Current_Annu_Existing_Maintenance__c;
                  FinalAclList.add(b);
                  }
                  else if((b.Current_Annu_Existing_Maintenance__c == null || b.Current_Annu_Existing_Maintenance__c == 0)&&(b.Contracted_Renewal_Amount__c != b.Orig_ATTRF_LC__c))
                  {
                   b.Orig_ATTRF_LC__c =b.Contracted_Renewal_Amount__c;
                  FinalAclList.add(b);
                  }
                  else if(b.Contracted_Renewal_Amount__c != 0 && b.Contracted_Renewal_Amount__c != null && b.Current_Annu_Existing_Maintenance__c != null && b.Current_Annu_Existing_Maintenance__c != 0 )
                  {
                  //ACL with non zero values in Contracted_Renewal_Amount__c and Current_Annu_Existing_Maintenance__c
                  // We need to find the sum of CAM and CRA for each AC and then Compare the values 
                     CAM += b.Current_Annu_Existing_Maintenance__c;
                     CRA += b.Contracted_Renewal_Amount__c;
                     
                    aclSet.add(b); 
                  }            
            }
            //System.debug('The ACTIVE CONTRACT PRO' + a);
           System.debug('The value of CRA' + CRA);
           System.debug('The value of CAM' + CAM);
            if(CAM > 0 && CRA > 0)
            {
            if(!cracamSum.containsKey(a.Active_Contract__r.Id))
            {
            List<Double> aclTemp1 = new List<Double>();
            aclTemp1.add(CRA);
            aclTemp1.add(CAM);
            cracamSum.put(a.Active_Contract__r.Id,aclTemp1);
            // aclTemp1.clear();
            System.debug('The aclTemp1 value from Map' + cracamSum.get(a.Active_Contract__r.Id));
            }
            else
            {
            List<Double> aclTemp3 = new List<Double>();
            aclTemp2 = cracamSum.get(a.Active_Contract__r.Id);
            System.debug('The aclTemp2 value from Map_1' + cracamSum.get(a.Active_Contract__r.Id) + '---'+ CRA +'----' +CAM);
            aclTemp3.add(aclTemp2.get(0) + CRA);
            aclTemp3.add(aclTemp2.get(1) + CAM);
            cracamSum.put(a.Active_Contract__r.Id, aclTemp3);
            aclTemp2.clear();
            System.debug('The aclTemp2 value from Map_2' + cracamSum.get(a.Active_Contract__r.Id));
            }
            }
            
        }
        System.debug('The Constructed Map is '+ cracamSum);
        for(Active_Contract_Line_Item__c c: aclSet)
        {
          
           if(cracamSum.containsKey(c.Contract_Product__r.Active_Contract__r.Id)) 
           {
           
           List<Double> tempSum = cracamSum.get(c.Contract_Product__r.Active_Contract__r.Id);
           //System.debug('The ACTIVE CONTRACT line' + c);
           //System.debug('The Key is '+ c.Contract_Product__r.Active_Contract__r.Id);
           //System.debug('The value of CRA' + tempSum[0]);
           //System.debug('The value of CAM' + tempSum[1]);
           if(c.Renewal_Valuation_Type__c=='VSOE Stated Renewal') //US266794-Added by SAMTU01
           {
              
               c.Orig_ATTRF_LC__c = c.Contracted_Renewal_Amount__c;
               System.debug('----CRA-----'+c.Contracted_Renewal_Amount__c);
               
               FinalAclList.add(c);
               System.debug(FinalAclList);
               
           
           }
             else if(tempSum[0]<= tempSum[1]) 
              {
                 
                 if(c.Contracted_Renewal_Amount__c != c.Orig_ATTRF_LC__c)
                 {
                 
                 c.Orig_ATTRF_LC__c = c.Contracted_Renewal_Amount__c;
                 FinalAclList.add(c);
                 }
              }
              else
              {
                  
                 if(c.Current_Annu_Existing_Maintenance__c != c.Orig_ATTRF_LC__c)
                 {
                 
                 c.Orig_ATTRF_LC__c = c.Current_Annu_Existing_Maintenance__c;
                 FinalAclList.add(c);
                 }
              }
           
           }
                   
        }
        if(FinalAclList.size()>0)
        update FinalAclList;
    }
}

}