
// 2010 Digilent RO

#include "quad_spi_if_0.h"
#include "xparameters.h"
#include "xio.h"
#include <stdio.h>
#include "xbasic_types.h"


extern char verbose;

Xuint32 Status;
Xuint32 start_command;
Xuint32 end_command;
Xuint32 div_rate;
Xuint32 nr_of_bytes;
Xuint32 nr_of_dummy_clks;

u8 addr_0; // Most Significant
u8 addr_1;
u8 addr_2; // Least Significant

//u8 Status_Reg;



/*********************************************************************************************************
 * READ FLAG STATUS REGISTER                                                                             *
 ********************************************************************************************************/

Xuint32 Read_Flag_Status_Register (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 MODE,
		Xuint32 NR_OF_BYTES, u8 *data)
{
	//int i;
	//u8 data;

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting div_rate for serial clock and number of Bytes to read (max. 256 Bytes)
	div_rate = (DIV_RATE << 17);
	nr_of_bytes = (1 << 4);

	start_command = 0xFFFE1FF4 & (div_rate | 0xC001FFFF) & (nr_of_bytes | 0xFFFFE00F);
	end_command = 0x7FFE1FF4 & (div_rate | 0xC001FFFF) & (nr_of_bytes | 0xFFFFE00F);

	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x22); // cmd_mode, read_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x11); // cmd_mode, read_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode, read_mode = 0

	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, RFSR);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);
	//xil_printf("\n0x%0.8x",Status);
	// Wait until session end
	while ((Status != 0xC0000003) && (Status != 0xC0000002) && (Status != 0xC0000011))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf(" ");

	// Read Bytes from RxFIFO - data read from Flash memory
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*data = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	return 0;
}

/*********************************************************************************************************
 * WRITE ENABLE                                                                                          *
 ********************************************************************************************************/

Xuint32 Write_Enable (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 MODE)
{
	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting the mode and the div rate for serial clock
	div_rate = (DIV_RATE << 17);

	start_command = 0xFFFE0000 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0000 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x02); // cmd_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x01); // cmd_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, WREN);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);
	//xil_printf("\n0x%0.8x",Status);

	// Wait until session end
	while (!((Status | 0xFFFFFFF6) & 0x09))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	//xil_printf(" ");

	return 0;
}

/*********************************************************************************************************
 * WRITE VOLATILE ENHANCED CONFIGURATION REGISTER                                                        *
 ********************************************************************************************************/

Xuint32 Write_Volatile_Enhanced_Configuration_Register (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE,
		Xuint32 MODE, u8 DATA)
{

	// Enable writing
	Write_Enable (QuadSPI_Baseaddr, DIV_RATE, MODE);

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting div_rate for serial clock
	div_rate = (DIV_RATE << 17);


	start_command = 0xBFFE0018 & (div_rate | 0xC001FFFF);
	end_command = 0x3FFE0018 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x82); // cmd_mode, write_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x41); // cmd_mode, write_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode, write_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, WRVECR);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Data into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, DATA);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);


	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	//Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);
	//xil_printf("\n0x%x",Status);
	// Wait until session end
	while ((Status != 0xC0000003) && (Status != 0xC0000002) && (Status != 0xC0000011) && (Status != 0xC0000013))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	//xil_printf(" ");


	return 0;
}

/*********************************************************************************************************
 * CLEAR FLAG STATUS REGISTER                                                                            *
 ********************************************************************************************************/

Xuint32 Clear_Flag_Status_Register (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE,
		Xuint32 MODE)
{

	// Enable multi-line command
	if (MODE == 2)
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F); // quad command input
	else if (MODE == 1)
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF); // dual command input
	else
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF); // single command input

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting div rate for serial clock
	div_rate = (DIV_RATE << 17);

	start_command = 0xFFFE0000 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0000 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x02); // cmd_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x01); // cmd_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, CLFSR);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);


	// Wait until session end
	while (!((Status | 0xFFFFFFF6) & 0x09))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}


	return 0;
}

/*********************************************************************************************************
 * READ IDENTIFICATION (works only in Extended Mode)                                                     *
 ********************************************************************************************************/

