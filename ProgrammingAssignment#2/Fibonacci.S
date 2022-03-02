	.data
	.type v, %object
	.size v, 2

v:
	.xword 1, 0 // Initialize first 2 fib numbers


	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

/* I just took the loop file given to us
 and edited it so that it increased the
 array size rather than shrink it and
 then store the calculated fib numbers
 inside the array.*/
main: // Used registers: 
// X0 stores array
// X3 = i variable
// X5 will stored the edited array
// X4 will hold v[i]
// X1 will hold v[i+1]
	// for (i=0; i<8; i++)
	ADRP	X0, v
	ADD	X0, X0, :lo12:v
	MOV	X3, #1			// X3=i = 0
	MOV 	X5, X0			// Move the array to X5
for:
	SUB	X2, X3, #8		// i-8

	LDUR	X1, [X5, #8]		// Load first number
	LDUR	X4, [X5, #0]		// Load second

	SUB	X5, X0, X3, LSL #3	// *v[i]

	ADD X1, X1, X4			// Add 2 fib numbers

	STUR X1, [X5, #0]		// Store the fib number

	CBZ	X2, Exit		// if i=0 break

	ADD	X3, X3, #1		// i++ (x3++)
	B	for 			// Loop back

Exit:

