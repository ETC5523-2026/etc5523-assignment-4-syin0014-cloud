# Summarise rubbish counts for selected Trash Wheels and years

Filters collection records and calculates the mean estimated item count
for each selected Trash Wheel and rubbish category.

## Usage

``` r
summarise_data(data, wheels, years)
```

## Arguments

- data:

  A data frame with the columns in
  [trash_items](https://etc5523-2026.github.io/etc5523-assignment-4-syin0014-cloud/reference/trash_items.md).

- wheels:

  Character vector of full Trash Wheel names.

- years:

  Numeric vector of length two giving the first and last years to
  include. Both endpoints are included.

## Value

A tibble with one row per Trash Wheel and rubbish category:

- name:

  Full name of the Trash Wheel.

- trash_type:

  Rubbish category.

- collections:

  Number of selected collection records.

- recorded_collections:

  Number with a non-missing item count.

- mean_count:

  Mean estimated item count among recorded collections. NA if all counts
  in the group are missing.

## Details

Missing counts are excluded from the mean, rather than treated as zero.
A selection with no matching records returns zero rows. The mean
describes recorded collections, not a daily collection rate or the
amount of rubbish remaining in the water.

## Examples

``` r
summarise_data(
  trash_items,
  wheels = "Mister Trash Wheel",
  years = c(2022, 2023)
)
#> # A tibble: 7 × 5
#>   name               trash_type      collections recorded_collections mean_count
#>   <chr>              <chr>                 <int>                <int>      <dbl>
#> 1 Mister Trash Wheel cigarette_butts         119                  119     3505. 
#> 2 Mister Trash Wheel plastic_bottles         119                  119     2180. 
#> 3 Mister Trash Wheel wrappers                119                  119     1261. 
#> 4 Mister Trash Wheel polystyrene             119                  119      210. 
#> 5 Mister Trash Wheel plastic_bags            119                  119      204. 
#> 6 Mister Trash Wheel glass_bottles           119                  119       19.7
#> 7 Mister Trash Wheel sports_balls            119                  119       19.5
```
