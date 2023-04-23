#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla_simbolos.h"
#include "commands.h"

void logo_print(){
    printf("\n\n .d8888b.        d8888 888      .d8888b.  888     888 888             d8888 88888888888 .d88888b.  8888888b.  888888b.   8888888888 \n"
           "d88P  Y88b      d88888 888     d88P  Y88b 888     888 888            d88888     888    d88P\" \"Y88b 888   Y88b 888  \"88b  888        \n"
           "888    888     d88P888 888     888    888 888     888 888           d88P888     888    888     888 888    888 888  .88P  888        \n"
           "888           d88P 888 888     888        888     888 888          d88P 888     888    888     888 888   d88P 8888888K.  8888888    \n"
           "888          d88P  888 888     888        888     888 888         d88P  888     888    888     888 8888888P\"  888  \"Y88b 888        \n"
           "888    888  d88P   888 888     888    888 888     888 888        d88P   888     888    888     888 888 T88b   888    888 888        \n"
           "Y88b  d88P d8888888888 888     Y88b  d88P Y88b. .d88P 888       d8888888888     888    Y88b. .d88P 888  T88b  888   d88P 888        \n"
           " \"Y8888P\" d88P     888 88888888 \"Y8888P\"   \"Y88888P\"  88888888 d88P     888     888     \"Y88888P\"  888   T88b 8888888P\"  888\n\n");
}

int main(int argc, char * argv[]) {

    table_create();

    if (argc == 1){
        logo_print();
        yyparse();
    } else if (argc == 2){
        if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0){
            help();
        } else {
            logo_print();
            load(argv[1]);
            yyparse();
        }
    }

    table_free();
    return 0;
}
