public with sharing class AccountCreateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('in start method');
        return Database.getQueryLocator('Select id, Name from Account Limit 10');
    }
    public void execute(Database.BatchableContext BC, list<Account> accList) {
        System.debug('in execute method');
        String body = new JSONAccount().JSONAccountMethod(accList);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        //req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setEndPoint('callout:trailheadOrg/services/data/v54.0/composite/tree/Account');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
        HttpResponse response = http.send(req);
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
    
    }
    public void finish(Database.BatchableContext BC){
        System.debug('in finish method');
    }

    public class JSONAccount {
        public String JSONAccountMethod (List<Account> accList) {
            String jsonData='';
            if(!accList.isEmpty()) {
                JSONGenerator jsonGen = JSON.createGenerator(true);
                jsonGen.writeStartObject();
                jsonGen.writeFieldName('records');
                jsonGen.writeStartArray();
                Integer i = 1;
                for(Account acc : accList){
                    jsonGen.writeStartObject();
                    jsonGen.writeFieldName('attributes');
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('type','Account');
                    jsonGen.writeStringField('referenceId','ref'+(i++));
                    jsonGen.writeEndObject();
                    jsonGen.writeStringField('name',acc.Name);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                jsonGen.writeEndObject();
                jsonData = jsonGen.getAsString();
                //System.debug('Json Data - ' + jsonData);
                return jsonData;
            }

            return jsonData;
            
        }
/*         public Map<String,String> getAttribute(String currType, String refId) {
            Map<String,String> attrMap = new Map<String,String>();
            if(currType == 'Account') {
                attrMap.put('type','Account');
                attrMap.put('referenceId',refId);
            }
            return attrMap;
        }  */
    }
}

/*{
    "records" :[{
        "attributes" : {"type" : "Account", "referenceId" : "ref1"},
        "name" : "SampleAccount1",
        "phone" : "1111111111",
        "website" : "www.salesforce.com",
        "numberOfEmployees" : "100",
        "industry" : "Banking"   
        },{
        "attributes" : {"type" : "Account", "referenceId" : "ref2"},
        "name" : "SampleAccount2",
        "phone" : "2222222222",
        "website" : "www.salesforce2.com",
        "numberOfEmployees" : "250",
        "industry" : "Banking"
        },{
        "attributes" : {"type" : "Account", "referenceId" : "ref3"},
        "name" : "SampleAccount3",
        "phone" : "3333333333",
        "website" : "www.salesforce3.com",
        "numberOfEmployees" : "52000",
        "industry" : "Banking"
        }]
}  */