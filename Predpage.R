mod_predmodule<- function(id){
    ns<-NS(id)
    fluidPage(
  fluidRow(
    mod_info(ns("currentrep")), mod_info(ns("recommendedrep")), mod_info(ns("savings")), mod_info(ns("reduction"))
  ),
  fluidRow(
    box(
      #background ="black",
      collapsible = F,
      width = 12,
      column(width = 8,
             h3("Expected results of optimization")),
      column(width = 4,
             selectizeInput(ns("compselectpred"),"Select Component",choices=c("comp1","comp2","comp4"), selected=c("comp2"))
             )
      
    )
  ),
  fluidRow(
    shinydashboardPlus::box(
      title = "Comparison of current and optimized scenario",
      footer=a("Estimated savings per year, all machines. Change parameters from controlpanel on top right corner of the page (gear icon)"),
      #background ="black",
      collapsible = F,
      width = 6,
          withSpinner(plotlyOutput(ns("costcompplot"), height = "300px"))
    ),
    shinydashboardPlus::box(
      title = "Optimization calculation",
      footer=a("The curves show cost based on replacement hours(x axis).Change parameters from controlpanel on top right corner of the page (gear icon)"),
      #background ="black",
      collapsible = F,
      width = 6,
      withSpinner(plotlyOutput(ns("costplot"), height = "300px"))
    )
  ),
  fluidRow(
    shinydashboardPlus::box(
      title = "Summary of items that need replacement",
      width = 6,
      footer=a("Predicted on dummy data. Prob means probability of failure"),
      withSpinner(plotlyOutput(ns("comrisknow"), height = "350px"))
    ),
    shinydashboardPlus::box(
      title = "Items that need replacement",
      #status = "warning",
      width = 6,
      footer=a("Predicted on dummy data. Select row and click on order button to order replacement (doesn'twork here)."),
        DTOutput(ns("resultcox")),
      actionButton("order","Order replacement")
    )
  )
)
}

