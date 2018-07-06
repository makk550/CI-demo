/**
* @author Umang Modi
* @date 06/22/2017
*
* @description created to Copy the Agreement POB records from Parent to Child Agreement and Related to current Agreement Record.
*/
public class CA_AgreementPOBUtility {

	/*******************************************************************************************************
	* @description Inserts Agreement POB records from Source to Destination
	* @param Apttus__APTS_Agreement__c new
	* @param Apttus__APTS_Agreement__c old
	* @return 
	* 
	*/
	public static void prepareAndInsertAgreementPOBs(Apttus__APTS_Agreement__c newAgreementSO, Apttus__APTS_Agreement__c oldAgreementSO) {
		List<Agreement_POB__c> lstSourceAgmtPOBList= new List<Agreement_POB__c>();
		List<Agreement_POB__c> lstNewAgmtPOBList = new List<Agreement_POB__c>();
		List<Id> lstParentRelatedAgmtIdList = new List<id>();
		List<String> lstFieldNameList;
		String strPOBName;
		Boolean isParent;

		lstFieldNameList = checkandGetUpdatedFieldList(newAgreementSO, oldAgreementSO);
		system.debug('lstFieldNameList in the for loop is:'+lstFieldNameList.size());
		for (String strFieldName:lstFieldNameList) {
			if(strFieldName.equals('Apttus__Parent_Agreement__c') && newAgreementSO.Apttus__Parent_Agreement__c != null) {
				lstParentRelatedAgmtIdList.add(newAgreementSO.Apttus__Parent_Agreement__c);
			}
			if(strFieldName.equals('CA_RelatedAgreement1__c') && newAgreementSO.CA_RelatedAgreement1__c != null) {
				lstParentRelatedAgmtIdList.add(newAgreementSO.CA_RelatedAgreement1__c);
			}
			if(strFieldName.equals('CA_RelatedAgreement2__c') && newAgreementSO.CA_RelatedAgreement2__c != null) {
				lstParentRelatedAgmtIdList.add(newAgreementSO.CA_RelatedAgreement2__c);
			}
			if(strFieldName.equals('CA_RelatedAgreement3__c') && newAgreementSO.CA_RelatedAgreement3__c != null) {
				lstParentRelatedAgmtIdList.add(newAgreementSO.CA_RelatedAgreement3__c);
			}
			if(strFieldName.equals('CA_RelatedAgreement4__c') && newAgreementSO.CA_RelatedAgreement4__c != null) {
				lstParentRelatedAgmtIdList.add(newAgreementSO.CA_RelatedAgreement4__c);
			}
		}
		system.debug('lstParentRelatedAgmtIdList is :::'+lstParentRelatedAgmtIdList);
		if (!lstParentRelatedAgmtIdList.isEmpty()) 
			lstSourceAgmtPOBList = getSourceAgreementPOBRecords(lstParentRelatedAgmtIdList, newAgreementSO);
			system.debug('lstSourceAgmtPOBList size before for loop is::'+lstSourceAgmtPOBList.size());
		for(Agreement_POB__c parentPOBSO : lstSourceAgmtPOBList) {
			//strPOBName = parentPOBSO.Agreement__r.name + ' - '+ parentPOBSO.name;
            strPOBName = parentPOBSO.name; //Modified per request
			if (newAgreementSO.Apttus__Parent_Agreement__c == parentPOBSO.Agreement__c)
				isParent = true;
			else
				isParent = false;
			lstNewAgmtPOBList.add(getNewAgreementPOBSObject(newAgreementSO, parentPOBSO, strPOBName, isParent));
		}
		try {
			system.debug('lstNewAgmtPOBList size is ::'+lstNewAgmtPOBList.size());
			if(!lstNewAgmtPOBList.isEmpty()) {
				insert lstNewAgmtPOBList;
			}
		} Catch(Exception e) {
			e.getMessage();
		}

		//Delete Agreement POB copied from Parent/Related Agreement if association is removed.
		/*
		if (lstFieldNameList.size() > lstParentRelatedAgmtIdList.size()) {

		}*/
	}

