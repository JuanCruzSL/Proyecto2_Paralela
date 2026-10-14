#!/bin/bash
# medir.sh - Corre N repeticiones de un binario de fuerza bruta MPI con
# distintas cantidades de procesos, usa el secuencial como base, y calcula
# tiempo promedio, speedup y eficiencia. Guarda todo en CSV (act. 9/10/11).
#
# Uso: ./medir.sh <binarioMpi> <cifrado.bin> <palabraClave> <bitsEspacio> <repeticiones> <procesos...>
# Ejemplo: ./medir.sh ./bruteforce_mpi prueba.bin secreta 24 5 1 2 4 8
#
# Para comparar naive vs mejorado (act. 10), correr dos veces con el mismo
# cifrado/llave y distinto binario (./bruteforce_mpi y ./bruteforce_mpi_naive),
# cambiando el nombre de los CSV de salida entre corridas.

set -euo pipefail

if [ "$#" -lt 6 ]; then
    echo "Uso: $0 <binarioMpi> <cifrado.bin> <palabraClave> <bitsEspacio> <repeticiones> <procesos...>" >&2
    exit 1
fi

binario="$1"; cifrado="$2"; palabraClave="$3"; bitsEspacio="$4"; repeticiones="$5"
shift 5
procesos=("$@")

csvMediciones="mediciones.csv"
csvResumen="resumen.csv"
echo "binario,procesos,repeticion,tiempo_s" > "$csvMediciones"
echo "binario,procesos,tiempo_prom_s,speedup,eficiencia" > "$csvResumen"

extraerTiempo() {
    grep -oE 'Tiempo: [0-9.]+' | awk '{print $2}'
}

echo "Midiendo secuencial (baseline, $repeticiones repeticiones)..."
tiempoSecTotal=0
for ((i = 1; i <= repeticiones; i++)); do
    t=$(./secuencial "$cifrado" "$palabraClave" "$bitsEspacio" | extraerTiempo)
    echo "secuencial,1,$i,$t" >> "$csvMediciones"
    tiempoSecTotal=$(echo "$tiempoSecTotal + $t" | bc -l)
done
tiempoSecProm=$(echo "$tiempoSecTotal / $repeticiones" | bc -l)
echo "secuencial,1,$tiempoSecProm,1,1" >> "$csvResumen"
echo "  secuencial: ${tiempoSecProm}s"

for p in "${procesos[@]}"; do
    echo "Midiendo $binario con $p proceso(s), $repeticiones repeticiones..."
    tiempoTotal=0
    for ((i = 1; i <= repeticiones; i++)); do
        t=$(mpirun --oversubscribe -np "$p" "$binario" "$cifrado" "$palabraClave" "$bitsEspacio" | extraerTiempo)
        echo "$(basename "$binario"),$p,$i,$t" >> "$csvMediciones"
        tiempoTotal=$(echo "$tiempoTotal + $t" | bc -l)
    done
    tiempoProm=$(echo "$tiempoTotal / $repeticiones" | bc -l)
    speedup=$(echo "$tiempoSecProm / $tiempoProm" | bc -l)
    eficiencia=$(echo "$speedup / $p" | bc -l)
    echo "$(basename "$binario"),$p,$tiempoProm,$speedup,$eficiencia" >> "$csvResumen"
    echo "  procesos=$p tiempo_prom=${tiempoProm}s speedup=${speedup} eficiencia=${eficiencia}"
done

echo "Listo: $csvMediciones y $csvResumen"
