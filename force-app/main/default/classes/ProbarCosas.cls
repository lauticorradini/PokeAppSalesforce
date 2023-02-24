public class ProbarCosas {
    
    public static String getSprite(Integer i){
        String imagen = '';
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+i);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                Map<String,Object> sprites = (Map<String,Object>)results.get('sprites');
                imagen = (String)sprites.get('front_default');
            }
        } catch (Exception e) {
            System.debug(e);
        }
        System.debug(imagen);
        return imagen;
        
    }
    
    public static String getTypes(Integer i){
        String tipo ;
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+i);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                List<Object> typesData = (List<Object>) results.get('types');
                String types = '';
                for (Object typeData : typesData) {
                    Map<String, Object> type = (Map<String, Object>) typeData;
                    Map<String, Object> typeInfo = (Map<String, Object>) type.get('type');
                    String typeName = ((String) typeInfo.get('name')).capitalize();
                    types += typeName + ';';
                }
                //types = types.substring(0, types.length() - 1); // Eliminar el último ;
                tipo = types;
            }
            
        } catch (Exception e) {
            System.debug(e);
        }
        System.debug(tipo);
        return tipo;
    }
    
    public static void getStats(Integer i){
        Integer vida,ataque,defensa,velocidad;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+i);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            List<Object> statList = (List<Object>)results.get('stats');
            //Mapea stats ya que es una lista, para iterar y buscar vida,ataque,defensa y velocidad
            for (Object stat : statList){
                Map<String,Object> stat2 = (Map<String,Object>) stat;
                Map<String,Object> someStat = (Map<String,Object>) stat2.get('stat');
                if (someStat.get('name') == 'hp'){
                    vida = (Integer) stat2.get('base_stat');
                } else if (someStat.get('name') == 'attack'){
                    ataque = (Integer) stat2.get('base_stat');
                } else if (someStat.get('name') == 'defense'){
                    defensa = (Integer) stat2.get('base_stat');
                } else if (someStat.get('name') == 'speed'){
                    velocidad = (Integer) stat2.get('base_stat');
                } 
            }
        }
        System.debug('vida: '+vida);
        System.debug('ataque: '+ataque);
        System.debug('defensa: '+defensa);
        System.debug('velocidad: '+velocidad);
    }
    
    public static void getAbilities(Integer i){
        List<String> abilitiesName = new List<String>();
        String habilidad;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+i);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200){
            Map<String,Object> results = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            List<Object> abilitiesLst = (List<Object>)results.get('abilities');
            //Map<String,Object> ability2 = (Map<String,Object>) ability;
            //Map<String,Object> someAbility = (Map<String,Object>) ability2.get('ability');
            //String habilidad = ((String) someAbility.get('name')).capitalize();
            for (Object ability : abilitiesLst){
                Map<String,Object> ability2 = (Map<String,Object>) ability;
                Map<String,Object> someAbility = (Map<String,Object>) ability2.get('ability');
                abilitiesName.add((String) someAbility.get('name'));
            }
            habilidad = getRandomAbility(abilitiesName); 
        }
        System.debug(habilidad);
    }
    
    public static String getRandomAbility(List<String> abilitiesName){
        Integer listSize = abilitiesName.size();
        Integer randomNumber = Integer.valueof((Math.random() * listSize));
        String randomString= abilitiesName[randomNumber];
        return randomString;
    }
    
    public static void getMoves(Integer i){
        Pokemon__c pokemon = new Pokemon__c();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+i);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            List<String> nombresMovimientos = new List<String>();
            for(Integer j = 0; j < 4; j++) {
                Map<String, Object> move = (Map<String, Object>) ((List<Object>) results.get('moves'))[j];
                String moveName = ((String) ((Map<String, Object>) move.get('move')).get('name')).capitalize();
                nombresMovimientos.add(moveName);
            }
            System.debug(nombresMovimientos[1]);
            //pokemon.Slot1__c = nombresMovimientos[0];
            //pokemon.Slot2__c = nombresMovimientos[1];
            //pokemon.Slot3__c = nombresMovimientos[2];
            //pokemon.Slot4__c = nombresMovimientos[3];
        }
    }
    
    public static void getHeightAndWeight(Integer i){
        	Double altura,peso;
        	Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+i);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                altura = ((Double) results.get('height'))/10;
                peso = ((Double) results.get('weight'))/10;
            }
        	System.debug('altura: ' + altura);
        	System.debug('peso: ' + peso);
    }
}