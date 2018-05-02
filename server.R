library(shiny)
library(ggplot2)
library(forecast)

#loading one of the standard datasets, containing monthly passenger numbers (in thousands) from 1949 to 1960

DF_AirPassengers<-as.data.frame(AirPassengers)
names(DF_AirPassengers)[1]<-"Monthly_Passengers"

#converting data into time series format

ts_AirPassengers<-ts(DF_AirPassengers$Monthly_Passengers,start=c(1949,1),frequency=12)

#creating dataframe with months

month_choice<-as.data.frame(c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))
names(month_choice)[1]<-"Month_Name"

#fitting the model using arima method

model_fit <- arima(ts_AirPassengers, c(0, 1, 1),seasonal = list(order = c(0, 1, 1), period = 12))


shinyServer(function(input, output) {
  
  #the app will predict number of passengers for selected month (for year 1961 - next year after last observation in dataset)
  #reactive function below receives name of month selected by user as an input, and returns number of the month (from 1 to 12)
  
  selectStep<-reactive ({
    month<-input$Month_Name
    h<-which(month_choice$Month_Name == month)
    return(h)
  })
  
  #number h is used to produce the prediction for selected month
  #below code returns predictied number of passengers in the text format, and also a plot with the previous time series + prediction
  
  output$pred <- renderText({
    h<-selectStep()
    prediction <- forecast(model_fit, h = h)
    paste0("Prediction for selected month: ",round(prediction[[4]][length(prediction[[4]])],digits=0))
  })
   
  output$pred_plot <- renderPlot({
    h<-selectStep()
    prediction <- forecast(model_fit, h = h)
    autoplot(prediction)
  })
  
})
