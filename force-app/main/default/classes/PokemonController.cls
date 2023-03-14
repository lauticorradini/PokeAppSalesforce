global with sharing class PokemonController {

    @AuraEnabled(cacheable=true)
    global static Pokemon__c[] getAllPokemons(){
        // Obtiene todos los registros de Pokemon__c y los ordena por ExtId__c
        return [SELECT Id,Name, ExtId__c, Generacion__c, Tipos__c, Altura__c, Peso__c, Habilidad__c, Imagen__c,
        Ataque__c, Defensa__c, Vida__c, Velocidad__c, Slot1__c, Slot2__c, Slot3__c, Slot4__c
        FROM Pokemon__c 
        ORDER BY ExtId__c];    
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
    global static Pokemon__c[] getFilteredPokemons(String searchTerm, Integer generation, String types){
        //Se elimina cualquier espacio en blanco en el termino de busqueda
        searchTerm = searchTerm.trim();
        //Si todos los parametros de busqueda estan vacios, se muestran todos los pokemones
        if(searchTerm == '' && generation == 0 && types == null) {
            return getAllPokemons();
        }
        //Agrega % para buscar aproximaciones sobre el pokemon a buscar
        searchTerm = '%' + searchTerm + '%';
        //Consulta SOQL inicial
        String query = 'SELECT Name, Id, ExtId__c, Generacion__c, Tipos__c, Imagen__c, Peso__c, Altura__c FROM Pokemon__c WHERE Name LIKE :searchTerm';
    
        //Si la generacion es entre 1 y 8, se agrega a la consulta SOQL
        if(generation != 0){
            query += ' AND Generacion__c =: generation';
        }
        ////Si el tipo es valido, se agrega a la consulta SOQL
        if(types != ''){
            query += ' AND Tipos__c =: types';
        }
        //Ordena la consulta por el campo ExtId
        query += ' ORDER BY ExtId__c';
        //Ejecuta la consulta SOQL
        return Database.query(query);
    }
}