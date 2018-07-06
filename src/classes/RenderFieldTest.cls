@IsTest
private class RenderFieldTest {
    
    private static testmethod void testTranslatePicklistValue_Multipicklist(){
        final String result = RenderField.translatePicklistValue(
            'abc;xyz',
            new Map<String,String>{'abc'=>'123','xyz'=>'456'},
            true);
        System.assertNotEquals(null, result);            
        System.assertEquals('123;456', result);            
    }

    private static testmethod void testTranslatePicklistValue_Singlepicklist1(){
        final String result = RenderField.translatePicklistValue(
            'abc',
            new Map<String,String>{'abc'=>'123','xzy'=>'456'},
            false);
        System.assertNotEquals(null, result);            
        System.assertEquals('123', result);            
    }

    private static testmethod void testTranslatePicklistValue_Singlepicklist2(){
        final String result = RenderField.translatePicklistValue(
            'abc;xyz',
            new Map<String,String>{'abc'=>'123','xzy'=>'456'},
            false);
        System.assertNotEquals(null, result);            
        System.assertEquals('abc;xyz', result);            
    }
    
    private static testmethod void testCreate(){
    	final RenderField field = new RenderField(
    	   'Account',
    	   Account.Profile_Published_to_Partner_Finder__c.getDescribe());
    	final Map<String,String> valuesToLabels = field.pickListValuesValueToLabelMap;
        System.assertNotEquals(null,valuesToLabels);
        System.assert(valuesToLabels.size()>0);
    }
    
    
}