Xuint32 Read_Identification (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE, u8 *MANUFACT_ID,
		u8 *MEM_TYPE, u8 *MEM_CAPACITY, u8 *EDID)
{

	Xuint32 edid_first_byte;
	Xuint32 edid_second_byte;

	// single command input
	Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF);

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting div_rate for serial clock
	div_rate = (DIV_RATE << 17);
	start_command = 0xFFFE0054 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0054 & (div_rate | 0xC001FFFF);

	// Setting modes (cmd_mode = 0, read_mode = 0)
	XIo_Out32(QuadSPI_Baseaddr + MODES_REG, 0x00);

	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, RDID);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000011) && (Status != 0xC0000002) && (Status != 0xC0000003))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf(" ");

	// Read 1 Byte from RxFIFO - manufacturer identification
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*MANUFACT_ID = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	// Read 1 Byte from RxFIFO - memory type
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*MEM_TYPE = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	// Read 1 Byte from RxFIFO - memory capacity
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*MEM_CAPACITY = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	// Read 1 Byte from RxFIFO - extended device ID
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	edid_first_byte = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	// Read 1 Byte from RxFIFO - extended device ID
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	edid_second_byte = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	//edid_first_byte = (edid_first_byte << 8);
	*EDID = edid_first_byte;// & (0xFFFFFF00 | edid_second_byte);

	return 0;
}

/*********************************************************************************************************
 * MULTIPLE I/O READ IDENTIFICATION (works only in Dual and Quad Mode)                                   *
 ********************************************************************************************************/

Xuint32 Multiple_IO_Read_Identification (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE,
		Xuint32 MODE, u8 *MANUFACT_ID, u8 *MEM_TYPE, u8 *MEM_CAPACITY)
{

	if (MODE == 2)
		// quad command input
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F);
	else
		// quad command input
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF);

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting div_rate for serial clock
	div_rate = (DIV_RATE << 17);

	start_command = 0xFFFE0034 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0034 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x22); // cmd_mode = 2, read_mode = 2
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x11); // cmd_mode = 1, read_mode = 1


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, MIORDID);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	//Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000011) && (Status != 0xC0000002) && (Status != 0xC0000003))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf(" ");

	// Read 1 Byte from RxFIFO - manufacturer identification
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*MANUFACT_ID = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	// Read 1 Byte from RxFIFO - memory type
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*MEM_TYPE = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);

	// Read 1 Byte from RxFIFO - memory capacity
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	*MEM_CAPACITY = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);


	return 0;
}

/*********************************************************************************************************
 * FAST READ (use this function for DCFR and QCFR too)                                                   *
 ********************************************************************************************************/

Xuint32 Fast_Read (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE, Xuint32 MODE,
		Xuint32 ADDRESS, Xuint32 NR_OF_BYTES, Xuint32 NR_OF_DUMMY_CLKS, u8 DATA[256])
{

	int i;
	u8 data;

	// Enable multi-line command
	if (CURRENT_MODE != MODE)
	{
		if (MODE == 2)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F); // quad command input
		else if (MODE == 1)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF); // dual command input
		else
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF); // single command input
	}

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting div_rate for serial clock, number of Bytes to read (max. 256 Bytes) and the
	// number of dummy clocks
	div_rate = (DIV_RATE << 17);
	nr_of_bytes = (NR_OF_BYTES << 4);
	nr_of_dummy_clks = (NR_OF_DUMMY_CLKS << 13);

	// Setting the address from which the reading will be performed
	addr_2 = ADDRESS;
	addr_1 = (ADDRESS >> 8);
	addr_0 = (ADDRESS >> 16);


	start_command = 0xBFFFFFF7 & (div_rate | 0xC001FFFF) & (nr_of_dummy_clks | 0xFFFE1FFF) &
			(nr_of_bytes | 0xFFFFE00F);
	end_command = 0x3FFFFFF7 & (div_rate | 0xC001FFFF) & (nr_of_dummy_clks | 0xFFFE1FFF) &
			(nr_of_bytes | 0xFFFFE00F);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x2A); // cmd_mode, addr_mode, read_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x15); // cmd_mode, addr_mode, read_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode, addr_mode, read_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, FAST_READ);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 0 (most significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_0);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 1 into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_1);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 2 (least significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_2);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	//Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000003) && (Status != 0xC0000002) && (Status != 0xC0000011))// && (Status != 0xC0000012))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf("");

	// Read Bytes from RxFIFO - data read from Flash Memory
	for (i = 0; i < NR_OF_BYTES; i++)
	{
		XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x01);
		XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
		data = XIo_In32(QuadSPI_Baseaddr + DATA_OUT_REG);
		DATA[i] = data;
	}

	return 0;
}

