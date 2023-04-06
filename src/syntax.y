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
double power(double base, int exponent);
int isnan(double x);
double module(double dividend, double divisor);

#define PRINT_PROMPT if (!script) printf("\n>> ");
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
            | CONSTANT                      {
                                                component = table_lexSearch($1);
                                                $$ = component.value.variable;
                                                free($1);
                                            }
            | VARIABLE                      {
                                                component = table_lexSearch($1);
                                                if (component.lex != NULL){
                                                    $$ = component.value.variable;
                                                } else{
                                                    error_show(UNDEFINED_VARIABLE);
                                                    error = 1;
                                                    $$ = NAN;
                                                }

                                                free($1);
                                            }
            | '-' expression %prec NEG      {
                                                $$ = -$2;
                                            }
            | expression '+' expression     {
                                                $$ = $1 + $3;
                                            }
            | expression '-' expression     {
                                                $$ = $1 - $3;
                                            }
            | expression '*' expression     {
                                                 $$ = $1 * $3;
                                            }
            | expression '/' expression     {
                                                if($3 == 0){
                                                    error_show(MOD_DIV_ZERO);
                                                    error = 1;
                                                    $$ = NAN;
                                                } else {
                                                    $$ = $1 / $3;
                                                }
                                            }
            | expression '%' expression     {
                                                if($3 == 0){
                                                    error_show(MOD_DIV_ZERO);
                                                    error = 1;
                                                    $$ = NAN;
                                                } else {
                                                    $$ = module($1, $3);
                                                }
                                            }
            | expression '^' expression     {
                                                $$ = power($1, $3);
                                            }
            | '(' expression ')'            {}
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

double power(double base, int exponent) {
    double result = 1.0;
    int i;

    if (exponent == 0) {
        return 1.0; // cualquier número elevado a 0 es 1
    }

    if (exponent > 0) {
        for (i = 0; i < exponent; ++i) {
            result *= base;
        }
    }
    else {
        for (i = 0; i > exponent; --i) {
            result /= base;
        }
    }

    return result;
}

int isnan(double x) {
    return x != x;
}

double module(double dividend, double divisor) {
    double quotient = dividend / divisor;
    double rest = quotient - (int)quotient;
    if (rest < 0) {
        rest += 1.0;
    }
    return rest * divisor;
}