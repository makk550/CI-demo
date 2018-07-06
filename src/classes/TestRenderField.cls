@IsTest
private class TestRenderField {
	private static testmethod void testThreeParamConstructor(){
		final Schema.DescribeFieldResult d1 = Account.Industry.getDescribe();
		final Schema.DescribeFieldResult d2 = Account.Type.getDescribe();
		
		List<RenderField> theList = new List<RenderField>();
		for(Integer i = 0; i < 10; i++){
			theList.add(new RenderField('Account', d1, d2));
		}
		RenderFilterField.putFilterFieldList(theList);
		System.assert(d1 != null && d2 != null);
	}
}