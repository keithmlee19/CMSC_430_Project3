/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   Keith Lee
   Summer 2024
   
   Project 3 Parser with semantic actions for the interpreter */

%{

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);

Symbols<double> scalars;
Symbols<vector<double>*> lists;
double result;

double* cl_args;
int parameterNo = 0;
int parameterCount;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	Fold_Dirs dir;
	double value;
	vector<double>* list;
}

%token <iden> IDENTIFIER

%token <value> INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token <oper> ADDOP MULOP MODOP EXPOP ANDOP OROP RELOP NEGOP NOTOP

%token ARROW

%token BEGIN_ CASE CHARACTER ELSE ELSIF END ENDFOLD ENDIF ENDSWITCH FOLD FUNCTION IF INTEGER IS LEFT LIST OF OTHERS
	REAL RETURNS RIGHT SWITCH THEN WHEN

%type <value> body statement_ statement cases case case_ elsif_clauses elsif_clause 
	expression term exp_term neg_term primary condition or_condition not_condition relation
	
%type <oper> operator

%type <list> list list_choice expressions

%type <dir> direction

%%

function:	
	function_header optional_variable_ body ';' {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_params RETURNS type ';' ;

type:
	INTEGER |
	CHARACTER |
	REAL ;
	
optional_variable_:
	optional_variable |
	error ';' ;
	
optional_variable:
	optional_variable variable |
	%empty ;

variable:	
	IDENTIFIER ':' type IS statement ';' {scalars.insert($1, $5);}; |
	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $7);} ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$1->push_back($3); $$ = $1;} | 
	expression {$$ = new vector<double>(); $$->push_back($1);}
	
optional_params:
	parameters |
	%empty ;

parameters:
	parameters ',' parameter |
	parameter ;

parameter:
	IDENTIFIER ':' type {if (parameterNo < parameterCount) scalars.insert($1, cl_args[parameterNo++]);} ;

body:
	BEGIN_ statement_ END {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
    
statement:
	expression |
	WHEN or_condition ',' expression ':' expression {$$ = $2 ? $4 : $6;} |
	SWITCH expression IS cases OTHERS ARROW statement_ ENDSWITCH
		{$$ = !isnan($4) ? $4 : $7;} |
	IF or_condition THEN statement_ elsif_clauses ELSE statement_ ENDIF {$$ = $2 ? $4 : !isnan($5) ? $5 : $7;} |
	FOLD direction operator list_choice ENDFOLD {$$ = evaluateFold($2, $3, *$4);} ;

elsif_clauses:
	elsif_clauses elsif_clause {$$ = !isnan($1) ? $1 : $2;} |
	%empty {$$ = NAN;} ;

elsif_clause:
	ELSIF or_condition THEN statement_ {$$ = $2 ? $4 : NAN;} ;
	
cases:
	cases case_ {$$ = !isnan($1) ? $1 : $2;} |
	%empty {$$ = NAN;} ;

case_:
	case |
	error ';' {$$ = 0;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $<value>-2 == $2 ? $4 : NAN;} ;

direction:
	LEFT {$$ = LEFT_DIR;} |
	RIGHT {$$ = RIGHT_DIR;} ;

operator:
	ADDOP |
	MULOP |
	EXPOP ;

list_choice:
	list |
	IDENTIFIER {if (!lists.find($1, $$)) appendError(UNDECLARED, $1);} ;
	
or_condition:
	or_condition OROP condition {$$ = $1 || $3;} |
	condition ;

condition:
	condition ANDOP not_condition {$$ = $1 && $3;} |
	not_condition ;

not_condition:
	NOTOP relation {$$ = !($2);} |
	relation ;

relation:
	'(' or_condition ')' {$$ = $2;} |
	expression RELOP expression {$$ = evaluateRelational($1, $2, $3);} ;

expression:
	expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term ;
      
term:
	term MULOP exp_term {$$ = evaluateArithmetic($1, $2, $3);}  |
	term MODOP exp_term {$$ = evaluateArithmetic($1, $2, $3);}  |
	exp_term ;

// the only right associative binary operator
exp_term:
	neg_term EXPOP exp_term {$$ = evaluateArithmetic($1, $2, $3);} |
	neg_term ;

neg_term:
	NEGOP primary {$$ = evaluateArithmetic($2, $1, 0);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | 
	CHAR_LITERAL |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' {$$ = extract_element($1, $3); } |
	IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

int main(int argc, char *argv[]) {
	cl_args = new double[argc-1];
	parameterCount = argc - 1;
	for (int i = 0; i < argc-1; i++) {
		cl_args[i] = atof(argv[i+1]);
	}
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
