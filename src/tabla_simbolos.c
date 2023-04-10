
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <dlfcn.h>

#include "tabla_simbolos.h"
#include "abb.h"
#include "commands.h"


// Declaracion de la Tabla de simbolos
abb table;

lex_component table_lexSearch(char * lexeme){
    tipoelem aux_search;
    aux_search.lex = NULL;
    buscar_nodo(table, lexeme, &aux_search);
    return aux_search;

}

lex_component table_functSearch(char * funct, void * lib){
    tipoelem comp_busqueda = {0, NULL};
    buscar_nodo(table, funct, &comp_busqueda);

    if (comp_busqueda.lex == NULL) {
        void (*funcion)(void);
        *(void **) (&funcion) = dlsym(lib, funct);
        if (funcion) {
            comp_busqueda.lex_comp = FUNCTION;
            comp_busqueda.lex = funct;
            comp_busqueda.value.pFunction = (double (*)()) funcion;
            table_insert(comp_busqueda);
        }
    }
    table_print();
    return comp_busqueda;
}

void table_insert (lex_component component){
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
    reset_ws(table);
}

void table_printWorkSpace(){
    printf("\n\n");
    printf("╔═════════════════════════════════════╗\n");
    printf("║              WORK_SPACE             ║\n");
    printf("╠════════════╦════════════╦═══════════╣\n");
    printf("║    TYPE    ║     ID     ║    VAL    ║\n");
    print_ws(table);
    printf("╚════════════╩════════════╩═══════════╝\n\n");
}

void table_create(){
    // Inicialización de la tabla
    crear(&table);

    tipoelem inicializacion[] = {
            {CONSTANT, "PI", .value.variable=3.141592653589793},
            {CONSTANT, "e", .value.variable=2.718281828459045},
            {COMMAND1, "help", .value.pFunction=help},
            {COMMAND2, "load", .value.pFunction=load},
            {COMMAND2, "import", .value.pFunction=import_lib},
            {COMMAND1, "stable", .value.pFunction=show_table},
            {COMMAND1, "sws", .value.pFunction=show_ws},
            {COMMAND1, "clear", .value.pFunction=clear},
            {COMMAND1, "clearws", .value.pFunction=clear_ws},
            {COMMAND1, "quit", .value.pFunction=quit},
            {COMMAND2, "from", .value.pFunction=import_lib},
            {COMMAND2, "use"},
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
    printf("╔═════════════════════════════════════╗\n");
    printf("║             SYMBOL TABLE            ║\n");
    printf("╠════════════╦════════════╦═══════════╣\n");
    printf("║    TYPE    ║     ID     ║    VAL    ║\n");
    print(table);
    printf("╚════════════╩════════════╩═══════════╝\n\n");
}

void table_search(){
    printf("Falta por implementar table_search() en tabla_simbolos.c\n");
}


