

.section    .init
.globl     _start
 
_start:
    b       main
    
.section .text



main:
    	mov     sp, #0x8000 // Initializing the stack pointer
	bl	EnableJTAG // Enable JTAG
	bl	InitUART    // Initialize the UART
	bl	Init_GPIO	//go to Init_GPIO

	ldr	r0, =creatorName				//print creator name
	mov	r1, #27
	bl	WriteStringUART

input:	ldr	r0, =inputMessage				//print input message
	mov	r1, #23
	bl	WriteStringUART


loop:	

	bl	Read_SNES					//Read input
	cmp	r10, r1				//If no new button were pressed, go back to loop
	beq	loop				//prevent loops of message
	mov	r10, r1				//update r10 if new button is pressed


test:	ldr	r7, =0xFEFF		
	cmp	r1, r7				//r1 = FEFF go to aPressed
	beq	aPressed
	ldr	r7, =0xFFFE
	cmp	r1, r7				//r1 = FFFE go to bPressed
	beq	bPressed
	ldr	r7, =0xFDFF			
	cmp	r1, r7				//r1 = FDFF go to xPressed	
	beq	xPressed			
	ldr	r7, =0xFFFD
	cmp 	r1, r7				//r1 = FFFD go to yPressed
	beq	yPressed		
	ldr	r7, =0xFFFB	
	cmp	r1, r7				//r1 = FFFB go to selectPressed
	beq	selectPressed
	ldr	r7, =0xFFF7
	cmp	r1, r7				//r1 = FFF7 go to startPressed
	beq	startPressed
	ldr	r7, =0xFFEF
	cmp	r1, r7				//r1 = FFEF go to upPressed
	beq	upPressed	
	ldr	r7, =0xFFDF
	cmp	r1, r7				//r1 = FFDF go to downPressed
	beq	downPressed			
	ldr	r7, =0xFFBF
	cmp	r1, r7				//r1 = FFBF go to leftPressed
	beq	leftPressed
	ldr	r7, =0xFF7F
	cmp	r1, r7				//r1 = FF7F go to rightPressed
	beq	rightPressed
	ldr	r7, =0xFBFF			
	cmp	r1, r7				//r1 = FBFF go to leftRTPressed
	beq	leftRTPressed
 	ldr	r7, =0xF7FF
	cmp	r1, r7				//r1 = F7FF go to rightRTPressed
	beq	rightRTPressed
	b	loop
aPressed:
	ldr	r0, =aButton			//print A message
	mov	r1, #20
	bl	WriteStringUART
	b	input
bPressed:
	ldr	r0, =bButton			//print B message
	mov	r1, #20
	bl	WriteStringUART
	b	input
xPressed:	
	ldr	r0, =xButton			//print X message
	mov	r1, #20
	bl	WriteStringUART
	b	input
yPressed:
	ldr	r0, =yButton			//print Y message
	mov	r1, #20
	bl	WriteStringUART
	b	input
startPressed:
	ldr	r0, =startButton		//print start message
	mov	r1, #24
	bl	WriteStringUART

	ldr	r0, =exitMessage		//program terminated
	mov	r1, #20
	bl	WriteStringUART
	b	halt$				//go to halt loop

selectPressed:
	ldr	r0, =selectButton		//print select message
	mov	r1, #25
	bl	WriteStringUART
	b	input
upPressed:
	ldr	r0, =upButton			//print up message
	mov	r1, #29
	bl	WriteStringUART
	b	input
downPressed:
	ldr	r0, =downButton			//print down message
	mov	r1, #31
	bl	WriteStringUART
	b	input
leftPressed:
	ldr	r0, =jleftButton		//print left message
	mov	r1, #31
	bl	WriteStringUART
	b	input
rightPressed:
	ldr	r0, =jrightButton		//print right message
	mov	r1, #32
	bl	WriteStringUART
	b	input
leftRTPressed:
	ldr	r0, =leftButton			//print left rt message
	mov	r1, #26
	bl	WriteStringUART
	b	input
rightRTPressed:
	ldr	r0, =rightButton		//print right rt message
	mov	r1, #27
	bl	WriteStringUART
	b	input
Init_GPIO:
LATCH:
	ldr	r0, =0x3F200000			//GPFSEL0			
	ldr	r2, [r0]			//load value into r2	
        mov     r1, #1				//r1 = 001 (output)
        mov     r3, #7                          //r3 = 111            
        lsl     r3, #27                         //offset = 3 * 9 = 27                
        bic     r2, r3                          //clear bit r2                 
	lsl     r1, #27                         //shift r1 to 27 pin                
        orr     r2, r1				//orr operation 		
	str	r2, [r0]			//store new value back to GPIO0		

		
DATA:
	ldr	r0, =0x3F200004			//GPFSEL1		
	ldr	r2, [r0]			//load value into r2		
        mov     r1, #0				//r1 = 000 (input)	
        mov     r3, #0b111                      //r3 = 111  
        bic     r2, r3                          //bit clear r2 with r3            
	orr	r2, r1				//orr operation r2, r1, no need for offset cuz its 							//first 3 pin
	str	r2, [r0]               		//store new value back to GPIO                          

