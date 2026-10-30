library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(syinexplore)

# Use data included in the installed package.
collections <- syinexplore::trash_items

wheel_choices <- sort(unique(collections$name))
year_limits <- range(collections$year)

ui <- page_sidebar(
  title = "Trash Wheel Explorer",
  fillable = FALSE,

  theme = bs_theme(
    version = 5,
    primary = "#176B70"
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
      "Choose one or more Trash Wheels.",
      "Both selected years are included."
    ),

    helpText(
      "Means use collections with a reported item count.",
      "Missing counts are not treated as zero."
    )
  ),

  h2("Which types of rubbish are most common?"),

  p(
    "For environmental volunteers and readers interested in cleaner",
    "waterways. Explore which rubbish categories have the highest",
    "estimated item counts per recorded collection at selected",
    "sites and times."
  ),

  textOutput("selection_note"),

  plotOutput(
    "trash_plot",
    height = "600px"
  ),

  h3("Summary of selected records"),

  tableOutput("trash_table"),

  p(
    "Collections includes all selected records for a category.",
    "Recorded collections includes only records with a reported count.",
    "Mean items is calculated from those recorded counts."
  ),

  p(
    "Categories without recorded counts are omitted from the plot",
    "and have a missing mean in the table."
  ),

  p(
    "Counts are estimates. Collection histories and reporting coverage",
    "differ between Trash Wheels. These results do not directly measure",
    "local pollution levels or machine performance."
  ),

  p(
    "Source: Baltimore Healthy Harbor / Mr. Trash Wheel,",
    "distributed through TidyTuesday on 5 March 2024."
  )
)

server <- function(input, output, session) {

  summary_data <- reactive({

    validate(
      need(
        length(input$wheels) > 0,
        "Choose at least one Trash Wheel to see the results."
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
      ". Values are estimated items per recorded collection."
    )
  })

  output$trash_plot <- renderPlot({

    selected <- summary_data()

    validate(
      need(
        nrow(selected) > 0,
        "No collections match. Choose another wheel or a wider year range."
      )
    )

    plotted <- selected |>
      filter(!is.na(mean_count))

    validate(
      need(
        nrow(plotted) > 0,
        "Item counts were not recorded for this selection."
      )
    )

    ggplot(
      plotted,
      aes(x = mean_count, y = trash_type)
    ) +
      geom_col(
        fill = "#176B70",
        width = 0.7
      ) +
      facet_wrap(~name, ncol = 2) +
      scale_y_discrete(
        labels = function(x) gsub("_", " ", x)
      ) +
      labs(
        x = "Estimated items per recorded collection",
        y = NULL
      ) +
      theme_minimal(base_size = 13)
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
        trash_type = gsub("_", " ", trash_type),
        mean_count = round(mean_count, 1)
      ) |>
      rename(
        "Trash Wheel" = name,
        "Rubbish type" = trash_type,
        "Collections" = collections,
        "Recorded collections" = recorded_collections,
        "Mean items" = mean_count
      )
  }, rownames = FALSE, digits = 1)
}

shinyApp(ui, server)
