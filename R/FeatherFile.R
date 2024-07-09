# library(BiocGenerics)
# library(S4Vectors)
# library(BiocIO)
#
# # Class
# .FeatherFile <- setClass("FeatherFile", contains = "BiocFile")
#
# # Validity
# .feather_validity <- function(object){
#     o <- try(feather::feather_metadata(resource(object)), silent = TRUE)
#
#     if(class(o) == "try-error"){
#         o <- "Not a valid feather file"
#     }else{
#         o <- TRUE
#     }
#
#     o
# }
#
# setValidity2("FeatherFile", .feather_validity)
#
# # User-friendly
# FeatherFile <- function(resource){
#     o <- .FeatherFile(resource = resource)
#     validObject(o)
#     o
# }
#
# # Dimensions
# setMethod("dim", "FeatherFile",  function(x){
#     feather::feather_metadata(resource(x))$dim
# })
#
# setMethod("nrow", "FeatherFile",  function(x){dim(x)[1]})
# setMethod("ncol", "FeatherFile",  function(x){dim(x)[2]})
#
# # Columns and their types
# setMethod("type", "FeatherFile", function(x){
#     feather::feather_metadata(resource(x))$types
# })
#
# setMethod("colnames", "FeatherFile", function(x){names(type(x))})
#
# # Import
# setMethod("import", "FeatherFile", function(con, format, text, columns=NULL) {
#     o <- feather::read_feather(resource(con), columns=columns)
#     o <- as(o, "DataFrame")
#     o
# })
#
# # Export
# setMethod("export", c("DataFrame", "FeatherFile"),
#           function(object, con, format, ...) {
#               feather::write_feather(as(object, "data.frame") ,
#                                      resource(con), ...)
#           } )
#
# # Make a feather file:
# feather_fname <- tempfile(fileext = ".feather")
# feather::write_feather(iris, feather_fname)
# x <- FeatherFile(feather_fname)
#
#
#
# ## Recommend CSVFile class for .csv files
# temp <- tempfile(fileext = ".csv")
# FileForFormat(temp)
# ## Create CSVFile
# csv <- CSVFile(temp)
# ## Display path of file
# path(csv)
# ## Display resource of file
# resource(csv)
