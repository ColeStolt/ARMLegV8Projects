/* 
   Author: Cole Stoltz
   Date: 02/05/2022

   Calculates the cosine of a number
   
   */
#include <stdio.h> // For printf and scanf

int main(){

    // Formula ((-1)^nx^(2n))/(2n)!
    // n = a
    int n = 1;
    // Single precision float
    float x = 1;

    // Get user input
    printf("Enter a degree: ");
    scanf("%f", &x);

    printf("Enter number of iterations: ");
    scanf("%d", &n);

    // Holds exponents 1 and 2
    int exp1 = -1;
    float exp2 = 1;

    // For holding the factorial
    int fact = 1;
     
     // Holds the final result
    float result = 0.0;

    // Convert to radians
    x = x * (3.142/180.0);

    for(int i = 0; i <= n; i++){
        
       // Exponent 1
        for(int j = 1; j <= i; j++){ // This equals (-1)^n
           exp1 *= -1;
       }
       // Exponent 2
        for(int k = 1; k <= i*2; k++){ // This equals (x)^(2n)
           exp2 *= x;
       }
       // Factorial
       for(int z = 1; z <= i*2;z++){ // This equals (2n)!
           fact *= z;
       }

        // Series, so add results of computation to the last
        result += (exp1*exp2)/fact;
        
        // Reset for next iteration
        fact = 1;
        exp2 = 1;
        exp1 = -1;
        
    }

    // Print final result
    printf("=\n%f\n\n", result);
    
}
