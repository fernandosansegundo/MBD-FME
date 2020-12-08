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
                    p("We used a data set consisting of 39 attributes from 11,158 players registered
                          in Pro Evolution Soccer 2019 (PES 2019), an electronic soccer game. The data set
                          was obtained from ", a("PES Data Base", href="http://pesdb.net/", target="_blank"),
                              "website using web scraping. This app is an interactive tool that allows any user to choose a soccer player from the game
                         and find the ten players most similar whith him. The similarity between the players is determined using a data mining technique
                         called", a("k-nearest neighbors", href="https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm", target="_blank"), ".",style = "font-size:25px"),
                    
                    hr(), 
                    p("The available player positions are:",style = "font-size:25px"),
                    p("GK: Goalkeeper",style = "font-size:15px;color: blue"),
                    p("CB: Center Back",style = "font-size:15px;color: blue"),
                    p("RB: Right Back",style = "font-size:15px;color: blue"),
                    p("LB: Left Back",style = "font-size:15px;color: blue"),
                    p("DMF: Defense Midfield",style = "font-size:15px;color: blue"),
                    p("CMF: Center Midfield",style = "font-size:15px;color: blue"),
                    p("AMF: Attacking Midfield",style = "font-size:15px;color: blue"),
                    p("RMF: Right Midfield",style = "font-size:15px;color: blue"),
                    p("LMF: Left Midfield",style = "font-size:15px;color: blue"),
                    p("RWF: Right Wing Forward",style = "font-size:15px;color: blue"),
                    p("LWF: Left Wing Forward",style = "font-size:15px;color: blue"),
                    p("SS: Second Striker",style = "font-size:15px;color: blue"),
                    p("CF: Counter Forward",style = "font-size:15px;color: blue"),
                    hr(), 
                    
                    p("The abbreviations used in the radar chart are:",style = "font-size:25px"),
                    
                    p("BAL: Unwavering Balance",style = "font-size:15px;color: blue"),
                    p("STM: Stamina",style = "font-size:15px;color: blue"),
                    p("SPE: Speed",style = "font-size:15px;color: blue"),
                    p("EXP: Explosive Power",style = "font-size:15px;color: blue"),
                    p("ATT: Attacking Prowess",style = "font-size:15px;color: blue"),
                    p("BCO: Ball Control",style = "font-size:15px;color: blue"),
                    p("DRI: Dribbling",style = "font-size:15px;color: blue"),
                    p("LPAS: Low Pass",style = "font-size:15px;color: blue"),
                    p("APAS: Air Pass (Lofted Pass)",style = "font-size:15px;color: blue"),
                    p("KPOW: Kicking Power",style = "font-size:15px;color: blue"),
                    p("FIN: Finishing",style = "font-size:15px;color: blue"),
                    p("PKIC: Place Kicking",style = "font-size:15px;color: blue"),
                    p("SWE: Swerve",style = "font-size:15px;color: blue"),
                    p("HEA: Header",style = "font-size:15px;color: blue"),
                    p("JUM: Jump",style = "font-size:15px;color: blue"),
                    p("PHY: Physical Contact",style = "font-size:15px;color: blue"),
                    p("BWIN: Ball Winning",style = "font-size:15px;color: blue"),
                    p("DEF: Defensive Prowess",style = "font-size:15px;color: blue"),
                    p("GOA: Goalkeeping",style = "font-size:15px;color: blue"),
                    p("GKC: GK Catch",style = "font-size:15px;color: blue"),
                    p("CLE: Clearing",style = "font-size:15px;color: blue"),
                    p("REF: Reflexes",style = "font-size:15px;color: blue"),
                    p("COV: Coverage",style = "font-size:15px;color: blue")
           ),
           tabPanel("Desarrollador",
                    p(a("Guillermo Valle Gutiérrez", href="https://www.linkedin.com/in/guillermo-valle-guti%C3%A9rrez-889b93158/", target="_blank"),style = "font-size:25px"),
                    p("e-mail: gvallegutierrez@gmail.com",style = "font-size:20px"))
           
)