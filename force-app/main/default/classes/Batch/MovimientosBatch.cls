global class MovimientosBatch implements Database.Batchable<Integer>, Database.StateFul, Database.AllowsCallouts {
	
    List<Movimiento__c> movimientos = new List<Movimiento__c>();
    
    global Iterable<Integer> start(Database.BatchableContext bc){
        //Creando una lista para almacenar los identificadores de Movimientos
        List<Integer> movIds = new List<Integer>();
        //Se itera hasta 826 para obtener los movimientos pedidos
        for (Integer i = 1; i <= 826; i++) {
            //Agrego el numero de iteracion a la lista de identificadores
            movIds.add(i);
        }
        return movIds;
    }
    
    global void execute(Database.BatchableContext bc, List<Integer> movIds){
        
        for(Integer id : movIds){
            Movimiento__c movimiento = new Movimiento__c();
            //Llamada tipo GET a la PokeAPI para el movimiento segun su id
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/move/' + id);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                //Deserealiza el JSON para obtener nombre,punteria,chance de efecto,prioridad,poder,pp y id
                movimiento.Name = ((String)results.get('name')).capitalize();
                movimiento.Punteria__c = (Integer)results.get('accuracy');
                movimiento.Chance_de_Efecto__c = (Integer)results.get('effect_chance');
                movimiento.Prioridad__c = (Integer)results.get('priority');
                movimiento.Poder__c = (Integer)results.get('power');
                movimiento.Pp__c = (Integer)results.get('pp');
                movimiento.ExtId__c = (Integer)results.get('id');

                //Mapa de type para obtener el tipo de movimiento
                Map<String,Object> type = (Map<String,Object>)results.get('type');
                movimiento.Tipo__c = (String) type.get('name');
                
                //Mapa de target para obtener el objetivo
                Map<String,Object> target = (Map<String,Object>)results.get('target');
                movimiento.Objetivo__c = (String) target.get('name');

                //Lista de efectos 
                List<Object> effect_entries = (List<Object>) results.get('effect_entries');
                for(Object entry : effect_entries){
                    //Se itera sobre cada elemento de la lista de efectos y se almacena en entryMap de tipo Mapa
                    Map<String,Object> entryMap = (Map<String,Object>)entry;
                    //Se almacena el nombre de short effect 
                    movimiento.Efecto__c = (String) entryMap.get('short_effect');
                }
                }else{
                    throw new CalloutException('Error ' + response.getBody());
                }
            //Luego de almacenar la informacion del movimiento, se agrega a la lista "movimientos"    
            movimientos.add(movimiento);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        insert movimientos;
    }
}