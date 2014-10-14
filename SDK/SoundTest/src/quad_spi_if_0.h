
#include "xparameters.h"


//** OFFSETS OF REGISTERS *********************************************

#define RESET_REG				0x00
#define STATUS_REG				0x04
#define OCCUPANCY_RXFIFO_REG	0x08
#define OCCUPANCY_TXFIFO_REG	0x0C
#define CONTROL_CYCLE_REG		0x10
#define DATA_IN_REG				0x14
#define DATA_OUT_REG			0x18
#define CONTROL_FIFO_REG		0x1C
#define MODES_REG				0x20

//*********************************************************************

//** STATUS REG *******************************************************

#define TXFIFO_EMPTY		0
#define RXFIFO_EMPTY		1
#define TXFIFO_FULL			2
#define RXFIFO_FULL			3
#define CYCLE_DONE			4
#define READ_ONE_BYTE_DONE	30
#define WRITE_ONE_BYTE_DONE	31

//*********************************************************************

//** COMMANDS *********************************************************

#define	RDID		0x9F
#define	READ		0x03
#define	MIORDID		0xAF
#define	ROTP		0x4B
#define	WREN		0x06
#define	WRDI		0x04
#define	POTP		0x42
#define	SSE			0x20
#define	SE			0xD8
#define	BE			0xC7
#define	PER			0x7A
#define	PES			0x75
#define	RDSR		0x05
#define	WRDSR		0x01
#define	RDLR		0xE8
#define	WRLR		0xE5
#define	RFSR		0x70
#define	CLFSR		0x50
#define	RDNVCR		0xB5
#define	WRNVCR		0xB1
#define	RDVCR		0x85
#define	WRVCR		0x81
#define	RDVECR		0x65
#define	WRVECR		0x61

#define	FAST_READ	0x0B
#define	DOFR		0x3B
#define	DIOFR		0xBB
#define	QOFR		0x6B
#define	QIOFR		0xEB

#define	PP			0x02
#define	DIFP		0xA2
#define	DIEFP		0xD2
#define	QIFP		0x32
#define	QIEFP		0x12



//*********************************************************************




