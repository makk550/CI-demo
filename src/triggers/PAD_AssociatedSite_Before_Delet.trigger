/**
*Description :trigger to call the class to delet Product Alignments when an 
Associated Site is deleted.
*SOQl: 0
*DML: 0
*Client: CA technologies
*Developed By:  Accenture
*/
trigger PAD_AssociatedSite_Before_Delet on Associated_Site__c (before delete) {

    //calling class to delet the product alignments created on the Associated sites. 
    PAD_DeletProdAlignmentAfterSiteDelet classVar=new PAD_DeletProdAlignmentAfterSiteDelet();
    classVar.deletProdAlignmentOnSiteDelet(Trigger.Old);
}