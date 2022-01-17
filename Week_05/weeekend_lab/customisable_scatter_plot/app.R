#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(CodeClanData)
students_big <- read_csv("../data/students_big.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Reaction Time vs. Memory Game"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        radioButtons("colour_points",
                     "Colour of points",
                  choices = c(Blue = "#3891A6", Yellow = "#FDE74C", Red = "#E3655B")
                     ),
        
         sliderInput("trans_points",
                     "Transparency of points",
                     min = 0,
                     max = 1,
                     value = 0.7),
        selectInput(
               inputId = "shape_point",
               label   =  "Shape of points", 
               choices = c("Square", "Circle", "Triangle")
                       ),
        textInput(
          inputId = "title_input",
          label =  "Title of Graph"
          ),
        textInput("caption", "Caption", "Data Summary")
     
        
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     
     students_big %>% 
       ggplot() +
       aes(x = reaction_time, y = score_in_memory_game) +
       geom_point() +
       ggtitle("Reaction")
     
     })
}

# Run the application 
shinyApp(ui = ui, server = server)

