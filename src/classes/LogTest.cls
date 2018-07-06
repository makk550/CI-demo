@IsTest
public class LogTest {

  @IsTest
  static void test_all_logging() {
    log.debug(new Account());
    log.debug('Test {0}', new String[]{'args'});
    log.info(new Contact());
    log.info('Test {0}', new String[]{'args'});
    log.warn('some text');
    log.warn('Test {0}', new String[]{'args'});
    try {
      insert new Contact();
    } catch (Exception ex) {
      log.error(ex);
      log.error('Test {0}', new String[]{'args'});
    }
    log.limits();
    log.startTrigger('test');
  }

  @IsTest
  static void test_log_limits() {
    CC_TestUtils.setupTestDataToInsertCase();
    log.limits();
    Contact c = new Contact(LastName='Butt', Email='butgr02@ca.com');
    insert c;
    log.limits();
    Case newCase = CC_TestUtils.buildCase(c.Id, 'Open');
    insert newCase;
    log.limits();
  }

}