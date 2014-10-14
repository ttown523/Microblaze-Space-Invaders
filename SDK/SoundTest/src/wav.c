#include "wav.h"
#include "xac97_l.h"
#include "xintc_l.h"
#include "stdlib.h"


#define XPAR_QUAD_SPI_IF_0_BASEADDR XPAR_DIGILENT_QUADSPI_CNTLR_BASEADDR
#define XPAR_AC97_PLB_CONTROLLER_0_BASEADDR XPAR_AXI_AC97_0_BASEADDR
#define XPAR_XPS_INTC_0_BASEADDR XPAR_AXI_INTC_0_BASEADDR
#define XPAR_AC97_PLB_CONTROLLER_0_INTERRUPT_MASK XPAR_AXI_AC97_0_INTERRUPT_MASK

void usleep(unsigned int useconds)
{
  int i,j;
  for (j=0;j<useconds;j++)
    for (i=0;i<15;i++) asm("nop");
}

void InitializeMixer(){
	int i;
	for(i=0; i<MIXER_ARRAY_SIZE; i++){
		MixerArray[i] = NULL;
	}
	MixerPtr = 0;
}

void IncrementMixerPtr(){
	MixerPtr = (++MixerPtr) % MIXER_ARRAY_SIZE;
}

void initializeAC97()
{
	//XAC97_WriteReg(Xuint32 BaseAddress, Xuint32 RegAddress, Xuint32 Value)

	// Hard Reset the AC97
	XAC97_mSetControl(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, AC97_ENABLE_RESET_AC97);
	usleep(100);
	XAC97_mSetControl(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, AC97_DISABLE_RESET_AC97);
	usleep(100);
	XAC97_SoftReset(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR);

	// Enable a variable audio rate in the AC97
	XAC97_WriteReg(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, AC97_ExtendedAudioStat, AC97_EXTENDED_AUDIO_CONTROL_VRA);

	// Change the sample rate on the AC97
	XAC97_WriteReg(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, AC97_PCM_DAC_Rate, AC97_PCM_RATE_11025_HZ);

	// Change Volume
	u32 volumeLevel = AC97_VOL_MID;
	XAC97_WriteReg(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, AC97_MasterVol, volumeLevel);

	// Wait for the device to be ready
	XAC97_AwaitCodecReady(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR);

	// Enable interrupt generation on the AC97.
	XAC97_mSetControl(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, AC97_ENABLE_IN_FIFO_INTERRUPT);

	//CurrentWave = NULL;
	InitializeMixer();
}

void printWaveFileFmtInfo(WaveFile * f){
	xil_printf("\n\rFile Size: %d\r\n", f->fileSize);
	xil_printf("Data Size: %d\r\n", f->dataSize);
	xil_printf("Compression Code: %02X\r\n", f->compressionCode);
	xil_printf("Num. Channels: %d\r\n", f->numChannels);
	xil_printf("Sample Rate: %d\r\n", f->sampleRate);
	xil_printf("Bytes Per Second: %d\r\n", f->bytesPerSecond);
	xil_printf("BlockAlign: %d\r\n", f->blockAlign);
	xil_printf("Significant Bits Per Sample: %d\r\n", f->sigBitsPerSample);
}

u8 ReadFlashByte(WaveFile * W){
   xil_printf(".");
   return Read_Flash_8(XPAR_QUAD_SPI_IF_0_BASEADDR, W->flashCurrentAddress++);
 }

void ReadFlash256Byte(WaveFile * W, u8 * sampleBuffer){
	xil_printf("*");
	u32 Current_Mode = Check_Initial_Mode (XPAR_QUAD_SPI_IF_0_BASEADDR);
	Fast_Read (XPAR_QUAD_SPI_IF_0_BASEADDR, 2, Current_Mode, 2, W->flashCurrentAddress, 256, 10, sampleBuffer);
	W->flashCurrentAddress += 256;
}

