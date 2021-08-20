global class ContagionSchedulable implements Schedulable {
    global void execute(SchedulableContext SC) {
      this.contagiar(); 
   }
    //Humano virou zumbi e o zumbi infectou um humano
    private void zumbificar(Criatura__c hmn, Criatura__c zb){
        
            hmn.recordtypeId = '0125e000000NRWnAAO'; //Humano fica infectado e vira um zumbi
            hmn.DataZumbificacao__c = Date.today(); //Data que virou zumbi é o dia de hj
            hmn.HumanosMatados__c = 0; //Ele ainda é um zumbi inocente que não matou nenhum humano

            zb.HumanosMatados__c += 1;  //Aumenta o score de humanos matados para o zumbi que infectou esse humano 
           
    }
    //Qualquer condição de se um humano é infectado ou zumbi morre é decidida nessa função
    private void encontro(Criatura__c hmn, Criatura__c zb){
        decimal dano = 0;
        if (hmn.RecursosCriatura__r != null){
            for(recursoCriatura__c recCri : hmn.RecursosCriatura__r){
                if ( recCri.Dano__C > dano ) dano = recCri.Dano__C;
            }
        }
        if (hmn.RecordTypeId == '0125e000000NRWdAAO' ){
            if (hmn.Bunker__c != Null){
                    //Caso um humano esteja num bunker, ele está seguro de zumbis.
                }else{
                    integer random = Math.mod(Integer.valueof(Math.random()*100000),100);                
                    switch on zb.TipoZumbi__c {
                        when 'Lerdo' {//Se o zumbi for do tipo Lerdo
                            if(random < 60 && hmn.Stamina__C == 'Descansado' ){ //Chance de fugir
                                hmn.Stamina__C = 'Cansado'; //Depois de fugir de um zumbi o humano fica cansado
                            }else{ //Embate:
                                random = Math.mod(Integer.valueof(Math.random()*100000),100);
                                if (dano == 1){
                                    if (random > 50){
                                        zb.TipoZumbi__c = 'Morto';
                                    }else{
                                        this.zumbificar(hmn,zb);
                                    }
                                }else if(dano > 1){
                                    zb.TipoZumbi__c = 'Morto';
                                }else{
                                    this.zumbificar(hmn,zb);
                                }      
                            } 
                        }   
                        when 'Rápido' {//Se o zumbi for do tipo Rápido
                            if(random < 10 && hmn.Stamina__C == 'Descansado' ){ //Chance de fugir
                                hmn.Stamina__C = 'Cansado'; //Depois de fugir de um zumbi o humano fica cansado
                            }else{ //Embate:
                               this.zumbificar(hmn,zb);
                            } 
                        }
                        when 'Gordo' {//Se o zumbi for do tipo Gordo
                            if(random < 30 && hmn.Stamina__C == 'Descansado' ){ //Chance de fugir
                                hmn.Stamina__C = 'Cansado'; //Depois de fugir de um zumbi o humano fica cansado
                            }else{ //Embate:
                               this.zumbificar(hmn,zb);
                            } 
                        }
                        when else {//Se o zumbi for do tipo Aberração
                            //Embate:
                               this.zumbificar(hmn,zb);
                            } 
                        }
                    }
        }else{
           // essa criatura já é zumbi :d
        }
    }
    
    
    private void contagiar(){
        List<Criatura__c> humanList = [SELECT id, Bunker__c,RecordTypeId,Stamina__C,(SELECT id,Dano__c FROM RecursosCriatura__r) FROM Criatura__c where recordtypeId = '0125e000000NRWdAAO'];
        List<Criatura__c> zombieList = [SELECT id, HumanosMatados__c,tipoZumbi__c FROM Criatura__c where recordtypeId <> '0125e000000NRWdAAO'];
        for(Criatura__c zb : zombieList){ //para cada zumbi na lista de zumbis faz :
            if(zb.tipoZumbi__c == 'Morto') break; //Se o zumbi estiver morto, ele não pode atacar, então sai do loop
            if(humanList.size() ==0) break; //Se não existirem humanos, não tem quem infectar, então sai do loop
            
            Criatura__c hmn1 = humanList.get(Math.mod(Integer.valueOf(Math.random()*1000), humanList.size())); //Seleciona um humano aleatório    
            this.encontro(hmn1,zb);

            if(humanList.size() ==0) break; //Se não existirem humanos, não tem quem infectar, então sai do loop
            
            Criatura__c hmn2 = humanList.get(Math.mod(Integer.valueOf(Math.random()*1000), humanList.size()));
            this.encontro(hmn2,zb);
        }
        update zombieList; 
        update humanList;
    }
}