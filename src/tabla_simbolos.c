
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "tabla_simbolos.h"
#include "abb.h"

// Declaracion de la Tabla de simbolos
abb table;

void table_insert (char * ID, int val);

void table_create(){
    // Inicialización de la tabla
    crear(&table);

    // Creación de las palabras clave
    tipoelem elem[8];

    elem[0].ID = "import";
    elem[0].val = IMPORT;

    elem[1].ID = "double";
    elem[1].val = DOUBLE;

    elem[2].ID = "int";
    elem[2].val = INT;

    elem[3].ID = "while";
    elem[3].val = WHILE;

    elem[4].ID = "foreach";
    elem[4].val = FOREACH;

    elem[5].ID = "return";
    elem[5].val = RETURN;

    elem[6].ID = "void";
    elem[6].val = VOID;

    elem[7].ID = "cast";
    elem[7].val = CAST;

    // Inserción de las palabras clave en la tabla
    for (int i = 0; i < 8; ++i) {
        table_insert(elem[i].ID, elem[i].val);
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

void table_insert (char * ID, int val){
    tipoelem lex;
    lex.ID = malloc(sizeof(char) * strlen(ID) + 1);
    strcpy(lex.ID, ID);
    lex.val = val;
    insertar(&table, lex);
}

void table_search(tipoelem * elem){
    tipoelem result;
    // Comprobación de si el elemento está en la tabla de simbolos
    if (es_miembro(table, *elem)){
        buscar_nodo(table, elem->ID, &result);
        elem->val = result.val;
    } else{
        // Si el elemento no existe en la tabla, se añade
        table_insert(elem->ID, elem->val);
    }
}


