//******************************************************************************
//
//
//	Kevin Ellsworth
//	Jonathan Steck
// 	Brigham Young University
//	ECEn 427 (Fall 2009)
//	
//
//	waveUtils.c
//	Description
//
//******************************************************************************

#include "waveUtils.h" 
//#include "gameState.h"


/*void initializeDMAController()
{
	xil_printf("Initializing DMA Controller\n\r");
	
	// Program Control Registers
	XIo_Out32(RESET_ADDRESS, 1);
	XIo_Out32(DESTINATION_ADDRESS, AC97_ADDRESS);
	XIo_Out32(SILENT_VALUE_ADDRESS, 128);
	XIo_Out32(NUM_SAMPLES_ADDRESS, 128);
	XIo_Out32(NUM_CYCLES_BEFORE_TIMEOUT_ADDRESS, 512);
	
	// Program Master Control Register
	XIo_Out32(MASTER_CONTROL_ADDRESS, 0);//initialize with nothing playing
	
	//TODO: This doesn't really belong here, but I'm not sure where else to put it.
	alienSoundIndex = 0;
	
	xil_printf("\tDestination Register: 0x%X\n\r", XIo_In32(DESTINATION_ADDRESS));
	xil_printf("\tSilent Value Register: 0x%X\n\r", XIo_In32(SILENT_VALUE_ADDRESS));
	xil_printf("\tNumber Of Samples Register: 0x%X\n\r", XIo_In32(NUM_SAMPLES_ADDRESS));
	xil_printf("\tNumber Of Cycles Before Timeout Register: 0x%X\n\r", XIo_In32(NUM_CYCLES_BEFORE_TIMEOUT_ADDRESS));
	xil_printf("\tMaster Control Register: 0x%X\n\n\r", XIo_In32(MASTER_CONTROL_ADDRESS));
}*/

/*
void initializeAC97()
{
	//XAC97_WriteReg(Xuint32 BaseAddress, Xuint32 RegAddress, Xuint32 Value)
	
	// Hard Reset the AC97
	XAC97_mSetControl(XPAR_AUDIO_CODEC_BASEADDR, AC97_ENABLE_RESET_AC97);
	usleep(100);
	XAC97_mSetControl(XPAR_AUDIO_CODEC_BASEADDR, AC97_DISABLE_RESET_AC97);
	usleep(100);
	XAC97_SoftReset(XPAR_AUDIO_CODEC_BASEADDR);

	// Enable a variable audio rate in the AC97
	XAC97_WriteReg(XPAR_AUDIO_CODEC_BASEADDR, AC97_ExtendedAudioStat, AC97_EXTENDED_AUDIO_CONTROL_VRA);
	
	// Change the sample rate on the AC97
	XAC97_WriteReg(XPAR_AUDIO_CODEC_BASEADDR, AC97_PCM_DAC_Rate, AC97_PCM_RATE_11025_HZ);
	
	// Change Volume
	volumeLevel = AC97_VOL_MID;
	XAC97_WriteReg(XPAR_AUDIO_CODEC_BASEADDR, AC97_MasterVol, volumeLevel);
	
	// Wait for the device to be ready
	XAC97_AwaitCodecReady(XPAR_AUDIO_CODEC_BASEADDR);
	
	// Enable interrupt generation on the AC97.
	XAC97_mSetControl(XPAR_AUDIO_CODEC_BASEADDR, AC97_ENABLE_IN_FIFO_INTERRUPT);
}*/

