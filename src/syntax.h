//
// Created by Roi Castro on 03/04/2023.
//

#ifndef CALCULATORBF_SYNTAX_H
#define CALCULATORBF_SYNTAX_H

typedef struct {
    int lex_comp;
    char *lex;
    union {
        double var;
        double (*funcptr)();
        void *libhandle;
    } value;
} lex_component;

void syntax(char * param);
#endif //CALCULATORBF_SYNTAX_H
