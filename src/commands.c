//
// Created by Roi Castro on 03/04/2023.
//

#include "commands.h"
#include "lex.yy.h"
#include "error.h"
#include "syntax.tab.h"
#include <stdlib.h>
#include <stdio.h>


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
    printf("This command does nothing to quit.\n");
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