# Mineria de datos

## Nociones básicas Datamining

Tecnologias de base de datos
* database managment systems
* advance database systems
* advance data analytics

**Datamining concepto**
* extracción de patrones interesantes o conocimiento a partir de grandes cantidad de datos
    * patrones interesantes
        * no triviales
        * implícitos
        * previamente desconocidos
        * potencialmente útiles
* incorpora técnicos de otros dominios (interdiciplicanria)
    * estadística, db, patter recognition, ML, IR, datawarehouse, HPC, etc
    
**KDD**
Paso escencial es datamining, es un procesos interactivo e iterativo. Los pasos son:
1. entender dominio y objetivo
2. selección de datos
3. preprocesamiento
4. transformación de los datos
5. selección del método de data mining
    * tarea
    * algoritmo
    * utilización
6. evaluación e interpretación
7. **conocimiento descubierto**

### Entender el dominio
* donde aplicar KDD
* que problema se está intentando resolver
* cuales son los objetivos

### Selección de datos
* que datos están disponibles
* obtener datos adicionales
* integrar todos los datos

### Preprocesamiento y limpieza
* mejorar la fiabilidad de los datos
* manejo de datos faltantes
* eliminación de datos ruidosos o valores atípicos
    * no todo es ruidio OJO

### Transformación
* reducción de la dimensionalidad: PCA
* suavizados: discretización
* agregación: group by
* generalización: datos de bajo nivel reemplzados por datos de alto nivel
* normalización: escalado de atributos
* contrucción de atributos: nuevas variables

### Selección del método
* aplicación de los métodos inteligentes para extracción de patrones
* los métodos pueden ser:
    * estimación: aproximación a variable numérica como target
    * predicción: pronosticar valores futuros de una variable
    * clasificación: variable categórica como target
    * clustering: agrupamiento de registros
    * asociación: buscar atributos que van juntos

**Selección del algoritmo**
* metalearning: como trabaja
* cada algoritmo tiene:
    * parametros
    * tácticas de aprendizaje
* decidir entre precisión vs capacidad de explicar

**Utilización del algoritmo**
* se ejecuta muchas veces hasta obtener resultados
* en cada ejecución se hacen ajustes

### Evaluación
* interpretación de los patrones: validado con nuevos datos
* comprensibilidad del modelo inducido
* medidas cuantitativas para evaluar patrones
* funciones de utilidad

### Utilizar el conocimiento
* superar las condiciones de laboratorio
* verificar potenciales conflictos
* puede ser incorporado para soporte de toma de decisiones


## Preprocesamiento

Atributos de los datos:
* nominal: categorico
* binario
    * simétrico
    * antisimétrico
* numérico: 
    * cuantitativos: enteros o reales
        * escalas de intervalos: temperatura
        * escalas de razón: 10k
* ordinal: tienen sentido de ranking
* discretos
* continuos

Descripción estadistica de los datos:
* motivacion
    * vista gral de los datos
* medidas de tendencia central
    * media, mediana, moda, rango medio
* medidas de disperción
    * rangos intercuartiles
    * desviación estandar y varianza
    * 5 números mágicos, boxplot
* análisis de gráficos
    * histogramas
    * gráficos de disperción
    * QQ plot

### Calidad de los datos
* precisión
* integridad
* consistencia
* puntualidad
* confiabilidad
* interpretabilidad

### Tareas
* limpieza de los datos
    * completar datos faltantes
* integración de datos
    * con fuentes externas
* reducción de los datos
    * reducción de dimensionalidad
    * reducción de numerosidad
    * compresión de datos
* transformaciones y discretizaciones
    * nomralización
    * generación de jerarquia conceptual

**Limpieza de los datos**
* incompletos: datos faltantes
    * eliminar registros
    * imputar registros
* ruidosos: errores, valores atípicos, datos incompletos o inconsistentes, registros duplicados
    * binnig: 
        * ordena los datos y particiona en bins de igual frecuencia
        * suaviza por distintos medios: media, mediana, limites
    * regresión
        * suaviza ajustando por una fucnión de regresión lineal
    * clustering
        * identificar outliers. Los valores atípicos quedan aislados

