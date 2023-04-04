%{
#include <math.h>

#include "tabla_simbolos.h"
#include "error.h"
#include "lex.yy.h"


lex_component component;
int doEcho = 1;
int script = 0;
int error = 0;

void yyerror (char *s);
%}

%union {
    double number;
    char *string;
}

%start start

%token <number> NUMBER
%token <string> CONSTANT VARIABLE FUNCTION COMMAND1 COMMAND2 LIBRARY
%token <string> SOURCE_FILE

%type <number> expression assign command function

%left '-' '+'
%left '*' '/'
%left '%'
%precedence NEG
%right '^'


%%
start: %empty
        | start line
;

line:   '\n'
        | expression '\n'
        | expression ';' '\n'
        | assign '\n'
        | assign ';' '\n'
        | command '\n'
        | command ';' '\n'
        | function '\n'
        | function ';' '\n'

;

expression:    NUMBER
        | CONSTANT
        | VARIABLE
        | '-' expression %prec NEG
        | expression '+' expression
        | expression '-' expression
        | expression '*' expression
        | expression '/' expression
        | expression '%' expression
        | expression '^' expression
        | '(' expression ')'
;

assign:   VARIABLE '=' expression
        | VARIABLE '=' function
        | CONSTANT '=' expression
        | CONSTANT '=' function
;

command:   COMMAND1
        | COMMAND1 '(' ')'
        | COMMAND2
        | COMMAND2 '(' ')'
        | COMMAND2 SOURCE_FILE
        | COMMAND2 '(' SOURCE_FILE ')'
        | COMMAND2 expression
;

function:    LIBRARY '/' VARIABLE '(' expression ')'
        | LIBRARY '/' VARIABLE '(' expression ',' expression ')'
        | LIBRARY '/' VARIABLE '(' ')'
        | expression '(' expression ')'
        | expression '(' expression ',' expression ')'
        | expression '(' ')'
;
%%
