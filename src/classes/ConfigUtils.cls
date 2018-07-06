public class ConfigUtils {

	public static String getVariable(String key){
		Configuration_Variable__c var = null;
		try{
			var = [select name,value__c from Configuration_Variable__c where name = :key limit 1];
		}catch(QueryException e){}
		if(var == null){
			return null;
		}
		return var.value__c;
	}
		
}