Descripción
-----------

Unidad de Punto Flotante(FPU) es un circuito que permite sumar, restar, multiplicar números de 32 bits acordes al estándar IEEE. 

Compilación
-----------

Para al compilación se requiere GHDL, y se realiza mediante el comando:

$make

Para limiar los archivos generados:

$make clean

Ejecución
---------

Se ejecuta y se muestra mediante gtkwave. Esto se realiza mediante el comando:

$make run

Señales
-------

busa - Entrada del bus A de 32 bits
busb - Entrada del bus B de 32 bits
busc - Salida al bus C de 32 bits
inst - Entrada con el número de operación de 4 bits: 0000 para suma y 0001 para multiplicación

Las señales manti, oe, om y os son señales de debug, y representan los valores internos de la mantiza, el exponente el signo de la suma. 
