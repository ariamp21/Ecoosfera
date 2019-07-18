
#Pagina Ecoosfera: "https://www.ecoosfera.com/"

#install.packages("rvest")
library('rvest')

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
ListaCompartidos <- list()

#Ejemplo usando DataFrame


for (i in paginaEcooA){

  
  #crea dataframe
  estadisticasRedesSociales <- data.frame()
  
  
  lecturaEcoo <- read_html(i)
  CategoriaEcoo2 <- html_text(html_nodes(lecturaEcoo,".archive-title"))
  CategoriaEcoo2 <- gsub("\n","",CategoriaEcoo2)
  CategoriaEcoo2 <- gsub("\t","",CategoriaEcoo2)
  ListaCategorias <- c(ListaCategorias, (CategoriaEcoo2))
  print(ListaCategorias)
  NodesNoticias <- html_nodes(lecturaEcoo, ".entry-thumbnail")
  NodesNoticias2 <- html_nodes(NodesNoticias,".icon-link")
  LinksNoticias <- html_attr(NodesNoticias2, "href")
  #print(ListaLinks)

  
  
  for (x in LinksNoticias){
    lecturaLinks <- read_html(x)
    Compartidos <- html_text(html_nodes(lecturaLinks, ".sha_box"))
    Compartidos <- as.numeric(gsub("Shares","",Compartidos))
    Compartidos <- as.numeric(Compartidos)
    
    # se crea dataframe con los valores necesitados
    dfTemporal <- data.frame(categoriaLink = i, Links = x, Fb = Compartidos[1], Tw = Compartidos[2], Pst = Compartidos[3])
    dfTemporal$newColum <- (as.numeric(dfTemporal$Fb)+as.numeric(dfTemporal$Tw)+as.numeric(dfTemporal$Pst))

    # Se mergean (unen) los valores en un DataFrame
    estadisticasRedesSociales <- rbind(estadisticasRedesSociales,dfTemporal)
    #print(Compartidos)
  }
  print(paste("============= crea csv",CategoriaEcoo2,"============="))
  write.csv(estadisticasRedesSociales,paste(CategoriaEcoo2,".csv",sep = ""))
  
}

  


  
  
  


  
  
  
    
    
    
    




  
  
   
   


 


 
#############################################################
############## CREANDO TABLAS ##############################
############################################################

#####Estan !!malos!! los intervalos de lista compartidos, tengo q encontrar una forma de sumar de 3 en 3 los compartidos y así usar
#####el unlist ,supongo, en la parte de val1 con [1:10]
  
dfTemporalArte <- data.frame(categorias = ListaCategorias[1], links= unlist(ListaLinks[1:10]), val1 = ListaCompartidos[1:3])

dfTemporalEvolucion <- data.frame(categorias = ListaCategorias[2], links= unlist(ListaLinks[11:20]), val1 = ListaCompartidos[31:33])

dfTemporalGuia <- data.frame(categorias = ListaCategorias[3], links= unlist(ListaLinks[21:30]), val1 = ListaCompartidos[61:63])

dfTemporalMA <- data.frame(categorias = ListaCategorias[4], links= unlist(ListaLinks[31:40]), val1 = ListaCompartidos[91:93])

dfTemporalNoticias <- data.frame(categorias = ListaCategorias[5], links= unlist(ListaLinks[41:50]), val1 = ListaCompartidos[121:123])

dfTemporalSci <- data.frame(categorias = ListaCategorias[6], links= unlist(ListaLinks[51:60]), val1 = ListaCompartidos[151:153])

dfTemporalWell <- data.frame(categorias = ListaCategorias[7], links= unlist(ListaLinks[61:70]), val1 = ListaCompartidos[181:183])

dfTemporalViajes <- data.frame(categorias = ListaCategorias[8], links= unlist(ListaLinks[71:80]), val1 = ListaCompartidos[211:213])

dfTemporalCol <- data.frame(categorias = ListaCategorias[9], links= unlist(ListaLinks[81:90]), val1 = ListaCompartidos[241:243])