u32 ReadFlashBigEndianWord(WaveFile * W){
	u8 data0 = ReadFlashByte(W);
	u8 data1 = ReadFlashByte(W);
	u8 data2 = ReadFlashByte(W);
	u8 data3 = ReadFlashByte(W);

	return (data0 << 24) | (data1 << 16) | (data2 << 8) | (data3 << 0);
}

u16 ReadFlashLittleEndianHalfWord(WaveFile * W){
	u8 data0 = ReadFlashByte(W);
	u8 data1 = ReadFlashByte(W);

	return (data1 << 8) | (data0 << 0);
}

u32 ReadFlashLittleEndianWord(WaveFile * W){

	u8 data0 = ReadFlashByte(W);
	u8 data1 = ReadFlashByte(W);
	u8 data2 = ReadFlashByte(W);
	u8 data3 = ReadFlashByte(W);

	return (data3 << 24) | (data2 << 16) | (data1 << 8) | (data0 << 0);
}



boolean verifyWaveFile(WaveFile * W){
   u32 file_id = ReadFlashBigEndianWord(W);
   xil_printf("%08x\r\n", file_id);
   u32 file_size = ReadFlashLittleEndianWord(W);
   xil_printf("%d Bytes\r\n", file_size);
   u32 file_type_id = ReadFlashBigEndianWord(W);
   xil_printf("%08x\r\n", file_type_id);
   if((file_id == RIFF_ID) && (file_type_id == RIFF_WAVE_ID)){
	   W->fileSize = file_size;
	   return true;
   }
   return false;
}

/*typedef struct {
  u32 fileSize;
  u32 dataSize;
  u16 compressionCode;
  u16 numChannels;
  u32 sampleRate;
  u16 blockAlign;
  u16 sigBitsPerSample;
  u16 extraFmtBytes;
} WaveFile; */

/*
0x08 2 Compression code 1 - 65,535
0x0a 2 Number of channels 1 - 65,535
0x0c 4 Sample rate 1 - 0xFFFFFFFF
0x10 4 Average bytes per second 1 - 0xFFFFFFFF
0x14 2 Block align 1 - 65,535
0x16 2 Significant bits per sample 2 - 65,535
0x18 2 Extra format bytes 0 - 65,535
0x1a Extra format bytes *
 */

boolean verifyFmtChunkId(WaveFile * W){
	if(ReadFlashBigEndianWord(W) == FMT_CHUNK_ID){
		xil_printf("Verified format chunk\r\n");
		return true;
	} else {
		xil_printf("Did not verify format chunk\r\n");
		return false;
	}
}

void parseFmtChunk(WaveFile * W){
   if(verifyFmtChunkId(W)){
     u32 chunkDataSize = ReadFlashLittleEndianWord(W);
     xil_printf("Format Chunk Data Size: %08x", chunkDataSize);
     W->compressionCode = ReadFlashLittleEndianHalfWord(W);
     W->numChannels = ReadFlashLittleEndianHalfWord(W);

     if(W->numChannels > 1){
        xil_printf("Wave Parser Error: To many channels\r\n");
        exit(1);
     }

     W->sampleRate = ReadFlashLittleEndianWord(W);
     W->bytesPerSecond = ReadFlashLittleEndianWord(W);
     W->blockAlign = ReadFlashLittleEndianHalfWord(W);
     W->sigBitsPerSample = ReadFlashLittleEndianHalfWord(W);
     if(chunkDataSize == 0x12){
    	 ReadFlashLittleEndianHalfWord(W);
     }
   }
}

boolean verifyWaveDataChunk(WaveFile * W){
	u32 data = ReadFlashBigEndianWord(W);
	xil_printf("Data %08x Read From %08x", data, W->flashCurrentAddress);
	if(data == WAVE_DATA_CHUNK_ID){
		return true;
	} else
		return false;
}

