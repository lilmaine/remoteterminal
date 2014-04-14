/*
 * header.h
 *
 *  Created on: Apr 9, 2014
 *      Author: C15Tramaine.Barnett
 */

#ifndef HEADER_H_
#define HEADER_H_

unsigned char led(unsigned char a, unsigned char b, unsigned char c);
unsigned char outputUpper(unsigned char c);
unsigned char outputLower(unsigned char c);
unsigned char topNibbleToAscii(unsigned char nibble);
unsigned char bottomNibbleToAscii(unsigned char nibble);
unsigned char swt(unsigned char a, unsigned char b, unsigned char c);

#endif /* HEADER_H_ */
