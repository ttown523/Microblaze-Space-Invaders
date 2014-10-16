/*
 * bullet.c
 *
 *  Created on: Oct 1, 2014
 *      Author: superman
 */

#include "bullet.h"
#include "bunker.h"
#include "tank.h"

AlienBullet bullets[4];

/***********************************
 *		Alien Bullet Bitmaps
 **********************************/
u8 alienBulletCrossUp[BULLET_HEIGHT] =
{
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,1,1,1,1),
		packWord8(0,0,1,1,1,1,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
};

u8 alienBulletCrossMiddle[BULLET_HEIGHT] =
{
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,1,1,1,1),
		packWord8(0,0,1,1,1,1,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
};

u8 alienBulletCrossDown[BULLET_HEIGHT] =
{
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,1,1,1,1),
		packWord8(0,0,1,1,1,1,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
};

u8 alienBulletZigZagRight[BULLET_HEIGHT] =
{
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
};

u8 alienBulletZigZagFarRight[BULLET_HEIGHT] =
{
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,1,1,0,0,0,0),
};

u8 alienBulletZigZagLeft[BULLET_HEIGHT] =
{
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
};

u8 alienBulletZigZagFarLeft[BULLET_HEIGHT] =
{
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,1,1,0,0,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,1,1,0,0),
		packWord8(0,0,0,0,0,0,1,1),
		packWord8(0,0,0,0,0,0,1,1),
};

//Look up tables used for bullet animation
u8 * crossBulletBitmaps[4] = { alienBulletCrossUp, alienBulletCrossMiddle, alienBulletCrossDown, alienBulletCrossMiddle };
u8 * zigzagBulletBitmaps[6] = {alienBulletZigZagLeft, alienBulletZigZagFarLeft, alienBulletZigZagLeft,
								alienBulletZigZagRight, alienBulletZigZagFarRight, alienBulletZigZagRight };


/***********************************
 *	    Alien Bullet Functions
 **********************************/

/**
 * initAlienBullets:
 * -----------------
 * Initializes the alien bullets on program start
 */
void initAlienBullets(void){
	u8 i;
	for(i = 0; i < 4; i++) {
		bullets[i].inFlight = F;
		bullets[i].position.x = 0;
		bullets[i].position.y = 0;
	}
}

/**
 * drawAlienBullet:
 * ----------------
 * Draws the specified alien bullet at its current position.  If the bullet attempts to draw
 * over a green pixel, a collision is detected and handled
 *
 * num: Which alien bullet to draw (0-3)
 */
void drawAlienBullet(int num){
	int row, col, i, j, x = bullets[num].position.x, y = bullets[num].position.y;

	//get the current bitmap in the bullet animation
	u8 * bulletBitmap = (bullets[num].type == CROSS) ? crossBulletBitmaps[bullets[num].bulletState] \
												     : zigzagBulletBitmaps[bullets[num].bulletState];

	//draw the bullet into the frame buffer
	for( row = x, i = 0 ; row < x + BULLET_HEIGHT; row++, i++)
		 for(col = y, j = 0; col < y + ALIEN_BULLET_WIDTH; col++, j++) {
			 if(framePointer0[row*640 + col] == GREEN) { //collision check,
				 //erase the bullet, then erode
				 eraseAlienBullet(num);
				 collision(num, row, col);
				 return;
			}
			else
				framePointer0[row*640 + col] = bulletBitmap[i] & (1 << j) ? OFF_WHITE : BLACK ;
		 }
}

/**
 * moveAlienBullets:
 * -----------------
 * Move each alien bullet by a constant number of pixels if they are in flight
 *
 */
void moveAlienBullets(void) {
	int i, row, col;
	for (i = 0; i < 4; i++){
		if(bullets[i].inFlight == T) { //only move a bullet if its in flight
			if( bullets[i].position.x < 480 ) { //check to see if the bullet has gone off screen

				//erase old alien bullet
				for( row = bullets[i].position.x; row < bullets[i].position.x + BULLET_MOVE_LENGTH; row++)
					 for(col = bullets[i].position.y; col < bullets[i].position.y + ALIEN_BULLET_WIDTH; col++)
						 framePointer0[row*640 + col] = BLACK;

				bullets[i].position.x += BULLET_MOVE_LENGTH;
				bullets[i].bulletState++;
				//move the bullet animation to the next state
				if ((bullets[i].type == CROSS && bullets[i].bulletState > 3) || (bullets[i].type == ZIGZAG && bullets[i].bulletState > 5 ) ){
					bullets[i].bulletState = 0;
				}

				//redraw alien bullet
				drawAlienBullet(i);
			}
			else{ //the bullet has gone off screen
				bullets[i].inFlight = F;
				bullets[i].bulletState = 0;
			}
		}
	}
}

/**
 * eraseAlienBullet:
 * -----------------
 * Erases the alien bullet after a collision
 *
 * Parameters:
 * 		num: bullet number (0-3)
 */
void eraseAlienBullet(u8 num) {

	int row, col;

	//erase old alien bullet
	for( row = bullets[num].position.x - BULLET_MOVE_LENGTH; row < bullets[num].position.x + BULLET_HEIGHT; row++)
		 for(col = bullets[num].position.y; col < bullets[num].position.y + ALIEN_BULLET_WIDTH; col++)
			 if (framePointer0[row*640 + col] == OFF_WHITE)//only erase the white part of the bullet
				 framePointer0[row*640 + col] = BLACK;

	bullets[num].inFlight = F;
}

/**
 *	collision:
 *	----------
 *	Called if an alien bullet collision is detected
 */
void collision(u8 bulletNum, int x, int y) {

	if (bullets[bulletNum].position.x > BELOW_THE_BUNKERS) // the tank has been hit
		killTank();
	else//find the bunker that has been hit
		erodeBunker(x, y);
}

/**
 * placeAlienBullet:
 * -----------------
 * Place the alien bullet in its starting location:
 *
 * Parameters:
 * 		num - the alien bullet number to place
 * 		x - row on the screen to place the bullet
 * 		y - column on the screen to place the bullet:
 * 		cross - True if the bullet to place is a cross bullet
 */
void placeAlienBullet(u8 num, int x, int y, Boolean cross) {

	bullets[num].position.x = x;
	bullets[num].position.y = y;
	bullets[num].inFlight = T;
	bullets[num].bulletState = 0;
	bullets[num].type = cross == T ? CROSS : ZIGZAG;
	drawAlienBullet(num);
}

/**
 * getFirstAvailableBullet:
 * ------------------------
 * Finds the first alien bullet that can be fired.
 *
 * Returns: The number of the first available bullet:
 * 		    (0-3) if there is a bullet available, 4 otherwise;
 */
u8 getFirstAvailableBullet() {
	u8 i;
	for(i = 0; i < 4; i++) {
		if(bullets[i].inFlight == F)
			return i;
	}
	return 4;
}

/**
 * launchedIntoBunker:
 * -------------------
 * Tests to see if a recently launched alien bullet was launched directly into the bunker.
 *
 * Return: True if the alien bullet was launched into the bunker
 */
Boolean launchedIntoBunker(unsigned short startX, unsigned short startY ){

	unsigned short row, col, i, j;

	for (row = startX, i = 0 ; row < startX + BULLET_HEIGHT ; row++, i++)
		for (col = startY, j = 0; col < startY + ALIEN_BULLET_WIDTH ; col++, j++)
			if (framePointer0[row*640 + col] == GREEN ){ //the bullet has been launched into the bunker
				erodeBunker(row, col);
				return T;
			}

	return F;
}
