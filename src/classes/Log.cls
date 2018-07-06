public class Log {
  public static void debug(Object obj) {
    System.debug(LoggingLevel.DEBUG, obj);
  }
  public static void debug(String template, String[] args) {
    log.debug(String.format(template, args));
  }
  public static void info(Object obj) {
    System.debug(LoggingLevel.INFO, obj);
  }
  public static void info(String template, String[] args) {
    log.info(String.format(template, args));
  }
  public static void warn(Object obj) {
    System.debug(LoggingLevel.WARN, obj);
  }
  public static void warn(String template, String[] args) {
    log.warn(String.format(template, args));
  }
  public static void error(Object obj) {
    System.debug(LoggingLevel.ERROR, obj);
  }
  public static void error(String template, String[] args) {
    log.error(String.format(template, args));
  }

  public static void limits() {
    log.info('========= Log Limits =========');
    logLimit(Limits.getQueries(), Limits.getLimitQueries(), 'SOQL queries');
    logLimit(Limits.getQueryRows(), Limits.getLimitQueryRows(), 'query rows');
    logLimit(Limits.getDmlStatements(), Limits.getLimitDmlStatements(), 'DML statements');
    logLimit(Limits.getDMLRows(), Limits.getLimitDMLRows(), 'DML rows');
    log.info('==============================');
  }

  public static void startTrigger(String name) {
    if (trigger.isExecuting) {
      String beforeOrAfter = trigger.isBefore ? 'Before' : 'After';
      String action = trigger.isInsert ? 'Insert' : (trigger.isUpdate ? 'Update' : (trigger.isDelete ? 'Delete' : 'Undelete'));
      String ids = trigger.newMap != null && trigger.newMap.size() > 0 ? '['+String.join(new List<Id>(trigger.newMap.keySet()), ',')+']' : '[' + trigger.new.size() + ' new records]';
      log.info('Entering trigger {0} - {1} {2} - {3}', new String[]{name, beforeOrAfter, action, ids});
    }
  }

  private static void logLimit(Integer actual, Integer max, String type) {
    Integer percent = (Integer)(Decimal.valueOf(actual).divide(Decimal.valueOf(max), 2) * 100);
    log.info('Number of {0}: {1} out of {2} ({3}%)', new String[]{type, String.valueOf(actual), String.valueOf(max), String.valueOf(percent)});
  } 
}