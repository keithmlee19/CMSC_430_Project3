// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// Keith Lee
// Summer 2024

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>
#include <numeric>
#include <vector>
#include <functional>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateArithmetic(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case ADD:
			result = left + right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case MOD:
			result = fmod(left, right);
			break;
		case EXP:
			result = pow(left, right);
			break;
		case NEG:
			result = left * (-1);
			break;
	}
	return result;
}

double evaluateRelational(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case LESS:
			result = left < right;
			break;
		case EQUALS:
			result = left == right;
			break;
		case NOTEQUALS:
			result = left != right;
			break;
		case GREATER:
			result = left > right;
			break;
		case GREATEREQUAL:
			result = left >= right;
			break;
		case LESSEQUAL:
			result = left <= right;
			break;
	}
	return result;
}

double evaluateFold(Fold_Dirs fold_dir, Operators operator_, vector<double> list) {
	double result;
	if (fold_dir == LEFT_DIR) {
		switch (operator_) {
			case ADD:
				result = accumulate(list.begin(), list.end(), 0, plus<double>());
				break;
			case SUBTRACT:
				result = accumulate(list.begin(), list.end(), list[0]*2, minus<double>());
				break;
			case MULTIPLY:
				result = accumulate(list.begin(), list.end(), 1, multiplies<double>());
				break;
			case DIVIDE:
				result = accumulate(list.begin(), list.end(), list[0]*list[0], divides<double>());
				break;
			case EXP:
			{
				auto expf = [](double lhs, double rhs) {return pow(lhs, rhs); };
				result = accumulate(list.begin(), list.end(), pow(list[0], 1.0/list[0]), expf);
				break;
			}
		}
	}
	else {
		result = list[list.size() - 1];
		for (int i = list.size() - 2; i >=  0; i--)
			result = evaluateArithmetic(list[i], operator_, result);
	}
	return result;
}