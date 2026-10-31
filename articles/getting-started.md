# Getting started with Trash Wheel Explorer

## Who is this app for?

Trash Wheel Explorer is for environmental volunteers and readers
interested in cleaner waterways.

It helps users investigate this question:

**At selected Baltimore Trash Wheels and times, which rubbish categories
have the highest estimated item counts per recorded collection?**

Choose collection sites and years, then compare the chart, table and
written results.

## Install the package

Run these commands in your R console. Installation requires an internet
connection.

``` r

install.packages("remotes")

remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-syin0014-cloud"
)
```

## Launch the app

After installation, run:

``` r

library(syinexplore)

run_app()
```

The app opens in a browser or the RStudio Viewer. It uses data included
in the installed package, so it does not download a CSV when it starts.

To stop the app in RStudio, click Stop in the Console or press Esc.

## Choose collection records

Use the controls in the sidebar:

- **Trash Wheels:** choose one or more collection devices. Selecting
  several shows them in separate chart panels.
- **Year range:** move the two slider handles to choose the first and
  last years. Both end years are included.

Results update automatically when either selection changes.

Start with Mister Trash Wheel and 2022–2023. Then change the year range
to explore whether the average counts and leading rubbish categories
change. Select another Trash Wheel to compare its records.

## Read the summary cards

The three cards describe the current selection:

- **Devices with records:** the number of selected devices with matching
  collection records, out of all devices selected.
- **Collection records:** the number of matching collections. Each
  collection is counted once per device, rather than once for each
  rubbish category.
- **Years selected:** the chosen year or year range.

For example, “1 of 2” means that two devices were selected but only one
has collection records in the chosen period.

A collection record does not necessarily contain a count for every
rubbish category. Check the table for reporting coverage.

## Read the results

The **What your selection shows** section identifies the rubbish
categories with the highest mean counts for each selected Trash Wheel.
If categories share the highest mean, they are all included.

Use **Compare categories** to view the chart and **Check the values** to
view the table. Both tabs use the same selected records.

### Compare categories

Longer bars represent higher estimated item counts per recorded
collection. Each panel shows one Trash Wheel, and the panels use the
same horizontal scale.

“Not recorded” means no item counts were reported for that category in
the selection. It does not mean zero.

### Check the values

The table contains:

- **Trash Wheel:** the device that collected the rubbish.
- **Rubbish type:** one of seven categories in the source data. The app
  calls polystyrene “Foam items”.
- **Collections:** all selected collection records for that category.
- **Recorded collections:** selected records with a reported item count.
- **Mean items:** the average estimated item count among those recorded
  collections.

Check Recorded collections before comparing means, because reporting
coverage can differ across categories.

Collections and Recorded collections are equal when no item counts are
missing for that category in the selected records. Changing the years
can change both numbers while they remain equal.

For example, Gwynnda Trash Wheel in 2022–2023 has 171 collection records
for wrappers, but only 103 have a reported wrapper count. The mean uses
those 103 reported counts.

Missing counts are excluded from the mean, rather than treated as zero.
If all counts in a group are missing, the table shows “Not recorded” for
its mean.

Collection counts repeat across rubbish categories. Do not add the
category rows together to count distinct collections.

## Reproduce a summary in R

You can use the package’s summary function without opening the app:

``` r

example_summary <- summarise_data(
  data = trash_items,
  wheels = "Mister Trash Wheel",
  years = c(2022, 2023)
)

example_summary |>
  dplyr::mutate(
    trash_type = gsub("_", " ", trash_type)
  ) |>
  dplyr::select(
    trash_type,
    recorded_collections,
    mean_count
  ) |>
  knitr::kable(
    digits = 1,
    col.names = c(
      "Rubbish type",
      "Recorded collections",
      "Mean items"
    )
  )
```

| Rubbish type    | Recorded collections | Mean items |
|:----------------|---------------------:|-----------:|
| cigarette butts |                  119 |     3504.9 |
| plastic bottles |                  119 |     2179.7 |
| wrappers        |                  119 |     1261.3 |
| polystyrene     |                  119 |      209.9 |
| plastic bags    |                  119 |      203.5 |
| glass bottles   |                  119 |       19.7 |
| sports balls    |                  119 |       19.5 |

The rows are ordered from the highest mean to the lowest. The first row
therefore identifies the category with the highest average count for
this selection.

For Mister Trash Wheel in 2022–2023, cigarette butts have the highest
mean, at about 3,505 estimated items per recorded collection.

These values describe items per recorded collection. They are not yearly
totals or measures of environmental harm.

## What if there are no matching records?

If you remove all Trash Wheels, the app asks you to select at least one.
The device and collection cards show a dash until you make a selection.

To try a selection with no records, choose Gwynnda Trash Wheel and
2014–2015. The app explains that no records match and suggests changing
the years or selecting another device.

If only some selected devices have records, the coverage message
identifies those without records.

No matching records does not mean that the device collected zero
rubbish.

## Keep the limits in mind

Item counts are estimates based on sampling.

A mean per collection helps compare records without relying only on
total collection counts. However, it does not account for all
differences in collection conditions, locations or reporting coverage.

A higher mean does not by itself show a more polluted location or a
better-performing machine. Item counts also do not measure how harmful
each rubbish category is.

This historical dataset covers 2014–2023. It does not show current
collection totals or all rubbish remaining in the waterways.

## Data sources

The data were distributed by [TidyTuesday on 5 March
2024](https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05).

The original project is [Baltimore Healthy Harbor / Mr. Trash
Wheel](https://www.mrtrashwheel.com/).
