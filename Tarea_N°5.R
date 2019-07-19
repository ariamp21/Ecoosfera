
#Pagina Ecoosfera: "https://www.ecoosfera.com/"

#install.packages("rvest")
library('rvest')
library('ggplot2')

#Guardando la pagina
paginaEcoosfera <- "https://www.ecoosfera.com/"

#Leyendo el codigo de ecoosfera
paginaEcooRead <- read_html(paginaEcoosfera)
print(paginaEcooRead)

#Entrando a los links
paginaEcooNodes <- html_nodes(paginaEcooRead, ".menu")
paginaEcooNodes <- html_nodes(paginaEcooNodes, "a")
print(paginaEcooNodes)

#Obteniendo links
paginaEcooA <- html_attr(paginaEcooNodes, "href")
print(paginaEcooA)

########################################################################
#####EXTRACCION DE LOS TITULOS DE LAS "NOTICIAS" DE CADA CATEGORIA######
########################################################################

#El orden es el siguiente:
#1. Link de donde se obtuvo la informacion para que puedan corroborarlo
#2. Nombre de la categoria a estudiar
#3. Titulos de las noticias que presenta cada categoria

for (i in paginaEcooA){
  print(i)
  lecturaEcoo <- read_html(i)
  CategoriaEcoo <- html_text(html_nodes(lecturaEcoo,"title"))
  print(CategoriaEcoo)
  TituloEcoo <- html_text(html_nodes(lecturaEcoo,".entry-header"))
  TituloEcoo <- gsub("\t","",TituloEcoo)
  TituloEcoo <- gsub("\n","",TituloEcoo)
  TituloEcoo <- gsub("                                                           ","",TituloEcoo)
  TituloEcoo <- gsub("       ","",TituloEcoo)
  print(TituloEcoo)
}
###########################################################################
############### OBTENIENDO COMPARTIDOS DE CADA NOTICIA ######################
##########################################################################

#El orden es el siguiente
# Nombre de la categoría
# Links de las 10 noticias que presenta cada categoría
# Compartidos de las noticias, respecto a Facebook, Twitter y Pinterest respectivamente

ListaCategorias <- list()
ListaLinks <- list()
estRRSS <- data.frame()

for (i in paginaEcooA){
  
  lecturaEcoo <- read_html(i)
  CategoriaEcoo2 <- html_text(html_nodes(lecturaEcoo,".archive-title"))
  CategoriaEcoo2 <- gsub("\n","",CategoriaEcoo2)
  CategoriaEcoo2 <- gsub("\t","",CategoriaEcoo2)
  ListaCategorias <- c(ListaCategorias, (CategoriaEcoo2))
  print(ListaCategorias)
  NodesNoticias <- html_nodes(lecturaEcoo, ".entry-thumbnail")
  NodesNoticias2 <- html_nodes(NodesNoticias,".icon-link")
  LinksNoticias <- html_attr(NodesNoticias2, "href")
  ListaLinks <- c(ListaLinks, (LinksNoticias))
  print(ListaLinks)
  
  
  
  for (x in LinksNoticias){
    lecturaLinks <- read_html(x)
    Compartidos <- html_text(html_nodes(lecturaLinks, ".sha_box"))
    Compartidos <- gsub("Shares","",Compartidos)
    Compartidos <- as.numeric(Compartidos)
    
    # Se crea dataframe con los valores necesitados para realizar la estadistica descriptiva
    dfTemporal <- data.frame(Categoria = i, Fb = Compartidos[1], Tw = Compartidos[2], Pst = Compartidos[3])
    dfTemporal$SumaCompartidos <- (as.numeric(dfTemporal$Fb)+as.numeric(dfTemporal$Tw)+as.numeric(dfTemporal$Pst))
    
    # Se pone la informacion dentro de un data frame creado fuera del for para no perder los datos
    estRRSS <- rbind(estRRSS,dfTemporal)
    print(Compartidos)
    
  }
  # Se guarda en csv para no perder la informacion de cada categoria
  print(paste("============= crea csv",CategoriaEcoo2,"============="))
  write.csv(estRRSS,paste(CategoriaEcoo2,".csv",sep = ""))
  
}

#############################################################
############## CREANDO TABLAS X CATEGORIA ##################
############################################################
# El orden es el siguiente
# 1. Se creó un data frame vacio para luego meter la informacion necesaria de cada categoria
# 2. Se realizo data frame por separado segun los 10 links por categoria que ofrece la pagina
# 3. Luego se adjunto la tabla estRRSS la cual contiene los compartidos de cada categoria por RRSS
# 4. Finalmente se unieron todos los datos respecto a los 90 links.

dfFinal <- data.frame()
dfArte <- data.frame(links= unlist(ListaLinks[1:10]))
dfFinal <- rbind(dfFinal,dfArte)

dfEvolucion <- data.frame(links= unlist(ListaLinks[11:20]))
dfFinal <- rbind(dfFinal,dfEvolucion)

dfGuia <- data.frame(links= unlist(ListaLinks[21:30]))
dfFinal <- rbind(dfFinal,dfGuia)

dfMA <- data.frame(links= unlist(ListaLinks[31:40]))
dfFinal <- rbind(dfFinal,dfMA)

dfNoticias <- data.frame(links= unlist(ListaLinks[41:50]))
dfFinal <- rbind(dfFinal,dfNoticias)

dfSci <- data.frame(links= unlist(ListaLinks[51:60]))
dfFinal <- rbind(dfFinal,dfSci)

dfWell <- data.frame(links= unlist(ListaLinks[61:70]))
dfFinal <- rbind(dfFinal,dfWell)

