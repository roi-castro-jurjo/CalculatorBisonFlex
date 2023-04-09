//
// Created by Roi Castro on 03/04/2023.
//

#include "error.h"

void error_show(int error){
    switch (error) {
        case SYNTAX_ERROR:
            printf("\n\nSYNTAX ERROR\n\n");
            break;
        case UNDEFINED_VARIABLE:
            printf("\n\nUNDEFINED VARIABLE\n\n");
            break;
        case UNDEFINED_FUNCTION:
            printf("\n\nUNDEFINED FUNCTION\n\n");
            break;
        case ASSIGN_CONSTANT:
            printf("\n\nCANNOT REASSIGN CONSTANT\n\n");
            break;
        case MOD_DIV_ZERO:
            printf("\n\nCANNOT DIVIDE BY ZERO\n\n");
            break;
        case BAD_SOURCE_FILE:
            printf("\n\nSOURCE FILE NOT FOUND\n\n");
            break;
        case MISSING_ARGUMENTS:
            printf("\n\nINVALID OR MISSING ARGUMENTS\n\n");
            break;
        case LIBRARY_NOT_FOUND:
            printf("\n\nINVALID OR MISSING LIBRARY\n\n");
            break;
        case CANT_OPEN_LIBRARY:
            printf("\n\nCOULDNT OPEN LIBRARY\n\n");
            break;
        default:
            break;
    }
}