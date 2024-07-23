// CMSC 430 Compiler Theory and Design
// Project 2 Skeleton
// Keith Lee
// Summer 2024

// This file contains the bodies of the functions that produces the 
// compilation listing

#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int errorCounts[3] = {0,0,0}; // keeps track of each type of error
static vector<string> errorVec; // use vector/arraylist to store error messages for each line

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if (errorCounts[0] == 0 && errorCounts[1] == 0 && errorCounts[2] == 0)
	  printf("Compiled Successfully\n"); // if no errors
	else { // print count of each type of error
	  printf("Lexical Errors %d \n", errorCounts[0]);
	  printf("Syntax Errors %d \n", errorCounts[1]);
	  printf("Semantic Errors %d \n", errorCounts[2]);
	}
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " };
	if (errorCategory == LEXICAL) {
	  errorCounts[0]++; // increase count of lexical
	}
	if (errorCategory == SYNTAX) {
	  errorCounts[1]++; // increase count of syntax
	}
	if (errorCategory == GENERAL_SEMANTIC) {
	  errorCounts[2]++; // increase count of semantic
	}
	error = messages[errorCategory] + message;
	errorVec.push_back(error); // add error to vector/arraylist
	totalErrors++;
}

void displayErrors()
{
  while (!errorVec.empty()) {
    printf("%s\n", errorVec.front().c_str()); // print first error in arraylist
    errorVec.erase(errorVec.begin()); // erase already printed error
	   }
}
