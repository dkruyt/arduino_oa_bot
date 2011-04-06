//Robot Code

// servo
#include <Servo.h> 
Servo myservo;  // create servo object to control a servo
int pos = 0;    // variable to store the servo position 

int PosValue[] = {15,40,145,180};

int h;

int Sensor[4];
int j,Maximum,Position;

// sonar code, mostly taken from luckylarry.co.uk
const int numOfReadings = 10;                   // number of readings to take/ items in the array
int readings[numOfReadings];                    // stores the distance readings in an array
int arrayIndex = 0;                             // arrayIndex of the current item in the array
int total = 0;                                  // stores the cumlative total
int averageDistance = 0;                        // stores the average value
// setup pins and variables for SRF05 sonar device
int echoPin = 2;                                // SRF05 echo pin (digital 2)
int initPin = 3;                                // SRF05 trigger pin (digital 3)
unsigned long pulseTime = 0;                    // stores the pulse in Micro Seconds
unsigned long distance = 0;                     // variable for storing the distance (cm)

//Arduino PWM Speed Control based upon code from dfrobot：
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
const int ledPin =  13;

void setup() 
{ 
    myservo.attach(11);  // attaches the servo on pin 11 to the servo object 
     
    pinMode(initPin, OUTPUT);                     // set init pin 3 as output
    pinMode(echoPin, INPUT);                      // set echo pin 2 as input 
     
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

  // create array loop to iterate over every item in the array
  for (int thisReading = 0; thisReading < numOfReadings; thisReading++) {
readings[thisReading] = 0;
 }
} 
 
void loop() 
{ 
  // while the front middle sensor reading is low
  if (analogRead(IRsensorFm) <= 300) {
  sensorValue = analogRead(IRsensorFm);
  //Serial.println(sensorValue);
  digitalWrite(ledPin, HIGH); 
  //stopmoter(1000);
  //backwards(400);
  //turnleft(800);
  //stopmoter(1000);
  
   stopmoter(1000);
   backwards(800);
   stopmoter(500);
   
   // Start sensor sweep
   
   for(j=0;j<4;j++){ 
   delay(500);
   myservo.write(PosValue[j]);
   delay(1000);
   for(h=0;h<10;h++){ 
   digitalWrite(initPin, HIGH);                    // send 10 microsecond pulse
   delayMicroseconds(10);                  // wait 10 microseconds before turning off
   digitalWrite(initPin, LOW);                     // stop sending the pulse
   pulseTime = pulseIn(echoPin, HIGH);             // Look for a return pulse, it should be high as the pulse goes low-high-low
   distance = pulseTime/58;                        // Distance = pulse time / 58 to convert to cm.
   total= total - readings[arrayIndex];           // subtract the last distance
   readings[arrayIndex] = distance;                // add distance reading to array
   total= total + readings[arrayIndex];            // add the reading to the total
   arrayIndex = arrayIndex + 1;                    // go to the next item in the array
   // At the end of the array (10 items) then start again
   if (arrayIndex >= numOfReadings)  {
     arrayIndex = 0;
    }
   averageDistance = total / numOfReadings;      // calculate the average distance
   }
   Sensor[j]=averageDistance;
   Serial.print("Start sweep");
   Serial.print(j);
   Serial.print(" ");
   Serial.println(averageDistance, DEC); 
   }
   Position=MAX_Point();
   switch(Position){
      case 0: Serial.println("go 0");turnleft(750);; break;
      case 1: Serial.println("go 1");turnleft(450);; break;
      case 2: Serial.println("go 2");turnright(450);; break;
      case 3: Serial.println("go 3");turnright(750);; break;
   }
   stopmoter(200);
  }
  // while the front left sensor reading is low
  else if (analogRead(IRsensorFl) <= 300) {
  digitalWrite(ledPin, HIGH);
  stopmoter(1000);
  backwards(400);
  stopmoter(100);
  turnright(400);
  stopmoter(1000);
  }
  // while the front right sensor reading is low
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
 
  //myservo.write(165);              // tell servo to go to position in variable 'pos' 
  //delay(1000);
  
  }
}

int MAX_Point(){
  int i,Old=0,max_;
  for(i=0;i<4;i++){ 
  if(Sensor[i]>Old){
  Old=Sensor[i]; max_=i;
      }
    } 
  Maximum=Old; 
  return(max_);
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
