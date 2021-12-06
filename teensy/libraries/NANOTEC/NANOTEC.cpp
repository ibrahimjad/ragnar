/* Copyright (C) 2019-2020 Juan de Dios Flores Mendez. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the MIT License
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the MIT License for further details.
 *
 * Contact information
 * ------------------------------------------
 * Juan de Dios Flores Mendez
 * e-mail   :  juan.dios.flores@gmail.com
 * ------------------------------------------
 */

#include "NANOTEC.h"

NANOTEC::NANOTEC(CAN *bus, Stream *port, uint8_t nodeid, float MaxCurrent, float TorqueConstant, float GearRatio, uint32_t EncoderTicksPrRev, float MaxMotorSpeed, bool configPDOS) : NANOTEC_MAX_AMP_SETPOINT(MaxCurrent),
                                                                                                                                                                                      MOTOR_TORQUE_CONSTANT(TorqueConstant),
                                                                                                                                                                                      GEARING_RATIO(GearRatio),
                                                                                                                                                                                      ENCODER_TICKS_PR_REV(EncoderTicksPrRev),
                                                                                                                                                                                      NANOTEC_MAX_RAD_PR_SEC(MaxMotorSpeed),
                                                                                                                                                                                      _serialport(port),
                                                                                                                                                                                      _nodeid(nodeid),
                                                                                                                                                                                      _configPDOS(configPDOS),
                                                                                                                                                                                      _deleteObjectsAtDestruction(false),
                                                                                                                                                                                      _configured(false),
                                                                                                                                                                                      _configuredPDOS(false)
{
    _nanotecbus = new NANOTEC_CANOpen(bus, _serialport);
    // _configured = Configure();
    // uint8_t tries = 5;
    // if (configPDOS)
    // {
    //     while (tries < 5)
    //     {
    //         _configuredPDOS = ConfigurePDOS();
    //         if (_configuredPDOS)
    //         {
    //             break;
    //         }
    //         tries++;
    //     }
    // }
    // SetTorque(0);
    // Disable();
}

NANOTEC::NANOTEC(CAN *bus, Stream *port, int8_t MotorIndex, float MaxCurrent, float TorqueConstant, float GearRatio, uint32_t EncoderTicksPrRev, float MaxMotorSpeed, bool configPDOS) : NANOTEC_MAX_AMP_SETPOINT(MaxCurrent),
                                                                                                                                                                                         MOTOR_TORQUE_CONSTANT(TorqueConstant),
                                                                                                                                                                                         GEARING_RATIO(GearRatio),
                                                                                                                                                                                         ENCODER_TICKS_PR_REV(EncoderTicksPrRev),
                                                                                                                                                                                         NANOTEC_MAX_RAD_PR_SEC(MaxMotorSpeed),
                                                                                                                                                                                         _serialport(port),
                                                                                                                                                                                         _nodeid(0),
                                                                                                                                                                                         _configPDOS(configPDOS),
                                                                                                                                                                                         _deleteObjectsAtDestruction(false),
                                                                                                                                                                                         _configured(false),
                                                                                                                                                                                         _configuredPDOS(false)
{
    _nanotecbus = new NANOTEC_CANOpen(bus, _serialport);
    // Instantiate periphiral objects according to selected motor index
    if (MotorIndex == 1)
        _nodeid = 0x1;
    else if (MotorIndex == 2)
        _nodeid = 0x2;
    else if (MotorIndex == 3)
        _nodeid = 0x3;
    else if (MotorIndex == 4)
        _nodeid = 0x4;
    else
    {
        // Error message
        // ERROR("Incorrect motor index");s
        return;
    }
    // _configured = Configure();
    // uint8_t tries = 5;
    // if (configPDOS)
    // {
    //     while (tries < 5)
    //     {
    //         _configuredPDOS = ConfigurePDOS();
    //         if (_configuredPDOS)
    //             break;

    //         tries++;
    //     }
    // }
    // SetTorque(0);
    // Disable();
}

