#' Add M values to given feature
#' 
#' Add M values to a given linear feature and store them in the m-coordinate of the sf object. Returns
#' the new sf object with added m-values.
#' For more information on m-values and linear referencing see: 
#' \url{http://desktop.arcgis.com/en/arcmap/10.3/guide-books/linear-referencing/what-is-linear-referencing.htm}
#' 
#' @param sfDataObject An sf object. Must be a LINESTRING, POLYGON, MULTIPOLYGON, or MULTILINESTRING
#' 
#' @return Returns the new \code{sfDataObject} with added m-values. The class of the output is \code{sf}.
#' 
#' @examples
#' library(rLFT)
#' data("shpObject")
#' # Assign M Values to each vertex
#' mValues <- addMValues(shpObject)
#' print("M Values Added")
#' head(st_coordinates(mValues))
#' 
#' @export
addMValues <- function(sfDataObject)
{
  if (st_geometry_type(sfDataObject[1,]) %in% c("LINESTRING", "POLYGON", "MULTIPOLYGON", "MULTILINESTRING"))
  {
    if (st_geometry_type(sfDataObject[1,]) == "MULTIPOLYGON")
    {
      warning("Multi Polygon will be converted to Multi Linestring")
      sfDataObject <- st_cast(sfDataObject, "POLYGON")
    }
    if (st_geometry_type(sfDataObject[1,]) == "POLYGON")
    {
      sfDataObject <- st_cast(sfDataObject, "MULTILINESTRING")
      warning("Inner polygons are not calculated")
      
    }
    # Create temp data.frame
    outDF<- data.frame()
    if (st_geometry_type(sfDataObject[1,]) == "MULTILINESTRING")
    {
      
      for(i in 1:nrow(sfDataObject))
      {
        tempFt <- st_coordinates(sfDataObject[i,])
        errInRows = FALSE
        errRows <- vector()
        for (k in 1:nrow(tempFt))
        {
          if (!(tempFt[k,]["L1"] == 1))
          {
            errRows <- c(errRows, k) 
            errInRows = TRUE
          }
        }
        if (errInRows)
        {
          tempFeat <- tempFt[-c(errRows), ]
        }
        else
        {
          tempFeat <- tempFt
        }
        
        tempSf <- sfDataObject[i,]
        tempSf <- as.data.frame(tempSf)
        tempFeat <- addM(tempFeat)
        tempFeat <- st_linestring(tempFeat, dim = "XYM")
        tempSf$geometry <- st_as_text(tempFeat, digits = 15)
        outDF<- rbind(outDF, tempSf)
      }
    }
    else
    {
      for(i in 1:nrow(sfDataObject))
      {
        tempFeat <- st_coordinates(sfDataObject[i,])
        tempSf <- sfDataObject[i,]
        tempSf <- as.data.frame(tempSf)
        tempFeat <- addM(tempFeat)
        tempFeat <- st_linestring(tempFeat, dim = "XYM")
        tempSf$geometry <- st_as_text(tempFeat, digits = 15)
        outDF<- rbind(outDF, tempSf)
      }
    }
  }
  else
  {
    stop("Please use an sf object of type LINESTRING, MULTILINESTRING, POLYGON, or MULTIPOLYGON")
  }
  return(st_as_sf(outDF, wkt = "geometry", crs = st_crs(sfDataObject)))
}
