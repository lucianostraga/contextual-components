public class CryptoRankingController {
    
     @AuraEnabled
    public static List<Coin> getCryptosByOppId(String opportunityId){
        Opportunity opp = [SELECT Id, Amount FROM Opportunity WHERE ID =: opportunityId];
        
        List<Coin> cryptos = getCryptos();
        
        for(Coin c : cryptos)
            c.OppValue = (opp.Amount / c.Rate);
        
        return cryptos;
    }
    
    @AuraEnabled
    public static List<Coin> getCryptos(){
        List<Coin> coins = new List<Coin>();
        
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');   
        httpRequest.setEndpoint('https://api.coinmarketcap.com/v1/ticker/?limit=10&sort=rank');
        Http http = new Http();   
        HttpResponse httpResponse = http.send(httpRequest);  
        List<Object> cryptoResponse = (List<Object>) JSON.deserializeUntyped(httpResponse.getBody());
        
        for(Object o : cryptoResponse){
            Map<String, Object> coinMap = (Map<String, Object>) o;
            Coin c = new Coin();
            c.Name = (String) coinMap.get('name');
            c.CryptoId = (String) coinMap.get('symbol');
            c.Rate = Double.valueOf((String) coinMap.get('price_usd'));
            c.Change24 = Double.valueOf((String) coinMap.get('percent_change_24h'));
            coins.add(c);
        }
       
        return coins;
    }
    
    public class Coin{
        @AuraEnabled
        public String Name {get; set;}
        
        @AuraEnabled
        public String CryptoId {get; set;}
        
        @AuraEnabled
        public Double Rate {get; set;}
        
        @AuraEnabled
        public Double Change24 {get; set;}
        
        @AuraEnabled
        public Double OppValue {get; set;}
    }

}