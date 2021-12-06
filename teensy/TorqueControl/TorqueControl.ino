#include <FlexCAN.h>     // Pawelsky flex can library, used with Jens
#include <CAN.h>         // CAN message thing
#include <NANOTEC_Bus.h> // Handles the writing and receiving data in can format
#include <NANOTEC.h>     // Handles the specific motor controller registers and data

FlexCAN Canbus0(1000000, 0, 1, 1);
static CAN_message_t txmsg,rxmsg;
static bool receive = false;

CAN canport(&Canbus0);   // take care of the writing and receiving data on CAN PORT
NANOTEC_CANOpen teensy(&canport, &Serial);

// The following are the specific motor objects 
NANOTEC motor1(&canport, &Serial, (int8_t)1, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f, true);       // platform specific constructor
NANOTEC motor2(&canport, &Serial, (int8_t)2, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f, true);       // platform specific constructor
NANOTEC motor3(&canport, &Serial, (int8_t)3, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f, true);       // platform specific constructor
NANOTEC motor4(&canport, &Serial, (int8_t)4, 1.050f, (3.5f) / 4.2f, 60.0f / 14.0f, 10000, 60.0f, true);       // platform specific constructor

NANOTEC* motors[4] = {
    &motor1, &motor2, &motor3, &motor4
};

float angles[4];
float previousAngles[4];
float velocities[4];
float reference[8] = {0.5, 0.5, 0.5, 0.5, 0, 0, 0, 0};
//float feedback[8] = {-230.9401, -250.4995, -250.4995, -0.0828, -34.4133, -35.8128, -35.8128, -0.0123};
float feedback[8] = {-2.5, -2.5, -2.5, -2.5, -2.5, -2.5, -2.5, -2.5};
float measurement[8];

void SendSyncMessage()
{
  teensy._bus->WriteMessage(SYNC_COBID, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  receive = !receive;
}

float* calculate() {
  float arr[4];
  for (int i=0; i<4; i++) {
    arr[i] = ((measurement[i] - reference[i]) * feedback[i]) + ((measurement[i+4] - reference[i+4]) * feedback[i+4]);
  }
  Serial.println();

  return arr;
}

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
  for (int i=0; i<4; i++){
      motors[i]->Configure();
  }
}

double startMillis = 0;
double sendMillis = 0;
double receiveMillis = 0;
double previousMillis = 0;

void loop() {
  // put your main code here, to run repeatedly:
  delay(10);

  SendSyncMessage();
  previousMillis = startMillis;
  startMillis = micros();
  
  ////Serial.println("------------------------");
  ////Serial.println(receive ? "Receiving": "Sending");
  while(Canbus0.available()) {
    Canbus0.read(rxmsg);
    for (int i=0; i < 4; i++) {
      motors[i]->ReceivePDOS(&rxmsg);
      previousAngles[i] = angles[i];
      angles[i] = motors[i]->GetOutputAnglePDO();
      velocities[i] = ((angles[i] - previousAngles[i]))/((startMillis - previousMillis));
      //Serial.print("angle ");
      //Serial.print(i+1);
      //Serial.print(": ");
      //Serial.print(angles[i]);
      //Serial.print(" | ");

      if (velocities[i] > 0) {
        //Serial.print("velocity ");
        //Serial.print(i+1);
        //Serial.print(": ");
        //Serial.print(velocities[i]);
        //Serial.print(" | ");
      }
    }
    //Serial.println();
  }
  if (receive) {
      for (int i=0; i<4;i++) {
      measurement[i] = angles[i];
      measurement[i+4] = velocities[i];
    }
   receiveMillis = micros();
   Serial.print("Time to recieve data: ");
   Serial.println(receiveMillis-startMillis);
  }
  else {
    float controlSignal[4];
     for (int i=0; i<4; i++) {
      controlSignal[i] = ((measurement[i] - reference[i]) * feedback[i]) + ((measurement[i+4] - reference[i+4]) * feedback[i+4]);
      if (controlSignal[i] > 1){
        controlSignal[i] = 1;
      }
      if (controlSignal[i] < -1){
        controlSignal[i] = -1;
      }
      Serial.print("torque ");
      Serial.print(i+1);
      Serial.print(": ");
      Serial.print(controlSignal[i]);
      Serial.print(" | ");      
     }
     Serial.println();
     for (int i=0; i<4; i++) {
      float value = 0;
      if (controlSignal[i] > 1.8 || controlSignal[i] < -1.8) {
        value = 0;
      }
      else {
        value = controlSignal[i];
      }
      motors[i]->SetOutputTorquePDO(value);
     }
  sendMillis = micros ();
  Serial.print("Time to calculate+send signal: ");
  Serial.print(sendMillis-startMillis);
  Serial.print(" | ");
  }
}
