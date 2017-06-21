	.section .text


// Checks if flappy hits the ground.
// Jumps to loseLife if he does	
.globl groundCheck
groundCheck:
	push	{r0-r4, lr}
	
	ldr	r4, =flappyPos	// Load the current position of flappy
	
	ldrh	r0, [r4, #2]	// Load the Y position
	ldr	r1, =669
	cmp	r0, r1		// If flappy is about to hit the ground, loselife
	blgt	loseLife

	bl 	pillarCheck
	bl	incLevel
	
	pop	{r0-r4, lr}
	bx	lr



// Checks if the bird has collided with pillars. Works for all levels.
.globl	pillarCheck
pillarCheck:
	push	{r0-r7, lr}
	ldr	r4, =level	// Checks which version of pillar checks to run
	ldrb	r0, [r4]
	cmp	r0, #1
	beq 	firstLevel
	cmp	r0, #2
	beq	secondLevel

firstLevel:
	bl	scoreCheckL1
	mov	r6, #0
firstLevelLoop:
	ldr	r4, =flappyPos
	ldr	r5, =level1Pillar
	ldr	r7, =6
	mul	r0, r6, r7
	add	r5, r5, r0
	ldrh	r0, [r4]	// Bird X
	ldrh	r1, [r5], #2	// Pillar left X
	add	r0, r0, #50	// Add #50 for bird width
	cmp	r0, r1		// If bird hasn't reached the pillar, pass
	bge	secondCheck	// If the bird has reached the pillar, check if he's gone past the pillar
	b 	levelCheck



secondLevel:
	bl	scoreCheckL2
	mov	r6, #0
secondLevelLoop:
	ldr	r4, =flappyPos
	ldr	r5, =level2Pillar
	ldr	r7, =6
	mul	r0, r6, r7
	add	r5, r5, r0
	ldrh	r0, [r4]	// Bird X
	ldrh	r1, [r5], #2	// Pillar left X
	add	r0, r0, #50	// Add #50 for bird width
	cmp	r0, r1		// If bird hasn't reached the pillar, pass
	bge	secondCheck	// If the bird has reached the pillar, check if he's gone past the pillar
	b	levelCheck
secondCheck:
	sub	r0, r0, #50	// Remove the  bird width	
	add	r1, r1, #86	// Add pillar width
	cmp	r0, r1		// If bird is not between pillar X coords, pass
	ble	thirdCheck	// If it is, go to third check
	bgt	levelCheck
thirdCheck:
	ldrh	r0, [r4, #2]	// Bird Y
	ldrh	r2, [r5], #2
	ldrh	r1, [r5], #2

	cmp	r0, r1		// If the bird is below the top pillar, go to fourth check
	bgt	fourthCheck
	bl	loseLife	// If not, lose life
	b	levelCheck
fourthCheck:
	add	r0, r0, #35	// If the bird is above the bottom pillar, pass
	cmp	r0, r2
	blt	levelCheck
	bl 	loseLife	// If not, lose life
	b 	end

levelCheck:
	ldr	r4, =level
	ldrh	r0, [r4]
	cmp	r4, #1
	beq	passedL1
	cmp	r4, #2
	beq	passedL2
	b	end
passedL1:

	add	r6, r6, #1
	cmp	r6, #2
	blt	firstLevelLoop
	b 	end
passedL2:
	add	r6, r6, #1
	cmp	r6, #3
	blt	secondLevelLoop
	b	end
end:
	pop	{r0-r7, lr}
	bx	lr






	
// Checks if the bird has gained score in level 1.	
scoreCheckL1:
	push	{r0-r4, lr}
	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	ldr	r1, =583
	cmp	r0, r1
	bleq	incScore

	ldr	r1, =863
	cmp	r0, r1
	bleq	incScore	
	
	
	pop	{r0-r4, lr}
	bx	lr
	

scoreCheckL2:
	push	{r0-r4, lr}
	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	ldr	r1, =286
	cmp	r0, r1
	bleq	incScore
	pop	{r0-r4, lr}
	bx	lr




// Increments the score by one.
.globl	incScore
incScore:	
	push	{r0-r4, r6, lr}


	ldr	r4, =score
	ldr	r0, [r4]
	add	r0, r0, #1
	str	r0, [r4]
	cmp	r0, #0
	beq	drawZero
	cmp	r0, #1
	beq	drawOne
	cmp	r0, #2
	beq	drawTwo
	b	endScore
drawZero:
	
	ldr	r6, =score0
	bl	drawScore
	b	endScore
drawOne:
	ldr	r6, =score1
	bl	drawScore
	b	endScore
drawTwo:
	ldr	r6, =score2
	bl	drawScore
	b	endScore
	
endScore:
	pop	{r0-r4, r6, lr}
	bx	lr







// Checks if the right edge of the screen is reached. If yes, increments the level count and loads the next level.
.globl	incLevel
incLevel:
	push	{r0-r4, lr}

	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	add	r0, #50
	ldr	r1, =1023	
	cmp	r0, r1		// If the right edge of the screen is reached, inc level
	bne	skip		// If not, skip

	ldr	r4, =level	// Increments the level
	ldr	r0, [r4]
	add	r0, r0, #1
	str	r0, [r4]	// Branch to the level being changed to and print that level
	cmp	r0, #1
	beq	level1Check
	cmp	r0, #2
	beq	startLevel2
	cmp	r0, #3
	beq	startLevel3
	cmp	r0, #4
	beq 	startLevel4
	cmp	r0, #5
	beq	win
level1Check:
	mov	r0, #0
	mov	r1, #0
	ldr	r2, =50
	ldr	r3, =35
	ldr	r6, =flappy
	bl 	drawImage
	
startLevel2:
	bl	drawSecondLevel
	ldr	r4, =flappyPos
	b	reset
startLevel3:
	
startLevel4:

win:


reset:			
	mov	r1, #0		// Reset the position of the bird at the start of a new level
	strh	r1, [r4], #2
	mov	r1, #400
	strh	r1, [r4]
skip:	
	pop	{r0-r4, lr}
	bx	lr









	
.globl loseLife
loseLife:	
	push	{r4, r6, lr}

	ldr	r4, =lives	// Load lives
	ldr	r0, [r4]	
	sub	r0, r0, #1	// Subtract a life
	str	r0, [r4]

	cmp	r0, #2		// Branch for two lives, one life, or loss
	bleq	drawtwoLives

	ldr	r0, [r4]
	cmp	r0, #1
	bleq	drawoneLife

//	ldr	r0, [r4] Will lose if the player
//	cmp	r0, #0
//	beq 	loseGame


	ldr	r4, =flappyPos

	ldrh	r0, [r4]	// This block of code clears the old flappy before before his position is reset
	add	r4, r4, #2
	ldrh	r1, [r4]
	
	mov	r2, r0
	add	r2, r2, #50
	mov	r3, r1
	add	r3, r3, #35
	ldr	r6, =flappySky
	bl 	drawImage
	

	ldr	r4, =flappyPos	// Load flappy pos
	mov	r0, #0
	strh	r0, [r4]	// Reset flappy's X pos back to 0
	
	add	r4, r4, #2
	mov	r0, #400	// Reset flappy's Y pos back to 400
	strh	r0, [r4]
	
	ldr	r4, =score	// Resets score
	mov	r0, #0
	str	r0, [r4]

	ldr	r6, =score0
	bl	drawScore
	
	pop	{r4, r6, lr}
	bx	lr