dfViajes <- data.frame(links= unlist(ListaLinks[71:80]))
dfFinal <- rbind(dfFinal,dfViajes)

dfCol <- data.frame(links= unlist(ListaLinks[81:90]))
dfFinal <- rbind(dfFinal,dfCol)

dfFinal <- cbind(dfFinal,estRRSS)

write.csv(dfFinal, file = "TablaFinalCompartidos.csv")


############################################################
############## ESTADISTICA DESCRIPTIVA ####################
##########################################################

summary(dfFinal)
#       Fb                Tw               Pst           SumaCompartidos   
#Min.   :   12.0   Min.   :    9.0   Min.   :     0.0   Min.   :   146.0  
#1st Qu.:  262.2   1st Qu.:   24.0   1st Qu.:   242.5   1st Qu.:   977.8  
#Median :  680.0   Median :  269.0   Median :   337.5   Median :  3238.5  
#Mean   : 2537.7   Mean   : 2829.5   Mean   :  4858.7   Mean   : 10225.9  
#3rd Qu.: 1896.0   3rd Qu.:  843.2   3rd Qu.:  2674.8   3rd Qu.:  9068.5  
#Max.   :27493.0   Max.   :36421.0   Max.   :188644.0   Max.   :192203.0  

sd(dfFinal$Fb)
# 4941.315

sd(dfFinal$Tw)
# 7350.088

sd(dfFinal$Pst)
#  21185.24

sd(dfFinal$SumaCompartidos)
# 23287.89

#Desglose de los datos
#En Facebook la noticia que menos compartidos tuvo fue https://ecoosfera.com/arte-consciente-denuncia-la-emergencia-climatica-olafur-eliasson-in-real-life/
#la cual estaba publicada en dos categorias "Arte y Guia Gaia". Por otro lado la que más compartidos tuvo fue 
#https://ecoosfera.com/queen-brian-may-tesis-de-doctorado-astrofisico/ publicada en la categoria "Sci-Innovacion".

#En twitter la noticia con menos compartidos fue https://ecoosfera.com/ecoturismo-mexico-guia-donde-ir-mejores-destinos/
#parte de "Wellness". La con mayor cantidad de compartidos fue https://ecoosfera.com/ultima-luna-llena-luna-fria-planes-disfrutar-cielo/
#de la categoria "Viajes"

#En Pinterest la noticia que nunca fue compartida es https://ecoosfera.com/ecoturismo-mexico-guia-donde-ir-mejores-destinos/
#de "Viajes". La mas compartida fue https://ecoosfera.com/amazonas-deforestacion-pierde-arboles-campo-futbol-bolsonaro/
#de "Medio Ambiente".

#Podemos notar, que la noticia respecto a ecoturismo en la seccion "Viajes" y "Wellness" serian las que menos importancia le da el publico
#debido a que coincide la misma noticia en Twitter y Pinterest como la menos compartida.
#Ademas podemos notar que los roles de estas RRSS se pueden demostrar, por ejemplo en Pinterest la mas compartida
#es respecto a la deforestacion en "Medio Ambiente", esto sigue la corriente de su rol de demostrar realidad en fotos.
#En Twitter el publico suele visitar aquello que es "trending topics", lo cual fue hace un par de dias la luna llena en la
#tarde y noche del 17 de julio.
#Y finalmente en Facebook donde su publico actualmente lo utiliza para ver videos o aprender cosas rapidamente, las 
#cuales en epocas anteriores no se obtenian con tal velocidad.


#En cuanto a la Suma total de compartidos por noticia, la que menor numero de compartidos tuvo fue 
#https://ecoosfera.com/caribe-mexicano-emergencia-contaminacion-corales-blanqueamiento/ y la mas compartida fue
#https://ecoosfera.com/amazonas-deforestacion-pierde-arboles-campo-futbol-bolsonaro/. La primera publicada en
#"Columna especial" y la segunda en "Medio Ambiente".

#Podemos decir que la media de los compartidos para Facebook es de 2537 aproximadamente, para Twitter es de 2829 aproximadamente
#y de 4858 para Pinterest. Si nos guiamos por estos datos, podemos decir que la aplicacion que mas se informa mediante
#Ecoosfera son los usuarios de "Pinterest".

#A modo general podemos decir que el minimo esperado de compartidos para una noticia es de 146 en "Columna Especial" y el maximo es de 
#192 mil aproximadamente en "Medio Ambiente".

#################################################################
##################### GRAFICOS ##################################
##################################################################

hist(dfFinal$Fb, main="Noticias compartidas en Facebook", ylab="Frecuencia en links",xlab="Compartidos")

#Podemos notar que la moda de los links de Facebook muestra que se comparten generalmente hasta 5000 veces.

hist(dfFinal$Tw, main="Noticias compartidas en Twitter", ylab="Frecuencia en links",xlab="Compartidos")

#Se aprecia que generalmente hay 5000 compartidos en casi la totalidad de los links, al igual que facebook.

hist(dfFinal$Pst, main="Noticias compartidas en Pinterest", ylab="Frecuencia en links",xlab="Compartidos")
#La cantidad que generalmente se comparte son de 2500 salvo por algunas que ocasionan revuelo y llegan hasta
#200.000 compartidos

#Existen varios saltos entre los datos, lo cual no permite una distribucion normal, ademas de presentar
#altisimos niveles de dispersion, denotados por la desviacion estandar presentada.


########FIN########
#PD: No hay tildes debido a que despues salen cuadrados extraños que me perturban.
