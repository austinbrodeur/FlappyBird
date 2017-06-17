	.section .text


// This section controls all main menu interations.
	.globl menuControls
menuControls:
	push 	{r0-r12, lr}
	mov	r4, #1			//Set value for start or quit game
loop:	bl	Read_SNES
	cmp	r10, r1
	beq	loop
	mov	r10, r1

	ldr	r7, =0xFFEF
	cmp	r1, r7
	beq	upPressed
	ldr	r7, =0xFFDF
	cmp	r1, r7
	beq	downPressed
	ldr	r7, =0xFEFF		
	cmp	r1, r7
	beq	aPressed
	b	loop
aPressed:
	cmp	r4, #1
	beq	startGame
	b	haltLoop$
startGame:
	bl	clearScreen
	bl	drawBird
	b	loop
upPressed:
	bl	drawCursorPlay
	bl	clearCursorQuit
	mov	r4, #1			//r4 = start game	
	b	loop
downPressed:
	bl	drawCursorQuit
	bl	clearCursorPlay
	mov	r4, #2			//r4 = quit game
	b	loop

	pop	{r0-r12, lr}
	bx	lr

.section .data
