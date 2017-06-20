	.section .text

	.globl upFlappy
upFlappy:
	push	{r4, r6, lr}

	ldr	r4, =flappyPos
	ldrh	r0, [r4]	

	add	r4, #2
	ldrh	r1, [r4]
	
	mov	r2, #50		// Width of sky
	add	r2, r2, r0	// Add the X pos to the width
	mov	r3, #35		// Height of sky
	add	r3, r3, r1	// Add the Y pos to the height
	ldr	r6, =flappySky
	bl	drawImage

	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	add	r0, r0, #1	// The amount flappy is moved to the right
	strh	r0, [r4]	

	add	r4, #2
	ldrh	r1, [r4]
	sub	r1, r1, #3	// The amount flappy is moved up (single tick)
	strh	r1, [r4]
	
	mov	r2, #50
	add	r2, r2, r0
	mov	r3, #35
	add	r3, r3, r1
	ldr	r6, =flappy
	bl 	drawImage

	bl	groundCheck	// Perform checks before moving flappy

	pop	{r4, r6, lr}
	bx	lr



	// Moves flappy to the right and down. Returns the new position of flappy.
	// TODO: clear the position of the old flappy
	.globl moveFlappy
moveFlappy:	
	push	{r4, r6, lr}

	ldr	r4, =flappyPos
	ldrh	r0, [r4]	

	add	r4, #2
	ldrh	r1, [r4]
	
	mov	r2, #50		// Width of sky
	add	r2, r2, r0	// Add the X pos to the width
	mov	r3, #35		// Height of sky
	add	r3, r3, r1	// Add the Y pos to the height
	ldr	r6, =flappySky
	bl	drawImage

	ldr	r4, =flappyPos
	ldrh	r0, [r4]
	add	r0, r0, #1	// The amount flappy is moved to the right
	strh	r0, [r4]	

	add	r4, #2
	ldrh	r1, [r4]
	add	r1, r1, #1	// The amount flappy is moved down
	strh	r1, [r4]
	
	mov	r2, #50
	add	r2, r2, r0
	mov	r3, #35
	add	r3, r3, r1
	ldr	r6, =flappy
	bl 	drawImage

	bl	groundCheck	// Perform checks before moving flappy

	pop	{r4, r6, lr}
	bx	lr