NANOTEC::~NANOTEC()
{
    if (_deleteObjectsAtDestruction)
        if (_nanotecbus)
            delete (_nanotecbus);
}

void NANOTEC::Enable()
{
    // check if it is configured
    if (!_configured)
    {
        _configured = Configure();
    }
    // set to switch on
}

void NANOTEC::Disable()
{
    // check if it is configured
    if (!_configured)
    {
        _configured = Configure();
    }
    // set to ready to switch on. Follow diagram of state machine
}

bool NANOTEC::ResetNode()
{
    _nanotecbus->_bus->WriteMessage(CAN_NMT, 2, CAN_RESET_NODE, _nodeid, 0, 0, 0, 0, 0, 0);
    delay(1);
    bool replied = _nanotecbus->waitForId(0x700 + _nodeid, true, 10000);
    delay(1000);
    // this is a message object to hold incoming messages
    CAN_message_t inMsg1;
    while (_nanotecbus->_bus->isAvailable())
    { //Clear out the canbus
        _nanotecbus->_bus->Read(inMsg1);
        _nanotecbus->hexDumpAll(inMsg1);
        //   hexDumpAll(inMsg1, &Serial);
    }
    return replied;
}

bool NANOTEC::ActivateNode()
{
    _nanotecbus->_bus->WriteMessage(CAN_NMT, 2, CAN_SWITCH_TO_OPERATIONAL, _nodeid, 0, 0, 0, 0, 0, 0);
    delay(1);
    bool replied = _nanotecbus->waitForId(0x700 + _nodeid, true, 10000);
    delay(1000);
    // this is a message object to hold incoming messages
    CAN_message_t inMsg1;
    while (_nanotecbus->_bus->isAvailable())
    { //Clear out the canbus
        _nanotecbus->_bus->Read(inMsg1);
        _nanotecbus->hexDumpAll(inMsg1);
        //   hexDumpAll(inMsg1, &Serial);
    }
    return replied;
}

bool NANOTEC::PreoperationalNode()
{
    _nanotecbus->_bus->WriteMessage(CAN_NMT, 2, CAN_SWITCH_TO_PREOPERATIONAL, _nodeid, 0, 0, 0, 0, 0, 0);
    delay(1);
    bool replied = _nanotecbus->waitForId(0x700 + _nodeid, true, 10000);
    delay(1000);
    // this is a message object to hold incoming messages
    CAN_message_t inMsg1;
    while (_nanotecbus->_bus->isAvailable())
    { //Clear out the canbus
        _nanotecbus->_bus->Read(inMsg1);
        _nanotecbus->hexDumpAll(inMsg1);
        //   hexDumpAll(inMsg1, &Serial);
    }
    return replied;
}

