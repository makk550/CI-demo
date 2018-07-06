global class DE_CreateAccFromSite_CLS
{
    webservice static string createAccFromSA(ID SID)
    {
         DE_AccSearch_CLS objAccSrch = new  DE_AccSearch_CLS();
         objAccSrch.populateSAForNewAcc(SID);
         objAccSrch.createTaqAccount();
         //
         return objAccSrch.accname; 
    }
}