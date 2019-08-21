library(mongolite)
library(ggmap)
library(dplyr)
library(sp)
library(lubridate)
library(tidyr)
library(reshape2)
library(stringr)
library(tm)
library(stringi)
library(dplyr)
library(arules)
library(arulesViz)

register_google(key = "AIzaSyDNEh_BUnqoTTsABfuSB_BftOm5fvlHpuw")

#sucursales_mongo <- mongo(collection = "sucursales", db = "precios_caba")
#sucursales <- sucursales_mongo$find()
#productos <- mongo(collection = "productos", db = "precios_caba")$find()
#precios <- mongo(collection = "precios", db = "precios_caba")$find()
#barrios <- mongo(collection = "barrios", db = "precios_caba")
dolar <- mongo(collection = "dolar", db = "precios_caba")$find()
inflacion <- mongo(collection = "inflacion", db = "precios_caba")$find()
#precios_sucursal_discretizado = mongo(collection = "precios_sucursal_discretizado", db = "precios_caba")$find()
#sucursales_con_datos = mongo(collection = "sucursales_con_datos", db = "precios_caba")$find()
#productos <- mongo(collection = "productos_transformados", db = "precios_caba")$find()
precios_finales = mongo(collection = "precios_finales", db = "precios_caba")$find()
precios_finales_con_sufijo = mongo(collection = "precios_finales_con_sufijo", db = "precios_caba")$find()

# ------------------- Pre procesamiento de datos --------------------------------- #
# sucursales_con_datos = filter(sucursales, id %in% distinct(precios, sucursal)$sucursal)
# seleccionar_barrio <- function(los_barrios, la_sucursal) {
#   query <- paste0('{"geometry": {"$near": {"$geometry": {"type": "Polygon", "coordinates": [',la_sucursal['lng'],',',la_sucursal['lat'],']}}}}')
#   
#   return (los_barrios$find(query, limit=1)$properties$BARRIO)
# }
# 
# barrios_sucursales = apply(sucursales_con_datos, 1, seleccionar_barrio, los_barrios=barrios)
# sucursales_con_datos$barrio <- barrios_sucursales
# mongo(collection = "sucursales_con_datos", db = "precios_caba")$insert(sucursales_con_datos)

# -------------------------------- TP 2 ------------------------------------------ #
# ---------------------- Se levantan de la DB nuevas tablas ---------------------- #
# precios_sucursal <- mongo(collection = "precios_sucursal", db = "precios_caba")$find()
# # Agrego el periodo a los precios
# precios$periodo = -1
# precios$periodo = if_else(precios$medicion == 1 | precios$medicion == 2 | precios$medicion == 3,
#                           1, precios$periodo)
# precios$periodo = if_else(precios$medicion == 4 | precios$medicion == 5,
#                           2, precios$periodo)
# precios$periodo = if_else(precios$medicion == 6 | precios$medicion == 7,
#                           3, precios$periodo)
# precios$periodo = if_else(precios$medicion == 8 | precios$medicion == 9 | precios$medicion == 10,
#                           4, precios$periodo)
# 
# # Columnizo los precios
# precios_en_columnas = dcast(precios, producto + sucursal ~ medicion,value.var="precio")
# 
# # Completar datos faltantes
# completar_datos_faltantes <- function(una_fila) {
#   for (i in 3:ncol(una_fila)) {
#     if (is.na(una_fila[i])) {
#       if (i==3) {
#         una_fila[i] = rowMeans(una_fila[i:(i+1)], na.rm = TRUE)
#       } else if (i==12) {
#         una_fila[i] = rowMeans(una_fila[(i-1):i], na.rm = TRUE)
#       } else {
#         una_fila[i] = rowMeans(una_fila[(i-1):(i+1)], na.rm = TRUE)
#       }
#     }
#   }
#   return(una_fila)
# }
# 
# precios_en_columnas_con_promedio = precios_en_columnas

# for (i in 1:nrow(precios_en_columnas_con_promedio)) {
#   for (j in 3:ncol(precios_en_columnas_con_promedio[i,])) {
#     if (is.na(precios_en_columnas_con_promedio[i,j])) {
#       if (j==3) {
#         precios_en_columnas_con_promedio[i,j] = rowMeans(precios_en_columnas_con_promedio[i,j:(j+1)], na.rm = TRUE)
#       } else if (j==12) {
#         precios_en_columnas_con_promedio[i,j] = rowMeans(precios_en_columnas_con_promedio[i,(j-1):j], na.rm = TRUE)
#       } else {
#         precios_en_columnas_con_promedio[i,j] = rowMeans(precios_en_columnas_con_promedio[i,(j-1):(j+1)], na.rm = TRUE)
#       }
#     }
#   }
# }
# 
# # Grabo para evitar a futuro hacer lo mismo
# precios_sucursal <- mongo(collection = "precios_sucursal", db = "precios_caba")
# precios_sucursal$insert(precios_en_columnas_con_promedio)

