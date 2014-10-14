/*
 * charGen.h
 *
 *  Created on: Oct 6, 2014
 *      Author: superman
 */

#ifndef CHARGEN_H_
#define CHARGEN_H_

#include "global.h"
#include "xbasic_types.h"

/****************************
 *		  Macros
 ****************************/
#define CHAR_SIZE 10
#define ONE_WIDTH 4

#define SCORE_X 5
#define SCORE_Y 5

#define LIVES_X 5
#define LIVES_Y 400


/***********************************
 *      Function definitions
 ***********************************/
void initializeScoreAndLives(void);
void printScore(unsigned score, unsigned startX, unsigned startY, Boolean erase);
void printNumber(int num, int x, int y);
void eraseNumber(u8 digits, unsigned startX, unsigned startY);
void setTextColor(unsigned color);
void printGameOver(void);

#endif /* CHARGEN_H_ */