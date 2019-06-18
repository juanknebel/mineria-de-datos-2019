load("/Users/jknebel/Projects/mineria-de-datos-2019/labo_6/titanic.raw.rdata")

attach(titanic.raw)

total_passangers = nrow(titanic.raw)

# Soporte para Survived=Yes
nrow(titanic.raw[Survived=='Yes',])/total_passangers

# Soporte para Survived=Yes y Sex=Male
nrow(titanic.raw[Survived=='Yes' & Sex=='Male' ,])/total_passangers

# ¿Cuales itemsets de los que se listan a continuación tienen mayor soporte?
nrow(titanic.raw[Class=='3rd' & Sex=='Male' & Survived=='Yes', ])/total_passangers
nrow(titanic.raw[Class=='3rd' & Sex=='Male' & Survived=='No', ])/total_passangers

# ¿Considera que 0.02 es un minsup adecuado para conseguir itemsets frecuentes? Justifique su respuesta con ejemplos.

# Confianza
# Calcular la confianza para el siguiente conjunto de reglas:

# {Class=Crew} => {Survived=Yes} --> support_count(Class=Crew, Survived=Yes) / support_count(Class=Crew)
support_count_1 = nrow(titanic.raw[Class=='Crew' & Survived=='Yes',  ])
support_count_2 = nrow(titanic.raw[Class=='Crew',])
confidence_1 = support_count_1/support_count_2

# {Class=1st} => {Survived=Yes} --> support_count(Class=1st, Survived=Yes) / support_count(Survived=Yes)
support_count_3 = nrow(titanic.raw[Class=='1st' & Survived=='Yes',  ])
support_count_4 = nrow(titanic.raw[Class=='1st',])
confidence_2 = support_count_3/support_count_4

# Para 1 y 2 calcule para los no sobrevivientes e interprete los resultados.
# ¿Cuál de las siguientes reglas tiene minconf >= 0.3?
# {Age=Adult, Sex=Female} => {Survived=Yes}
# {Age=Adult, Sex=Male} => {Survived=No}

nrow(titanic.raw[Class=='Crew' & Survived=='Yes',])/nrow(titanic.raw[Class=='Crew',])