@isTest
public class MovimientosBatchTest {
	@isTest
    static void testMovimiento(){
        String  expected = '{ "accuracy": null, "effect_chance": null, "effect_entries": [{"short_effect": "User becomes a copy of the target until it leaves battle."}], "id": 144, "name": "transform", "power": null, "pp": 10, "priority": 0,"target": { "name": "selected-pokemon"},"type": { "name": "normal"}}';
        SingleRequestMock mock = new SingleRequestMock(200,
                                                      'OK',
                                                       expected,
                                                      null);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        	Database.executeBatch(new MovimientosBatch(),826);
        Test.stopTest();
        List<Movimiento__c> movimientos = [SELECT Id,Name,ExtId__c, Punteria__c, Efecto__c, Prioridad__c, Poder__c, Pp__c, Objetivo__c, Chance_de_Efecto__c, Tipo__c FROM Movimiento__c];
        System.assertEquals(1,movimientos.size());
        System.assertEquals('Transform', movimientos[0].Name);
    }
    @isTest 
    static void testException(){
        String expected = 'Error';
        SingleRequestMock mock = new SingleRequestMock(400,
                                                      'Bad Request',
                                                      expected,
                                                      null);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            try{
                Database.executeBatch(new MovimientosBatch(),826);
                System.assert(false, 'Exception should have been thrown');
            } catch(CalloutException e){
                System.assertEquals('Error Message', e.getMessage());
            }
        Test.stopTest();
    }
}