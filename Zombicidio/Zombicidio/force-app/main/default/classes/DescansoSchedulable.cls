global class DescansoSchedulable  implements Schedulable {
global void execute(SchedulableContext SC) {
      this.descansar();
   }

    private void descansar(){
        List<Criatura__c> humanList = [SELECT Stamina__C FROM Criatura__c where recordtypeId = '0125e000000NRWdAAO'];
        for (Criatura__c hmn : humanList ){
            hmn.Stamina__C = 'Descansado';
        }
        update humanList;
	}
}