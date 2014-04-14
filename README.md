remoteterminal
==============

Purpose :  By using a USB-to-UART bridge, you will create a program that can take a command written over your computer's 
serial port (i.e., remote terminal) and read or write to any one of your input or output peripherals. Control the following
on your development board: LEDs and switches.



Part A: PicoBlaze
====================

using openPicide I created a software implementation to read in "LED" or "SWT" in order to either change the LEDs on the
FPGA or read in the switch values from the FPGA. openPicide allowed us to write code in assembly and the export a vhd file
using the vhd template.

Example of the LED code

```
Ledx1:  IN s0, rx_data_present
	TEST s0, rx_data_present
	JUMP Z,  Ledx1
	IN s0, uart_rx_port
	OUT s0, uart_tx_port	

	LOAD s4, s0
```

Example of the Switch Code

```
IN s0, switch_high
	Load s2, s0
	OUT s0, uart_tx_port
```


After the vhd file was created it was instantiated in ISE. The code was given for uart and I only had to create a few signals.

```
   rx: uart_rx6 
   port map (      serial_in => serial_in,
                   en_16_x_baud => en_16_x_baud,
                   data_out => uart_rx_data_out,
                   buffer_read => write_data_present,
                   buffer_data_present => read_data_present,
                   buffer_half_full => open,
                   buffer_full => open,
                   buffer_reset => '0',              
                   clk => clk

				);
```

The hardest part of this lab was figuring out what was given to me and what I had to create myself and how to make them all work together.


Part B: Microblaze
===================


The mircroblaze portion had the same purpose as the picoBlaze just using different software. This part of the lab was much more difficult than the first. After finally getting the proper version of ISE installed and getting through the tutorial it became a lot easier. Rather than creating a new index I used C2C jason mossings decimal to binary converter. Once I understood all of the addressing between SDK and platform studio, writing the code became much easier. 


```
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

```

Schematic

![schematic](picture.jpg)



Test/Debug
===========

During the microBlaze portion I got stuck a lot more than on the first portion. On many of the problems if there was an error I was able to look at the error description and figure out the problem. As for the other problems, I typically had to rely on the expertise of a classmate who had gotten the same error or help from Dr. York.

Conclusion
=============

I learned how to rely on the documentation in order to figure out how to make hardware and software work together. I am now able to write simple software and instantiate it within a hardware configuration.