/*********************************************************************************************************
 * PAGE PROGRAM (use this function for DCPP and QCPP too)                                                *
 ********************************************************************************************************/

Xuint32 Page_Program (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE, Xuint32 MODE,
		Xuint32 ADDRESS, Xuint32 NR_OF_BYTES, u8 DATA[256])
{
	int i;
	u8 data;
	u8 Status_Reg = 0;


	// Enable multi-line command
//	if (CURRENT_MODE != MODE)
//	{
		if (MODE == 2)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F); // quad command input
		else if (MODE == 1)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF); // dual command input
		else
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF); // single command input
//	}

	// Enable writing
	Write_Enable (QuadSPI_Baseaddr, DIV_RATE, MODE);


	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting the mode and the div rate for serial clock and number of Bytes
	div_rate = (DIV_RATE << 17);
	nr_of_bytes = (NR_OF_BYTES << 4);

	// Setting the address from which the reading will be performed
	addr_2 = ADDRESS;
	addr_1 = (ADDRESS >> 8);
	addr_0 = (ADDRESS >> 16);

	start_command = 0xBFFE1FF9 & (div_rate | 0xC001FFFF) & (nr_of_bytes | 0xFFFFE00F);
	end_command = 0x3FFE1FF9 & (div_rate | 0xC001FFFF) & (nr_of_bytes | 0xFFFFE00F);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x8A); // cmd_mode, addr_mode, write_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x45); // cmd_mode, addr_mode, write_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode, addr_mode, write_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, PP);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 0 (most significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_0);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 1 into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_1);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 2 (least significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_2);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);


	// Put data to write into TxFIFO
	for (i = 0; i < NR_OF_BYTES; i++)
	{
		data = DATA[i];
		XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, data);
		XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
		XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	}

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000011) && (Status != 0xC0000002) && (Status != 0xC0000003) && (Status != 0xC0000012))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf(" ");

	while (!Status_Reg)
	{
		Read_Flag_Status_Register (QuadSPI_Baseaddr, DIV_RATE, MODE, 1, &Status_Reg);
	}

	// Check if it was any error on programming
	if (Status_Reg & 0x80)
		return 0x03;
	else
		return 0x02;
}

/*********************************************************************************************************
 * SUBSECTOR ERASE                                                                                       *
 ********************************************************************************************************/

Xuint32 Subsector_Erase (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE, Xuint32 MODE,
		Xuint32 ADDRESS)
{
	u8 Status_Reg = 0;

	// Enable multi-line command
	if (CURRENT_MODE != MODE)
	{
		if (MODE == 2)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F); // quad command input
		else if (MODE == 1)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF); // dual command input
		else
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF); // single command input

	}

	// Enable writing
	Write_Enable (QuadSPI_Baseaddr, DIV_RATE, MODE);


	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting the div rate for serial clock
	div_rate = (DIV_RATE << 17);

	// Setting the address
	addr_2 = ADDRESS;
	addr_1 = (ADDRESS >> 8);
	addr_0 = (ADDRESS >> 16);

	start_command = 0xFFFE0001 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0001 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x0A); // cmd_mode, addr_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x05); // cmd_mode, addr_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode, addr_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, SSE);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 0 (most significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_0);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 1 into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_1);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 2 (least significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_2);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);


	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	//Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000003) && (Status != 0xC0000002) && (Status != 0xC0000011) && (Status != 0xC0000012))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf(" ");
	//xil_printf("\nbuc");
	while (!Status_Reg)// != 0x80)
	{
		Read_Flag_Status_Register (QuadSPI_Baseaddr, DIV_RATE, MODE, 1, &Status_Reg);
		//xil_printf("\n0x%x",Status_Reg);
	}

	// Check if it was any error on programming
	if (Status_Reg & 0x80)
		return 0x03;
	else
		return 0x02;
}

/*********************************************************************************************************
 * SECTOR ERASE                                                                                          *
 ********************************************************************************************************/

