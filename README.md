# Laboratorio: Aritmética de Precisión Múltiple, Ajuste BCD y Mini Calculadora

* **Estudiante:** Juan Carlos Barajas Quintero 
* **Curso:** Arquitectura de Computadores - Unidad 8
* **Institución:** Universidad Francisco de Paula Santander

## Descripción del Proyecto
Este laboratorio implementa en **NASM** bajo el entorno **DOSBox** diversas operaciones aritméticas avanzadas de 32 bits y el manejo de datos en formato decimal. El objetivo es demostrar el dominio de las instrucciones de acarreo, el ajuste de resultados para representación humana (BCD) y la interacción básica con el usuario mediante una calculadora funcional.

### Entorno de Trabajo
Para el cumplimiento de los objetivos, se utilizó el siguiente software y versiones:
*   **Emulador:** DOSBox 0.74+.
*   **Ensamblador:** NASM versión 2.14+.
*   **Control de Versiones:** Git para la gestión del repositorio.
*   **Editor de Texto:** VS code para la escritura de los archivos .asm.

## Aritmética de Precisión Múltiple (32 bits)
Dado que en modo real de 16 bits los registros tienen un límite de capacidad, las operaciones de 32 bits se procesan utilizando pares de registros (como **DX:AX**).

*   **Propagación del Acarreo (Carry/Borrow):** El bit de acarreo (**CF**) es la pieza clave para conectar las operaciones entre la parte baja y la parte alta de los números.
*   **Suma de 32 bits:** Se realiza primero una suma normal con `ADD` en las partes bajas. Si se genera un exceso, el bit CF se activa y es sumado automáticamente a la parte alta mediante la instrucción **`ADC`** (Add with Carry).
*   **Resta de 32 bits:** Funciona de manera análoga; se usa `SUB` para las partes bajas y **`SBB`** (Subtract with Borrow) para las partes altas, restando el bit de préstamo si la operación inicial lo requirió.

## Proceso de Ajuste BCD Empaquetado
El formato **BCD empaquetado** almacena dos dígitos decimales en un solo byte (un dígito por cada nibble). Las operaciones binarias estándar suelen dejar resultados que no son válidos en este formato, por lo que se aplican ajustes post-operación:

*   **DAA (Decimal Adjust after Addition):** Tras una suma, esta instrucción verifica el nibble bajo y el flag AF para corregir el registro AL, sumando 6 si es necesario para mantener el resultado dentro del rango decimal (0-9 por dígito).
*   **DAS (Decimal Adjust after Subtraction):** Realiza el ajuste tras una resta binaria, asegurando que el resultado se mantenga como un valor BCD válido, incluso corrigiendo el nibble bajo si la resta produjo un valor mayor a 9.

## Lógica de la Mini Calculadora
La calculadora está diseñada para operar con enteros de un solo dígito ingresados por el usuario.

1.  **Entrada de Datos:** Se capturan los operandos desde el teclado usando la interrupción `INT 21h / AH=01h`.
2.  **Conversión ASCII a Binario:** Los caracteres ingresados se convierten a valores numéricos restándoles **30h**.
3.  **Procesamiento:** 
    *   Para la **multiplicación**, se utiliza la instrucción `MUL`, almacenando el producto en el registro AX.
    *   Para la **división**, se emplea `DIV`, verificando previamente que el divisor no sea cero para evitar errores del sistema.
4.  **Salida y Conversión:** El resultado binario final se procesa mediante una subrutina (`imprimirAX`) que utiliza divisiones sucesivas entre 10 para extraer cada dígito decimal, les suma **30h** para volver al formato ASCII y los muestra en pantalla.

## Instrucciones de Compilación y Ejecución
Para compilar y ejecutar cualquiera de los módulos, utilice los siguientes comandos en la consola de DOSBox:

```bash
nasm -f bin nombre_archivo.asm -o nombre_archivo.com (En consola del host)
nombre_archivo.com (En DOSBox)
```
