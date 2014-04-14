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

```Ledx1:  IN s0, rx_data_present
	TEST s0, rx_data_present
	JUMP Z,  Ledx1
	IN s0, uart_rx_port
	OUT s0, uart_tx_port	

	LOAD s4, s0
```

Example of the Switch Code

```	IN s0, switch_high
	Load s2, s0
	OUT s0, uart_tx_port
```
