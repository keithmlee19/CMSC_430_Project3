/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   Keith Lee
   Summer 2024 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

char returnEscapeChar(char* chartext);

%}

%option noyywrap

ws		[ \t\r]+
comment		("//"|"--").*\n
line		[\n]
id		[A-Za-z](_?_?[A-Za-z0-9]+)*
digit		[0-9]
dec		{digit}+
hex		#[A-Fa-f0-9]+
real		[0-9]*\.[0-9]+([eE][+-]?[0-9]+)*
char		'(\\b|\\t|\\n|\\f|\\r|.)'
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"%"		{ ECHO; yylval.oper = MOD; return(MODOP); }
"^"		{ ECHO; yylval.oper = EXP; return(EXPOP); }
"~"		{ ECHO; yylval.oper = NEG; return(NEGOP); }
"&"		{ ECHO; yylval.oper = AND; return(ANDOP); }
"|"		{ ECHO; yylval.oper = OR; return(OROP); }
"!"		{ ECHO; yylval.oper = NOT; return(NOTOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUALS; return(RELOP); }
"<>"		{ ECHO; yylval.oper = NOTEQUALS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEREQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSEQUAL; return(RELOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
else		{ ECHO; return(ELSE); }
elsif		{ ECHO; return(ELSIF); }
end		{ ECHO; return(END); }
endfold		{ ECHO; return(ENDFOLD); }
endif		{ ECHO; return(ENDIF); }
endswitch	{ ECHO; return(ENDSWITCH); }
fold		{ ECHO; return(FOLD); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
if		{ ECHO; return(IF); }
is		{ ECHO; return(IS); }
left		{ ECHO; return(LEFT); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
returns		{ ECHO; return(RETURNS); }
right		{ ECHO; return(RIGHT); }
switch		{ ECHO; return(SWITCH); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{dec}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{hex}		{ ECHO; std::string s = yytext; yylval.value = stoi(s.substr(1),nullptr,16); return(INT_LITERAL); }
{real}		{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{char}		{ ECHO; yylval.value = returnEscapeChar(yytext); return(CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

char returnEscapeChar(char* chartext) {
	char escChars[] = "btnrf";
	if (chartext[1] == '\\') {
		for (int j = 0; j < 5; j++) {
			if (chartext[2] == escChars[j]) {
				return j + 8;
			}
		}
	}
	else {
		return chartext[1];
	}
	return 0;
}

