
#include <FlexCAN.h>     // Pawelsky flex can library, used with Jens
#include <CAN.h>         // CAN message thing
#include <NANOTEC_Bus.h> // Handles the writing and receiving data in can format
#include <NANOTEC.h>     // Handles the specific motor controller registers and data

FlexCAN Canbus0(1000000, 0, 1, 1);

CAN canport(&Canbus0);   // take care of the writing and receiving data on CAN PORT
NANOTEC_CANOpen NANOTECCAN(&canport, &Serial); // Handle the data writing and reading operations 
// The following are the specific motor objects 
NANOTEC motor1(&canport, &Serial, (int8_t)1, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f, true); // platform specific constructor
NANOTEC motor2(&canport, &Serial, (int8_t)2, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f);       // platform specific constructor
NANOTEC motor3(&canport, &Serial, (int8_t)3, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f);       // platform specific constructor
NANOTEC motor4(&canport, &Serial, (int8_t)4, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f);       // platform specific constructor


static CAN_message_t msg,rxmsg;
static uint8_t hex[17] = "0123456789abcdef";

int txCount,rxCount;
unsigned int txTimer,rxTimer;
void setup() {
  // put your setup code here, to run once:
  pinMode(28,  OUTPUT);
  pinMode(35,  OUTPUT);
  digitalWrite(28, LOW); 
  digitalWrite(35, LOW);
  
  Serial.begin(115200);   

  Canbus0.begin();
  delay(2000);
  motor3.Configure();
  motor3.SetOutputTorque(0);
}
// -------------------------------------------------------------
static void hexDump(uint8_t dumpLen, uint8_t *bytePtr)
{
  uint8_t working;
  while( dumpLen-- ) {
    working = *bytePtr++;
    Serial.write( hex[ working>>4 ] );
    Serial.write( hex[ working&15 ] );
  }
  Serial.write('\r');
  Serial.write('\n');
}


void loop() {
  // put your main code here, to run repeatedly:
  delay(100);
  Serial.println(motor3.GetAngleDeg());
}