### Punto 3 ###
# Otra forma
#promedio_periodo_1 = precios_sucursal %>% group_by(producto,sucursal) %>% dplyr::summarize(prom_periodo_1 = (mean(`1`, na.rm=TRUE) + mean(`2`, na.rm=TRUE) + mean(`3`, na.rm=TRUE)) / 3)
#promedio_periodo_2 = precios_sucursal %>% group_by(producto,sucursal) %>% dplyr::summarize(prom_periodo_2 = (mean(`4`, na.rm=TRUE) + mean(`5`, na.rm=TRUE)) / 2)
#promedio_periodo_3 = precios_sucursal %>% group_by(producto,sucursal) %>% dplyr::summarize(prom_periodo_3 = (mean(`6`, na.rm=TRUE) + mean(`7`, na.rm=TRUE)) / 2)
#promedio_periodo_4 = precios_sucursal %>% group_by(producto,sucursal) %>% dplyr::summarize(prom_periodo_4 = (mean(`8`, na.rm=TRUE) + mean(`9`, na.rm=TRUE) + mean(`10`, na.rm=TRUE)) / 3)
#precios_sucursal = merge(x = precios_sucursal, y = promedio_periodo_1, by = c("producto","sucursal"), all = TRUE)
#precios_sucursal = merge(x = precios_sucursal, y = promedio_periodo_2, by = c("producto","sucursal"), all = TRUE)
#precios_sucursal = merge(x = precios_sucursal, y = promedio_periodo_3, by = c("producto","sucursal"), all = TRUE)
#precios_sucursal = merge(x = precios_sucursal, y = promedio_periodo_4, by = c("producto","sucursal"), all = TRUE)
#precios_sucursal$prom_total <- rowMeans(precios_sucursal[, 3:12], na.rm=TRUE)

#Generar cuatro nuevas columnas de precios con los precios promedios de cada
#período descripto en la  Tabla 1 . 
#Además se podría generar una columna con el promedio total de todas las mediciones.
# precios_en_columnas=precios_sucursal
# precios_en_columnas$prom_periodo_1 = -1
# precios_en_columnas$prom_periodo_2 = -1
# precios_en_columnas$prom_periodo_3 = -1
# precios_en_columnas$prom_periodo_4 = -1
# precios_en_columnas$prom_total = -1

# # Agrego promedio de precios por fila
# precios_en_columnas$prom_total <- rowMeans(precios_en_columnas[, 3:12], na.rm=TRUE)
# 
# # Agrego promedio de precios periodo_1 a periodo_4
# for (i in 1:nrow(precios_en_columnas)) {
#   producto_i= precios_en_columnas$producto[i]
#   sucursal_i= precios_en_columnas$sucursal[i]
#   precios_groupBy = (precios%>%filter(precios$producto==producto_i)%>%filter(sucursal==sucursal_i))%>%group_by(periodo)%>%summarize(promedio=mean(precio))
#   precios_en_columnas$prom_periodo_1[i]=precios_groupBy$promedio[1]
#   precios_en_columnas$prom_periodo_2[i]=precios_groupBy$promedio[2]
#   precios_en_columnas$prom_periodo_3[i]=precios_groupBy$promedio[3]
#   precios_en_columnas$prom_periodo_4[i]=precios_groupBy$promedio[4]
# }

# Grabo para evitar a futuro hacer lo mismo (en otra tabla por ahora)
# precios_sucursal_conAvg <- mongo(collection = "precios_sucursal_conAvg", db = "precios_caba")
# precios_sucursal_conAvg$insert(precios_en_columnas)
# mongoexport --db precios_caba --collection precios_sucursal_conAvg --out ./data/precios_sucursal_conAvg.json

### Punto 4 ###
# precios_en_columnas_sinNa = na.omit(precios_sucursal)
# 
# precios_sucursal_con_avg_sin_na <- mongo(collection = "precios_sucursal_con_avg_sin_na", db = "precios_caba")
# precios_sucursal_con_avg_sin_na$insert(precios_en_columnas_sinNa)

