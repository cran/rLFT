#' Route ID Check
#'
#' Checks the given Route ID and makes sure it exists and if it does assigns FALSE to the variable noRID.
#' Otherwise it will stop the program if the given Route ID does not exist or just assign noRID to TRUE if no 
#' RID was given.
#' @param sfDataObject An sf Object containing shape file data.
#' @param ridName A character denoting the column name where the unique Route ID for each feature is stored in 
#' given sf object.
#' @keywords internal
#' @return noRID A literal denoting whether or not an RID value was given
#'
#'
ridCheck <- function(sfDataObject, ridName)
{
  if (!(is.null(ridName)))
  {
    noRID <- FALSE
    found <- FALSE
    for (i in 1:ncol(sfDataObject))
    {
      if (ridName == colnames(sfDataObject)[i])
      {
        found <- TRUE
      }
    }
    if (found == FALSE)
    {
      stop("RID name does not exist")
    }
    if (st_geometry_type(sfDataObject)[1] == "POLYGON")
    {
      if (length(sfDataObject[[ridName]][[1]][[1]]) > 1)
      {
        stop("RID cells cannot have more than 1 entry")
      }
    }
    else
    {
      if (length(sfDataObject[[ridName]][[1]]) > 1)
      {
        stop("RID cells cannot have more than 1 entry")
      }
    }
    
  }
  else
  {
    noRID <- TRUE
  }
  return(noRID)
}