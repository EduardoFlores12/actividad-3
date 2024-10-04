    ORG 0000h
    LD SP, 4000h
    CALL INICIO            ; Llamada a la rutina de inicio

INICIO:
    CALL IMPRIMIR_TEXTO
    DB 'Iniciando la generacion de numeros...', 0

    ; Generar los 20 números pseudoaleatorios
    CALL GENERAR_NUMEROS

    ; Mostrar los números generados
    CALL IMPRIMIR_TEXTO
    DB 'Numeros generados: ', 0
    CALL MOSTRAR_NUMEROS_GENERADOS

    ; Preguntar cómo se desea ordenar
    CALL IMPRIMIR_TEXTO
    DB 'Orden Ascendente (A) o Descendente (D)?', 0
    CALL OBTENER_RESPUESTA

    ; Ordenar los números según la selección
    CP 'A'                ; Comparar si es 'A'
    CALL Z, ORDENAR_ASC
    CP 'D'                ; Comparar si es 'D'
    CALL Z, ORDENAR_DESC

    ; Mostrar números ordenados
    CALL IMPRIMIR_TEXTO
    DB 'Numeros ordenados: ', 0
    CALL MOSTRAR_NUMEROS_ORDENADOS

    ; Preguntar si desea continuar o salir
    CALL IMPRIMIR_TEXTO
    DB '¿Desea repetir el programa (S/N)?', 0
    CALL OBTENER_RESPUESTA
    CP 'S'
    JP Z, INICIO

    CALL IMPRIMIR_TEXTO
    DB 'Saliendo del programa...', 0
    JP FIN

FIN:
    JP FIN                ; Bucle infinito para detener el programa

; --- Rutina para generar los 20 números pseudoaleatorios ---
GENERAR_NUMEROS:
    LD HL, 8000h          ; Dirección en memoria para guardar los números
    LD B, 20              ; Vamos a generar 20 números
GENERAR_BUCLE:
    LD A, R               ; Utilizar el registro R para obtener un valor aleatorio
    AND 0FFh              ; Asegurar que el número esté en el rango de 1 byte
    LD (HL), A            ; Guardar el número en memoria
    INC HL                ; Siguiente posición en memoria
    DJNZ GENERAR_BUCLE    ; Repetir hasta que se generen 20 números
    RET

MOSTRAR_NUMEROS_GENERADOS:
    LD HL, 8000h          ; Dirección de los números generados
    LD B, 20              ; 20 números por mostrar
MOSTRAR_GENERADOS_BUCLE:
    LD A, (HL)            ; Cargar un número
    CALL MOSTRAR_DECIMAL  ; Mostrar el número en decimal
    CALL IMPRIMIR_ESPACIO ; Agregar un espacio
    INC HL                ; Avanzar al siguiente número
    DJNZ MOSTRAR_GENERADOS_BUCLE
    RET

; --- mostrar los números ordenados ---
MOSTRAR_NUMEROS_ORDENADOS:
    LD HL, 9000h          ; Dirección de los números ya ordenados
    LD B, 20
MOSTRAR_ORDENADOS_BUCLE:
    LD A, (HL)            ; Cargar un número
    CALL MOSTRAR_DECIMAL
    CALL IMPRIMIR_ESPACIO
    INC HL                ; Siguiente número
    DJNZ MOSTRAR_ORDENADOS_BUCLE
    RET

ORDENAR_ASC:
    CALL ORDENAR_BURBUJA_ASC
    RET

ORDENAR_DESC:
    CALL ORDENAR_BURBUJA_DESC
    RET

ORDENAR_BURBUJA_ASC:
    ; Algoritmo de burbuja para ordenar de forma ascendente
    LD BC, 20             ; 20 números
BURBUJA_ASC_OUTER:
    LD HL, 8000h
    LD A, C
    DEC A
    LD C, A
    JR Z, FIN_BURBUJA_ASC ; Fin del ordenamiento
BURBUJA_ASC_INNER:
    LD A, (HL)
    INC HL
    CP (HL)
    JR NC, NO_SWAP_ASC    ; Si ya está en orden, no intercambiar
    LD A, (HL)
    DEC HL
    LD (HL), A
    INC HL
    DEC HL
    LD A, (HL)
    INC HL
    LD (HL), A
NO_SWAP_ASC:
    INC HL
    DJNZ BURBUJA_ASC_INNER
    JR BURBUJA_ASC_OUTER
FIN_BURBUJA_ASC:
    RET

ORDENAR_BURBUJA_DESC:
    ; Algoritmo de burbuja para ordenar de forma descendente
    LD BC, 20             ; 20 números
BURBUJA_DESC_OUTER:
    LD HL, 8000h
    LD A, C
    DEC A
    LD C, A
    JR Z, FIN_BURBUJA_DESC
BURBUJA_DESC_INNER:
    LD A, (HL)
    INC HL
    CP (HL)
    JR C, NO_SWAP_DESC
    LD A, (HL)
    DEC HL
    LD (HL), A
    INC HL
    DEC HL
    LD A, (HL)
    INC HL
    LD (HL), A
NO_SWAP_DESC:
    INC HL
    DJNZ BURBUJA_DESC_INNER
    JR BURBUJA_DESC_OUTER
FIN_BURBUJA_DESC:
    RET

OBTENER_RESPUESTA:
    IN A, (0)
    CP 0DH                ; Comparar con ENTER (0x0D en ASCII)
    RET Z                 ; Si es ENTER, retornar
    RET

IMPRIMIR_TEXTO:
    LD A, (HL)            ; Cargar el siguiente carácter
    CP 0
    RET Z                 ; Si es 0, retornar
    OUT (1), A
    INC HL                ; Siguiente carácter
    JR IMPRIMIR_TEXTO     ; Repetir
    RET

MOSTRAR_DECIMAL:
    PUSH AF               ; Guardar el registro A
    CALL DIVIDE_BY_TEN     ; Convertir a decimal
    POP AF                ; Restaurar el registro A
    RET


IMPRIMIR_ESPACIO:
    LD A, ' '             ; Cargar el carácter de espacio
    OUT (1), A            ; Enviar a la pantalla
    RET

DIVIDE_BY_TEN:

    RET
