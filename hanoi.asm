# Torres de Hanoi
#Integrantes: 	Emiliano Arroyo Valencia	|	Jose Emiliano Figueroa Hernandez


.text
main:
	addi a0, zero, 0	#inicializar contador de movimientos a 0
	addi a1, zero, 1	#definir una constante 1 para comparaciones y operaciones
	addi s0, zero, 3	#inicializar el número de discos a 3
	
	jal inicio		#iniciar los arreglos y sus contenidos
	jal hanoi		#llamar a la función principal para resolver las torres de hanoi
	jal exit		#salir del programa

hanoi:
	beq s0, a1, casoBase	#si solo hay 1 disco, ir al caso base
	
	#guardar el contexto actual en el stack antes de la recursión
	addi sp, sp, -20	#ajustar el puntero del stack para almacenar 5 registros
	sw s0, 16(sp)		#guardar el número de discos
	sw s1, 12(sp)		#guardar la dirección de source
	sw s2, 8(sp)		#guardar la dirección de auxiliary
	sw s3, 4(sp)		#guardar la dirección de destination
	sw ra, 0(sp)		#guardar la dirección de retorno

	#preparar los argumentos para la primera llamada recursiva
	addi s0, s0, -1		#disminuir el número de discos en 1
	addi t2, s2, 0		#almacenar el valor actual de auxiliary en t2
	addi s2, s3, 0		#asignar el valor de destination a auxiliary
	addi s3, t2, 0		#asignar el valor almacenado en t2 a destination
	addi t2, zero, 0	#temp = null
	
	jal hanoi		#primera llamada recursiva
	
	#restaurar el contexto desde el stack después de la recursión
	lw ra, 0(sp)		#recuperar la dirección de retorno
	lw s3, 4(sp)		#recuperar la dirección de destination
	lw s2, 8(sp)		#recuperar la dirección de auxiliary
	lw s1, 12(sp)		#recuperar la dirección de source
	lw s0, 16(sp)		#recuperar el número de discos
	sw zero, 0(sp)		#limpiar direccion de retorno guardada en stack
	sw zero, 4(sp)		#limpiar dest guardado en stack
	sw zero, 8(sp)		#limpiar aux guardado en stack
	sw zero, 12(sp)		#limpiar source guardado en stack
	sw zero, 16(sp)		#limpiar numero de discos guardado en stack
	addi sp, sp, 20		#restaurar el puntero del stack

	#mover el disco de source a destination
	addi t6, ra, 0		#almacenar temporalmente la dirección de retorno
	jal moverDisco		#llamar a la función para mover el disco
	addi ra, t6, 0		#restaurar la dirección de retorno desde t6
	addi t6, zero, 0	#temp = 0
	
	#guardar el contexto en el stack antes de la segunda llamada recursiva
	addi sp, sp, -20	#ajustar el puntero del stack para almacenar 5 registros
	sw s0, 16(sp)		#guardar el número de discos
	sw s1, 12(sp)		#guardar la dirección de source
	sw s2, 8(sp)		#guardar la dirección de auxiliary
	sw s3, 4(sp)		#guardar la dirección de destination
	sw ra, 0(sp)		#guardar la dirección de retorno

	#preparar los argumentos para la segunda llamada recursiva
	addi s0, s0, -1		#disminuir el número de discos en 1
	addi t2, s1, 0		#almacenar el valor actual de source en t2
	addi s1, s2, 0		#asignar el valor de auxiliary a source
	addi s2, t2, 0		#asignar el valor almacenado en t2 a auxiliary
	addi t2, zero, 0	#temp = null
	jal hanoi		#segunda llamada recursiva

	#restaurar el contexto desde el stack después de la recursión
	lw ra, 0(sp)		#recuperar la dirección de retorno
	lw s3, 4(sp)		#recuperar la dirección de destination
	lw s2, 8(sp)		#recuperar la dirección de auxiliary
	lw s1, 12(sp)		#recuperar la dirección de source
	lw s0, 16(sp)		#recuperar el número de discos
	sw zero, 0(sp)		#limpiar direccion de retorno guardada en stack
	sw zero, 4(sp)		#limpiar dest guardado en stack
	sw zero, 8(sp)		#limpiar aux guardado en stack
	sw zero, 12(sp)		#limpiar source guardado en stack
	sw zero, 16(sp)		#limpiar numero de discos guardado en stack
	addi sp, sp, 20		#restaurar el puntero del stack

	jalr ra			#regresar al llamador

