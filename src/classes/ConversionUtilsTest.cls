@IsTest
private class ConversionUtilsTest {

    private static testmethod void testNullsParams(){
        System.assertEquals(0,ConversionUtils.convert(null,null,null));  
    }
    
    private static testmethod void testConvert(){
        assertEqualsRounded(100,ConversionUtils.convert(100,UnitOfLength.KILOMETERS,UnitOfLength.KILOMETERS),5);  
        assertEqualsRounded(100,ConversionUtils.convert(100,UnitOfLength.MILES,UnitOfLength.MILES),5);  
        assertEqualsRounded(100/ConversionUtils.KILOMETERS_IN_ONE_MILE,
            ConversionUtils.convert(100,UnitOfLength.KILOMETERS,UnitOfLength.MILES),5);  
        assertEqualsRounded(100*ConversionUtils.KILOMETERS_IN_ONE_MILE,
            ConversionUtils.convert(100,UnitOfLength.MILES,UnitOfLength.KILOMETERS),5);  
    }
    
    private static void assertEqualsRounded(Double expected, Double actual, Integer decimalPlaces){
        System.assertEquals(round(expected,decimalPlaces),round(actual,decimalPlaces));
    }
    
    private static Double round(Double d, Integer decimalPlaces){
        if(decimalPlaces >= 0){
            d = Decimal.valueOf(d).setScale(decimalPlaces).doubleValue();
        }
        System.assert(true);
        return d;
    }
    
}