public class CC_RedirectToCSOController {
    public static String csoBaseUrl {
        get { 
        	if (csoBaseUrl == null) {
        		Url csoUrl = new Url(CC_Settings.csoUrl);
        		csoBaseUrl = csoUrl.getProtocol() + '://' + csoUrl.getHost();
        	}
        	return csoBaseUrl;
        }
    }

}