public with sharing class OpportunitySummary {
  //Initialize member variables
  public List<String> productFamilyPicklistValues{get;set;}
  public List<String> businessUnitPicklistValues{get;set;}
  
  public List<LineItemDetailsByFamily> lineItemDetailsByFamilyList{get;set;}
  public List<LineItemDetailsByQuarter> lineItemDetailsByQuarterList{get;set;}
  
  Map<String, Double> businessUnitFamilAndUnitPriceMap = new Map<String, Double>();
  Map<String, Double> quarterAndUnitPriceMap = new Map<String, Double>();
  List<String> quarterList = new List<String>();
  
  String opptyId = '';
  Double unitPrice; 
  Boolean unassignedInd;
  List<List<String>> MatrixString = new List<List<String>>();
  public List<String> headerRow{get;set;}
  public List<String> footerRow{get;set;}
  
  Opportunity opp = new Opportunity();
  //Map<String, String> productFamilyMap = new Map<String, String>();
  
  //Product Family And Header Mapping.
  /*
  PNCV  -- Product
  SNCV  -- Services
  ENCV  -- Education
  NCV   -- Total of Product, Services and Education
  CV    -- Time & Mainframe Capacity
  */
  
  public OpportunitySummary(ApexPages.StandardController stdController)
  {
    
    this.opp = (Opportunity)stdController.getRecord();
    headerRow = new List<String>();
    footerRow = new List<String>();
    footerRow.add('TOTAL');
    
    Schema.DescribeFieldResult f = Schema.sObjectType.Product2.fields.Market_Focus_Area__c;
    /* Commented by Nomita. Header row being set on Page
    
    headerRow.add(f.getLabel());
    
    headerRow.add('PNCV');
    headerRow.add('SNCV');
    headerRow.add('ENCV');
    headerRow.add('NCV');
    headerRow.add('Renewal');
    headerRow.add('CV');
    */
    
    /*
    productFamilyMap.put('Product', 'PNCV');
    productFamilyMap.put('Services', 'SNCV');
    productFamilyMap.put('Education', 'ENCV');
    productFamilyMap.put('Time', 'CV');
    productFamilyMap.put('Mainframe Capacity', 'CV');
    productFamilyMap.put('Total of Product', 'NCV');
    productFamilyMap.put('Services and Education', 'NCV');
    */
    
    
    productFamilyPicklistValues = new List<String>();
    businessUnitPicklistValues = new List<String>();
    
    lineItemDetailsByFamilyList = new List<LineItemDetailsByFamily>();
    lineItemDetailsByQuarterList = new List<LineItemDetailsByQuarter>();
    opptyId = opp.Id;
    
   
    Schema.DescribeFieldResult productFieldResult = Product2.Family.getDescribe();
    for(Schema.PicklistEntry entry : productFieldResult.getPicklistValues())
    {
        productFamilyPicklistValues.add(entry.getLabel());
        /*if(productFamilyMap.get(entry.getLabel()) != null)
        headerRow.add(productFamilyMap.get(entry.getLabel()));
        else
        headerRow.add(entry.getLabel());
        */
    }
    // Need to add 'Renewal' to the list to handle Renewal Oppty Products - 6 Oct 2011
    productFamilyPicklistValues.add('Renewal');

    productFamilyPicklistValues.add('');
    
    Schema.DescribeFieldResult businessUnitFieldResult = Product2.Market_Focus_Area__c.getDescribe();
    for(Schema.PicklistEntry entry : businessUnitFieldResult.getPicklistValues())
    {
        //ISBU and RMDM Business Units should not appear on the Opp Summary. 
        if(entry.getLabel() != 'ISBU' && entry.getLabel() != 'RMDM')
            businessUnitPicklistValues.add(entry.getLabel());
    }
  //  businessUnitPicklistValues.add('Unassigned');   
    //System.debug('businessUnitPicklistValues='+businessUnitPicklistValues);
    
    //System.debug('productFamilyPicklistValues => '+productFamilyPicklistValues);
    //OpportunityLineItem[] optyLineItemList = [SELECT PricebookEntry.Product2.Market_Focus_Area__c, PricebookEntry.Product2.Name, PricebookEntry.Product2.Family, UnitPrice, Sales_Milestone__c, Inside_Outside__c, Close_Date__c FROM OpportunityLineItem WHERE OpportunityId =: opptyId ORDER BY  PricebookEntry.Product2.Family,Close_Date__c asc];
    OpportunityLineItem[] optyLineItemList = [SELECT PricebookEntry.Product2.Market_Focus_Area__c,Description,
                                            PricebookEntry.Product2.Name, PricebookEntry.Product2.Family, UnitPrice,  
                                            Business_Type__c FROM OpportunityLineItem WHERE OpportunityId =: opptyId ORDER BY PricebookEntry.Product2.Family asc];

    // Renewal Contract Product decommissioned - 6 Oct 2011
    // List<CA_Product_Renewal__c> caProdList = [Select  c.projected_renewal__c,c.Active_Contract_Product__r.AOCV__c,c.Active_Contract_Product__r.product__r.Market_Focus_Area__c, c.Active_Contract_Product__r.product__r.family 
    //                                         from CA_Product_Renewal__c c where c.Renewal_Opportunity__c =:opptyId];
    
    for(OpportunityLineItem optyLineItem : optyLineItemList)
    {
        // Unassigned code added to handle unmapped products - 6 Oct 2011
        unassignedInd = true;
        for(String buVal : businessUnitPicklistValues) 
        {
            if (optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c.equals(buVal))
                unassignedInd = false;
        }
        if(unassignedInd)
                optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c = 'Unassigned';
    
        System.debug('Business Unit + Product Family => '+optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family + ' => Unit Price => ' +businessUnitFamilAndUnitPriceMap.get(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family));
        if(!((optyLineItem.PricebookEntry.Product2.Family == 'Services' || optyLineItem.PricebookEntry.Product2.Family == 'Education') ))
        {
            // Following code was replaced to correct Renewals processing - 6 Oct 2011
            // unitPrice = businessUnitFamilAndUnitPriceMap.get(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family);
            // if(unitPrice != null)
            // businessUnitFamilAndUnitPriceMap.put(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family, (unitPrice + optyLineItem.UnitPrice));
            // else
            // businessUnitFamilAndUnitPriceMap.put(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family, (optyLineItem.UnitPrice));

            if(optyLineItem.PricebookEntry.Product2.Family == 'Product' && optyLineItem.Business_Type__c == 'Renewal')
            { 
                unitPrice = businessUnitFamilAndUnitPriceMap.get(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+'Renewal');
                if(unitPrice != null)
                    businessUnitFamilAndUnitPriceMap.put(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+'Renewal', (unitPrice + optyLineItem.UnitPrice));
                else
                    businessUnitFamilAndUnitPriceMap.put(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+'Renewal', (optyLineItem.UnitPrice));
            }
            else
            {
                unitPrice = businessUnitFamilAndUnitPriceMap.get(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family);
                if(unitPrice != null)
                    businessUnitFamilAndUnitPriceMap.put(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family, (unitPrice + optyLineItem.UnitPrice));
                else
                    businessUnitFamilAndUnitPriceMap.put(optyLineItem.PricebookEntry.Product2.Market_Focus_Area__c+optyLineItem.PricebookEntry.Product2.Family, (optyLineItem.UnitPrice));
            }

        }
    } 
    //System.debug('businessUnitFamilAndUnitPriceMap => '+businessUnitFamilAndUnitPriceMap);
    
        Double totalPNCV = 0;
        Double totalSerNCV = 0;
        Double totalENCV = 0;
        Double totalNCV = 0;
        Double totalRenewal = 0;
        Double totalCV = 0;
        Double totalSupNCV = 0;
    
    //order the BU's as per requirement
   /* businessUnitPicklistValues.set(0,'SA');
    businessUnitPicklistValues.set(1,'VSA');
    businessUnitPicklistValues.set(2,'PPM');
    businessUnitPicklistValues.set(3,'SEC');
    businessUnitPicklistValues.set(4,'MAINFRAME');
    businessUnitPicklistValues.set(5,'CLOUD');
    businessUnitPicklistValues.set(6,'OTHER');
    businessUnitPicklistValues.set(7,'Future FY Time');
    businessUnitPicklistValues.set(8,'Current FY Time');
    businessUnitPicklistValues.set(9,'Mainframe Capacity');
    businessUnitPicklistValues.set(10,'Unassigned');
  */
    businessUnitPicklistValues.add('Unassigned');   
    //Need to show a blank column
    String strblank = ''; 
    //Group Products by Family & Businesss Unit.
    Set<string> assignedBUs = new Set<string>();
    for(string str : productFamilyPicklistValues)
      assignedBUs.add(str);
      
  
  /*  assignedBUs.add('SA');
    assignedBUs.add('VSA');
    assignedBUs.add('PPM');
    assignedBUs.add('SEC');
    assignedBUs.add('MAINFRAME');
    assignedBUs.add('CLOUD');
    assignedBUs.add('OTHER');
    assignedBUs.add('Future FY Time');
    assignedBUs.add('Current FY Time');
    assignedBUs.add('Mainframe Capacity');
    */
    
    for(String businessUnitPicklistValue : businessUnitPicklistValues)
    {
        //ISBU and RMDM Business Units should not appear on the Opp Summary. 
        //if(businessUnitPicklistValue != 'ISBU' && businessUnitPicklistValue != 'RMDM')
        //{
            List<String> businessUnitAndPriceList = new List<String>();
            
            businessUnitAndPriceList.add(businessUnitPicklistValue);
            Double PNCV = 0;
            Double SerNCV = 0;
            Double ENCV = 0;
            Double NCV = 0;
            Double Renewal = 0;
            Double CV = 0;
            Double SupNCV = 0;
            
            // Renewal Contract Product decommissioned - 6 Oct 2011
            // if(caProdList.size()>0){
            //    for(CA_Product_Renewal__c ca : caProdList){
            //        if(ca.Active_Contract_Product__c != null){
                    
                        //if(businessUnitPicklistValue == ca.Active_Contract_Product__r.product__r.Market_Focus_Area__c)
                        //{
                        //    Renewal += (ca.projected_renewal__c == null?0:ca.projected_renewal__c);
                        //    totalRenewal+= (ca.projected_renewal__c == null?0:ca.projected_renewal__c);
                        //    System.Debug('UNASSIGNED1'+totalRenewal);
                        //} 
                        //Commented by Rao to avoid the incorrect total 
                       /// else if(assignedBUs.contains(ca.Active_Contract_Product__r.product__r.Market_Focus_Area__c) ==false && businessUnitPicklistValue == 'Unassigned' ){
                         //else if(businessUnitPicklistValue == 'Unassigned' ){
                          //  Renewal += (ca.projected_renewal__c == null?0:ca.projected_renewal__c);
                           // totalRenewal+= (ca.projected_renewal__c == null?0:ca.projected_renewal__c);
                           // System.Debug('UNASSIGNED'+totalRenewal);
                        //} 
                        
                   
                        
            //        }
            //    }
            // }
           
            for(String productFamilyPicklistValue : productFamilyPicklistValues)
            {
             
                if(productFamilyPicklistValue == 'Product' && businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    PNCV = businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    NCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    totalPNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    
                }
                else if(productFamilyPicklistValue == 'Services' && businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    SerNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    NCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    totalSerNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                }
                else if(productFamilyPicklistValue == 'Education' && businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    ENCV = businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    NCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    totalENCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                }
                else if(productFamilyPicklistValue == 'Support' && businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    //SNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    //totalSNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    SupNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    NCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalSupNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalNCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                }
                else if((productFamilyPicklistValue == 'Renewal')&& businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    Renewal += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalRenewal += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    System.debug('Rao....'+Renewal  );  
                }
                else if((productFamilyPicklistValue == 'Time')&& businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    Renewal += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    System.debug('Rao....'+Renewal  );  
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalRenewal += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                }
                else if((productFamilyPicklistValue == 'Mainframe Capacity')&& businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    Renewal += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    totalRenewal += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                }
                /*else if((productFamilyPicklistValue == 'Time' || productFamilyPicklistValue == 'Mainframe Capacity')&& businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue) != null)
                {
                    CV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                    
                    totalCV += businessUnitFamilAndUnitPriceMap.get(businessUnitPicklistValue+productFamilyPicklistValue);
                }*/
                
            }
            
            businessUnitAndPriceList.add(roundPrice(PNCV));
            businessUnitAndPriceList.add(roundPrice(SerNCV));
            businessUnitAndPriceList.add(roundPrice(ENCV));
            businessUnitAndPriceList.add(roundPrice(SupNCV));
            //Need to show a blank column
            businessUnitAndPriceList.add(strblank);
            businessUnitAndPriceList.add(roundPrice(NCV));
            businessUnitAndPriceList.add(roundPrice(Renewal));
            businessUnitAndPriceList.add(roundPrice(CV));
            
            MatrixString.add(businessUnitAndPriceList);
        //} 
        
    }
    
        footerRow.add(roundPrice(totalPNCV));
        footerRow.add(roundPrice(totalSerNCV));
        footerRow.add(roundPrice(totalENCV));
        footerRow.add(roundPrice(totalSupNCV));
        //Need to show a blank column
        footerRow.add(strblank);
        footerRow.add(roundPrice(totalNCV));
        footerRow.add(roundPrice(totalRenewal));
        System.Debug('totalrenewal=='+roundPrice(totalRenewal));
        footerRow.add(roundPrice(totalCV));
        
    
    //Group Products by Family.
    //for(String productFamilyPicklistValue : productFamilyPicklistValues)
    //{
        LineItemDetailsByFamily lineItemDetByFamily_PNCV_Renewal = new LineItemDetailsByFamily();
        List<OpportunityLineItem> lineItemList_PNCV_Renewal = new List<OpportunityLineItem>();
        
       
        for(OpportunityLineItem optyLineItem : optyLineItemList)
        {
            //(Only one summary should appear per Product Family) The fiscal period, sales milestone and inside/outside will be the same for each product and renewal added to an opp it is not tracked at the line item level.
            if(lineItemList_PNCV_Renewal.size() == 0)
            {
                //Since "Description" field is not used in this code, it is used to populate the Fiscal Period
                /*if(optyLineItem.Close_Date__c != null)
                {
                    if((optyLineItem.Close_Date__c).month() >= 1 && (optyLineItem.Close_Date__c).month() <= 3)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+'').substring(2,4) + '-Q4';
                    
                    else if((optyLineItem.Close_Date__c).month() >= 10 && (optyLineItem.Close_Date__c).month() <= 12)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+1+'').substring(2,4) + '-Q3';
                    
                    else if((optyLineItem.Close_Date__c).month() >= 7 && (optyLineItem.Close_Date__c).month() <= 9)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+1+'').substring(2,4) + '-Q2';
                    
                    else if((optyLineItem.Close_Date__c).month() >= 4 && (optyLineItem.Close_Date__c).month() <= 6)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+1+'').substring(2,4) + '-Q1';
                }*/
                
                if(optyLineItem.PricebookEntry.Product2.Family == 'Product' || optyLineItem.PricebookEntry.Product2.Family == 'Renewal' || optyLineItem.PricebookEntry.Product2.Family == 'Time' || optyLineItem.PricebookEntry.Product2.Family == 'Mainframe Capacity')
                lineItemList_PNCV_Renewal.add(optyLineItem);
            }
            
            // SNVC/ENCV Summary
            // SNVC =>  Services and Support; ENCV  => Education
            if(optyLineItem.PricebookEntry.Product2.Family == 'Services' || optyLineItem.PricebookEntry.Product2.Family == 'Support' || optyLineItem.PricebookEntry.Product2.Family == 'Education')
            {
                /*if(optyLineItem.Close_Date__c != null)
                {
                    if((optyLineItem.Close_Date__c).month() >= 1 && (optyLineItem.Close_Date__c).month() <= 3)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+'').substring(2,4) + '-Q4';
                    
                    else if((optyLineItem.Close_Date__c).month() >= 10 && (optyLineItem.Close_Date__c).month() <= 12)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+1+'').substring(2,4) + '-Q3';
                    
                    else if((optyLineItem.Close_Date__c).month() >= 7 && (optyLineItem.Close_Date__c).month() <= 9)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+1+'').substring(2,4) + '-Q2';
                    
                    else if((optyLineItem.Close_Date__c).month() >= 4 && (optyLineItem.Close_Date__c).month() <= 6)
                    optyLineItem.Description = 'FY'+ ((optyLineItem.Close_Date__c).year()+1+'').substring(2,4) + '-Q1';
                    
                    if(quarterAndUnitPriceMap.get(optyLineItem.Description) != null)
                    {
                        if(optyLineItem.UnitPrice != null)
                        {
                          Double sumOfUnitPrice = quarterAndUnitPriceMap.get(optyLineItem.Description);
                          quarterAndUnitPriceMap.put(optyLineItem.Description, sumOfUnitPrice + (optyLineItem.UnitPrice));
                        }
                    }
                    else
                    {
                        quarterList.add(optyLineItem.Description);
                        if(optyLineItem.UnitPrice != null)
                        quarterAndUnitPriceMap.put(optyLineItem.Description, (optyLineItem.UnitPrice));
                        else
                        quarterAndUnitPriceMap.put(optyLineItem.Description, 0);
                    }
                }*/
            }
            
            
        }
       
        //lineItemDetByFamily.productFamily = productFamilyPicklistValue;
        lineItemDetByFamily_PNCV_Renewal.productFamily = 'PNCV/Renewal Summary';
        lineItemDetByFamily_PNCV_Renewal.opptyLineItemList = lineItemList_PNCV_Renewal;
        lineItemDetailsByFamilyList.add(lineItemDetByFamily_PNCV_Renewal);
        
        for(Integer s=0; s<quarterList.size(); s++)
        {
        LineItemDetailsByQuarter lineItemDetByFamilyByQuarter  = new LineItemDetailsByQuarter();
        lineItemDetByFamilyByQuarter.quarter = quarterList[s];
        lineItemDetByFamilyByQuarter.UnitPrice = roundPrice(quarterAndUnitPriceMap.get(quarterList[s]));
        lineItemDetailsByQuarterList.add(lineItemDetByFamilyByQuarter);
        }
        
   //}
    
        
    
  
  }
  
  
    
    public class LineItemDetailsByFamily {          
    public String productFamily{get;set;}     
    public List<OpportunityLineItem> opptyLineItemList{get;set;}  
    }  
    public class LineItemDetailsByQuarter { 
    public String quarter{get;set;}     
    public String UnitPrice{get;set;}  
    }   
    
    public List<List<String>> getmatrix()
    {
        return MatrixString;
    }
    
    public String roundPrice(Decimal price)
    {
        String roundPrice;
        Decimal temproundPrice;
        if(price < 1000000)
        {
            if(price >= 1000)
            {
            roundPrice = (price/1000).round()+'K';
            }
            else
            roundPrice = price.round()+'';
        } 
        else if(price >= 1000000)
        {
            //roundPrice = (price/1000000).round()+'M';
            temproundPrice = (price/1000000).setscale(2);
            //round the decimal places to nearest tenth
            temproundPrice = temproundPrice * 10;
            temproundPrice = Math.round(temproundPrice);
            temproundPrice = temproundPrice / 10.0;
            roundPrice = temproundPrice.format()+'M';
            //roundPrice = roundPrice.substring(0,roundPrice.indexOf('.')+3);
            
            /*if(roundPrice.contains('.'))
            {
                String temp = roundPrice.substring(roundPrice.indexOf('.'),roundPrice.indexOf('.')+3);
                Double db_temp = Double.valueOf(temp).round();
                roundPrice = db_temp.format();
            }
            */
        }
        
        return roundPrice; 
    }
    
}