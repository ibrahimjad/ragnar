#ifndef CAN_CMD_h
#define CAN_CMD_h

#define CAN_NMT 0x0

#define CAN_NODE_BROADCAST_ID 0x0

#define CAN_SWITCH_TO_OPERATIONAL 0X01
#define CAN_SWITCH_TO_STOP 0x02
#define CAN_SWITCH_TO_PREOPERATIONAL 0x80
#define CAN_RESET_NODE 0x81
#define CAN_RESET_COMM 0x82

/* Request command data size */
#define CAN_SDOW_DATA_BYTE_1 0x2F
#define CAN_SDOW_DATA_BYTE_2 0x2B
#define CAN_SDOW_DATA_BYTE_3 0x27
#define CAN_SDOW_DATA_BYTE_4 0x23

/* Data read reply data size */ 

#define CAN_SDOR_DATA_BYTE_1 0x4F
#define CAN_SDOR_DATA_BYTE_2 0x4B
#define CAN_SDOR_DATA_BYTE_3 0x47
#define CAN_SDOR_DATA_BYTE_4 0x43

#define CAN_SDO_CANID_W 0x600
#define CAN_SDO_CANID_R 0x580
#define CAN_READ_REQUEST 0x40

#define CAN_WRITE_RESPONSE 0x60
#define CAN_ERROR_RESPONSE 0x80

#define SYNC_COBID 0x80

#endif