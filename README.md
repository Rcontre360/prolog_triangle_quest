# prolog_triangle_quest

- Movimientos
    
    En la estructura triangular que has proporcionado, cada número (excepto los que están en los bordes) está rodeado por otros seis. Para un número dado en la posición `x`, puedes calcular las posiciones de los números que lo rodean si conoces el número de la fila `r` en la que se encuentra `x`. Primero, encuentras `r` de tal manera que \( r(r+1)/2 < x \leq (r+1)(r+2)/2 \).
    
    Una vez que tienes `r`, las posiciones de los números alrededor de `x` en la fila `r` se pueden encontrar usando las siguientes fórmulas:
    
    - **Arriba a la Izquierda**: `x - r`
    - **Arriba a la Derecha**: `x - r + 1`
    - **Izquierda**: `x - 1`
    - **Derecha**: `x + 1`
    - **Abajo a la Izquierda**: `x + r`
    - **Abajo a la Derecha**: `x + r + 1`
    
    Por ejemplo, para el número 5 que está en la fila 3, los números alrededor serían 2, 3, 4, 6, 8 y 9. Ten en cuenta que para los números en los bordes del triángulo, algunos de estos cálculos no serán válidos ya que no habrá un elemento en uno de los lados. Deberás agregar comprobaciones para asegurarte de que los índices que estás calculando no se salgan de los límites de la estructura del triángulo.
    
- Validaciones
    
    En cada paso de la solucion se debe revisar lo siguiente para confirmar que existe una solucion.
    
    - Calcular todos los “vecinos” validos usando la formula de arriba
        - Se tiene que chequear el vecino actual (no vacio), y el vecino del vecino (vacio)
        - Se tiene que chequear que no se salga del triangulo (al moverse arriba siempre debemos encontrarnos en el “nivel” i-1, lo mismo con las demas direcciones).
    - Por cada vecino verificar si ese camino lleva a una solucion valida.
        - Las matrices se pasaran por parámetro (copia) para lograr el “backtrack”.
    - Si se encuentra solución se informa. Sino termina.
- Predicados:
    - Nuestros:
        - Inicializadores:
            - triangleLevel([])
            - puzzle ([]) 
        - isLevelDifference(Cur, Nxt, Diff): Este predicado se encargará de calcular la diferencia entre dos números de Niveles
        - isValidMove(Cur, Nxt, Puzzle): Valida si un movimiento puede hacerse
        - isIntermediate(Cur, Nxt, Inter) Valida si un elemento es Intermedio cuando movemos una pieza Desde (From) A Hasta (To) B.Si eliminamos C cuando hacemos un movimiento esta función retornará el número de C
        - isValidTransition(Puzzle,NxtPuzzle, From, To): Chequea que si dado un elemento y un Puzzle el NxtPuzzle (Siguiente Puzzle) sea correctamente creado.
        - modifyAtIndex([], X, Y, []): Dado un índice 'X' se modificará el valor dentro del mismo por el valor sumistrado en la entrara 'Y'.
        - makeAllMoves(Puzzle, [], []) Predicado auxiliar para hacer todos los movimientos posibles dado un arreglo de movimientos.
        - (): Muestra el tablero
        - (): Muestra cada nivel
        - (): Muesrta los espacios en blanco entre casillas y niveles
    - Problema:
        - resolver(X): Calcular la secuencia de movimientos necesarias para que quede sólo una ficha en el tablero a partir de
        una configuración inicial.
        - jugar(X): Permitir que el usuario resuelva interactivamente el juego.
        - Para jugar también redefiniremos el preficado como jugar((From,To)) esto debido a que el predicado principalmente planteado no nos especifica nada de cómo movernos, hacia donde ir, y en qué direccióm.
          Por ello decidimos redefinirlo tomando en cuenta que recibe una tupla con dos valores (From, To) donde From, indicará desde qué casilla el jugador se moverá, y 'To' indicará hacia qué casilla desea moverse.
    - De PROLOG:
        - nth1/3: es un predicado que se utiliza para acceder al enésimo elemento de una lista.
        - length/2: este predicado se utiliza para verificar o determinar la longitud de una lista.
        - write/1: predicado para imprimir por consola
- Estructuras de datos
    
    Usaremos 2 arreglos para este problema. El primero tendra 15 elementos y sera de la siguiente forma: 
    
    [ 1, 2, 2, 3, 3, 3, 4, 4, 4, 4…] Este guarda el “nivel” en el que se encuentra un elemento dado. Se usará para hacer las validaciones durante el movimiento.
    
    Además se usará un arreglo de booleanos para determinar si nos encontramos con o sin un elemento en una casilla dada.