bool NANOTEC::DeactivatePDOs()
{
    TransmitPDO1CommunicationParameter_1_DataType data_ = 0x01 << 31; // set the bit 31 to 1 of communication parameter of TPDO
    uint16_t pdoid = 0x180;
    data_ += pdoid + _nodeid;
    bool pdo1 = _nanotecbus->writeRegister(_nodeid, TransmitPDO1CommunicationParameter,
                                           TransmitPDO1CommunicationParameter_1, data_);
    TransmitPDO2CommunicationParameter_1_DataType data_2 = 0x01 << 31; // set the bit 31 to 1 of communication parameter of TPDO
    pdoid = 0x280;
    data_2 += pdoid + _nodeid; // complete the cobid data
    bool pdo2 = _nanotecbus->writeRegister(_nodeid, TransmitPDO2CommunicationParameter,
                                           TransmitPDO2CommunicationParameter_1, data_2);
    TransmitPDO3CommunicationParameter_1_DataType data_3 = 0x01 << 31; // set the bit 31 to 1 of communication parameter of TPDO
    pdoid = 0x380;
    data_3 += pdoid + _nodeid; // complete the cobid data
    bool pdo3 = _nanotecbus->writeRegister(_nodeid, TransmitPDO3CommunicationParameter,
                                           TransmitPDO3CommunicationParameter_1, data_3);
    TransmitPDO4CommunicationParameter_1_DataType data_4 = 0x01 << 31; // set the bit 31 to 1 of communication parameter of TPDO
    pdoid = 0x480;
    data_4 += pdoid + _nodeid; // complete the cobid data
    bool pdo4 = _nanotecbus->writeRegister(_nodeid, TransmitPDO4CommunicationParameter,
                                           TransmitPDO4CommunicationParameter_1, data_4);

    ReceivePDO1CommunicationParameter_1_DataType data_5 = 0x01 << 31; // set the bit 31 to 1 of communication parameter of TPDO
    pdoid = 0x200;
    data_5 += pdoid + _nodeid; // complete the cobid data
    bool pdo5 = _nanotecbus->writeRegister(_nodeid, ReceivePDO1CommunicationParameter,
                                           ReceivePDO1CommunicationParameter_1, data_5);
    ReceivePDO2CommunicationParameter_1_DataType data_6 = 0x01 << 31; // set the bit 31 to 1 of communication parameter of TPDO
    pdoid = 0x300;
    data_6 += pdoid + _nodeid; // complete the cobid data
    bool pdo6 = _nanotecbus->writeRegister(_nodeid, ReceivePDO2CommunicationParameter,
                                           ReceivePDO2CommunicationParameter_1, data_6);
    return pdo1 || pdo2 || pdo3 || pdo4 || pdo5 || pdo6;
}

bool NANOTEC::ActivatePDOs()
{
    TransmitPDO1CommunicationParameter_1_DataType data_ = 0x0 << 31; // set the bit 31 to 0 of communication parameter of TPDO
    uint16_t pdoid = 0x180;
    data_ += pdoid + _nodeid;
    bool pdo1 = _nanotecbus->writeRegister(_nodeid, TransmitPDO1CommunicationParameter,
                                           TransmitPDO1CommunicationParameter_1, data_);
    TransmitPDO2CommunicationParameter_1_DataType data_2 = 0x0 << 31; // set the bit 31 to 0 of communication parameter of TPDO
    pdoid = 0x280;
    data_2 += pdoid + _nodeid; // complete the cobid data
    bool pdo2 = _nanotecbus->writeRegister(_nodeid, TransmitPDO2CommunicationParameter,
                                           TransmitPDO2CommunicationParameter_1, data_2);
    ReceivePDO1CommunicationParameter_1_DataType data_3 = 0x0 << 31; // set the bit 31 to 0 of communication parameter of RPDO
    pdoid = 0x200;
    data_3 += pdoid + _nodeid; // complete the cobid data
    bool pdo3 = _nanotecbus->writeRegister(_nodeid, ReceivePDO1CommunicationParameter,
                                           ReceivePDO1CommunicationParameter_1, data_3);
    ReceivePDO2CommunicationParameter_1_DataType data_4 = 0x0 << 31; // set the bit 31 to 0 of communication parameter of RPDO
    pdoid = 0x300;
    data_4 += pdoid + _nodeid; // complete the cobid data
    bool pdo4 = _nanotecbus->writeRegister(_nodeid, ReceivePDO2CommunicationParameter,
                                           ReceivePDO2CommunicationParameter_1, data_4);
    return pdo1 || pdo2 || pdo3 || pdo4;
}

bool NANOTEC::Configure()
{
    _serialport->print("Configuring motor node ");
    _serialport->println(_nodeid);
    // _serialport->send_now();
    // Run the configuration of the motor
    ResetNode();
    // Turn to preoperational to turn off all the PDOS
    PreoperationalNode();
    // Deactivate PDOs in an appropiate manner
    DeactivatePDOs();

    if (_configPDOS)
        _configuredPDOS = ConfigurePDOS();
    /* A fault can be triggered if the voltage in the motor comes 
       after the voltage in the controller */
    // Reset Fault
    ResetFault();
    // Exit Fault
    ExitFault();
    // Save initial encoder settings just in case
    GetEncoderUnitsBoot();
    // Set Encoder Settings according to configuration
    SetEncoderUnits();
    // Get boot encoder
    GetEncoderBootRaw();
    // Set Torque Settings
    SetTorqueSettings();
    // Activate the Node
    ActivateNode();
    // Turn on the motor
    ActivateStateMachine();
    _configured = true;
    if (_configPDOS && _configuredPDOS)
        // SendSyncMessage();
    return true;
}

