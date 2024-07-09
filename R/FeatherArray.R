#### FeatherArraySeed ####

# Class
.FeatherArraySeed <- setClass("FeatherArraySeed",
                              contains="Array",
                              slots=c(
                                  filepath="character",
                                  columns="character",
                                  rows="integer",
                                  type="character"))

# Constructor
FeatherArraySeed <- function(filepath, columns=NULL, type=NULL){
    # Fails if not a feather file
    filepath <- tools::file_path_as_absolute(filepath)
    fm <- feather::feather_metadata(filepath)

    # Figure out columns
    if(is.null(columns)){
        columns <- names(fm$types[fm$types %in% c("double", "integer")])
    }else{
        checkmate::assertSubset(columns,
                                choices=names(fm$types),
                                empty.ok = FALSE)
    }

    # Figure out the type (perhaps have shortcut for double+integer)
    if(is.null(type)){
        coltypes <- sort(unique(fm$types[columns]))
        if(length(coltypes) == 1){
            type <- coltypes
        }else{
            fo <- feather::feather(filepath)
            type <- fo[sort(sample.int(n = nrow(fo),
                                       size = min(nrow(fo), 100))),
                       columns]
            type <- as.matrix(type)
            type <- type(type)
        }
    }

    # Build object
    .FeatherArraySeed(filepath=filepath,
                      columns=columns,
                      rows=fm$dim[1],
                      type=type)
}

# Dimensions
#' @rdname FeatherArray-package
setMethod("dim", "FeatherArraySeed", function(x){c(x@rows, length(x@columns))})

#' @rdname FeatherArray-package
setMethod("dimnames", "FeatherArraySeed", function(x){list(NULL, x@columns)})

# Extracting
.extract_feather_array <- function(x, index){
    # Extract feather
    fo <- feather::feather(x@filepath)

    # Extract indices
    i <- index[[1]]
    j <- index[[2]]

    # Make sure it handles NULL index
    if(!is.null(i) && !is.null(j)){
        o <- fo[i, x@columns[j]]
    }else if(is.null(i) && !is.null(j)){
        o <- fo[, x@columns[j]]
    }else if(!is.null(i) && is.null(j)){
        o <- fo[i, x@columns]
    }else if(is.null(i) && is.null(j)){
        o <- fo[,x@columns]
    }else{
        stop("This should not happen!")
    }

    # Convert to matrix
    o <- as.matrix(o)
    if(type(o) != x@type){
        type(o) <- x@type
    }

    # Return
    o
}

setMethod("extract_array", "FeatherArraySeed", .extract_feather_array)

#### FeatherArray ####

#' FeatherArray: A DelayedArray backend for feather
#'
#' FeatherArray allows you to use the feather package as a backend for
#' DelayedArrays, similarly to the default HDF5Array package. Only reading from feather files is supported. Optionally, only a subset of columns from the feather file can be used.
#'
#' @param filepath character: Path to feather file.
#' @param columns character or NULL: columns to use from the feather file. If NULL, a 100 random rows will be used to guess numeric columns.
#' @param type character or NULL: resulting type of matrix. If NULL, will be guessed from 100 random rows.
#' @return A FeatherMatrix object (A 2D FeatherArray)
#'
#' @export
#' @examples
#' # Make a feather file:
#' feather_fname <- tempfile(fileext = "feather")
#' feather::write_feather(iris, feather_fname)
#'
#' # Use feather file in a DelayedArray, by default all numeric columns:
#' fa <- FeatherArray(feather_fname)
#'
#' # Data is only read from the feather file when needed, so the resulting object is very small:
#' object.size(iris)
#' object.size(fa)
#'
#' # All normal DelayedArray operations are supported
#' fa[1:4, c(1:3)]
#' t(fa)
#' fa + 5
#'
#' # FeatherArray also support using just a subset of columns
#' fas <- FeatherArray(feather_fname, columns=c("Sepal.Length", "Petal.Length"))
#' fas
setClass("FeatherArray",
                          contains="DelayedArray",
                          representation(seed="FeatherArraySeed")
)

# DelayedArray infrastructure
setMethod("DelayedArray", "FeatherArraySeed",
          function(seed) new_DelayedArray(seed, Class="FeatherArray")
)

#' @rdname FeatherArray-class
#' @export
FeatherArray <- function(filepath, columns=NULL, type=NULL){
    checkmate::assertFile(filepath, access = "r", extension = c("feather", "fea"))
    checkmate::assertCharacter(columns, null.ok = TRUE)
    checkmate::assertString(type, null.ok = TRUE)

    if (is(filepath, "FeatherArraySeed")){
        seed <- filepath
    }else {
        seed <- FeatherArraySeed(filepath=filepath, columns=columns, type=type)
    }

    DelayedArray(seed)
}

#' @rdname FeatherArray-class
#' @export
setClass("FeatherMatrix", contains=c("FeatherArray", "DelayedMatrix"))

# DelayedArray infrastructure
setMethod("matrixClass", "FeatherArray", function(x) "FeatherMatrix")
setAs("FeatherArray", "FeatherMatrix", function(from) new("FeatherMatrix", from))
setAs("FeatherMatrix", "FeatherArray", function(from) from)



