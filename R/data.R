#' An example sf object outlining boundaries of a group of islands in Alaska cast as LINESTRING.
#'
#' A dataset with coordinates (x, y) of 37 linear features with a geometry type of LINESTRING and
#' a projected coordinate system (aea). These particular features represent several small islands in Alaska.
#' 
#'@format A data frame with 37 rows and 2 variables
#'\describe{
#'      \item{RID}{Route ID of the features}
#'      \item{geometry}{coordinates of feature (x, y)}
#'      
#'}
#'
#'
"shpObject"


#' An example sf object outlining boundaries of a group of islands in Alaska in the lat/lon CRS.
#'
#' A dataset with coordinates (x, y, z) of 3 linear features with a geometry type of MULTIPOLYGON and
#' a geographic coordinate system (longlat)
#'
#'@format A data frame with 1 row and 10 variables
#'      
#'
#'
"latlongShpObject"


#' An example sf object outlining boundaries of a group of islands in Alaska cast as POLYGON.
#'
#' A dataset with coordinates (x, y) of 37 features with a geometry type of POLYGON and
#' a projected coordinate system (aea). These features represent the same data as 'shpObject' but this sf
#' object has been cast to be of geometry type POLYGON. There are also inner polygons on some features.
#' 
#'@format A data frame with 37 rows and 2 variables
#'\describe{
#'      \item{Id}{Id's of all features}
#'      \item{geometry}{coordinates of feature (x,y)}
#'      
#'}
#'
#'
"polygonShpObject"


#' An example sf object with geometry type of POINT, used for testing.
#'
"pointObject"