# Punto 5
# precios_en_columnas_sinNa = mongo(collection = "precios_sucursal_con_avg_sin_na", db = "precios_caba")$find()
# 
# precios_en_columnas_sinNa$primera_variacion = precios_en_columnas_sinNa$prom_periodo_2 - precios_en_columnas_sinNa$prom_periodo_1
# precios_en_columnas_sinNa$segunda_variacion = precios_en_columnas_sinNa$prom_periodo_3 - precios_en_columnas_sinNa$prom_periodo_2
# precios_en_columnas_sinNa$tercera_variacion = precios_en_columnas_sinNa$prom_periodo_4 - precios_en_columnas_sinNa$prom_periodo_3
# precios_en_columnas_sinNa$total_variacion = precios_en_columnas_sinNa$prom_periodo_4 - precios_en_columnas_sinNa$prom_periodo_1
# 
# # Punto 6
# 
# discretizar <- function(columna) {
#   return (discretize(columna, method = "fixed", 
#              breaks = c(-Inf, -0.05, -0.02, -0.005, 0.005, 0.05, 0.1, Inf),
#              labels = c("Disminucion Fuerte", "Disminucion Media", "Disminucion Leve", "Mantiene", "Aumento Leve", "Aumento Medio", "Aumento Fuerte"),
#              onlycuts = FALSE))
# }
# 
# precios_en_columnas_sinNa = discretizeDF(precios_en_columnas_sinNa, methods = list(
#   primera_variacion = list(method = "fixed",
#                            breaks = c(-Inf, -0.05, -0.02, -0.005, 0.005, 0.05, 0.1, Inf),
#                            labels = c("Disminucion Fuerte", "Disminucion Media", "Disminucion Leve", "Mantiene", "Aumento Leve", "Aumento Medio", "Aumento Fuerte")),
#   segunda_variacion = list(method = "fixed",
#                            breaks = c(-Inf, -0.05, -0.02, -0.005, 0.005, 0.05, 0.1, Inf),
#                            labels = c("Disminucion Fuerte", "Disminucion Media", "Disminucion Leve", "Mantiene", "Aumento Leve", "Aumento Medio", "Aumento Fuerte")),
#   tercera_variacion = list(method = "fixed",
#                            breaks = c(-Inf, -0.05, -0.02, -0.005, 0.005, 0.05, 0.1, Inf),
#                            labels = c("Disminucion Fuerte", "Disminucion Media", "Disminucion Leve", "Mantiene", "Aumento Leve", "Aumento Medio", "Aumento Fuerte")),
#   total_variacion = list(method = "fixed",
#                            breaks = c(-Inf, -0.05, -0.02, -0.005, 0.005, 0.05, 0.1, Inf),
#                            labels = c("Disminucion Fuerte", "Disminucion Media", "Disminucion Leve", "Mantiene", "Aumento Leve", "Aumento Medio", "Aumento Fuerte"))
#   ),
#   default = list(method = "none")
#   )
# 
# # Punto 7
# promedio_periodo_1_relativo = precios_en_columnas_sinNa %>% group_by(producto) %>% dplyr::summarize(prom_periodo_1_relativo = mean(prom_periodo_1, na.rm=TRUE))
# promedio_periodo_2_relativo = precios_en_columnas_sinNa %>% group_by(producto) %>% dplyr::summarize(prom_periodo_2_relativo = mean(prom_periodo_2, na.rm=TRUE))
# promedio_periodo_3_relativo = precios_en_columnas_sinNa %>% group_by(producto) %>% dplyr::summarize(prom_periodo_3_relativo = mean(prom_periodo_3, na.rm=TRUE))
# promedio_periodo_4_relativo = precios_en_columnas_sinNa %>% group_by(producto) %>% dplyr::summarize(prom_periodo_4_relativo = mean(prom_periodo_4, na.rm=TRUE))
# promedio_total_relativo = precios_en_columnas_sinNa %>% group_by(producto) %>% dplyr::summarize(prom_total_relativo = mean(prom_total, na.rm=TRUE))
# 
# precios_en_columnas_sinNa = merge(x = precios_en_columnas_sinNa, y = promedio_periodo_1_relativo, by = "producto", all = TRUE)
# precios_en_columnas_sinNa = merge(x = precios_en_columnas_sinNa, y = promedio_periodo_2_relativo, by = "producto", all = TRUE)
# precios_en_columnas_sinNa = merge(x = precios_en_columnas_sinNa, y = promedio_periodo_3_relativo, by = "producto", all = TRUE)
# precios_en_columnas_sinNa = merge(x = precios_en_columnas_sinNa, y = promedio_periodo_4_relativo, by = "producto", all = TRUE)
# precios_en_columnas_sinNa = merge(x = precios_en_columnas_sinNa, y = promedio_total_relativo, by = "producto", all = TRUE)
# 
# # Punto 8
# #precio relativo = (precio producto en sucursal − precioproducto promedio) / precioproducto promedio
# (precios_en_columnas_sinNa$prom_periodo_1 - precios_en_columnas_sinNa$prom_periodo_1_relativo) / precios_en_columnas_sinNa$prom_periodo_1_relativo
# 
# precios_en_columnas_sinNa$primer_precio_relativo = (precios_en_columnas_sinNa$prom_periodo_1 - precios_en_columnas_sinNa$prom_periodo_1_relativo) / precios_en_columnas_sinNa$prom_periodo_1_relativo
# precios_en_columnas_sinNa$segundo_precio_relativo = (precios_en_columnas_sinNa$prom_periodo_2 - precios_en_columnas_sinNa$prom_periodo_2_relativo) / precios_en_columnas_sinNa$prom_periodo_2_relativo
# precios_en_columnas_sinNa$tercero_precio_relativo = (precios_en_columnas_sinNa$prom_periodo_3 - precios_en_columnas_sinNa$prom_periodo_3_relativo) / precios_en_columnas_sinNa$prom_periodo_3_relativo
# precios_en_columnas_sinNa$cuarto_precio_relativo = (precios_en_columnas_sinNa$prom_periodo_4 - precios_en_columnas_sinNa$prom_periodo_4_relativo) / precios_en_columnas_sinNa$prom_periodo_4_relativo
# precios_en_columnas_sinNa$final_precio_relativo = (precios_en_columnas_sinNa$prom_total - precios_en_columnas_sinNa$prom_total_relativo) / precios_en_columnas_sinNa$prom_total_relativo
# 
# # Discretizo
# precios_en_columnas_sinNa = discretizeDF(precios_en_columnas_sinNa, methods = list(
#   primer_precio_relativo = list(method = "fixed",
#                            breaks = c(-Inf, -0.1, -0.05, -0.01, 0.01, 0.05, 0.1, Inf),
#                            labels = c("Muy Barato", "Medianamente Barato", "Levemente Barato", "Medio", "Levemente Caro", "Medio Caro", "Muy Caro")),
#   segundo_precio_relativo = list(method = "fixed",
#                            breaks = c(-Inf, -0.1, -0.05, -0.01, 0.01, 0.05, 0.1, Inf),
#                            labels = c("Muy Barato", "Medianamente Barato", "Levemente Barato", "Medio", "Levemente Caro", "Medio Caro", "Muy Caro")),
#   tercero_precio_relativo = list(method = "fixed",
#                            breaks = c(-Inf, -0.1, -0.05, -0.01, 0.01, 0.05, 0.1, Inf),
#                            labels = c("Muy Barato", "Medianamente Barato", "Levemente Barato", "Medio", "Levemente Caro", "Medio Caro", "Muy Caro")),
#   cuarto_precio_relativo = list(method = "fixed",
#                           breaks = c(-Inf, -0.1, -0.05, -0.01, 0.01, 0.05, 0.1, Inf),
#                           labels = c("Muy Barato", "Medianamente Barato", "Levemente Barato", "Medio", "Levemente Caro", "Medio Caro", "Muy Caro")),
#   final_precio_relativo = list(method = "fixed",
#                          breaks = c(-Inf, -0.1, -0.05, -0.01, 0.01, 0.05, 0.1, Inf),
#                          labels = c("Muy Barato", "Medianamente Barato", "Levemente Barato", "Medio", "Levemente Caro", "Medio Caro", "Muy Caro"))
# ),
# default = list(method = "none")
# )
# 
# # mongo(collection = "precios_sucursal_pupnto_8", db = "precios_caba")$insert(precios_en_columnas_sinNa)
# 
# precios_sucursal_discretizado = precios_en_columnas_sinNa %>% 
#   select(producto, sucursal, primer_precio_relativo, segundo_precio_relativo,
#          tercero_precio_relativo, cuarto_precio_relativo, final_precio_relativo,
#          primera_variacion, segunda_variacion, tercera_variacion, total_variacion) %>%
#   rename(precio_rel_per_1_disc = primer_precio_relativo, precio_rel_per_2_disc = segundo_precio_relativo,
#          precio_rel_per_3_disc = tercero_precio_relativo, precio_rel_per_4_disc = cuarto_precio_relativo, 
#          precio_rel_medio_disc = final_precio_relativo,
#          precio_var_per_1_disc = primera_variacion, precio_var_per_2_disc = segunda_variacion,
#          precio_var_per_3_disc = tercera_variacion, precio_var_total_disc = total_variacion)
# 
# mongo(collection = "precios_sucursal_discretizado", db = "precios_caba")$insert(precios_sucursal_discretizado)

