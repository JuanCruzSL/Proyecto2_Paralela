#include "distribucion.h"

/* Reparto por bloque contiguo (version original, solo para comparar contra
 * el reparto ciclico en las pruebas de la actividad 10). */
void calcularRango(int rank, int size, long long totalKeys, long long *inicio, long long *fin, long long *paso)
{
    long long porProceso = totalKeys / size;
    *inicio = rank * porProceso;
    *fin = (rank == size - 1) ? totalKeys : *inicio + porProceso;
    *paso = 1;
}
