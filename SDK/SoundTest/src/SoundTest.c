/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 */

#include <stdio.h>
#include "platform.h"
#include "xbasic_types.h"
#include "quad_spi_if_0.h"
#include "xac97_l.h"
#include "xio.h"
#include "xintc_l.h"
#include "mb_interface.h"
#include "wav.h"
char verbose = 0;



int main()
{
    init_platform();
    //verbose = 1;

    xil_printf("\n\rLoading Sounds and initializing hardware...\n\r");

    loadWaveFiles();

    initializeAC97();

    xil_printf("Playing Sound\r\n");

    microblaze_enable_interrupts();
	microblaze_register_handler((XInterruptHandler) AC97_InterruptHandler, NULL);
	XAC97_mSetControl(XPAR_AXI_AC97_0_BASEADDR, AC97_ENABLE_IN_FIFO_INTERRUPT);
    XIntc_EnableIntr(XPAR_INTC_SINGLE_BASEADDR, XPAR_AXI_AC97_0_INTERRUPT_MASK);
    XIntc_MasterEnable(XPAR_INTC_SINGLE_BASEADDR);
    //xil_printf("Current Wave = %08x, CurrentAddress = %08x, CurrentStopAddress =%08x\r\n", CurrentWave, CurrentWave->ddrCurrentAddress, CurrentWave->ddrStopAddress );
    while(1){
        xil_printf("Please Select a Sound Effect (0-9)\r\n");
    	char ch;
    	read(0,&ch, 1);
    	switch(ch){
    	  case '0':
    		  playWaveFile(&DarthVader);
    		  break;
    	  case '1':
    		  playWaveFile(&BaseHit);
    		  break;
    	  case '2':
    		  playWaveFile(&InvHit);
    		  break;
    	  case '3':
    		  playWaveFile(&UFO);
    		  break;
    	  case '4':
    		  playWaveFile(&UFOHit);
    		  break;
    	  case '5':
    		  playWaveFile(&Shot);
    		  break;
    	  case '6':
    		  playWaveFile(&Walk1);
    		  break;
    	  case '7':
    		  playWaveFile(&Walk2);
    		  break;
    	  case '8':
    		  playWaveFile(&Walk3);
    		  break;
    	  case '9':
    		  playWaveFile(&Walk4);
    		  break;
    	}
    }
	//Xuint32 Current_Mode = Check_Initial_Mode (XPAR_QUAD_SPI_IF_0_BASEADDR);
    //u32 testResult = Quad_SPI_Flash_Test (XPAR_QUAD_SPI_IF_0_BASEADDR);
    //xil_printf("Quad_SPI_Flash Test Result %08X.\r\n", testResult);
    //u8 ReadByte =  Read_Flash_8(XPAR_QUAD_SPI_IF_0_BASEADDR, 0x00000000);
    //xil_printf("I read Byte %2X, from the SPI Flash.\r\n", ReadByte);
    //u32 FLASH_ID = Manufact_ID (XPAR_QUAD_SPI_IF_0_BASEADDR);
    //xil_printf("Flash ID is:  %08x.\r\n", FLASH_ID);
    //for(i = 0; i<256; i++){
    //   data[i]=i;
   // }

    //Page_Program (XPAR_QUAD_SPI_IF_0_BASEADDR, 2, Current_Mode, 2, 0, 256, data);

    //Fast_Read(XPAR_QUAD_SPI_IF_0_BASEADDR, 2, Current_Mode, 2, 0x00C00000, 256, 10, data1);
    //Fast_Read(XPAR_QUAD_SPI_IF_0_BASEADDR, 2, Current_Mode, 2, 0x00C00000, 256, 10, data2);
    //Page_Program (XPAR_QUAD_SPI_IF_0_BASEADDR, 2, Current_Mode, 2, 0, 256, data);
   // for(i = 0; i<256; i++){
   // 	xil_printf("%02x %02x\r\n", data1[i], data2[i]);
    //}
    //while(1) XAC97_WriteFifo(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, 0x0);
    //xil_printf("Final i: %d", i);
    cleanup_platform();

    return 0;
}



