public class ACL_Increase_calc {

        
    public ACL_Increase_calc(){}
        
    public Map<id,Active_Contract_Line_Item__c> CalculateIncStep1_2_3(set<id> Cpids,list<Active_Contract_Line_Item__c> ACL_items){
        
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        System.debug('2.Number of rows queried in this apex code so far: ' + Limits.getDmlRows());
        System.debug('3. Number of script statements used so far : ' + Limits.getDmlStatements());
        
        // id= contract product id and value = Active_Contract_Line_Item__c
        Map<id,Active_Contract_Line_Item__c> OutputMap=new Map<id,Active_Contract_Line_Item__c>();
        
        
        Map<id,Active_Contract_Product__c> ContractProductMap=new Map<id,Active_Contract_Product__c>(
        [select Active_Contract__r.Header_Install_Date__c,Active_Contract__r.Territory_Country__c,Active_Contract__r.GSA_Pricing__c
        from Active_Contract_Product__c 
        where id in :Cpids and (Active_Contract__r.GSA_Pricing__c= true or Active_Contract__r.GSA_Pricing__c =false)]);
        
        System.debug('----Cp size ---'+ContractProductMap.size());
        System.debug('----Printing Query elements---'+ContractProductMap);
        
        for(Active_Contract_Line_Item__c acl:ACL_items){
           
            if(ContractProductMap.containsKey(acl.Contract_Product__c)){
                        
            	Date HeaderDt=ContractProductMap.get(acl.Contract_Product__c).Active_Contract__r.Header_Install_Date__c;
            	string trrCntry=ContractProductMap.get(acl.Contract_Product__c).Active_Contract__r.Territory_Country__c;
            	boolean GSAprice=Boolean.valueOf(ContractProductMap.get(acl.Contract_Product__c).Active_Contract__r.GSA_Pricing__c);
            	System.debug('--------Header date --------'+HeaderDt);
                System.debug('--------trrCntry --------'+trrCntry);
                System.debug('--------GSAprice --------'+GSAprice);
                System.debug('--------Currency --------'+acl.Renewal_Currency_Name__c);
                System.debug('--------Platform --------'+acl.Platform__c);
                System.debug('--------Dismantling Date --------'+acl.Dismantling_Date__c);
                String JpCntry=label.ACL_Japan;
                if(JpCntry== 'Japan'){
                     String dsds='adfdf';
                }
                String UsdCurr=label.ACL_Usd;
                if(UsdCurr == 'USD'){
                    string ud='xx';
                }
                String MfPlatform=label.ACL_Mainframe;
                if(MfPlatform == 'Mainframe'){
                    String mf='asdf';
                }
                System.debug('------jp,usd,mf---'+JpCntry+'--'+UsdCurr+'--'+MfPlatform);
                
                // All dates are used in Header date comparisions except few.
            	Date Y07_M1=Date.newInstance(2007,1,2);
            	Date Y08_M4=Date.newInstance(2008,4,1);
                Date Y09_M10=Date.newInstance(2009,10,1);
                Date Y13_M1=Date.newInstance(2013,1,1);     //Used in Dismantling_Date__c comparisions
                Date Y08_M4_2=Date.newInstance(2008,4,2);
                Date Y13_M7=Date.newInstance(2013,7,1);     //Used in Dismantling_Date__c comparisions
                Date Y10_M7=Date.newInstance(2010,7,1);
                Date Y18_M4=Date.newInstance(2018,4,1);     //Used in Dismantling_Date__c comparisions
                Date Y10_M7_2=Date.newInstance(2010,7,2);
                Date Y10_M6=Date.newInstance(2010,6,30);
                Date Y18_M3=Date.newInstance(2018,3,31);
                Date Y13_M7_3=Date.newInstance(2013,7,3);
                Date Y08_M3=Date.newInstance(2008,3,31);   
                Date Y07_M1_1=Date.newInstance(2007,1,1);
                Date Y13_M7_2=Date.newInstance(2013,7,2);
                System.debug('--------Y13_M7_3 --------'+Y13_M7_3);
                System.debug('--------Y18_M3 --------'+Y18_M3);
                System.debug('--------Y18_M4 --------'+Y18_M4);
                if(HeaderDt != Null){
                    
                    System.debug('---*********** Increase_Step_1_text2__c assignment Start**********-----');
                    boolean crtr1=false;
                    if(trrCntry !=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && HeaderDt>=Y07_M1 && HeaderDt<=Y08_M4){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c<Y13_M1
                        && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                        crtr1=true;
                            System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>Y13_M1
                        && acl.Dismantling_Date__c<Y13_M7 && trrCntry!=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr&& acl.Platform__c==MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>=Y13_M7
                        && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c<Y13_M1
                        && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c !=MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>Y13_M1
                        && acl.Dismantling_Date__c<Y13_M7 && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c !=MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>=Y13_M7
                        && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c !=MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && trrCntry !=JpCntry && GSAprice 
                        && acl.Renewal_Currency_Name__c !=UsdCurr){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>= Y08_M4_2 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c> Y13_M1
                        && trrCntry== JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c> Y13_M1 && trrCntry== JpCntry && GSAprice && acl.Renewal_Currency_Name__c != UsdCurr && acl.Platform__c != MfPlatform ){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4_2&& HeaderDt<=Y09_M10 && acl.Dismantling_Date__c< Y13_M1 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c== UsdCurr && acl.Platform__c != MfPlatform){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                    else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>=Y13_M7 && trrCntry== JpCntry && GSAprice){
                        crtr1=true;System.debug('---crtr value became 1---'+crtr1);
                    }
                   
                
        
            System.debug('---condition 1: crtr1 value---'+crtr1);
            // filed Increase_Step_1_text2__c assignment to 300 if criteria 'crtr1' is true
            if(crtr1){
                acl.Increase_Step_1_text2__c=300;
            }
            else{
                boolean crtr2=false;
                if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y10_M7 && acl.Dismantling_Date__c<Y13_M1 && trrCntry !=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                	}
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c !=UsdCurr && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y18_M4 && trrCntry==JpCntry && !GSAprice && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y07_M1 && HeaderDt<=Y10_M7 && acl.Dismantling_Date__c<Y13_M1 && trrCntry !=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c !=UsdCurr && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y10_M7_2 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y18_M4 && trrCntry !=JpCntry && !GSAprice && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y10_M6 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y18_M4 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    crtr2=true; System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y10_M6 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y18_M4 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c !=UsdCurr && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y10_M7_2 && HeaderDt<=Y18_M3 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry !=JpCntry && !GSAprice && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y13_M7_3 && HeaderDt<=Y18_M3 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry !=JpCntry && GSAprice && acl.Platform__c==MfPlatform){
                	crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if(HeaderDt>=Y10_M6 && HeaderDt<=Y18_M3 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && GSAprice && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                else if( HeaderDt>=Y08_M4_2 && HeaderDt<=Y18_M3 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && !GSAprice && acl.Platform__c==MfPlatform){
                    crtr2=true;System.debug('---crtr value became 2---'+crtr2);
                    }
                
           
                
            System.debug('---condition 2: crtr2 value---'+crtr2);
            // filed Increase_Step_1_text2__c assignment to 500 if criteria 'crtr2' is true  
            if(crtr2){
                acl.Increase_Step_1_text2__c=500;
            }
            else {
                    boolean crtr3=false;
                    
                if(HeaderDt<=Y08_M3 && HeaderDt<=Y13_M1 && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    crtr3=true;
                }
                else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    crtr3=true;
                    }
                else if(HeaderDt<=Y07_M1_1 && trrCntry !=JpCntry && !GSAprice){
                    crtr3=true;
                    }
                else if(HeaderDt<=Y08_M3 && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c != MfPlatform){
                     crtr3=true;
                    }
                else if(HeaderDt<=Y08_M3 && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c != UsdCurr){
                    crtr3=true;
                    }
                else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c>=Y13_M7 && trrCntry !=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    crtr3=true;
                    }
                else if(HeaderDt<=Y08_M4 && trrCntry==JpCntry && GSAprice){
                     crtr3=true;
                    }
                else if(HeaderDt<=Y08_M4 && trrCntry==JpCntry && !GSAprice){
                    crtr3=true;
                    }
         
          System.debug('---condition 3: crtr3 value---'+crtr3);
            // filed Increase_Step_1_text2__c assignment to 600 if criteria 'crtr3' is true  
            if(crtr3){
                acl.Increase_Step_1_text2__c=600;
            }
            else {
                   boolean crtr4=false;
                
                if(trrCntry !=JpCntry && acl.Platform__c==MfPlatform ){
                if(HeaderDt>=Y07_M1 && HeaderDt<=Y10_M7 && acl.Dismantling_Date__c>Y13_M1 && !GSAprice && acl.Renewal_Currency_Name__c !=UsdCurr ){
                       crtr4=true;
                   }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y10_M7 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y18_M4 && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr ){
                            crtr4=true;
                        }
                else if(HeaderDt>=Y10_M6 && HeaderDt<=Y13_M7_2 && acl.Dismantling_Date__c>=Y13_M7 && GSAprice ){
                        crtr4=true;
                        }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y10_M7 && acl.Dismantling_Date__c>=Y18_M4  && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr ){
                        crtr4=true;
                        }
                }
              System.debug('---condition 4: crtr4 value---'+crtr4);
            // filed Increase_Step_1_text2__c assignment to 10.25 if criteria 'crtr4' is true  
            if(crtr4){
                acl.Increase_Step_1_text2__c=1025; //10.25
            }
            else{
              acl.Increase_Step_1_text2__c=0;
            }
            }
            }                     
        }
                
