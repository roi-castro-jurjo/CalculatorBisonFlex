#include "abb.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include "syntax.tab.h"

///////////////////////// ESTRUCTURAS DE DATOS

struct celda {
    tipoelem info;
    struct celda *izq, *der;
};

//////////////////////// FUNCIONES


/*Extraer la clave de una celda */
tipoclave _clave_elem(tipoelem *E) {
    return E->lex;
}

/* Esta funcion puente nos permite modificar el tipo de
 * de datos del TAD sin tener que cambiar todas las 
 * comparaciones del resto de la biblioteca y en su lugar
 * cambiando solo esta. */
int _comparar_claves(tipoclave cl1, tipoclave cl2) {
    return (strcmp(cl1, cl2) == 0 ? 0 : strcmp(cl1, cl2) > 0 ? 1 : -1);
}





//OPERACIONES DE CREACIÓN Y DESTRUCCIÓN

void crear(abb *A) {
    *A = NULL;
}

void destruir(abb *A) {
    if (*A != NULL) {
        printf("Entramos a destruir %s\n", (*A)->info.lex);
        destruir(&(*A)->izq);
        destruir(&(*A)->der);
        free((*A)->info.lex);
        if ((*A)->info.lex_comp == LIBRARY) {
            dlclose((*A)->info.value.lib);
        }
        free(*A);
        *A = NULL;
    }
}






//OPERACIONES DE INFORMACIÓN

unsigned es_vacio(abb A) {
    return A == NULL;
}

abb izq(abb A) {
    return A->izq;
}

abb der(abb A) {
    return A->der;
}

void leer(abb A, tipoelem *E) {
    *E = A->info;
}
// Función privada para comparar las claves

int _comparar_clave_elem(tipoclave cl, tipoelem E) {
    return _comparar_claves(cl, _clave_elem(&E));
}
//Función privada para informar si una clave está en el árbol

unsigned _es_miembro_clave(abb A, tipoclave cl) {
    if (es_vacio(A)) {
        return 0;
    }
    int comp = _comparar_clave_elem(cl, A->info);

    if (comp == 0) { //cl == A->info
        return 1;
    }
    if (comp > 0) { //cl > A->info
        return _es_miembro_clave(der(A), cl);
    }
    //cl < A->info
    return _es_miembro_clave(izq(A), cl);
}

//Funciones públicas

unsigned es_miembro(abb A, tipoelem E) {
    return _es_miembro_clave(A, _clave_elem(&E));
}

void buscar_nodo(abb A, tipoclave cl, tipoelem *nodo) {
    if (es_vacio(A)) {
        return;
    }
    int comp = _comparar_clave_elem(cl, A->info);

    if (comp == 0) { // cl == A->info
        *nodo = A->info;
    } else if (comp < 0) { // cl < A->info
        buscar_nodo(A->izq, cl, nodo);
    } else { // cl > A->info
        buscar_nodo(A->der, cl, nodo);
    }
}

void print(abb A){
    tipoelem aux;
    if (!es_vacio(A)){
        print(A->izq);

        leer(A, &aux);

        if (aux.lex_comp == CONSTANT){
            printf("╠════════════╬════════════╬═══════════╣\n");
            printf("║  CONSTANT  ║ %-10s ║ %.7lf ║\n", aux.lex, aux.value.variable);
        } else if (aux.lex_comp == VARIABLE){
            printf("╠════════════╬════════════╬═══════════╣\n");
            printf("║  VARIABLE  ║ %-10s ║ %-9g ║\n", aux.lex, aux.value.variable);
        } else if (aux.lex_comp == FUNCTION){
            printf("╠════════════╬════════════╬═══════════╣\n");
            printf("║  FUNCTION  ║ %-10s ║ NOT VALUE ║\n", aux.lex);
        } else if (aux.lex_comp == COMMAND1 || aux.lex_comp == COMMAND2){
            printf("╠════════════╬════════════╬═══════════╣\n");
            printf("║  COMMAND   ║ %-10s ║ NOT VALUE ║\n", aux.lex);
        } else if (aux.lex_comp == LIBRARY){
            printf("╠════════════╬════════════╬═══════════╣\n");
            printf("║  LIBRARY   ║ %-10s ║ NOT VALUE ║\n", aux.lex);
        }

        print(A->der);
    }
}

