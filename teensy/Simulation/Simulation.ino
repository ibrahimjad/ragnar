#include <FlexCAN.h>     // Pawelsky flex can library, used with Jens
#include <CAN.h>         // CAN message thing
#include <NANOTEC_Bus.h> // Handles the writing and receiving data in can format
#include <NANOTEC.h>     // Handles the specific motor controller registers and data

FlexCAN Canbus0(1000000, 0, 1, 1);
static CAN_message_t txmsg, rxmsg;
IntervalTimer timer;
volatile bool receive = false;

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
float feedback[8] = { -230.9401, -250.4995, -250.4995, -0.0828, -34.4133, -35.8128, -35.8128, -0.0123};
//float feedback[8] = {-2.5, -2.5, -2.5, -2.5, -2.5, -2.5, -2.5, -2.5};
float measurement[8];
double startMillis = 0;
double previousMillis = 0;

void SendSyncMessage()
{
  teensy._bus->WriteMessage(SYNC_COBID, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  receive = true;
}

int txCount, rxCount;
unsigned int txTimer, rxTimer;

void setup() {
  // put your setup code here, to run once:
  pinMode(28,  OUTPUT);
  pinMode(35,  OUTPUT);
  digitalWrite(28, LOW);
  digitalWrite(35, LOW);

  Serial.begin(115200);

  Canbus0.begin();
  delay(2000);
  timer.begin(SendSyncMessage, 1000);
  for (int i = 0; i < 4; i++) {
    motors[i]->Configure();
  }
}

void Recv() {
  previousMillis = startMillis;
  startMillis = micros();

  while (Canbus0.available()) {
    Canbus0.read(rxmsg);
    Serial.println(rxmsg.id);
    for (int i = 0; i < 4; i++) {
      motors[i]->ReceivePDOS(&rxmsg);
      previousAngles[i] = angles[i];
      angles[i] = motors[i]->GetOutputAnglePDO();
      velocities[i] = ((angles[i] - previousAngles[i])) / ((startMillis - previousMillis));
      measurement[i] = angles[i];
      measurement[i + 4] = velocities[i];
    }
  }
}

void Calc() {
  for (int i = 0; i < 4; i++) {
    float controlSignal[4];
    controlSignal[i] = ((measurement[i] - reference[i]) * feedback[i]) + ((measurement[i + 4] - reference[i + 4]) * feedback[i + 4]);
  }
}

void Send() {
  for (int i = 0; i < 4; i++) {
    motors[i]->SetOutputTorquePDO(0.2);
  }
}

void loop() {
  Serial.print("Available: ");
  Serial.println(Canbus0.available());
  Recv();
  Serial.print("Not Available: ");
  Serial.println(Canbus0.available());
  Calc();
  Serial.print("Not Available: ");
  Serial.println(Canbus0.available());
  //Send();
  motors[0]->SetOutputTorquePDO(6);
  motors[1]->SetOutputTorquePDO(-6);
  motors[2]->SetOutputTorquePDO(-9);
  motors[3]->SetOutputTorquePDO(9);
  Serial.print("Not Available: ");
  Serial.println(Canbus0.available());
  if (receive) {
    SendSyncMessage();
    receive = false;
  }
  Serial.print("Not Available: ");
  Serial.println(Canbus0.available());
}