**Ruido en aprendizaje supervisado**
* robustez: capacidad de un algoritmo de construir modelos que son insensibles a datos corruptos, es tan importante como la precisión
* robust learnes: menos influenciados por datos ruidosos
* data polishing methods: corregir instancias ruidosas
* noise filters: eliminar instancias ruidosas

**Ruido y degradación de performance**
* presencia de pequeñas disyunciones
* solapamiento entre clases
* clasificación erronea ocurre cerca de los límites de la clase donde la superposición también ocurre
* Tipo de ruido
    * Ruido en la clase: etiquetas mal asignadas
        * subjetividad durante el etiquetado
        * ejemplos contradictorios
        * ejemplos mal clasificados

**Integración de los datos**
* integrar datos de diferentes fuentes
* problemas en identificar entidades del mundo real
* detectar y resolver conflictos
    * misma entidad del mundo real con diferntres valores en los atributos de diferentes fuentes
    * razones: difrerentes representaciones, escalas, etc
* herramientas: ETL
* genera datos redundantes:
    * identificarlos
    * detectar datos derivables
    * Solución:
        * análisios de correlación y covarianza
        * prueba de independencia

## Outliers

### Univariados
Son en una simple variable y los enfoques son buenos para la detección de extremos pero no en otros casos
**Métodos**
* box plot: visualiza solo los varlores extremos
* IRQ: analiza los valores fuera del rango intercuartil
* z-score: cuantas desviaciones estandar tiene una observación de la media muestral. 1, 2, 3 desvios de la media

### Multivariados
Se encuentran en un espacio multidimensional y los enfoques necesitan ajustar el modelo
**Métodos**
* globales: utilizando clustering con medidas como Mahalanobis
* lof: basado en distancias
    * utiliza KNN
    * calcula scores para los puntos a partir de la tasa promedio de densidad de los puntos vecinos con respecto a si mismo
* ensambles: random forest

## Missing data

**Razones**
* factores propioos del procedimiento
* negativa a responder
* respuestas inaplicables

**Problemas**
* dificulta el análisis de datos
* manejo inapropiado introduce sesgos y resulta en conclusiones engañosas
* limita la generalización del conocimiento
* pérdida de eficiencia
* complicaciones en el análisis y manejo de datos
* sesgos entre los datos faltantes y completos

**Tipos**
* como datos faltantes: datos fuera de rango
* faltantes al azar o missing at random (MAR): se puede predecir a partir de otras variables de la base de datos
* completamente al azar o missing completeley at random (MCAR): los datos inexistentes son una muestra al azar
* dependen de un predictor no observado o non ignorable missing data: se podría estimar a partir de una variable no observada

**Métodos**
* utilizar solo registros completos: solo si los faltantes son MCAR
* borrar casos seleccionados o variables: solo si hay patrón no aleatorio. Puede no ser efectivo si se eliminan muchos datos
* imputación de datos o relleno de datos (puede generar sesgos):
    * sustitución de casos: reemplaza con valores observados. Realizado por un experto 
    * sustitución de medias: usa la media si los datos son normales, si no, usa la mediana
        * desventajas:
            * la varianza estimada no es valida, hay valores repetidos
            * distorsiona la distrubución
            * correlaciones deprimidas por la repetición de un valor consante
    * cold deck: usar valores o relaciones obtenidas de fuentes distintas de la base de datos actual. Se sustituye un valor constante derivado de fuentes externas o investigaciones previas
        * desventajas:
            * la varianza estimada no es valida, hay valores repetidos
            * distorsiona la distrubución
            * correlaciones deprimidas por la repetición de un valor consante
    * hot deck: reemplaza los datos faltantes con valores obtenidos de registros que son los mas similares
        * ventajas:
            * conceptualmente simple
            * conseva niveles de medición
            * finaliza con un set de datos completo
        * desventajas:
            * definición de similar
    * usando regresiones: utiliza análisis de regresión para predecir valores faltantes
        * utiliza regresiones simples o múltiples
        * se identifican variables independientes y dependientes
