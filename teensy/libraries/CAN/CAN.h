/*
 * CAN.h
 *
 *  Created on: Jul 2, 2020
 *      Author: tequilajohn
 */
#include <Arduino.h>
#include <FlexCAN.h> 

#ifndef CAN_H
#define CAN_H

/* FDCAN port will be hard coded*/
//#include "cmsis_os.h" // for memory allocation (for the buffer) and callback

class CAN
{
public:
	typedef enum port_t
	{
		PORT_UNDEFINED = 0,
		PORT_CAN1
	} port_t;

public:
	static uint8_t RX_test[8];
	CAN(FlexCAN * handle_); // use the default FDCAN port defined in the IO map in STM32CubeMX
	~CAN();
	void InitPeripheral();
	void DeInitiPeripheral();
	void ConfigurePeripheral(FlexCAN* handlei);
    bool isAvailable();
	void WriteDummyData(uint8_t data);
	void WriteMessage(uint32_t id, uint8_t len, uint8_t d0, uint8_t d1,
					  uint8_t d2, uint8_t d3, uint8_t d4, uint8_t d5,
					  uint8_t d6, uint8_t d7);
	void Read(CAN_message_t &p_inMsg);
	uint32_t GetRxFiFoLevel();
	void Read(uint8_t index, uint8_t subindex, uint32_t *buffer);

	void Read();
	uint8_t Read(uint8_t index);
	
public:
	typedef struct hardware_resource_t
	{
		port_t port;
		bool configured;
		uint8_t instances; // how many objects are using this hardware resource
		FlexCAN* handle;
	} hardware_resource_t;

	static hardware_resource_t *resCAN1;

private: //private
	CAN_message_t * pinMsg;
    CAN_message_t outMsg;
    
	uint8_t TxData[8];
	int b;

public:
	hardware_resource_t *_hRes;

private:
	bool _waitingForReply;
};

#endif /* PERIPHIRALS_FDCAN_H_ */
