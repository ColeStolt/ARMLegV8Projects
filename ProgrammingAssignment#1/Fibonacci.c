/* 
   Author: Cole Stoltz
   Date: 01/31/2022

   Calculates the first 8 fibonacci numbers using the following
   equation (Fn-2 + Fn-1 = Fn).
   
   */
#include <stdio.h> // For printf and scanf

int main(){

    // Size of array
    const int ARRAY_SIZE = 10;

    // Initialize first two numbers
    int fibonacciSequence[10] = {0, 1};

    // First 8 Fibonacci numbers
    for(int i = 2; i < ARRAY_SIZE; i++){
        fibonacciSequence[i] = fibonacciSequence[i - 2] + fibonacciSequence[i - 1];
    }

    // Print 10 (Inluding the first 0, 1) Fibonacci numbers
    for(int i = 0; i < ARRAY_SIZE; i++){
        printf("%d, ", fibonacciSequence[i]);
    }

}