mod_predmoduleServer <- function(id, pred.table=pred.table, repgaps= repgaps, compprice1= input$comp1price,
                               compprice2=input$comp2price, compprice3=input$comp3price,
                               compprice4=input$comp4price, prodrate=input$prodrate,
                               reptime=input$reptime){
  moduleServer(
    id,
    function(input,output,session){
      
      curhour<- reactive(filter(repgaps,comp==input$compselectpred)$rep_gap)
      
      observeEvent(input$compselectpred,{
        mod_infoServer("currentrep",curhour(), "Current", "red", "hammer","hours")
      })
      
      
      optitable<- reactive({
        pred.table%>%
          filter(comp==input$compselectpred)%>%
          mutate(replacements=8760/hours)%>%
          mutate(costofrep=replacements*ifelse(comp=="comp1",compprice1,
                                               ifelse(comp=="comp2",compprice2,
                                                      ifelse(comp=="comp3", compprice3,compprice4))))%>%
          mutate(failurechance=1-survival)%>%
          mutate(prodloss=failurechance*((prodrate*reptime)/60+ifelse(comp=="comp1",compprice1,
                                                                                  ifelse(comp=="comp2",compprice2,
                                                                                         ifelse(comp=="comp3", compprice3,compprice4)))))%>%
          mutate(totalcost=costofrep+prodloss)
      })
      
      rechour<- reactive(optitable()[which.min(optitable()$totalcost),2])
      
      observeEvent(c(input$compselectpred, prodrate, reptime), {
        mod_infoServer("recommendedrep",rechour(), "Recommended", "olive", "hammer","hours")
      })
      
      costcomp<- reactive({
        a=optitable()[which.min(optitable()$totalcost),2]
        b=repgaps[which(repgaps$comp==input$compselectpred),2]
        optitable()%>%
          filter(hours %in% c(a,b))%>%
          mutate(status=ifelse(hours == as.integer(a[1,1]), "recommended", "current"))%>%
          mutate(costofrep=costofrep*100, prodloss=prodloss*100)%>%
          mutate(totalcost=costofrep+prodloss)
      })
      savings<- reactive({
        round(costcomp()[which(costcomp()$status=="current"),8]-costcomp()[which(costcomp()$status=="recommended"),8],2)
      })
      
      observeEvent(c(input$compselectpred,prodrate, reptime), {
        mod_infoServer("savings",savings(), "Savings", "green", "money","$")
      })
      
      observeEvent(c(input$compselectpred,prodrate, reptime), {
        mod_infoServer("reduction",round(savings()*100/costcomp()[which(costcomp()$status=="current"),8],2), "Reduction", "green", "euro-sign","%")
      })
      
      output$costcompplot<- renderPlotly({
        
        costcomp()%>%
          select(costofrep,prodloss,status)%>%
          plot_ly(
            x=~status,
            y=~costofrep,
            type = "bar",
            opacity = 0.7,
            name = "Cost of scheduled maintenance"
          )%>%
          add_trace(
            y=~prodloss,
            name="Cost of failure"
          )%>%
          layout(
            #title= title,
            legend = list(orientation = 'h'),
            xaxis = list(title = "", color = "white"),
            yaxis = list(title = "Amount", color = "white"),
            plot_bgcolor = 'transparent',
            paper_bgcolor = 'transparent',
            barmode="stack"
          ) %>% config(displayModeBar = FALSE)
      })
      
      output$costplot<- renderPlotly({
        ay <- list(
          tickfont = list(color = "red"),
          #overlaying = "y",
          side = "right",
          title = ""
        )
        optitable()%>%
          mutate(costofrep=costofrep*100, prodloss=prodloss*100)%>%
          mutate(totalcost=costofrep+prodloss)%>%
          mutate(failures=failurechance*100)%>%
          filter(hours> 600 & hours<6000)%>%
          plot_ly(
            x=~hours,
            y=~costofrep,
            type = "scatter",
            mode = "lines+markers",
            opacity = 0.8,
            name = "Cost of scheduled maintenance"
          ) %>%
          add_trace(
            y=~prodloss,
            type = "scatter",
            mode = "lines+markers",
            opacity = 0.8,
            name = "Cost of failure"#,
            #yaxis="y2"
          )%>%
          layout(xaxis = list(title = " ", color = "white"),
                 yaxis = list(title = "Total cost", color = "white"),
                 legend = list(orientation = 'h'),
                 plot_bgcolor = 'transparent',
                 paper_bgcolor = 'transparent'#,
                 #yaxis2 = ay
          )%>% config(displayModeBar = FALSE)
      })
      
      
      
      output$resultcox <- renderDT({
        resultcox%>%
          select(-2)%>%
          datatable(
            rownames = FALSE,
            class = "compact",
            selection = list(mode="single",target = 'row', selected = c(1)),
            extensions = 'Responsive',
            style = "bootstrap",
            options = list(pageLength = 6)
          ) %>%
          formatStyle('comp1',
                      #color = styleInterval(c(0.5,0.75), c('black','yellow','red'))
                      background = styleColorBar(range(seq(0.5,1, by=0.01)), 'red')
          ) %>%
          formatStyle('comp2',
                      #color = styleInterval(c(0.5,0.75), c('black','yellow', 'red'))
                      background = styleColorBar(range(seq(0.5,1, by=0.01)), 'red')) %>%
          formatStyle('comp3',
                      #color = styleInterval(c(0.5,0.75), c('black','yellow', 'red'))
                      background = styleColorBar(range(seq(0.5,1, by=0.01)), 'red')) %>%
          formatStyle('comp4',
                      #color = styleInterval(c(0.5,0.75), c('black','yellow', 'red'))
                      background = styleColorBar(range(seq(0.5,1, by=0.01)), 'red')
          )
        
      })
      
      risktable<- reactive({
        resultcox%>%
          pivot_longer(4:7)%>%
          mutate(risk=case_when(
            value>= 0.75 ~ "Highest",
            value>=0.5 ~ "High",
            TRUE ~ "Low"
          ))%>%
          filter(risk %in% c("Highest","High"))
      })
      output$comrisknow<- renderPlotly({
        risktable()%>%
          group_by(name, risk)%>%
          summarise(count=n())%>%
          ungroup()%>%
          pivot_wider(names_from = risk, values_from = count)%>%
          plot_ly(
            x= ~Highest,
            y= ~ reorder(name, -Highest),
            type = "bar",
            opacity = 0.7,
            name = "Prob > 0.75"
          )%>%
          add_trace(
            x=~High,
            name="Prob > 0.5"
          )%>%
          layout(
            #title= title,
            legend = list(orientation = 'h'),
            xaxis = list(title = "#items"
                         , color = "white"
            ),
            yaxis = list(title = ""
                         , color = "white"
            ),
            plot_bgcolor = 'transparent',
            paper_bgcolor = 'transparent',
            barmode="stack"
          ) %>% config(displayModeBar = FALSE)
      })
      
      riskitemcounts<- reactive({
        risktable()%>%
          group_by(risk)%>%
          summarise(count=n())%>%
          ungroup()
      })
      
      output$highriskitemcount<- renderText({
        riskitemcounts()[which(riskitemcounts()$risk=="Highest"),2]
      })
      
      output$riskitemcount<- renderText({
        riskitemcounts()[which(riskitemcounts()$risk=="High"),2]
      })
    }
  )
}