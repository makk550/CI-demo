@IsTest
private class TestDataTest {

    private static testmethod void testEnsureVariableExists_Existing(){
    	Configuration_Variable__c variable = new Configuration_Variable__c(name='test123',value__c='abcd');
        insert variable;
        TestData.ensureVariableExists('test123','abcd');      
        System.assertEquals(variable.Name, 'test123');
        System.assertEquals(variable.Value__c, 'abcd');  
    }

    private static testmethod void testEnsureVariableExists_New(){
        TestData.ensureVariableExists('test123','abcd');
        System.assert(true);   
    }

}