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
        fclose(yyin);
        yyin = stdin;
        return EXIT_SUCCESS;
    }
}

int show_table(){
    printf("This command does nothing to show.\n");
    return EXIT_SUCCESS;
}

int quit(){
    yylex_destroy();
    table_free();
    exit(EXIT_SUCCESS);
}

int import_lib(char *lib) {
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