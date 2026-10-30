library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(syinexplore)

# Use data included in the installed package.
collections <- syinexplore::trash_items

wheel_choices <- sort(unique(collections$name))
year_limits <- range(collections$year)

# Reader-friendly labels for the source categories.
trash_labels <- c(
  plastic_bottles = "Plastic bottles",
  polystyrene = "Foam items",
  cigarette_butts = "Cigarette butts",
  glass_bottles = "Glass bottles",
  plastic_bags = "Plastic bags",
  wrappers = "Wrappers",
  sports_balls = "Sports balls"
)

ui <- page_sidebar(
  title = "Trash Wheel Explorer",
  fillable = FALSE,

  theme = bs_theme(
    version = 5,
    primary = "#176B70"
  ),

  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "styles.css"
    )
  ),

  sidebar = sidebar(
    title = "Choose collection records",

    selectInput(
      "wheels",
      "Trash Wheels",
      choices = wheel_choices,
      selected = "Mister Trash Wheel",
      multiple = TRUE
    ),

    helpText(
      "Choose one or more collection devices.",
      "Select several to compare them in separate chart panels."
    ),

    sliderInput(
      "years",
      "Collection years",
      min = year_limits[1],
      max = year_limits[2],
      value = c(2022, 2023),
      step = 1,
      sep = ""
    ),

    helpText(
      "Move the two handles to choose the first and last years.",
      "Both end years are included. Results update automatically."
    ),

    helpText(
      "Years refer to when rubbish was collected.",
      "Changing the years changes the records used in the averages."
    )
  ),

  div(
    class = "app-intro",

    h2(
      "Which rubbish types have the highest average counts",
      "per collection?"
    ),

    p(
      "For environmental volunteers and readers interested in",
      "cleaner waterways. Compare estimated item counts at",
      "selected Baltimore Trash Wheels and times."
    )
  ),

  div(
    class = "finding",

    h3("What your selection shows"),

    textOutput("selection_note"),

    textOutput("takeaway"),

    div(
      class = "coverage-note",
      textOutput("coverage_note")
    )
  ),

  card(
    fill = FALSE,
    class = "result-card",

    card_header(
      "Compare rubbish categories",
      class = "section-heading"
    ),

    p(
      "Longer bars mean more estimated items per recorded collection.",
      "Each panel shows one Trash Wheel, using the same horizontal scale."
    ),

    div(
      class = "plot-wrap",

      plotOutput(
        "trash_plot",
        height = "650px"
      )
    ),

    p(
      class = "chart-note",
      "'Not recorded' means no item counts were reported for that",
      "category in this selection. It does not mean zero."
    )
  ),

  card(
    fill = FALSE,
    class = "result-card",

    card_header(
      "Check the values and reporting coverage",
      class = "section-heading"
    ),

    div(
      class = "table-wrap",
      tableOutput("trash_table")
    ),

    p(
      "Use Mean items to compare categories.",
      "Check Recorded collections before comparing means:",
      "some categories have fewer reported counts than others."
    )
  ),

  div(
    class = "methods-note",

    h3("What the fields mean"),

    tags$ul(
      tags$li(
        strong("Trash Wheel: "),
        "the named device collecting rubbish from a Baltimore waterway."
      ),

      tags$li(
        strong("Rubbish type: "),
        "one of seven categories recorded by the source.",
        "'Foam items' is the source's polystyrene category."
      ),

      tags$li(
        strong("Collections: "),
        "all selected collection records for that category,",
        "including records with a missing count."
      ),

      tags$li(
        strong("Recorded collections: "),
        "selected records with a reported item count."
      ),

      tags$li(
        strong("Mean items: "),
        "the average estimated item count among recorded collections.",
        "Missing counts are excluded rather than treated as zero."
      )
    ),

    p(
      "Collection counts repeat across rubbish categories.",
      "Do not add category rows together to count distinct collections."
    ),

    h3("Keep in mind"),

    p(
      "Counts are estimates based on sampling.",
      "The means describe selected recorded collections,",
      "not daily collection rates or all rubbish in the water."
    ),

    p(
      "Trash Wheels have different collection histories and reporting",
      "coverage. A higher mean does not by itself show a more polluted",
      "location or a better-performing machine."
    ),

    p(
      paste0(
        "This historical snapshot covers ",
        year_limits[1],
        " to ",
        year_limits[2],
        ". It does not show current collection totals."
      )
    ),

    p(
      "Sources: ",

      a(
        "TidyTuesday, 5 March 2024",
        href = paste0(
          "https://github.com/rfordatascience/tidytuesday/",
          "tree/main/data/2024/2024-03-05"
        ),
        target = "_blank"
      ),

      "; original data from ",

      a(
        "Baltimore Healthy Harbor / Mr. Trash Wheel",
        href = "https://www.mrtrashwheel.com/",
        target = "_blank"
      )
    )
  )
)

