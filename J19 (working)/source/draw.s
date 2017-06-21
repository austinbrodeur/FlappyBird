

.section .text


// The following code, up to and including drawPicture, is code taken from the tutorials.
.globl clearScreen
clearScreen:
        push    {r0-r12, lr}

	mov	r4,	#0			//x value
	mov	r5,	#0			//Y value
	mov	r6,	#0			//black color
	ldr	r7,	=1024			//Width of screen
	ldr	r8,	=768			//Height of the screen

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
	offset	.req	r4 // offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10 // offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1 // store the colour (half word) at framebuffer pointer + offset
	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]
	pop		{r4}
	bx		lr





	
// Draws image to the screen
// r0 = X position
// r1 = Y position
// r2 = Width
// r3 = Height
// r6 = Image address
.globl drawImage
drawImage:
	push {lr}
	mov	r4, r0			// Start X position of your picture
	mov	r9, r0			// Copy of X position
	mov	r5, r1			// Start Y position
	mov	r7, r2			// Width of your picture (Add X position to this)
	mov	r8, r3			// Height of your picture (Add Y position to this)
drawImageLoop:
	mov	r0, r4			// Passing x for ro which is used by the Draw pixel function 
	mov	r1, r5			// Passing y for r1 which is used by the Draw pixel formula 
	
	ldrh	r2, [r6],#2		// Setting pixel color by loading it from the data section. We load hald word
	bl	DrawPixel
	add	r4, #1			// Increment x position
	cmp	r4, r7			// Compare with image with
	blt	drawImageLoop
	mov	r4, r9			// Reset x
	add	r5, #1			// Increment Y
	cmp	r5, r8			// Compare y with image height
	blt	drawImageLoop
	pop    {lr}
	mov	pc, lr			// Return


// Draws background
drawBG:
	push	{lr}
	mov	r0, #0
	mov	r1, #0
	mov 	r2, #1024
	mov	r3, #768
	ldr	r6, =background
	bl	drawImage
	pop	{lr}
	bx	lr


// Draws play button	
drawPlay:
	push	{lr}
	mov	r0, #400 // X Pos
	mov	r1, #300 // Y Pos
	mov	r2, #580 // Image is 180 x 100
	mov	r3, #400
	ldr	r6, =playButton // Load ascii
	bl	drawImage
	pop	{lr}
	bx	lr


// Draws quit button
drawQuit:
	push	{lr}
	mov	r0, #400
	mov	r1, #420
	mov	r2, #580 // Image is 180 x 100
	mov	r3, #520
	ldr	r6, =quitButton
	bl	drawImage
	pop	{lr}
	bx 	lr


// Draws flappy bird logo
drawLogo:
	push	{lr}
	mov	r0, #100
	mov	r1, #100
	ldr	r2, =700 // Image is 600 x 160
	ldr	r3, =260
	ldr	r6, =logo
	bl	drawImage
	pop	{lr}
	bx	lr

// Draws creator names
drawNames:
	push	{lr}
	mov	r0, #400
	mov	r1, #0
	ldr	r2, =1000 // Image is 600 x 30
	ldr	r3, =30
	ldr	r6, =creatorsNames
	bl	drawImage
	pop	{lr}
	bx	lr



// Places cursor next to the play button
.globl drawCursorPlay
drawCursorPlay:
	push	{lr}
	mov	r0, #580
	mov	r1, #300
	mov	r2, #680
	mov	r3, #400
	ldr	r6, =cursor
	bl	drawImage
	pop	{lr}
	bx	lr



// Places cursor next to the quit button
.globl drawCursorQuit
drawCursorQuit:
	push	{lr}
	mov	r0, #580
	mov	r1, #420
	mov	r2, #680
	mov	r3, #520
	ldr	r6, =cursor
	bl	drawImage
	pop	{lr}
	bx	lr


// Clears the cursor when play is being pointed to
.globl clearCursorPlay
clearCursorPlay:
	push	{lr}
	mov	r0, #580
	mov	r1, #300
	mov	r2, #680
	mov	r3, #400
	ldr	r6, =sky
	bl	drawImage
	pop	{lr}
	bx	lr


