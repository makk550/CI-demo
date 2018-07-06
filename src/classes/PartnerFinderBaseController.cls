public abstract class PartnerFinderBaseController extends StickyParametersController {

	public static final String HTTP_LANGUAGE_CODE_PARAMETER_KEY = 'l';

	public PartnerFinderBaseController(){
		super(new String[]{HTTP_LANGUAGE_CODE_PARAMETER_KEY});
	}
	
	public String getPreferredLanguageCode(){
		return LanguageUtils.getLangCodeByHttpParamOrIfNullThenUser();
	}
 

}