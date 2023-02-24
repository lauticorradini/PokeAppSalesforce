global class HabilidadesBatch implements Database.Batchable<Integer>, Database.StateFul, Database.AllowsCallouts {
    
    List<Habilidad__c> habilidades = new List<Habilidad__c>();
    
    global Iterable<Integer> start(Database.BatchableContext bc){
        //Creando una lista para almacenar los identificadores de Habilidades
        List<Integer> habIds = new List<Integer>();
        //Se itera hasta 267 para obtener las habilidades pedidas
        for (Integer i = 1; i <= 267; i++) {
            //Agrego el numero de iteracion a la lista de identificadores
            habIds.add(i);
        }
        return habIds;
    }
    
    global void execute(Database.BatchableContext bc, List<Integer> habIds){
        for(Integer id : habIds){
            Habilidad__c habilidad = new Habilidad__c();
            //Llamada tipo GET a la PokeAPI para la habilidad segun su id
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/ability/' + id);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');

            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                //Se almacena el nombre con la primera letra capitalizada y el id de la habilidad
                habilidad.Name = ((String)results.get('name')).capitalize();
                habilidad.ExtId__c = (Integer)results.get('id');

                // Obtener la lista de effect entries de la habilidad
                List<Object> effect_entries = (List<Object>) results.get('effect_entries');
                for(Object entry : effect_entries){
                    Map<String,Object> entryMap = (Map<String,Object>)entry;
                    Map<String,Object> language = (Map<String,Object>)entryMap.get('language');
                    //Si el nombre de effect entries es en ingles se almacena
                    String name = (String)language.get('name');
                    if((String)language.get('name') == 'en') {
                        habilidad.Efecto__c = (String) entryMap.get('short_effect');
                        break;
                    }
                }
            }else{
                throw new CalloutException('Error ' + response.getBody());
            }
            //Luego de almacenar la informacion del pokemon, se agrega a la lista "pokemons"
            habilidades.add(habilidad);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        insert habilidades;
    }
}