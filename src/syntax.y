%{
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
double set_nan();

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
                                                    $$ = set_nan();
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
                                                    $$ = set_nan();
                                                } else {
                                                    $$ = $1 / $3;
                                                }
                                            }
            | expression '%' expression     {
                                                if($3 == 0){
                                                    error_show(MOD_DIV_ZERO);
                                                    error = 1;
                                                    $$ = set_nan();
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
            | CONSTANT '=' expression       {
                                                error_show(ASSIGN_CONSTANT);
                                                error = 1;
                                                $$ = set_nan();
                                                free($1);
                                            }
            | CONSTANT '=' function         {
                                                error_show(ASSIGN_CONSTANT);
                                                error = 1;
                                                $$ = set_nan();
                                                free($1);
                                            }
            | NUMBER '=' expression         {
                                                error_show(SYNTAX_ERROR);
                                                error = 1;
                                                $$ = set_nan();
                                            }
;

command:      COMMAND1                      {
                                                component = table_lexSearch($1);
                                                component.value.pFunction();
                                                free($1);
                                                error = 1;
                                            }
            | COMMAND1 '(' ')'              {
                                                component = table_lexSearch($1);
                                                component.value.pFunction();
                                                free($1);
                                                error = 1;
                                             }
            | COMMAND1 '(' expression ')'    {
                                                error_show(SYNTAX_ERROR);
                                                error = 1;
                                                $$ = set_nan();
                                             }
            | COMMAND2 expression            {
                                                error_show(BAD_SOURCE_FILE);
                                                error = 1;
                                                $$ = set_nan();
                                                free($1);
                                             }
            | COMMAND2                       {
                                                error_show(BAD_SOURCE_FILE);
                                                error = 1;
                                                $$ = set_nan();
                                                free($1);
                                             }
            | COMMAND2 '(' ')'               {
                                                error_show(BAD_SOURCE_FILE);
                                                error = 1;
                                                $$ = set_nan();
                                                free($1);
                                             }
            | COMMAND2 SOURCE_FILE           {
                                                component = table_lexSearch($1);
                                                component.value.pFunction($2);
                                                free($1);
                                                free($2);
                                             }
            | COMMAND2 '(' SOURCE_FILE ')'   {
                                                 component = table_lexSearch($1);
                                                 component.value.pFunction($3);
                                                 free($1);
                                                 free($3);
                                              }
;

function:     LIBRARY '/' VARIABLE '(' expression ')'   {
                                                            component = table_lexSearch($1);

                                                            char *library = malloc((strlen($1) + strlen($3) + 2) * sizeof(char));
                                                            sprintf(library, "%s/%s", $1, $3);

                                                            lex_component function = table_functSearch( $3, component.value.lib, library);

                                                            if (function.lex != NULL) {
                                                                $$ = function.value.pFunction($5);
                                                            } else {
                                                                error_show(UNDEFINED_FUNCTION);
                                                                error = 1;
                                                                $$ = set_nan();
                                                            }
                                                            free(library);
                                                            free($1);
                                                            free($3);
                                                        }
            | LIBRARY '/' FUNCTION '(' expression ')'     {
                                                            component = table_lexSearch($1);

                                                            char *library = malloc((strlen($1) + strlen($3) + 2) * sizeof(char));
                                                            sprintf(library, "%s/%s", $1, $3);

                                                            lex_component function = table_functSearch( $3, component.value.lib, library);

                                                            if (function.lex != NULL) {
                                                                $$ = function.value.pFunction($5);
                                                            } else {
                                                                error_show(UNDEFINED_FUNCTION);
                                                                error = 1;
                                                                $$ = set_nan();
                                                            }
                                                            free(library);
                                                            free($1);
                                                            free($3);
                                                        }
            | LIBRARY '/' VARIABLE '(' expression ',' expression ')'    {
                                                                            component = table_lexSearch($1);

                                                                            char *library = malloc((strlen($1) + strlen($3) + 2) * sizeof(char));
                                                                            sprintf(library, "%s/%s", $1, $3);

                                                                            lex_component function = table_functSearch( $3, component.value.lib, library);

                                                                            if (function.lex != NULL) {
                                                                                $$ = function.value.pFunction($5);
                                                                            } else {
                                                                                error_show(UNDEFINED_FUNCTION);
                                                                                error = 1;
                                                                                $$ = set_nan();
                                                                            }
                                                                            free(library);
                                                                            free($1);
                                                                            free($3);
                                                                        }
            | LIBRARY '/' VARIABLE '(' ')'                              {
                                                                            error_show(MISSING_ARGUMENTS);
                                                                            error = 1;
                                                                            $$ = set_nan();
                                                                        }
            | expression '(' expression ')'                             {
                                                                            error_show(MISSING_ARGUMENTS);
                                                                            error = 1;
                                                                            $$ = set_nan();
                                                                        }
            | expression '(' expression ',' expression ')'              {
                                                                            error_show(MISSING_ARGUMENTS);
                                                                            error = 1;
                                                                            $$ = set_nan();
                                                                        }
            | expression '(' ')'                            {
                                                                error_show(MISSING_ARGUMENTS);
                                                                error = 1;
                                                                $$ = set_nan();
                                                            }
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

double set_nan() {
    unsigned long long nan_bits = 0x7FF8000000000000ULL;
    double nan_value;
    memcpy(&nan_value, &nan_bits, sizeof(double));
    return nan_value;
}