/*
 * main.c
 *
 *  Created on: Apr 4, 2014
 *      Author: C15Tramaine.Barnett
 */

#include <xuartlite_l.h>
#include <xparameters.h>
#include <xil_io.h>
#include "header.h"

int main(void)
{

 while (1)
 {
  unsigned char c, d, e;
  c = XUartLite_RecvByte(0x84000000);
  XUartLite_SendByte(0x84000000, c);
  d = XUartLite_RecvByte(0x84000000);
  XUartLite_SendByte(0x84000000, d);
  e = XUartLite_RecvByte(0x84000000);
  XUartLite_SendByte(0x84000000, e);

  led(c,d,e);
  swt(c,d,e);

  XUartLite_SendByte(0x84000000, 0x0A); // new line
  XUartLite_SendByte(0x84000000, 0x0D); // beginning of the new line



 }

 return 0;
}



unsigned char led(unsigned char a, unsigned char b, unsigned char c)
{
	if(a == 'l' && b == 'e' && c == 'd'){
		XUartLite_SendByte(0x84000000, 0x20);
		unsigned char y, z;
		y = XUartLite_RecvByte(0x84000000);
		z = XUartLite_RecvByte(0x84000000);

		XUartLite_SendByte(0x84000000, y);
		XUartLite_SendByte(0x84000000, z);
		y = outputUpper(y);
		z = outputLower(z);

		Xil_Out32(0x83000000,y&z);

	}
	return 0;
}

unsigned char swt(unsigned char a, unsigned char b, unsigned char c)
{
	if(a == 's' && b == 'w' && c == 't'){
		XUartLite_SendByte(0x84000000, 0x20);
		unsigned char x, y, z;

		x = Xil_In8(0x83000004);
		y =  x & 0b11110000;
		z =  x & 0b00001111;
		y = topNibbleToAscii(y);
		z = bottomNibbleToAscii(z);
		XUartLite_SendByte(0x84000000, y);
		XUartLite_SendByte(0x84000000, z);

		y = outputUpper(y);
		z = outputLower(z);


		Xil_Out32(0x83000000,y&z);

	}
	return 0;
}

unsigned char outputUpper(unsigned char c){
	unsigned char out;
	if(c == '0'){
		out = 0b00001111;
	}
	else if(c == '1'){
		out = 0b00011111;
	}
	else if(c == '2'){
		out = 0b00101111;
	}
	else if(c == '3'){
		out = 0b00111111;
	}
	else if(c == '4'){

		out = 0b01001111;
	}
	else if(c == '5'){
		out = 0b01011111;
	}
	else if(c == '6'){
		out = 0b01101111;
	}
	else if(c == '7'){
		out = 0b01111111;
	}
	else if(c == '8'){
		out = 0b10001111;
	}
	else if(c == '9'){
		out = 0b10011111;
	}
	else if(c == 'A'){
		out = 0b10101111;
	}
	else if(c == 'B'){
		out = 0b10111111;
	}
	else if(c == 'C'){
		out = 0b11001111;
	}
	else if(c == 'D'){
		out = 0b11011111;
	}
	else if(c == 'E'){
		out = 0b11101111;
	}
	else{
		out = 0b11111111;
	}

	return out;
}

unsigned char outputLower(unsigned char c){
	unsigned char out;
	if(c == '0'){
		out = 0b11110000;
	}
	else if(c == '1'){
		out = 0b11110001;
	}
	else if(c == '2'){
		out = 0b11110010;
	}
	else if(c == '3'){
		out = 0b11110011;
	}
	else if(c == '4'){
		out = 0b11110100;
	}
	else if(c == '5'){
		out = 0b11110101;
	}
	else if(c == '6'){
		out = 0b11110110;
	}
	else if(c == '7'){
		out = 0b11110111;
	}
	else if(c == '8'){
		out = 0b11111000;
	}
	else if(c == '9'){
		out = 0b11111001;
	}
	else if(c == 'A'){
		out = 0b11111010;
	}
	else if(c == 'B'){
		out = 0b11111011;
	}
	else if(c == 'C'){
		out = 0b11111100;
	}
	else if(c == 'D'){
		out = 0b11111101;
	}
	else if(c == 'E'){
		out = 0b11111110;
	}
	else{
		out = 0b11111111;
	}

	return out;
}

unsigned char topNibbleToAscii(unsigned char nibble){
	unsigned char out;
		if(nibble == 0b00000000){
			out = '0';
		}
		else if(nibble == 0b00010000){
			out = '1';
		}
		else if(nibble == 0b00100000){
			out = '2';
		}
		else if(nibble == 0b00110000){
			out = '3';
		}
		else if(nibble == 0b01000000){
			out = '4';
		}
		else if(nibble == 0b01010000){
			out = '5';
		}
		else if(nibble == 0b01100000){
			out = '6';
		}
		else if(nibble == 0b01110000){
			out = '7';
		}
		else if(nibble == 0b10000000){
			out = '8';
		}
		else if(nibble == 0b10010000){
			out = '9';
		}
		else if(nibble == 0b10100000){
			out = 'A';
		}
		else if(nibble == 0b10110000){
			out = 'B';
		}
		else if(nibble == 0b11000000){
			out = 'C';
		}
		else if(nibble == 0b11010000){
			out = 'D';
		}
		else if(nibble == 0b11100000){
			out = 'E';
		}
		else{
			out = 'F';
		}

		return out;
}

unsigned char bottomNibbleToAscii(unsigned char nibble){
	unsigned char out;
		if(nibble == 0b00000000){
			out = '0';
		}
		else if(nibble == 0b00000001){
			out = '1';
		}
		else if(nibble== 0b00000010){
			out = '2';
		}
		else if(nibble == 0b00000011){
			out = '3';
		}
		else if(nibble == 0b00000100){
			out = '4';
		}
		else if(nibble == 0b00000101){
			out = '5';
		}
		else if(nibble == 0b00000110){
			out = '6';
		}
		else if(nibble == 0b00000111){
			out = '7';
		}
		else if(nibble == 0b00001000){
			out = '8';
		}
		else if(nibble == 0b00001001){
			out = '9';
		}
		else if(nibble == 0b00001010){
			out = 'A';
		}
		else if(nibble == 0b00001011){
			out = 'B';
		}
		else if(nibble == 0b00001100){
			out = 'C';
		}
		else if(nibble == 0b00001101){
			out = 'D';
		}
		else if(nibble == 0b00001110){
			out = 'E';
		}
		else{
			out = 'F';
		}

		return out;
}
