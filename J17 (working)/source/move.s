	.section .text

	.globl upFlappy
upFlappy:
	push	{lr}

	pop	{lr}
	bx	lr



	// Moves flappy to the right and down. Returns the new position of flappy.
	// Returns:
	// r0 = X pos
	// r1 = Y pos
	.globl moveFlappy
moveFlappy:	
	push	{r6, lr}

	add	r0, r0, #2	// The amount flappy is moved to the right
	add	r1, r1, #3	// The amount flappy is moved down
	mov	r2, #50		// Width of flappy
	add	r2, r2, r0	// Add the X pos to the width
	mov	r3, #35		// Height of flappy
	add	r3, r3, r1	// Add the Y pos to the height
	ldr	r6, =flappy
	bl	drawImage

	pop	{r6, lr}
	bx	lr
