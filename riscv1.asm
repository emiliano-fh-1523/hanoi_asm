# Declaración de variables globales
.data

# Declaración de funciones
.text

# Función principal
main:
    # Llamar a hanoi con n=3, source='A', destination='C', auxiliary='B'
    li a0, 3
    li a1, 'A'
    li a2, 'C'
    li a3, 'B'
    jal hanoi

    # Salir del programa
    li a0, 10       # Código de salida
    ecall

# Función para mover el disco desde el poste source al poste destination
hanoi:
    # Argumentos:
    # a0: n
    # a1: source
    # a2: destination
    # a3: auxiliary
    
    # Comprobar si n es igual a 0
    beqz a0, end_hanoi

    # Llamada recursiva para mover n-1 discos de source a auxiliary usando destination como auxiliar
    # Swap auxiliary y destination como postes auxiliares
    mv a4, a3
    mv a3, a2
    mv a2, a4
    addi a0, a0, -1
    jal hanoi

    # Llamada recursiva para mover n-1 discos de auxiliary a destination usando source como auxiliar
    # Swap source y auxiliary como postes auxiliares
    mv a4, a1
    mv a1, a3
    mv a3, a4
    addi a0, a0, -1
    jal hanoi

end_hanoi:
    nop

