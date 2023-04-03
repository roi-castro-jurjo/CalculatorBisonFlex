%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "syntax.h"
#include "tabla.simbolos.h"
#include "error.h"
#include "bison.tab.h"
%}
%option noyywrap header-file="lex.yy.h"


DELIM       [ \t\r]
SPACE       {DELIM}+
END_LINE    \n

LETTER      [a-zA-Z]
DIGIT       [0-9]

EXP         e[+-]?{DIGIT}+
INT         {DIGIT}+
FLOAT       ({INT}\.{INT}?{EXP}?)|({INT}{EXP})|(\.{INT}{EXP}?)
NUMBER      {INT}|{FLOAT}

COMMENT     (\/\/[^\n]*)|("/*"([^*]|(\*+[^*/]))*\*+\/)

ID          ((\_|{LETTER})+(\_|{LETTER}|{NUMBER})*)

OPERATOR    [\+\-\*\/\^\=]|[\(\)\,\;]
SPECIAL     {OPERATOR}|{END_LINE}

FILE        ({LETTER}|{NUMBER})+(.cbf)

%%

{NUMBER}  {yylval.number = atof(yytext); return NUM;}



{DELIM}
{COMMENT}

%%