casoBase:	
	#caso base para mover el disco de source a destination cuando n=1
	addi t6, ra, 0		#almacenar temporalmente la dirección de retorno
	jal moverDisco		#llamar a la función para mover el disco
	addi ra, t6, 0		#restaurar la dirección de retorno desde t6
	addi t6, zero, 0	#temp = 0
	
	jalr ra			#regresar al llamador

moverDisco:	#función para mover el disco superior de source a destination

	#manipulación de la pila source
	lw t4, (s1)		#leer el tamaño de source
	slli t5, t4, 2		#convertir el tamaño a bytes (x4 ya que cada entero tiene 4 bytes)
	add s1, s1, t5		#acceder al elemento superior de source
	lw t3, (s1)		#leer el disco superior de source
	sw zero, (s1)		#limpiar el elemento superior de source
	sub s1, s1, t5		#volver al inicio de source
	addi t4, t4, -1		#disminuir el tamaño de source
	sw t4, (s1)		#actualizar el tamaño de source

	#manipulación de la pila destination
	lw t4, (s3)		#leer el tamaño de destination
	addi t4, t4, 1		#aumentar el tamaño de destination
	slli t5, t4, 2		#convertir el tamaño a bytes (x4 ya que cada entero tiene 4 bytes)
	add s3, s3, t5		#acceder al nuevo elemento superior de destination
	sw t3, (s3)		#copiar el disco a destination
	sub s3, s3, t5		#volver al inicio de destination
	sw t4, (s3)		#actualizar el tamaño de destination

	#reinicio de registros temporales
	addi t3, zero, 0	#restablecer el registro t3 a 0 (limpiar el disco temporal)
	addi t4, zero, 0	#restablecer el registro t4 a 0 (limpiar el tamaño temporal)
	addi t5, zero, 0	#restablecer el registro t5 a 0 (limpiar el cálculo de bytes temporal)
	addi a0, a0, 1		#aumentar el contador de movimientos en 1
	jalr ra			#regresar al llamador

inicio:
	addi t1, s0, 1		#incrementa el número de discos por 1 para contar el espacio adicional de tamaño en el arreglo.
	slli t2, t1, 2		#multiplica el tamaño (t1) por 4 para convertirlo a bytes, ya que cada entero tiene 4 bytes en RISC-V.

	lui s1, 0x10010		#carga la dirección de inicio de RAM (StartRAM) en s1, que actuará como la fuente.
	add s2, s1, t2		#establece el inicio de la torre auxiliar (s2) después de la fuente, usando la cantidad de bytes calculada.
	add s3, s2, t2		#establece el inicio de la torre de destino (s3) después de la auxiliar, usando la misma cantidad de bytes.

	addi t3, s1, 0		#inicializa t3 con la dirección de inicio de la fuente.
	addi t1, t1, -1		#decrementa t1 por 1 para establecer el tamaño del arreglo en la fuente.
	sw t1, (t3)		#almacena el tamaño en la primera posición de la fuente.
	addi t3, t3, 4		#avanza a la siguiente posición en el arreglo.

bucleInicio:
	beq t1, zero, limpiar	#si t1 (N) es 0, termina el loop. Es decir, cuando todos los discos hayan sido inicializados, termina el setup.
	sw t1, (t3)		#almacena el valor actual de t1 (N) en la posición actual de la fuente.
	addi t3, t3, 4		#avanza a la siguiente posición en el arreglo.
	addi t1, t1, -1		#decrementa t1 (N) por 1.
	jal x0, bucleInicio	#regresa al inicio del loop para continuar la inicialización.

limpiar:
	addi t1, zero, 0	#limpia el registro t1, estableciéndolo a 0.
	addi t2, zero, 0	#limpia el registro t2, estableciéndolo a 0.
	addi t3, zero, 0	#limpia el registro t3, estableciéndolo a 0.
	
	jalr ra			#regresa al código que llamó a la función setup.

exit:
	nop			#no operation: Una instrucción que no hace nada. 