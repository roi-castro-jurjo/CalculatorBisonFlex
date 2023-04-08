//
// Created by Roi Castro on 03/04/2023.
//

#include "commands.h"
#include "lex.yy.h"
#include "error.h"
#include "syntax.tab.h"
#include "syntax.h"
#include "tabla_simbolos.h"
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>


int help(){
    printf("This command does nothing to help.\n");
    return EXIT_SUCCESS;
}

int load(char * file){
    yyin = fopen(file, "r");

    if (yyin == NULL){
        error_show(BAD_SOURCE_FILE);
        yyin = stdin;
        return EXIT_FAILURE;
    } else {
        setReadingScript(1);
        return EXIT_SUCCESS;
    }
}

int show_table(){
    printf("This command does nothing to show.\n");
    return EXIT_SUCCESS;
}

int quit(){
    printf("This command does nothing to quit.\n");
    return EXIT_SUCCESS;
}

int import_lib(char * lib){
    void *library = dlopen(lib, RTLD_LAZY);
    char *nome_lib = NULL;
    char *lexema;
    if (library == NULL) {
        printf("\033[1;31mErro: apertura de librería fallida.\n\tDetalles: %s\033[0m\n\n", dlerror());
    } else {
        for (int i = strlen(lib) - 1; i >= 0; i--) {
            if (lib[i] == '/') {
                nome_lib = &lib[i + 1];
                break;
            }
        }
        if (nome_lib == NULL) {
            nome_lib = lib;
        }
        lexema = strtok(nome_lib, ".");
        lex_component comp_lib = {LIBRARY, lexema, .value.lib = library};
        table_insert(comp_lib);
        printf("\033[1;33mLibrería cargada correctamente.\n\n\033[0m");
    }
    return EXIT_SUCCESS;
}

int clear(){
    printf("This command does nothing to quit.\n");
    return EXIT_SUCCESS;
}

int clear_ws(){
    printf("This command does nothing to quit.\n");
    return EXIT_SUCCESS;
}

int show_ws(){
    printf("This command does nothing to quit.\n");
    return EXIT_SUCCESS;
}