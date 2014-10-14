#ifndef WAVE_UTILS_H
#define WAVE_UTILS_H

#include "xparameters.h"
#include "stdio.h"
#include "xintc.h"
//#include "xexception_l.h"
//#include "xsysace.h"
//#include "sysace_stdio.h"
#include "xbasic_types.h"
//#include "xac97_l.h"

#include "string.h"

// This immediately follows the VGA frame buffers in memory.
#define AUDIO_BUFFER			0x00A00000

#define AC97_ADDRESS			(XPAR_AUDIO_CODEC_BASEADDR + AC97_IN_FIFO_OFFSET)
#define LITTLE_ENDIAN 1


//------Sounds 
#define NUM_SOUNDS			10
//--
#define MARCH_1_SOUND_NAME				"move0.wav" //walk0.wav
#define MARCH_2_SOUND_NAME				"move1.wav"
#define MARCH_3_SOUND_NAME				"move2.wav"
#define MARCH_4_SOUND_NAME				"move3.wav" 
#define ALIEN_BULLET_SOUND_NAME			"shoot.wav"	//ashoot.wav
#define TANK_BULLET_SOUND_NAME			"kill.wav"	//tankshot.wav
#define SPACESHIP_SOUND_NAME			"ship.wav"	//ufoshort.wav
#define TANK_EXPLOSION_SOUND_NAME		"explode.wav" //explode.wav
#define ALIEN_EXPLOSION_SOUND_NAME		"alienhit.wav" //aexp.wav
#define SPACESHIP_EXPLOSION_SOUND_NAME	"high.wav" //ufodie.wav
//--
#define MARCH_1_SOUND				0
#define MARCH_2_SOUND				1
#define MARCH_3_SOUND				2
#define MARCH_4_SOUND				3
#define ALIEN_BULLET_SOUND			4
#define TANK_BULLET_SOUND			5
#define SPACESHIP_SOUND				6
#define TANK_EXPLOSION_SOUND		7
#define ALIEN_EXPLOSION_SOUND		8
#define SPACESHIP_EXPLOSION_SOUND	9
//--
#define NO_LOOP		 	0
#define LOOP		 	1

//#define DEBUG

//--------------------------------------
// DMA Controller Register Addresses
//--------------------------------------

// Control Register Addresses (READ/WRITE)
#define RESET_ADDRESS						0x40090000
#define MASTER_CONTROL_ADDRESS				0x40090004
#define DESTINATION_ADDRESS					0x40090008
#define SILENT_VALUE_ADDRESS				0x4009000C
#define NUM_SAMPLES_ADDRESS					0x40090010
#define NUM_CYCLES_BEFORE_TIMEOUT_ADDRESS	0x40090014

// Channel Register Addresses (Read/Write)
#define CHANNEL_0_SOURCE_ADDRESS			0x40090018
#define CHANNEL_0_LENGTH_ADDRESS			0x4009001C
#define CHANNEL_0_LOOP_ADDRESS				0x40090020
#define CHANNEL_1_SOURCE_ADDRESS			0x40090024
#define CHANNEL_1_LENGTH_ADDRESS			0x40090028
#define CHANNEL_1_LOOP_ADDRESS				0x4009002C
#define CHANNEL_2_SOURCE_ADDRESS			0x40090030
#define CHANNEL_2_LENGTH_ADDRESS			0x40090034
#define CHANNEL_2_LOOP_ADDRESS				0x40090038
#define CHANNEL_3_SOURCE_ADDRESS			0x4009003C
#define CHANNEL_3_LENGTH_ADDRESS			0x40090040
#define CHANNEL_3_LOOP_ADDRESS				0x40090044
#define CHANNEL_4_SOURCE_ADDRESS			0x40090048
#define CHANNEL_4_LENGTH_ADDRESS			0x4009004C
#define CHANNEL_4_LOOP_ADDRESS				0x40090050
#define CHANNEL_5_SOURCE_ADDRESS			0x40090054
#define CHANNEL_5_LENGTH_ADDRESS			0x40090058
#define CHANNEL_5_LOOP_ADDRESS				0x4009005C
#define CHANNEL_6_SOURCE_ADDRESS			0x40090060
#define CHANNEL_6_LENGTH_ADDRESS			0x40090064
#define CHANNEL_6_LOOP_ADDRESS				0x40090068
#define CHANNEL_7_SOURCE_ADDRESS			0x4009006C
#define CHANNEL_7_LENGTH_ADDRESS			0x40090070
#define CHANNEL_7_LOOP_ADDRESS				0x40090074
#define CHANNEL_8_SOURCE_ADDRESS			0x40090078
#define CHANNEL_8_LENGTH_ADDRESS			0x4009007C
#define CHANNEL_8_LOOP_ADDRESS				0x40090080
#define CHANNEL_9_SOURCE_ADDRESS			0x40090084
#define CHANNEL_9_LENGTH_ADDRESS			0x40090088
#define CHANNEL_9_LOOP_ADDRESS				0x4009008C


// Read Only Addresses
#define READ_ADDRESS						0x40090090
#define DATA_ADDRESS						0x40090094
#define SAMPLE_COUNER_ADDRESS				0x40090098
#define WRITE_COUNTER_ADDRESS				0x4009009C
#define TIMEOUT_COUNTER_ADDRESS				0x400900A0

//Global
Xint8* DDRAddress;
Xint8* soundAddresses[NUM_SOUNDS];

Xint32 volumeLevel; //current volume level
Xint32 alienSoundIndex;


//Functions
void initializeAC97();
void getSoundsFromCF();
Xint32 copyFileToDDR(Xint8 * fileName, Xint32 index);
void initiateSound(Xint32 soundIndex, Xint32 loop);
void playSound(Xint32 soundIndex);
void stopSound();
Xint32 bytesToInt(Xint8 * bytePointer, Xint32 bytesToConvert, Xint8 little_endian);
void initializeDMAController();

#endif


