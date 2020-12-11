navbarPage("Análisis con Twitter",
           tabPanel("Análisis", fluidPage(theme = shinytheme("flatly")),
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    
                    # Generate a row with a sidebar
                    sidebarLayout(      
                        # Define the sidebar with one input
                        sidebarPanel(
                            h4("Obtención de tweets"),
                            sliderInput("ntweets",
                                        "Número de Tweets:",
                                        min = 0,  max = 500,  value = 200, step = 10),
                            selectInput("opciones", "Opciones:", 
                                        choices=c("Publicados de la cuenta", "Publicados sobre la cuenta")),
                            textInput("cuenta", "Cuenta:",value = "@JoeBiden", placeholder = "Example: @pepe32"),
                            selectInput("idioma", "Idioma:", 
                                        choices=c("Inglés", "Español")),
                            h4("Gráfico de la nube"),
                            sliderInput("freqWords",
                                        "Frencuencia mínima:",
                                        min = 1,  max = 50, value = 5),
                            sliderInput("maxWords",
                                        "Máximo numero de palabras:",
                                        min = 1,  max = 300,  value = 20),
                            actionButton("analisis", "Análisis")
                        ),
                        
                        # Create a spot for the barplot
                        mainPanel(
                          # Output: Tabset w/ plot, summary, and table ----
                          tabsetPanel(type = "tabs",
                                      tabPanel("Emociones", plotOutput("emociones") %>% withSpinner(color="#0dc5c1")),
                                      tabPanel("Valoración", plotOutput("valoracion") %>% withSpinner(color="#0dc5c1")),
                                      tabPanel("Nube", plotOutput("nube") %>% withSpinner(color="#0dc5c1"))
                          )
                        )
                    )
           ),
           tabPanel("Sobre la App",
                    p("La aplicación trata datos extraídos de Twitter. Los datos son extraídos al momento con una conexión 
                      establecida a la API de Twitter. Para replicar este proyecto, hay que crearse una cuenta de desarrollador
                      y conseguir las claves para poder extraer los datos. El código de la App esta alojado en el 
                      siguiente ", a("repositorio", href="https://github.com/gvalleg/MBD-FME", target="_blank"), "de GitHub."),
                    hr(), 
                    h3("Funcionamiento"),
                    p("El panel de usuario de la App cuenta con dos partes. La primera es la parte correspondiente a la 
                      extracción de los Tweets, mientras que la segunda va enfocada al último de los gráficos 
                      (nube de palabras):"),
                    h4("Obtención de los Tweets"),
                    tags$ul(
                      tags$li("Elección del número de Tweets que te quieres traer desde la fecha actual."),
                      tags$li("Traer los Tweets publicados por la cuenta en concreto, o traer los Tweets que se han escrito 
                      sobre la cuenta."),
                      tags$li("Elección de la cuenta en concreto que se quiere investigar."),
                      tags$li("Elección del idioma sobre el que se quiere realizar el análisis de sentimientos. Aquí aclarar que
                      la App con la opción 'Publicados sobre la cuenta', solo se trae los Tweets en ese idioma, pero si se 
                      elige los Tweets publicados de la cuenta no distingue por idioma.")
                    ),
                    h4("Gráfico de la nube"),
                    p("Los los sliders de esta parte son para jugar con el conjunto de los datos extraídos de Twitter:"),
                    tags$ul(
                      tags$li("Elección de la frecuencia mínima que tiene que tener una palabra para aparecer dentro del 
                      gráfico de la nube generado."),
                      tags$li("Elección del máximo número de palabras que aparecen en el gráfico.")
                    )
           ),
           tabPanel("Desarrollador",
                    p(a("Guillermo Valle Gutiérrez", href="https://www.linkedin.com/in/guillermo-valle-guti%C3%A9rrez-889b93158/", target="_blank"),style = "font-size:25px"),
                    p("e-mail: gvallegutierrez@gmail.com",style = "font-size:20px"))
           
)