bool NANOTEC::ActivateStateMachine()
{
    Controlword_DataType control_status = 0x06;
    _serialport->println("Ready to switch on");
    _nanotecbus->writeRegister(_nodeid, Controlword, 0x0, control_status);
    delay(50);
    _serialport->println("Switch on");
    control_status = 0x07;
    _nanotecbus->writeRegister(_nodeid, Controlword, 0x0, control_status);
    delay(50);
    _serialport->println("Operation enable");
    control_status = 0xF;
    _nanotecbus->writeRegister(_nodeid, Controlword, 0x0, control_status);
    return true;
}
int32_t NANOTEC::GetEncoderRawPDO()
{
    return _posMotorUnits;
}
bool NANOTEC::SetTorqueSettings()
{
    /* Set to torque mode */
    // Change the control word to profile torque mode
    // Modes of operation object 0x6060
    Modesofoperation_DataType torque_mode = 0x04;
    _nanotecbus->writeRegister(_nodeid, Modesofoperation, 0x0, torque_mode);
    _serialport->println("Setting max torque");
    // maximum torqe 1000 equivalent to 100 percent
    Maxtorque_DataType max_torque = 1000;
    _nanotecbus->writeRegister(_nodeid, Maxtorque, 0x0, max_torque);
    _serialport->println("Reading rated current");
    I2tParameters_1_DataType rated_current = 0;
    _nanotecbus->readRegister(_nodeid, I2tParameters, I2tParameters_1, &rated_current);
    _serialport->print("Read ");
    _serialport->println(rated_current);
    _serialport->print("Writing rated current to ");
    /* this is a second premultiplier for torque
     torque is set as a percentage of this rated currrent
     from motor specs example 3 Amps 4 Nm
     if set to 1 Amps then max torque 4*1/3 */
    rated_current = 0x41A; // 1050 mA
    rated_current = (uint32_t)(NANOTEC_MAX_AMP_SETPOINT * 1000.0f);
    _serialport->print(rated_current);
    _serialport->println(" mA");
    _nanotecbus->writeRegister(_nodeid, I2tParameters, I2tParameters_1, rated_current);
    delay(50);
    _serialport->println("Writing duration peak current");
    I2tParameters_2_DataType peak_duration = 0x64;
    _nanotecbus->writeRegister(_nodeid, I2tParameters, I2tParameters_2, peak_duration);
    delay(50);
    // this set how fast the torque is changed
    _serialport->println("Setting torque ramp to 1000%/sec");
    Torqueslope_DataType slope_ramp = 20000; //0x2710; // 10000 , tenth of percent
    _nanotecbus->writeRegister(_nodeid, Torqueslope, 0x0, slope_ramp);
    _nanotecbus->readRegister(_nodeid, Torqueslope, 0x0, &slope_ramp);
    delay(50);
    // while(1);
    // set torque to zero
    // targettorqueindex = 0x6071
    Targettorque_DataType target_torque = 0;
    _serialport->println("Setting torque to zero");
    _nanotecbus->writeRegister(_nodeid, Targettorque, 0x0, target_torque);
    return true;
}
bool NANOTEC::SetEncoderUnits()
{
    _nanotecbus->writeRegister(_nodeid, Positionencoderresolution, Positionencoderresolution_1,
                               ENCODER_TICKS_PR_REV);
    delay(10);
    /* Set motor revolutions 0x1 = 1 */
    _nanotecbus->writeRegister(_nodeid, Positionencoderresolution, Positionencoderresolution_2,
                               (Positionencoderresolution_2_DataType)1);
    delay(10);
    return true;
}