void print_ws(abb A){
    tipoelem aux;
    if (!es_vacio(A)){
        print_ws(A->izq);

        leer(A, &aux);

        if (aux.lex_comp == VARIABLE){
            printf("╠════════════╬════════════╬═══════════╣\n");
            printf("║  VARIABLE  ║ %-10s ║ %-9g ║\n", aux.lex, aux.value.variable);
        }
        print_ws(A->der);
    }
}



//OPERACIONES DE MODIFICACIÓN

/* Funcion recursiva para insertar un nuevo nodo 
   en el arbol. Se presupone que no existe un nodo
   con la misma clave en el arbol. */
void insertar(abb *A, tipoelem E) {
    if (es_vacio(*A)) {
        *A = (abb) malloc(sizeof (struct celda));
        (*A)->info.lex_comp = E.lex_comp;
        (*A)->info.lex = strdup(E.lex);
        (*A)->info.value = E.value;
        (*A)->izq = NULL;
        (*A)->der = NULL;
        return;
    }
    tipoclave cl = _clave_elem(&E);
    int comp = _comparar_clave_elem(cl, (*A)->info);
    if (comp > 0) {
        insertar(&(*A)->der, E);
    } else {
        insertar(&(*A)->izq, E);
    }
}
/* Funcion privada que devuelve mínimo de subárbol dcho */
tipoelem _suprimir_min(abb * A) {//Se devuelve el elemento más a la izquierda
    abb aux;
    tipoelem ele;
    if (es_vacio((*A)->izq)) {//Si izquierda vacía, se devuelve valor nodo actual A
        ele = (*A)->info;
        aux = *A;
        *A = (*A)->der;
        free(aux);
        return ele;
    } else {
        return _suprimir_min(&(*A)->izq); //se vuelve a buscar mínimo rama izquierda
    }
}

/* Funcion que permite eliminar un nodo del arbol */
void suprimir(abb *A, tipoelem E) {
    abb aux;
    if (es_vacio(*A)) {
        return;
    }

    tipoclave cl = _clave_elem(&E);
    int comp = _comparar_clave_elem(cl, (*A)->info);
    if (comp < 0) { //if (E < (*A)->info) {
        suprimir(&(*A)->izq, E);
    } else if (comp > 0) { //(E > (*A)->info) {
        suprimir(&(*A)->der, E);
    } else if (es_vacio((*A)->izq) && es_vacio((*A)->der)) {
        free(*A);
        *A = NULL;
    } else if (es_vacio((*A)->izq)) { // pero no es vacio derecha
        aux = *A;
        *A = (*A)->der;
        free(aux);
    } else if (es_vacio((*A)->der)) { //pero no es vacio izquierda
        aux = *A;
        *A = (*A)->izq;
        free(aux);
    } else { //ni derecha ni izquierda esta vacio, busco mínimo subárbol derecho
        //pues en su sitio voy a poner el mínimo del subárbol derecho
        (*A)->info = _suprimir_min(&(*A)->der);
    }
}

/* Funcion privada para pasar la clave y no tener que
   extraerla del nodo en las llamadas recursivas.*/
void _modificar(abb A, tipoclave cl, tipoelem nodo) {
    if (es_vacio(A)) {
        return;
    }
    int comp = _comparar_clave_elem(cl, A->info);
    if (comp == 0) {
        A->info = nodo;
    } else if (comp < 0) {
        _modificar(A->izq, cl, nodo);
    } else {
        _modificar(A->der, cl, nodo);
    }
}


/* Permite modificar el nodo extrayendo del mismo la clave */
void modificar(abb A, tipoelem nodo) {
    tipoclave cl = _clave_elem(&nodo);
    _modificar(A, cl, nodo);
}

void reset_ws(abb A){
    tipoelem aux;
    if (!es_vacio(A)){
        reset_ws(A->izq);

        leer(A, &aux);

        reset_ws(A->der);

        if (aux.lex_comp == VARIABLE){
            suprimir(&A, aux);
        }
    }
}
