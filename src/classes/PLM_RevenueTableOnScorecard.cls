/**
Class Name: PLM_RevenueTableOnScorecard

Date: 6/22/2010
Date Updated: 10/5/2010

Project/Requirement: CA PRM Phase 1/PLM

Author: Accenture

Description: This class is controller to the page "PLM_RevenueTableOnScorecard". This class gets the revenue data against a 
BU and a month for the current fiscal year and returns to the page to display the records in a tabular format.
*/



public class PLM_RevenueTableOnScorecard {    
    
    //variable declarations
    String actId;
    String currCode;
    List<WithVals> revs = new List<WithVals>();
    WithVals varOfRev;
    WithVals varOfTotalByMonthRev = new WithVals();//to add the row for Total By Months -R2
    List<Revenue__c> rList;
    List<String> buList = new List<String>();
    Set<String> buSet = new Set<String>();
    Map<String,List<Revenue__c>> buRevenueListMap = new Map<String,List<Revenue__c>>();//map to store revenue against an account Id  

    //varibles to store revenue against months
    Double varOfRevJan;
    Double varOfRevFeb;
    Double varOfRevMar;
    Double varOfRevApr;
    Double varOfRevMay;
    Double varOfRevJun;
    Double varOfRevJul;
    Double varOfRevAug;
    Double varOfRevSep;
    Double varOfRevOct;
    Double varOfRevNov;
    Double varOfRevDec;
    
    //added by Siddharth (PRM R2)- varibles to store total revenue against months for -R2
    Double totalByMonthRevJan=0;
    Double totalByMonthRevFeb=0;
    Double totalByMonthRevMar=0;
    Double totalByMonthRevApr=0;
    Double totalByMonthRevMay=0;
    Double totalByMonthRevJun=0;
    Double totalByMonthRevJul=0;
    Double totalByMonthRevAug=0;
    Double totalByMonthRevSep=0;
    Double totalByMonthRevOct=0;
    Double totalByMonthRevNov=0;
    Double totalByMonthRevDec=0;
    Double totalByMonthRevBuTotal=0;
    


