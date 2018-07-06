public class QueryCriteria {
	public String fieldName;
	public String operator;
	public Object value;

	// constructor
    public QueryCriteria (String fieldName, Object value) {
    	this(fieldName,'=',value);
    }

    public QueryCriteria (String fieldName, String operator, Object value) {
        this.fieldName = fieldName;
        this.operator = operator;
        this.value = value;
    }

	
	public static String getWhereClause(Map<String,List<QueryCriteria>> criteriaMap){
		String whereClause = '';
		Integer index=0;
		for(String key:criteriaMap.keySet()){
			String subClause='';
			if('AND'.equalsIgnoreCase(key)){
				subClause=getWhereClause(criteriaMap.get(key),'AND');
			} else if(key.startsWith('OR')){
				subClause=getWhereClause(criteriaMap.get(key),'OR');
				if(StringUtils.isNotEmpty(subClause)){
					subClause= ' ( ' + subClause + ' ) ';
				}
			}
			
			if(StringUtils.isNotEmpty(subClause)){
				if(index==0){
					whereClause = subClause;
				} else {
					whereClause += ' AND ' + subClause;
				}
			}
			
			index++;
		}
		if (whereClause != ''){
			whereClause = ' where ' + whereClause;
		}
		
		return whereClause;
	}
	
	public static String getWhereClause(List<QueryCriteria> criteriaList, String logicalOp /*Either AND or OR*/){
		String whereClause = '';
		
		if(!('AND'.equalsIgnoreCase(logicalOp) || 'OR'.equalsIgnoreCase(logicalOp))){
			return whereClause;
		}
			
		// add each portion of the where clause
		if (criteriaList != null) {
			for (QueryCriteria criteria : criteriaList) {
				if (criteria.value != null) {
					// assuming and in this implementation
					if(StringUtils.isNotEmpty(whereClause)){
						whereClause += ' ' + logicalOp +' ';
					}
					if(criteria.value instanceOf Integer || 
					   criteria.value instanceOf Decimal || 
					   criteria.value instanceOf Double  || 
					   criteria.value instanceOf Boolean ||
					   'includes'.equalsIgnoreCase(criteria.operator)){
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' '+ criteria.value;						
					} else if (criteria.value instanceOf String) {
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' \'' + criteria.value + '\'';
					} else if (criteria.value instanceOf Date) {
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' ' + formatDate((Date) criteria.value, 'yyyy-MM-dd') + '';
					} else if (criteria.value instanceOf Datetime) {
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' ' + ((Datetime) criteria.value).format('yyyy-MM-dd') + 'T' + ((Datetime) criteria.value).format('hh:mm:ss') + 'Z' + '';
					}
				}
			}
		}
		//if (whereClause != ''){
		//	whereClause = ' where ' + whereClause;
		//}
		return whereClause;
	}

	// create where clause
	public static String getWhereClause(List<QueryCriteria> criteriaList) {
		/*String whereClause = '';

		// add each portion of the where clause
		if (criteriaList != null) {
			for (QueryCriteria criteria : criteriaList) {
				if (criteria.value != null) {
					// assuming and in this implementation
					if(StringUtils.isNotEmpty(whereClause)){
						whereClause += ' and ';
					}
					if(criteria.value instanceOf Integer || 
					   criteria.value instanceOf Decimal || 
					   criteria.value instanceOf Double  || 
					   criteria.value instanceOf Boolean ||
					   'includes'.equalsIgnoreCase(criteria.operator)){
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' '+ criteria.value;						
					} else if (criteria.value instanceOf String) {
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' \'' + criteria.value + '\'';
					} else if (criteria.value instanceOf Date) {
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' ' + formatDate((Date) criteria.value, 'yyyy-MM-dd') + '';
					} else if (criteria.value instanceOf Datetime) {
						whereClause += criteria.fieldName + ' ' + criteria.operator + ' ' + ((Datetime) criteria.value).format('yyyy-MM-dd') + 'T' + ((Datetime) criteria.value).format('hh:mm:ss') + 'Z' + '';
					}
				}
			}
		}*/
		String whereClause = getWhereClause(criteriaList, 'AND');
		if (whereClause != ''){
			whereClause = ' where ' + whereClause;
		}
		return whereClause;
	}

	private static String formatDate(Date d, String formatString) {
		Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
		return dt.format(formatString);
	}
}