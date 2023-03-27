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
    
    static testMethod void testGetGenerations(){
        Test.startTest();
        // Create some test data
        List<Pokemon__c> testPokemons = new List<Pokemon__c>();
        testPokemons.add(new Pokemon__c(Name = 'Bulbasaur', ExtId__c = 1));
        testPokemons.add(new Pokemon__c(Name = 'Chikorita', ExtId__c = 152));
        testPokemons.add(new Pokemon__c(Name = 'Treecko', ExtId__c = 252));
        testPokemons.add(new Pokemon__c(Name = 'Turtwig', ExtId__c = 387));
        testPokemons.add(new Pokemon__c(Name = 'Victini', ExtId__c = 494));
        testPokemons.add(new Pokemon__c(Name = 'Chespin', ExtId__c = 650));
        testPokemons.add(new Pokemon__c(Name = 'Rowlet', ExtId__c = 722));
        testPokemons.add(new Pokemon__c(Name = 'Grookey', ExtId__c = 810));
        insert testPokemons;

        // Test getting generations
        List<Integer> result = PokemonController.getGenerations();
        System.assertEquals(8, result.size(), 'Unexpected number of generations');
        System.assertEquals(1, result[0], 'Unexpected first generation');
        System.assertEquals(2, result[1], 'Unexpected second generation');
        System.assertEquals(3, result[2], 'Unexpected third generation');

        Test.stopTest();
    }
    
    static testMethod void testGetFilteredPokemonsIncomplete(){
        // Test para obtener todos los pokemones sin que haya parametros
        List<Pokemon__c> expectedPokemons = new List<Pokemon__c>();
        for (Integer i = 1; i <= 10; i++) {
            Pokemon__c p = new Pokemon__c(Name='Pokemon ' + i, ExtId__c=i);
            expectedPokemons.add(p);
        }
        insert expectedPokemons;
        
        List<Pokemon__c> actualPokemons = PokemonController.getFilteredPokemons('', 0, '');
        System.assertEquals(expectedPokemons.size(), actualPokemons.size(), 'Numero de Pokemones no coincide');
        for (Integer i = 0; i < expectedPokemons.size(); i++) {
            System.assertEquals(expectedPokemons[i].Name, actualPokemons[i].Name, 'El nombre del Pokemon no coincide ' + i);
            System.assertEquals(expectedPokemons[i].ExtId__c, actualPokemons[i].ExtId__c, 'ExtId no coincide con el Pokemon ' + i);
        }
    }
    
    static testMethod void testGetFilteredPokemonsComplete(){
        // Test para obtener el pokemon especifico con nombre generacion y tipo
        Pokemon__c pokeFull = new Pokemon__c(Name = 'Pikachu', ExtId__c = 25, Tipos__c = 'Electric');
        insert pokeFull;
        String searchTerm = 'Pikachu';
        String types = 'Electric';
        Integer gen = 1;
        List<Pokemon__c> actualPokemon = PokemonController.getFilteredPokemons(searchTerm, gen, types);
        System.assertEquals(actualPokemon.size(), 1, 'No se encontro el Pokemon');
    }
    static testMethod void testSearchFilter(){
        Pokemon__c poke = new Pokemon__c(Name='Pikachu');
        insert poke;
        String searchTerm = 'pika';
        List<Pokemon__c> result = PokemonController.getFilteredPokemons(searchTerm, 0, '');
        System.assertEquals(result.size(), 1);
        System.assertEquals(result[0].Name, 'Pikachu');
    }
    
    static testMethod void testGenFilter(){
        Pokemon__c p1 = new Pokemon__c(ExtId__c=1);
        Pokemon__c p2 = new Pokemon__c(ExtId__c=152);
        insert new List<Pokemon__c>{p1, p2};
		Integer generation = 2;
        List<Pokemon__c> result3 = PokemonController.getFilteredPokemons('', generation, '');
        System.assertEquals(result3.size(), 1); 
    }  
    
    static testMethod void testTypesFilter(){
        Pokemon__c poke1 = new Pokemon__c(Tipos__c='Fire;Flying');
        Pokemon__c poke2 = new Pokemon__c(Tipos__c='Water');
        insert new List<Pokemon__c>{poke1, poke2};
        String types = 'Fire;Flying';
        List<Pokemon__c> result4 = PokemonController.getFilteredPokemons('', 0, types);
        System.assertEquals(result4.size(), 1);
    }
}