* aproximación basados en modelado MICE: múltiples imputaciones. Usa el supuesto de de que los datos son MAR, sino puede generar datos sesgados
    * Pasos
        1. imputación simple (guardo que datos se imputaron)
        2. place holders: toma una de las variables que se imputó y la vuelve a poner en NA
        3. se modela a partir del resto de las variables (todas o algunas) predecir un imputación para la variable en NA
        4. se imputa la variable en NA con las predicciones
        5. repetir desde el punto 2.
    * ventajas:
        * sin sesgo
        * cualquier tipo de análisis
        * es fácil de usar
    * desventajas:
        * pensar el modelo
        * costoso computacionalmente
        * genera un dataset en cada iteración completa

## Reducción de la dimensionalidad

* reducción de dimensionalidad: remover atributos que no son importantes, PCA, pares correlacionados
* reducción de datos: regresiones and log-linear models
* compresión de datos

**Maldición de dimensionalidad**
* cuando aumenta la dimensionalidad, los datos se vuelven cada vez más ralos
* la densidad y distancia entre los puntos se vuelve menos significativa
* combinaciones de subespacios crecen exponencialmente

**Reducción de la dimensionalidad**
* evaita la maldición de la dimensionalidad
* ayuda a eliminar características irrelevantes y reduce ruido
* reduce tiempo y espacio en la extracción de datos
* visualización más fácil

### Métodos de reduccion
**Eliminar columnas con datos faltantes**
Si bien se se puede trabajar con imputación de datos, a veces no es posible rellenar
* criterio: predominio de faltantes
* se calcula la poporción de faltantes y se busca valor de corte
* variables numéricas y categóricas

**Low variance filter**
Una forma de medir cuánta información tiene una columna de datos es medir la varianza
* elimina aquellos atributos con varianza menos a un umbral, varianza en 0 no ayuda a discriminar
* consideraciones
    * rangos deben estar normalizados
    * solo para datos numéricos
    * para variables booleanas se puede usar bernoulli

**Método $\chi^2$**
* remueve las variables con mayor probabilidad de ser independientes de la clase, o sea, irrelevantes para la clasificación
* para atributos categóricos y no negativos como booleanos o frecuencias

**Reducing highly correlated columns**
Los atributos correlacionados introducen redundancia al dataset y no agregan información
* eliminar pares corerlacionados a partir de la matriz de correlación
* puede ser usado con variables continuas o discretas con coeficientes de correlación Pearson

**PCA**
* encuentra una proyección que captura la mayor cantidad de variación en los datos
* datos originales se proyectan en un espacio mucho más pequeño
* se busca autovectores y de la matriz de covarianza y esos definen el nuevo espcio

**Variables importantes**
* son la salida de un modelo de ensables random forest
* utiliza medidas internas de importancia
* realiza un muestreo de variables para cada árbol y mide la importancia de cada variable. Al finalizar usa la importancia promedio de cada variable

**Backward feature elimination**
* usa un algoritmo de aprendizaje automático para medir como disminuye el error al quitar un atributo
* en cada paso elimina el peor atributo
* desventaja: caro computacionalmente

**Forward feature construction**
* en cada paso agrega el mejor de los atributos

## Feature engineering

Tiene como tarea mejorar el rendimiento del modelado en un conjunto de datos mediante la transformación de su *feature space*

### Normalización
* escalar features, mapeados a rangos más pequeños
* medidas dificultan la comparación de features
* evitar atributos con mayor magnitud tengan mayor peso

**Min-Max**
$$X^{*}\ =\ \dfrac{X\ -\ min(X)}{range(X)}\ =\ \dfrac{X\ -\ min(X)}{max(X)\ -\ min(X)}$$

**Z-score**
$$Z-score\ =\ \dfrac{X\ -\ mean(X)}{sd(X)}$$

**Decimal scaling**
$$X_{decimal}\ =\ \dfrac{X}{10^{d}}$$

**Escalado robusto**
Dataset con muchos valores atípicos entonces se usan estimaciones más solidas.
$$sesgo\ =\ \dfrac{3\ *\ (\overline{X}\ -\ \widetilde{X})}{\sigma}$$

### Discretización
* permite dividir el rango de una variable continua en intervalos
* pasa de valores continuos a un número reducido de etiquetas
* genera una representación concisa y fácil de utilizar
* supervisada: si utiliza información de la clase
* no supervisada: no utiliza información de la clase
* top down: parte de pocos puntos de splitting y trata de separar todo el rango
* bottom up: considera todos los puntos como posibles separadores del rango