bool NANOTEC::GetEncoderUnits()
{
    _nanotecbus->readRegister(_nodeid, Positionencoderresolution, Positionencoderresolution_1,
                              &encoderIncrements);
    _nanotecbus->readRegister(_nodeid, Positionencoderresolution, Positionencoderresolution_2,
                              &motorRevolutions);
    return true;
}

bool NANOTEC::GetEncoderUnitsBoot()
{
    _nanotecbus->readRegister(_nodeid, Positionencoderresolution, Positionencoderresolution_1,
                              &_encoderIncrementsBoot);
    _nanotecbus->readRegister(_nodeid, Positionencoderresolution, Positionencoderresolution_2,
                              &_motorRevolutionsBoot);
    return true;
}

uint32_t NANOTEC::GetEncoderBootRaw()
{
    _nanotecbus->readRegister(_nodeid, EncoderBootValue, 0x0,
                              &_encoderBoot);
    return _encoderBoot;
}

bool NANOTEC::ResetFault()
{
    bool replied = _nanotecbus->writeRegister(_nodeid, Controlword, 0x0,
                                              (uint16_t)0x06);
    delay(29);
    CAN_message_t inMsg;
    while (_nanotecbus->_bus->isAvailable())
    { //Clear out the canbus
        _nanotecbus->_bus->Read(inMsg);
        _nanotecbus->hexDumpAll(inMsg);
        //   hexDumpAll(inMsg1, &Serial);
    }
    return replied;
}
bool NANOTEC::ExitFault()
{
    bool replied = _nanotecbus->writeRegister(_nodeid, Controlword, 0x0,
                                              (uint16_t)B10000110);
    delay(29);
    CAN_message_t inMsg;
    while (_nanotecbus->_bus->isAvailable())
    { //Clear out the canbus
        _nanotecbus->_bus->Read(inMsg);
        _nanotecbus->hexDumpAll(inMsg);
        //   hexDumpAll(inMsg1, &Serial);
    }
    return replied;
}
bool NANOTEC::ConfigurePDOS()
{
    /* This need to execute when the motors is in stop or preoperational state */
    _serialport->println("Set a new Sync COBID");
    // _serialport->send_now();
    /* variable sync_cobid is chosen. It is the synchronize message */
    _nanotecbus->writeRegister(_nodeid, COB_IDSync, 0x0, (COB_IDSync_DataType)SYNC_COBID);
    /* Set TPDO1 and TPDO2 */
    /* Every two sync messages it will send data*/
    TransmitPDO1CommunicationParameter_2_DataType transmissionType = 0x02;
    /* Wait 0 miliseconds to react */
    TransmitPDO1CommunicationParameter_3_DataType inhibitTime = 0x0;
    _serialport->println("Writing Transmission type TPDO1");
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1CommunicationParameter,
                               TransmitPDO1CommunicationParameter_2, transmissionType);
    _serialport->println("Writing Inhibit time TPDO1");
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1CommunicationParameter,
                               TransmitPDO1CommunicationParameter_3, inhibitTime);
    _serialport->println("Writing Transmission type TPDO2");
    // transmit process data object 2
    _nanotecbus->writeRegister(_nodeid, TransmitPDO2CommunicationParameter,
                               TransmitPDO2CommunicationParameter_2, transmissionType);
    _serialport->println("Writing Inhibit time TPDO2");
    // transmit process data object 2 parameters
    _nanotecbus->writeRegister(_nodeid, TransmitPDO2CommunicationParameter,
                               TransmitPDO2CommunicationParameter_3, inhibitTime);
    /* Remap TPDO1 and TPDO2
       TPDO_1 mapping: Status word 16 bits
                       Modes of operation display 8 bits
                       Position actual value 32 bits */
    _serialport->println("Deactivate TPDO1 number of entries to 0");
    TransmitPDO1MappingParameter_0_DataType numberOfEntries = 0;
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1MappingParameter,
                               TransmitPDO1MappingParameter_0, numberOfEntries);
    _serialport->println("Remap TPDO1_1 to statusword");
    TransmitPDO1MappingParameter_1_DataType datatpdo1_1;
    datatpdo1_1 = (Statusword << 16) + (0x0 << 8);
    datatpdo1_1 += (uint8_t)16; //Statusword is 16 bits long
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1MappingParameter,
                               TransmitPDO1MappingParameter_1, datatpdo1_1);
    _serialport->println("Remap TPDO1_2 to modes of operation display");
    TransmitPDO1MappingParameter_2_DataType datatpdo1_2;
    datatpdo1_2 = (Modesofoperationdisplay << 16) + (0x0 << 8);
    datatpdo1_2 += 8; //ModesOfOperationDisplay is 8 bits long
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1MappingParameter,
                               TransmitPDO1MappingParameter_2, datatpdo1_2);
    _serialport->println("Remap TPDO1_3 to position actual value");
    TransmitPDO1MappingParameter_3_DataType datatpdo1_3;
    datatpdo1_3 = (Positionactualvalue << 16) + (0x0 << 8);
    datatpdo1_3 += 32; //PositionActualValue is 32 bits long
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1MappingParameter,
                               TransmitPDO1MappingParameter_3, datatpdo1_3);
    _serialport->println("Reactivate number of entries TPDO1");
    numberOfEntries = 3;
    _nanotecbus->writeRegister(_nodeid, TransmitPDO1MappingParameter,
                               TransmitPDO1MappingParameter_0, numberOfEntries);
    /* TPDO_2 mapping: Actual torque */
    _serialport->println("Deactivate TPDO2 number of entries to 0");
    numberOfEntries = 0;
    _nanotecbus->writeRegister(_nodeid, TransmitPDO2MappingParameter,
                               TransmitPDO2MappingParameter_0, numberOfEntries);
    _serialport->println("Remap TPDO2_1 to torque actual value");
    TransmitPDO2MappingParameter_1_DataType datatpdo2_1;
    datatpdo2_1 = (Torqueactualvalue << 16) + (0x0 << 8);
    datatpdo2_1 += 16; //Statusword is 16 bits long
    _nanotecbus->writeRegister(_nodeid, TransmitPDO2MappingParameter,
                               TransmitPDO2MappingParameter_1, datatpdo2_1);
    _serialport->println("Reactivate number of entries TPDO2");
    numberOfEntries = 1;
    _nanotecbus->writeRegister(_nodeid, TransmitPDO2MappingParameter,
                               TransmitPDO2MappingParameter_0, numberOfEntries);
    // Remap transmit PDOS 1 and 2
    transmissionType = 0x01; // read more on internet
    _serialport->println("Writing Transmission type RPDO1");
    _nanotecbus->writeRegister(_nodeid, ReceivePDO1CommunicationParameter,
                               ReceivePDO1CommunicationParameter_2, transmissionType);
    _serialport->println("Writing Transmission type RPDO2");
    _nanotecbus->writeRegister(_nodeid, ReceivePDO2CommunicationParameter,
                               ReceivePDO2CommunicationParameter_2, transmissionType);
    /* RPDO1 mapping: control word 16 bits
                      modes of operation 8 bits
                      motor drive submode select 32 bits
      Deafult values are kept as they are
       RPDO2 mapping: target torque 16 bits
    */
    _serialport->println("Deactivate RPDO2map number of entries to 0");
    numberOfEntries = 0;
    _nanotecbus->writeRegister(_nodeid, ReceivePDO2MappingParameter,
                               ReceivePDO2MappingParameter_0, numberOfEntries);
    _serialport->println("Remap RPDO2_1 to target torque");
    ReceivePDO2MappingParameter_1_DataType datarpdo2_1;
    datarpdo2_1 = (Targettorque << 16) + (0x0 << 8);
    datarpdo2_1 += 16; //TargetTorque is 16 bits long
    _nanotecbus->writeRegister(_nodeid, ReceivePDO2MappingParameter,
                               ReceivePDO2MappingParameter_1, datarpdo2_1);
    // _serialport->println("Remap RPDO2_2 to limiting velocity on torque mode");
    _serialport->println("Activate RPDO2map number of entries to 1");
    numberOfEntries = 1;
    _nanotecbus->writeRegister(_nodeid, ReceivePDO2MappingParameter,
                               ReceivePDO2MappingParameter_0, numberOfEntries);
    _serialport->println("Activate all PDOS");

    ActivatePDOs();
    // SendSyncMessage();
    return true;
}

