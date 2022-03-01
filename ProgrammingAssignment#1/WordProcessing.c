/* 
   Author: Cole Stoltz
   Section:  003
   Date: 02/04/2022

   Counts the number of words in the sentence and
   capitalizes the first letter of every word.
   
   */
#include <stdio.h> // For printf and scanf

int main(){

    // Size of char array
    const int ARRAY_SIZE = 75;

    // Holds number of words
    int wordCount = 0;

    // Allocate memory for 75 characters
    char sentence[75];

    // Get user input
    printf("Enter a sentence: ");
    scanf("%[^\n]", sentence);

    // Parse sentence
    for(int i = 0; i < ARRAY_SIZE; i++){
        if(sentence[i] == ' ')
            wordCount++;
            // i == 0 will assumes the user did not enter a space as the first character
        if(i-1 >= 0 && sentence[i-1] == ' ' || i==0){
            sentence[i] = sentence[i] - 32;
        }
        if(i-1 >= 0 && sentence[i-1] == ' ' && sentence[i] < 'A' || i==0){
            sentence[i] += 32;
        }
    }

    // Account for off by one
    // Also assumes user wont enter a space as the first character
    wordCount += 1;

    // Print results
    printf("Word count: %d\n", wordCount );
    printf("New sentence: %s", sentence);

}
