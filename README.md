
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FeatherArray

<!-- badges: start -->
<!-- badges: end -->

`FeatherArray` makes it possible to use a
[feather](https://cran.r-project.org/package=feather) file as a
(read-only)
[DelayedArray](https://bioconductor.org/packages/DelayedArray/) backend.

## Installation

You can install the development version of `FeatherArray` like so:

``` r
devtools::install(MalteThodberg/FeatherArray)
```

## Basic usage for matrix-like `feather` files

We load both the `feather` and `FeatherArray` packages:

``` r
library(feather)
library(FeatherArray)
```

Let’s first simulate a large-ish matrix and write it to a feather file:

``` r
large_mat <- matrix(rep(rnorm(1e6), 50), ncol = 50)

feather_fname <- tempfile(fileext = ".feather")
write_feather(as.data.frame(large_mat), path = feather_fname)
```

We can then wrap the `feather` file in a `DelayedArray`. This doesn’t
load any data into memory yet, so it takes up very little memory:

``` r
fa <- FeatherArray(feather_fname)

object.size(fa)
#> 5264 bytes
```

``` r
object.size(large_mat)
#> 400000216 bytes
```

All the regular read-only operations on `DelayedArray` objects are
supported, e.g.:

``` r
fa[5:10, c(3,40, 50)]
#> <6 x 3> DelayedMatrix object of type "double":
#>              V3        V40        V50
#> [1,] -1.5980131 -1.5980131 -1.5980131
#> [2,]  0.5852134  0.5852134  0.5852134
#> [3,] -0.1588924 -0.1588924 -0.1588924
#> [4,]  1.4543198  1.4543198  1.4543198
#> [5,] -0.7931164 -0.7931164 -0.7931164
#> [6,]  0.1494189  0.1494189  0.1494189
```

``` r

t(fa)
#> <50 x 1000000> DelayedMatrix object of type "double":
#>            [,1]        [,2]        [,3] ...  [,999999] [,1000000]
#>  V1 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#>  V2 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#>  V3 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#>  V4 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#>  V5 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#> ...           .           .           .   .          .          .
#> V46 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#> V47 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#> V48 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#> V49 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
#> V50 -0.38712375  0.58350823 -0.03249806   .  0.7831217 -0.3560107
```

``` r

fa * 4 + 1
#> <1000000 x 50> DelayedMatrix object of type "double":
#>                    V1         V2         V3 ...        V49        V50
#>       [1,] -0.5484950 -0.5484950 -0.5484950   . -0.5484950 -0.5484950
#>       [2,]  3.3340329  3.3340329  3.3340329   .  3.3340329  3.3340329
#>       [3,]  0.8700078  0.8700078  0.8700078   .  0.8700078  0.8700078
#>       [4,] -0.9979023 -0.9979023 -0.9979023   . -0.9979023 -0.9979023
#>       [5,] -5.3920524 -5.3920524 -5.3920524   . -5.3920524 -5.3920524
#>        ...          .          .          .   .          .          .
#>  [999996,]  0.8276858  0.8276858  0.8276858   .  0.8276858  0.8276858
#>  [999997,] 11.1329107 11.1329107 11.1329107   . 11.1329107 11.1329107
#>  [999998,]  3.9239662  3.9239662  3.9239662   .  3.9239662  3.9239662
#>  [999999,]  4.1324868  4.1324868  4.1324868   .  4.1324868  4.1324868
#> [1000000,] -0.4240430 -0.4240430 -0.4240430   . -0.4240430 -0.4240430
```

``` r

cbind(fa, fa)
#> <1000000 x 100> DelayedMatrix object of type "double":
#>                     V1          V2          V3 ...         V49         V50
#>       [1,] -0.38712375 -0.38712375 -0.38712375   . -0.38712375 -0.38712375
#>       [2,]  0.58350823  0.58350823  0.58350823   .  0.58350823  0.58350823
#>       [3,] -0.03249806 -0.03249806 -0.03249806   . -0.03249806 -0.03249806
#>       [4,] -0.49947556 -0.49947556 -0.49947556   . -0.49947556 -0.49947556
#>       [5,] -1.59801310 -1.59801310 -1.59801310   . -1.59801310 -1.59801310
#>        ...           .           .           .   .           .           .
#>  [999996,] -0.04307855 -0.04307855 -0.04307855   . -0.04307855 -0.04307855
#>  [999997,]  2.53322766  2.53322766  2.53322766   .  2.53322766  2.53322766
#>  [999998,]  0.73099155  0.73099155  0.73099155   .  0.73099155  0.73099155
#>  [999999,]  0.78312170  0.78312170  0.78312170   .  0.78312170  0.78312170
#> [1000000,] -0.35601074 -0.35601074 -0.35601074   . -0.35601074 -0.35601074
```

## Advanced usage: `feather` files with different column types

As `feather` files store data.frames, the columns can be of different
types (integer, double, character, etc.). `FeatherArray` can therefore
use only a subset of columns of compatible types. The default is to use
all numeric types (double and integer) in the `feather` file, but this
can be manually specified.

Below is an example using the iris data:

``` r
iris_fname <- tempfile(fileext = ".feather")
write_feather(iris, iris_fname)

FeatherArray(iris_fname)
#> <150 x 4> FeatherMatrix object of type "double":
#>        Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   [1,]          5.1         3.5          1.4         0.2
#>   [2,]          4.9         3.0          1.4         0.2
#>   [3,]          4.7         3.2          1.3         0.2
#>   [4,]          4.6         3.1          1.5         0.2
#>   [5,]          5.0         3.6          1.4         0.2
#>    ...            .           .            .           .
#> [146,]          6.7         3.0          5.2         2.3
#> [147,]          6.3         2.5          5.0         1.9
#> [148,]          6.5         3.0          5.2         2.0
#> [149,]          6.2         3.4          5.4         2.3
#> [150,]          5.9         3.0          5.1         1.8
```

``` r

FeatherArray(iris_fname, columns=c("Sepal.Length", "Petal.Length"))
#> <150 x 2> FeatherMatrix object of type "double":
#>        Sepal.Length Petal.Length
#>   [1,]          5.1          1.4
#>   [2,]          4.9          1.4
#>   [3,]          4.7          1.3
#>   [4,]          4.6          1.5
#>   [5,]          5.0          1.4
#>    ...            .            .
#> [146,]          6.7          5.2
#> [147,]          6.3          5.0
#> [148,]          6.5          5.2
#> [149,]          6.2          5.4
#> [150,]          5.9          5.1
```

If the columns are not all of the same type, `FeatherArray` will default
to sample 100 random rows and coercing them to a matrix. Alternatively
users can manually specify the desired output type:

``` r
FeatherArray(iris_fname, type="double")
#> <150 x 4> FeatherMatrix object of type "double":
#>        Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   [1,]          5.1         3.5          1.4         0.2
#>   [2,]          4.9         3.0          1.4         0.2
#>   [3,]          4.7         3.2          1.3         0.2
#>   [4,]          4.6         3.1          1.5         0.2
#>   [5,]          5.0         3.6          1.4         0.2
#>    ...            .           .            .           .
#> [146,]          6.7         3.0          5.2         2.3
#> [147,]          6.3         2.5          5.0         1.9
#> [148,]          6.5         3.0          5.2         2.0
#> [149,]          6.2         3.4          5.4         2.3
#> [150,]          5.9         3.0          5.1         1.8
```

``` r
FeatherArray(iris_fname, type="integer")
#> <150 x 4> FeatherMatrix object of type "integer":
#>        Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   [1,]            5           3            1           0
#>   [2,]            4           3            1           0
#>   [3,]            4           3            1           0
#>   [4,]            4           3            1           0
#>   [5,]            5           3            1           0
#>    ...            .           .            .           .
#> [146,]            6           3            5           2
#> [147,]            6           2            5           1
#> [148,]            6           3            5           2
#> [149,]            6           3            5           2
#> [150,]            5           3            5           1
```

``` r
FeatherArray(iris_fname, type="character")
#> <150 x 4> FeatherMatrix object of type "character":
#>        Sepal.Length Sepal.Width Petal.Length Petal.Width
#> [1,]   "5.1"        "3.5"       "1.4"        "0.2"      
#> [2,]   "4.9"        "3"         "1.4"        "0.2"      
#> [3,]   "4.7"        "3.2"       "1.3"        "0.2"      
#> [4,]   "4.6"        "3.1"       "1.5"        "0.2"      
#> [5,]   "5"          "3.6"       "1.4"        "0.2"      
#> ...    .            .           .            .          
#> [146,] "6.7"        "3"         "5.2"        "2.3"      
#> [147,] "6.3"        "2.5"       "5"          "1.9"      
#> [148,] "6.5"        "3"         "5.2"        "2"        
#> [149,] "6.2"        "3.4"       "5.4"        "2.3"      
#> [150,] "5.9"        "3"         "5.1"        "1.8"
```

``` r
FeatherArray(iris_fname, columns="Species", type="character")
#> <150 x 1> FeatherMatrix object of type "character":
#>        Species    
#> [1,]   "setosa"   
#> [2,]   "setosa"   
#> [3,]   "setosa"   
#> [4,]   "setosa"   
#> [5,]   "setosa"   
#> ...    .          
#> [146,] "virginica"
#> [147,] "virginica"
#> [148,] "virginica"
#> [149,] "virginica"
#> [150,] "virginica"
```

## Possible extensions.

`FeatherArray` provides a basic `DelayedArray` backend for `feather`
files. There are other Bioconductor functionality that could be added in
the future:

- A `FeatherFile` class implemented via
  [BiocIO](https://bioconductor.org/packages/BiocIO/) BiocIO for basic
  import/export and metadata retrieval of `feather` files.
- A `FeatherDataFrame` class for random access DataFrames similar to
  [SQLDataFrame](https://bioconductor.org/packages/SQLDataFrame/) and
  [ParquetDataFrame](https://github.com/LTLA/ParquetDataFrame).
- A `SparseFeatherArray` similar to how `TENxMatrix` stores [sparse
  data](https://tomsing1.github.io/blog/posts/ParquetMatrix/).

The same setup used here could also be used for a `DelayedArray` backend
for [parquet](https://CRAN.R-project.org/package=arrow),
[fst](https://CRAN.R-project.org/package=fst) and
[LaF](https://CRAN.R-project.org/package=LaF).
