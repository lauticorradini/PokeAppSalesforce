global with sharing class PokemonController {

    @AuraEnabled(cacheable=true)
    global static List<Pokemon__c> getAllPokemons(){
        // Obtiene todos los registros de Pokemon__c y los ordena por ExtId__c
        return [SELECT Id,Name, ExtId__c, Generacion__c, Tipos__c, Altura__c, Peso__c, Habilidad__c, Imagen__c,
        Ataque__c, Defensa__c, Vida__c, Velocidad__c, Slot1__c, Slot2__c, Slot3__c, Slot4__c
        FROM Pokemon__c 
        ORDER BY ExtId__c];    
    }
    
    @AuraEnabled(cacheable=true)
    global static Pokemon__c[] searchPokemon(String searchTerm){
        // Permite buscar registros de tipo Pokemon__c por el nombre
        // El argumento searchTerm contiene el término de búsqueda
        searchTerm = searchTerm.trim();
        if (searchTerm == ''){
            return getAllPokemons();
        }
        searchTerm = '%' + searchTerm + '%';
        return [SELECT Id,Name, ExtId__c, Generacion__c, Tipos__c, Altura__c, Peso__c, Habilidad__c, Imagen__c,
        Ataque__c, Defensa__c, Vida__c, Velocidad__c, Slot1__c, Slot2__c, Slot3__c, Slot4__c
        FROM Pokemon__c 
        WHERE Name 
        LIKE :searchTerm 
        ORDER BY Name 
        ];
    }
    
    @AuraEnabled(cacheable=true)
    global static List<Integer> getGenerations(){
        // Devuelve una lista de enteros que representan las diferentes generaciones
        // de los registros en la tabla "Pokemon__c". 
        List<Integer> unicos = new List<Integer>();
        for(Pokemon__c p : [SELECT Id, Name, ExtId__c, Generacion__c FROM Pokemon__c ORDER BY ExtId__c]){
            // Verifica si la generación ya ha sido agregada a la lista
            if(!unicos.contains((Integer)p.Generacion__c)){
                unicos.add((Integer)p.Generacion__c);
            }
        }
        return unicos;
    }   
    
    @AuraEnabled(cacheable=true)
    global static List<Pokemon__c> getRecordsByGeneration(Integer generation){
        // Si la generacion es 0, entonces se mostraran todos los pokemones
        if (generation == 0){
            return getAllPokemons();
        }
        // Obtiene todos los pokemon segun la generacion seleccionada
        return [SELECT Id, Name, ExtId__c, Generacion__c, Peso__c, Altura__c, Imagen__c 
        FROM Pokemon__c
        WHERE Generacion__c = :generation
        ORDER BY ExtId__c];
    }

    @AuraEnabled(cacheable=true)
    global static List<Pokemon__c> getTypes(String type){
        // Realiza una consulta a la tabla de pokemones 
        // y selecciona los registros que tienen el tipo especificado en el argumento "type"
        return [SELECT Id, Name, ExtId__c, Generacion__c, Peso__c, Altura__c, Imagen__c, Tipos__c
        FROM Pokemon__c
        WHERE Tipos__c = :type
        ORDER By ExtId__c];
    }
}