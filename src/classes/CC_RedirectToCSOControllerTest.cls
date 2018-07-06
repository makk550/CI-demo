@IsTest
public class CC_RedirectToCSOControllerTest {
  @IsTest
  static void it_should_parse_cso_url() {
    System.assert(CC_Settings.csoUrl.startsWith(CC_RedirectToCSOController.csoBaseUrl));
  }
}