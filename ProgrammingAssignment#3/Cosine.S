   .data
   .type	v, %object

s:
    .double 112.42, 422.252, 53.432
d:
    .asciz "123456789"

    .text
    .global main
    .arch armv8-a+fp+simd
    .type main, %function

// Cole Stoltz
// cms0644


power:
	FMUL D1, D1, D4 	// a * a * a ... // D1 is temp
	SUB X1, X1, #1 		// X1 temp
	CMP X1, #0 			// compare
	B.NE power 			// check
	RET 				// return

factorial:
	MUL X2, X2, X1 		// X2 is temp
	SUB X1, X1, #1 		// i--
	CMP X1, #0 			// Set flags
	B.NE factorial 		// Check
	SCVTF D0, X2 		// Convert to float
	RET					// Return back

cosineSet:
	MOV X10, X30		// Set address so application can return back to proper place
cosine:
	// Order of execution
	// POWER
	// POWER
	// FACTORIAL
	// Then multiply power * power
	// Then divice power/divide
	MOV X1, X0			// Set temp variable so counter is not garbled
	FMOV D1, #1.0		// Reset d1
	FMOV D4, #-1.0 		// -1^n
	BL power			// Execute power function

	FMOV D2, D1			// Move result to different regsiter

	MOV X1, X0			// Move counter back up to n for loop
	MUL X1, X1, X7		// Multiply n by 2
	FMOV D1, #1.0		// Reset d1
	FMOV D4, D3 		// Reset d4 with inital value
	BL power			// Go to power function

	MOV X1, X0			// Reset counter
	MOV X2, #1			// Reset x2
	MUL X1, X1, X7		// Multiply n by 2
	BL factorial		// Go to factorial function

	FMUL D5, D2, D1		// Multiply above fraction
	FDIV D6, D5, D0		// Divide -1^n*x^2n/(2n)!

	FADD D8, D8, D6		// Summation

	// Resets variables used
	FMOV D0, #1.0
	FMOV D1, #1.0
	FMOV D2, #1.0
	FMOV D5, #1.0
	MOV X2, XZR

	// Check loop and branch
	SUB X0, X0, #1
	CMP X0, #0
	B.NE cosine
	// Move address back to x30
	MOV X30, X10
	RET 				// Returb

main: 			// Results for power D1, D2 Result for factorial in  D0

	SUB SP, SP, #40 // for the 4 registers used
	STUR X0, [SP, #0]
	STUR X1, [SP, #8]
	STUR X2, [SP, #16]
	STUR X7, [SP, #24]
	STUR X12, [SP, #32]
	// X0, X1, X2, X7

	// Function parameters
	MOV X0, #8 		// Iterations
	MOV X12, #120   // Floating point number (Converted down below)


	SCVTF D3, X12	// X floating point
	FMOV D4, D3		// D4 will act as a temp area
	FMOV D8, XZR	// D8 holds summation
	MOV X7, #2		// X7 holds the number for 2n when needed

	BL cosineSet	// Call cosine function

	// Reload registers
	LDUR X0, [SP, #0]
	LDUR X1, [SP, #8]
	LDUR X2, [SP, #16]
	LDUR X7, [SP, #24]
	LDUR X12, [SP, #32]

	// Pop stack
	ADD SP, SP, #40

Exit:
	NOP
