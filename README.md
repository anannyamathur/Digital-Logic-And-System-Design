# Digital-Logic-And-System-Design
COL-215 Course Offered By IIT-Delhi in the first semester of the academic year 2020-21 under Professor Anshul Kumar. 

Reference book- [Fundamentals of Digital Logic with VHDL Design](https://www.flipkart.com/fundamentals-digital-logic-vhdl-design-cd-rom/p/itmfbum95rwfqqza)

- [Assignment 1](https://github.com/anannyamathur/Digital-Logic-And-System-Design/blob/main/Assignment%201.pdf)

- Designed a digital clock using VHDL. 

- Designed an image filter in VHDL that uses a 3x3 sliding window for QQVGA size images, with 8-bit pixel resolution. 


- Made use of rotating priorities to modify the arbiter FSM(shown below) to ensure that device 3 will get serviced, such that if it raises a request, the
devices 1 and 2 will be serviced only once before the device 3 is granted its request.



<img width="255" alt="arbiterFSM" src="https://user-images.githubusercontent.com/78497850/107569799-b9f33d80-6c0e-11eb-9299-24e2acd79bd2.PNG">

- [Assignment 4](https://github.com/anannyamathur/Digital-Logic-And-System-Design/blob/main/Assignment%204.pdf)


### Lab Assignments   
- A2: Display decimal/hexadecimal digits using 7-segment displays.
- A3: Design and implement a circuit that takes a 4-digit decimal/hexadecimal number from slide switches and displays it on seven segment displays of BASYS3 FPGA board. Use on-board clock and find valid range of refresh rates.
- A4: Design a circuit that controls brightness of 7-segment LED displays using pulse width modulation. 
- A5: Design a state machine where every state controls a set of multiplexers so that the appropriate BCD digit from the switches is made available at the appropriate display. Also, you control the PWM for each digit. Control the speed of state transition to create a desired effect.
- A6: Design a stopwatch and implement it on BASYS 3 board, using its 7-segment display and push
buttons. Since the display has only 4 digits, assign these as follows - 1 digit for minutes, two
digits for seconds and one digit for tenths of a second. Use three push buttons as follows:
• Start/Continue • Pause • Reset 
- A7: Design asynchronous serial receiver with baud rate = 9600, 8 data bits, no parity bits and 1 stop bit. Connect this to the micro USB port of the BASYS 3 board. Use gtkterm on PC to test and demonstrate.
- A8: Design asynchronous serial transmitter to create a loop with the receiver developed in the previous assignment.
- A9: Design a FIFO buffer with switches as inputs and 7-segment displays as outputs. Also display FIFO status of full and empty on LEDs. Implement memory using BRAM and then design a FIFO.
- A10: Interface the serial receiver and transmitter designed in the previous assignments to a memory module for downloading (PC to BASYS-3) and uploading files (BASYS-3 to PC). 


