public class Zumbificacao {

    @InvocableMethod (label='Transofrma Zumbi')
    public static void zumbificar(List<id> ids){
        List<Criatura__c> criList = [SELECT id, bunker__r.name, bunker__c, (SELECT id FROM RecursosCriatura__r) FROM Criatura__c WHERE id in :ids];
        String tipoZumbi = '';
        integer random;
        List<RecursoCriatura__C> rcDeleteList = new List<RecursoCriatura__C>() ;
        for(Criatura__c cr : criList){ //para cada criatura da lista de criaturas faz :
        	random = Math.mod(Integer.valueof(Math.random()*100000),100);
            if(random < 89){//O zumbi tem 90% chance de ser criado como um zumbi lerdo
                tipoZumbi = 'Lerdo';
            }
            else if(random < 98){//O zumbi tem 9% de chance de ser criado como um zumbi gordo
                tipoZumbi = 'Gordo';
            }else{//O zumbi tem 1% de chance de ser criado como um zumbi abominação
                tipoZumbi = 'Abominação'; 
            }
            cr.tipoZumbi__c = tipoZumbi; //Adiciona o tipo de zumbi gerado aleatóriamente
            if(cr.RecursosCriatura__r != null){
                rcDeleteList.addAll(cr.RecursosCriatura__r); //Deleta todos os recursos que a criatura possuia
            }    
        	}
        update criList;
        delete rcDeleteList;
        } 
}