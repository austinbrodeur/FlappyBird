

.section .text


// The following code, up to and including drawPicture, is code taken from the tutorials.
.globl clearScreen
clearScreen:
        push    {r0-r12, lr}

	mov	r4,	#0			//x value
	mov	r5,	#0			//Y value
	mov	r6,	#0			//black color
	ldr	r7,	=1023			//Width of screen
	ldr	r8,	=767			//Height of the screen

Looping:
	mov	r0,	r4			//Setting x
	mov	r1,	r5			//Setting y
	mov	r2,	r6			//setting pixel color
	push    {lr}
	bl	DrawPixel
	pop     {lr}
	add	r4,	#1			//increment x by 1
	cmp	r4,	r7			//compare with width
	blt	Looping
	mov	r4,	#0			//reset x
	add	r5,	#1			//increment Y by 1
	cmp	r5,	r8			//compare with height
	blt	Looping
        pop     {r0-r12,lr}
	mov	pc,	lr			//return
	

DrawPixel:
	push	{r4}


	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset

	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	pop		{r4}
	bx		lr


.globl drawBG
drawBG:
	push {lr}
	mov	r4,	#0			//Start X position of your picture
	mov	r5,	#0
	ldr	r6,	=background		//Address of the picture
	mov	r7,	#1024			//Width of your picture
	mov	r8,	#768			//Height of your picture
drawBGLoop:
	mov	r0,	r4			//passing x for ro which is used by the Draw pixel function 
	mov	r1,	r5			//passing y for r1 which is used by the Draw pixel formula 
	
	ldrh	r2,	[r6],#2			//setting pixel color by loading it from the data section. We load hald word
	bl	DrawPixel
	add	r4,	#1			//increment x position
	cmp	r4,	r7			//compare with image with
	blt	drawBGLoop
	mov	r4,	#0			//reset x
	add	r5,	#1			//increment Y
	cmp	r5,	r8			//compare y with image height
	blt	drawBGLoop
	pop    {lr}
	mov	pc,	lr			//return
	
.section	.data

// Contains ascii information for images
