library(shiny)
library(shinydashboardPlus)
library(shinydashboard)
library(plotly)
library(dplyr)
library(stringr)
library(shinycssloaders)
library(feather)
library(DT)
library(lubridate)
library(shinymanager)
library(sever)
library(tidyr)
library(shinyLP)
library(waiter)
library(shinythemes)


source("dataset.R")
source("mod_info.R")
source("mod_linechart.R")
source("mod_linechartnofill.R")
source("mod_mainchart.R")
source("mod_barline.R")
source("mod_horizontalmainchart.R")
source("mod_gauge.R")
source("mod_description.R")
source("Controlpanel.R")
source("sidebars.R")
source("explorepage.R")
source("Predpage.R")
source("macpage.R")
source("helper.R")
source("homepage.R")




# Define UI for application that draws a histogram
ui <-shinydashboardPlus::dashboardPage(
    skin = "midnight",
    title= "Niti-run",
    preloader = list(waiter = list(html = spin_1(), color = "#333e48"), duration = 10),
    header = shinydashboardPlus::dashboardHeader(title = tags$a(href='http://asitavsen.com',
                                                                tags$img(src='faviconwhite.png'))),
    sidebar = shinydashboardPlus::dashboardSidebar(minified = TRUE, collapsed = T,
                                                   admin.sidebar
                                                   ),
    body = dashboardBody(
        tabItems(
            tabItem(
                "homepage",
                homepage
            ),
            tabItem(
                "explore",
                mod_exploremodule("incidents")
            ),
            tabItem(
                "predict",
                mod_predmodule("prediction")
            ),
            tabItem(
                "machine",
                mod_macmodule("machine")
            )
        )
        
    ),
    controlbar = controlpanel
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    mod_exploreServer("incidents",timeseriesdata, trainfileset)
    observeEvent( c(input$comp1price,input$comp2price,input$comp3price,input$comp4price, input$prodrate, input$reptime),
        {
        mod_predmoduleServer("prediction", pred.table=pred.table, repgaps= repgaps, compprice1= input$comp1price,
                             compprice2=input$comp2price, compprice3=input$comp3price,
                             compprice4=input$comp4price, prodrate=input$prodrate,
                             reptime=input$reptime)
    })
    
    mod_macmoduleServer("machine",telemetry)
    waiter_hide()
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
