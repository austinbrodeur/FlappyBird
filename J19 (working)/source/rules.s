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
	bl	scoreCheck
	bl	incLevel
	
	pop	{r0-r4, lr}
	bx	lr



// Checks if the bird has collided with pillars. Works for all levels.
.globl	pillarCheck
pillarCheck:
	push	{r0-r5, lr}

	ldr	r4, =level	// Checks which version of pillar checks to run
	ldrb	r0, [r4]
	cmp	r0, #1
	beq 	first


first:
	ldr	r4, =flappyPos
	ldr	r5, =level1Pillar
	ldrh	r0, [r4]	// Bird X
	ldrh	r1, [r5]	// Pillar left X
//	ldr	r1, =497	// Hardcoded, remove
	add	r0, r0, #50	// Add #50 for bird width
	cmp	r0, r1		// If bird hasn't reached the pillar, pass
	bge	secondCheck	// If the bird has reached the pillar, check if he's gone past the pillar
	blt	passed		
secondCheck:
	sub	r0, r0, #50	// Remove the  bird width	
	add	r1, r1, #86	// Add pillar width
	cmp	r0, r1		// If bird is not between pillar X coords, pass
	ble	thirdCheck	// If it is, go to third check
	bgt	passed
thirdCheck:
	add	r4, r4, #2
	ldrh	r0, [r4]	// Bird Y
	add	r5, r5, #2
	ldrh	r2, [r5]
	add	r5, r5, #2
	ldrh	r1, [r5]
//	ldr	r1, =198	// Top pillar
//	ldr	r2, =426	// Bottom pillar

	cmp	r0, r1		// If the bird is below the top pillar, go to fourth check
	bgt	fourthCheck
	bl	loseLife	// If not, lose life
	b	passed
fourthCheck:
	add	r0, r0, #35	// If the bird is above the bottom pillar, pass
	cmp	r0, r2
	blt	passed
	bl 	loseLife	// If not, lose life
	b 	passed

passed:	
	pop	{r0-r5, lr}
	bx	lr



	
// Checks if the bird has gained score. Works for all levels.
// TODO: Check the current level	
.globl scoreCheck
scoreCheck:
	push	{r0-r4, lr}
	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	ldr	r1, =583
	cmp	r0, r1
	bleq	incScore	
	
	
	pop	{r0-r4, lr}
	bx	lr
	



// Increments the score by one.
.globl	incScore
incScore:	
	push	{r0-r4, lr}

	mov	r0, #0		// Draws flappy. Remove when score picture is implemented.
	mov	r1, #0
	ldr	r2, =50
	ldr	r3, =35
	ldr	r6, =flappy
	bl	drawImage
	
	ldr	r4, =score
	ldr	r0, [r4]
	add	r0, r0, #1
	str	r0, [r4]
	
	pop	{r0-r4, lr}
	bx	lr



// Checks if the right edge of the screen is reached. If yes, increments the level count and loads the next level.
.globl	incLevel
incLevel:
	push	{r0-r4, lr}

	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	ldr	r1, =1023	
	cmp	r0, r1		// If the right edge of the screen is reached, inc level
	bne	skip		// If not, skip
	mov	r0, #0		// Draws flappy. Replace with draw next level and reset flappy
	mov	r1, #400
	ldr	r2, =50
	ldr	r3, =35
	ldr	r6, =flappy
	bl	drawImage
	
	ldr	r4, =level	// Increments the level
	ldr	r0, [r4]
	add	r0, r0, #1
	str	r0, [r4]

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

//	ldr	r0, [r4]
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
	
	pop	{r4, r6, lr}
	bx	lr