// Clears the cursor when quit is being pointed to
.globl clearCursorQuit
clearCursorQuit:
	push	{lr}
	mov	r0, #580
	mov	r1, #420
	mov	r2, #680
	mov	r3, #520
	ldr	r6, =sky
	bl	drawImage
	pop	{lr}
	bx	lr

// Draws flappybird
.globl drawFlappy
drawFlappy:	
	push	{lr}
	mov	r0, #0
	mov	r1, #400
	ldr	r2, =50
	ldr	r3, =435
	ldr	r6, =flappy
	bl	drawImage
	pop	{lr}
	bx	lr

	

// Draws the prompt that tells the user to press up to start moving
.globl drawuptoStart
drawuptoStart:
	push	{lr}
	mov	r0, #100
	mov	r1, #200
	ldr	r2, =280
	ldr	r3, =460
	ldr	r6, =uptoStart
	bl	drawImage
	pop	{lr}
	bx	lr


.globl drawScoreLabel
drawScoreLabel:
	push	{lr}
	mov	r0, #400
	mov	r1, #720
	ldr	r2, =510
	ldr	r3, =765
	ldr	r6, =scoreLabel
	bl	drawImage
	pop	{lr}
	bx	lr

.globl	drawScore
drawScore:
	push	{lr}
	ldr	r0, =510
	mov	r1, #720
	ldr	r2, =590
	ldr	r3, =765
//	ldr	r6, =score0
	bl	drawImage
	pop	{lr}
	bx	lr

// Clears the up to start prompt off the screen
.globl clearuptoStart
clearuptoStart:
	push	{lr}
	mov	r0, #100	// Top left
	mov	r1, #200
	ldr	r2, =200
	ldr	r3, =300
	ldr	r6, =sky
	bl	drawImage

	mov	r0, #200	// Top right
	mov	r1, #200
	ldr	r2, =300
	ldr	r3, =300
	ldr	r6, =sky
	bl	drawImage
	
	mov	r0, #100	// Middle left
	mov	r1, #300
	ldr	r2, =200
	ldr	r3, =400
	ldr	r6, =sky
	bl	drawImage

	mov	r0, #200	// Middle right
	mov	r1, #300
	ldr	r2, =300
	ldr	r3, =400
	ldr	r6, =sky
	bl	drawImage

	mov	r0, #100	// Bottom left
	mov	r1, #400
	ldr	r2, =200
	ldr	r3, =500
	ldr	r6, =sky
	bl	drawImage
	
	mov	r0, #200	// Bottom right
	mov	r1, #400
	ldr	r2, =300
	ldr	r3, =500
	ldr	r6, =sky
	bl	drawImage
	

	pop	{lr}
	bx	lr
	




// Draws lives
.globl drawthreeLives
drawthreeLives:
	push	{lr}
	mov	r0, #0		// X Pos
	ldr	r1, =720 	// Y Pos
	ldr	r2, =156
	ldr	r3, =765
	ldr	r6, =threeLives
	bl	drawImage
	pop	{lr}
	bx	lr


// Draws lives
.globl drawtwoLives
drawtwoLives:
	push	{lr}
	mov	r0, #0		// X Pos
	ldr	r1, =720 	// Y Pos
	ldr	r2, =156
	ldr	r3, =765
	ldr	r6, =twoLives
	bl	drawImage
	pop	{lr}
	bx	lr	

// Draws lives
.globl drawoneLife
drawoneLife:
	push	{lr}
	mov	r0, #0		// X Pos
	ldr	r1, =720 	// Y Pos
	ldr	r2, =156
	ldr	r3, =765
	ldr	r6, =oneLife
	bl	drawImage
	pop	{lr}
	bx	lr	







	

	
// Calls draw methods to create the initial state of the main menu	
.globl	drawMenu
drawMenu:	
	push	{r6, lr}
	bl	drawBG
	bl	drawLogo
	bl	drawPlay
	bl	drawQuit
	bl	drawNames
	bl	drawCursorPlay
	pop	{r6, lr}
	bx	lr














	


	
	
