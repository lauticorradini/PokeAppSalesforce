@isTest
public class PokemonControllerTest {
    static testMethod void testGetAllPokemons() {
        List<Pokemon__c> expectedPokemons = new List<Pokemon__c>();
        for (Integer i = 1; i <= 10; i++) {
            Pokemon__c p = new Pokemon__c(Name='Pokemon ' + i, ExtId__c=i,
                Altura__c=i, Peso__c=i, Imagen__c='Imagen ' + i,
                Ataque__c=i, Defensa__c=i, Vida__c=i, Velocidad__c=i);
            expectedPokemons.add(p);
        }
        insert expectedPokemons;

        List<Pokemon__c> actualPokemons = PokemonController.getAllPokemons();
        System.assertEquals(expectedPokemons.size(), actualPokemons.size(), 'Number of pokemons does not match');
        for (Integer i = 0; i < expectedPokemons.size(); i++) {
            System.assertEquals(expectedPokemons[i].Name, actualPokemons[i].Name, 'Name does not match for pokemon ' + i);
            System.assertEquals(expectedPokemons[i].ExtId__c, actualPokemons[i].ExtId__c, 'ExtId does not match for pokemon ' + i);
            // other fields assertions can be added here
        }
    }
    
    static testMethod void testSearchPokemon(){
        Test.startTest();
        // Create some test data
        List<Pokemon__c> testPokemons = new List<Pokemon__c>();
        for (Integer i = 1; i <= 10; i++) {
            Pokemon__c p = new Pokemon__c(Name='Pokemon ' + i);
            testPokemons.add(p);
        }
        insert testPokemons;

        // Test search with empty search term
        Pokemon__c[] result = PokemonController.searchPokemon('');
        System.assertEquals(10, result.size(), 'Unexpected number of results');

        // Test search with valid search term
        result = PokemonController.searchPokemon('2');
        System.assertEquals(1, result.size(), 'Unexpected number of results');
        System.assertEquals('Pokemon 2', result[0].Name, 'Unexpected name');

        // Test search with no matching results
        result = PokemonController.searchPokemon('xyz');
        System.assertEquals(0, result.size(), 'Unexpected number of results');

        Test.stopTest();
    }
    
    static testMethod void testGetGenerations(){
        Test.startTest();
        // Create some test data
        List<Pokemon__c> testPokemons = new List<Pokemon__c>();
        for (Integer i = 1; i <= 8; i++) {
            Pokemon__c p = new Pokemon__c(Name='Pokemon ' + i, ExtId__c=i);
            testPokemons.add(p);
        }
        insert testPokemons;

        // Test getting generations
        List<Integer> result = PokemonController.getGenerations();
        System.assertEquals(8, result.size(), 'Unexpected number of generations');
        System.assertEquals(1, result[0], 'Unexpected first generation');
        System.assertEquals(2, result[1], 'Unexpected second generation');
        System.assertEquals(3, result[2], 'Unexpected third generation');

        Test.stopTest();
    }
}