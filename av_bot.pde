//Arduino PWM Speed Control：
int E1 = 6;   
int M1 = 7;
int E2 = 5;                         
int M2 = 4;                           

int IRsensorF = 1;     // pin that the FRONT sensor is attached to
 
int sensorValue = 0;

void setup() 
{ 
    pinMode(M1, OUTPUT);   
    pinMode(M2, OUTPUT); 
    pinMode (IRsensorF, INPUT);
    
    // open the serial port at 9600 bps:
    Serial.begin(9600);

} 
 
void loop() 
{ 
  sensorValue = analogRead(IRsensorF);
  Serial.println(sensorValue);
 // while the front sensor reading is high, propel:
  while (analogRead(IRsensorF) >= 300) {
  sensorValue = analogRead(IRsensorF);
  Serial.print("Forward ");
  Serial.println(sensorValue); 
  forward();
  }
  
// while the front sensor reading is low, backwards:
  while (analogRead(IRsensorF) <= 300) {
  sensorValue = analogRead(IRsensorF);
  Serial.print("Backwards ");
  Serial.println(sensorValue); 
  stopmoter(1000);
  backwards(1000);
  turnleft(800);
  stopmoter(1000);
  
  }
 
}

void forward() {
  // turn on motor forward
  digitalWrite(M1,HIGH);   
  digitalWrite(M2, LOW); 
  analogWrite(E1, 100);   //PWM Speed Control
  analogWrite(E2, 100);   //PWM Speed Control
  }
  
void backwards(int time) {
  // turn on motor backwards
  digitalWrite(M1,LOW);   
  digitalWrite(M2, HIGH); 
  analogWrite(E1, 120);   //PWM Speed Control
  analogWrite(E2, 120);   //PWM Speed Control
  delay(time);
  }
  
void stopmoter(int time) {
  analogWrite(E1, 0);   //PWM Speed Control
  analogWrite(E2, 0);   //PWM Speed Control
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
