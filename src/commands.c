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


double help(){
    printf("This command does nothing to help.\n");
    return EXIT_SUCCESS;
}

double load(char * file){
    yyin = fopen(file, "r");

    if (yyin == NULL){
        error_show(BAD_SOURCE_FILE);
        yyrestart(stdin);
        return EXIT_FAILURE;
    } else {
        setReadingScript(1);
        return EXIT_SUCCESS;
    }
}

double show_table(){
    table_print();
    return EXIT_SUCCESS;
}

double quit(){
    yylex_destroy();
    table_free();
    exit(EXIT_SUCCESS);
}

double import_lib(char *lib) {
    void *library = dlopen(lib, RTLD_LAZY);
    if (library == NULL) {
        error_show(CANT_OPEN_LIBRARY);
        return EXIT_FAILURE;
    }

    char *lib_name = NULL;
    for (int i = strlen(lib) - 1; i >= 0; i--) {
        if (lib[i] == '/') {
            lib_name = &lib[i + 1];
            break;
        }
    }
    if (lib_name == NULL) {
        lib_name = lib;
    }

    char *lexema = strtok(lib_name, ".");
    lex_component comp_lib = {
            .lex_comp = LIBRARY,
            .lex = lexema,
            .value.lib = library
    };
    table_insert(comp_lib);

    return EXIT_SUCCESS;
}

double clear(){
    printf("\033c");
    return EXIT_SUCCESS;
}

double clear_ws(){
    table_resetWorkSpace();
    return EXIT_SUCCESS;
}

double show_ws(){
    table_printWorkSpace();
    return EXIT_SUCCESS;
}