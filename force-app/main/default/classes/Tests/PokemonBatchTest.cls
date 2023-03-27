@isTest
public class PokemonBatchTest {
	@isTest
    static void testPokemon(){
        String expected = '{ "abilities": [ { "ability": { "name": "limber" } }, { "ability": { "name": "imposter" } } ], "height": 3, "id": 132, "moves": [ { "move": { "name": "transform" } } ], "name": "ditto", "sprites": { "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png" }, "stats": [ { "base_stat": 48, "effort": 1, "stat": { "name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/" } }, { "base_stat": 48, "effort": 0, "stat": { "name": "attack", "url": "https://pokeapi.co/api/v2/stat/2/" } }, { "base_stat": 48, "effort": 0, "stat": { "name": "defense", "url": "https://pokeapi.co/api/v2/stat/3/" } }, { "base_stat": 48, "effort": 0, "stat": { "name": "speed", "url": "https://pokeapi.co/api/v2/stat/6/" } } ], "types": [ { "type": { "name": "normal" } } ], "weight": 40 }';
        SingleRequestMock mock = new SingleRequestMock(200,
                                                      'OK',
                                                      expected,
                                                      null);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	Database.executeBatch(new PokemonBatch(),898);
        Test.stopTest();
        Pokemon__c pokemonAVerificar = [SELECT Id,Name,ExtId__c, Peso__c, Altura__c, Tipos__c, Ataque__c, Vida__c, Velocidad__c, Imagen__c, Habilidad__c, Slot1__c,Slot2__c,Slot3__c,Slot4__c FROM Pokemon__c];
        System.assertEquals('Ditto', pokemonAVerificar.Name);
    }
}