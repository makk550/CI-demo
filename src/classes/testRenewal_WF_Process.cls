@isTest
public class testRenewal_WF_Process{
   public static testmethod void testMeth_WFProcess(){
   
        Renewal_Currency__c  rcObj = new Renewal_Currency__c();
        rcObj.Name='test rc';
        rcObj.Conversion_Rate__c = 2;
        insert rcObj;
   
        List<Renewal__c> renList =new List<renewal__c>();
       
       Renewal__c renObj1 = new Renewal__c();
       renObj1.name = 'test renObj1';
       renObj1.Renewal_Date__c = system.today()+400;
       renObj1.Projected_Renewal__c = 400000;
        renObj1.Unapproved_Projected_Renewal_amount__c = 500000;
       renObj1.Projected_Time_Duration_Months__c = 20;
       renObj1.Segmentation__c = 'HT';
       renObj1.Renewal_Currency__c = rcObj.Id;
        renObj1.Change_Of_Projected_Renewal__c = -5;
        renObj1.Potential_Pull_Forward__c= false;
        renObj1.Overall_Comments__c = 'this is an overall comment';
        renObj1.Renewal_Risk__c = 'Pricing';
       renList.add(renObj1);
      
      
      
       Renewal__c renObj2 = new Renewal__c();
       renObj2.Name = 'test renObj2';
       renObj2.Renewal_Date__c = system.today()+400;
       renObj2.Projected_Renewal__c = 11;
       renObj2.Projected_Time_Duration_Months__c = 20;
       renObj2.Renewal_Currency__c = rcObj.Id;
        renObj2.Segmentation__c = 'MT';
        renObj2.Potential_Pull_Forward__c=false;
        renObj2.Overall_Comments__c = 'this is an overall comment';
        renObj2.Renewal_Risk__c = 'Pricing';
       renList.add(renObj2);
       
       insert renList ;
        
         renObj1.Projected_Renewal__c = 20;
         renObj2.Projected_Renewal__c = 20;
         renObj1.Segmentation__c = 'MT';
         renObj2.Segmentation__c = 'HT';
         renObj1.Segmentation_reason__c = 'Move to Autobill';
         renObj2.Segmentation_reason__c = 'Move to Autobill';
         renObj1.Projected_Time_Duration_Months__c = 20;
         renObj2.Projected_Time_Duration_Months__c = 20;
         renObj1.Is_Rejected_Recalled__c = true;
         renObj1.Unapproved_Projected_Renewal_amount__c = 5;
         renObj1.Unapproved_Duration_of_months__c = 1;
         renObj1.Unapprove_Segmentation__c='test';
         renObj2.Potential_Pull_Forward__c=false;
         renObj1.Potential_Pull_Forward__c= true;
         
         renObj1.IsRecordLocked__c = false;
         renObj1.Unapproved_Projected_Renewal_amount__c = 500002;
         renObj1.Projected_Renewal__c = 400002;
      //   renObj1.Projected_Renewal_USD__c = 200001;
      //   renObj1.Unapproved_Projected_Renewal_amount__c = 2;
         renObj1.Is_Segmentation_Changed__c = false;
       
       //  renObj1.Change_Of_Projected_Renewal__c = -6;
      
      //   renObj1.Proj_Realization_Rate_ATTRF__c = 90;
       //update renObj1;
       update renObj2;       
       
   }
    
   public static testmethod void testMeth_WFProcess_new()
   {
       Renewal_Currency__c  rcObj = new Renewal_Currency__c();
       rcObj.Name='test rc';
       rcObj.Conversion_Rate__c = 1;
       insert rcObj;
   
       List<Renewal__c> renList =new List<renewal__c>();
       
       for(Integer i=0;i<18;i++)
       {
           Renewal__c ren = new Renewal__c(Change_Of_Projected_Renewal__c=0,Is_Segmentation_Changed__c=false,Unapproved_Duration_of_months__c=0,Unapproved_Projected_Renewal_amount__c=0,Unapprove_Segmentation__c=null,Unapproved_Potential_Pull_Forward__c=false);
           ren.name = 'test ren' + i;
           ren.Renewal_Date__c = system.today()+400;
           ren.Projected_Renewal__c = 385000;
           ren.ATTRF_CRV__c=400000;
           ren.Projected_Time_Duration_Months__c = 14;
           ren.Segmentation__c = (i<6 || i>11?'HT':'MT');
           ren.Renewal_Currency__c = rcObj.Id;
           ren.Potential_Pull_Forward__c=false;
           ren.Overall_Comments__c = 'this is an overall comment';
           ren.Renewal_Risk__c = 'Pricing';
           
           renList.add(ren);
       }
       
       insert renList;
       
       
       // HT: PPF and Chg <-5%
       renList[0].Potential_Pull_Forward__c=true;
       renList[0].Projected_Renewal__c = 200000;
       
       // HT: PPF and Projected Realization Rate (ATTRF) < 95%
       renList[1].Potential_Pull_Forward__c=true;
       renList[1].Projected_Renewal__c = 370000;
       
       // HT: PPF Only
       renList[2].Potential_Pull_Forward__c=true;
       
       // HT: no PPF and Chg <-5%
       renList[3].Projected_Renewal__c = 200000;
       
       // HT: no PPF and Projected Realization Rate (ATTRF) < 95%
       renList[4].Projected_Renewal__c = 370000;
       
       // HT: Catch-all?
       renList[5].Overall_Comments__c = 'nope';
       
       // MT/LT: PPF and Chg <-5%
       renList[6].Potential_Pull_Forward__c=true;
       renList[6].Projected_Renewal__c = 200000;
       
       // MT/LT: PPF and Projected Realization Rate (ATTRF) < 95%
       renList[7].Potential_Pull_Forward__c=true;
       renList[7].Projected_Renewal__c = 370000;
       
       // MT/LT: PPF Only
       renList[8].Potential_Pull_Forward__c=true;
       
       // MT/LT: no PPF and Chg <-5%
       renList[9].Projected_Renewal__c = 200000;
       
       // MT/LT: no PPF and Projected Realization Rate (ATTRF) < 95%
       renList[10].Projected_Renewal__c = 370000;
       
       // MT/LT: Catch-all?
       renList[11].Overall_Comments__c = 'nope';
       
       
       // set change
       for(Integer i=12;i<18;i++)
       {
           renList[i].Segmentation__c='MT';
           renList[i].Segmentation_Reason__c = 'Customer Moving Off Mainframe – Move to MT';
       }
       
       // seg change: PPF and Chg <-5%
       renList[12].Potential_Pull_Forward__c=true;
       renList[12].Projected_Renewal__c = 200000;
       
       // seg change: PPF and Projected Realization Rate (ATTRF) < 95%
       renList[13].Potential_Pull_Forward__c=true;
       renList[13].Projected_Renewal__c = 370000;
       
       // seg change: PPF Only
       renList[14].Potential_Pull_Forward__c=true;
       
       // seg change: no PPF and Chg <-5%
       renList[15].Projected_Renewal__c = 200000;
       
       // seg change: no PPF and Projected Realization Rate (ATTRF) < 95%
       renList[16].Projected_Renewal__c = 370000;
       
       // seg change: Catch-all?
       renList[17].Overall_Comments__c = 'nope';
       
       update renList;
   }
       
}