//
// Created by Roi Castro on 03/04/2023.
//

#include "commands.h"
#include "lex.yy.h"
#include "error.h"
#include "syntax.tab.h"
#include "tabla_simbolos.h"
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>


double help(){
    printf("# COMANDOS\n"
           "\n"
           "- stable: muestra la tabla de simbolos\n"
           "- sws: muestra el espacio de trabajo\n"
           "- clear: borra lo escrito en la consola\n"
           "- clearws: elimina todas las variables del workspace\n"
           "- quit: cierra el programa\n"
           "- help: muestra la ayuda\n"
           "- load: carga un fichero y lo ejecuta. Se imprimirá la tabla de simbolos al terminar de ejecutar el fichero.\n"
           "- import: importa una libreria. Se debe indicar su archivo .so. Por ejemplo, para usar la funcion \"sin()\"\", se debe usar \"import libm.so.6\". Una vez importada una libreria, se pueden usar sus funciones usando \"from LIBRARY use FUNCTION\", o \"LIBRARY/FUNCTION\".\n"
           "\t- EJEMPLO: import libm.so.6 -> from libm use sin -> sin(PI/2) (Esta secuencia de comandos devuelve 1)\n"
           "- from LIBRARY use FUNCTION\n"
           "\n"
           "# SYNTAX\n"
           "\n"
           "TERMINAL: En cada linea de la terminal se escribe una expression. Las operaciones soportadas son \"+\", \"-\", \"/\", \"*\", \"^\", \"<\", \">\", y \"%\". Para asignar valor a una variable se usa \"VARIABLE = VALOR\". Para ejecutar un comando, se escribe seguido de sus argumentos. Las funciones funcionan de forma identica a los comandos.Si se añade \";\" al final de una sentencia, no se imprimirá el output de la misma.\n"
           "\n"
           "ARCHIVO: Sintaxis identida a la terminal, pero cada linea ha de terminar con \";\".");
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