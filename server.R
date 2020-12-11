function(input, output, session) {
    texto <- reactive({
        # Cuando se pulsa el boton de analisis es cuando se cargan de nuevo los tweets
        input$analisis
        # Mientras se carga muestra el texto y la barra de cargando
        isolate({
            withProgress({
                setProgress(message = "Cargando ...")
                get_texto(input$ntweets, input$cuenta, input$opciones, input$idioma) # llamamos a la funcion traer texto que ejecuta la conexión con la API de twitter
            })
        })
    })
    cloud <- reactive({
        getTermMatrix(texto()) # Funcion que se llama cuando se va a formar la matriz
    })
    emocion1 <- reactive({
        idioma_sentiment = if_else(condition = input$idioma=="Español", true = "spanish", false = "english")
        #Aplicamos la función indicando el vector y el idioma y creamos
        #un nuevo data frame llamado emocion.df
        get_nrc_sentiment(char_v = texto(), language = idioma_sentiment) #funcion que analiza los sentimientos en funcion del idioma que se le haya pasado
    })
    emocion2 <- reactive({
        #Empezamos transponiendo emocion.df
        emocion.df3 <- data.frame(t(emocion1()))
        
        #Sumamos los puntajes de cada uno de los tweets para cada emocion
        emocion.df3 <- data.frame(rowSums(emocion.df3))
        
        #Nombramos la columna de puntajes como recuento
        names(emocion.df3)[1] <- "recuento"
        
        #Dado que las emociones son los nombres de las filas y no una variable
        #transformamos el data frame para incluirlas dentro
        cbind("sentimiento" = rownames(emocion.df3), emocion.df3)
    })
    
    output$emociones <- renderPlot({
        ggplot(emocion2()[1:8,],
               aes(x = sentimiento,
                   y = recuento)) + 
            geom_bar(colour="black", stat = "identity", size=.4, fill = brewer.pal(8, "Set2")) +
            labs(title = "Análisis de sentimiento \n Ocho emociones",
                 x = "Sentimiento", y = "Frecuencia") +
            geom_text(aes(label = recuento),
                      vjust = 1.5, color = "black",
                      size = 5) +
            theme(plot.title = element_text(hjust = 0.5),
                  axis.text = element_text(size=12),
                  axis.title = element_text(size=14,face = "bold"),
                  title = element_text(size=20,face = "bold"),
                  legend.position = "none")
    })
    
    output$valoracion <- renderPlot({
        ggplot(emocion2()[9:10,], 
               aes(x = sentimiento,
                   y = recuento, fill = sentimiento)) + 
            geom_bar(colour="black", stat = "identity", size=.4) +
            labs(title = "Análisis de sentimiento \n Valoración positiva o negativa", 
                 x = "Sentimiento", y = "Frecuencia") +
            geom_text(aes(label = recuento),
                      vjust = 1.5, color = "black",
                      size = 5) +
            theme(plot.title = element_text(hjust = 0.5),
                  axis.text = element_text(size=12),
                  axis.title = element_text(size=14,face = "bold"),
                  title = element_text(size=20,face = "bold"),
                  legend.position = "none")
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)

    output$nube = renderPlot({
        wordcloud_rep(names(cloud()), cloud(), scale=c(4,1),
                      min.freq = input$freqWords, max.words=input$maxWords,
                      colors= brewer.pal(8, "Set2"))
    })
}
