/*
 * CAN.cpp
 *
 *  Created on: Jul 2, 2020
 *      Author: tequilajohn
 */
#include "CAN.h"
#include <string.h> // for memset
//#include "stm32h7xx_hal.h"
CAN::hardware_resource_t *CAN::resCAN1 = 0;

// Necessary to export for compiler to generate code to be called by the interrupt vector

/* Initalize shit  */
uint8_t CAN::RX_test[8];
/* Initializing function */
CAN::CAN(FlexCAN * handle_)
{
    InitPeripheral();
    ConfigurePeripheral(handle_);
    _waitingForReply = false;
}

CAN::~CAN()
{
    if (!_hRes)
        return;

    _hRes->instances--;
    if (_hRes->instances == 0)
    { // deinitialize port and peripherals
        DeInitiPeripheral();

        // Delete hardware resource
        port_t tmpPort = _hRes->port;
        //		delete _hRes; TK shit

        switch (tmpPort)
        {
        case PORT_CAN1:
            resCAN1 = 0;
            break;
        default:
            //				ERROR("Undefined CAN port");
            return;
        }
    }
}

void CAN::DeInitiPeripheral()
{
    if (!_hRes)
        return;
    if (_hRes->port == PORT_CAN1)
    {
    }
}

void CAN::InitPeripheral()
{
    port_t port = PORT_CAN1;
    bool firstTime = false;
    if (!resCAN1)
    {
        resCAN1 = new CAN::hardware_resource_t;
        memset(resCAN1, 0, sizeof(CAN::hardware_resource_t));
        firstTime = true;
        _hRes = resCAN1;
    }
    if (firstTime)
    { // first time configuring peripheral
        _hRes->port = port;
        _hRes->configured = false;
        _hRes->instances = 0;
        /* Real time stuff to add later
		if (_hRes->resourceSemaphore == NULL) {
			_hRes = 0;
			ERROR("Could not create I2C resource semaphore");
			return;
		}
		vQueueAddToRegistry(_hRes->resourceSemaphore, "I2C Resource");
		xSemaphoreGive( _hRes->resourceSemaphore ); // give the semaphore the first time
		_hRes->transmissionFinished = xSemaphoreCreateBinary();
		if (_hRes->transmissionFinished == NULL) {
			_hRes = 0;
			ERROR("Could not create I2C transmission semaphore");
			return;
		}
		vQueueAddToRegistry(_hRes->transmissionFinished, "I2C Finish");
		xSemaphoreGive( _hRes->transmissionFinished ); // ensure that the semaphore is not taken from the beginning
		xSemaphoreTake( _hRes->transmissionFinished, ( TickType_t ) portMAX_DELAY ); // ensure that the semaphore is not taken from the beginning
		*/
        // COnfigure pins for I2C accordingly
        if (port == PORT_CAN1)
        {
            
        }
    }
    _hRes->instances++;
    //	TxHeader.Identifier = 0x321;
}
void CAN::ConfigurePeripheral(FlexCAN *handlei)
{

    if (!_hRes->configured)
    { // only configured peripheral once
        switch (_hRes->port)
        {
        case PORT_CAN1:
            _hRes->handle = handlei;
            // here all the parameters should be set 
            break;
        default:
            return;
        }
        // _hRes->handle->begin();
        _hRes->configured = true; 
    }
    if (!_hRes)
        return; /* only here works */
}
uint32_t CAN::GetRxFiFoLevel()
{
    return 0;
}

void CAN::WriteDummyData(uint8_t data)
{
    outMsg.id = 0x321;
    outMsg.len = 3;
    outMsg.buf[0] = 0xA;
    outMsg.buf[1] = 0xB;
    outMsg.buf[2] = 0xC;
    _hRes->handle->write(outMsg);

}
void CAN::WriteMessage(uint32_t id, uint8_t len, uint8_t d0, uint8_t d1,
                       uint8_t d2, uint8_t d3, uint8_t d4, uint8_t d5, uint8_t d6, uint8_t d7)
{
    for (int i = 0; i < 7; i++)
        outMsg.buf[i] = 0;

    outMsg.id = id;
    outMsg.len = len;
    outMsg.ext = 0;

    outMsg.buf[0] = d0;
    outMsg.buf[1] = d1;
    outMsg.buf[2] = d2;
    outMsg.buf[3] = d3;
    outMsg.buf[4] = d4;
    outMsg.buf[5] = d5;
    outMsg.buf[6] = d6;
    outMsg.buf[7] = d7;

    _hRes->handle->write(outMsg);
}

void CAN::Read(CAN_message_t &p_inMsg)
{
    _hRes->handle->read(p_inMsg);
}
void CAN::Read()
{
    CAN_message_t _inMsg;
    _hRes->handle->read(_inMsg);
}

bool CAN::isAvailable()
{
    return _hRes->handle->available();
}