#### Métodos no supervisados
**Binning**
* similar a la técnica de eliminación del ruido
* top down
* se basa en un número específico de bins
* criterios de agrupamiento:
    * igual frecuencia
    * igual ancho
    * usar k-means
* cada grupo se lo puede:
    * reemplazar por la media
    * reemplazar por la mediana
    * reemplazar por una etiqueta

**Rank**
* ranking de un número es su tamaño relativo a otros valores
* método sólido con un inconveniente, los valores pueden tener rangos diferentes en diferentes listas

**Quantiles**

**Math functions**
* efectivo para las variables numéricas con distribución altamente sesgada (ingresos)
* ejemplo: $FLOOR(LOG(X))$

#### Métodos supervisados
**Basado en entropía**
* top down
* el split point se calcula con la entropía de la clase y el information gain de las particiones

**Variables flags**
* predictores categóricos

## NoSql

### ACID
*  utilizada en RBDMS
* Atomicity: todo o nada, la transacción no se puede dividir
* Consistency: la transacción pasa de un estado consistente a otro estado consistente
* Isolation: transacciones se ejecutan de manera independiente
* Durability: los cambios en la base de datos son permanentes. Se persiste un estado consistente
* hace foco en la cosistencia e integridad
* usa estrategias de bloqueo de recursos

### BASE
* mantenerse incositentes por unos minutos en menos importanteque poder tomar un pedido
* Basic availability: permite que los sistemas sean temporalmente incosistenes para que las transacciones sean manejables
* Soft state: permite algunas incosistencias temporalmente y los datos pueden cambiar se usan para reducir la cantidad de recursos consumidos
* Evantual consistency: significa que cuando toda la lógica de servicio es ejecutada, el sistema alcanza un estado consistente
* hace foco en la disponibilidad
* permite almacenamiento de nuevos datos, con el riesgo de no estar sincronizados

### Diferencias ACID vs BASE
| **BASE** | **ACID** |
| -- | -- |
| disponibilidad | consistencia |
| optimista | pesimista |
| sin locks | con locks |

### Teorema de CAP
* Cualquier sistema de base de datos distribuido puede tener como máximo dos las siguientes 3 propiedades
    * Consistency
    * High availability
    * Partition tolarenca

**Key value**
* claves utilizadas para recuperar valores
* pros: escalable, api simple
* cons: no hay forma de consutlar los valores
* ej: 

**Column family**
* clave incluye una fila, familia de columnas y nombres de columnas
* consultas en filas y familia de columnas y nombres de columnas
* pros: alta escalabilidad y disponibilidad
* cons: el diseño de las columnas y filas es crítico
* ej: page rank

**Graph store**
* datos almacenados como nodos con relaciones y propiedades
* consutlas transversales a la red
* pros: búsquedas rápidas en la red
* cons: pobra escalabilidad cuando el grafo pasa el tamaño de la red
* ej: redes sociales

**Document store**
* datos almacenados en jerarquías anidadas
* lógica de los datos queda almacenada como una unidad
* pros: no existe capa de mapeo de objetos
* cons: incompatible con sql, complejo de implementar
* ej:

## Datos no estructurados

Actualmente los datos no están estructurados y se estima que son más del 95% de todos los datos generados.

**Lexicon**
* es conjunto completo y de las distintas palabras usadas para definir el corpus

**Modelo de bolsa de palabras**
* el orden de las palabras no importa
* las palabras se tratan como dimensiones o features y sus valores son las frecuencias de ocurrencia
* stopwords: muchas palabras frecuentes que no ayudan y se pueden remover de la bolsa de palabras. Existen ya conjuntos para cada idioma
* corpus: conjunto de datos que corresponde a una colección de documentos (en texto plano)
* matriz de término/documento: mayoría de los valores en cero, es una representación de alta dimensión, dispersa y no negativa
* stemming: consolida palabras relacionadas con la misma raíz
* lematización: usa la parte específica el habla para determianr la raíz de una palabra, son específicas de cada idioma
* NER: reconocimiento de entidades como personas, lugares, maras, fechas, etc

**Part os speech tagging**
* averiguar que son sustantivos, verbos, adjetivos, etc

