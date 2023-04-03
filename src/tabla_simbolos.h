
#ifndef DCOMPILER_TABLA_SIMBOLOS_H
#define DCOMPILER_TABLA_SIMBOLOS_H

#include "definiciones.h"

/**
 * Busca un elemento en la tabla de simbolos.
 *  Si el elemento existe, se devuelve su valor.
 *  Si no existe, se inserta en la tabla y se devuelve su valor.
 * @param elem -> Elemento a buscar
 */
void table_search(tipoelem * elem);

/**
 * Inicializa la tabla de simbolos a los simbolos iniciales
 */
void table_create();

/**
 * Destruye la tabla y libera la memoria
 */
void table_free();

/**
 * Muestra la tabla por pantalla
 */
void table_print();

#endif //DCOMPILER_TABLA_SIMBOLOS_H
