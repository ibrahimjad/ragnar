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

#ifndef DEVICES_NANOTEC_H
#define DEVICES_NANOTEC_H

#include "NANOTEC_Bus.h"
#include "CAN.h" //FDCAN Library
#include "Arduino.h"

class NANOTEC
{

public:
    NANOTEC(CAN *bus, Stream *port, uint8_t nodeid, float MaxCurrent, float TorqueConstant, float GearRatio, uint32_t EncoderTicksPrRev, float MaxMotorSpeed, bool configPDOS = false);
    NANOTEC(CAN *bus, Stream *port, int8_t MotorIndex, float MaxCurrent, float TorqueConstant, float GearRatio, uint32_t EncoderTicksPrRev, float MaxMotorSpeed, bool configPDOS = false); // platform specific constructor
    ~NANOTEC();

private:
    const double _M_PI = 3.14159265358979323846264338327950288;
    const float NANOTEC_MAX_AMP_SETPOINT; // A
    const float MOTOR_TORQUE_CONSTANT;    // Nm/A
    const float GEARING_RATIO;            // Arm_ratio/Motor_ratio
    const uint32_t ENCODER_TICKS_PR_REV;  // ticks/rev on encoder side - hence one revolution on motor shaft (before gearing)
    const float NANOTEC_MAX_RAD_PR_SEC;   // rad/s
    Stream *_serialport;
    uint8_t _nodeid; // motor node id s
    bool _configPDOS;
    NANOTEC_CANOpen *_nanotecbus;

public:
    void Enable();
    void Disable();

    bool Configure();
    bool ResetNode();
    bool ActivateNode();
    bool ActivateStateMachine();
    bool PreoperationalNode();
    bool DeactivatePDOs();
    bool ActivatePDOs();
    uint16_t GetNodeId();
    uint16_t GetMotorStatusPDO();

    bool ConfigurePDOS();
    bool SendSyncMessage();
    bool SetTorqueSettings();
    bool ResetFault();
    bool ExitFault();

    bool GetEncoderUnitsBoot();
    bool GetEncoderUnits();
    bool SetEncoderUnits();
    uint32_t GetEncoderBootRaw();

    bool IsConfigured();
    bool IsPDOSConfigured();

    bool SetTorque(float torqueNewtonMeter);
    bool SetOutputTorque(float torqueNewtonMeter);
    float GetAppliedTorque();
    float GetAppliedOutputTorque();
    float GetCurrent();
    float GetAngle();
    float GetAngleDeg();
    float GetOutputAngle();
    float GetOutputAngleDeg();
    float GetOutputVelocity();
    float GetVelocity();
    /* Getting things in PDO manner */
    bool SetTorquePDO(float torqueNewtonMeter);
    bool SetOutputTorquePDO(float torqueNewtonMeter);
    float GetAppliedTorquePDO();
    float GetAppliedOutputTorquePDO();
    float GetCurrentPDO();
    float GetAnglePDO();
    float GetAngleDegPDO();
    float GetOutputAnglePDO();
    float GetOutputAngleDegPDO();
    float GetOutputVelocityPDO();
    float GetVelocityPDO();

    bool ReceivePDOS(CAN_message_t *r_inMsg);

    int32_t GetEncoderRaw();
    int32_t GetEncoderRawPDO();

    uint32_t motorRevolutions;
    uint32_t encoderIncrements;
    uint16_t motorStatus;

private:
    bool _deleteObjectsAtDestruction;
    
    bool _configured;
    bool _configuredPDOS;
    
    
    uint32_t _motorRevolutionsBoot;
    uint32_t _encoderIncrementsBoot;
    uint32_t _encoderBoot;
    /* -2 Auto setup
       -1 Clock-direction mode
        0 No mode change/no mode assigned
        1 Profile Position Mode
        2 Velocity Mode
        3 Profile Velocity Mode
        4 Profile Torque Mode
        5 Reserved
        6 Homing Mode */
    int8_t _modesOfOperationDisplay;
    int32_t _posMotorUnits;
    float _posMotorRad;
    float _posOutput;
    int16_t _actualTorquePercentage;
    float _torqueCurrent;
    float _actualTorque;
};

#endif