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
   titlePanel("Height and Arm Span vs Age"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
     fluidRow( 
       column(1,
              ),
       column(6,
               radioButtons( "age_input",
                             "Age",
                             choices = unique(students_big$ageyears),
                             inline = TRUE
                             
               ) ),
       column(5,
              actionButton("uptade",
                           "Update Age!")
       )
     ),
     fluidRow(
       column(6,
              plotOutput("first_graph")
                     ),
              column(6,
                     plotOutput("second_graph")
                     
                     )
              )

 
 
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  filtered_data <- eventReactive(input$uptade,{
    students_big %>% 
      filter(ageyears == input$age_input) %>% 
      ggplot() 
  })
  
  
   output$first_graph <- renderPlot({ 
     filtered_data() +
       aes(x = height) +
       geom_histogram()
     
   })
   
   output$second_graph <- renderPlot({ 
     filtered_data() +
       aes(x = arm_span) +
       geom_histogram()
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

