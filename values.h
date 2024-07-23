// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// Keith Lee
// Summer 2024

// This file contains type definitions and the function
// definitions for the evaluation functions

typedef char* CharPtr;

enum Operators {ADD, MULTIPLY, LESS, AND};

double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateRelational(double left, Operators operator_, double right);