    public PLM_RevenueTableOnScorecard(ApexPages.StandardController controller) {
        
        for(Scorecard__c s: [SELECT Id, Partner__c FROM Scorecard__c WHERE Id =: ApexPages.currentPage().getParameters().get('Id')]){
            actId = s.Partner__c;
        }

        for(Revenue__c r: [SELECT Product_Family__c, Product_Type__c, Local_Revenue__c, Licensing_Type__c, Id, Functional_Business_Unit__c, End_User__c, End_User_Zip__c, End_User_State_Province__c, End_User_Country__c, End_User_Address__c, Distributor__c, Disti_Site_ID__c, Date__c, CurrencyIsoCode, Country__c FROM Revenue__c WHERE Distributor__c =: actId]){
            rList = new List<Revenue__c>();
            try{
                currCode = r.CurrencyIsoCode + ' ';

                if(buRevenueListMap.containsKey(r.Functional_Business_Unit__c)){
                    rList = buRevenueListMap.get(r.Functional_Business_Unit__c);
                    rList.add(r);
                }else{
                    rList.add(r);
                }            
                buRevenueListMap.put(r.Functional_Business_Unit__c,rList);
                buSet.add(r.Functional_Business_Unit__c);
            }catch(Exception e){
                System.debug('Something did not go right!!!');
            }
        }
        buList.addAll(buSet);
        buList.sort();
    }

    
    public List<WithVals> getRevenues() {

        Integer cMonth = System.today().month();
        Integer cYear = System.today().year();

        Integer rMonth;
        Integer rYear;

        Double amount;
        Double TotalAmount;//added by Siddharth (PRM R2)- to be used for Total By BU -R2
        for(String bu: buList){
            varOfRevJan = 0;
            varOfRevFeb = 0;
            varOfRevMar = 0;
            varOfRevApr = 0;
            varOfRevMay = 0;
            varOfRevJun = 0;
            varOfRevJul = 0;
            varOfRevAug = 0;
            varOfRevSep = 0;
            varOfRevOct = 0;
            varOfRevNov = 0;
            varOfRevDec = 0;
            
            System.debug('bu***'+bu);
            
            TotalAmount=0;
            
            //adding the amounts for each month.
            for(Revenue__c r: buRevenueListMap.get(bu)){
                varOfRev = new WithVals();
                amount = 0;
                if(r.Date__c != null){
                    rMonth = r.Date__c.month();
                    rYear = r.Date__c.year();
                }
                if(r.Local_Revenue__c != null){
                    amount = r.Local_Revenue__c;
                }
                
                try{
                    if(cMonth <= 3){                        
                        if(rMonth == 4 && rYear == cYear - 1){
                        	varOfRevApr = varOfRevApr + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 5 && rYear == cYear - 1){
                        	varOfRevMay = varOfRevMay + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 6 && rYear == cYear - 1){
                        	varOfRevJun = varOfRevJun + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 7 && rYear == cYear - 1){
                        	varOfRevJul = varOfRevJul + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 8 && rYear == cYear - 1){
                        	varOfRevAug = varOfRevAug + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 9 && rYear == cYear - 1){
                        	varOfRevSep = varOfRevSep + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 10 && rYear == cYear - 1){
                        	varOfRevOct = varOfRevOct + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 11 && rYear == cYear - 1){
                        	varOfRevNov = varOfRevNov + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 12 && rYear == cYear - 1){
                        	varOfRevDec = varOfRevDec + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 1 && rYear == cYear){
                        	varOfRevJan = varOfRevJan + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 2 && rYear == cYear){
                        	varOfRevFeb = varOfRevFeb + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 3 && rYear == cYear){
                        	varOfRevMar = varOfRevMar + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                    }else{
                        if(rMonth == 4 && rYear == cYear){
                        	varOfRevApr = varOfRevApr + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 5 && rYear == cYear){
                        	varOfRevMay = varOfRevMay + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 6 && rYear == cYear){
                        	varOfRevJun = varOfRevJun + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 7 && rYear == cYear){
                        	varOfRevJul = varOfRevJul + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 8 && rYear == cYear){
                        	varOfRevAug = varOfRevAug + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 9 && rYear == cYear){
                        	varOfRevSep = varOfRevSep + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 10 && rYear == cYear){
                        	varOfRevOct = varOfRevOct + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 11 && rYear == cYear){
                        	varOfRevNov = varOfRevNov + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 12 && rYear == cYear){
                        	varOfRevDec = varOfRevDec + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 1 && rYear == cYear + 1){
                        	varOfRevJan = varOfRevJan + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 2 && rYear == cYear + 1){
                        	varOfRevFeb = varOfRevFeb + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                        if(rMonth == 3 && rYear == cYear + 1){
                        	varOfRevMar = varOfRevMar + amount;
                        	TotalAmount=TotalAmount+amount;
                        }
                    }
                }catch(Exception ex){
                    System.debug('System went wrong!!!'+ex);
                }
            }
                varOfRev.bu = bu;
                
                //adding currency to amount totaled by months.
                varOfRev.jan = currCode + varOfRevJan;
                varOfRev.feb = currCode + varOfRevFeb;
                varOfRev.mar = currCode + varOfRevMar;
                varOfRev.apr = currCode + varOfRevApr;
                varOfRev.may = currCode + varOfRevMay;
                varOfRev.jun = currCode + varOfRevJun;
                varOfRev.jul = currCode + varOfRevJul;
                varOfRev.aug = currCode + varOfRevAug;
                varOfRev.sep = currCode + varOfRevSep;
                varOfRev.oct = currCode + varOfRevOct;
                varOfRev.nov = currCode + varOfRevNov;
                varOfRev.dec = currCode + varOfRevDec;
                varOfRev.YrTotal = currCode + TotalAmount;
                
                //added by Siddharth (PRM R2) Calculation of the Total by Months -R2
                totalByMonthRevJan = totalByMonthRevJan + varOfRevJan;
                totalByMonthRevFeb = totalByMonthRevFeb + varOfRevFeb;
                totalByMonthRevMar = totalByMonthRevMar + varOfRevMar;
                totalByMonthRevApr = totalByMonthRevApr + varOfRevApr;
                totalByMonthRevMay = totalByMonthRevMay + varOfRevMay;
                totalByMonthRevJun = totalByMonthRevJun + varOfRevJun;
                totalByMonthRevJul = totalByMonthRevJul + varOfRevJul;
                totalByMonthRevAug = totalByMonthRevAug + varOfRevAug;
                totalByMonthRevSep = totalByMonthRevSep + varOfRevSep;
                totalByMonthRevOct = totalByMonthRevOct + varOfRevOct;
                totalByMonthRevNov = totalByMonthRevNov + varOfRevNov;
                totalByMonthRevDec = totalByMonthRevDec + varOfRevDec;
                totalByMonthRevBuTotal = totalByMonthRevBuTotal + TotalAmount;

                revs.add(varOfRev);
        }
        if(currCode == null)
            currCode='';
        
        //added by Siddharth (PRM R2) Adding currency to the final values totaled by Months.    
        varOfTotalByMonthRev.bu = 'Month Total';
        varOfTotalByMonthRev.jan = currCode + totalByMonthRevJan;
        varOfTotalByMonthRev.feb = currCode + totalByMonthRevFeb;
        varOfTotalByMonthRev.mar = currCode + totalByMonthRevMar;
        varOfTotalByMonthRev.apr = currCode + totalByMonthRevApr;
        varOfTotalByMonthRev.may = currCode + totalByMonthRevMay;
        varOfTotalByMonthRev.jun = currCode + totalByMonthRevJun;
        varOfTotalByMonthRev.jul = currCode + totalByMonthRevJul;
        varOfTotalByMonthRev.aug = currCode + totalByMonthRevAug;
        varOfTotalByMonthRev.sep = currCode + totalByMonthRevSep;
        varOfTotalByMonthRev.oct = currCode + totalByMonthRevOct;
        varOfTotalByMonthRev.nov = currCode + totalByMonthRevNov;
        varOfTotalByMonthRev.dec = currCode + totalByMonthRevDec ;
        varOfTotalByMonthRev.yrTotal = currCode + totalByMonthRevBuTotal;
        
        revs.add(varOfTotalByMonthRev);
        return revs;
    }
        
//class with values only
 public class WithVals{

            public String bu{get;set;}

            public String jan{get;set;}
            public String feb{get;set;}
            public String mar{get;set;}
            public String apr{get;set;}
            public String may{get;set;}
            public String jun{get;set;}
            public String jul{get;set;}
            public String aug{get;set;}
            public String sep{get;set;}
            public String oct{get;set;}
            public String nov{get;set;}
            public String dec{get;set;}
            public String yrTotal{get;set;}
    }            
}