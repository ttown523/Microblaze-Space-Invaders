/*
 * charGen.c
 *
 *  Created on: Oct 6, 2014
 *      Author: superman
 */

#include "charGen.h"


/************************************
 * 		Character Bitmaps
 ************************************/

const u16 S[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
};

const u16 C[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
};

const u16 O[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
};

const u16 R[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
};

const u16 E[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
};

const u16 L[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
};

const u16 I[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
};

const u16 V[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
};

const u16 G[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
};

const u16 A[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
};

const u16 M[CHAR_SIZE] = {
	packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1),
	packWord16(0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
	packWord16(0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1),
};

const u16 one[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0),
};

const u16 two[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
};

const u16 three[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
};

const u16 four[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
};

const u16 five[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
};

const u16 six[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
};

const u16 seven[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0),
};

const u16 eight[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
};

const u16 nine[CHAR_SIZE] = {
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
	packWord16(0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0),
};

//look up table for numbers;
const u16 * numbers [10] = {
	O, one, two, three, four, five, six, seven, eight, nine
};

//keeps track of the current text color
static unsigned textColor = GREEN;


/**
 * setTextColor:
 * ------------
 * Sets the text color to be written
 */
void setTextColor(unsigned color){
	textColor = color;
}

/**
*	initializeScoreAndLives:
*	------------------------
*	This function prints "SCORE" and "LIVES" to the correct position on the screen
*/
void initializeScoreAndLives(void){

	unsigned short i, j, k, row, col, y1 = SCORE_Y, y2 = LIVES_Y, charSize = 0;
	u16 * scoreChar;
	u16 * livesChar;

	//Switch the character to print each time through the loop
	for(k = 0; k < 5; k++){
		switch(k){
			case 0:
				scoreChar = S;
				livesChar = L;
				break;
			case 1:
				scoreChar = C;
				livesChar = I;
				charSize = 2;
				goto SKIP;
				break;
			case 2:
				scoreChar = O;
				livesChar = V;
				break;
			case 3:
				scoreChar = R;
				livesChar = E;
				break;
			case 4:
				scoreChar = E;
				livesChar = S;
				break;
			default:
				break;
		}

		charSize = CHAR_SIZE;
SKIP:
		//print score character
		for (row = SCORE_X, i = 0 ; row < SCORE_X + CHAR_SIZE; row++, i++)
			for (col = y1, j = 0; col < y1 + CHAR_SIZE; col++, j++)
				framePointer0[row*640 + col] = scoreChar[i] & (1 << j) ? OFF_WHITE : BLACK;

		//print lives character
		for (row = LIVES_X, i = 0 ; row < LIVES_X + CHAR_SIZE; row++, i++)
			for (col = y2, j = 0; col < y2 + charSize; col++, j++)
				framePointer0[row*640 + col] = livesChar[i] & (1 << j) ? OFF_WHITE : BLACK;

		y1 += CHAR_SIZE + 1;
		y2+= charSize + 1;
	}
}

/**
 *	printScore:
 *	-----------
 *	Decodes the current score into its corresponding digits,
 *	and prints each digit to the screen
 *
 *	score: Score to print
 *	startX: Row to start printing the score
 *	startY: column to start printing the score
 *	erase: True if the score at the old position should be erased
 */
void printScore(unsigned score, unsigned startX, unsigned startY, Boolean erase){

	unsigned short digits [10];
	short i = 0;
	unsigned short y = startY;//SCORE_START_Y;

	//find each digit of the score
	for (i = 0; score != 0; i++){
		digits[i] = score % 10;
		score = score / 10;
	}

	if(erase == T)
		eraseNumber(i, startX, startY );

	//print each digit
	for( --i ; i >= 0; i--){
		printNumber(digits[i], startX, y);
		y += ((digits[i] == 1) ? ONE_WIDTH : CHAR_SIZE) + 1;
	}
}

/**
 * eraseNumber:
 * ------------
 * Erases the specified number of digits off of the screen at the given location
 */
void eraseNumber(u8 digits, unsigned startX, unsigned startY) {
	int row, col;
	for (row = startX; row < startX + CHAR_SIZE; row++)
		for (col = startY; col < startY + (digits*CHAR_SIZE) + digits  ; col++)
			framePointer0[row*640 + col] = BLACK;

}

/**
 *	printNumber:
 *	------------
 *	Prints a single digit to the screen at the (x,y) location
 *
 *	num: digit to print
 *	x: row to start printing
 *	y: column to start printing
 */
void printNumber(int num, int x, int y){
	int row, col, i, j;

	for (row = x, i = 0 ; row < x + CHAR_SIZE; row++, i++)
		for (col = y, j = 0; col < y + ((num == 1)? ONE_WIDTH : CHAR_SIZE) ; col++, j++)
			framePointer0[row*640 + col] = numbers[num][i] & (1 << j) ? textColor : BLACK;
}


/*
*	printGameOver:
*	-------------
*	Prints the string "GAME OVER" to the screen once the game has ended
*
*/
void printGameOver(void) {
	unsigned i, j, k, row, col, y = 280, charWidth;
	u16 * character;

	for(k = 0; k < 8; k++){
		switch(k){
			case 0:
				character = G;
				break;
			case 1:
				character = A;
				break;
			case 2:
				character = M;
				charWidth = CHAR_SIZE + 4;
				goto M_SKIP;
				break;
			case 3:
				character = E;
				break;
			case 4:
				character = O;
				break;
			case 5:
				character = V;
				break;
			case 6:
				character = E;
				break;
			case 7:
				character = R;
				break;
			default:
				break;
		}

		charWidth = CHAR_SIZE;

M_SKIP:

		//print score character
		for (row = 230, i = 0 ; row < 230 + CHAR_SIZE; row++, i++)
			for (col = y, j = 0; col < y + charWidth; col++, j++)
				framePointer0[row*640 + col] = character[i] & (1 << j) ? WHITE : BLACK;

		y += charWidth + (k ==3  ? 7 : 1);
	}
}
