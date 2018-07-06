@IsTest
private class TestQueryCriteria {

	private static testmethod void testOneCriteria(){
		List<QueryCriteria> criteriaList = new List<QueryCriteria>();
		criteriaList.add(new QueryCriteria('email','=','test@acme.com'));
		System.assertEquals('where email = \'test@acme.com\'',StringUtils.trim(QueryCriteria.getWhereClause(criteriaList)));
	}
	
	private static testmethod void testMultipleCriteria(){
		ID idOfCurrentUser = [select id from user where id = :UserInfo.getUserId()].id;
		List<QueryCriteria> criteriaList = new List<QueryCriteria>();
		criteriaList.add(new QueryCriteria('email','=','test@acme.com'));
		criteriaList.add(new QueryCriteria('number','=',1));
		criteriaList.add(new QueryCriteria('date','<',Date.newinstance(1960, 2, 17)));
		criteriaList.add(new QueryCriteria('datetime','>=',Datetime.newInstance(2008, 12, 1)));
		criteriaList.add(new QueryCriteria('userid','!=',idOfCurrentUser));
		System.debug('expected = [' + EncodingUtil.urlEncode('where email = \'test@acme.com\' and number = 1', 'UTF-8'));
		System.debug('actual   = [' + EncodingUtil.urlEncode(StringUtils.trim(QueryCriteria.getWhereClause(criteriaList)), 'UTF-8'));
		System.assertEquals(
			'where email = \'test@acme.com\' AND number = 1'
			+ ' AND date < 1960-02-17'
			+ ' AND datetime >= 2008-12-01T12:00:00Z'
			+ ' AND userid != \'' + idOfCurrentUser + '\''
			,
			StringUtils.trim(QueryCriteria.getWhereClause(criteriaList)));

	}
	
	private static testmethod void testMultipleOrCriteria(){
		ID idOfCurrentUser = [select id from user where id = :UserInfo.getUserId()].id;
		List<QueryCriteria> criteriaListAnd = new List<QueryCriteria>();
		criteriaListAnd.add(new QueryCriteria('email','=','test@acme.com'));
		criteriaListAnd.add(new QueryCriteria('number','=',1));
		Map<String,List<QueryCriteria>> criteriaMap=new Map<String,List<QueryCriteria>>{'AND'=>criteriaListAnd};
		QueryCriteria.getWhereClause(criteriaMap);
		System.debug(StringUtils.trim(QueryCriteria.getWhereClause(criteriaMap)));
				System.assertEquals(
			'where email = \'test@acme.com\' AND number = 1',
			StringUtils.trim(QueryCriteria.getWhereClause(criteriaMap)));
	}
	
	private static testmethod void testIncorrectOp(){
		System.assertEquals('',QueryCriteria.getWhereClause(new List<QueryCriteria>(),'WrongOp'));
	}
	
	

}