                System.debug('---*********** Increase_Step_1_text2__c assignment end**********-----');
                System.debug('----acl.Increase_Step_1_text2__c value--'+acl.Increase_Step_1_text2__c);
                
                System.debug('---*********** Increase_Step_2_text__c assignment Start**********-----');
                
                             boolean Step2_crtr1=false;
             if(HeaderDt<=Y07_M1_1 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr){
                 Step2_crtr1=true;
             }
             else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c<Y13_M1 && trrCntry!=JpCntry && GSAprice){
                   Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry!=JpCntry && GSAprice && acl.Platform__c !=MfPlatform){
                 Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry!=JpCntry && GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                 Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c>=Y13_M7 && trrCntry!=JpCntry && GSAprice){
                 Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M4 && trrCntry==JpCntry && acl.Renewal_Currency_Name__c==UsdCurr){
                 Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>Y13_M1 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c != MfPlatform){
                 Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>=Y13_M7 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                 Step2_crtr1=true;
                  }
             else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry!=JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                 Step2_crtr1=true;
                  }
             
           System.debug('---condition 1: Step2_crtr1 value---'+Step2_crtr1);
            // filed Increase_Step_2_text__c assignment to 300 if criteria 'Step2_crtr1' is true
            if(Step2_crtr1){
                acl.Increase_Step_2_text__c=300;
            }
            else {
                   boolean Step2_crtr2=false;
                
                if(HeaderDt<=Y07_M1_1 && acl.Dismantling_Date__c<Y13_M1 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                }
                else if(HeaderDt>=Y07_M1 && HeaderDt<=Y08_M4 && acl.Dismantling_Date__c<Y13_M1 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }   
                else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry==JpCntry && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>=Y13_M7 && acl.Dismantling_Date__c<Y18_M4 && trrCntry==JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>=Y13_M1 && acl.Dismantling_Date__c<Y13_M7 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>=Y13_M7 && acl.Dismantling_Date__c<Y18_M4 && trrCntry==JpCntry && GSAprice && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y10_M6 && HeaderDt<=Y13_M7_2 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && GSAprice && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y07_M1 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && !GSAprice && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && GSAprice && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt>=Y08_M4_2 && HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && !GSAprice &&acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                else if(HeaderDt<=Y13_M1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr2=true;
                     }
                
            System.debug('---condition 2: Step2_crtr2 value---'+Step2_crtr2);
            // filed Increase_Step_2_text__c assignment to 5 if criteria 'Step2_crtr2' is true
            if(Step2_crtr2){
                acl.Increase_Step_2_text__c=500;
            }
            else {
                    boolean Step2_crtr3=false;
                
                if(HeaderDt<=Y07_M1_1 && acl.Dismantling_Date__c>Y13_M1 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr && acl.Platform__c==MfPlatform){
                    Step2_crtr3=true;
                }
                else if(HeaderDt>=Y07_M1 && HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>Y13_M1 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr && acl.Platform__c==MfPlatform){
                     Step2_crtr3=true;
                     }
                else if(HeaderDt>=Y08_M4 && HeaderDt<=Y09_M10 && acl.Dismantling_Date__c>=Y13_M7 && trrCntry!=JpCntry && GSAprice && acl.Platform__c==MfPlatform){
                    Step2_crtr3=true;
                     }
                
            System.debug('---condition 3: Step2_crtr3 value---'+Step2_crtr3);
            // filed Increase_Step_2_text__c assignment to 10.25 if criteria 'Step2_crtr3' is true
            if(Step2_crtr3){
                acl.Increase_Step_2_text__c=1025; //10.25
            }
            else {
                    acl.Increase_Step_2_text__c=0;
                }     
                
            }            
            }
                
                
                
                System.debug('---*********** Increase_Step_2_text__c assignment end**********-----');
                System.debug('----acl.Increase_Step_2_text__c value--'+acl.Increase_Step_2_text__c);
                
                System.debug('---*********** Increase_Step_3_text__c assignment start**********-----');
                
        if(acl.Platform__c==MfPlatform){
                 
                 boolean step3_crtr1=false;
                 
                 if(HeaderDt<=Y07_M1_1 && acl.Dismantling_Date__c<=Y13_M1 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr){
                     step3_crtr1=true;
                 }
                 else if(HeaderDt<=Y07_M1_1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr){
                      step3_crtr1=true;
                      }
                 else if(HeaderDt<=Y09_M10 && HeaderDt>=Y08_M4 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && GSAprice){
                     step3_crtr1=true;
                      }
                 else if(HeaderDt<=Y09_M10 && HeaderDt>=Y08_M4_2 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && GSAprice){
                     step3_crtr1=true;
                      }
                 else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c<Y18_M4 && acl.Dismantling_Date__c>Y13_M1 && trrCntry==JpCntry && acl.Renewal_Currency_Name__c==UsdCurr){
                     step3_crtr1=true;
                      }
                 else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>=Y13_M7 && acl.Dismantling_Date__c<Y18_M4 && trrCntry==JpCntry && GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr){
                     step3_crtr1=true;
                      }
                 else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && !GSAprice && acl.Renewal_Currency_Name__c!=UsdCurr){
                     step3_crtr1=true;
                      }
                 else if(HeaderDt<=Y08_M4 && HeaderDt>=Y07_M1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && !GSAprice && acl.Renewal_Currency_Name__c==UsdCurr){
                     step3_crtr1=true;
                      }
                 
                 System.debug('---condition 1--step3_crtr1--'+step3_crtr1);
                 if(step3_crtr1){
                     acl.Increase_Step_3_text__c=500; //5
                 }
                 else{
					 
                    boolean step3_crtr2=false; 
                     if(HeaderDt<=Y07_M1_1 && acl.Dismantling_Date__c>Y13_M1 && acl.Dismantling_Date__c<Y18_M4 && trrCntry!=JpCntry && (!GSAprice) && acl.Renewal_Currency_Name__c==UsdCurr){
                         step3_crtr2=true;
                     }                   
                     else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c>=Y13_M7 && acl.Dismantling_Date__c<Y18_M4 && trrCntry!=JpCntry && GSAprice){
                          step3_crtr2=true;
                          }
                     else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && GSAprice){
                         step3_crtr2=true;
                          }
                     else if(HeaderDt<=Y08_M4 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry==JpCntry && (!GSAprice) && acl.Renewal_Currency_Name__c==UsdCurr){
                         step3_crtr2=true;
                          }
                     
                    System.debug('---condition 1--step3_crtr2--'+step3_crtr2);
                 if(step3_crtr2){
                     acl.Increase_Step_3_text__c=1025; //10.25
                 }
                 else{
                     boolean step3_crtr3=false;
                     if(HeaderDt<=Y07_M1_1 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && (!GSAprice) && acl.Renewal_Currency_Name__c==UsdCurr){
                         step3_crtr3=true;
                     }
                     else if(HeaderDt<=Y08_M3 && acl.Dismantling_Date__c>=Y18_M4 && trrCntry!=JpCntry && GSAprice){
                          step3_crtr3=true;
                          }
                     
                      System.debug('---condition 1--step3_crtr3--'+step3_crtr3);
                 if(step3_crtr3){
                     acl.Increase_Step_3_text__c=1576; //1576
                 }
                 else{
                          acl.Increase_Step_3_text__c=0;
                     }
                     
                 }
                 }
                 
             }
        else{ 
        acl.Increase_Step_3_text__c=0;
		}
     
                
                System.debug('---*********** Increase_Step_3_text__c assignment end**********-----');
                System.debug('----acl.Increase_Step_3_text__c value--'+acl.Increase_Step_3_text__c);
      }
                else{
                     acl.Increase_Step_1_text2__c=0;
                     acl.Increase_Step_2_text__c=0;
                     acl.Increase_Step_3_text__c=0;
                }
                
                     
            }
            else{
                
            acl.Increase_Step_1_text2__c=0;
            acl.Increase_Step_2_text__c=0;
            acl.Increase_Step_3_text__c=0;
                
            }
                     
            OutputMap.put(acl.id,acl);

        }
        
        return OutputMap;
    }
    
}