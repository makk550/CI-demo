trigger RFP_Response_PopulateSrchFields_TRG on Response__c  (before insert,before update)
{
    //This trigger is going to work for both insert and update in before mode. The commit to database is
    //with held until trigger completes the last execution line on the same record on which this trigger
    //is called. Since this trigger is updating self in both insert and update transactions, so please do
    //issue Database.update...statement. At the end of execution it will automatically commit with update
    //statement. Self updates have to be done only through before insert, before update combination only
    //Sharat (vursh01)
    Set<id> idProd = new Set<id>();

    //collect the product ids for updating the name and BU
    For (Response__c  cObj :   Trigger.New)
    {
        If (cObj.ProductResp__c  != null )
            idProd.add(cObj.ProductResp__c);
    }//end for 
    
    if(idProd.size()>0)
    {
           Map<id,Product2>   lstProd = new Map<id,Product2>( [Select id,  Name , Market_Focus_Area__c  From Product2  where id  in : idProd and Salesforce_CPQ_Product__c=false ]) ;
           For(Response__c tRsp: Trigger.New)
           {
                If (tRsp.ProductResp__c != null )
                {
                    tRSP.Product_Search__c =  lstProd.get(tRsp.ProductResp__c).Name;
                    tRSP.BU_Search__c = lstProd.get(tRsp.ProductResp__c).Market_Focus_Area__c;
                 }//end if 
           }//end for 

    }// end if 
}