bool NANOTEC::SendSyncMessage()
{
    /* Sync message is used to sync PDO messages transmission and reception */
    uint32_t COBID = SYNC_COBID;
    uint8_t len = 1;
    uint8_t d_ = 0x0;
    _nanotecbus->_bus->WriteMessage(COBID, len, d_, d_, d_, d_, d_, d_, d_, d_);
    return true;
}

bool NANOTEC::IsConfigured()
{
    return _configured;
}
bool NANOTEC::IsPDOSConfigured()
{
    return _configuredPDOS;
}

bool NANOTEC::SetTorque(float torqueNewtonMeter)
{
    /* input is in Nm 
     convert to motor controller units 
     saturate to max torque, max_torque = nominal current set in settings * (3.5 Nm / 4.2A)-> motor constant from datasheet */
    float currentmA = torqueNewtonMeter * MOTOR_TORQUE_CONSTANT * 1000.0f;
    int32_t currentmAInt = (int32_t)currentmA;
    int32_t maxAmpInt = (int32_t)(NANOTEC_MAX_AMP_SETPOINT * 1000.0f);
    int32_t satOutput = fmin(fmax(currentmAInt, -maxAmpInt), maxAmpInt);
    Targettorque_DataType target_torque = satOutput;
    _nanotecbus->writeRegister(_nodeid, Targettorque, 0x0, target_torque);
    return true;
}

