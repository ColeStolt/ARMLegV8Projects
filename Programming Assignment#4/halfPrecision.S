	.data
	.type	num1, %object
	.size	num1, 1

v:
	.xword 23, 42, 45

	.text
	.global main
	.arch armv8-a+fp16+simd
	.type main, %function

// Used registers X1, X2, X3, X4, X5, X6, X7, X8, X30

splithf:
	// Get Sign into x1 ---------------
	MOV X1, #32768 	// Set bit 16 to 1 to get the sign
	AND X1, X1, X5	// Get the sign by anding.
	// Get unbiased exponent X2 ---------------
	MOV X2, #31744	// Set 5 bits for exponent
	AND X2, X2, X5	// Get the exponent
	LSR X2, X2, #10 // Shift bits to the right
	MOV X4, #15		// Set exponent max
	// Get mantisa X3	--------------------
	MOV X3, #1023	// Set bits iun mantisa-
	AND X3, X3, X5	// And to get mantissa

	RET // Return back to last instruction

combinehf:

	MOV X5, XZR;
	// Get sign from x1 -----------------
	ORR X5, X5, X1
	// Get biased expoenent X2 -----------------
	LSL X2, X2, #10
	ORR X5, X5, X2
	// Get mantissa X3 -------------------
	ORR X5, X5, X3
	/// Convert to H --------------------
	SCVTF H0, X5

	RET // Return back to last instruction

normalizehf:

	// Determine 0 manitssa -----------------
	CMP X3, #0
	B.EQ return
	// Determine shift left or right -------
	CMP X2, #16
	B.GE rightShift

leftShift: // Shift to the left
	LSL X3, X3, X2
	RET

rightShift:	// Shift to the right based on exponent
	SUB X2, X2, #16 // Gets how many bits to shift to the right
	LSR X3, X3, X2
	RET

addhf:
	MOV X8, X30 // Temp variable for original return address
	// use x1 and x2 to add the numbers
	MOV X0, X2 // temp to keep second number safe
	MOV X5, X1 // Move to x5 for parsing
	BL splithf
	BL normalizehf
	MOV X4, X1 // Sign
	MOV X6, X2 // Exponent
	MOV X7, X3 // Manitssa

	MOV X5, X0 // Move x2 into x5
	BL splithf // Split the number
	BL normalizehf // normalize it

	// Add the two numbers together after mantissa aligned
	ADD X3, X3, X7 // Add two mantissas
	AND X3, X3, #1023 // Cuts off mantissa so it is within 10 bits

	ADD X2, X2, X6 // Add exponents
	AND X2, X2, #31 // Keep exponent within 5 bits

	ADD X1, X1, X4 // Add signs
	AND X1, X1, #32768 // Keep within the 6th bit

	BL combinehf // combine for the final result

	MOV X30, X8 // Reset return address

	RET // return back to main

multhf:
	MOV X8, X30 // Temp variable for original return address
	// use x1 and x2 to add the numbers
	MOV X0, X2 // temp to keep second number safe
	MOV X5, X1 // Move to x5 for parsing
	BL splithf
	BL normalizehf
	MOV X4, X1 // Sign
	MOV X6, X2 // Exponent
	MOV X7, X3 // Manitssa

	MOV X5, X0 // Move x2 into x5
	BL splithf // Split the number
	BL normalizehf // normalize it

	// Add the two numbers together after mantissa aligned
	MUL X3, X3, X7 // Multiply two mantissas
	AND X3, X3, #1023 // Cuts off mantissa so it is within 10 bits

	ADD X2, X2, X6 // Add exponents
	AND X2, X2, #31 // Keep exponent within 5 bits

	ADD X1, X1, X4 // Add signs
	AND X1, X1, #32768 // Keep within the 6th bit

	BL combinehf // combine for the final result

	MOV X30, X8 // Reset return address

	RET // return back to main

return: // Used in a case where return back to main or previous executution is needed
	RET

main:

	// Save registers
	SUB SP, SP, #80
	STUR X1, [SP, #0]
	STUR X2, [SP, #8]
	STUR X3, [SP, #16]
	STUR X4, [SP, #24]
	STUR X5, [SP, #40]
	STUR X6, [SP, #48]
	STUR X7, [SP, #56]
	STUR X8, [SP, #64]
	STUR X30, [SP, #72]

	// X1, X2, X3, X4, X5, X6, X7, X8, X30

	// Main for testing
	MOV X1, #31
	MOV X2, #1245

	SCVTF H1, X1
	SCVTF H2, X1

	FADD H1, H1, H2

	BL addhf

	MOV X1, #31
	MOV X2, #1245

	SCVTF H1, X1
	SCVTF H2, X1

	FMUL H1, H1, H2

	BL multhf

	// Reload registers
	LDUR X1, [SP, #0]
	LDUR X2, [SP, #8]
	LDUR X3, [SP, #16]
	LDUR X4, [SP, #24]
	LDUR X5, [SP, #40]
	LDUR X6, [SP, #48]
	LDUR X7, [SP, #56]
	LDUR X8, [SP, #64]
	LDUR X30, [SP, #72]
	// X1, X2, X3, X4, X5, X6, X7, X8, X30

	// Pop stack
	ADD SP, SP, #80

exit:
	NOP