// Draws the first level gamestate
.globl	firstLevel
firstLevel:
	push	{r8, lr}
	bl	drawBG
	bl	drawFlappy
	bl	drawthreeLives
	bl	drawScoreLabel
	ldr	r6, =score0
	bl	drawScore
	bl	drawuptoStart

// Draw pipes section. The ground is 64 pixels tall
	ldr	r8, =level1Pillar
	ldr	r0, =497	// Pillar X
	strh	r0, [r8], #2
	ldr	r0, =426	// Bottom Pillar Y (top)
	strh	r0, [r8], #2
	ldr	r0, =198	// Top Pillar Y (bottom)
	strh	r0, [r8], #2
// Up pipes	
	mov	r0, #500
	ldr	r1, =624	// 768 (bg height) - 80 (pipe section height) - 64 (ground height)
	ldr	r2, =580	// 500 + 80 (pipe width)
	ldr	r3, =704	// 627 + 80
	ldr	r6, =pipeUp
	bl	drawImage

	mov	r0, #500
	ldr	r1, =544	// 768 - 160 - 64
	ldr	r2, =580	// 500 + 80
	ldr	r3, =624	// 544 + 80
	ldr	r6, =pipeUp
	bl	drawImage

	mov	r0, #500
	ldr	r1, =464	// 768 - 240 - 64
	ldr	r2, =580	// 500 + 80
	ldr	r3, =544	// 464 + 80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =497	// Top is shifted left by 3 to center it
	ldr	r1, =426	// 768 - 240 - 38 (height of top) - 64
	ldr	r2, =583	// 497 + 86
	ldr	r3, =464	// 464 + 38
	ldr	r6, =pipeupTop
	bl	drawImage
// End up pipes



// Down pipes
	mov	r0, #500
	mov	r1, #0
	ldr	r2, =580
	ldr	r3, =80
	ldr	r6, =pipeDown
	bl	drawImage

	mov	r0, #500
	mov	r1, #80
	ldr	r2, =580
	ldr	r3, =160
	ldr	r6, =pipeDown
	bl	drawImage

	ldr	r0, =497
	ldr	r1, =160
	ldr	r2, =583
	ldr	r3, =198
	ldr	r6, =pipedownTop
	bl	drawImage
	
// End first Pillar
	ldr	r8, =level1Pillar
	add	r8, r8, #6
	ldr	r0, =797	// Pillar X
	strh	r0, [r8], #2
	ldr	r0, =544	// Bottom Pillar Y (top)
	strh	r0, [r8], #2
	ldr	r0, =278	// Top Pillar Y (bottom)
	strh	r0, [r8]
//Second Pillar Up Pip
	mov	r0, #800
	ldr	r1, =624	// 768 (bg height) - 80 (pipe section height) - 64 (ground height)
	ldr	r2, =880	// 500 + 80 (pipe width)
	ldr	r3, =704	// 627 + 80
	ldr	r6, =pipeUp
	bl	drawImage

	mov	r0, #800
	ldr	r1, =544	// 768 - 160 - 64
	ldr	r2, =880	// 500 + 80
	ldr	r3, =624	// 544 + 80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =797	// Top is shifted left by 3 to center it
	ldr	r1, =544	// 768 - 64 - 80 - 80 
	ldr	r2, =883	// 497 + 86
	ldr	r3, =582	// 544 + 38
	ldr	r6, =pipeupTop
	bl	drawImage
// Second Pillar Down Pipe
	mov	r0, #800
	mov	r1, #0
	ldr	r2, =880
	ldr	r3, =80
	ldr	r6, =pipeDown
	bl	drawImage

	mov	r0, $800
	mov	r1, #80
	ldr	r2, =880
	ldr	r3, =160
	ldr	r6, =pipeDown
	bl	drawImage

	mov	r0, $800
	mov	r1, #160
	ldr	r2, =880
	ldr	r3, =240
	ldr	r6, =pipeDown
	bl	drawImage 

	ldr	r0, =797	
	ldr	r1, =240
	ldr	r2, =883
	ldr	r3, =278
	ldr	r6, =pipedownTop
	bl	drawImage
	
	pop	{r8, lr}
	bx	lr


