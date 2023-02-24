@isTest
public with sharing class HabilidadesBatchTest{
    
    @isTest
    static void testHabilidad(){
        SingleRequestMock mock = new SingleRequestMock(200,
                                                      'OK',
                                                       '{"name":"stench","id":"1","effect_entries":[{"short_effect":"Has a 10% chance of making target Pokémon flinch with each hit."}]}',
                                                      null);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	Database.executeBatch(new HabilidadesBatch(),267);
        Test.stopTest();
        Habilidad__c habilidadAVerificar = [SELECT Id,Name FROM Habilidad__c];
       
        System.assertEquals('Stench', habilidadAVerificar.Name, 
        'los nombres no coinciden, el resultado fue :: '+habilidadAVerificar.Name);
        
    }
    @isTest
    static void testStatusCode(){
        String responseExpected = 'El servicio no esta disponible';
        SingleRequestMock sadResponse = new SingleRequestMock(500,
                                                             'Error',
                                                             responseExpected,
                                                             null);
        Test.setMock(HttpCalloutMock.class,sadResponse);
        String error = null;
        Test.startTest();
            try{
                Database.executeBatch(new HabilidadesBatch(),267);
            } catch (Exception e){
                error = e.getMessage();
            }
        Test.stopTest();
        System.assertEquals('Error : '+responseExpected, error, 'el error no fue el esperado, fue :: '+error);
        
    }
}