.section .data
.align 2

.globl flappyPos
flappyPos:	.hword 0, 400

.globl	level1Pillar
level1Pillar:	.hword 	0, 0, 0, 0, 0, 0

.globl	level2Pillar
level2Pillar:	.hword 	0, 0, 0, 0, 0, 0, 0, 0, 0

.globl	level3Pillar
level3Pillar:	.hword	0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0

.globl	level4Pillar
level4Pillar:	.hword	0, 0, 0, 0, 0 ,0, 0, 0, 0

.globl lives
lives:		.int 3

.globl score
score:		.int 0

.globl level
level:		.int 1

