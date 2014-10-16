/*
 * aliens.c
 *
 *  Created on: Oct 1, 2014
 *      Author: superman
 */

#include "aliens.h"
#include "bullet.h"
#include "tank.h"

static Aliens aliens;

/*Alien explosion variables*/
static pos_t alienExplosionPos;
Boolean alienExplosionInProgress;

/*Alien animation timers*/
unsigned alienSpeed;
unsigned alienFireRate;

/***************************
 *	  Alien Bitmaps
 ***************************/
const int alienExplosion[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
};
const int topOutAlienSymbol[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,1,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,1,0,0,1,1),
};

const int topInAlienSymbol[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0),
};

//Bitmaps for the middle line of aliens
const int middleOutAlienSymbol[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
};

const int middleInAlienSymbol[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0),
};

//bitmap for the bottom line of aliens
const int bottomOutAlienSymbol[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
};

const int bottomInAlienSymbol[ALIEN_HEIGHT] =
{
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0),
	packWord32(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0),
};


/*
 * initAliens:
 * -----------
 * Initializes the alien block to its default value when the game begins
 */
void initAliens(void){
	int i;
	//init position
	aliens.position.x = 75;
	aliens.position.y = 100;
	aliens.prev_position.x = 50;
	aliens.prev_position.y = 150;

	//init other variables
	aliens.columns = 11;
	aliens.rows = 4;
	aliens.alienIn = T;
	aliens.moveDir = RIGHT;
	aliens.colStart = 0;
	aliens.movingDown = F;
	aliens.killCount = 0;
	aliens.bottomRowPos = aliens.position.x + (ALIEN_HEIGHT * 5) + (4*ALIEN_VERTICAL_SPACING);

	//make each alien alive
	for (i = 0;  i < 55; i++){
		aliens.alive[i] = T;
	}

	//initialize lowest alien
	for ( i = 0; i < 11; i++ ){
		aliens.lowestAlien[i] = 44 + i;
	}

	alienExplosionPos.x = 0;
	alienExplosionPos.y = 0;
	alienSpeed = 53;  //initialize alien speed
	alienExplosionInProgress = F;
	alienFireRate = 200; //initial alien fire rate
}

/**
 * drawAliens:
 * -----------
 * Writes the alien block to the frame buffer
 */
void drawAliens(void){
	unsigned short row=0, col=0, x = aliens.position.x, y = aliens.position.y, alienWidth = TOP_ALIEN_WIDTH;
	u8 alienPos=0, i = 0, j = 0;

	int * alienSymbol = (aliens.alienIn == T) ? topInAlienSymbol: topOutAlienSymbol ;

	//prints an alien at the x,y position specified
	for (alienPos = 0; alienPos < 55; alienPos++) {
		if (aliens.alive[alienPos] == T) {
			for (row = x, i = 0;  row < x + ALIEN_HEIGHT; row++, i++)
				for (col = y, j = 0 ; col < y + alienWidth; col++, j++)
					framePointer0[row*640 + col] = alienSymbol[i] & (1 << j) ? WHITE : BLACK ;

			//delete the part of the alien that needs to be deleted
			deleteAlienPart(x, y, alienWidth);
		}

		//change the alien bitmap to draw different aliens on different rows
		//also change the alien width for each alien.
		if (alienPos == 32){ //after this is the bottom row
			alienSymbol = (aliens.alienIn == T) ? bottomInAlienSymbol : bottomOutAlienSymbol;
			alienWidth = BOTTOM_ALIEN_WIDTH;
		}
		else if (alienPos == 10){ // after this is the middle row
			alienSymbol = (aliens.alienIn == T) ? middleInAlienSymbol : middleOutAlienSymbol;
			alienWidth = MIDDLE_ALIEN_WIDTH;
		}

		//update the row and column after 11 aliens have been drawn
		if( (alienPos + 1) % 11 == 0 ){
			x += ALIEN_HEIGHT + ALIEN_VERTICAL_SPACING;
			y = aliens.position.y;
		}
		else { //update the column only
			y+= ALIEN_WIDTH;
		}
	}

	//check to see if we need to move down now
	unsigned short testLeft = aliens.position.y + aliens.colStart*ALIEN_WIDTH, testRight = aliens.position.y + aliens.columns*ALIEN_WIDTH ;

	if ( aliens.movingDown == T)
		aliens.movingDown = F;
	else if (testRight >= 630 || testLeft < 15 )
		aliens.movingDown = T;
}

/**
 *	deleteAlienPart:
 *	---------------
 *	Deletes the part of the alien that is no longer valid once it has moved
 *
 *	Parameters:
 *		x - new row position of the alien
 *		y - new column position of the alien
 *		alienWidth - Width of the alien to delete
 */
void deleteAlienPart(int x, int y, int alienWidth){
	int row, col;
	if (aliens.movingDown == F) {
		switch (aliens.moveDir){
		case RIGHT://erase to the left of the alien
			for(row = x; row < x + ALIEN_HEIGHT ; row++)
				for (col = y - HORIZONTAL_MOVE; col < y; col++)
					 framePointer0[row*640 + col] = BLACK ;
			break;
		case LEFT://erase to the right of the alien
			for(row = x ; row < x + ALIEN_HEIGHT; row++)
				for (col = y + alienWidth; col < y + alienWidth + HORIZONTAL_MOVE ; col++)
					 framePointer0[row*640 + col] = BLACK ;
			break;
		default:
			break;
		}
	}
	else {//the aliens moved down...erase the top of the alien
		for(row = x - (( x-aliens.position.x < 16) ? VERTICAL_MOVE : ALIEN_VERTICAL_SPACING) ; row < x; row++)
			for (col = y; col < y + alienWidth; col++)
				 framePointer0[row*640 + col] = BLACK ;
	}
}

