
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <dlfcn.h>

#include "tabla_simbolos.h"
#include "abb.h"


// Declaracion de la Tabla de simbolos
abb table;

int var_num = 0;

lex_component table_lexSearch(char * lexeme){
    tipoelem aux_search;
    buscar_nodo(table, lexeme, &aux_search);
    return aux_search;

}

lex_component table_functSeach(char * funct, void * lib, char * functionLib){
    tipoelem aux_search;
    buscar_nodo(table, funct, &aux_search);
    if (aux_search.lex != NULL) {
        return aux_search;
    } else {
        void (*funcion)(void);
        *(void **) (&funcion) = dlsym(lib, funct);
        if (funcion) {
            aux_search.lex_comp = FUNCTION;
            aux_search.lex = functionLib;
            aux_search.value.pFunction = (double (*)()) funcion;
            insertar(&table, aux_search);
        }
        return aux_search;
    }
}

void table_insert (lex_component component){
    if (component.lex_comp == VARIABLE) {
        var_num++;
    }
    insertar(&table, component);
}
void table_reassignLexeme(char * lexeme, double val){
    tipoelem aux_search;

    buscar_nodo(table, lexeme, &aux_search);
    if (aux_search.lex != NULL) {
        aux_search.value.variable = val;
        modificar(table, aux_search);
    }

}

void table_resetWorkSpace(){
    printf("Falta por implementar table_resetWorkSpace() en tabla_simbolos.c.\n");

}

void table_printWorkSpace(){
    printf("Falta por implementar table_printWorkSpace() en tabla_simbolos.c.\n");
}

void table_create(){
    // Inicialización de la tabla
    crear(&table);

    tipoelem inicializacion[] = {
            {CONSTANT, "pi", .value.variable=3.14159265358979323846},
            {CONSTANT, "e", .value.variable=2.7182818284590452354}
    };

    for (int i = 0; i < (sizeof(inicializacion) / sizeof(tipoelem)); i++) {
        insertar(&table, inicializacion[i]);
    }
}

void table_free(){
    destruir(&table);
}

void table_print(){
    printf("\n\n");
    printf("╔══════════════════╗\n");
    printf("║   SYMBOL TABLE   ║\n");
    printf("╠════════════╦═════╣\n");
    printf("║     ID     ║ VAL ║\n");
    print(table);
    printf("╚════════════╩═════╝\n\n");
}

void table_search(){
    printf("Falta por implementar table_search() en tabla_simbolos.c\n");
}