/*void getSoundsFromCF()
{
	Xint32 fileSize;
	DDRAddress = (Xint8*)AUDIO_BUFFER;
	
	xil_printf("%s at address 0x%x\r\n", MARCH_1_SOUND_NAME, DDRAddress);
	//fileSize = copyFileToDDR(MARCH_1_SOUND_NAME, MARCH_1_SOUND);
	initiateSound(MARCH_1_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", MARCH_1_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", MARCH_2_SOUND_NAME, DDRAddress);
	//fileSize = copyFileToDDR(MARCH_2_SOUND_NAME, MARCH_2_SOUND);
	initiateSound(MARCH_2_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", MARCH_2_SOUND_NAME);
	
	//xil_printf("%s at address 0x%x\r\n", MARCH_3_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(MARCH_3_SOUND_NAME, MARCH_3_SOUND);
	initiateSound(MARCH_3_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", MARCH_3_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", MARCH_4_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(MARCH_4_SOUND_NAME, MARCH_4_SOUND);
	initiateSound(MARCH_4_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", MARCH_4_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", ALIEN_BULLET_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(ALIEN_BULLET_SOUND_NAME, ALIEN_BULLET_SOUND);
	initiateSound(ALIEN_BULLET_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", ALIEN_BULLET_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", TANK_BULLET_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(TANK_BULLET_SOUND_NAME, TANK_BULLET_SOUND);
	initiateSound(TANK_BULLET_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", TANK_BULLET_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", SPACESHIP_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(SPACESHIP_SOUND_NAME, SPACESHIP_SOUND);
	initiateSound(SPACESHIP_SOUND, LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", SPACESHIP_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", TANK_EXPLOSION_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(TANK_EXPLOSION_SOUND_NAME, TANK_EXPLOSION_SOUND);
	initiateSound(TANK_EXPLOSION_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", TANK_EXPLOSION_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", ALIEN_EXPLOSION_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(ALIEN_EXPLOSION_SOUND_NAME, ALIEN_EXPLOSION_SOUND);
	initiateSound(ALIEN_EXPLOSION_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", ALIEN_EXPLOSION_SOUND_NAME);
	
	xil_printf("%s at address 0x%x\r\n", SPACESHIP_EXPLOSION_SOUND_NAME, DDRAddress);
	fileSize = copyFileToDDR(SPACESHIP_EXPLOSION_SOUND_NAME, SPACESHIP_EXPLOSION_SOUND);
	initiateSound(SPACESHIP_EXPLOSION_SOUND, NO_LOOP);
	if(fileSize == 0) 
		xil_printf("Error with file: %s\r\n", SPACESHIP_EXPLOSION_SOUND_NAME);
}*/

/*Xint32 copyFileToDDR(Xint8 * fileName, Xint32 index)
{
	//SYSACE_FILE *infile;
	Xint8 *audiobuffer = DDRAddress;
	Xint32 numread;
	Xint32 fileSize = 0;
	
	Xint8 completeFileName[50] = "a:\\";
	
	//Concatenate strings
	strcat(completeFileName, fileName);

	//infile = sysace_fopen(completeFileName, "r");
	
	/*if (infile != NULL)
	{
		//Record address for this file in array
		soundAddresses[index] = audiobuffer;
		
		//read first 8 btyes to determine file size
		numread = sysace_fread(audiobuffer, 1, 8, infile);
		
		//Determine Filesize
		fileSize = bytesToInt(&audiobuffer[4], 4, LITTLE_ENDIAN);

		//infile is already incremented past the part that we have read
		//	So, we start from there and continue reading to filesize - but we need to increment the ddr pointer
		audiobuffer += 8;
		
		//copy rest of file
		numread = sysace_fread(audiobuffer, 1, fileSize, infile);
		DDRAddress += (8 + fileSize);	//move pointer to location for next file
		
		sysace_fclose(infile);
	}
	
	return fileSize;
}*/

/*void playSound(Xint32 soundIndex)
{
	if(gameState.tank.isAlive == FALSE)
	{
		Xint32 controlRegMask = 1 << soundIndex;
		XIo_Out32(MASTER_CONTROL_ADDRESS, controlRegMask);
	}
	else if(gameState.spaceship.x == INACTIVE)
	{
		Xint32 controlRegMask = 1 << soundIndex;
		XIo_Out32(MASTER_CONTROL_ADDRESS, controlRegMask);
	}
	
}
*/
// Stops whatever is playing right now
void stopSound()
{
	Xil_Out32(MASTER_CONTROL_ADDRESS, 0);
}


