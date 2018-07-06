public class renewal_viewCAProduct {
    String strProdId;
    public renewal_viewCAProduct(ApexPages.StandardController controller) {
        strProdId=system.currentPageReference().getParameters().get('retURL');
        strProdId = strProdId.subString(1,strProdId.length());
    }
    public pageReference goToEdit(){
        PageReference pageRef = new PageReference('/apex/Renewal_editCAProduct?id='+strProdId);
         pageRef.setRedirect(true);
         return pageRef;
    }
	
	@isTest(SeeAllData=true)
	public static void renewal_viewCAProduct_test() {
		ApexPages.StandardController controller;
		system.currentPageReference().getParameters().put('retURL','testId');
		renewal_viewCAProduct c = new renewal_viewCAProduct(controller);
		c.goToEdit();
	}
}