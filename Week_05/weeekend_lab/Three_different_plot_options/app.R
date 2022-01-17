#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Three different plot options"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        radioButtons( "plot_type_input",
                      "Plot Type",
                      choices = c("Bar","Horizontal Bar","Stacked Bar")
                    
                      
        )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  generate_plot <- reactive({
    students_big %>% 
      ggplot() +
      aes(x = handed,fill = gender) 
  })
   
   output$distPlot <- renderPlot({ 
     
     if(input$plot_type_input == "Bar")
       {
       generate_plot() +
         geom_bar(position = position_dodge())
     } 
     else if(input$plot_type_input == "Horizontal Bar"){
       generate_plot() +
         geom_bar(position = position_dodge())+
         coord_flip()
     }
     else 
       if(input$plot_type_input == "Stacked Bar"){
         generate_plot() +
           geom_bar()
         
       }
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

