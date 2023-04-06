#include <stdio.h>
#include <stdlib.h>

#include "tabla_simbolos.h"

int main(int args, char * argv[]) {
    table_create();

    syntax(NULL);

    table_free();
    return 0;
}