/**
 * moveAliens:
 * -----------
 * Move the aliens by a constant number of pixels
 */
void moveAliens(void){

	if (aliens.movingDown == T){ //move the aliens down

		aliens.position.x += VERTICAL_MOVE;
		aliens.moveDir = !aliens.moveDir; //change the alien move direction

		if ( (alienSpeed -= SPEED_UP_AMOUNT) < MAX_ALIEN_SPEED) //update the alien speed
			alienSpeed = MAX_ALIEN_SPEED;

		//check to see if we have reached below the bunkers
		aliens.bottomRowPos += VERTICAL_MOVE;
		if(aliens.bottomRowPos > BELOW_THE_BUNKERS)
			gameEnded();
	}
	else {
		aliens.position.y += (aliens.moveDir== RIGHT) ? HORIZONTAL_MOVE : -HORIZONTAL_MOVE ;
		aliens.alienIn = (aliens.alienIn == T) ? F : T;
	}
}

/**
* killAlien:
* ----------
* Kill the alien at the specified index
*
*/
void killAlien(int index){

	unsigned col, row;

	aliens.alive[index] = F;

	//if 55 aliens have been killed, start the next level
	if (++aliens.killCount == 55){
		addTankLife();
		gameEnded(); //this will be changed once levels are implemented
		aliens.killCount = 0;
		//reset alien block slightly lower
	}

	if ((alienFireRate - 5) >MAX_BULLET_RATE) //increase the alien fire rate
		alienFireRate -= 5;

	col = index % 11;
	while(aliens.alive[ aliens.lowestAlien[col] ] == F)  //update the lowestAlien array...for firing alien bullets
		aliens.lowestAlien[col] -=11;
	while( aliens.lowestAlien[aliens.colStart] < 0 )  //check to see if the leftmost column is gone
		aliens.colStart++;
	while ( aliens.lowestAlien[aliens.columns-1] < 0) //check to see if the rightmost column is gone
		aliens.columns--;

	row = index / 11;
	++aliens.rowHits[row];
	while ( aliens.rowHits[aliens.rows] == 11 ){ //check to see if the bottom row is gone
		aliens.rows--;
		aliens.bottomRowPos -= ALIEN_HEIGHT + ALIEN_VERTICAL_SPACING;
	}

	//update score
	if (index < 11)
		incrementScore(40);
	else if (index < 32 )
		incrementScore(20);
	else
		incrementScore(10);

	drawAlienExplosion(index/11, col);
}

/**
 * drawAlienExplosion:
 * -------------------
 */
void drawAlienExplosion(unsigned short row, unsigned short col) {

	int i, j;

	//calculate the alien explosion position
	alienExplosionPos.y = aliens.position.y  + col*ALIEN_WIDTH;
	alienExplosionPos.x = aliens.position.x + row*(ALIEN_HEIGHT + ALIEN_VERTICAL_SPACING);

	//draw an alien explosion at the new location
	for (row = alienExplosionPos.x, i = 0 ; row < alienExplosionPos.x + ALIEN_HEIGHT ; row++, i++)
		for (col = alienExplosionPos.y, j = 0; col < alienExplosionPos.y + EXPLOSION_WIDTH ; col++, j++)
			framePointer0[row*640 + col] = alienExplosion[i] & (1 << j) ? OFF_WHITE : BLACK;

	alienExplosionInProgress = T;
}

/**
 *  eraseAlienExplosion
 *  -------------------
 *	Erase the alien explosion
 */
void eraseAlienExplosion(void){
	int i, j, row, col;

	for (row = alienExplosionPos.x, i = 0 ; row < alienExplosionPos.x + ALIEN_HEIGHT ; row++, i++)
		for (col = alienExplosionPos.y, j = 0; col < alienExplosionPos.y + EXPLOSION_WIDTH ; col++, j++)
			framePointer0[row*640 + col] = BLACK;

	//reset explosion variables
	alienExplosionPos.x = 0;
	alienExplosionPos.y = 0;
	alienExplosionInProgress = F;
}

/**
 * launchAlienBullet:
 * -----------------
 * Chooses a random alien on the bottom row, and places a bullet directly under him
 *
 */
void launchAlienBullet(void) {
	u8 bulletNum = getFirstAvailableBullet();

	if(bulletNum == 4) //no bullets are available, so return
		return;

	int col = getRandomNumber() % 11, row, startX, startY;

	//keep getting a column until one is found
	while(aliens.lowestAlien[col] < 0)
		col = getRandomNumber() % 11;

	//calculate the position of the lowest alien in that column
	row = aliens.lowestAlien[col] / 11;
	startX = aliens.position.x + (row* (ALIEN_HEIGHT + ALIEN_VERTICAL_SPACING)) + ALIEN_HEIGHT;
	startY = aliens.position.y + (col * ALIEN_WIDTH) + (ALIEN_HALF_WIDTH);

	//if the bullet is launched into the bunker, don't display it
	if ( launchedIntoBunker (startX, startY) == F )
		placeAlienBullet(bulletNum, startX, startY, (getRandomNumber()%2) ? T : F );
}

/**
*	getAlienIndex:
*	--------------
*	Returns the alien index of the specified row and column value
*
*	Parameters:
*		x - row pixel on the screen
*		y - column pixel on the screen
*/
unsigned short getAlienIndex(unsigned short x, unsigned short y){
	unsigned short row, col, visibleAlienBlock;

	row = (x - aliens.position.x) / (ALIEN_HEIGHT + ALIEN_VERTICAL_SPACING) ;
	visibleAlienBlock = aliens.position.y + aliens.colStart*ALIEN_WIDTH;
	col = ((y - visibleAlienBlock)/ALIEN_WIDTH) + aliens.colStart;

	return (row*11 + col);
}

