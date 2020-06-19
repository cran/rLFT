
#' Boundary Convexity Tool
#' 
#' Calculates raw convexity, convexity index, and sinuosity of a given sf object and returns a data frame with all measurements for each step and feature. If provided, the data will also be output to a tab delimited file.
#'
#' This function will reject any sf object with a geographic coordinate system, so consider projecting your features. Your sf object must be of either type LINESTRING, MULTILINESTRING, POLYGON, or MULTIPOLYGON. If a given POLYGON or MUTLIPOLYGON contains inner rings, they will be ignored. If a unique ID Column name is not provided, the function will generate a unique ID for each feature. The arguments \code{step} and \code{window} can be any non-negative numeric. The argument \code{ridName} MUST be a character indicating the name of the column in your sf object where the route id is stored. 
#' 
#' @section Reference:
#' Albeke, S.E. et al. \emph{“Measuring boundary convexity at multiple spatial scales using a linear “moving window” analysis: an application to coastal river otter habitat selection.”} Landscape Ecology 25 (2010): 1575-1587. [linked phrase](https://link.springer.com/article/10.1007/s10980-010-9528-4)
#' 
#'
#' @param sfDataObject An sf Object containing shape file data.
#' @param step A numeric describing the distance between measurements along an arc.
#' @param window A numeric describing the diameter of the window used to measure convexity.
#' @param ridName A character denoting the column name where the unique ID for each feature is stored in 
#' given sf object.
#' @param filename A character denoting the name of the file you wish to output convexity data to in tab delimited format. Must have the .txt extension.
#'
#' @return The output of this function is a \code{data.frame} that contains all measurements for each step and feature.
#' @export
#' @examples 
#' library(rLFT)
#' data("shpObject")
#' #store convexity output data in a variable 'outputTable'
#' outputTable <- bct(shpObject, step = 50, window = 100, ridName = "RID")
#' 
bct <- function(sfDataObject, step, window, ridName = NULL, filename = "")
{
  if (!inherits(sfDataObject, "sf"))
  {
    stop("sfDataObject must be of type sf")
  }
  if (!inherits(step, "numeric") | step < 0)
  {
    stop("Step must be a number (>0) indicating the step size")
  }
  if (!inherits(window, "numeric") | window < 0)
  {
    stop("Window must be a number (>0) indicating window size")
  }
  if(!(is.null(ridName)) & !inherits(ridName, "character"))
  {
    stop("ridName must be a character giving the RID column name!")
  }
  if((nchar(filename) > 0) & !inherits(filename, "character"))
  {
    stop("filename must be a character giving the name of the file you wish to output data to!")
  }
  if ((nchar(filename)) > 0 & !(endsWith(filename, ".txt")))
  {
    stop("Output file must end with .txt")
  }
  if (st_is_longlat(sfDataObject))
  {
    stop("Please use a sf object with a projected coordinate system")
  }
  if(!is.null(ridName)){
    if(!ridName %in% names(sfDataObject))
    {
      stop("ridName is not an existing column within your sf object. Please specify the correct column containing the unique identifier for each row/feature. If you don't have one, create one perhaps using row.names.")
    }
  }
  
  
  # # Route ID setup
  # noRID <- ridCheck(sfDataObject, ridName)
  noRID<- FALSE
  # If no Route ID column is given generate one based off of the number of features in the given sf object
  if (is.null(ridName))
  {
    rids <- as.character(c(1:nrow(sfDataObject)))
  }
  else
  {
    rids <- as.character(sfDataObject[[ridName]])
  }
  # rids <- as.character(rids)  ## need to pass char values to C++ so it can write them to the outputfile
  
  ## opens given file
  if (nchar(filename) > 0)
  {
    openOutput(filename, noRID)
  }
  
  sfDataObjectM <- addMValues(sfDataObject)
  ## iterate through the sf object running through all the features
  skippedList <- vector()
  stime <- system.time({
  for(i in 1:nrow(sfDataObject))
  {
    
    
    featureUpdatedM <- st_coordinates(sfDataObjectM[i,])
    fid <- i  ## To keep all features in numerical order assign i to feature ID
    
    if (window > featureUpdatedM[nrow(featureUpdatedM), 3])
    {
      ## Move to the next feature if current one is too small (window size is larger than max M)
      ## Possibly add a warning here
      skippedList <- skipFeatureList(skippedList, i)
      next
    }
    
    ## storing the convexity data retrieved from C++ function in R matrix
    cMatrix <- CalcBoundaryConvex(featureUpdatedM, window, step, fid, rids[i], filename, noRID)
    
    ## now that we have convexity values, coerce to our output data.frame
    if (!exists("finalTable"))    ## check in case the first feature was skipped over due to size
    {
      finalTable <- formatTable(cMatrix, rids[i], fid, noRID)
    }
    else
    {
      finalTable <- rbind(finalTable, formatTable(cMatrix, rids[i], fid, noRID))
    }
    
  }
  })
  
  # if(noRID)  ## add generated RID column into the table
  # {
  #   colnames(finalTable) <- c("RID", "MidMeas", "WindowSize", "RawConvexity", "ConvexityIndex", "Sinuosity", "Midpoint X", "Midpoint Y")
  # }
  # else      ## Use given RID column and add generated FID column into the table
  # {
  #   colnames(finalTable) <- c("FID", "RID", "MidMeas", "WindowSize", "RawConvexity", "ConvexityIndex", "Sinuosity", "Midpoint X", "Midpoint Y")
  # }
  colnames(finalTable) <- c("FID", "RID", "MidMeas", "WindowSize", "RawConvexity", "ConvexityIndex", "Sinuosity", "Midpoint_X", "Midpoint_Y")
  
  print(stime)
  print("Features skipped due to size: ")
  print(skippedList)
  return(finalTable)
  
}