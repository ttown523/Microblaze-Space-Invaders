/*
 * wav.h
 *
 *  Created on: Nov 22, 2011
 *      Author: superman
 */

#ifndef WAV_H_
#define WAV_H_

#include "quad_spi_if_0.h"
#include "xac97_l.h"

#define RIFF_ID      0x52494646
#define RIFF_WAVE_ID 0x57415645
#define FMT_CHUNK_ID 0x666D7420
#define WAVE_DATA_CHUNK_ID 0x64617461
#define LIST_CHUNK_ID 0x4C495354
#define DARTH_VADER_FLASH_ADDRESS  0x00C00000
#define DARTH_VADER_DDR_ADDRESS    XPAR_MCB_DDR2_S0_AXI_BASEADDR + DARTH_VADER_FLASH_ADDRESS

#define BASEHIT_FLASH_ADDRESS 0x00D00000
#define BASEHIT_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + BASEHIT_FLASH_ADDRESS

#define SHOT_FLASH_ADDRESS 0x00D019C0
#define SHOT_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + SHOT_FLASH_ADDRESS

#define INVHIT_FLASH_ADDRESS 0x00D029DC
#define INVHIT_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + INVHIT_FLASH_ADDRESS

#define UFO_FLASH_ADDRESS 0x00D0375C
#define UFO_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + UFO_FLASH_ADDRESS

#define UFOHIT_FLASH_ADDRESS 0x00D03E92
#define UFOHIT_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + UFOHIT_FLASH_ADDRESS

#define WALK1_FLASH_ADDRESS 0x00D0A38C
#define WALK1_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + WALK1_FLASH_ADDRESS

#define WALK2_FLASH_ADDRESS 0x00D0A824
#define WALK2_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + WALK2_FLASH_ADDRESS

#define WALK3_FLASH_ADDRESS 0x00D0AC48
#define WALK3_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + WALK3_FLASH_ADDRESS

#define WALK4_FLASH_ADDRESS 0x00D0B0A8
#define WALK4_DDR_ADDRESS XPAR_MCB_DDR2_S0_AXI_BASEADDR + WALK4_FLASH_ADDRESS

typedef u32 Address;

enum BOOL {false, true};
typedef enum BOOL boolean;

typedef struct {
  //Address
  Address flashStartAddress;
  Address flashCurrentAddress;
  Address ddrStartAddress;
  Address ddrStopAddress;
  Address ddrCurrentAddress;

  //Sample
  u32 wordCnt;
  u32 samples;
  //Wave File Information
  u32 fileSize;
  u32 dataSize;
  u32 numOfSamples;
  u16 compressionCode;
  u16 numChannels;
  u32 sampleRate;
  u32 bytesPerSecond;
  u16 blockAlign;
  u16 sigBitsPerSample;
} WaveFile;

WaveFile DarthVader;
WaveFile BaseHit;
WaveFile InvHit;
WaveFile Shot;
WaveFile UFO;
WaveFile UFOHit;
WaveFile Walk1;
WaveFile Walk2;
WaveFile Walk3;
WaveFile Walk4;

WaveFile * AlienSounds[4];
//WaveFile * CurrentWave;
#define MIXER_ARRAY_SIZE 20
WaveFile * MixerArray[MIXER_ARRAY_SIZE];
u32 MixerPtr;
void initializeAC97();
void loadWaveFiles();
void playWaveFile(WaveFile * W);
void continueWaveFile(WaveFile * W);
XInterruptHandler AC97_InterruptHandler();
#endif /* WAV_H_ */