## Reglas de asociación

Dado un conjunto de transacciones, encontrar reglas que puedan predecir la ocurrencia de un ítem basado en la presencia de otros

**Definiciones**
* itemset: colección de 1 o más items
* k-itemset: un itemset que contiene k items
* support_count ($\sigma$): cantidad de ocurrencia de un itemset
* support ($S$): fracción de transacciones que contiene a un itemset. $S(x)$ $=$ $\dfrac{\sigma(x)}{|T|}$
* itemset frecuente: itemset cuyo support es mayor o igual a un umbral establecido como *minimo soporte (min_sup)*

**Reglas de asociación**
* $X \longrightarrow Y$, donde $X$ e $Y$ son itemsets frecuentes
* métricas de evaluación:
    * support ($S$): fracción de transacciones que contienen a $X$ e $Y$
    * confidence ($C$): mide con que frecuencia $Y$ aparece en las transacciones en las que también aparece $X$. $C(X \longrightarrow Y)$ $=$ $\dfrac{\sigma(X \cap Y)}{\sigma(X)}$

### Descubrimiento de reglas
A partir de un conjunto de transacciones $T$, el objetivo es encontrar el todas las reglas que cumplan:
* Soporte $\ge$ min_sup
* Confianza $\ge$ min_conf

La aproximación por fuerza bruta: no funciona es caro computacionalmente

**Aplicaciones**
* encontrar conceptos relacionados
* encontrar plagios

**Association Rule Mining (ARM)**
* genera itemsets frecuentes con support $\ge$ min_sup (caro computacionalmente)
* genera reglas a partir de la división de los itemsets frecuentes los subconjuntos con las reglas que satisfacen la confianza

**Generación de un itemset**
* por fuerza burta: NO, es caro
* reducir el número de candidatos: haciendo poda
* reducir el número de comparaciones: usando estructuras de datos eficientes, no se necesitan comparar cada candidato contra cada transacción
* reducir el número de transacciones: usar Direct Hashing and Pruning (DHP)

**Principio Apriori**
Es una estrategia de reducción del número de candidatos. Se basa en que si un itemset es frecuente, enotnces todos sus subsets deben ser además frecuentes:
$$\forall\ X,\ Y\ :\ (X \subseteq Y)\Rightarrow S(X) \ge S(Y) $$

**Antimonotonía**
Si un itemset $X$ no satisface el umbral de min_sup, entonces no es frecuente. Si agrego un elemento cualqueira entonces tampoco puede ser frecuente:
$$S(X) < min\_sup \Rightarrow S(X \cup X_2) < min\_sup$$

**Algoritmo Apriori**
* maneja dos conjuntos de itemsets:
    * candidatos $C_k$
    * frecuentes $L_k$
* cuenta de dos pasos:
    * join:
        * $C_k$ es generado uniendo $L_{k-1}$ con sigo mismo
    * prune:
        * un (k-1)-itemset que no es frecuente no puede ser un subset de un k-itemset frecuente
* factores que afectan la complejidad:
    * elegir el umbral de min_sup
    * dimensionalidad del dataset
    * tamaño de las transacciones
* como las reglas se construyen a partir de los itemsets frecuentes, entonces todas satisfacen el min_sup


**Maximal frequent itemset**
* un itemset es maximal si ninguno de su superset es frecuente
* proporcionan un representación compacta del conjunto de elementos frecuentes

**Closed frequent itemset**
* un itemset es closed si ninguno de sus inmediatos supersets tiene el mismo support que el itemset
* representación mínima de los itemsets sin perder información del soporte
* permite remover reglas redundantes
* todos los MFI son closed

**Relgas redundantes**
Una regla $X \rightarrow Y$ es redundante si existe otra regla $X' \rightarrow Y'$ tal que:
* $X \subseteq X'$
* $Y \subseteq Y'$
* el soporte y la confianza de ambas reglas son idénticas

Si se usa CFI, entonces no se generan reglas redundantes

**Limitaciones de la confianza**
Reglas con alta confianza pueden ocurrir por casualidad. Estas reglas espurias pueden detectarse determinando si el antecedente y consecuente son independientes: $P(A \cap B) = P(A)P(B)$

