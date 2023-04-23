
#ifndef DCOMPILER_TABLA_SIMBOLOS_H
#define DCOMPILER_TABLA_SIMBOLOS_H

typedef struct {
    int lex_comp;
    char *lex;
    union {
        double variable;
        double (*pFunction)();
        void *lib;
    } value;
} lex_component;

#include "syntax.tab.h"

lex_component table_lexSearch(char * lexeme);

lex_component table_functSearch(char * funct, void * lib);

void table_insert(lex_component component);

void table_reassignLexeme(char * lexeme, double val);

void table_resetWorkSpace();

void table_printWorkSpace();

/**
 * Inicializa la tabla de simbolos a los simbolos iniciales
 */
void table_create();

/**
 * Destruye la tabla y libera la memoria
 */
void table_free();

/**
 * Muestra la tabla por pantalla
 */
void table_print();

#endif //DCOMPILER_TABLA_SIMBOLOS_H