# Tratamiento de textos de descripciones de productos
# 3 nuevas columnas nombre_copia, marca_copia y presentacion_copia con el tratatamiento para eliminar
# puntuaciones, numeros, vocales y espacios en blanco

# for (i in 1:nrow(productos)) {
#   productos$nombre_copia[i] = stri_trans_general(
#     removePunctuation(
#       removeNumbers(
#         tolower(productos$nombre[i]))),"Latin-ASCII")
#   
#   productos$marca_copia[i] = str_trim(
#     stri_trans_general(
#       removePunctuation(
#         removeNumbers(
#           tolower(productos$marca[i]))),"Latin-ASCII"))
#   
#   productos$presentacion_copia[i] = str_trim(
#     stri_trans_general(
#       removePunctuation(
#         removeNumbers(
#           tolower(productos$presentacion[i]))),"Latin-ASCII"))
# }
# 
# #7. Obtengo el listado de presentaciones unicas y borro del nombre
# presentaciones_unicas = unique(productos$presentacion_copia)
# productos$nombre_copia=removeWords(productos$nombre_copia, presentaciones_unicas)
# 
# #8. Obtengo el listado de marcas unicas y borro del nombre
# marcas_unicas = unique(productos$marca_copia)
# productos$nombre_copia=removeWords(productos$nombre_copia, marcas_unicas)
# 
# #9. Eliminar palabras vacías en español 13 (preposiciones, artículos, etc).
# palabas_vacias = stopwords(kind = "spanish")
# productos$nombre_copia=removeWords(productos$nombre_copia, palabas_vacias)
# 
# #mongo(collection = "productos_transformados", db = "precios_caba")$insert(productos)

