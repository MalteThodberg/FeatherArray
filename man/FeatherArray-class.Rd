% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FeatherArray.R
\docType{class}
\name{FeatherArray-class}
\alias{FeatherArray-class}
\alias{FeatherArray}
\alias{FeatherMatrix-class}
\title{FeatherArray: A DelayedArray backend for feather}
\usage{
FeatherArray(filepath, columns = NULL, type = NULL)
}
\arguments{
\item{filepath}{character: Path to feather file.}

\item{columns}{character or NULL: columns to use from the feather file. If NULL, a 100 random rows will be used to guess numeric columns.}

\item{type}{character or NULL: resulting type of matrix. If NULL, will be guessed from 100 random rows.}
}
\value{
A FeatherMatrix object (A 2D FeatherArray)
}
\description{
FeatherArray allows you to use the feather package as a backend for
DelayedArrays, similarly to the default HDF5Array package. Only reading from feather files is supported. Optionally, only a subset of columns from the feather file can be used.
}
\examples{
# Make a feather file:
feather_fname <- tempfile(fileext = "feather")
feather::write_feather(iris, feather_fname)

# Use feather file in a DelayedArray, by default all numeric columns:
fa <- FeatherArray(feather_fname)

# Data is only read from the feather file when needed, so the resulting object is very small:
object.size(iris)
object.size(fa)

# All normal DelayedArray operations are supported
fa[1:4, c(1:3)]
t(fa)
fa + 5

# FeatherArray also support using just a subset of columns
fas <- FeatherArray(feather_fname, columns=c("Sepal.Length", "Petal.Length"))
fas
}
