# meditate

[![Travis Build Status](https://travis-ci.org/jfisher-usgs/meditate.svg?branch=master)](https://travis-ci.org/jfisher-usgs/meditate)
[![CRAN Version](https://www.r-pkg.org/badges/version/meditate)](https://CRAN.R-project.org/package=meditate)
[![CRAN Downloads](https://cranlogs.r-pkg.org/badges/meditate?color=brightgreen)](https://CRAN.R-project.org/package=meditate)
[![Dependencies](https://tinyverse.netlify.com/badge/meditate)](https://CRAN.R-project.org/package=meditate)

## Overview

The [R](https://www.r-project.org/) package **meditate** is a simple meditation timer that logs session information.

## Install

The current release is available on [CRAN](https://CRAN.R-project.org/package=meditate "The Comprehensive R Archive Network"), which you can install using the following command:

```r
install.packages("meditate")
```

To install the development version, you need to clone the repository and build from source, or run:

```r
remotes::install_github("jfisher-usgs/meditate")
```

## Usage

Begin a 10-minute meditation session:

```r
meditate::Meditate(10)
```
Access help documentation:

```r
help("Meditate", package = "meditate")
```

## Contact

Please consider reporting bugs and asking questions on the [Issues page](https://github.com/jfisher-usgs/meditate/issues).

## License

This package is free and open source software, licensed under GPL (>= 2).

<img src="./man/figures/mandala.svg" alt="Mandala" width="60%" height="auto" />