bool NANOTEC::SetTorquePDO(float torqueNewtonMeter)
{ // it is set according the configuration done before
    /* input is in Nm 
     convert to motor controller units 
     saturate to max torque, max_torque = nominal current set in settings * (3.5 Nm / 4.2A)-> motor constant from datasheet */
    float currentmA = torqueNewtonMeter * MOTOR_TORQUE_CONSTANT * 1000.0f;
    int32_t currentmAInt = (int32_t)currentmA;
    int32_t maxAmpInt = (int32_t)(NANOTEC_MAX_AMP_SETPOINT * 1000.0f);
    int32_t satOutput = fmin(fmax(currentmAInt, -maxAmpInt), maxAmpInt);
    Targettorque_DataType target_torque = satOutput;
    /* RPDO_1 cobid is 0x200 + nodeid */
    _nanotecbus->_bus->WriteMessage(0x300 + _nodeid, 2, lowByte(target_torque),
                                    highByte(target_torque), 0, 0, 0, 0, 0, 0);
    delayMicroseconds(300);
    // _nanotecbus->writeRegister(_nodeid, 0x200 + _nodeid,
    //                            0x0, target_torque);
    return true;
}

bool NANOTEC::SetOutputTorquePDO(float torqueNewtonMeter)
{
    float torqueOut = torqueNewtonMeter / GEARING_RATIO;
    SetTorquePDO(torqueOut);
    return true;
}

bool NANOTEC::SetOutputTorque(float torqueNewtonMeter)
{
    float torqueOut = torqueNewtonMeter / GEARING_RATIO;
    SetTorque(torqueOut);
    return true;
}

float NANOTEC::GetAppliedTorque()
{
    _actualTorque = GetCurrent() * MOTOR_TORQUE_CONSTANT;
    return _actualTorque;
}

uint16_t NANOTEC::GetMotorStatusPDO()
{
    return motorStatus;
}

float NANOTEC::GetAppliedOutputTorque()
{
    return GEARING_RATIO * GetAppliedTorque();
}

