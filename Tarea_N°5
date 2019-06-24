#Pagina Ecoosfera: "https://www.ecoosfera.com/"

#install.packages("rvest")
library('rvest')

#Guardando la pagina
paginaEcoosfera <- "https://www.ecoosfera.com/"

#Leyendo el codigo de ecoosfera
paginaEcooRead <- read_html(paginaEcoosfera)
print(paginaEcooRead)

#Entrando a los links
paginaEcooNodes <- html_nodes(paginaEcooRead, "a")
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

for (i in paginaEcooA [2:9]){
  print(i)
  lecturaEcoo <- read_html(i)
  CategoriaEcoo <- html_text(html_nodes(lecturaEcoo,"title"))
  print(CategoriaEcoo)
  TituloEcoo <- html_text(html_nodes(lecturaEcoo,".entry-header"))
  TituloEcoo <- gsub("\t","",TituloEcoo)
  TituloEcoo <- gsub("\n","",TituloEcoo)
  print(TituloEcoo)
  }
