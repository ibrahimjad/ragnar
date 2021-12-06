// -------------------------------------------------------------
// CANtest for Teensy 3.6 dual CAN bus
// by Collin Kidder, Based on CANTest by Pawelsky (based on CANtest by teachop)
//
// Both buses are left at default 250k speed and the second bus sends frames to the first
// to do this properly you should have the two buses linked together. This sketch
// also assumes that you need to set enable pins active. Comment out if not using
// enable pins or set them to your correct pins.
//
// This sketch tests both buses as well as interrupt driven Rx and Tx. There are only
// two Tx buffers by default so sending 5 at a time forces the interrupt driven system
// to buffer the final three and send them via interrupts. All the while all Rx frames
// are internally saved to a software buffer by the interrupt handler.
//

// Mod by JDN  (oct 2019)
#include <FlexCAN.h>

#ifndef __MK66FX1M0__
#error "Teensy 3.6 with dual CAN bus is required to run this example"
#endif
FlexCAN Can0(1000000, 0, 1, 1);
FlexCAN Can1(1000000, 1, 1, 1);

static CAN_message_t msg;
static uint8_t hex[17] = "0123456789abcdef";

// -------------------------------------------------------------
static void hexDump(uint8_t dumpLen, uint8_t *bytePtr)
{
  uint8_t working;
  while ( dumpLen-- ) {
    working = *bytePtr++;
    Serial.write( hex[ working >> 4 ] );
    Serial.write( hex[ working & 15 ] );
  }
  Serial.write('\r');
  Serial.write('\n');
}


// -------------------------------------------------------------
void setup(void)
{
  delay(100);
  Serial.begin(57600);

  while (!Serial) ; // wait
  Serial.println("Hello Teensy 3.6 dual CAN Test.");

  pinMode(13, OUTPUT); // for blinking

  Can0.begin();
  Can1.begin();

  //if using enable pins on a transceiver they need to be set on
  pinMode(28, OUTPUT);
  pinMode(35, OUTPUT);

  digitalWrite(28, LOW);
  digitalWrite(35, LOW);

  msg.ext = 0;
  msg.id = 0x100;
  msg.len = 8;
  //msg.timeout = 0;
  msg.buf[0] = 10;
  msg.buf[1] = 20;
  msg.buf[2] = 0;
  msg.buf[3] = 100;
  msg.buf[4] = 128;
  msg.buf[5] = 64;
  msg.buf[6] = 32;
  msg.buf[7] = 16;
  Can1.write(msg);
  delay(20);

  Serial.println("bef start- wait two seconds");
  Serial.println (millis());
 Serial.print("timeout "); Serial.print(msg.timeout);
  delay(2000);
}

int loopC = 0, loop2 = 0;
int ccc = 0;
boolean ledT = true;
CAN_message_t inMsg;
// -------------------------------------------------------------
void loop(void)
{

  while (Can0.available())
  {
    Can0.read(inMsg);
    Can1.write(msg);
    //Serial.print(loopC++);
    //    Serial.print(" CAN bus 0:: "); hexDump(8, inMsg.buf);
    if ( 1000 < ++ccc) {
      ccc = 0;

      if (ledT) {
        digitalWrite(13, HIGH);
        ledT = !ledT;
      }
      else {
        digitalWrite(13, LOW);
        ledT = !ledT;
      }
    }
  }
  //  msg.buf[0]++;
  //  Can1.write(msg);
  //  msg.buf[0]++;
  //  Can1.write(msg);
  //  msg.buf[0]++;
  //  Can1.write(msg);
  //  msg.buf[0]++;
  //  Can1.write(msg);
  //  msg.buf[0]++;
  //  Can1.write(msg);
  Serial.println(loop2++);
  //delay(1);
}
