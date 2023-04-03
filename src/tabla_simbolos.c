
#include <stdio.h>
#include <string.h>
#include <malloc.h>

#include "tabla_simbolos.h"
#include "abb.h"
#include "syntax.h"

// Declaracion de la Tabla de simbolos
abb table;

lex_component table_lexSearch(char * lexeme){
    printf("Falta por implementar table_lexSearch() en tabla_simbolos.c.\n");

}

lex_component table_functSeach(char * funct, void * lib, char * functionLib){
    printf("Falta por implementar table_functSeach() en tabla_simbolos.c.\n");

}

void table_insert (lex_component component){
    printf("Falta por implementar table_insert() en tabla_simbolos.c.\n");
}
void table_reassignLexeme(char * lexeme, double val){
    printf("Falta por implementar table_reassignLexeme() en tabla_simbolos.c.\n");

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

void table_search(){
    printf("Falta por implementar table_search() en tabla_simbolos.c\n");
}