# precios_finales = inner_join(precios_sucursal_discretizado, productos, c("producto" = "id"))
# precios_finales = inner_join(precios_finales, sucursales_con_datos, c("sucursal" = "id"))
# 
# #mongo(collection = "precios_finales_crudos", db = "precios_caba")$insert(precios_finales)
# 
# precios_finales = precios_finales %>% 
#   select(nombre_copia, barrio, precio_rel_per_1_disc, precio_rel_per_2_disc,
#          precio_rel_per_3_disc, precio_rel_per_4_disc, precio_rel_medio_disc,
#          precio_var_per_1_disc, precio_var_per_2_disc,precio_var_per_3_disc, 
#          precio_var_total_disc) %>% rename(producto = nombre_copia)
# 
# mongo(collection = "precios_finales", db = "precios_caba")$insert(precios_finales)

#10. Separar el campo nombre en palabras y realizar conteos. Formar un vocabulario de palabras
#con aquellas palabras que tengan una mínima frecuencia en los textos de los productos
#precios_finales = mongo(collection = "precios_finales", db = "precios_caba")$find()
# myCorpus <- Corpus(VectorSource(precios_finales$producto))
# tdm <- TermDocumentMatrix(myCorpus)
# min_frecuencia = data.frame(findFreqTerms(tdm, 3, Inf))
# colnames(min_frecuencia) <- c("minFrecWord")

#11. Por cada palabra de vocabulario seleccionada, generar una columna de presencia
# ausencia. En el caso de ausencia marcar como NA, y en el caso de presencia algún
# caracter (Ej ‘S’). Es recomendable para luego aplicar reglas de asociación, utilizar un
# prefijo en cada una de de estas columnas seguido por la palabra en cuestión 15 (Ej:termino_yerba, termino_leche).

# ------------- Para usar una lista particular de palabras frecuentes ------------------- #
# Si no usar el punto 10
#precios_finales = mongo(collection = "precios_finales", db = "precios_caba")$find()
#min_frecuencia = read.csv(file = "~/min.csv", header = TRUE)

# --------------------------------------------------------------------------------------- #

# palabras_frecuentes = as.vector(t(min_frecuencia))
# c = dcast(min_frecuencia, minFrecWord ~ minFrecWord,value.var="minFrecWord")
# colnames(c) <- paste("SUFIJO", sep = "_",colnames(c))
# c$SUFIJO_minFrecWord=NULL
# c = c [0,]
# precios_finales_con_sufijo = cbind(precios_finales, c[1:nrow(precios_finales),])

