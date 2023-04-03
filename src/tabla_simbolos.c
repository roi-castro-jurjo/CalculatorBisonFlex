
#include <stdio.h>
#include <string.h>
#include <malloc.h>

#include "tabla_simbolos.h"
#include "abb.h"
#include "syntax.h"

// Declaracion de la Tabla de simbolos
abb table;

void table_create(){
    // Inicialización de la tabla
    crear(&table);

    printf("Falta por implementar table_create() en tabla_simbolos.c\n");
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

void table_insert (lex_component component){
    printf("Falta por implementar table_insert() en tabla_simbolos.c.\n");
}

void table_search(){
    printf("Falta por implementar table_search() en tabla_simbolos.c\n");
}


