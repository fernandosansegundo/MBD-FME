# Used packages
pacotes = c("shiny", "shinydashboard", "tm", "wordcloud", "memoise","tidyverse",
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

#Se establece la conexion con la API
consumer_key = "lOyVVuUKfi8WnbekjW6EmPQZ6"
consumer_secret = "KhrOwxLyFGXACtSb9IOrV490bNPIqttDYZCVxQFTx1qgWuwlVJ"
access_token = "2833913589-mbS7RsfjAspHJg0q0zPgqz0OycRw7QuxphfbkVj"
access_secret = "wBFChvVngjERyBMQZx98TXVQ7wvHtbbnK41yXHIX6shLP"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

get_texto = function(ntweets, cuenta, opciones, idioma){
  clave_idioma = if_else(condition = idioma == "Español", true = "es", false = "en")
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
  
  #Transformamos la base de textos importados en un vector para
  #poder utilizar la función get_nrc_sentiment
  palabra.df <- as.vector(tweets.df2)
  return(palabra.df)
}

# Using "memoise" to automatically cache the results
getTermMatrix <- function(text) {
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but", "pero", "el", "la", "uno", "una", "las", "los", "..."))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 2))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
}
