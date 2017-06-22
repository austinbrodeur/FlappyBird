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
	bl	clearScreen
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
	cmp	r10, r1		// If nothing is pressed, flappy moves down
	beq	moveDown
	mov	r10, r1
	
	ldr	r7, =0xFFEF	// If up is pressed, flappy moves up
	cmp	r1, r7
	beq	moveUp

	ldr	r7, =0xFFF7
	cmp	r1, r7
	beq	pausedMenu

	
	
	b	startLoop
moveUp:
	bl	upFlappy
	add	r11, r11, #1
	cmp	r11, #10
	blt	moveUp
	b	startLoop
moveDown:
	bl	moveFlappy
	b	startLoop
	





// Pause menu controls
pausedMenu:
	bl	drawPausedMenu
	push 	{r0-r12, lr}
	mov	r4, #1			//Set value for start or quit game
pausedLoop:
	bl	Read_SNES
	cmp	r10, r1
	beq	pausedLoop
	mov	r10, r1

	ldr	r7, =0xFFEF
	cmp	r1, r7
	beq	upPressedPaused
	ldr	r7, =0xFFDF
	cmp	r1, r7
	beq	downPressedPaused
	ldr	r7, =0xFEFF		
	cmp	r1, r7
	beq	aPressedPaused
	b	pausedLoop
aPressedPaused:
	cmp	r4, #1
	beq	pausedStartGame
	bl	clearScreen
	b	haltLoop$
pausedStartGame:
	b	waitforUp		// Jump to waitforup if game is restarted
upPressedPaused:
	bl	drawCursorRestart
	bl	clearCursorPQuit
	mov	r4, #1			//r4 = restart game	
	b	pausedLoop
downPressedPaused:
	bl	drawCursorPQuit
	bl	clearCursorRestart
	mov	r4, #2			//r4 = quit game
	b	pausedLoop

	pop	{r0-r12, lr}
	bx	lr	

	.globl	anyButton
anyButton:
	push	{r0-r12, lr}
	bl	Read_SNES
	cmp	r10, r1
	beq	anyButton
	mov	r10, r1

	ldr	r7, =0xFFFF
	cmp	r1, r7
	bne	anyPressed
	b	anyButton
anyPressed:
	bl	drawMenu
	b	menuControls
	
	pop	{r0-r12, lr}
	bx	lr
