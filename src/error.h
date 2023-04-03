//
// Created by Roi Castro on 03/04/2023.
//

#ifndef CALCULATORBF_ERROR_H
#define CALCULATORBF_ERROR_H

#include <stdio.h>
#include <stdlib.h>

#define SYNTAX_ERROR 101
#define UNDEFINED_VARIABLE 102
#define UNDEFINED_FUNCTION 103
#define ASSIGN_CONSTANT 104
#define MOD_DIV_ZERO 105
#define BAD_SOURCE_FILE 106
#define MISSING_ARGUMENTS 107
#define MISSING_LIBRARY 108

void error_show(int error);

#endif //CALCULATORBF_ERROR_H
