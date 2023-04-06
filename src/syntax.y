%{
#include <math.h>

#include "tabla_simbolos.h"
#include "error.h"
#include "lex.yy.h"
#include <stdio.h>
#include <stdlib.h>


lex_component component;
int doEcho = 1;
int script = 0;
int error = 0;

void yyerror (char *s);

#define PRINT_PROMPT if (!script) printf(">> ");
%}


%union {
    double number;
    char *string;
}

%start start

%type <number> expression
%type <number> assign
%type <number> command
%type <number> function

%token <number> NUMBER

%token <string> CONSTANT
%token <string> VARIABLE
%token <string> FUNCTION
%token <string> COMMAND1
%token <string> COMMAND2
%token <string> LIBRARY
%token <string> SOURCE_FILE

%left '-' '+'
%left '*' '/'
%left '%'
%precedence NEG
%right '^'


%%
start:        %empty            {
                                    PRINT_PROMPT
                                }
            | start line
;

line:         '\n'                      {
                                            PRINT_PROMPT
                                        }
            | expression '\n'           {
                                            if(!error){
                                                if (doEcho){
                                                printf("%lf", $1);
                                                }
                                            }
                                            PRINT_PROMPT
                                            error = 0;
                                        }
            | expression ';' '\n'       {
                                             if(!error){
                                                 if (doEcho){
                                                 printf("%lf", $1);
                                                 }
                                             }
                                             PRINT_PROMPT
                                             error = 0;
                                         }
            | assign '\n'                {
                                             if(!error){
                                                 if (doEcho){
                                                 printf("%lf", $1);
                                                 }
                                             }
                                             PRINT_PROMPT
                                             error = 0;
                                         }
            | assign ';' '\n'            {
                                             if(!error){
                                                 if (doEcho){
                                                 printf("%lf", $1);
                                                 }
                                             }
                                             PRINT_PROMPT
                                             error = 0;
                                         }
            | command '\n'               {
                                              if(!error){
                                                  if (doEcho){
                                                  printf("%lf", $1);
                                                  }
                                              }
                                              PRINT_PROMPT
                                              error = 0;
                                          }
            | command ';' '\n'            {
                                              if(!error){
                                                  if (doEcho){
                                                  printf("%lf", $1);
                                                  }
                                              }
                                              PRINT_PROMPT
                                              error = 0;
                                          }
            | function '\n'               {
                                               if(!error){
                                                   if (doEcho){
                                                   printf("%lf", $1);
                                                   }
                                               }
                                               PRINT_PROMPT
                                               error = 0;
                                           }
            | function ';' '\n'            {
                                               if(!error){
                                                   if (doEcho){
                                                   printf("%lf", $1);
                                                   }
                                               }
                                               PRINT_PROMPT
                                               error = 0;
                                           }
;

expression:   NUMBER
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

assign:       VARIABLE '=' expression
            | VARIABLE '=' function
            | VARIABLE '=' CONSTANT
            | CONSTANT '=' expression
            | CONSTANT '=' function
;

command:      COMMAND1
            | COMMAND1 '(' ')'
            | COMMAND2
            | COMMAND2 '(' ')'
            | COMMAND2 SOURCE_FILE
            | COMMAND2 '(' SOURCE_FILE ')'
            | COMMAND2 expression
;

function:     LIBRARY '/' VARIABLE '(' expression ')'
            | LIBRARY '/' VARIABLE '(' expression ',' expression ')'
            | LIBRARY '/' VARIABLE '(' ')'
            | expression '(' expression ')'
            | expression '(' expression ',' expression ')'
            | expression '(' ')'
;
%%

void setReadingScript(int value) {
    script = value;
}