void setAddressToWaveData(WaveFile * W){

	u32 listChunk_id = ReadFlashBigEndianWord(W);
	if(listChunk_id == LIST_CHUNK_ID){
	  u32 listChunk_size = ReadFlashLittleEndianWord(W);
	//CurrentAddress = CurrentAddress + listChunk_size;
	  W->flashCurrentAddress = W->flashCurrentAddress + listChunk_size;
	} else {
		W->flashCurrentAddress = W->flashCurrentAddress - 4;
	}
	if(verifyWaveDataChunk(W)){
       W->dataSize = ReadFlashLittleEndianWord(W);
	} else {
		xil_printf("Did not arrive at data chunk!!");
		exit(1);
	}

	u32 sigBytesPerSample = W->sigBitsPerSample / 8;
	if(sigBytesPerSample <= 8){
	  	sigBytesPerSample = 1;
	} else if(sigBytesPerSample <= 16){
	    sigBytesPerSample = 2;
	} else {
	  	xil_printf("Wave Parser Error: Significant Sample Bit\r\n");
	    exit(1);
	   }

	     W->numOfSamples = W->dataSize /sigBytesPerSample;
	     W->ddrStopAddress = W->ddrStartAddress + W->dataSize;
}
//Populate Wave File Struct
void open_wave_file(WaveFile * W){

	if(verifyWaveFile(W)){
		parseFmtChunk(W);
		printWaveFileFmtInfo(W);
	} else {
		xil_printf("Not A Wave File\r\n");
		exit(1);
	}

	setAddressToWaveData(W);
	//EndAddress = W->flashCurrentAddress + W->dataSize;
}


void getSamplesFromDDR(WaveFile * W){
	W->samples = XIo_In32(W->ddrCurrentAddress);
	W->ddrCurrentAddress+=4;
	W->wordCnt = 0;
}
/*u16 getNextSampleFromDDR(WaveFile * W){
    u16 sample = 0;
    if(W->blockAlign== 2){
      sample = XIo_In16(W->ddrCurrentAddress);
      W->ddrCurrentAddress += 2;
    } else if(W->blockAlign == 1){
    	u8 temp = XIo_In8(W->ddrCurrentAddress);
    	temp = temp - 128;
    	sample = (temp << 8);
    	W->ddrCurrentAddress++;
    }
    return sample;
}*/

u16 getNextSample(WaveFile * W){
	u8 temp, u16;
	if(W->blockAlign == 2){
		if(W->wordCnt > 1){
			getSamplesFromDDR(W);
		}
		switch(W->wordCnt){
		  case 0:
            W->wordCnt++;
			return (W->samples & (0xFFFF0000)) >> 16; break;
		  case 1:
			W->wordCnt++;
			return (W->samples & (0x0000FFFF)); break;
		  default:
			xil_printf("WordCnt Error!!");
			return 0x0;  break;
		}
	} else if(W->blockAlign == 1){
		if(W->wordCnt > 3){
			getSamplesFromDDR(W);
		}
		switch(W->wordCnt){
		  case 0:
			W->wordCnt++;
			temp = ((W->samples & (0xFF000000)) >> 24) - 128;
			return temp << 8; break;
		  case 1:
			W->wordCnt++;
			temp = ((W->samples & (0x00FF0000)) >> 16) - 128;
		    return temp << 8; break;
		  case 2:
			W->wordCnt++;
			temp = ((W->samples & (0x0000FF00)) >> 8) - 128;
			return temp << 8; break;
		  case 3:
	  	    W->wordCnt++;
	  	    temp = ((W->samples & (0x000000FF)) >> 0) - 128;
	  	  	return temp << 8; break;
		  default:
			xil_printf("WordCnt Error!!");
			return 0x0;  break;
		}
	}
	return 0;
}

boolean currentSoundDone(WaveFile * W){
   if(W->ddrCurrentAddress >= W->ddrStopAddress){
		 return true;
   }
   return false;
}

