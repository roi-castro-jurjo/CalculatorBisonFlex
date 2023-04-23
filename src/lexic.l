%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla_simbolos.h"
#include "error.h"
#include "syntax.tab.h"
%}
%option noyywrap
%option header-file="lex.yy.h"

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

OPERATOR    [\+\-\*\/\^\=\<\>]|[\(\)\,\;]
SPECIAL     {OPERATOR}|{END_LINE}

FILE        ({LETTER}|{DIGIT})+(\.({LETTER}|{DIGIT})+)+|(\/({LETTER}|{DIGIT})*)*\/({LETTER}|{DIGIT})+(\.({LETTER}|{DIGIT})+)+

%%

{ID}        {
                yylval.string = malloc(strlen(yytext));
                strcpy(yylval.string, yytext);

                lex_component component = table_lexSearch(yylval.string);

                if(component.lex != NULL){
                    return component.lex_comp;
                } else {
                    return VARIABLE;
                }
            }


{NUMBER}    {
                yylval.number = atof(yytext);
                return NUMBER;
            }


{FILE}      {
                yylval.string = malloc(strlen(yytext));
                strcpy(yylval.string, yytext);
                return SOURCE_FILE;
            }


{SPECIAL}   {
                return (int) *yytext;
            }


<<EOF>>     {
                setReadingScript(0);
                fclose(yyin);
                yyrestart(stdin);
                table_print();
                printf("\n>> ");
            }


"/+"        {
                int next_char;
                // Establecemos un contador de /+ para abarcar correctamente todos los comentarios anidados
                int counter = 1;
                do {
                    next_char = input();
                    if (next_char == '/') {
                        next_char = input();
                        // Cuando encontramos la cadena "/+" aumentamos el contador
                        if (next_char == '+') {
                            counter++;
                        }
                    }

                    if (next_char == '+') {
                        next_char = input();
                        // Cuando encontramos la cadena "+/" disminuímos el contador
                        if (next_char == '/') {
                            counter--;
                        }
                    }
                } while (counter != 0);
            }
{SPACE}
{COMMENT}

.           {
                error_show(LEXICAL_ERROR);
            }

%%

 void yyerror (char const *s) {
   fprintf(stderr, "SYNTAX ERROR: %s\n", s);
 }