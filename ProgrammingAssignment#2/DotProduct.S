	.data
	.type x, %object
	.size x, 5

x:
	.xword 2, 4, 6, 8, 10 // Initialize first 2 fib numbers


	.data
	.type y, %object
	.size y, 5

y:
	.xword 1, 3, 5, 7, 9 // Initialize first 2 fib numbers


	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function


main:
	// for (i=0; i<8; i++)
	ADRP	X0, x // Add array x  to X0
	ADD		X0, X0, :lo12:x //Convert to 64bit
	ADRP 	X1, y // Add array y to X1
	ADD		X1, X1, :lo12:y // Convert to 64 bit

	MOV 	X2, XZR // X2 stores x[i]
	MOV 	X3, XZR // X3 stores y[i]
	MOV 	X4, XZR // Stores total dot product
	MOV 	X5, XZR // Stores temp dot for adding to total
	MOV 	X6, #1 // Incrementor for y[i] & x[i]
	MOV 	X7, XZR // i = 0
	B 		for // Start for loop No need to return so B is used

for:
	SUBS 	XZR, X7, #5 // I >= 5

	B.GE 	Exit // If true, exit

	LDUR 	X2, [X0, #0] // Load x[i]
	LDUR 	X3, [X1, #0] // Load y[i]

	MUL 	X5, X2, X3 // Multiply x[i] * y[i]

	ADD 	X4, X4, X5 // Add to total so (a*b) ... + (an*bn)

	ADD 	X0, X0, X6, LSL #3 // Calculate x[i]
	ADD 	X1, X1, X6, LSL #3 // Calculate y[i]

	ADD X7, X7, #1 // Increment I

	B 		for // Loop back around

Exit:
