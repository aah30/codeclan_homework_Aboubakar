library(shiny)
library(leaflet)

{
  col_feed_con_raw_01_coords <- data.frame(lng = rep(sample(seq(from=-101, to=-99,by=.4), 100, replace = T),3),
                                           lat = rep(sample(seq(from=39, to=41,  by=.4), 100, replace=T),3),
                                           service_type = sample(LETTERS[1:4], 300, replace = T)
  )
  
  ser_types <- sort(unique(col_feed_con_raw_01_coords$service_type) )
  
  colorList4  <- c('forestgreen',
                   '#ee0000',
                   'orange',
                   'cornflowerblue'
  )
  
  
  ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  checkboxGroupInput("service_type",
                                     "Choose service:"
                                     ,choiceNames  = ser_types
                                     ,choiceValues = 1:4
                                     ,selected = 1:4
                  )
                  ,checkboxInput("allnone",
                                 "All/None"
                                 ,value=TRUE)
    )
  )
  
  server <- function(input, output, session) {
    
    print(paste0("Running in: ",
                 isolate(session$clientData$url_hostname),":"
                 ,isolate(session$clientData$url_port))
    )
    
    observeEvent(input$allnone,{
      
      if(input$allnone){
        updateCheckboxGroupInput(session,"service_type",selected = 1:4)
      } else {
        updateCheckboxGroupInput(session,"service_type"
                                 ,choiceNames=ser_types
                                 ,choiceValues = 1:4
                                 ,selected = NULL)
      }
    })
    
    filteredColors <- reactive({
      colorList4[as.numeric(input$service_type) ]
    })
    
    filteredService <- reactive({
      ser_types[as.numeric(input$service_type) ]
    })
    
    filteredData <- reactive({
      col_feed_con_raw_01_coords[which(col_feed_con_raw_01_coords$service_type %in%
                                         filteredService() ), ]
    })
    
    colors<-colorFactor(palette = colorList4
                        ,ser_types
    )
    
    mycolors <- reactive({
      colorFactor(palette = filteredColors()
                  ,filteredService()
      )
    })
    
    JSfunction <- JS("function (cluster) {
                     var childCount = cluster.getChildCount();
                     if (childCount < 100) {
                     c = 'rgba(255, 150, 150, 0.5);'
                     } else if (childCount < 500) {
                     c = 'rgba(255, 100, 100, 0.5);'
                     } else {
                     c = 'rgba(255, 50, 50, 0.5);'
                     }
                     return new L.DivIcon({ html: '<div style=\"background-color:'+c+'\"><span>' + childCount + '</span></div>',
                     className: 'marker-cluster'
                     
                     });
  }"
  )
    
    output$map <- renderLeaflet({
      
      pal<-colors
      
      leaflet(data = col_feed_con_raw_01_coords
              ,options = leafletOptions(preferCanvas = TRUE) )  %>%
        addTiles(options = providerTileOptions(
          updateWhenZooming = FALSE,
          updateWhenIdle = FALSE) 
        ) %>% setView(lng = -100 
                      ,lat = 40  
                      ,zoom = 9
        ) %>% addCircleMarkers(data = col_feed_con_raw_01_coords
                               ,~lng
                               ,~lat
                               ,clusterOptions = markerClusterOptions(
                                 iconCreateFunction= JSfunction
                                 ,spiderfyOnMaxZoom = TRUE
                               )
                               , fillColor   = ~pal(service_type)
                               , stroke      = FALSE
                               , fillOpacity = 0.7
        ) # aCM
      
    })
    
    observeEvent(c(input$service_type, input$allnone),{
      
      if(nrow(filteredData() )==0){
        filOrAll <- col_feed_con_raw_01_coords
        pal <- colors
      } else {
        filOrAll<- filteredData()
        pal <- mycolors()
      }
      output$map <- renderLeaflet({
        
        leaflet(data = filOrAll
                
        )  %>% addTiles(
          options = providerTileOptions(
            updateWhenZooming = FALSE,      # map won't update tiles until zoom is done
            updateWhenIdle = FALSE)
        ) %>%
          addCircleMarkers(data = filOrAll
                           ,~lng
                           ,~lat
                           ,clusterOptions = markerClusterOptions(
                             iconCreateFunction=JSfunction
                             ,spiderfyOnMaxZoom = TRUE
                           )
                           , fillColor   = ~pal(service_type)
                           , stroke      = FALSE
                           , fillOpacity = 0.7
          ) # aCM
      })
      
      
    })
    
    observe({
      
      if(length(input$service_type)>0 & nrow(filteredData()>0 ) ) {
        
        proxy <- leafletProxy("map", data = filteredData() )
        
        pal <- mycolors()
        
        proxy %>% clearControls()
        proxy %>% addLegend('bottomright',
                            pal = pal,
                            values = ~service_type,
                            title = 'Services:',
                            opacity = 1)
        
      }
    })
}
  }

shinyApp(ui, server)