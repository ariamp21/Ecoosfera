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
  print(TituloEcoo)
  }
###########################################################################
############### OBTENIENDO COMPARTIDOS DE CADA NOTICIA ######################
##########################################################################

#El orden es el siguiente
# Nombre de la categoría
# Links de las 10 noticias que presenta cada categoría
# Compartidos de las noticias, respecto a Facebook, Twitter y Pinterest respectivamente


for (i in paginaEcooA){
  lecturaEcoo <- read_html(i)
  CategoriaEcoo2 <- html_text(html_nodes(lecturaEcoo,".archive-title"))
  CategoriaEcoo2 <- gsub("\n","",CategoriaEcoo2)
  CategoriaEcoo2 <- gsub("\t","",CategoriaEcoo2)
 print(CategoriaEcoo2)
  NodesNoticias <- html_nodes(lecturaEcoo, ".entry-thumbnail")
  NodesNoticias2 <- html_nodes(NodesNoticias,".icon-link")
  LinksNoticias <- html_attr(NodesNoticias2, "href")
print (LinksNoticias)

for (x in LinksNoticias){
  lecturaLinks <- read_html(x)
  Compartidos <- html_text(html_nodes(lecturaLinks, ".sha_box"))
  Compartidos <- gsub("Shares","",Compartidos)
  Compartidos <- (as.numeric(Compartidos))
print(Compartidos)
 }

}



