/* Encoder Library - Basic Example
 * http://www.pjrc.com/teensy/td_libs_Encoder.html
 *
 * This example code is in the public domain.
 */

#include <Encoder.h>

// Change these two numbers to the pins connected to your encoder.
//   Best Performance: both pins have interrupt capability
//   Good Performance: only the first pin has interrupt capability
//   Low Performance:  neither pin has interrupt capability
Encoder p1(6, 7);
Encoder p2(8, 9);

int l1 = 2;
int r1 = 3;
int l2 = 4;
int r2 = 5;
//   avoid using pins with LEDs attached

void setup() {
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(l2, OUTPUT);
  pinMode(r2, OUTPUT);
  Serial.begin(9600);
  Serial.println("Basic Encoder Test:");
}

long oldPositionp1  = -999;
long oldPositionp2  = -999;

void loop() {
  long newPosition = p1.read();
  if (newPosition>oldPositionp1){
    digitalWrite(l1,HIGH);
    delay(1);
    digitalWrite(l1,LOW);
    delay(1);
  }
  else if (oldPositionp1>newPosition){
    digitalWrite(r1,HIGH);
    delay(1);
    digitalWrite(r1,LOW);
    delay(1);
  }
  oldPositionp1=newPosition;
  newPosition = p2.read();
  if (newPosition>oldPositionp2){
    digitalWrite(l2,HIGH);
    delay(1);
    digitalWrite(l2,LOW);
    delay(1);
  }
  else if (oldPositionp2>newPosition){
    digitalWrite(r2,HIGH);
    delay(1);
    digitalWrite(r2,LOW);
    delay(1);
  }
  oldPositionp2=newPosition;
}
