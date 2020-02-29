public class CTRL {
@RemoteAction
public static  Map<String, object> sendGBRequest(string request)

//public static  String sendGBRequest(string request)
{
   Map<String, object> returnData = new Map<String, object>();
    
    // get the api key in static resource
    StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'gb_api_key' LIMIT 1];
    String apiKey = sr.Body.toString();
       
    request = request.replace(' ','%20'); // #JOSH
    HttpRequest req = new HttpRequest();
    req.setTimeout(60000);
    req.setMethod('GET');
    req.setEndpoint('https://www.giantbomb.com/api/search/?format=json&api_key=' + apiKey + '&query=' + request + '&resources=game');
    
    // System.debug(req + ' ' + request);
    
    Http routeHTTP = new Http();
    HttpResponse res = routeHTTP.send(req);
   returnData = (Map<String,object>) JSON.deserializeuntyped(res.getBody());
   return returnData;
 
}

@RemoteAction
public static  Map<String, object> sendGBRequestGame(string request)

{
   Map<String, object> returnData = new Map<String, object>();

    // get the api key in static resource
    StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'gb_api_key' LIMIT 1];
    String apiKey = sr.Body.toString();
   
    HttpRequest req = new HttpRequest();
    req.setTimeout(60000);
    req.setMethod('GET');
    req.setEndpoint('https://www.giantbomb.com/api/game/' + request + '/?api_key=' + apiKey + '&format=json');
    
    Http routeHTTP = new Http();
    HttpResponse res = routeHTTP.send(req);
    returnData = (Map<String,object>) JSON.deserializeuntyped(res.getBody());
    return returnData;
}

@RemoteAction
public static list<Video_Game__c> getGames(string type)

{
   List<Video_Game__c> vgList = [SELECT GUID__c FROM Video_Game__c WHERE GUID__c != null AND RecordTypeId = :type];
    return vgList;
}

@RemoteAction
public static list<Video_Game__c> convertGame(String vgId, String rtId)

{
   List<Video_Game__c> vgList = [SELECT Id, RecordTypeId FROM Video_Game__c WHERE GUID__c = :vgId];
    for(Video_Game__c vg :vgList){
        vg.RecordTypeId = rtId;
    }

    update vgList;
    return vgList;
}

}