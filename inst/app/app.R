library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(syinexplore)

# Use data included in the installed package.
collections <- syinexplore::trash_items

wheel_choices <- sort(unique(collections$name))
year_limits <- range(collections$year)

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
    bg = "#F5F7F5",
    fg = "#203C39",
    primary = "#176B70"
  ),

  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "styles.css"
    )
  ),

  sidebar = sidebar(
    title = "Choose your records",
    width = 290,
    bg = "#FFFFFF",
    class = "filter-sidebar",

    p(
      class = "sidebar-intro",
      "Choose sites and years to compare the rubbish collected."
    ),

    h3(
      class = "filter-heading",
      "1. Collection sites"
    ),

    selectInput(
      "wheels",
      "Trash Wheels",
      choices = wheel_choices,
      selected = "Mister Trash Wheel",
      multiple = TRUE
    ),

    helpText(
      "Choose one or more devices.",
      "Each has its own chart panel."
    ),

    h3(
      class = "filter-heading",
      "2. Collection years"
    ),

    sliderInput(
      "years",
      "Year range",
      min = year_limits[1],
      max = year_limits[2],
      value = c(2022, 2023),
      step = 1,
      sep = ""
    ),

    helpText(
      "Move both handles to set the first and last years.",
      "Both end years are included. Results update automatically."
    ),

    div(
      class = "sidebar-note",
      strong("A useful starting point"),

      p(
        "Try Mister Trash Wheel in 2022–2023,",
        "then change the years or add another device."
      )
    )
  ),

  div(
    class = "app-intro",

    div(
      class = "intro-label",
      "BALTIMORE WATERWAYS"
    ),

    h2("What rubbish turns up in each collection?"),

    p(
      class = "intro-summary",
      "Compare the average estimated item counts for seven rubbish types",
      "at selected Trash Wheels and times."
    ),

    p(
      class = "audience-note",
      "For environmental volunteers and readers interested in",
      "cleaner waterways."
    )
  ),

  layout_columns(
    fill = FALSE,
    fillable = FALSE,
    class = "summary-grid",

    value_box(
      title = "Devices with records",
      value = textOutput("device_total"),

      p("Out of the devices you selected."),

      fill = FALSE,
      theme = "light",
      class = "summary-box"
    ),

    value_box(
      title = "Collection records",
      value = textOutput("collection_total"),

      p("Each collection counted once per device."),

      fill = FALSE,
      theme = "light",
      class = "summary-box"
    ),

    value_box(
      title = "Years selected",
      value = textOutput("year_total"),

      p("Both end years are included."),

      fill = FALSE,
      theme = "light",
      class = "summary-box"
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

  div(
    class = "results-section",

    navset_card_tab(
      id = "results_view",
      selected = "compare",

      wrapper = function(...) {
        card_body(
          ...,
          fillable = FALSE,
          fill = FALSE
        )
      },

      nav_panel(
        "Compare categories",
        value = "compare",

        h3(
          class = "panel-heading",
          "Average items per collection"
        ),

        p(
          class = "reading-guide",
          "Longer bars mean more estimated items per recorded collection.",
          "Each panel shows one Trash Wheel,",
          "using the same horizontal scale."
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
          "'Not recorded' means no item counts were reported",
          "for that category in this selection.",
          "It does not mean zero."
        )
      ),

      nav_panel(
        "Check the values",
        value = "values",

        h3(
          class = "panel-heading",
          "Values and reporting coverage"
        ),

        p(
          class = "reading-guide",
          "Use Mean items to compare categories.",
          "Check Recorded collections before comparing means:",
          "some categories have fewer reported counts."
        ),

        div(
          class = "table-wrap",
          tableOutput("trash_table")
        ),

        p(
          class = "chart-note",
          "Collection counts repeat across categories.",
          "Do not add category rows together",
          "to count distinct collections."
        )
      )
    )
  ),

  layout_columns(
    fill = FALSE,
    fillable = FALSE,
    class = "guide-grid",

    card(
      fill = FALSE,
      class = "guide-card",

      card_header("Read the fields"),

      tags$dl(
        tags$dt("Trash Wheel"),

        tags$dd(
          "The device collecting rubbish from a Baltimore waterway."
        ),

        tags$dt("Rubbish type"),

        tags$dd(
          "One of seven source categories.",
          "'Foam items' is polystyrene."
        ),

        tags$dt("Collections"),

        tags$dd(
          "All selected records for that category,",
          "including missing counts."
        ),

        tags$dt("Recorded collections"),

        tags$dd(
          "Selected records with a reported item count."
        ),

        tags$dt("Mean items"),

        tags$dd(
          "The average estimated count among recorded collections.",
          "Missing counts are excluded, not treated as zero."
        )
      )
    ),

    card(
      fill = FALSE,
      class = "guide-card limits-card",

      card_header("Keep the limits in mind"),

      p("Counts are estimates based on sampling."),

      p(
        "The means describe selected recorded collections,",
        "not daily collection rates or all rubbish in the water."
      ),

      p(
        "Trash Wheels have different collection histories",
        "and reporting coverage.",
        "A higher mean does not by itself show a more polluted location",
        "or a better-performing machine."
      ),

      p(
        paste0(
          "This historical snapshot covers ",
          year_limits[1],
          " to ",
          year_limits[2],
          ". It does not show current collection totals."
        )
      )
    )
  ),

  div(
    class = "source-note",

    strong("Data sources: "),

    a(
      "TidyTuesday, 5 March 2024",
      href = paste0(
        "https://github.com/rfordatascience/tidytuesday/",
        "tree/main/data/2024/2024-03-05"
      ),
      target = "_blank",
      rel = "noopener noreferrer"
    ),

    " · ",

    a(
      "Baltimore Healthy Harbor / Mr. Trash Wheel",
      href = "https://www.mrtrashwheel.com/",
      target = "_blank",
      rel = "noopener noreferrer"
    )
  )
)

server <- function(input, output, session) {

  # One shared calculation supplies the outputs.
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

  output$device_total <- renderText({

    if (
      length(input$wheels) == 0 ||
      length(input$years) != 2
    ) {
      return("—")
    }

    selected <- summary_data()

    paste(
      length(unique(selected$name)),
      "of",
      length(input$wheels)
    )
  })

  output$collection_total <- renderText({

    if (
      length(input$wheels) == 0 ||
      length(input$years) != 2
    ) {
      return("—")
    }

    # Keep one collection count per device.
    # Category rows repeat that same count.
    counts <- summary_data() |>
      distinct(name, collections)

    format(
      sum(counts$collections),
      big.mark = ",",
      scientific = FALSE,
      trim = TRUE
    )
  })

  output$year_total <- renderText({

    if (length(input$years) != 2) {
      return("—")
    }

    if (input$years[1] == input$years[2]) {
      return(as.character(input$years[1]))
    }

    paste(
      input$years[1],
      input$years[2],
      sep = "–"
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

    if (
      any(
        selected$recorded_collections < selected$collections
      )
    ) {
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
      aes(
        x = mean_count,
        y = trash_type
      )
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
      facet_wrap(
        ~name,
        ncol = 2
      ) +
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
      theme_minimal(
        base_size = 13
      ) +
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
        trash_type = unname(
          trash_labels[trash_type]
        ),

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