void initiateSound(Xint32 soundIndex, Xint32 loop)
{
	Xint32 compressed;
	Xint32 numChannels;
	Xint32 sampleRate;
	Xint32 blockAlign;
	Xint32 sigBitsPerSample;
	Xint32 dataSize;
	Xint32 fmtSize;
	
	Xint32 dataStartAddress;

	Xint8* fileLocation = soundAddresses[soundIndex];
	
	//check to make sure size of block is correct - 28 is size without extra fmt chunks info
	fmtSize = bytesToInt(&fileLocation[16], 4, LITTLE_ENDIAN);
	compressed = (bytesToInt(&fileLocation[20], 2, LITTLE_ENDIAN) == 1) ? 0 : 1;//not compressed if code is 1 else is compressed
	numChannels = bytesToInt(&fileLocation[22], 2, LITTLE_ENDIAN);
	sampleRate = bytesToInt(&fileLocation[24], 4, LITTLE_ENDIAN);
	blockAlign = bytesToInt(&fileLocation[32], 2, LITTLE_ENDIAN);
	sigBitsPerSample = bytesToInt(&fileLocation[34], 2, LITTLE_ENDIAN);
	
	//TODO: Add checks to make sure we are getting right data - i.e. if location == "data"
	//get data size
	// if(fmtSize != 16)
	// {
		// xil_printf("fmt block not 16\r\n");
		// return;
	// }
	
	if (compressed == 1)
	{
		xil_printf("sound file is compressed\r\n");
		return;
	}
	
	if (numChannels != 1)
	{
		xil_printf("sound file not single channel\r\n");
		return;
	}
	
	dataSize = bytesToInt(&fileLocation[24 + fmtSize], 4, LITTLE_ENDIAN);
	// else
		// dataSize = bytesToInt(&fileLocation[40], 4, LITTLE_ENDIAN);
	
	#ifdef DEBUG
		xil_printf("--fileInfo: %x\r\n", fileLocation);
		xil_printf("compressed: %d\r\n", compressed);
		xil_printf("numChannels: %d\r\n", numChannels);
		xil_printf("sampleRate: %d\r\n", sampleRate);
		xil_printf("blockAlign: %d\r\n", blockAlign);
		xil_printf("sigBitsPerSample: %d\r\n", sigBitsPerSample);
		xil_printf("dataSize: 0x%x\r\n", dataSize);
	#endif
	
	// Program the AC97 for the correct sample rate
	// TODO: How do we want to handle Sample rate?
	// TODO: This will take the last initalized sound and program the AC97 with that - assumes they are all the same rate
	//XAC97_WriteReg(XPAR_AUDIO_CODEC_BASEADDR, AC97_PCM_DAC_Rate, sampleRate);
	
	dataStartAddress = (Xint32)(fileLocation + 44); // 44 is the offset between the fileLocation and the data section
	
	//Program DMA Registers
	switch(soundIndex)
	{
		case 0:
		{
			Xil_Out32(CHANNEL_0_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_0_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_0_LOOP_ADDRESS, loop);
			break;
		}
		case 1:
		{
			Xil_Out32(CHANNEL_1_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_1_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_1_LOOP_ADDRESS, loop);
			break;
		}
		case 2:
		{
			Xil_Out32(CHANNEL_2_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_2_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_2_LOOP_ADDRESS, loop);
			break;
		}
		case 3:
		{
			Xil_Out32(CHANNEL_3_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_3_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_3_LOOP_ADDRESS, loop);
			break;
		}
		case 4:
		{
			Xil_Out32(CHANNEL_4_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_4_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_4_LOOP_ADDRESS, loop);
			break;
		}
		case 5:
		{
			Xil_Out32(CHANNEL_5_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_5_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_5_LOOP_ADDRESS, loop);
			break;
		}
		case 6:
		{
			Xil_Out32(CHANNEL_6_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_6_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_6_LOOP_ADDRESS, loop);
			break;
		}
		case 7:
		{
			Xil_Out32(CHANNEL_7_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_7_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_7_LOOP_ADDRESS, loop);
			break;
		}
		case 8:
		{
			Xil_Out32(CHANNEL_8_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_8_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_8_LOOP_ADDRESS, loop);
			break;
		}
		case 9:
		{
			Xil_Out32(CHANNEL_9_SOURCE_ADDRESS, dataStartAddress);
			Xil_Out32(CHANNEL_9_LENGTH_ADDRESS, dataSize);
			Xil_Out32(CHANNEL_9_LOOP_ADDRESS, loop);
			break;
		}
		default:
		{
			xil_printf("Error in initiateSound\r\n");
		}
	}
}

//This function takes a pointer to the start of the bytes to be converted
//	The second parameter is a bool that tells if it is little_endian
Xint32 bytesToInt(Xint8 * bytePointer, Xint32 bytesToConvert, Xint8 little_endian)
{
	Xint32 returnInt;
	
	if(little_endian)
		if(bytesToConvert == 4)
			returnInt = ((bytePointer[3] << 24) + (bytePointer[2] << 16) + (bytePointer[1] << 8) + bytePointer[0]);
		else if(bytesToConvert == 2)
			returnInt = (bytePointer[1] << 8) + bytePointer[0];
	else
		if(bytesToConvert == 4)
			returnInt = ((bytePointer[0] << 24) + (bytePointer[1] << 16) + (bytePointer[2] << 8) + bytePointer[3]);
		else if(bytesToConvert == 2)
			returnInt = (bytePointer[0] << 8) + bytePointer[1];
		
	return returnInt;
}



