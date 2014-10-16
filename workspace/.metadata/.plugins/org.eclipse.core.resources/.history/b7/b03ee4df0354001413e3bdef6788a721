/*
 * bunker.c
 *
 *  Created on: Oct 1, 2014
 *      Author: superman
 */

#include "bunker.h"

//a look up table for the bunker bitmaps
static const u16 * bunkerBitmaps[3][4][5];

//array of bunkers
static Bunker bunkers[4];


/***********************************
 *		 Bunker Bitmaps
 **********************************/

u16 const bunkerBlock[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),

};

u16 const bunkerBlockE1[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,1,1),
};

u16 const bunkerBlockE2[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1),
		packWord16(0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1),
};

u16 const bunkerBlockE3[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockTopCornerLeft[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
};

u16 const bunkerBlockTopLeftE1[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
};
u16 const bunkerBlockTopLeftE2[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
};

u16 const bunkerBlockTopLeftE3[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0),
};

u16 const bunkerBlockTopCornerRight[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
};

u16 const bunkerBlockTopRightE1[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
};

u16 const bunkerBlockTopRightE2[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
};

u16 const bunkerBlockTopRightE3[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1),
};


u16 const bunkerBlockBottomCornerRight[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockBottomRightE1[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockBottomRightE2[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,1,1,0,0,1,1,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockBottomRightE3[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockBottomCornerLeft[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
};

u16 const bunkerBlockBottomLeftE1[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockBottomLeftE2[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,1,1,1,1,0,0,1,1,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

u16 const bunkerBlockBottomLeftE3[BLOCK_SIZE] =
{
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};

/**
 * initBunkers:
 * ------------
 * Initializes each of the 4 bunkers to put on the screen
 */
void initBunkers(void){
	int i,j;
	//initialize the position of each bunker
	bunkers[0].position.x = 360;
	bunkers[0].position.y = 100;

	bunkers[1].position.x = 360;
	bunkers[1].position.y = 220;

	bunkers[2].position.x = 360;
	bunkers[2].position.y = 340;

	bunkers[3].position.x = 360;
	bunkers[3].position.y = 460;

	//set each bunker state to 0 (not eroded)
	for(i = 0; i < 3; i++){
		for (j = 0; j < 4; j++){
			bunkers[0].bunkerState[i][j] = 0;
			bunkers[1].bunkerState[i][j] = 0;
			bunkers[2].bunkerState[i][j] = 0;
			bunkers[3].bunkerState[i][j] = 0;
		}
	}

	//the empty blocks are already eroded, so set their erosion state to 4
	bunkers[0].bunkerState[2][1] = 4;
	bunkers[0].bunkerState[2][2] = 4;
	bunkers[1].bunkerState[2][1] = 4;
	bunkers[1].bunkerState[2][2] = 4;
	bunkers[2].bunkerState[2][1] = 4;
	bunkers[2].bunkerState[2][2] = 4;
	bunkers[3].bunkerState[2][1] = 4;
	bunkers[3].bunkerState[2][2] = 4;

	//generating lookup table for bunker bitmaps ... maybe find a better way to do this
	//top left corner
	bunkerBitmaps[0][0][0] = bunkerBlockTopCornerLeft;
	bunkerBitmaps[0][0][1] = bunkerBlockTopLeftE1;
	bunkerBitmaps[0][0][2] = bunkerBlockTopLeftE2;
	bunkerBitmaps[0][0][3] = bunkerBlockTopLeftE3;
	bunkerBitmaps[0][0][4] = NULL;
	//left middle block
	bunkerBitmaps[1][0][0] = bunkerBlock;
	bunkerBitmaps[1][0][1] = bunkerBlockE1;
	bunkerBitmaps[1][0][2] = bunkerBlockE2;
	bunkerBitmaps[1][0][3] = bunkerBlockE3;
	bunkerBitmaps[1][0][4] = NULL;
	//left bottom block/...etc
	bunkerBitmaps[2][0][0] = bunkerBlock;
	bunkerBitmaps[2][0][1] = bunkerBlockE1;
	bunkerBitmaps[2][0][2] = bunkerBlockE2;
	bunkerBitmaps[2][0][3] = bunkerBlockE3;
	bunkerBitmaps[2][0][4] = NULL;

	bunkerBitmaps[0][1][0] = bunkerBlock;
	bunkerBitmaps[0][1][1] = bunkerBlockE1;
	bunkerBitmaps[0][1][2] = bunkerBlockE2;
	bunkerBitmaps[0][1][3] = bunkerBlockE3;
	bunkerBitmaps[0][1][4] = NULL;

	bunkerBitmaps[1][1][0] = bunkerBlockBottomCornerLeft;
	bunkerBitmaps[1][1][1] = bunkerBlockBottomLeftE1;
	bunkerBitmaps[1][1][2] = bunkerBlockBottomLeftE2;
	bunkerBitmaps[1][1][3] = bunkerBlockBottomLeftE3;
	bunkerBitmaps[1][1][4] = NULL;

	bunkerBitmaps[2][1][0] = NULL;

	bunkerBitmaps[0][2][0] = bunkerBlock;
	bunkerBitmaps[0][2][1] = bunkerBlockE1;
	bunkerBitmaps[0][2][2] = bunkerBlockE2;
	bunkerBitmaps[0][2][3] = bunkerBlockE3;
	bunkerBitmaps[0][2][4] = NULL;

	bunkerBitmaps[1][2][0] = bunkerBlockBottomCornerRight;
	bunkerBitmaps[1][2][1] = bunkerBlockBottomRightE1;
	bunkerBitmaps[1][2][2] = bunkerBlockBottomRightE2;
	bunkerBitmaps[1][2][3] = bunkerBlockBottomRightE3;
	bunkerBitmaps[1][2][4] = NULL;

	bunkerBitmaps[2][2][0] = NULL;

	bunkerBitmaps[0][3][0] = bunkerBlockTopCornerRight;
	bunkerBitmaps[0][3][1] = bunkerBlockTopRightE1;
	bunkerBitmaps[0][3][2] = bunkerBlockTopRightE2;
	bunkerBitmaps[0][3][3] = bunkerBlockTopRightE3;
	bunkerBitmaps[0][3][4] = NULL;

	bunkerBitmaps[1][3][0] = bunkerBlock;
	bunkerBitmaps[1][3][1] = bunkerBlockE1;
	bunkerBitmaps[1][3][2] = bunkerBlockE2;
	bunkerBitmaps[1][3][3] = bunkerBlockE3;
	bunkerBitmaps[1][3][4] = NULL;

	bunkerBitmaps[2][3][0] = bunkerBlock;
	bunkerBitmaps[2][3][1] = bunkerBlockE1;
	bunkerBitmaps[2][3][2] = bunkerBlockE2;
	bunkerBitmaps[2][3][3] = bunkerBlockE3;
	bunkerBitmaps[2][3][4] = NULL;
}


/**
 * drawBunker:
 * -----------
 * Draws an initialized bunker to the screen
 *
 * num: The bunker to draw (0-3)
 * framePointer0: Pointer to the location in memory that the vdma controller uses to write pixels to the screen
 *
 * todo: update this to call drawBunkerPart to reduce code size
 */
//fix this to call draw bunker part to reduce code size
void drawBunker(u8 num){
	u16 * bunkerBitmap;
	u8 i,j,k,m;
	int x = bunkers[num].position.x, y = bunkers[num].position.y, row, col;

	//for each block of the bunker
	for( i = 0; i < 3; i++ ) {
		for(j = 0; j < 4 ; j++ ) {

		//get the current state bitmap for that block
		bunkerBitmap = bunkerBitmaps[i][j][bunkers[num].bunkerState[i][j]];

		//the bunker portion has either been destroyed, or it is empty, so don't draw it
		if (bunkerBitmap == NULL)
			goto SKIP_DRAWING;

		//drawing the bunker block
		for(row = x, k = 0; row < x + BLOCK_SIZE; row++, k++){
			for(col = y, m = 0 ; col < y + BLOCK_SIZE; col++, m++ ){
				framePointer0[row*640 + col] = bunkerBitmap[k] & (1 << m) ? GREEN : BLACK;
			}
		}
SKIP_DRAWING:
		//go to the next block
			y += BLOCK_SIZE;
		}
		x += BLOCK_SIZE;
		y = bunkers[num].position.y;
	}
}

/**
*
*/
void erodeBunker(int x, int y){
	u8 i, j, bunkerNum;

	//bunkerNum = (y - BUNKER_START) / 120;
	if (y < 220)
		bunkerNum = 0;
	else if (y < 340)
		bunkerNum = 1;
	else if (y < 460)
		bunkerNum = 2;
	else
		bunkerNum = 3;

	i = (x - bunkers[bunkerNum].position.x) / BLOCK_SIZE;
	j = (y - bunkers[bunkerNum].position.y) / BLOCK_SIZE;

	bunkers[bunkerNum].bunkerState[i][j]++;
	drawBunkerPart(bunkerNum, i, j);

}

/**
 * drawBunkerPart:
 * ---------------
 * Draws a bunker block to the frame buffer
 *
 * num: Bunker to draw a piece of
 * i : row of the block to draw
 * j : column of the block to draw
 * framePointer0: Pointer to the location in memory that the vdma controller uses to write pixels to the screen
 */
void drawBunkerPart(int num, int i, int j){

	//calculate the x and y position of the bunker block
	int x = bunkers[num].position.x + i*BLOCK_SIZE, y = bunkers[num].position.y + j*BLOCK_SIZE, k, m, row, col;

	//get the bitmap of that block
	u16 * bunkerBitmap = bunkerBitmaps[i][j][bunkers[num].bunkerState[i][j]];

	//draw the block if it hasn't been completely eroded
	if (bunkers[num].bunkerState[i][j] != 4) {
		for(row = x, k = 0; row < x + BLOCK_SIZE; row++, k++){
			for(col = y, m = 0 ; col < y + BLOCK_SIZE; col++, m++ ){
				if(framePointer0[row*640 + col] != WHITE && framePointer0[row*640 + col] != BLACK )
					framePointer0[row*640 + col] = bunkerBitmap[k] & (1 << m) ? GREEN : BLACK;
			}
		}
	}
	else //erase the block if it has been completely eroded
	{
		for(row = x, k = 0; row < x + BLOCK_SIZE; row++, k++)
			for(col = y, m = 0 ; col < y + BLOCK_SIZE; col++, m++ )
				if(framePointer0[row*640 + col] != WHITE && framePointer0[row*640 + col] != BLACK)
					framePointer0[row*640 + col] = BLACK;
	}

}

