#ifndef DISTRIBUCION_H
#define DISTRIBUCION_H

/* Calcula el recorrido de llaves de un proceso: prueba inicio, inicio+paso,
 * inicio+2*paso, ... mientras sea menor que fin. paso=1 da un bloque
 * contiguo; paso=size da reparto ciclico (entrelazado entre procesos). */
void calcularRango(int rank, int size, long long totalKeys, long long *inicio, long long *fin, long long *paso);

#endif
