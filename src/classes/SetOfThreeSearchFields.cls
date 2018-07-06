public class SetOfThreeSearchFields {

    public SearchField field1{get; set;}
    public SearchField field2{get; set;}
    public SearchField field3{get; set;}
    
    public static List<SetOfThreeSearchFields> createFromList(List<SearchField> fields){
        final List<SetOfThreeSearchFields> returnValue = new List<SetOfThreeSearchFields>();
        if(fields != null && fields.size() > 0){
	        final Integer rowCount = Math.ceil(fields.size() / 3.0).intValue();
	        for(Integer i = 0; i < rowCount; i++){
	            SetOfThreeSearchFields theSet = new SetOfThreeSearchFields();
	            returnValue.add(theSet);
	            theSet.field1=fields[i*3];
	            if(i==(rowCount-1)){
	                if((i*3) + 1 >= fields.size()){
	                    break;
	                } else {
	                    theSet.field2=fields[i*3+1];
	                    if(((i*3) + 2 >= fields.size())){
	                        break;
	                    } else {
	                        theSet.field3=fields[i*3+2];
	                    }
	                }
	            } else {
	                theSet.field2=fields[(i*3) + 1];
	                theSet.field3=fields[(i*3) + 2];
	            }
	        }
        	
        }
        return returnValue;
    }
}