void resetWaveFile(WaveFile * W){
	W->ddrCurrentAddress = W->ddrStartAddress;
}

void resetCompletedSounds(){
	int i;
	for(i = 0; i<MIXER_ARRAY_SIZE; i++){
		if(MixerArray[i] != NULL){
			if(currentSoundDone(MixerArray[i])){
				resetWaveFile(MixerArray[i]);
				MixerArray[i] = NULL;
			}
		}
	}
}

u16 mixNextSample(){
	int i;
	Xint16 mixed=0;
	u16 sample;
	for(i=0;i<MIXER_ARRAY_SIZE; i++){
	   if(MixerArray[i]!= NULL){
		 mixed += getNextSample(MixerArray[i]);
	   }
	}
	//if(mixed > 32767) sample = (unsigned) 32767;
	//if(mixed < -32768) sample =(unsigned)-32768;
	sample = (unsigned) mixed;
	return sample;
}

void WriteNextSampleToAC97(){
	//u32 sample = getNextSampleFromDDR(W);
	u32 sample = mixNextSample();
	sample = (sample << 16) | sample;
	//XAC97_WriteFifo(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, sample);
	XAC97_mSetInFifoData(XPAR_AC97_PLB_CONTROLLER_0_BASEADDR, sample);

	resetCompletedSounds();
	/*if(currentSoundDone()){
		xil_printf("Current Sound Done... Starting Blank\r\n");
		resetWaveFile(W);
		CurrentWave = NULL;
	}*/
}

void WriteNextSampleToDDR(WaveFile * W){
   if(W->blockAlign == 2){
	 XIo_Out16(W->ddrCurrentAddress, ReadFlashLittleEndianHalfWord(W));
	 W->ddrCurrentAddress+=2;
   } else if(W->blockAlign == 1){
	 XIo_Out8(W->ddrCurrentAddress, ReadFlashByte(W));
	 W->ddrCurrentAddress++;
   } else {
	   xil_printf("Wave Parser Error: Unsupported Sample Size.");
	   exit(1);
   }
}

void WriteDataSectorToDDR(WaveFile * W){
  u8 byteBuffer[256];
  u16 sampleBuffer[128];
  ReadFlash256Byte(W, &(byteBuffer[0]));

  int i;
  if(W->blockAlign == 2){
	  for(i=0; i<128; i++){
		  sampleBuffer[i] = (byteBuffer[2*i+1] << 8) | byteBuffer[2*i];
		  //xil_printf("\r\nSampleBuffer[%d] = %04x", i, sampleBuffer[i]);
		  XIo_Out16(W->ddrCurrentAddress, sampleBuffer[i]);
		  W->ddrCurrentAddress+=2;
	  }
  } else if(W->blockAlign == 1){
	  for(i=0; i<256; i++){
		  XIo_Out8(W->ddrCurrentAddress, byteBuffer[i]);
		  W->ddrCurrentAddress++;
	  }
  } else {
	   xil_printf("Wave Parser Error: Unsupported Sample Size.");
	   exit(1);
  }
  //exit(1);
}
///u16 samples[30000];

XInterruptHandler AC97_InterruptHandler(){
    int i;
   // xil_printf("In AC97_Interrupt\r\n");
	//microblaze_disable_interrupts();
	for(i=0; i<128; i++){
  	   WriteNextSampleToAC97();
	}
	XIntc_AckIntr(XPAR_XPS_INTC_0_BASEADDR,XPAR_AC97_PLB_CONTROLLER_0_INTERRUPT_MASK);
	//microblaze_enable_interrupts();
}

void copyWaveFileFromFlashToDDR(WaveFile * W){
   Address EndFlashAddress = W->flashCurrentAddress + W->dataSize;
   while(W->flashCurrentAddress < EndFlashAddress){
	 if((EndFlashAddress - W->flashCurrentAddress) > 255){
	   WriteDataSectorToDDR(W);
     } else {
       WriteNextSampleToDDR(W);
     }
   }
   W->ddrCurrentAddress = W->ddrStartAddress;
}