server <- function(input, output, session) {

  # One shared calculation supplies every output.
  summary_data <- reactive({

    validate(
      need(
        length(input$wheels) > 0,
        "Choose at least one Trash Wheel to see the results."
      ),

      need(
        length(input$years) == 2,
        "Choose a first and last collection year."
      )
    )

    summarise_data(
      data = collections,
      wheels = input$wheels,
      years = input$years
    )
  })

  output$selection_note <- renderText({

    selected <- summary_data()

    if (nrow(selected) == 0) {
      return(
        "No collections match. Choose another wheel or a wider year range."
      )
    }

    paste0(
      "Selected years: ",
      input$years[1],
      " to ",
      input$years[2],
      ". Means are calculated separately for each Trash Wheel."
    )
  })

  output$takeaway <- renderText({

    selected <- summary_data() |>
      filter(!is.na(mean_count))

    if (nrow(selected) == 0) {
      return(
        "No reported item counts are available. Try another wheel or period."
      )
    }

    leaders <- selected |>
      group_by(name) |>
      slice_max(
        mean_count,
        n = 1,
        with_ties = TRUE
      ) |>
      ungroup()

    results <- paste0(
      leaders$name,
      ": ",
      trash_labels[leaders$trash_type],
      " (",
      format(
        round(leaders$mean_count, 1),
        big.mark = ",",
        scientific = FALSE,
        trim = TRUE
      ),
      " estimated items per recorded collection)."
    )

    paste(
      "Highest recorded means by Trash Wheel, including ties:",
      paste(results, collapse = " ")
    )
  })

  output$coverage_note <- renderText({

    selected <- summary_data()

    if (nrow(selected) == 0) {
      return(
        "A period with no collection records is not evidence of zero rubbish."
      )
    }

    missing_wheels <- input$wheels[
      !(input$wheels %in% selected$name)
    ]

    message <- "Means use reported counts only."

    if (any(
      selected$recorded_collections < selected$collections
    )) {
      message <- paste(
        message,
        "Some category counts are missing.",
        "Check Recorded collections in the table."
      )
    }

    if (length(missing_wheels) > 0) {
      message <- paste(
        message,
        paste0(
          "No collection records in this period for: ",
          paste(missing_wheels, collapse = ", "),
          ". Try a wider year range to include them."
        )
      )
    }

    message
  })

  output$trash_plot <- renderPlot({

    selected <- summary_data()

    validate(
      need(
        nrow(selected) > 0,
        "No collections match. Choose another wheel or a wider year range."
      ),

      need(
        any(!is.na(selected$mean_count)),
        "No item counts were reported. Try another wheel or period."
      )
    )

    plot_data <- selected |>
      mutate(
        trash_type = factor(
          trash_type,
          levels = rev(names(trash_labels))
        )
      )

    ggplot(
      plot_data,
      aes(x = mean_count, y = trash_type)
    ) +
      geom_col(
        fill = "#176B70",
        width = 0.65,
        na.rm = TRUE
      ) +
      geom_text(
        data = plot_data |>
          filter(is.na(mean_count)),
        aes(
          x = 0,
          label = "Not recorded"
        ),
        hjust = 0,
        size = 3,
        colour = "#52605D"
      ) +
      facet_wrap(~name, ncol = 2) +
      scale_y_discrete(
        labels = trash_labels,
        drop = FALSE
      ) +
      scale_x_continuous(
        labels = function(x) {
          format(
            x,
            big.mark = ",",
            scientific = FALSE,
            trim = TRUE
          )
        }
      ) +
      labs(
        x = "Estimated items per recorded collection",
        y = NULL
      ) +
      theme_minimal(base_size = 13) +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold")
      )
  })

  output$trash_table <- renderTable({

    selected <- summary_data()

    validate(
      need(
        nrow(selected) > 0,
        "No collections match. Choose another wheel or a wider year range."
      )
    )

    selected |>
      mutate(
        trash_type = unname(trash_labels[trash_type]),
        mean_count = round(mean_count, 1)
      ) |>
      rename(
        "Trash Wheel" = name,
        "Rubbish type" = trash_type,
        "Collections" = collections,
        "Recorded collections" = recorded_collections,
        "Mean items" = mean_count
      )
  },
  rownames = FALSE,
  digits = 1,
  na = "Not recorded",
  striped = TRUE,
  width = "100%")
}

shinyApp(ui, server)
