
library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Monthly Airline Passenger Numbers"),
  
  sidebarLayout(
    sidebarPanel(
      
      #input in the format of drop-down menu with months
      
      selectInput("Month_Name", label = "Choose Month", 
                  choices = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), 
                  selected = NULL, multiple = FALSE,
                  selectize = TRUE, width = NULL, size = NULL)
      
    ),
    
    #output contains text and plot defined in server.R
    
    mainPanel(
      htmlOutput("pred"),
      plotOutput("pred_plot")
    )
  )
))

