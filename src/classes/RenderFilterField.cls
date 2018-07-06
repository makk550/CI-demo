public class RenderFilterField {
	public RenderField filterField1{get; set;}
	public RenderField filterField2{get; set;}
	public RenderField filterField3{get; set;}
	
	public static List<RenderFilterField> putFilterFieldList(List<RenderField> renderFields){
		List<RenderFilterField> fields = new List<RenderFilterField>();
		Integer rowCount = Math.ceil(renderFields.size() / 3.0).intValue();
		//PageUtils.addInfo('Filter Size :' + renderFields.size() );
		for(Integer i=0;i<rowCount;i++){
			RenderFilterField field = new RenderFilterField();
			fields.add(field);
			field.filterField1=renderFields[i*3];
			if(i==(rowCount-1)){
				if((i*3) + 1 >= renderFields.size()){
					break;
				} else {
					field.filterField2=renderFields[i*3+1];
					if(((i*3) + 2 >= renderFields.size())){
						break;
					} else {
						field.filterField3=renderFields[i*3+2];
					}
				}
			} else {
				field.filterField2=renderFields[(i*3) + 1];
				field.filterField3=renderFields[(i*3) + 2];
			}
		}
		return fields;
	}
}