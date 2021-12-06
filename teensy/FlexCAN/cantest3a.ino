/*
 * 
 * CANTEST3 - timestamps in packages
   What is missing ?

  How to modify code so we get a timestamp when TX and when RX


  repeat "cantest2" in the code

  what is transmit time ?

 
      NOTE THAT WE ARE TX A NUMBR OF PKGs AND ARE TESTING IF WE DO RECEIVE ALL OF THEM - buffer testing
*/




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

// CAN0 1 Mbit/sec
//ID 0  (pin 29,30)
// txAlternative  if 1 use std pin 29 else pin 3
// rxAlternative  if 1 usestd pin30, else pin 4
FlexCAN Can0(1000000, 0, 1, 1);

// CAN1 1 Mbit/sec
// ID 1  (pin 34,35)
// txAlternative  pin 33 - no alternative bq pins sre not broken out on teensy 3.6
// rxAlternative  pin 34 -  no alternative bq pins sre not broken out on teensy 3.6

FlexCAN Can1(1000000, 1, 1, 1);

static CAN_message_t msg0, msg1;
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

int initCAN()
{
  //Setting pin 35 / 28 low enables high speed mode on the two transceivers
  pinMode(28, OUTPUT);
  pinMode(35, OUTPUT);

  digitalWrite(28, LOW);
  digitalWrite(35, LOW);

  Can0.begin();
  Can1.begin();

  return 0; // for future use
}


void putInt(CAN_message_t * pkg, int  val)
{
  memcpy(  (void *)&(pkg->buf[3]),(void *)&val, sizeof(int));}

void fetchInt(int *val, CAN_message_t * pkg)
{
  memcpy( (void *)val, (void *)&(pkg->buf[3]), sizeof(int));
}


int fillStdTlg()
{
  // fillin
  msg1.ext = 0;
  msg1.id = 0x100;
  msg1.len = 8;
  msg1.timeout = 0; // hm - what does timeout == 0 do in tx ?
  msg1.buf[0] = 10;
  msg1.buf[1] = 20;
  msg1.buf[2] = 0;
  msg1.buf[3] = 100;
  msg1.buf[4] = 128;
  msg1.buf[5] = 64;
  msg1.buf[6] = 32;
  msg1.buf[7] = 16;

  return 0; // ok - for future use
}

// -------------------------------------------------------------
void setup(void)
{
  delay(100);
  Serial.begin(57600);

  while (!Serial) ; // wait
  Serial.println("cantest2");

  pinMode(13, OUTPUT); // for blinking

  initCAN();
  fillStdTlg();


  Serial.println("bef start- wait two seconds");
  Serial.println (millis());
  delay(2000);

}


// -------------------------------------------------------------

void toggleLED13()
{
  static  boolean LED13 = false;
  if (LED13) {
    digitalWrite(13, HIGH);
  }
  else {
    digitalWrite(13, LOW);
  }
  LED13 = ! LED13;
}

void toogleLEDSlow()
{
  static int ccc = 0;
  ccc++;
  if ( 1000 < ccc) {
    ccc = 0;
    toggleLED13();
  }
}


int loopC = 0;
int maxNr = 1;
void loop(void)
{

  int txCount = 0, rxCount = 0;;


  msg1.timeout = 1;
  msg1.buf[0] = 0;

  Serial.println("BEF TX");
  for (int nr = 1; nr <= maxNr; nr++) {
//      putInt(&msg1,nr);
      putInt(&msg1,micros());
    if (1 == Can1.write(msg1)) { // MISSING returns 1 if msg is delivered to CAN controller. 0 if not !!!
      msg1.buf[0]++;
      txCount++;
      // what if we add a delay when we are using timeout== 1?
      delay(2);
    }

  }

  delay(500);  // just to sure network is silent


  Serial.println("BEF RX");
  for (int nr = 1; nr <= maxNr; nr++) {
    msg0.timeout = 0;
    if (1 == Can0.read(msg0)) {  // did you receive anything ? 1== yes
      int v;
      
      fetchInt(&v,&msg0);
      Serial.print("rx loop nr "); Serial.print(nr); Serial.print(" "); Serial.println(v);
      rxCount++;
    }
  }
  Serial.println("===");
  Serial.print("TX pkg teor "); Serial.println(maxNr);
  Serial.print("TX pkg real "); Serial.println(txCount);
  Serial.print("TX pkg real "); Serial.println(rxCount);


  delay(500);
  maxNr++;

  if (20 < maxNr)
    maxNr = 1;
}
