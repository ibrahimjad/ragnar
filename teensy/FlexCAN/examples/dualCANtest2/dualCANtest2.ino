// -------------------------------------------------------------
// CANtest for Teensy 3.6 dual CAN bus
// by Pawelsky (based on CANtest by teachop)
//
// This test transmits all data coming from CAN0 to CAN1 and vice versa (at 1Mbps)
//

#include <FlexCAN.h>

#ifndef __MK66FX1M0__
  #error "Teensy 3.6 with dual CAN bus is required to run this example"
#endif

FlexCAN CANbus0(1000000, 0, 1,1); // baud rate, id, txAlt, rxAlt
FlexCAN CANbus1(1000000, 1, 0,0);

static CAN_message_t msg0,msg1,msgTemp;
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
        while( dumpLen-- ) {
                working = *bytePtr++;
                Serial.write( hex[ working>>4 ] );
                Serial.write( hex[ working&15 ] );
        }
        Serial.write('\r');
        Serial.write('\n');
}

void initMsg()
{
        msg0.id = 124;
        msg1.id = 124;
        msg0.ext = 0;
        msg0.len= 8;
        msg1.ext = 0;
        msg1.len= 8;
        for (int i=0; i < 8; i++)
        {
                msg0.buf[i] = (uint8_t)(i);
                msg1.buf[i] = (uint8_t)(i*8);
        }
}

// -------------------------------------------------------------
void setup(void)
{
        CANbus0.begin();
        CANbus1.begin();

        pinMode(28,OUTPUT);
        pinMode(35,OUTPUT);
        delay(100);
        digitalWrite(28,LOW); // activate 230 canbus transciever for can0
        digitalWrite(35,LOW); // activate 230 canbus transciever for can1
        delay(500);

        Serial.println(F("Hello Teensy 3.6 dual CAN Test2."));
        initMsg();

        CANbus0.write(msg0);
        delay(100);

        Serial.println(F("first pack on way"));
}


// -------------------------------------------------------------
void loop(void)
{
        if(CANbus1.available())
        {
                CANbus1.read(msgTemp);
                Serial.print("CAN bus 1: "); hexDump(8, msgTemp.buf);
                CANbus1.write(msg1);
        }

        delay(100);

        if(CANbus0.available())
        {
                CANbus0.read(msgTemp);
                Serial.print("CAN bus 0: "); hexDump(8, msgTemp.buf);
                CANbus0.write(msg0);
        }
}