Xuint32 Sector_Erase (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE, Xuint32 MODE,
		Xuint32 ADDRESS)
{
	u8 Status_Reg = 0;

	// Enable multi-line command
	if (MODE == 2)
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F); // quad command input
	else if (MODE == 1)
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF); // dual command input
	else
		Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF); // single command input

	// Enable writing
	Write_Enable (QuadSPI_Baseaddr, DIV_RATE, MODE);


	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting the div rate for serial clock
	div_rate = (DIV_RATE << 17);

	// Setting the address
	addr_2 = ADDRESS;
	addr_1 = (ADDRESS >> 8);
	addr_0 = (ADDRESS >> 16);

	start_command = 0xFFFE0001 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0001 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x0A); // cmd_mode, addr_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x05); // cmd_mode, addr_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode, addr_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, SE);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 0 (most significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_0);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 1 into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_1);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 2 (least significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_2);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);


	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000003) && (Status != 0xC0000002) && (Status != 0xC0000011))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}


	while (!Status_Reg)// != 0x80)
	{
		Read_Flag_Status_Register (QuadSPI_Baseaddr, DIV_RATE, MODE, 1, &Status_Reg);
	}


	// Check if it was any error on programming
	if (Status_Reg & 0x80)
		return 0x03;
	else
		return 0x02;
}

/*********************************************************************************************************
 * BULK ERASE                                                                                            *
 ********************************************************************************************************/

Xuint32 Bulk_Erase (Xuint32 QuadSPI_Baseaddr, Xuint32 DIV_RATE, Xuint32 CURRENT_MODE, Xuint32 MODE)
{
	u8 Status_Reg = 0;

	// Enable multi-line command
	if (CURRENT_MODE != MODE)
	{
		if (MODE == 2)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0x7F); // quad command input
		else if (MODE == 1)
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xBF); // dual command input
		else
			Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, DIV_RATE, CURRENT_MODE, 0xFF); // single command input
	}

	// Enable writing
	Write_Enable (QuadSPI_Baseaddr, DIV_RATE, MODE);


	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	// Setting the div rate for serial clock
	div_rate = (DIV_RATE << 17);

	start_command = 0xFFFE0000 & (div_rate | 0xC001FFFF);
	end_command = 0x7FFE0000 & (div_rate | 0xC001FFFF);


	// Setting modes
	if (MODE == 2)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x02); // cmd_mode = 2
	else if (MODE == 1)
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x01); // cmd_mode = 1
	else
		XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x00); // cmd_mode = 0


	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, BE);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);


	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);

	// Wait until session end
	while ((Status != 0xC0000003) && (Status != 0xC0000002) && (Status != 0xC0000011) && (Status != 0xC0000012))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}
	xil_printf(" ");

	while (!Status_Reg)// != 0x80)
	{
		Read_Flag_Status_Register (QuadSPI_Baseaddr, DIV_RATE, MODE, 1, &Status_Reg);
		//xil_printf("\n0x%x", Status_Reg);
	}

	// Check if it was any error on programming
	if (Status_Reg & 0x80)
		return 0x03; // OK
	else
		return 0x02; // Error
}

/*********************************************************************************************************
 * CHECK INITIAL MODE                                                                                    *
 ********************************************************************************************************/

Xuint32 Check_Initial_Mode (Xuint32 QuadSPI_Baseaddr)
{
	u8 MANUFACT_ID;
	u8 MEM_TYPE;
	u8 MEM_CAPACITY;
	u8 EDID;

	// Check Read ID in MODE 0
	Read_Identification (QuadSPI_Baseaddr, 4, 0, &MANUFACT_ID, &MEM_TYPE, &MEM_CAPACITY, &EDID);

	if (verbose) xil_printf("\nManufact ID mode extended: 0x%x,", MANUFACT_ID);

	if (MANUFACT_ID == 0x20)
	{
		if (verbose) xil_printf("\nCurrent mode: extended");
		return 0x00;
	}
	else
	{
		// Check Read ID in MODE 1
		Multiple_IO_Read_Identification (QuadSPI_Baseaddr, 4, 1, 1, &MANUFACT_ID, &MEM_TYPE, &MEM_CAPACITY);

		if (verbose) xil_printf("\nManufact ID mode dual: 0x%x,", MANUFACT_ID);

		if (MANUFACT_ID == 0x20)
		{
			if (verbose) xil_printf("\nCurrent mode: dual");
			return 0x01;
		}
		else
		{
			// Check Read ID in MODE 2
			Multiple_IO_Read_Identification (QuadSPI_Baseaddr, 4, 2, 2, &MANUFACT_ID, &MEM_TYPE, &MEM_CAPACITY);

			if (verbose) xil_printf("\nManufact ID mode quad: 0x%x,", MANUFACT_ID);

			if (MANUFACT_ID == 0x20)
			{
				if (verbose) xil_printf("\nCurrent mode: quad");
				return 0x02;
			}
			else
			{
				if (verbose) xil_printf("\nError reading");
				return 0xFFFFFFFF;
			}
		}
	}
}

