.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    	mov    	sp, #0x8000 // Initializing the stack pointer
	bl	EnableJTAG // Enable JTAG


	bl	InitFrameBuffer
	bl	Init_GPIO
	bl	clearScreen
	bl	drawMenu
	bl	menuControls
	
.globl haltLoop$
haltLoop$:
	b	haltLoop$

end:

	pop		{r4, r5, pc}




.section .data  

