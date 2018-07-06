/**
*Description :Class to Delet the Product alignments linked to an associated site 
    when the associated site is deleted.
*Methods deletProdAlignmentOnSiteDelet  , with List of Associated_Site__c as input
*SOQl: 1
*DML: 1 
*Client: CA technologies
*Developed By:  Accenture
*/
public class PAD_DeletProdAlignmentAfterSiteDelet {
    
    Set<Id> setOfSites=new Set<Id>();
    List<Product_Alignment__c> listOfProdAlignments=new List<Product_Alignment__c>();
    
    //Method called by trigger to delet the Product alignment if the sites is deleted.
    public void deletProdAlignmentOnSiteDelet(List<Associated_Site__c> thisSite){
        for(Associated_Site__c p: thisSite){
            setOfSites.add(p.Id);
        }
        listOfProdAlignments=[Select p.Id, p.Associated_Site__c From Product_Alignment__c p where
         p.Associated_Site__c in : setOfSites];
        if(listOfProdAlignments!=null && listOfProdAlignments.size()>0)
            delete listOfProdAlignments;
    }
}