/*********************************************************************************************************
 * QUAD SPI FLASH MEMORY TEST (for Atlys bist)                                                           *
 ********************************************************************************************************/

Xuint32 Quad_SPI_Flash_Test (Xuint32 QuadSPI_Baseaddr)
{

	u8 DATA_TO_WRITE[6];
	u8 DATA_READ[6];
	Xuint32 Current_Mode;
	Xuint32 Error;

	// Assign the control Bytes (to be written into Flash)
	DATA_TO_WRITE[0] = 0x00;
	DATA_TO_WRITE[1] = 0xFF;
	DATA_TO_WRITE[2] = 0x01;
	DATA_TO_WRITE[3] = 0x02;
	DATA_TO_WRITE[4] = 0x04;
	DATA_TO_WRITE[5] = 0x08;

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	// Check if IDCODE is correct
	if (Current_Mode == 0xFFFFFFFF)
	{
		return 0x70; // "memory not found"
	}
	else
	{
		// Erase the memory to ensure a proper writing
		Error = Subsector_Erase (QuadSPI_Baseaddr, 2, Current_Mode, 2, 0);
		//xil_printf("\npassed erase");


		if (Error == 0x02)
		{
			return 0x80; // "erasing memory failed"
		}
		else
		{
			// Write to memory in BY-4 mode: 0x00, 0xFF, 0x01, 0x02, 0x04, 0x04
			Error = Page_Program (QuadSPI_Baseaddr, 2, Current_Mode, 2, 0, 6, DATA_TO_WRITE);
			//xil_printf("\npassed program");

			// Check if Writing was OK
			if (Error == 0x02)
			{
				return 0x60; // "write to memory failed"
			}
			else
			{
				// Read data from the memory
				Fast_Read (QuadSPI_Baseaddr, 2, Current_Mode, 2, 0, 6, 10, DATA_READ);
				//xil_printf("\npassed read");
				// Erase written data
				Subsector_Erase (QuadSPI_Baseaddr, 2, Current_Mode, 2, 0);

				if (verbose)
				{
					xil_printf("\nData_Read[0]: 0x%x", DATA_READ[0]);
					xil_printf("\nData_Read[1]: 0x%x", DATA_READ[1]);
					xil_printf("\nData_Read[2]: 0x%x", DATA_READ[2]);
					xil_printf("\nData_Read[3]: 0x%x", DATA_READ[3]);
					xil_printf("\nData_Read[4]: 0x%x", DATA_READ[4]);
					xil_printf("\nData_Read[5]: 0x%x", DATA_READ[5]);
				}

				// Check if data read is the same as the written one
				if (XIo_In32(QuadSPI_Baseaddr + OCCUPANCY_RXFIFO_REG) == 0x00)
				{
					if ((DATA_READ[0] == DATA_TO_WRITE[0]) &&
							(DATA_READ[1] == DATA_TO_WRITE[1]) &&
							(DATA_READ[2] == DATA_TO_WRITE[2]) &&
							(DATA_READ[3] == DATA_TO_WRITE[3]) &&
							(DATA_READ[4] == DATA_TO_WRITE[4]) &&
							(DATA_READ[5] == DATA_TO_WRITE[5]))

					{
						return 0x00; // "memory passed the test"
					}
					else
					{
						if (DATA_READ[2] == 0)
						{
							return 0x10; // "Error on FIRST line"
						}
						else if (DATA_READ[3] == 0)
						{
							return 0x20; // "Error on SECOND line"
						}
						else if (DATA_READ[4] == 0)
						{
							return 0x30; // "Error on THIRD line"
						}
						else if (DATA_READ[5] == 0)
						{
							return 0x40; // "Error on FOURTH line"
						}
						else
						{
							return 0x50; // "read from memory failed"
						}
					}
				}
				else
				{
					return 0x50; // "read from memory failed"
				}
			}
		}
	}
}

/*********************************************************************************************************
 * BLANK CHECK ENTIRE FLASH MEMORY                                                                       *
 ********************************************************************************************************/

