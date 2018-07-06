global class PartnerSearchResultSortByDistComparator implements ObjectComparator{

	global Integer compare(Object object1, Object object2){
		if(object1==null || !(object1 instanceof PartnerSearchResult)
		&& object2==null || !(object2 instanceof PartnerSearchResult)){
			throw new IllegalArgumentException();
		}
		Double r1 = ((PartnerSearchResult)object1).distance;
		Double r2 = ((PartnerSearchResult)object2).distance;
		if(r1 < r2){
			return -1;
		} else if(r1 == r2){
			return 0;
		}else{
			return 1;
		}
	}

}