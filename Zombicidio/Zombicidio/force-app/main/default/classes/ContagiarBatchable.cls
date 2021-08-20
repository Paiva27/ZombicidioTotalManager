public with sharing class ContagiarBatchable implements Database.Batchable<SObject>{
    public ContagiarBatchable() {

    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQuerylOCATOR('SELECT id, Criatura__c.RecordTypeId,bunker__r,Bunker__c, (select id, Dano__c from RecursosCriatura__r) FROM Criatura__c)');
    }

    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<Criatura__c> hmn = preencheListaCriaturaRecordType('0125e000000NRWdAAO',List<Criatura__c> humano);
        List<Criatura__c> zb = preencheListaCriaturaRecordType('0125e000000NRWnAAO',);
    }

    private List<Criatura__c> preencheListaCriaturaRecordType(id RecordType, List<Criatura__c> listaP){
        List<Criatura__c> cri = new List<Criatura__c>();
        for(Criatura__c crip : listaP){
            if(crip.RecordTypeId == RecordType) cri.add(crip);
        }
        return cri;
    }

    public void finish(Database.BatchableContext BC){

    }
}