CLOCK:
	ldr	r0, =0x3F200004			//GPFSEL1		
	ldr	r2, [r0]					
        mov     r1, #1				//r1 = 1 (output)	
        mov     r3, #7                          //r3 = 111            
        lsl     r3, #3                          //offset = 3      
        bic     r2, r3                          //bit clear                
        lsl     r1, #3				//left shift		
        orr     r2, r1                          //orr operation                
	str	r2, [r0]			//store new value back to GPIO
	bx	lr				//go back to previous function

Write_Latch:
	cmp	r1, #0				//r0 != 0 go to Write_Latch_1
	bne	Write_Latch_1
	mov	r0, #9				//r0 = pin #9
	ldr	r2, =0x3F200028			//load GPCLR0
	mov	r3, #1				//r3 = 1
	lsl	r3, r0				//align for pin #9
	str	r3, [r2]			//store it back to gpio
	bx	lr				//back to previous function

Write_Latch_1:
	mov	r0, #9				//same process but with GPSET0 gpio function
	ldr	r2, =0x3F20001C			
	mov	r3, #1
	lsl	r3, r0
	str	r3, [r2]
	bx	lr

Write_Clock:
	cmp	r1, #0
	bne	Write_Clock_1
	mov	r0, #11				//pin #11
	ldr	r2, =0x3F200028			//load GPCLR0
	mov	r3, #1				//r3 = 1
	lsl	r3, r0				//align bit for pin #11
	str	r3, [r2]			//set pin
	bx	lr

Write_Clock_1:
	mov	r0, #11				//Same process with GPSET0 
	ldr	r2, =0x3F20001C			//load GPSET0
	mov	r3, #1
	lsl	r3, r0
	str	r3, [r2]
	bx	lr

Read_Data:
	mov	r0, #10				//data line
	ldr	r2, =0x3F200000			//base gpio 
	ldr	r1, [r2, #52]			//gplev0
	mov	r3, #1
	lsl	r3, r0				//align with pin 10
	and	r1, r3				//mask r1
	teq	r1, #0
	moveq	r1, #0				//return 0
	movne	r1, #1				//return 1
	bx	lr

Wait:
	ldr	r0, =0x3F003004			//address of clo
	ldr	r2, [r0]
	add	r2, r1				//add r2 with r1 which is will be input later
waitLoop:
	ldr	r3, [r0]			
	cmp	r2, r3				//stop when clo = r1
	bhi	waitLoop
	bx	lr
Read_SNES:
	mov	r6, #0				//set r6 = 0 

	push	{lr}
	mov	r1, #1
	bl	Write_Clock				//Write Clock #1
	pop	{lr}

	push	{lr}
	mov	r1, #1
	bl	Write_Latch			//Write Latch #1
	pop	{lr}

	push	{lr}
	mov	r1, #12				//Wait 12
	bl	Wait
	pop	{lr}

	push	{lr}
	mov	r1, #0
	bl	Write_Latch			//Write Latch #0
	pop	{lr}
	mov	r5, #0				//set r5 =0

pulseLoop:

	push	{lr}
	mov	r1, #6				//Wait for 6
	bl	Wait
	pop	{lr}
	

	push	{lr}
	mov	r1, #0				//write Clock #0
	bl	Write_Clock
	pop	{lr}


	push	{lr}
	mov	r1, #6
	bl	Wait					//wait for 6
	pop	{lr}
	

	push	{lr}		
	bl	Read_Data				//read Data
	pop	{lr}
	//button[i] = b
	lsl	r1, r5
	orr	r6, r1

	push	{lr}
	mov	r1, #1
	bl	Write_Clock			//clock #1
	pop	{lr}
	//r5++
	add	r5, r5, #1
	cmp	r5, #16			//r5 < #16 back to pulse loop
	blt	pulseLoop
	mov	r1, r6			//r1 = r6 = button pressed
	bx	lr

halt$:	b	halt$
.section	.data
.align 2

creatorName:
	.ascii	"Made by Quang Huy Nguyen \r\n"		//29
inputMessage:
	.ascii	"Please press a button\r\n"		//25
aButton:
	.ascii	"You have pressed A\r\n"		//22
bButton:
	.ascii	"You have pressed B\r\n"		//22
xButton:
	.ascii	"You have pressed X\r\n"		//22
yButton:
	.ascii	"You have pressed Y\r\n"		//22
startButton:
	.ascii	"You have pressed Start\r\n"		//26
selectButton:
	.ascii	"You have pressed Select\r\n"		//27
upButton:
	.ascii	"You have pressed Joy-Pad Up\r\n"	//31
downButton:
	.ascii	"You have pressed Joy-Pad Down\r\n"	//33
jleftButton:
	.ascii	"You have pressed Joy-Pad Left\r\n"	//33
jrightButton:
	.ascii	"You have pressed Joy-Pad Right\r\n"	//34
leftButton:
	.ascii	"You have pressed Left RT\r\n"		//28
rightButton:
	.ascii	"You have pressed Right RT\r\n"		//29
exitMessage:
	.ascii	"Program Terminated\r\n"		//22