# for (i in 1:length(palabras_frecuentes)) {
#   una_palabra = palabras_frecuentes[i]
#   esta_palabra = str_detect(precios_finales_con_sufijo$producto, una_palabra)
#   nombre_col = paste("SUFIJO_",palabras_frecuentes[i],sep="")
#   precios_finales_con_sufijo[nombre_col] = if_else(esta_palabra,"S", NA_character_)
# }

#mongo(collection = "precios_finales_con_sufijo", db = "precios_caba")$insert(precios_finales_con_sufijo)

# ------------ Init: Graficos de estudio de los datos ----------- #
data= table(precios_finales_con_sufijo %>% select(2:2))
pie(data, names(data),main = "# mediciones por Barrio",col = rainbow(length(data)))

# GRAFICO DE TORTA PARA PRECIOS RELAVITOS #
data= table(precios_finales_con_sufijo %>% select(3:3))
#piepercent<- round(100*data/sum(data), 1)
pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Precio relativo periodo 1",cex=1,
    col = rainbow(length(data)))
#legend("topright",bg="transparent", names(data), cex = 0.7, fill = rainbow(length(data)))

precios_relativos = precios_finales_con_sufijo %>% select(4:4)
data= table(precios_relativos)

pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Precio relativo periodo 2",cex=1,  col = rainbow(length(data)))

precios_relativos = precios_finales_con_sufijo %>% select(5:5)
data= table(precios_relativos)
pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Precio relativo periodo 3",cex=1,col = rainbow(length(data)))

precios_relativos = precios_finales_con_sufijo %>% select(6:6)
data= table(precios_relativos)
pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Precio relativo periodo 4",cex=1,col = rainbow(length(data)))

# GRAFICO DE TORTA PARA VARIACION #
precios_relativos = precios_finales_con_sufijo %>% select(8:8)
data= table(precios_relativos)
pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Variacion periodo 1",cex=1,col = rainbow(length(data)))

precios_relativos = precios_finales_con_sufijo %>% select(9:9)
data= table(precios_relativos)
pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Variacion periodo 2",cex=1,col = rainbow(length(data)))

precios_relativos = precios_finales_con_sufijo %>% select(10:10)
data= table(precios_relativos)
pielabels <- sprintf("%s = %3.1f%s", names(data),100*data/sum(data), "%")
pie(data, labels = pielabels,main = "Variacion periodo 3",cex=1,col = rainbow(length(data)))

# ------------ Fin: Graficos de estudio de los datos ----------- #


################# Reglas de Asociacion ################# 
precios_finales_con_sufijo = mongo(collection = "precios_finales_con_sufijo", db = "precios_caba")$find()

# precio_rel_per_1_disc
# precio_rel_per_2_disc
# precio_rel_per_3_disc
# precio_rel_per_4_disc
# precio_rel_medio_disc
# 
# Muy Barato 
# Medianamente Barato 
# Levemente Barato 
# Medio 
# Levemente Caro 
# Medio Caro 
# Muy Caro

# precio_var_per_1_disc
# precio_var_per_2_disc
# precio_var_per_3_disc
# precio_var_total_disc
# 
# Disminucion Fuerte 
# Disminucion Media 
# Disminucion Leve 
# Mantiene 
# Aumento Leve 
# Aumento Medio 
# Aumento Fuerte

poda_las_reglas <- function(reglas) {
  reglas.ordenadas = sort(reglas, by="lift", decreasing = TRUE)
  subconjunto.matriz = is.subset(reglas.ordenadas,reglas.ordenadas)
  subconjunto.matriz[lower.tri(subconjunto.matriz, diag=T)] <- F
  redundantes = apply(subconjunto.matriz, 2, any)
  reglas.podadas <- reglas[!redundantes]
  return (reglas.podadas)
}

reglas = apriori(precios_finales_con_sufijo, 
                 parameter = list(support=0.03, confidence=0.9, target = "rules", minlen=2)
)

inspectDT(reglas)
#reglas <- apriori(precios_finales_con_sufijo, parameter = list(support=0.02, confidence=0.03, target = "rules"))
#rules.sub <- subset(reglas, subset = lhs %pin% "sal=S")

plot(reglas)
plot(head(sort(reglas, by="lift", decreasing = TRUE),20), method="graph")
plot(head(sort(reglas, by="lift", decreasing = TRUE),20), method="grouped")

