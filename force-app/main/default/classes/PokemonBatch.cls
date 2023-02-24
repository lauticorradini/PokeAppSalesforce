global class PokemonBatch implements Database.Batchable<Integer>, Database.StateFul, Database.AllowsCallouts{
    
    List<Pokemon__c> pokemons = new List<Pokemon__c>();
    
    global Iterable<Integer> start(Database.BatchableContext bc) {
        //Creando una lista para almacenar los identificadores de Pokemon
        List<Integer> pokemonIds = new List<Integer>();
        //Se itera hasta 898 para obtener los pokemones pedidos
        for (Integer i = 1; i <= 898; i++) {
            //Agrego el numero de iteracion a la lista de identificadores
            pokemonIds.add(i);
        }
        return pokemonIds;
    }
    
    global void execute(Database.BatchableContext bc, List<Integer> pokemonIds){
        //Query antes del ciclo for para evitar hacer demasiadas llamadas
        //En movimientos o habilidades se almacena el Name e Id de un Movimiento__c o Habilidad__c para luego en la insercion sea mas facil de obtener
        List<Movimiento__c> movimientos = [SELECT Id,Name FROM Movimiento__c];
        Map<String,Id> movesMap = new Map<String,Id>();
        for(Movimiento__c movimiento : movimientos){
            movesMap.put(movimiento.Name, movimiento.Id); //Map donde se almacena el Name e Id de un movimiento
        }
        List<Habilidad__c> habilidades = [SELECT Id, Name FROM Habilidad__c];
        Map<String, Id> habilidadesMap = new Map<String, Id>();
        for (Habilidad__c habilidad : habilidades) {
            habilidadesMap.put(habilidad.Name, habilidad.Id); //Map donde se alamacena el Name e Id de una habilidad
        }
        for (Integer id : pokemonIds){
            Pokemon__c pokemon = new Pokemon__c();
            List<String> abilitiesName = new List<String>();
            //Llamada tipo GET a la PokeAPI para el pokemon segun su id
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + id);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                //Deserializa el JSON para obtener nombre,id,altura,peso e imagen
                pokemon.Name = ((String) results.get('name')).capitalize();
                pokemon.ExtId__c = (Integer) results.get('id');
                pokemon.Altura__c = ((Double) results.get('height')) / 10;
                pokemon.Peso__c = ((Double) results.get('weight')) / 10;

                //Mapa de sprites para obtener los resultados
                Map<String,Object> sprites = (Map<String,Object>)results.get('sprites');
                pokemon.Imagen__c = (String)sprites.get('front_default');
                
                //Obteniendo lista para las estadisticas 
                List<Object> statList = (List<Object>)results.get('stats');
                for (Object stat : statList){
                    //Obtengo la informacion de la estadistica actual en la iteracion
                    Map<String,Object> stat2 = (Map<String,Object>) stat;
                    Map<String,Object> someStat = (Map<String,Object>) stat2.get('stat');
                    //Verificando el nombre de la estadistica y asignando su valor al campo correspodiente en Pokemon__c
                    if (someStat.get('name') == 'hp'){
                        pokemon.Vida__c = (Integer) stat2.get('base_stat');
                    } else if (someStat.get('name') == 'attack'){
                        pokemon.Ataque__c = (Integer) stat2.get('base_stat');
                    } else if (someStat.get('name') == 'defense'){
                        pokemon.Defensa__c = (Integer) stat2.get('base_stat');
                    } else if (someStat.get('name') == 'speed'){
                        pokemon.Velocidad__c = (Integer) stat2.get('base_stat');
                    } 
                }

                //Almacena types en una lista para ir obteniendo sus valores, luego se concatena el nombre del Tipo con un ; ya que el campo es de tipo Picklist
                List<Object> typesData = (List<Object>) results.get('types');
                String types = '';
                for (Object typeData : typesData) {
                    Map<String, Object> type = (Map<String, Object>) typeData;
                    Map<String, Object> typeInfo = (Map<String, Object>) type.get('type');
                    String typeName = ((String) typeInfo.get('name')).capitalize();
                    types += typeName + ';';
                }
                types = types.substring(0, types.length() - 1); // Eliminar el último ;   
                pokemon.Tipos__c = types;
                

                //Obteniendo lista de habilidades
                List<Object> abilitiesLst = (List<Object>)results.get('abilities');
                
                //Iterando a traves de la lista de habilidades
                for (Object ability : abilitiesLst){
                    // Obteniendo información de la habilidad actual en la iteración
                    Map<String,Object> ability2 = (Map<String,Object>) ability;
                    Map<String,Object> someAbility = (Map<String,Object>) ability2.get('ability');
                    // Obteniendo nombre de la habilidad y capitalizando la primera letra
                    abilitiesName.add(((String) someAbility.get('name')).capitalize());
                }
                //Funcion que devuelve una habilidad de las que tengo en mi lista, de manera aleatoria
                String randomAbilityName = getRandomAbility(abilitiesName); 
                //Obtengo el Id de la habilidad pasada por parametro
                Id habilidadId = habilidadesMap.get(randomAbilityName); 
                // Asignando id de la habilidad al campo correspondiente en el objeto Pokemon
                pokemon.Habilidad__c = habilidadId;
                
                //Obteniendo lista de movimientos de results
                List<Object> movesData = (List<Object>)results.get('moves');

                //Iterando para obtener solamente los primeros 4 movimientos de un pokemon
                for(Integer i=0; i< movesData.size(); i++) {
                    //Obtengo la informacion del movimiento actual en la iteracion
                    Map<String, Object> move = (Map<String, Object>) movesData[i];
                    Map<String, Object> moveInfo = (Map<String, Object>) move.get('move');
                    //Obteniendo nombre del movimiento y capitalizando la primera letra
                    String moveName = ((String) moveInfo.get('name')).capitalize();
                    Id moveId = movesMap.get(moveName);
                    //Asignando el Id al campo correspondiente en Pokemon__c
                    if (i==0)
                        pokemon.Slot1__c = moveId;
                    else if (i==1)
                        pokemon.Slot2__c = moveId;
                    else if (i==2)
                        pokemon.Slot3__c = moveId;
                    else if (i==3)
                        pokemon.Slot4__c = moveId;
                }
            }else{
                throw new CalloutException('Error ' + response.getBody());
            }
            //Luego de almacenar la informacion del pokemon, se agrega a la lista "pokemons"
            pokemons.add(pokemon);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        insert pokemons;
    }
    
    //Dada una lista de habilidades, obtiene una de manera aleatoria
    public static String getRandomAbility(List<String> abilitiesName){
        Integer listSize = abilitiesName.size();
        Integer randomNumber = Integer.valueof((Math.random() * listSize));
        String randomString= abilitiesName[randomNumber];
        return randomString;
    }
}