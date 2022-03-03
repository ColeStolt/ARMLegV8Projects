	.data
	.type	v, %object
	.size	v, 4

v:
	.xword 1, 2, 3, 5

sentence:
	.asciz "  Hello    this   is a test sentence  "

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

	// #32 is the ascii number for a space
	// Word count is stored in X2
	// V[i] is stored in X0

main:
	ADRP X0, sentence
	ADD X0, X0, :lo12:sentence

	MOV X1, #1 			// Incrementer
	MOV X3, #0 			// Word count

loop:

	LDURB W2, [X0, #0]// Load x[i] // When this is looped back to from 'wordEnd' it loads the same x[i] already loaded
	CMP W2, #0			  // Checks for null terminator
	B.EQ finally		  // Branches to finally
	CMP W2, #32 		        // 32 is the ascii number for a space
	B.NE capitalizeAndCount // Updates counter and letter
	ADD X0, X0, X1		// Increments x[i]
	B loop				    // Loop again

capitalizeAndCount:	// Capitalizes first letter and updates word count

	ADD X3, X3, #1		// Updates word count
	CMP W2, #97			  // Checks if already capitalized
	B.LT wordEnd		  // Branches if word already capitalized
	SUB X2, X2, #32 	// Captalizes word
	STURB W2, [X0, #0]// Stores capitalized word
	B wordEnd			    // Branch to other loop

wordEnd:				    // This was done so the number of spaces did not matter

	ADD X0, X0, X1		// Incremenent x[i]
	LDURB W2, [X0, #0]// Load current letter
	CMP W2, #32			  // Sets comparison flag against 32
	B.EQ loop			    // If a space go back to loop
	B wordEnd			    // Keep looping until word ends

finally:
	SUB X0, X0, #30 	 // this probably isnt the best thing to do but it just moves
						         // The array back 30 bytes (characters) so you can see the
						         // modified string. Basically goes from x[n] to x[n-30]
						         // Any string longer than that wont be seen fully, it was
						         // just easier to do.

