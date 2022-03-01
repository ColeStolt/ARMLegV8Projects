#include <stdio.h> // For printf / scanf

/* 
   Author: Cole Stoltz
   Section:  003
   Date: 02/03/2022

   Calculates the dot product of two arrays (size 5) one with
   the first five odd numbers and the other with the first 
   five even numbers.

   Equation: (a1 * b1) + (a2 * b2) + ... + (an * bn)
   
   */

int main(){

    // Size of the arrays
    const int ARRAY_SIZE = 5;

    // Arrays (vectors) to be multiplied
    int evenNumbers[5] = {2, 4, 6, 8, 10};
    int oddNumbers[5] = {1, 3, 5, 7, 9};
    
    // Sum of dot product
    int sum = 0;

    // Performs dot product
    for(int i  = 0 ; i < ARRAY_SIZE; i++){
        sum += evenNumbers[i] * oddNumbers[i];
    }

    // Print sum
    printf ("Sum of vector multiplication: [%d]", sum);
}
