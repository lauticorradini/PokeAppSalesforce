public class TryPokeApi {
    public static List <Object> getAllPokemons(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String, Object> results = new Map<String, Object>();
        List<Object> listResponse = new List<Object>();
        Map<String, Object> pokeName = new Map<String, Object>();
        List<String> name = new List<String>();
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
            results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            listResponse = (List<Object>)results.get('results');
        }
        
        if (!listResponse.isEmpty()){
            for (Object o : listResponse){
                pokeName = (Map<String, Object>)o;
                name.add((String) pokeName.get('name'));
            }
        }
        System.debug('Name Poke: ' + name);
        return listResponse;
    }
    
}