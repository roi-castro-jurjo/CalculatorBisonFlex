%{

%}
%option noyywrap header-file="lex.yy.h"


DELIM       [ \t\n\r]
SPACE       {DELIM}+

LETTER      [a-zA-Z]
DIGIT       [0-9]

EXP         e[+-]?{DIGIT}+
INT         {DIGIT}+
FLOAT       {INT}\.{INT}?{EXP}?|{INT}{EXP}|\.{INT}{EXP}?
NUMBER      {INT}|{FLOAT}

COMMENT     (\/\/[^\n]*)|("/*"([^*]|(\*+[^*/]))*\*+\/)

OPERATOR    [\+\-\*\/\^\=]
MISC        [\(\)\,\;]
SPECIAL     {OPERATOR}|{MISC}

WORD ({LETTER}|{NUMBER})+
FILE (\/{WORD})*{WORD}(.txt)

%%

{DELIM}
{COMMENT}



%%