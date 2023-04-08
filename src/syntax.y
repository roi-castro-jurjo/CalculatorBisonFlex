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
            | '(' expression ')'            {
                                                $$ = $2;
                                            }
;

assign:       VARIABLE '=' expression       {
                                                if (!error){
                                                    component = table_lexSearch($1);
                                                    if (component.lex != NULL){
                                                        table_reassignLexeme($1, $3);
                                                    } else {
                                                        component.lex = malloc(strlen($1));
                                                        strcpy(component.lex, $1);
                                                        component.lex_comp = VARIABLE;
                                                        component.value.variable = $3;
                                                        table_insert(component);
                                                        free(component.lex);
                                                    }
                                                }
                                                $$ = $3;
                                                free($1);
                                            }
            | VARIABLE '=' function         {
                                                if (!error){
                                                    component = table_lexSearch($1);
                                                    if (component.lex != NULL){
                                                        table_reassignLexeme($1, $3);
                                                    } else {
                                                        component.lex = malloc(strlen($1));
                                                        strcpy(component.lex, $1);
                                                        component.lex_comp = VARIABLE;
                                                        component.value.variable = $3;
                                                        table_insert(component);
                                                        free(component.lex);
                                                    }
                                                }
                                                $$ = $3;
                                                free($1);
                                            }
            | VARIABLE '=' CONSTANT         {
                                                lex_component constant;
                                                if (!error){
                                                    constant = table_lexSearch($3);
                                                    component = table_lexSearch($1);
                                                    if (component.lex != NULL){
                                                        table_reassignLexeme($1, constant.value.variable);
                                                    } else {
                                                        component.lex = malloc(strlen($1));
                                                        strcpy(component.lex, $1);
                                                        component.lex_comp = VARIABLE;
                                                        component.value.variable = constant.value.variable;
                                                        table_insert(component);
                                                        free(component.lex);
                                                    }
                                                }
                                                $$ = constant.value.variable;
                                                free($1);
                                            }
            | VARIABLE '=' VARIABLE         {
                                                lex_component aux_variable;
                                                if (!error){
                                                    aux_variable = table_lexSearch($3);
                                                    component = table_lexSearch($1);
                                                    if (component.lex != NULL){
                                                        table_reassignLexeme($1, aux_variable.value.variable);
                                                    } else {
                                                        component.lex = malloc(strlen($1));
                                                        strcpy(component.lex, $1);
                                                        component.lex_comp = VARIABLE;
                                                        component.value.variable = aux_variable.value.variable;
                                                        table_insert(component);
                                                        free(component.lex);
                                                    }
                                                }
                                                $$ = aux_variable.value.variable;
                                                free($1);
                                            }
            | CONSTANT '=' expression       {
                                                error_show(ASSIGN_CONSTANT);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                            }
            | CONSTANT '=' function         {
                                                error_show(ASSIGN_CONSTANT);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                            }
            | CONSTANT '=' VARIABLE         {
                                                error_show(ASSIGN_CONSTANT);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                            }
            | CONSTANT '=' CONSTANT         {
                                                error_show(ASSIGN_CONSTANT);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                            }
;

command:      COMMAND1                      {
                                                component = table_lexSearch($1);
                                                (*(component.value.pFunction))();
                                                free($1);
                                            }
            | COMMAND1 '(' ')'              {
                                                component = table_lexSearch($1);
                                                (*(component.value.pFunction))();
                                                free($1);
                                             }
            | COMMAND2 expression            {
                                                error_show(BAD_SOURCE_FILE);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                             }
            | COMMAND2                       {
                                                error_show(BAD_SOURCE_FILE);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                             }
            | COMMAND2 '(' ')'               {
                                                error_show(BAD_SOURCE_FILE);
                                                error = 1;
                                                $$ = NAN;
                                                free($1);
                                             }
            | COMMAND2 SOURCE_FILE           {
                                                component = table_lexSearch($1);
                                                (*(component.value.pFunction))($2);
                                                free($1);
                                                free($2);
                                             }
            | COMMAND2 '(' SOURCE_FILE ')'   {
                                                 component = table_lexSearch($1);
                                                 (*(component.value.pFunction))($3);
                                                 free($1);
                                                 free($3);
                                              }
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
        return 1.0;
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