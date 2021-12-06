// -------------------------------------------------------------
// CANtest for Teensy 3.6 dual CAN bus
// by Pawelsky (based on CANtest by teachop)
//
// This test transmits all data coming from CAN0 to CAN1 and vice versa (at 1Mbps)
//

// This sketch tests both buses as well as interrupt driven Rx and Tx. There are only
// two Tx buffers by default so sending 5 at a time forces the interrupt driven system
// to buffer the final three and send them via interrupts. All the while all Rx frames
// are internally saved to a software buffer by the interrupt handler.
// This means that the caller may return from the send function BEFORE all packages has been
// send.
//
//
//**************************************************
//
//   bus arbitrering 0(lav) er stærkere end 1(high)
//   adressen læses fra venstre mod hojre
//   00100000000
//   00010001000
// nederste adresse er stærkest og vinder i busarbitrering
//   dvsS
//   se bla https://en.wikipedia.org/wiki/CAN_bus
//typedef struct CAN_message_t {
//  uint32_t id; // can identifier
//  uint8_t ext; // identifier is extended
//  uint8_t len; // length of data
//  uint16_t timeout; // milliseconds, zero will disable waiting
//  uint8_t buf[8];
//} CAN_message_t;
//
//typedef struct CAN_filter_t {
//  uint8_t rtr;
//  uint8_t ext;
//  uint32_t id;
//} CAN_filter_t;
//
//// -------------------------------------------------------------
//class FlexCAN
//{
//private:
//  struct CAN_filter_t defaultMask;
//  uint32_t flexcanBase;
//
//public:
//  FlexCAN(uint32_t baud = 125000, uint8_t id = 0, uint8_t txAlt = 0, uint8_t rxAlt = 0);
//  void begin(const CAN_filter_t &mask);
//  inline void begin()
//  {
//    begin(defaultMask);
//  }
//  void setFilter(const CAN_filter_t &filter, uint8_t n);
//  void end(void);
//  int available(void);
//  int write(const CAN_message_t &msg);
//  int read(CAN_message_t &msg);
//
//};


#include <FlexCAN.h>

#ifndef __MK66FX1M0__
#error "Teensy 3.6 with dual CAN bus is required to run this example"
#endif

FlexCAN CANbus0(1000000, 0, 1, 1);
FlexCAN CANbus1(1000000, 1, 0, 0);

static CAN_message_t msg0, msg1;
static uint8_t hex[17] = "0123456789abcdef";

/*
   typedef struct CAN_message_t {
   uint32_t id; // can identifier
   uint8_t ext; // identifier is extended
   uint8_t len; // length of data
   uint16_t timeout; // milliseconds, zero will disable waiting
   uint8_t buf[8];
   } CAN_message_t;
*/
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

void initMsg()
{
  msg0.id = 123;
  msg0.ext = 0;
  msg0.len = 8;
  for (int i = 0; i < 8; i++)
  {
    msg0.buf[i] = (uint8_t)(i);
  }
  msg1 = msg0;
  msg1.id = 124;
}

// -------------------------------------------------------------
void setup(void)
{

  Serial.begin(115200);
  while (!Serial) ; // wait until initialized

  CANbus0.begin();
  CANbus1.begin();

  pinMode(28, OUTPUT);
  pinMode(35, OUTPUT);
  digitalWrite(28, LOW); // set CAN0 transceiver in fast mode - drawing high currents 
  digitalWrite(35, LOW); // set CAN1 transceiver in fast mode - drawing high currents
  delay(500);

  Serial.println(F("Hello Teensy 3.6 dual CAN Test2."));

  initMsg();

  CANbus0.write(msg0);  // let first package run

  delay(100);

  Serial.println(F("first pack on way"));
}


// -------------------------------------------------------------
void loop(void)
{
  if (CANbus1.available())   // read interface 1, add 1 to buf[0] and transmit again
  {
    CANbus1.read(msg1);
    Serial.print("CAN bus 1: ");
    hexDump(8, msg1.buf);
    msg1.buf[0]++;
    CANbus1.write(msg1);
  }

  delay(500);
 
  if (CANbus0.available())   // read interface 0, add 1 to buf[0] and transmit again
  {
    CANbus0.read(msg0);
    Serial.print("CAN bus 0: ");
    hexDump(8, msg0.buf);
    CANbus0.write(msg0);

  }
}
