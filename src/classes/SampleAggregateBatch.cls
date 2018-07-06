global class SampleAggregateBatch implements Database.Batchable<AggregateResult> {
  // The batch job starts
  global Iterable<AggregateResult> start(Database.BatchableContext bc){
       System.debug('In start');
    String query = 'SELECT COUNT(Id) cnt, AccountId FROM Contact GROUP BY AccountId';
    return new AggregateResultIterable(query);
  } 
  // The batch job executes and operates on one batch of records
  global void execute(Database.BatchableContext bc, List<sObject> scope){ 
      System.debug('In execute');
    for(sObject sObj : scope) {
      AggregateResult ar = (AggregateResult)sObj;
      System.debug('>>>> COUNT : ' + ar.get('cnt'));
    }
  }
  // The batch job finishes
  global void finish(Database.BatchableContext bc){ }
}