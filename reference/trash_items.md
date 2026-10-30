# Rubbish collected by Baltimore's Trash Wheel family

Collection records from four Trash Wheels operating in Baltimore. Each
row describes one rubbish category in one dumpster collection. Item
counts are estimated using samples taken during collection.

## Usage

``` r
trash_items
```

## Format

A tibble with 6,951 rows and 7 variables:

- id:

  Short identifier for the Trash Wheel.

- name:

  Full name of the Trash Wheel.

- dumpster:

  Collection number reported by the source. Numbers can repeat within a
  Trash Wheel. Use `id`, `date`, and `dumpster` together to distinguish
  collection records.

- date:

  Date of collection, stored as a Date.

- year:

  Year of collection.

- trash_type:

  Category of rubbish counted.

- count:

  Estimated number of items; missing when not reported.

## Source

TidyTuesday:
<https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05>

Original data from Baltimore Healthy Harbor / Mr. Trash Wheel:
<https://www.mrtrashwheel.com/>

## Details

Missing counts do not mean zero. Collection histories and reporting
coverage differ between Trash Wheels. The records should not be used
directly to rank local pollution levels or machine performance.

## Examples

``` r
head(trash_items)
#> # A tibble: 6 × 7
#>   id     name               dumpster date        year trash_type       count
#>   <chr>  <chr>                 <dbl> <date>     <dbl> <chr>            <dbl>
#> 1 mister Mister Trash Wheel        1 2014-05-16  2014 plastic_bottles   1450
#> 2 mister Mister Trash Wheel        1 2014-05-16  2014 polystyrene       1820
#> 3 mister Mister Trash Wheel        1 2014-05-16  2014 cigarette_butts 126000
#> 4 mister Mister Trash Wheel        1 2014-05-16  2014 glass_bottles       72
#> 5 mister Mister Trash Wheel        1 2014-05-16  2014 plastic_bags       584
#> 6 mister Mister Trash Wheel        1 2014-05-16  2014 wrappers          1162
```