.globl	drawSecondLevel
drawSecondLevel:
	push	{r6, lr}
	bl	clearScreen
	bl	drawBG
	bl	drawFlappy
	bl	drawScoreLabel
	ldr	r6, =score2
	bl	drawScore

	ldr	r8, =level2Pillar
	ldr	r0, =197			//First Pillars X
	strh	r0, [r8], #2
	ldr	r0, =346			// Bottom pillar top
	strh	r0, [r8], #2	
	ldr	r0, =198			// Top pillar bottom
	strh	r0, [r8]


	ldr	r8, =level2Pillar
	add	r8, r8, #6


	ldr	r0, =287			//Second Pillars
	strh	r0, [r8], #2
	ldr	r0, =428
	strh	r0, [r8], #2
	ldr	r0, =278
	strh	r0, [r8]
	
	ldr	r8, =level2Pillar
	add	r8, r8, #12

	ldr	r0, =597
	strh	r0, [r8], #2
	ldr	r0, =268
	strh	r0, [r8], #2
	ldr	r0, =118
	strh	r0, [r8]
//first Pillar
	mov	r0, #200			//First Up Pillars x 4
	ldr	r1, =624
	ldr	r2, =280
	ldr	r3, =704
	ldr	r6, =pipeUp
	bl	drawImage

	mov	r0, #200
	ldr	r1, =544
	ldr	r2, =280
	ldr	r3, =624
	ldr	r6, =pipeUp
	bl	drawImage

	mov	r0, #200
	ldr	r1, =464
	mov	r2, #280
	ldr	r3, =544
	ldr	r6, =pipeUp
	bl	drawImage

	mov	r0, #200
	ldr	r1, =384
	mov	r2, #280
	ldr	r3, =464
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =197			//First up Pillars Top
	ldr	r1, =346
	ldr	r2, =283
	ldr	r3, =384
	ldr	r6, =pipeupTop
	bl	drawImage
	
	mov	r0, #200			//First Down Pillar x2
	mov	r1, #0
	mov	r2, #280
	mov	r3, #80
	ldr	r6, =pipeDown
	bl	drawImage

	mov	r0, #200
	mov	r1, #80
	mov	r2, #280
	mov	r3, #160
	ldr	r6, =pipeDown
	bl	drawImage
	
	ldr	r0, =197			//First Down Pillar Top
	ldr	r1, =160
	ldr	r2, =283
	ldr	r3, =198
	ldr	r6, =pipedownTop
	bl	drawImage

	ldr	r0, =290
	ldr	r1, =624
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =290
	ldr	r1, =544
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =290
	ldr	r1, =464
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =287
	ldr	r1, =428
	add	r2, r0, #86
	add	r3, r1, #38
	ldr	r6, =pipeupTop
	bl	drawImage

	ldr	r0, =290
	mov	r1, #0
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeDown
	bl	drawImage

	ldr	r0, =290
	mov	r1, #80
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeDown
	bl	drawImage

	ldr	r0, =290
	mov	r1, #160
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeDown
	bl	drawImage

	ldr	r0, =287
	mov	r1, #240
	add	r2, r0, #86
	add	r3, r1, #38
	ldr	r6, =pipedownTop
	bl	drawImage

	ldr	r0, =600
	ldr	r1, =624
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =600
	ldr	r1, =544
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =600
	ldr	r1, =464
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =600
	ldr	r1, =384
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =600
	ldr	r1, =304
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeUp
	bl	drawImage

	ldr	r0, =597
	ldr	r1, =268
	add	r2, r0, #86
	add	r3, r1, #38
	ldr	r6, =pipeupTop
	bl	drawImage

	mov	r0, #600
	mov	r1, #0
	add	r2, r0, #80
	add	r3, r1, #80
	ldr	r6, =pipeDown
	bl	drawImage

	ldr	r0, =597
	mov	r1, #80
	add	r2, r0, #86
	add	r3, r1, #38
	ldr	r6, =pipedownTop
	bl	drawImage



	pop	{r6, lr}
	bx	lr
.section	.data

// Contains ascii information for images
