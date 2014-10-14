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
#include "xparameters.h"
#include "xaxivdma.h"
#include "xio.h"
#include "time.h"
#include "unistd.h"
#define DEBUG
void print(char *str);

/*typedef struct {
    int VertSizeInput;      /**< Vertical size input */
  //  int HoriSizeInput;      /**< Horizontal size input */
  //  int Stride;             /**< Stride */
  //  int FrameDelay;         /**< Frame Delay */

 //   int EnableCircularBuf;  /**< Circular Buffer Mode? */
//    int EnableSync;         /**< Gen-Lock Mode? */
 //   int PointNum;           /**< Master we synchronize with */
  //  int EnableFrameCounter; /**< Frame Counter Enable */
  //  u32 FrameStoreStartAddr[XAXIVDMA_MAX_FRAMESTORE];
                            /**< Start Addresses of Frame Store Buffers. */
  //  int FixedFrameStoreAddr;/**< Fixed Frame Store Address index */
//} XAxiVdma_DmaSetup;
//*/

#define FRAME_BUFFER_0_ADDR 0xC0000000

int main()
{
	init_platform();
	int Status;
	XAxiVdma_FrameCounter FrameCfg;
	XAxiVdma VideoDMAController;
	//VideoDMAController.
    XAxiVdma_Config * VideoDMAConfig = XAxiVdma_LookupConfig(XPAR_AXI_VDMA_0_DEVICE_ID);
    XAxiVdma_DmaSetup FrameBuffer0;
    if(XST_FAILURE == XAxiVdma_CfgInitialize(&VideoDMAController, VideoDMAConfig,	XPAR_AXI_VDMA_0_BASEADDR))
    {
    	xil_printf("VideoDMA Did not initialize.\r\n");
    }

    if(XST_FAILURE ==  XAxiVdma_SetFrmStore(&VideoDMAController, 2, XAXIVDMA_READ)){
    	xil_printf("Set Frame Store Failed.");
    }

   FrameCfg.ReadFrameCount = 2;
   FrameCfg.ReadDelayTimerCount = 10;
   FrameCfg.WriteFrameCount =2;
   FrameCfg.WriteDelayTimerCount = 10;

   XAxiVdma_SetFrmStore(&VideoDMAController, 2, XAXIVDMA_READ);

   Status = XAxiVdma_SetFrameCounter(&VideoDMAController, &FrameCfg);
   if (Status != XST_SUCCESS) {
    		xil_printf(
    		    	"Set frame counter failed %d\r\n", Status);

    		if(Status == XST_VDMA_MISMATCH_ERROR)
    			xil_printf("DMA Mismatch Error\r\n");

    		//return XST_FAILURE;
    }
     FrameBuffer0.VertSizeInput = 480;
     FrameBuffer0.HoriSizeInput = 640*4;
     FrameBuffer0.Stride = 640*4;
     FrameBuffer0.FrameDelay = 0;
     FrameBuffer0.EnableCircularBuf=1;
     FrameBuffer0.EnableSync = 0;
     FrameBuffer0.PointNum = 0;
     FrameBuffer0.EnableFrameCounter = 0; // Endless Transfers
     FrameBuffer0.FixedFrameStoreAddr = 0; //


     if(XST_FAILURE == XAxiVdma_DmaConfig(&VideoDMAController, XAXIVDMA_READ, &FrameBuffer0))
     {
    	 xil_printf("DMA Config Failed\r\n");
     }

     FrameBuffer0.FrameStoreStartAddr[0] = FRAME_BUFFER_0_ADDR;
     FrameBuffer0.FrameStoreStartAddr[1] = FRAME_BUFFER_0_ADDR + 4*640*480;

     if(XST_FAILURE == XAxiVdma_DmaSetBufferAddr(&VideoDMAController, XAXIVDMA_READ,
    		               FrameBuffer0.FrameStoreStartAddr))
     {
    	 xil_printf("DMA Set Address Failed Failed\r\n");
     }

     xil_printf("Hello World\n\r");

     unsigned int * FRAME_POINTER = (unsigned int *) FRAME_BUFFER_0_ADDR;
     unsigned int * FRAME_POINTER1 = ((unsigned int *) FRAME_BUFFER_0_ADDR) + 640*480;
     int row=0, col=0;
     int red_cnt=0, green_cnt=0, blue_cnt=0, white_cnt=0;
     for( row=0; row<480;row++)
     {
       for(col=0; col <640; col++)
       {
    	 if(row < 240)
    	 {
    		 if(col<320)
    		 {
    			 FRAME_POINTER[row*640 + col] = 0x00FF0000;
    			 FRAME_POINTER1[row*640 + col] = 0x0000FF00;
    			 red_cnt++;
    		 } else{
    			 FRAME_POINTER[row*640 + col] = 0x000000FF;
    			 FRAME_POINTER1[row*640 + col] = 0x00FF0000;
    			 blue_cnt++;
    		 }
    	 }else
    	 {
    		 if(col<320)
    		 {
    			 FRAME_POINTER[row*640 + col] = 0x0000FF00;
    			 FRAME_POINTER1[row*640 + col] = 0x00FFFFFF;
    			 green_cnt++;
    		 } else{
    			 FRAME_POINTER[row*640 + col] = 0x00FFFFFF;
    			 FRAME_POINTER1[row*640 + col] = 0x000000FF;
    			 white_cnt++;
    		 }
    	 }
    	   //FRAME_POINTER[i] = 0x00FFFFFF;
       }
     }
     xil_printf("r: %d, g: %d, b: %d, w: %d\r\n", red_cnt, green_cnt, blue_cnt, white_cnt);
     XIo_Out32(XPAR_AXI_HDMI_0_BASEADDR, 640*480);


     if(XST_FAILURE == XAxiVdma_DmaStart(&VideoDMAController, XAXIVDMA_READ)){
    	 xil_printf("DMA START FAILED\r\n");
     }

     int i=0;
     for(i=0; i<20;i++)
     {
       int frame;
       if(i%2==0)
       {
    	   frame = 0;
       } else frame = 1;
       if(XST_FAILURE == XAxiVdma_StartParking(&VideoDMAController,frame,  XAXIVDMA_READ))
       {
      	 xil_printf("Parking Mode Failed!\r\n");
       }
       int j=0;
       do{
    	   j++;
       } while (j<100000000);
     }
     cleanup_platform();

    return 0;
}
