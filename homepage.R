homepage<-
  fluidPage(
    theme = shinytheme("cyborg"),
    fluidRow(
      jumbotron("Predictive Maintenance Dashboard", "Replacement schedules defined by OEMs is not customized to your circustances. 
                You may be spending a lot more than needed; either in replacements or in failures. Do you want to keep losing money in maintenance?
                If not, feel free to get in touch!", 
                button = F)
    ),
    fluidRow(
      column(
        width = 6,
        panel_div(class_type = "primary", panel_title = "What does the dashboad contain?",
                  content = "The dashboard contains sections of exploration and prediction. In exploration, one can start form an overall
                summary of status quo and then drill down to the machine level to undertand \"What happened\". In prediction, for each component
                an optimized replacement hour is calculated. The costs (recommended replacement hours vs. current practice) are compared and 
                estimated savings are calculated. A list of items that may need replacement are also shown."),
        panel_div(class_type = "primary", panel_title = "What is the data about?",
                  content = "The data is from real life. It contains details from 100 machines of one of the four models (model1, model2,..,model4). Each machine
                contains four components (comp1, comp2,..,comp4. Sceduled and unscheduled (failures) replacement history is also provided.
                Hourly rotation,vibration, pressure and voltage is recorded in telemetry data. We used one year's data."),
        panel_div(class_type = "primary", panel_title = "How use the dashboard?",
                  content = "Simply go to the relevant tabs by clicking on the menu in the sidebar. You can control the price of parts and machine
                from the control panel. The control panel is located on the right upper conter and can be accessed by clicking on the gear button."),
        panel_div(class_type = "primary", panel_title = "Why not use other dashboarding tools?",
                  content = "Sure you can. We can build the predictive model and provide data. The predicted data and the explorative data
                  (For e.g. maintenance data) can be shown using any dashboarding tool. However, we would recommed shiny because
                  it is open source and you don't need to pay a monthly fee for the dashboarding tool itself. Which you need to, when you are 
                  using other proprietory tools. Free and very cheap hosting options are also available. But, most importantly, if you think of
                  the pinnacle of customized dashboard, you would think Shiny. The customization options and vizualization options are simply
                  unmatched."),
        panel_div(class_type = "primary", panel_title = "Who am I?",
                  content = "I'm a data scientist and commercial strategist. You may find more about me at my website www.asitavsen.com")
      ),
      
      column(
        width = 6,
        panel_div(class_type = "primary", panel_title = "What is it all about?",
                  content = "Manufacturers do not know in which circumstance is your equipment running. When they recommend a replacement
                schedule it is very generic. For e.g. if you are running your machine in desert, you cannot expect it to behave in 
                the same manner, had it beed running on sea. 
                We can help you calculate the optimum replacement hours based on evidence from data and a little math. It will either increase
                the replacement hours, or increase the machine reliability. Either way, it saves you money."),
        panel_div(class_type = "primary", panel_title = "How does it work?",
                  content = "We take your telemetry, maintenance and failure data to predict probability of failure at a given time. Then, taking
                into consideration the replacement cost and cost of machine failure, we do some math to optimize."),
        panel_div(class_type = "primary", panel_title = "How accurate are the prediction?",
                  content = "We can only answer this question accurately after analyzing your data. However, if this helps to build
                your confidence, some of the algorithm we use are used even in medical science!"),
        panel_div(class_type = "primary", panel_title = "What are the risks?",
                  content = "Well, the algorithm predicts based on past events that are recorded. If a failure occures due to reasons that
                were never recorded before or some unforeseen reason, that can obviously not be predicted. Excluding these situations,
                we can provide a quantified risk, after analysis of data."),
        panel_div(class_type = "primary", panel_title = "How much time does it take?",
                  content = "It depends on the complexity of the problem and the level of customization and functions. In certain situations,
                  a minimum viable product can be built even within a couple of weeks to a month.")
      )
      
    )
  )