**Lift**
Asumiendo que los items son independientes, el lift mide que tan lejos de la independencia están X e Y. Valores cercanos a 1 implican que X e Y son independientes y por lo tanto la regla no es interesante. El lift se calcula:
$$Lift(X \Rightarrow Y) = \dfrac{conf(X \Rightarrow Y)}{sup(Y)}$$


## FP - Growth

**Difrencia con respecto a Apriori**
* utiliza un enfoque de generar y probar
* genera itemsets y prueba si son frecuentes
* es costosa en tiempo y espacio
* el conteo de soporte es costoso
    * comprobación de conjuntos
    * múltiples escaneos de base de datos E/S

**FP-Growoth**
* permite descubir itemset frecuentes sin generación de itemsets candidatos
* paso 1: estructura de datos compacta FP-tree. Se construye en dos pasadas sobre las transacciones
* paso 2: extrae itemsets frecuentes desde el FP-tree, a través del recorrido

**FP-tree**
* generalmente de tamaño más pequeño que los datos sin comprir
* mejor caso: todas las transacciones contienen el mismo conjunto de items, entonces 1 sola ruta en el FP-tree
* peor caso: cada transacción tiene un conjunto único de items, entonces el tamaño es tan grande como los datos orignales y requiere más RAM para guardar punteros y contadores
* tamaño depende de como se ordenen los datos

## Sistemas de recomendación

**Dominio de recomendación**:
* usuarios
* items

**Matriz de utilidad**:
* conjuntos de ítems I={i1, i2, ...}
* conjunto de usuarios U={u1, u2, ...}
* tamaño $|I|$ x $|U|$
* los valores representan grados de preferencias de los usuarios sobre los ítems
* representación explícita: los valores el valor nominal que el usuario eligió para el item
* representación implícita: los valores indican si el usuario conoce el item

**Etapas de recomendación**
Recomendaciones para el usuario u:
* etapa 1: predicción
    * el sistema de recomendación asigna un score a cada ítem i desconocido por u
* etapa 2: recomendación
    * se genera una lista de ítems ordenada por valor de score y se recomienda los primeros k elementos de la lista

**Distribución de la cola larga**

### Clasificación de algoritmos
* popularidad
* basados en contenido
* *asociación de productos*
* *filtrado y colaborativo*
* híbridos y ensambles

**Asociación de productos**
Utiliza reglas de asociación de 2-itemsets
* cada usuario es una transcción
* se calculan reglas entre todos los pares de ítems
* se utiliza una sola métrica
* se genera una matriz cuadrada de $|I|$ x $|I|$
* si la métrica usada es de similitud, entonces la matriz es simétrica
* similitud de Jaccard:
    * items se representan como conjunto de usuarios
    * $sim(A,B) = \dfrac{supp(A \cap B)}{supp(A \cup B)} = \dfrac{supp(A \cap B)}{supp(A) + supp(B) - supp(A \cap B)}$
    * $sim (A,B) = \dfrac{|A \cap B|}{|A \cup B|}  = \dfrac{|A \cap B|}{|A| + |B| - |A \cap B|}$
* similitud coseno:
    * items como vectores con tantas dimensiones como usuarios existen
    * $sim(A,B) = \dfrac{supp(A \cap B)}{\sqrt{supp(A) * supp(B)}}$
    * $sim(A,B) = \dfrac{A.B}{||A|| x ||B||}$

**Filtro colaborativo**
De users a users
* predicciones: dado un usuario u
    * se calculan similitudes contra todos sus usuarios
    * se eligen a los k vecinos más cercanos
    * por cada ítem desconocido por u, se calcula como score a la suma de todos los índices de similitud de los k vecinos que contienen a i
* es una generalización de las recomendaciones de asociación de productos
* para las predicciones se suman todas las smilitudes de los ítems conocidos por u
* factorización de matrices:
    * método de reducción de dimensionalidad: SVD, gradiente descendiente
    * se decompone la matriz de utilidad en las nuevas dimensiones
    * las dimensiones latentes u ocultas captan distintas características de los ítems o usuarios
    * los ítems y usuarios quedan representados en este espacio latente
    * al estar representados en un mismo espacio pueden calcularse directamente la similitud (o distancia) entre un usuario y un ítem