Xuint32 Blank_Check_Entire_Memory (Xuint32 QuadSPI_Baseaddr)
{
	Xuint32 i;
	Xuint32 j;
	Xuint32 Non_Blank_Bytes = 0;
	Xuint32 z = 0;
	Xuint32 Current_Mode;
	u8 DATA_READ[256];

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	for (i = 0; i < 16776959; i += 256)
	{
		// Read every Byte from memory
		Fast_Read (QuadSPI_Baseaddr, 2, Current_Mode, 2, i, 256, 10, DATA_READ);
		if (verbose)
		{
			if (i == z)
			{
				if (verbose) xil_printf("\n DATA[0x%x]: 0x%x", i, DATA_READ[1]);
				z = z + 0x10000;
			}
		}

		// Compare every Byte read
		for (j = 0; j < 256; j++)
		{
			if (DATA_READ[j] != 0xFF)
				Non_Blank_Bytes++;
		}
	}

	if (Non_Blank_Bytes != 0)
		return Non_Blank_Bytes;
	else
		return 0x00;

}

/*********************************************************************************************************
 * ERASE ENTIRE FLASH MEMORY                                                                             *
 ********************************************************************************************************/

Xuint32 Erase_Entire_Memory (Xuint32 QuadSPI_Baseaddr)
{
	Xuint32 i;
	Xuint32 j;
	Xuint32 Error_Erased_Bytes = 0;
	u8 DATA_READ[256];
	Xuint32 Current_Mode;
	Xuint32 Error;

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	Error = Bulk_Erase (QuadSPI_Baseaddr, 2, Current_Mode, 2);

	if (verbose) xil_printf("\nErase done, blank check memory started");
	// Additionally check if memory has been successfully erased
	for (i = 0; i < 16776959; i += 256)
	{
		// Read every Byte from memory
		Fast_Read (QuadSPI_Baseaddr, 2, Current_Mode, 2, i, 256, 10, DATA_READ);

		// Compare every Byte read: if it is not blank erase that subsector
		for (j = 0; j < 256; j++)
		{
			if (DATA_READ[j] != 0xFF)
				Error_Erased_Bytes++;
		}
	}

	// Return number of data Bytes left after erase (if there are any)
	if (Error_Erased_Bytes != 0)
		return Error_Erased_Bytes;
	else if (Error == 0x02)
		return 0xFFFFFFEE;
	else
		return 0x00;
}

/*********************************************************************************************************
 * BLANK CHECK SECTOR                                                                                    *
 ********************************************************************************************************/

Xuint32 Blank_Check_Sector (Xuint32 QuadSPI_Baseaddr, Xuint32 ADDRESS)
{
	Xuint32 i;
	Xuint32 j;
	Xuint32 z = 0;
	Xuint32 Non_Blank_Bytes = 0;
	Xuint32 Current_Mode;
	u8 DATA_READ[256];

	ADDRESS &= 0xFF0000;

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	for (i = ADDRESS; i < (ADDRESS + 65536); i += 256)
	{
		// Read every Byte from memory
		Fast_Read (QuadSPI_Baseaddr, 2, Current_Mode, 2, i, 256, 10, DATA_READ);

		if (verbose)
		{
			if (i == z)
			{
				if (verbose) xil_printf("\n DATA[0x%x]: 0x%x", i, DATA_READ[1]);
				z = z + 0x10000;
			}
		}

		// Compare every Byte read: if it is not blank erase that sector
		for (j = 0; j < 256; j++)
		{
			if (DATA_READ[j] != 0xFF)
				Non_Blank_Bytes++;
		}
	}


	if (Non_Blank_Bytes != 0)
		return Non_Blank_Bytes;
	else
		return 0x00;
}

/*********************************************************************************************************
 * ERASE SECTOR                                                                                          *
 ********************************************************************************************************/

Xuint32 Erase_Sector (Xuint32 QuadSPI_Baseaddr, Xuint32 ADDRESS)
{
	Xuint32 i;
	Xuint32 j;
	Xuint32 Error_Erased_Bytes = 0;
	Xuint32 Current_Mode;
	Xuint32 Error;
	u8 DATA_READ[256];

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	Error = Sector_Erase (QuadSPI_Baseaddr, 2, Current_Mode, 2, ADDRESS);

	// Additionally check if memory has been successfully erased
	for (i = ADDRESS; i < (ADDRESS + 65536); i += 256)
	{
		// Read every Byte from memory
		Fast_Read (QuadSPI_Baseaddr, 2, Current_Mode, 2, i, 256, 10, DATA_READ);

		// Compare every Byte read: if it is not blank erase that sector
		for (j = 0; j < 256; j++)
		{
			if (DATA_READ[j] != 0xFF)
				Error_Erased_Bytes++;
		}
	}

	// Return number of data Bytes left after erase (if there are any)
	if (Error_Erased_Bytes != 0)
		return Error_Erased_Bytes;
	else if (Error == 0x02)
		return 0xFFFFFFEE;
	else
		return 0x00;
}

