/*
 * A sketch to retrieve decibel and Co2 data from timestreams on the active ingredient timestreams blog.
 * RESTful api that returns JSON. Currently no authentication is required, but this will likely change.
 * To run this sketch you'll need to download and install the json-simple library found here:
 * http://code.google.com/p/json-simple/
 *
 * License:
 * Copyright (C) 2012 Mark Selby
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
import org.json.simple.*;
import org.json.simple.parser.*;
import processing.serial.*;

/****VALUES TO CHANGE THRESHOLDS****/
//
static int lowDecibelLimit = 40;
int highDecibelLimit = 70;
//
static int lowCO2Limit = 800;
int middleC02Limit = 1000;
int highCO2Limit = 1500;
//
//****VALUES TO CHANGE THRESHOLDS****
//
Serial myPort;

PFont myFont;
static int previousCo2 = lowCO2Limit;
static int previousDec = lowDecibelLimit;

String co2Request;
String decibelRequest;
static long timestamp = 0;
 
void setup() {
  size (1440, 900);
  background(255, 69, 0);
  //
  myFont = createFont("Futura-Medium-48.vlw", 150);
  textFont(myFont);
  //
  // Set the proxy server and port to nottingham uni 
   Properties systemSettings = System.getProperties();
   systemSettings.put("http.proxyHost", "mainproxy.nottingham.ac.uk");
   systemSettings.put("http.proxyPort", "8080");
   System.setProperties(systemSettings);
   //
  //
  String portName = Serial.list()[4]; // Enter the number of you serial port here
  println ("port list: " + portName);
  myPort = new Serial(this, portName, 9600);
  //
  decibelRequest = "http://activeingredient.timestreams.wp.horizon.ac.uk/wp-content/plugins/timestreams/2/timestream/id/58";
  co2Request = "http://activeingredient.timestreams.wp.horizon.ac.uk/wp-content/plugins/timestreams/2/timestream/id/57";
}

//makes sketch play full screen
boolean sketchFullScreen() {
  return true;
}

void draw() {
  
  try{
  handleData(co2Request, decibelRequest);
  }catch(Exception e){
   e.printStackTrace(); 
  }
  delay(2000); // delay to avoid hitting the server too often
}
// method for handling data - calls other methods to retrieve it and send it to arduino / display
void handleData(String urlBase1, String urlBase2) {
  String measurement1 = getData(urlBase1);
  Integer measurementInt1 = Integer.parseInt(measurement1);
  String measurement2 = getData(urlBase2);
  Integer measurementInt2 = Integer.parseInt(measurement2);
  //check if either of them is null or 0 - if so use previous value
  if ((measurementInt1 == null) || (measurementInt1<=0)) {
    measurementInt1 = previousCo2;
  }
  if ((measurementInt2 == null) || (measurementInt2<=0)) {
    measurementInt2 = previousDec;
  }
  sendSerial(measurementInt1, measurementInt2);
  displayValues(measurementInt1, measurementInt2);
  previousDec = measurementInt2;
  previousCo2 = measurementInt1;
}

// request data from the server
String getData(String urlBase) {
  try{
  String request = urlBase + "?last=" + timestamp;
  timestamp = parseTime();
  String data [] = loadStrings(request);
  //println("data.length: " + data.length); 
  //println("measurement: " + parseMeasurements(data[0]));
  return parseMeasurements(data[0]);
  }catch (NullPointerException npe){
   //npe.printStackTrace(); 
   return "0";
  }
}
// Method to parse the JSON, and retrieve the decibel and co2 values
String parseMeasurements(String s) {
  println("s: " + s);
  JSONObject obj=(JSONObject)JSONValue.parse(s);
  JSONArray t = (JSONArray)obj.get("measurements");
  int tSize = t.size();
  //println(tSize);
  if (tSize!=0) {
    obj = (JSONObject) t.get(tSize-1);
    return (String)obj.get("value");
  } 
  return "0";
}
// Method to get a timestamp from the server. This is used to retrieve all data collected since the last request.
// Timestamps on local machine and server may be different.
long parseTime(){
  String timeString = "http://activeingredient.timestreams.wp.horizon.ac.uk/wp-content/plugins/timestreams/2/time";
  String s = loadStrings(timeString)[0];
  JSONObject obj=(JSONObject)JSONValue.parse(s);

  JSONArray t = (JSONArray)obj.get("timestamp");
  obj = (JSONObject) t.get(0);
  return (Long)obj.get("CURRENT_TIMESTAMP");
}
// Method to interpret incoming values, match them to various thresholds, and send derial data to arduino
// 4 C02 categories - LOWEST, LOW, MEDIUM, HIGH - all with 3 possible decibel categories - LOW, MEDIUM, HIGH.
void sendSerial(int co2, int db) {
  //CO2 thresholds
  //LOWEST CO2
  if (co2<lowCO2Limit) {
    // LOW DECIBELS
    if (db<lowDecibelLimit) {
      myPort.write ('A');
      println("A");
    }
    // MEDIUM DECIBELS
    else if ((db>=lowDecibelLimit)&&(db<highDecibelLimit)) {
      myPort.write('B');
      println("B");
    }
    // HIGH DECIBELS
    else if (db>=highDecibelLimit) {
      myPort.write('C');
      println("C");
    }
  }
  //LOW CO2
  if ((co2>=lowCO2Limit)&&(co2<middleC02Limit)) {
    // LOW DECIBELS
    if (db<lowDecibelLimit) {
      myPort.write ('D');
      println("D");
    }
    // MEDIUM DECIBELS
    else if ((db>=lowDecibelLimit)&&(db<highDecibelLimit)) {
      myPort.write('E');
      println("E");
    }
    // HIGH DECIBELS
    else if (db>=highDecibelLimit) {
      myPort.write('F');
      println("F");
    }
  }
  //MEDIUM CO2
  if ((co2>=middleC02Limit)&&(co2< highCO2Limit)) {
    // LOW DECIBELS
    if (db<lowDecibelLimit) {
      myPort.write ('G');
      println("G");
    }
    // MEDIUM DECIBELS
    else if ((db>=lowDecibelLimit)&&(db<highDecibelLimit)) {
      myPort.write('H');
      println("H");
    }
    // HIGH DECIBELS
    else if (db>=highDecibelLimit) {
      myPort.write('I');
      println("I");
    }
  }
  //HIGH CO2
  if (co2>=highCO2Limit) {
    // LOW DECIBELS
    if (db<lowDecibelLimit) {
      myPort.write ('J');
      println("J");
    }
    //MEDIUM DECIBELS
    else if ((db>=lowDecibelLimit)&&(db<highDecibelLimit)) {
      myPort.write('K');
      println("K");
    }
    // HIGH DECIBELS
    else if (db>=highDecibelLimit) {
      myPort.write('L');
      println("L");
    }
  }
}

// Creates a simple on screen numeric dislay of the co2 and decibel values
void displayValues(int co2, int db) {
  background(255, 69, 0);

  String displayC02Text = (co2 +" C02 (PPM)");
  String displayDecibelText = (db + " DECIBELS");
  text (displayC02Text, width/8, 350);
  text (displayDecibelText, width/8, 600);
  textAlign(LEFT);
}

