#include "distribucion.h"

/* Reparto ciclico (actividad 10): cada proceso prueba rank, rank+size,
 * rank+2*size, ... en vez de un bloque contiguo. Si la llave real cae en
 * cualquier punto del espacio, el proceso que la encuentra la visita en
 * promedio tras pocas iteraciones, sin importar su valor absoluto. */
void calcularRango(int rank, int size, long long totalKeys, long long *inicio, long long *fin, long long *paso)
{
    *inicio = rank;
    *fin = totalKeys;
    *paso = size;
}
