	.section .text


// This section controls all main menu interations.
	.globl menuControls
menuControls:
	push 	{r0-r12, lr}
	mov	r4, #1			//Set value for start or quit game
menuLoop:
	bl	Read_SNES
	cmp	r10, r1
	beq	menuLoop
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
	b	menuLoop
aPressed:
	cmp	r4, #1
	beq	startGame
	b	haltLoop$
startGame:
	b	waitforUp		// Jump to waitforup if game is started
upPressed:
	bl	drawCursorPlay
	bl	clearCursorQuit
	mov	r4, #1			//r4 = start game	
	b	menuLoop
downPressed:
	bl	drawCursorQuit
	bl	clearCursorPlay
	mov	r4, #2			//r4 = quit game
	b	menuLoop

	pop	{r0-r12, lr}
	bx	lr



// Draws the first level and waits for the user to press up to start the game
	.globl waitforUp
waitforUp:
	bl	firstLevel
waitLoop:
	bl	Read_SNES
	cmp	r10, r1
	beq	waitLoop
	mov	r10, r1
	
	ldr	r7, =0xFFEF
	cmp	r1, r7
	beq	startMove
	b	waitLoop



	
// Starts the game when up is pressed
	.globl startMove
startMove:
	bl	clearuptoStart

startLoop:
	mov	r11, #0	
	bl	Read_SNES
	cmp	r10, r1
	beq	moveDown
	mov	r10, r1
	ldr	r7, =0xFFEF
	cmp	r1, r7
	beq	moveUp

moveUp:
	bl	upFlappy
	add	r11, r11, #1
	cmp	r11, #10
	blt	moveUp
	b	startLoop
moveDown:	bl	moveFlappy
	b	startLoop
	

.section .data
