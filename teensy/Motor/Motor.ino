#include <FlexCAN.h>

FlexCAN Canbus0(1000000, 0, 1, 1);
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
  delay(1500);
  Serial.println("Hello world! - 1");
  Serial.send_now();

  rxmsg.id = 0x601; 
  rxmsg.len = 8; 
  rxmsg.ext = 0;
  rxmsg.buf[0] = 0x40; 
  rxmsg.buf[1] = 0x41; 
  rxmsg.buf[2] = 0x60; 
  rxmsg.buf[3] = 0x00; 
  rxmsg.buf[4] = 0x00; 
  rxmsg.buf[5] = 0x00; 
  rxmsg.buf[6] = 0x00; 
  rxmsg.buf[7] = 0x00; 
  

  Canbus0.begin();
  delay(2000);

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
  Canbus0.write(rxmsg);
  delay(20); 
  Serial.println("looping");
  Serial.send_now();
  while(Canbus0.available())
  {
    Canbus0.read(msg);
    Serial.println("Received");
    Serial.send_now();
    hexDump(msg.len, msg.buf);
    delay(200);
  }
  delay(1000);

}
