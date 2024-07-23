/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IDENTIFIER = 258,              /* IDENTIFIER  */
    INT_LITERAL = 259,             /* INT_LITERAL  */
    CHAR_LITERAL = 260,            /* CHAR_LITERAL  */
    REAL_LITERAL = 261,            /* REAL_LITERAL  */
    ADDOP = 262,                   /* ADDOP  */
    MULOP = 263,                   /* MULOP  */
    MODOP = 264,                   /* MODOP  */
    EXPOP = 265,                   /* EXPOP  */
    NEGOP = 266,                   /* NEGOP  */
    ANDOP = 267,                   /* ANDOP  */
    RELOP = 268,                   /* RELOP  */
    ARROW = 269,                   /* ARROW  */
    BEGIN_ = 270,                  /* BEGIN_  */
    CASE = 271,                    /* CASE  */
    CHARACTER = 272,               /* CHARACTER  */
    ELSE = 273,                    /* ELSE  */
    ELSIF = 274,                   /* ELSIF  */
    END = 275,                     /* END  */
    ENDFOLD = 276,                 /* ENDFOLD  */
    ENDIF = 277,                   /* ENDIF  */
    ENDSWITCH = 278,               /* ENDSWITCH  */
    FOLD = 279,                    /* FOLD  */
    FUNCTION = 280,                /* FUNCTION  */
    IF = 281,                      /* IF  */
    INTEGER = 282,                 /* INTEGER  */
    IS = 283,                      /* IS  */
    LEFT = 284,                    /* LEFT  */
    LIST = 285,                    /* LIST  */
    OF = 286,                      /* OF  */
    OTHERS = 287,                  /* OTHERS  */
    REAL = 288,                    /* REAL  */
    RETURNS = 289,                 /* RETURNS  */
    RIGHT = 290,                   /* RIGHT  */
    SWITCH = 291,                  /* SWITCH  */
    THEN = 292,                    /* THEN  */
    WHEN = 293                     /* WHEN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 34 "parser.y"

	CharPtr iden;
	Operators oper;
	double value;
	vector<double>* list;

#line 109 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
