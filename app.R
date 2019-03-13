# Paquetes para que ejecute la aplicación adecuadamente
library(shiny)
library(leaflet)
library(rgdal)
library(tidyverse)
library(plotly)
library(DT)

# Definir el UI (User Interface)
ui <- fluidPage(
   
   # Título de la aplicación
   titlePanel("Taller de Shiny"),
   
   # Diseño de la aplicación (Barra Lateral - Panel Principal)
   # Barra lateral (columna a la izquierda) 
   sidebarLayout(
      sidebarPanel(width = 3,
        p("Los datos corresponden al informe basado en una encuesta historica del estado de la felicidad global, y han sido tomados de ", a("Kaggle", href = "https://www.kaggle.com") ,". Puedes revisar un poco mas sobre la info en el siguiente ", a("enlace", href = "https://www.kaggle.com/unsdsn/world-happiness"),"."),
        hr(),
        fileInput(inputId = "filedata", label = "Cargar datos. Elija el archivo .csv",
                  accept = c(".csv")),
        selectInput(inputId = "region", label = "Seleccionar region",
                    choices = c("Australia and New Zealand", "Central and Eastern Europe",
                                "Eastern Asia", "Latin America and Caribbean",
                                "Middle East and Northern Africa", "North America",
                                "Southeastern Asia", "Southern Asia", 
                                "Sub-Saharan Africa","Western Europe")),
        h5("Seleccionar si desea ver los datos"),
        checkboxInput(inputId = "mostrarData",
                      label = "Mostrar los datos",
                      value = FALSE),
        hr(),
        p("El mapa interactivo ha sido elaborado gracias al paquete", a("leaflet", href = "https://rstudio.github.io/leaflet/"),"."),
        hr(),
        p("App construida con", a("Shiny", href = "http://shiny.rstudio.com")),
        img(src = "LogoShiny.png", width = "70px", height = "80px"),
        hr(),
        p("Elaborado por", a("Vilma Romero", href = "https://vilmaromero.github.io"), "para:"),
        img(src = "LogoRLadiesLima.png", width = "70px", height = "80px"),
        img(src = "LogoEventoUPC.png", width = "150px", height = "80px")
        ),
      
      # Diseño del Panel Principal 
      # Espacio para mostrar los resultados
      mainPanel(
        h4("Mapa del Score de Felicidad"),
        leafletOutput(outputId = "mapa"),
        br(),
        plotlyOutput("PorRegion"),
        br(),
        tableOutput(outputId = "infoRegion"),
        br(),
        DTOutput(outputId = "info")
      )
   )
)


# Definir el Server (servidor)
server <- function(input, output) {
   # Lectura del archivo que contiene los datos
   datos <- reactive({read.csv(input$filedata$datapath)})
   
   # Código para la elaboración del mapa interactivo
   output$mapa <- renderLeaflet({
     world_spdf <- readOGR(dsn = getwd() , layer = "TM_WORLD_BORDERS_SIMPL-0.3")
     
     dataSel <- datos()
     
     # Manipulación de datos
     paises_mundi <- world_spdf@data$NAME  %in% dataSel$Country
     nombre <- sort(as.character(world_spdf@data$NAME[paises_mundi]))
     paises_happy <- dataSel$Country %in% world_spdf@data$NAME 
     
     # Matriz felicidad (ordenada)
     felicidad <- dataSel %>% 
       select(Country, Happiness.Score) %>% 
       filter(paises_happy) %>% 
       arrange(Country)
     
     felicidadTotal <- world_spdf@data
     indices <- rep(NA, dim(felicidad)[1])
     for (i in 1:dim(felicidad)[1]) {
       indices[i] <- which(felicidad$Country[i] == felicidadTotal$NAME)
     }
     
     felicidadTotal$Happiness[indices] <- felicidad$Happiness.Score 
     
     labels <- sprintf(
       "<strong>%s</strong><br/>%g Score de Felicidad",
       felicidadTotal$NAME, felicidadTotal$Happiness) %>% 
       lapply(htmltools::HTML)
     
     pal <- colorNumeric("YlGn", felicidadTotal$Happiness)
     
     leaflet(world_spdf) %>%
       setView(lat = 0, lng = 0, zoom = 2) %>% 
       addTiles() %>% 
       addPolygons(fillColor = ~pal(felicidadTotal$Happiness),
                   weight = 1,
                   opacity = 0.5,
                   color = "white",
                   dashArray = "3",
                   fillOpacity = 0.7,
                   highlight = highlightOptions(weight = 4,
                                                color = "#666",
                                                dashArray = "",
                                                fillOpacity = 0.7,
                                                bringToFront = TRUE),
                   label = labels,
                   labelOptions = labelOptions(style = list("font-weight" = "normal", 
                                                            padding = "3px 8px"),
                                               textsize = "15px",
                                               direction = "auto")) %>%
       addLegend(pal = pal, values = ~felicidadTotal$Happiness, opacity = 0.7, 
                 title = "Score de Felicidad", position = "bottomright")
   })  
   
   output$PorRegion <- renderPlotly({
     dataSel <- datos()
     AgrupadoRegion <- ggplot(dataSel, aes(x = Region, y = Happiness.Score)) +
       geom_boxplot(color = "black",fill = "#88398A", alpha = 0.5) +
       ylab("Happiness Score") + xlab(" ") + coord_flip() +
       ggtitle("Comportamiento del Score de Felicidad por Region")
     
     ggplotly(AgrupadoRegion)
   })
   
   output$infoRegion <- renderTable({
     dataSel <- datos()

     dataSel %>% 
       group_by(Region) %>% 
       summarise(Cantidad = n(), Prom.Happiness = mean(Happiness.Score), 
                 Prom.Economy = mean(Economy..GDP.per.Capita.),
                 Prom.Family = mean(Family),
                 Prom.Health = mean(Health..Life.Expectancy.),
                 Prom.Freedom = mean(Freedom),
                 Prom.Trust = mean(Trust..Government.Corruption.),
                 Prom.Generosity = mean(Generosity)) %>% 
       filter(Region == "Southeastern Asia")
   })
   
   output$info <- renderDT(if(input$mostrarData){datos()})
   
}


# Ejecutar el app de manera local
shinyApp(ui = ui, server = server)

