/*
 * This is a simple sketch that receives characters from processing over serial and drives
 * a relay shield according to the character it receives.
 * The relay shield used is this one:http://www.seeedstudio.com/depot/relay-shield-p-693.html?cPath=132_134
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

//unsigned char relayPin[4] = {4,5,6,7};
unsigned char aRelayPin = 5;
unsigned char bRelayPin = 6;
unsigned char cRelayPin = 7;

int val;
void setup()
{
  Serial.begin(9600);
  //int i;
  //for(i = 0; i < 4; i++)
  //{
  pinMode(aRelayPin,OUTPUT);
  pinMode(bRelayPin,OUTPUT);
  pinMode(cRelayPin,OUTPUT);
  //}
}

//just an simple demo to close and open 4 relays
// every other 1s.
void loop()
{
  val = Serial.read();
  switch (val)
  {
  case 'A':
    modeA();
    break;
  case 'B':
    modeB();
    break;
  case 'C':
    modeC();
    break;
  case 'D':
    modeD();
    break;
  case 'E':
    modeE();
    break;
  case 'F':
    modeF();
    break;
  case 'G':
    modeG();
    break;
  case 'H':
    modeH();
    break;
  case 'I':
    modeI();
    break;
  case 'J':
    modeJ();
    break;
  case 'K':
    modeK();
    break;
  case 'L':
    modeL();
    break;
  default:
  
    digitalWrite(aRelayPin,HIGH);
    digitalWrite(bRelayPin,LOW);
    digitalWrite(cRelayPin,LOW);
    delay(1500);
    digitalWrite(aRelayPin, LOW);
    delay(4000);
  }
}
void modeA(){
  //co2 NO breathing + LOW volume
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay (4000);
}
void modeB(){
  //co2 NO breathing + MEDIUM volume
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(4000);
}
void modeC(){
  //co2 NO breathing + HIGH volume
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(4000);
}
void modeD(){
  //co2 SLOW breathing + LOW volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay(4000);
  digitalWrite(aRelayPin,LOW);
   digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay(4000);
}

void modeE(){
  //co2 SLOW breathing + MEDIUM volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(4000);
  digitalWrite(aRelayPin,LOW);
   digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(4000);
}

void modeF(){
  //co2 SLOW + HIGH volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(4000);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(4000);
}

void modeG(){
  //co2 MEDIUM + LOW volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay(2000);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay(2000);
}
void modeH(){
  //co2 MEDIUM + MEDIUM volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(2000);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(2000);
}
void modeI(){
  //co2 MEDIUM + HIGH volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(2000);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(2000);
}

void modeJ(){
  //co2 FAST + LOW volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay(1000);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, LOW);
  digitalWrite(bRelayPin, LOW);
  delay(1000);
}
void modeK(){
  //co2 FAST + MEDIUM volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(1000);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, LOW);
  delay(1000);
}

void modeL(){
  //co2 FAST + HIGH volume
  digitalWrite(aRelayPin,HIGH);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(500);
  digitalWrite(aRelayPin,LOW);
  digitalWrite(cRelayPin, HIGH);
  digitalWrite(bRelayPin, HIGH);
  delay(1000);
}



