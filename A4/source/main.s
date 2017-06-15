.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    	mov    	sp, #0x8000 // Initializing the stack pointer
	bl	EnableJTAG // Enable JTAG


	bl	InitFrameBuffer
	bl	clearScreen
	
drawMenu:
	mov	r0, #0
	mov	r1, #0
	mov	r2, =background
	mov	r3, #1024
	mov	r4, #768
	bl	drawImage

	mov	r0, #350
	mov	r1, #500
	mov	r2, =startButton
	mov	r3, #300
	mov	r4, #188
	bl	drawImage

	mov	r0, #700
	mov	r1, #500
	mov	r2, =quitButton
	mov	r3, #300
	mov	r4, #188
	bl	drawImage

	mov	r0, #500
	mov	r1, #594
	mov	r2, =cursorButton
	mov	r3, #150
	mov	r4, #100
	bl	drawImage

haltLoop$:
	b	haltLoop$

end:

	pop		{r4, r5, pc}




.section .data  

