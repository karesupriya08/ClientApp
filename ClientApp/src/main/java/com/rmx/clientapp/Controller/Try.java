/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Controller;

import com.eclipsesource.json.Json;
import com.eclipsesource.json.JsonArray;
import com.eclipsesource.json.JsonValue;

import org.json.simple.parser.JSONParser;


public class Try {

    public static void main(String[] args) {

        /*  JSONParser parser = new JSONParser();
        String json="{\"data\":[{\"colour\":2008,\"order_per\":562.1,\"serial\":17,\"price\":32,\"raised\":423,\"order_qty\":511},{\"colour\":4369,\"order_per\":564.3,\"serial\":17,\"price\":32,\"raised\":539,\"order_qty\":513},{\"colour\":2008,\"order_per\":8.8,\"serial\":327,\"price\":32,\"raised\":0,\"order_qty\":8},{\"colour\":2008,\"order_per\":44,\"serial\":593,\"price\":32,\"raised\":42,\"order_qty\":40},{\"colour\":2008,\"order_per\":48.4,\"serial\":7017,\"price\":54.4,\"raised\":35,\"order_qty\":44}]}";
        JsonArray items = Json.parse(json).asObject().get("data").asArray();
        for (JsonValue item : items) {
        int name = item.asObject().getInt("colour",1);
        float quantity = item.asObject().getFloat("order_per", 2);
        System.out.println("colour-------"+name);
        System.out.println("rder-per-------"+quantity);*/
     String a ="hello";
   String b = new String("hello");
   if(a.equals(b))
   {
       System.out.println("equal");
   }
   else
   {
       System.out.println("not equal====");
   }
    if(a==b)
   {
       System.out.println("equal");
   }
   else
   {
       System.out.println("not equal====");
   }
}
/*
try {

Object obj = parser.parse("[{\"colour\":2008,\"order_per\":562.1,\"serial\":17,\"price\":32,\"raised\":423,\"order_qty\":511},{\"colour\":4369,\"order_per\":564.3,\"serial\":17,\"price\":32,\"raised\":539,\"order_qty\":513},{\"colour\":2008,\"order_per\":8.8,\"serial\":327,\"price\":32,\"raised\":0,\"order_qty\":8},{\"colour\":2008,\"order_per\":44,\"serial\":593,\"price\":32,\"raised\":42,\"order_qty\":40},{\"colour\":2008,\"order_per\":48.4,\"serial\":7017,\"price\":54.4,\"raised\":35,\"order_qty\":44}]");

JSONObject jsonObject = (JSONObject) obj;
System.out.println(jsonObject);


// loop array
JSONArray msg = (JSONArray) jsonObject.get(0);

Iterator<String> iterator = msg.iterator();
while (iterator.hasNext()) {
System.out.println(iterator.next());
}

} catch (ParseException e) {
e.printStackTrace();
} catch (Exception e) {
e.printStackTrace();
}*/

 
}
