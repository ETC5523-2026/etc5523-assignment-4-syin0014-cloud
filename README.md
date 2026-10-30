
# syinexplore

`syinexplore` contains prepared Trash Wheel data, a summary function
and an interactive Shiny app.

## Documentation website

[Read the package documentation and user guide](https://etc5523-2026.github.io/etc5523-assignment-4-syin0014-cloud/)

## Purpose and intended users

Trash Wheel Explorer is designed for environmental volunteers and
readers interested in cleaner waterways.

The app helps users investigate this question:

**At selected collection sites and times, which rubbish categories
have the highest estimated item counts per recorded collection?**

Users can select Trash Wheels and years. A comparison plot and summary
table update using the same selected records.

## Data

The package includes `trash_items`, prepared from the Trash Wheel
Collection Data distributed by TidyTuesday on 5 March 2024.

The original data come from Baltimore Healthy Harbor / Mr. Trash Wheel.
The prepared table contains 6,951 rows and seven columns. Each row
represents one rubbish category in one dumpster collection.

- [TidyTuesday data and descriptions](https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05)
- [Original project: Mr. Trash Wheel](https://www.mrtrashwheel.com/)

Item counts are estimates. Missing counts are not zero. Trash Wheels
have different collection histories and reporting coverage, so these
records should not be used directly to rank pollution levels or
machine performance.

## Installation

Install the package from GitHub:

```r
install.packages("remotes")

remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-syin0014-cloud"
)
```

## Launch the app

```r
library(syinexplore)

run_app()
```

Choose one or more Trash Wheels and a range of years. Longer bars
indicate higher estimated item counts per recorded collection.

The table reports all selected collection records, the number with
a reported count, and the mean calculated from those reported counts.
A missing mean indicates that no counts were reported for that group.

## Use the summary function

```r
library(syinexplore)

summarise_data(
  data = trash_items,
  wheels = "Mister Trash Wheel",
  years = c(2022, 2023)
)
```

`summarise_data()` filters the records and returns a summary for each
selected Trash Wheel and rubbish category. The app uses this function.

## Reproduce the package data

From the repository root, run:

```r
source("data-raw/prepare_data.R")
```

The script reads the specified TidyTuesday CSV file, cleans the column
names, converts collection dates and reshapes item counts into a long
table. It saves the result as `data/trash_items.rda`.

Running the preparation script requires an internet connection.
Launching the app uses the prepared package data and does not read
an external CSV file.

## Licence and attribution

Package code is provided under the MIT licence; see `LICENSE.md`.

The data originate from Baltimore Healthy Harbor / Mr. Trash Wheel
and are distributed through TidyTuesday. Source information is
preserved in the dataset documentation. The code licence does not
replace the source data's terms.

## AI-use declaration

ChatGPT assisted with planning the package structure, drafting and
explaining the R and Shiny code, and drafting documentation.
I take responsibility for the final code, results and documentation.
