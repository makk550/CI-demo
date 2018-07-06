public class ContractHandler implements Itrigger {

    public void bulkBefore(){
    	ContractGateway.loadBulkContractValues();
    }
    

    public void bulkAfter(){

    }
    

    public void beforeInsert(SObject so){

    }
    

    public void beforeUpdate(SObject oldSo, SObject so){

    }


    public void beforeDelete(SObject so){

    }


    public void afterInsert(SObject so){

    }


    public void afterUpdate(SObject oldSo, SObject so){

    }


    public void afterDelete(SObject so){

    }

    public void andFinally(){

    }
}