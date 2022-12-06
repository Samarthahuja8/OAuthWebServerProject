// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//JSON.serialize example

Datetime dt = Datetime.newInstance(
               Date.newInstance(
                  2011, 3, 22),
               Time.newInstance(
                  1, 15, 18, 0)); 
    String str = JSON.serialize(dt); 
    System.assertEquals(
       '"2011-03-22T08:15:18.000Z"',
       str);
       
//JSON.deserializeUntyped example
String jsonInput = '{\n' +
    ' "description" :"An appliance",\n' +
    ' "accessories" : [ "powerCord", ' + 
      '{ "right":"door handle1", ' + 
        '"left":"door handle2" } ],\n' +
    ' "dimensions" : ' + 
      '{ "height" : 5.5 , ' + 
        '"width" : 3.0 , ' + 
        '"depth" : 2.2 },\n' +
    ' "type" : null,\n' +
    ' "inventory" : 2000,\n' +
    ' "price" : 1023.45,\n' +
    ' "isShipped" : true,\n' +
    ' "modelNumber" : "123"\n' +
    '}';
    
Map<String, Object> m = 
   (Map<String, Object>)
      JSON.deserializeUntyped(jsonInput);


//JSONToken enum
String JSONContent = '{"firstName":"John"}';
JSONParser parser = 
   JSON.createParser(JSONContent);
// Advance to the next token.
while (parser.nextToken() != null) {
    System.debug('Current token: ' +
        parser.getCurrentToken());
}

//JSONParser example
String tokencred = '[{"Id":"003m000000yKLySkkL","Token":"I2j5bUky04B4eLJGYELV"}]';
JSONParser parser = JSON.createParser(tokencred);
Map<String,String> tokenMap = new Map<String,String>();

String parsedId;
String parsedToken;
while (parser.nextToken() != null) {
    if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
        String fieldName = parser.getText();
        System.debug('fieldName: ' + fieldName);
        //move to token after the field name
        parser.nextToken();
        if (fieldName == 'Id') {
            parsedId = parser.getText();
        } else if (fieldName == 'Token') {
            parsedToken = parser.getText();
        }
    }
    tokenMap.put(parsedId,parsedToken);
}