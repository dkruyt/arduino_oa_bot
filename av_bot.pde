

//Arduino PWM Speed Control：
const int E1 = 6;   
const int M1 = 7;
const int E2 = 5;                         
const int M2 = 4;                           

//IR sensors
const int IRsensorFm = 2;     // pin that the FRONT middle sensor is attached to
const int IRsensorFl = 1;     // pin that the FRONT left sensor is attached to
const int IRsensorFr = 0;     // pin that the FRONT right sensor is attached to

int sensorValue = 0;

// LED pin
const int ledPin =  13;      // the number of the LED pin

void setup() 
{ 
    pinMode(M1, OUTPUT);   
    pinMode(M2, OUTPUT);
    
    pinMode (IRsensorFm, INPUT);
    pinMode (IRsensorFl, INPUT);
    pinMode (IRsensorFr, INPUT);
    
    pinMode(ledPin, OUTPUT);
    digitalWrite(ledPin, LOW);
    
    // open the serial port:
    Serial.begin(19200);
    delay(1000);
    Serial.println("I am alive!");

} 
 
void loop() 
{ 
  delay(20);
  // while the front sensor reading is low, backwards:
  if (analogRead(IRsensorFm) <= 300) {
  sensorValue = analogRead(IRsensorFm);
  //Serial.println(sensorValue);
  digitalWrite(ledPin, HIGH); 
  stopmoter(1000);
  backwards(400);
  turnleft(800);
  stopmoter(1000);
  }
  else if (analogRead(IRsensorFl) <= 300) {
  digitalWrite(ledPin, HIGH);
  stopmoter(1000);
  backwards(400);
  stopmoter(100);
  turnright(400);
  stopmoter(1000);
  }
  else if (analogRead(IRsensorFr) <= 300) {
  digitalWrite(ledPin, HIGH);  
  stopmoter(1000);
  backwards(400);
  stopmoter(100);
  turnleft(400);
  stopmoter(1000);
  }
  else {
  digitalWrite(ledPin, LOW); 
  forward();  // No obstacle detected, so move forward
  }
}

void forward() {
  // turn on motor forward
  digitalWrite(M1,HIGH);   
  digitalWrite(M2, LOW); 
  analogWrite(E1, 140);   //PWM Speed Control
  analogWrite(E2, 140);   //PWM Speed Control
  }
  
void backwards(int time) {
  // turn on motor backwards
  digitalWrite(M1,LOW);   
  digitalWrite(M2, HIGH); 
  analogWrite(E1, 120);   //PWM Speed Control
  analogWrite(E2, 120);   //PWM Speed Control
  Serial.println("Backwards");
  delay(time);
  }
  
void stopmoter(int time) {
  analogWrite(E1, 0);   //PWM Speed Control
  analogWrite(E2, 0);   //PWM Speed Control
  Serial.println("Stop");
  delay(time);
}

void turnleft(int time) {
  // turn on motor backwards
  digitalWrite(M1,HIGH);   
  digitalWrite(M2, HIGH); 
  analogWrite(E1, 150);   //PWM Speed Control
  analogWrite(E2, 150);   //PWM Speed Control
  Serial.println("turnleft"); 
  delay(time);
  }
  
void turnright(int time) {
  // turn on motor backwards
  digitalWrite(M1,LOW);   
  digitalWrite(M2, LOW); 
  analogWrite(E1, 120);   //PWM Speed Control
  analogWrite(E2, 120);   //PWM Speed Control
  Serial.println("turnright"); 
  delay(time);
  }
