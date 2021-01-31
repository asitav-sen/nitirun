mytimeItem <-
  function (...,
            icon = NULL,
            color = NULL,
            time = NULL,
            title = NULL,
            border = F,
            footer = NULL,
            image=NULL)
  {
    data <- paste0(..., collapse = "<br><br>")
    cl <- "fa fa-"
    if (!is.null(icon))
      cl <- paste0(cl, icon)
    if (!is.null(color))
      cl <- paste0(cl, " bg-", color)
    itemCl <- "timeline-header no-border"
    if (isTRUE(border))
      itemCl <- "timeline-header"
    shiny::tags$li(
      shiny::tags$i(class = cl),
      shiny::tags$div(
        class = "timeline-item",
        shiny::tags$span(class = "time", shiny::icon("clock-o"), time),
        shiny::tags$h3(class = itemCl, title),
        shiny::tags$div(class = "timeline-body",
                        HTML(data)),
        shiny::tags$div(class = "timeline-footer", footer),
        shiny::tags$div(class="image", image)
      )
    )
  }