inspect(sort(reglas, by="lift", decreasing = TRUE))
# Selecciono las 10 primeras reglas
inspect(head(sort(reglas, by="lift", decreasing = TRUE),10))
# Selecciono las 20 primeras reglas
inspect(head(sort(reglas, by="lift", decreasing = TRUE),20))

# --------------------------- Init: Ignacio --------------------------- #
###### INICIO: PREDICTIVO 1 ###########
reglas <- apriori(precios_finales_con_sufijo, parameter = list(support=0.02, confidence=0.03, target = "rules",parameter=list(minlen=2)))
rules.sub <- subset(reglas, subset = lhs %ain%  c("precio_rel_per_1_disc","precio_rel_per_2_disc","precio_rel_per_3_disc"))
rules.sub <- subset(reglas, subset = rhs %pin%  "precio_rel_per_4_disc")
inspectDT(head(sort(rules.sub, by="lift", decreasing = TRUE),20))

plotly_arules(rules.sub)
###### FIN: PREDICTIVO 1 ###########
###### INICIO: PREDICTIVO 2 ###########
# Busco productos del TP1 para ver si se cumplio el aumento, decremento o mantenimiento de precios.
###### FIN: PREDICTIVO 2 ###########
###### FIN: NACHO ##################
# --------------------------- End: Ignacio --------------------------- #



# --------------------------- Juan --------------------------- #
# Reglas para ver la disminucion y aumento de la variacion de los precios
reglasDisminucion =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.034, confidence=0.5, target = "rules", minlen=2),
          appearance = list(rhs=c(
            "precio_var_per_3_disc=Disminucion Fuerte",
            "precio_var_per_3_disc=Disminucion Media",
            "precio_var_per_3_disc=Disminucion Leve",
            "precio_var_per_3_disc=Mantiene"))
  )

reglasAumento = 
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.034, confidence=0.5, target = "rules", minlen=2),
          appearance = list(rhs=c(
            "precio_var_per_3_disc=Aumento Fuerte",
            "precio_var_per_3_disc=Aumento Medio",
            "precio_var_per_3_disc=Aumento Leve"))
  )

reglasAumento.podadas = poda_las_reglas(reglasAumento)
reglasDisminucion.podadas = poda_las_reglas(reglasDisminucion)
inspectDT(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),4))
inspectDT(head(sort(reglasAumento.podadas, by="lift", decreasing = TRUE),4))
#write(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),4),file = "rulesDisminucion")
#write(head(sort(reglasAumento.podadas, by="lift", decreasing = TRUE),4),file = "rulesAumento")

inspect(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),5))

plot(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),200),
     #measure=c("support", "confidence"), shading = "lift",
     )

plot(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),20), 
     method="graph")

plot(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),20), 
     method="grouped",
     k=10)

plot(head(sort(reglasDisminucion.podadas, by="lift", decreasing = TRUE),20),
     method="paracoord")

plot(head(sort(reglasAumento.podadas, by="lift", decreasing = TRUE),200),
     #measure=c("support", "confidence"), shading = "lift",
    )

plot(head(sort(reglasAumento.podadas, by="lift", decreasing = TRUE),20), 
     method="graph")

plot(head(sort(reglasAumento.podadas, by="lift", decreasing = TRUE),20), 
     method="grouped",
     k=10)

plot(head(sort(reglasAumento.podadas, by="lift", decreasing = TRUE),20),
     method="paracoord")

# Reglas para ver como influyo la variacion total de los precios por barrio
reglasPreciosBarrio =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.01, confidence=0.4, target = "rules", minlen=2),
          appearance = list(
            rhs=paste0("precio_var_total_disc=",unique(precios_finales_con_sufijo$precio_var_total_disc)),
            default="lhs")
  )

reglasPreciosBarrio.podadas = poda_las_reglas(reglasPreciosBarrio)
reglasPreciosBarrio.subconjunto = subset(reglasPreciosBarrio.podadas, lhs %pin% "barrio")
inspectDT(reglasPreciosBarrio.subconjunto)

# Hay mas frecuencia de reglas que aumentan pero la confianza es mayor en las reglas que se mantienen para estos barrios
plot(head(sort(reglasPreciosBarrio.subconjunto, by="lift", decreasing = TRUE),40), 
     method="grouped",
     k=10)

# Los precios se mantuvieron o aumentaron fuerte pero no bajaron
plot(head(sort(reglasPreciosBarrio.subconjunto, by="lift", decreasing = TRUE),40),
     method="paracoord")