/*********************************************************************************************************
 * PROGRAM FLASH (with error code return)                                                                *
 ********************************************************************************************************/

Xuint32 Program_Flash_8 (Xuint32 QuadSPI_Baseaddr, Xuint32 ADDRESS, Xuint32 NR_OF_BYTES, u8 DATA[256])
{
	Xuint32 Current_Mode;
	Xuint32 i;
	u8 data;
	u8 Status_Reg = 0;

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	// Quad command input
	Write_Volatile_Enhanced_Configuration_Register (QuadSPI_Baseaddr, 2, Current_Mode, 0x7F);

	// Enable writing
	Write_Enable (QuadSPI_Baseaddr, 2, 2);

	// Reseting FSM's and FIFO's
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x01);
	XIo_Out32(QuadSPI_Baseaddr + RESET_REG, 0x00);

	div_rate = (2 << 17);
	nr_of_bytes = (NR_OF_BYTES << 4);

	// Setting the address from which the reading will be performed
	addr_2 = ADDRESS;
	addr_1 = (ADDRESS >> 8);
	addr_0 = (ADDRESS >> 16);

	start_command = 0xBFFE1FF9 & (div_rate | 0xC001FFFF) & (nr_of_bytes | 0xFFFFE00F);
	end_command = 0x3FFE1FF9 & (div_rate | 0xC001FFFF) & (nr_of_bytes | 0xFFFFE00F);

	// Setting modes (cmd_mode, addr_mode, write_mode = 2)
	XIo_Out32 (QuadSPI_Baseaddr + MODES_REG, 0x8A);

	// Put instruction command into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, PP);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02); //write enable on TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 0 (most significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_0);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 1 into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_1);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put Address 2 (least significant) into TxFIFO
	XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, addr_2);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);

	// Put data Byte into TxFIFO
	for (i = 0; i < NR_OF_BYTES; i++)
	{
		data = DATA[i];
		XIo_Out32(QuadSPI_Baseaddr + DATA_IN_REG, data);
		XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x02);
		XIo_Out32(QuadSPI_Baseaddr + CONTROL_FIFO_REG, 0x00);
	}

	// Start a cycle session
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, start_command);//start
	XIo_Out32(QuadSPI_Baseaddr + CONTROL_CYCLE_REG, end_command);//end

	// Wait until session end
	while ((Status != 0xC0000011) && (Status != 0xC0000002) && (Status != 0xC0000003))
	{
		Status = XIo_In32(QuadSPI_Baseaddr + STATUS_REG);
	}

	// Wait until Flash finishes reading
	while (!Status_Reg)
	{
		Read_Flag_Status_Register (QuadSPI_Baseaddr, 2, 2, 1, &Status_Reg);
	}

	// Check if it was any error on programming
	if (Status_Reg & 0x10)
		return 0x02;
	else
		return 0x03;
}

/*********************************************************************************************************
 * READ FLASH                                                                                            *
 ********************************************************************************************************/

u8 Read_Flash_8 (Xuint32 QuadSPI_Baseaddr, Xuint32 ADDRESS)
{
	Xuint32 Current_Mode;
	u8 DATA_READ;

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	Fast_Read (QuadSPI_Baseaddr, 2, Current_Mode, 2, ADDRESS, 1, 10, &DATA_READ);

	return DATA_READ;

}

/*********************************************************************************************************
 * MANUFACTURER IDENTIFICATION                                                                           *
 ********************************************************************************************************/

Xuint32 Manufact_ID (Xuint32 QuadSPI_Baseaddr)
{
	Xuint32 Current_Mode;
	u8 MANUFACT_ID;
	u8 m1, m2;

	// Check initial mode (current mode)
	Current_Mode = Check_Initial_Mode (QuadSPI_Baseaddr);

	Multiple_IO_Read_Identification (XPAR_DIGILENT_QUADSPI_CNTLR_BASEADDR, 4, Current_Mode, 2, &MANUFACT_ID, &m1, &m2);

	return MANUFACT_ID;
}