void setWaveFileAddresses(WaveFile * W, Address FlashStartAddress, Address DDRStartAddress){
	W->flashStartAddress = FlashStartAddress;
	W->flashCurrentAddress=FlashStartAddress;
	W->ddrStartAddress =   DDRStartAddress;
	W->ddrCurrentAddress = DDRStartAddress;
}

void loadWaveFiles(){

	setWaveFileAddresses(&DarthVader, DARTH_VADER_FLASH_ADDRESS, DARTH_VADER_DDR_ADDRESS);
	setWaveFileAddresses(&BaseHit, BASEHIT_FLASH_ADDRESS, BASEHIT_DDR_ADDRESS);
	setWaveFileAddresses(&Shot, SHOT_FLASH_ADDRESS, SHOT_DDR_ADDRESS);
	setWaveFileAddresses(&InvHit, INVHIT_FLASH_ADDRESS, INVHIT_DDR_ADDRESS);
	setWaveFileAddresses(&UFO, UFO_FLASH_ADDRESS,  UFO_DDR_ADDRESS );
	setWaveFileAddresses(&UFOHit, UFOHIT_FLASH_ADDRESS, UFOHIT_DDR_ADDRESS);
	setWaveFileAddresses(&Walk1, WALK1_FLASH_ADDRESS, WALK1_DDR_ADDRESS);
	setWaveFileAddresses(&Walk2, WALK2_FLASH_ADDRESS, WALK2_DDR_ADDRESS);
	setWaveFileAddresses(&Walk3, WALK3_FLASH_ADDRESS, WALK3_DDR_ADDRESS);
	setWaveFileAddresses(&Walk4, WALK4_FLASH_ADDRESS, WALK4_DDR_ADDRESS);

	xil_printf("Reading DarthVader \r\n");
    open_wave_file(&DarthVader);
    copyWaveFileFromFlashToDDR(&DarthVader);

    xil_printf("Reading BaseHit \r\n");
    open_wave_file(&BaseHit);
    copyWaveFileFromFlashToDDR(&BaseHit);

    xil_printf("Reading InvHit \r\n");
    open_wave_file(&InvHit);
    copyWaveFileFromFlashToDDR(&InvHit);

    xil_printf("Reading Shot \r\n");
    open_wave_file(&Shot);
    copyWaveFileFromFlashToDDR(&Shot);

    xil_printf("Reading UFO \r\n");
    open_wave_file(&UFO);
    copyWaveFileFromFlashToDDR(&UFO);

    xil_printf("Reading UFOHit \r\n");
    open_wave_file(&UFOHit);
    copyWaveFileFromFlashToDDR(&UFOHit);

    xil_printf("Reading Walk1 \r\n");
    open_wave_file(&Walk1);
    copyWaveFileFromFlashToDDR(&Walk1);

    xil_printf("Reading Walk2 \r\n");
    open_wave_file(&Walk2);
    copyWaveFileFromFlashToDDR(&Walk2);

    xil_printf("Reading Walk3 \r\n");
    open_wave_file(&Walk3);
    copyWaveFileFromFlashToDDR(&Walk3);

    xil_printf("Reading Walk4 \r\n");
    open_wave_file(&Walk4);
    copyWaveFileFromFlashToDDR(&Walk4);

    AlienSounds[0] = &Walk1;
    AlienSounds[1] = &Walk2;
    AlienSounds[2] = &Walk3;
    AlienSounds[3] = &Walk4;
}


void continueWaveFile(WaveFile * W){
	if(W->ddrCurrentAddress == W->ddrStartAddress){
		playWaveFile(W);
	}
}
void playWaveFile(WaveFile * W){
	if(MixerArray[MixerPtr] == NULL){
		MixerArray[MixerPtr] = W;
		IncrementMixerPtr();
	}


}