# Reglas para ver como es el precio relativo medio entre los barrios
reglasPreciosRelativoBarrio =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.01, confidence=0.4, target = "rules", minlen=2),
          appearance = list(
            rhs=paste0("precio_rel_medio_disc=",unique(precios_finales_con_sufijo$precio_rel_medio_disc)),
            default="lhs")
  )

reglasPreciosRelativoBarrio.podadas = poda_las_reglas(reglasPreciosRelativoBarrio)
reglasPreciosRelativoBarrio.subconjunto = subset(reglasPreciosRelativoBarrio.podadas, lhs %pin% "barrio")
inspectDT(reglasPreciosRelativoBarrio.subconjunto)

# ????
plot(head(sort(reglasPreciosRelativoBarrio.subconjunto, by="lift", decreasing = TRUE),40), 
     method="grouped",
     k=10)

# Los precios relativos medio estan entre levemente caro, barato y medio
plot(head(sort(reglasPreciosRelativoBarrio.subconjunto, by="lift", decreasing = TRUE),40),
     method="paracoord")

# Variacion entre periodo 3 y 4
reglasPreciosPeriodo =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.01, confidence=0.4, target = "rules", minlen=2),
          appearance = list(
            lhs=paste0("precio_var_per_2_disc=",unique(precios_finales_con_sufijo$precio_var_per_2_disc)),
            rhs=paste0("precio_var_per_3_disc=",unique(precios_finales_con_sufijo$precio_var_per_3_disc)),
            default="none")
  )
inspectDT(reglasPreciosPeriodo)

# Todas las reglas de barrios
reglasTodasBarrios =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.01, confidence=0.4, target = "rules", minlen=2),
          appearance = list(
            lhs=paste0("barrio=",unique(precios_finales_con_sufijo$barrio)),
            default="rhs")
  )

reglasTodasBarrios.podadas = poda_las_reglas(reglasTodasBarrios)
reglasTodasBarrios.subconjunto = subset(reglasTodasBarrios.podadas, lhs %pin% "barrio")
inspectDT(reglasTodasBarrios.subconjunto)

plot(head(sort(reglasTodasBarrios.subconjunto, by="lift", decreasing = TRUE),30),
     method="paracoord")

plot(head(sort(reglasTodasBarrios.subconjunto, by="lift", decreasing = TRUE),10), 
     method="graph")

# Todas las reglas por precio relativo
reglasTodasRelativo =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.02, confidence=0.6, target = "rules", minlen=2),
          appearance = list(
            rhs=paste0("precio_rel_medio_disc=",unique(precios_finales_con_sufijo$precio_rel_medio_disc)),
            default="lhs")
  )

reglasTodasRelativo.podadas = poda_las_reglas(reglasTodasRelativo)
reglasTodasRelativo.subconjunto = subset(reglasTodasRelativo.podadas, lhs %pin% "precio_var")
inspectDT(reglasTodasRelativo.subconjunto)

plot(head(sort(reglasTodasRelativo.subconjunto, by="lift", decreasing = TRUE),30),
     method="paracoord")

plot(head(sort(reglasTodasRelativo.subconjunto, by="lift", decreasing = TRUE),10), 
     method="graph")

plot(head(sort(reglasTodasRelativo.subconjunto, by="lift", decreasing = TRUE),20), 
     method="grouped")

# Reglas por producto
reglasProducto =
  apriori(precios_finales_con_sufijo,
          parameter = list(support=0.01, confidence=0.3, target = "rules", minlen=2),
          appearance = list(
            lhs=c("SUFIJO_vainilla=S","SUFIJO_polvo=S","SUFIJO_crema=S","SUFIJO_light=S","SUFIJO_galletitas=S",
                  "SUFIJO_harina=S","SUFIJO_aceite=S","SUFIJO_turron=S","SUFIJO_cerveza=S","SUFIJO_aerosol=S",
                  "SUFIJO_carne=S", "SUFIJO_detergente=S")
          )
  )

reglasProducto.podadas = poda_las_reglas(reglasProducto)
reglasProducto.subconjunto1 = subset(reglasProducto.podadas, rhs %pin% "precio_var_")
reglasProducto.subconjunto2 = subset(reglasProducto.podadas, rhs %pin% "precio_rel_")
reglasProducto.subconjunto = union(reglasProducto.subconjunto1, reglasProducto.subconjunto2)

inspectDT(reglasProducto.subconjunto)

plot(head(sort(reglasProducto.subconjunto, by="lift", decreasing = TRUE),10), 
     method="graph")

