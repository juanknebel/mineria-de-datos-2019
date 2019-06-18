librerias_instaladas<-rownames(installed.packages())
if("arules" %in% librerias_instaladas == FALSE) {
  install.packages("arules", dependencies = TRUE)
}

library(arules)