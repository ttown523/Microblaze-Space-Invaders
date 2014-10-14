/*
 * global.c
 *
 *  Created on: Oct 1, 2014
 *      Author: superman
 */

#include "global.h"
#include "bunker.h"
#include "tank.h"
#include "aliens.h"
#include "bullet.h"
#include "charGen.h"
#include "spaceship.h"
#include <time.h>
#include <stdlib.h>
#include "mb_interface.h"

unsigned int * framePointer0;
unsigned score = 0;
Boolean gameOver;
/**
 *	Set the frame pointer that will be written to, so that all files will have access to it
 */
void setFramePointer(unsigned int * framePointer){
	framePointer0 = framePointer;
}


/**
 *
 */
void clearScreen(void){
	int row=0, col=0;
	//clear screen
	for( row=0; row<480; row++)
		for(col=0; col<640; col++)
			framePointer0[row*640 + col] = BLACK;
}

/**
 * Function: initScene
 * -------------------
 * 	Initializes the tank, aliens, bunkers, and bullets when the program
 * 	is programmed to the board.
 *
 */
void initScene(void){
	gameOver = F;
	srand(time(NULL));
	initTankPos();
	initAliens();
	initBunkers();
	initAlienBullets();
}



/**
 * Function: render
 * -------------------
 * 	Draws the bunker, aliens, and tank to the screen after the program has been initialized
 *
 * 	framePointer0: Pointer to the location in memory that the vdma controller uses to write pixels to the screen
 *
 */
void render(void) {
	drawBunker(0);
	drawBunker(1);
	drawBunker(2);
	drawBunker(3);
	drawAliens();
	drawTank();
	initializeScoreAndLives();
	printNumber(0, 5, 5 + 70);
	drawTankLife(0);
	drawTankLife(1);
	drawTankLife(2);
}

/**
 *
 */
void incrementScore(unsigned amount) {
	setTextColor(GREEN);
	printScore(score+=amount, SCORE_START_X, SCORE_START_Y, T);
}

/**
 *
 */
unsigned getRandomNumber(void){
	return rand();
}

void gameEnded(void){
	gameOver = T;
}

void game_over(void){
	microblaze_disable_interrupts();
	clearScreen();
	printGameOver();
}

