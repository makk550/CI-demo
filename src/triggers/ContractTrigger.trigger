trigger ContractTrigger on Contract (before insert) {
    TriggerFactory.createHandler(Contract.sObjectType);
}