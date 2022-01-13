#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#    Week 5 day 3 Homework
library(CodeClanData)
library(shiny)
students
school_year <- unique(students$school_year)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("school year languages spoken"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
 
        selectInput(
          inputId = "year_input",
          label = "Select School Year",
          choices = school_year
          # choices = c("United States", "Soviet Union", "Germany",
          #   "Italy", "Great Britain")
        )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput(outputId = "distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    
    students %>% 
      filter(school_year == input$year_input) %>% 
      select(school_year,languages_spoken ) %>% 
      group_by(school_year) %>% 
      summarise(languages_spoken = mean(languages_spoken)) %>% 
      # select(school_year, languages_spoken) %>% 
      # filter(school_year == input$year_input) %>%
      ggplot() +
      aes(x = school_year, y = languages_spoken, fill = school_year) +  
      geom_col(show.legend = FALSE) +
      labs(
        x = "school year",
        y = "Average languages spoken"
      )
    
    
  })
   
 
}

# Run the application 
shinyApp(ui = ui, server = server)