	/*******************************************************************************************************
	* @description  Check for updates in Parent or Related Agreement fields.
	*			    Here the return Map would contain Agreement Id for which either Parent Agreement or
	*				any of the 4 related Agreement fields are updated. hence the return List with Api name of Agreement fields which are updated.
	* @param Apttus__APTS_Agreement__c
	* @param Apttus__APTS_Agreement__c
	* @return List<String>
	* 
	*/
	public static List<String> checkandGetUpdatedFieldList(Apttus__APTS_Agreement__c newAgmtSO, Apttus__APTS_Agreement__c oldAgmtSO) {
		system.debug('Inside the checkandGetUpdatedFieldList method::');
		List<String> lstFieldNameList = new List<String>();

		//if (!newAgmtSO.Apttus__IsLocked__c) {
			if (oldAgmtSO.Apttus__Parent_Agreement__c != newAgmtSO.Apttus__Parent_Agreement__c) {
				lstFieldNameList.add('Apttus__Parent_Agreement__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement1__c != newAgmtSO.CA_RelatedAgreement1__c) {
				lstFieldNameList.add('CA_RelatedAgreement1__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement2__c != newAgmtSO.CA_RelatedAgreement2__c) {
				lstFieldNameList.add('CA_RelatedAgreement2__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement3__c != newAgmtSO.CA_RelatedAgreement3__c) {
				lstFieldNameList.add('CA_RelatedAgreement3__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement4__c != newAgmtSO.CA_RelatedAgreement4__c) {
				lstFieldNameList.add('CA_RelatedAgreement4__c');
			}
		//}
		
		system.debug('Exiting the checkandGetUpdatedFieldList method lstFieldNameList is ::'+lstFieldNameList);
		return lstFieldNameList;
	}

	/*******************************************************************************************************
	* @description Returns New Agreement POB sObject from Source to Destination. Here isParent flag decides
					whether the Record is created from Parent or Related Agreement
	* @param Apttus__APTS_Agreement__c
	* @param Agreement_POB__c
	* @param String
	* @param Boolean
	* @return 
	* 
	*/
	public static Agreement_POB__c getNewAgreementPOBSObject(Apttus__APTS_Agreement__c childAgmtSO, Agreement_POB__c parentPOBSO, String strPOBName, Boolean isParent) {

		Id recordTypeId = Schema.SObjectType.Agreement_POB__c.getRecordTypeInfosByName().get('New Record Type').getRecordTypeId();
		Agreement_POB__c newPOBSO = new Agreement_POB__c();
		newPOBSO.Agreement__c = childAgmtSO.id; // update the Associated Agreement 
		newPOBSO.name = strPOBName; //Updated this as per requirement
		newPOBSO.RecordTypeId  = recordTypeId; //Creating with New Record Type
		if(isParent) {
			newPOBSO.Parent_Agreement_POB__c = parentPOBSO.Id;
		} else {
			newPOBSO.Related_Agreement_POB__c = parentPOBSO.Id;
		}
		newPOBSO.CommentsLong__c = parentPOBSO.CommentsLong__c;
		newPOBSO.Credit_Amount__c = parentPOBSO.Credit_Amount__c;
		newPOBSO.Credit_Amount_Percent__c = parentPOBSO.Credit_Amount_Percent__c;
        //for fy19 bringing
         newPOBSO.POB_modified__c = parentPOBSO.POB_modified__c;
        //for US444816
        newPOBSO.Effective_Date__c = parentPOBSO.Effective_Date__c;
		newPOBSO.Expiration_Date__c = parentPOBSO.Expiration_Date__c;
		newPOBSO.From_Master__c = True; //True
		newPOBSO.POB_Category__c = parentPOBSO.POB_Category__c;
		newPOBSO.Product_Type__c = parentPOBSO.Product_Type__c;
		newPOBSO.Perpetual__c = parentPOBSO.Perpetual__c;
		newPOBSO.Status__c = parentPOBSO.Status__c;
		return newPOBSO;
	}

	/*******************************************************************************************************
	* @description get all the Agreement POB records with provided list of Parent/Related Agreements
	* @param List<Apttus__APTS_Agreement__c>
	* @param Apttus__APTS_Agreement__c
	* @return List<Agreement_POB__c>
	* 
	*/
	public static List<Agreement_POB__c> getSourceAgreementPOBRecords(List<Id> lstParentRelatedAgmtIdList,Apttus__APTS_Agreement__c childAgmtSO) {
		List<Agreement_POB__c> lstAgreementPOBList = new List<Agreement_POB__c>();
		List<Agreement_POB__c> lstTempPOBList = new List<Agreement_POB__c>();
		List<Agreement_POB__c> lstExistingPOBList;
		Set<Agreement_POB__c> finalAgreementPOBSet = new Set<Agreement_POB__c>();
		Set<Id> parentRelatedAgmtIdSet = new Set<Id>();
		Boolean isDuplicate = false;

		parentRelatedAgmtIdSet.addAll(lstParentRelatedAgmtIdList);
		lstParentRelatedAgmtIdList.addAll(parentRelatedAgmtIdSet);// remove duplicate Agreement Ids

		DescribeSObjectResult describeResult = Agreement_POB__c.getSObjectType().getDescribe();
		List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
		String query =
		  ' SELECT ' +
			  String.join( fieldNames, ',' ) + ', Agreement__r.name ' +
		  ' FROM ' +
			  describeResult.getName() +
		  ' WHERE ' +
			  ' Agreement__c in :lstParentRelatedAgmtIdList ';

		lstTempPOBList = Database.query( query );
		System.debug('POB List size in lstTempPOBList is:'+lstTempPOBList.size());

		//Check if Any Agreement POB either as Parent or related record exist. If yes then ignore from List.
		if(!lstTempPOBList.isEmpty()) {
			finalAgreementPOBSet.addAll(lstTempPOBList);
			if (childAgmtSO.CA_POB_Count__c > 0) {
				lstExistingPOBList = [SELECT id, parent_agreement_pob__c, related_agreement_pob__c FROM Agreement_POB__c WHERE  Agreement__c = :childAgmtSO.id];
				for (Agreement_POB__c childAgmtPOBSO : lstExistingPOBList) {
					for (Agreement_POB__c parentAgmtPOBSO : lstTempPOBList) {
						if ((childAgmtPOBSO.parent_agreement_pob__c != null && childAgmtPOBSO.parent_agreement_pob__c == parentAgmtPOBSO.id) ||
							 (childAgmtPOBSO.related_agreement_pob__c != null && childAgmtPOBSO.related_agreement_pob__c == parentAgmtPOBSO.id)) {
							System.debug('duplicate Agreement POB record found on the Child Agreement');
							finalAgreementPOBSet.remove(parentAgmtPOBSO);
						}
					}
				}
			}
		}
		if (!finalAgreementPOBSet.isEmpty())
			lstAgreementPOBList.addAll(finalAgreementPOBSet);
		
		return lstAgreementPOBList;
	}

	/*******************************************************************************************************
	* @description  Check for updates in Parent or Related Agreement fields and return the list of deleted fields
	* @param Apttus__APTS_Agreement__c
	* @param Apttus__APTS_Agreement__c
	* @return List<Agreement_POB__c>
	* 
	*/
	/*
	public static List<Agreement_POB__c> checkandGetAgreementPOBToBeDeleted(Apttus__APTS_Agreement__c newAgmtSO, Apttus__APTS_Agreement__c oldAgmtSO) {
		system.debug('Inside the checkandGetAgreementPOBToBeDeleted method::');
		List<Agreement_POB__c> lstFieldNameList = new List<Agreement_POB__c>();
		List<Id> lstAgreementIdList = new List<Id>();

		if (!newAgmtSO.Apttus__IsLocked__c) {
			if (oldAgmtSO.Apttus__Parent_Agreement__c != newAgmtSO.Apttus__Parent_Agreement__c && newAgmtSO.Apttus__Parent_Agreement__c == null) {
				lstAgreementIdList.add();
			}
			if (oldAgmtSO.CA_RelatedAgreement1__c != newAgmtSO.CA_RelatedAgreement1__c && newAgmtSO.CA_RelatedAgreement1__c == null) {
				lstAgreementIdList.add('CA_RelatedAgreement1__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement2__c != newAgmtSO.CA_RelatedAgreement2__c && newAgmtSO.CA_RelatedAgreement2__c == null) {
				lstAgreementIdList.add('CA_RelatedAgreement2__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement3__c != newAgmtSO.CA_RelatedAgreement3__c && newAgmtSO.CA_RelatedAgreement3__c == null) {
				lstAgreementIdList.add('CA_RelatedAgreement3__c');
			}
			if (oldAgmtSO.CA_RelatedAgreement4__c != newAgmtSO.CA_RelatedAgreement4__c && newAgmtSO.CA_RelatedAgreement4__c == null) {
				lstAgreementIdList.add('CA_RelatedAgreement4__c');
			}
		}
		
		system.debug('Exiting the checkandGetAgreementPOBToBeDeleted method lstFieldNameList is ::'+lstFieldNameList);
		return lstFieldNameList;
	}*/
}