# Used packages
pacotes = c("shiny", "shinydashboard", "tm", "wordcloud","tidyverse",
            "twitteR", "tidyverse", "rtweet", "SnowballC","syuzhet")

# Run the following command to verify that the required packages are installed. If some package
# is missing, it will be installed automatically
package.check <- lapply(pacotes, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
  }
})

library(tm)
library(wordcloud)
library(twitteR)
library(tidyverse)
library(rtweet)
library(SnowballC)
library(syuzhet)
library(shiny)
library(dplyr)
library(shinycssloaders)
library(shinythemes)
library(shinydashboard)

# Carga de las claves de conexion a Twitter
twitter_keys = read.csv(file = ".twitter_keys.csv")

#Se establece la conexion con la API
consumer_key = twitter_keys[1,1]
consumer_secret = twitter_keys[1,2]
access_token = twitter_keys[1,3]
access_secret = twitter_keys[1,4]
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Funcion que trae el texto a analizar en funcion de los parametros de entrada.
get_texto = function(ntweets, cuenta, opciones, idioma){
  # Carga de idioma a analizar
  clave_idioma = if_else(condition = idioma == "Español", true = "es", false = "en")
  # Tweets publicados de la cuenta o sobre la cuenta
  propios = if_else(condition = opciones == "Publicados de la cuenta", true = TRUE, false = FALSE)
  
  if (propios) {
    # Importar datos según el usuario (periódico)
    tweets <- userTimeline(user=cuenta, n = ntweets)
  }else{
    tweets <- searchTwitter(cuenta, n=ntweets, lang=clave_idioma)
  }
  #Convirtiendo los tweets en un data frame
  tweets.df <- twListToDF(tweets)
  
  #Quitando los links en los tweets
  tweets.df2 <- gsub("http.*","",tweets.df$text)
  tweets.df2 <- gsub("https.*","",tweets.df2)
  
  #Quitando los hashtags y usuarios en los tweets
  tweets.df2 <- gsub("#\\w+","",tweets.df2)
  tweets.df2 <- gsub("@\\w+","",tweets.df2)
  
  #Quitando los signos de puntuación, números y textos con números
  tweets.df2 <- gsub("[[:punct:]]","",tweets.df2)
  tweets.df2 <- gsub("\\w*[0-9]+\\w*\\s*", "",tweets.df2)
  
  #Transformamos la base de textos importados en un vector
  palabra.df <- as.vector(tweets.df2)
  return(palabra.df)
}

# Función que recoge un vector de palabras y lo convierte en una matriz
getTermMatrix <- function(text) {
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower)) # Lo convierte todo a minúsculas
  myCorpus = tm_map(myCorpus, removePunctuation) # Elimina puntuación de nuevo (por si acaso)
  myCorpus = tm_map(myCorpus, removeNumbers) # Elimina numeración
  myCorpus = tm_map(myCorpus, removeWords, # Elimina las palabras elegidas para que no aparezcan en nuestra matriz
                    c(stopwords("SMART"), stopwords("spanish")))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 2))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE) # Ordenamos las palabras para mostrar las más importantes
}