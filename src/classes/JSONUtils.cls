global class JSONUtils {
	
	global static String encode(String str){
		return (str == null) ? 'null' : '"' + 
			StringUtils.replaceEach(str,new String[]{
					'"'
					,'\\'
					,'\n'
					,'\t'
					,'\f'
					,'\r'
					,'/'
			},new String[]{
					'\\"'
					,'\\\\'
					,'\\n'
					,'\\t'
					,'\\f'
					,'\\r'
					,'\\/'
			}) 
			+ '"';
	}
	
}