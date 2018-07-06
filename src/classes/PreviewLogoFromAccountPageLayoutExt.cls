public class PreviewLogoFromAccountPageLayoutExt extends PartnerFinderBaseController {
	 
	public static String NO_RECORD_ERROR {get{return 'NO_RECORD_ERROR';}}
	public String error{get;private set;}
	public Boolean errorOccurred{get{return StringUtils.isNotBlank(error);}}

	private SObject record;
	public ID logoRecordID {get;private set;}
	public ID logoAttachmentID {get;private set;}
		
	public PreviewLogoFromAccountPageLayoutExt(ApexPages.StandardController controller){
		this.record = controller.getRecord();
	}

	public PageReference doOnLoad(){
		if(record == null || !(record instanceof Account)){
			error = NO_RECORD_ERROR;
		} else {
			try{
				logoRecordID = ((Account) record).Logo__c;
				Attachment logoBlob = [select id from Attachment where parentid = :logoRecordID];
				logoAttachmentID = logoBlob.id;
			}catch(QueryException e){
				error = NO_RECORD_ERROR;
			}
		}
		return null;
		
	}
}