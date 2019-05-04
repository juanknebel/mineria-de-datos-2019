# Setea el directorio de trabajo
setwd("./")

# Labo 1
# Lee el archivo
MPI_subnational <- read.csv("./Labo 1/alkirempi/MPI_subnational.csv")
MPI_national <- read.csv("./Labo 1/alkirempi/MPI_national.csv")

# Muestra el dataframe
View(MPI_subnational)

# Represente gráficamente la cantidad de ciudades agrupados por Región.
# Agrupa por region la cantidad de ciudades
cities_by_region <- aggregate(MPI_subnational$Sub.national.region, by = list(MPI_subnational$World.region), FUN = length)
# Grafica la cantidad de ciudades que hay por cada region
pie(table(cities_by_region$x))

# Labo 2
ruidoso=read.csv('./Labo 2/ruidoso.txt')
data = ruidoso$Road_55dB

# Detección de outliers mediante irq (intercuartil)
plot(sort(data, decreasing = FALSE))
mean(data)
min(data)
max(data)
boxplot(data)
data.riq<-IQR(data)
cuantiles<-quantile(data, c(0.25, 0.5, 0.75), type = 7)
outliers_min<-as.numeric(cuantiles[1])-1.5*data.riq
outliers_max<-as.numeric(cuantiles[3])+1.5*data.riq
plot(sort(data[data>outliers_min & data<outliers_max], decreasing = FALSE))
boxplot(data[data>outliers_min & data<outliers_max])

# Detección de outliers mediante desvío de la media
N=3
desvio<-sd(data)
outliers_max_desvio<-mean(data)+N*desvio
outliers_min_desvio<-mean(data)-N*desvio
plot(sort(data[data>outliers_min_desvio & data<outliers_max_desvio], decreasing = FALSE))
boxplot(data[data>outliers_min_desvio & data<outliers_max_desvio])

# Detección de outliers mediante Z-Score
dataZ = ruidoso
dataZ$zscore<-(dataZ$Road_55dB-mean(dataZ$Road_55dB))/sd(dataZ$Road_55dB)
umbral<-2
max(dataZ$zscore)
min(dataZ$zscore)
plot(sort(dataZ$Road_55dB[dataZ$zscore<umbral], decreasing = FALSE))
boxplot(dataZ$Road_55dB[dataZ$zscore<umbral], decreasing = FALSE)

# Labo 3
auto_mpg=read.csv('./Labo 3/auto-mpg.data-original.txt', sep="")
auto_mpg[is.na(auto_mpg$X18.0),]
sum(is.na(auto_mpg$X18.0))

#Labo 4
auto_mpg_data=read.csv("./Labo 4/auto-mpg.data-original.txt", sep="")