float NANOTEC::GetCurrent()
{
    _nanotecbus->readRegister(_nodeid, Torqueactualvalue, 0x0,
                              &_actualTorquePercentage);
    _torqueCurrent = ((float)_actualTorquePercentage) * NANOTEC_MAX_AMP_SETPOINT / 1000.0f;

    return _torqueCurrent;
}

float NANOTEC::GetCurrentPDO()
{
    return _torqueCurrent;
}
/* Radians in arm/wheel */
float NANOTEC::GetOutputAngle()
{
    Positionactualvalue_DataType posmotor = GetEncoderRaw();
    float outAngle = 2.0f * PI * posmotor / ENCODER_TICKS_PR_REV;
    outAngle /= GEARING_RATIO;
    return outAngle;
}
float NANOTEC::GetOutputAngleDeg()
{
    return GetOutputAngle() * 180.0f / PI;
}

float NANOTEC::GetOutputAnglePDO()
{
    float outAngle = 2.0f * PI * _posMotorUnits / ENCODER_TICKS_PR_REV;
    outAngle /= GEARING_RATIO;
    return outAngle;
}

float NANOTEC::GetOutputAngleDegPDO()
{
    return GetOutputAnglePDO() * 180.0f / PI;
}

/* Radians in motor */
float NANOTEC::GetAngle()
{
    Positionactualvalue_DataType posmotor = GetEncoderRaw();
    float Angle = 2.0f * PI * posmotor / ENCODER_TICKS_PR_REV;
    return Angle;
}

float NANOTEC::GetAngleDeg()
{
    return GetAngle() * 180.0f / PI;
}

float NANOTEC::GetAnglePDO()
{
    float Angle = 2.0f * PI * _posMotorUnits / ENCODER_TICKS_PR_REV;
    return Angle;
}

float NANOTEC::GetAngleDegPDO()
{
    return GetAnglePDO() * 180.0f / PI;
}

float GetVelocity()
{
    return 1.0f;
}

bool NANOTEC::ReceivePDOS(CAN_message_t *r_inMsg)
{
    union {
        int32_t myInt32;        // 4 bytes
        byte myInt32InBytes[4]; //  mapped onto the same storage as myFloat
    } myUnion;
    union {
        int16_t myInt16;        // 4 bytes
        byte myInt16InBytes[2]; //  mapped onto the same storage as myFloat
    } myUnion16;
    /* Since there are more motors in the net the PDOS will be handled
    externally */
    if (r_inMsg->id == ((uint16_t)0x180) + _nodeid)
    {
        /* Then this is Status word 16-bits, 
                        Modes of Operation Display 8-bits,
                        Position Actual Value 32 bits */
        motorStatus = (r_inMsg->buf[1] << 8) + r_inMsg->buf[0];
        _modesOfOperationDisplay = r_inMsg->buf[2];
        for (int i = 0; i < 4; i++)
            myUnion.myInt32InBytes[i] = r_inMsg->buf[3 + i];
        _posMotorUnits = myUnion.myInt32;
    }
    else if (r_inMsg->id == ((uint16_t)0x280) + _nodeid)
    {
        myUnion16.myInt16InBytes[0] = r_inMsg->buf[0];
        myUnion16.myInt16InBytes[1] = r_inMsg->buf[1];
        _actualTorquePercentage = myUnion16.myInt16;
        _torqueCurrent = (((float)_actualTorquePercentage) / 1000.0f) * NANOTEC_MAX_AMP_SETPOINT;
        _actualTorque = _torqueCurrent * MOTOR_TORQUE_CONSTANT;
    }
    return true;
}

int32_t NANOTEC::GetEncoderRaw()
{
    _nanotecbus->readRegister(_nodeid, Positionactualvalue, 0x0,
                              &_posMotorUnits);
    return _posMotorUnits;
}

uint16_t NANOTEC::GetNodeId()
{
    return _nodeid;
}

float NANOTEC::GetAppliedTorquePDO()
{
    return _actualTorque;
}

float NANOTEC::GetAppliedOutputTorquePDO()
{
    return _actualTorque * GEARING_RATIO;
}
