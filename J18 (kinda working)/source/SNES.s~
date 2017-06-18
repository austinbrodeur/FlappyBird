.globl	Init_GPIO
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
.globl	Read_SNES
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
