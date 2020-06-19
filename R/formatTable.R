#' formatTable
#'
#' Formats a data frame with all the convexity data of a feature and that features corresponding ID's. If no Route
#' ID value is given, one will be generated, otherwise the given Route ID will be used and a feature ID will be
#' generated.
#' 
#' @param cppMatrix A matrix holding the convexity data of a given feature
#' @param rid A character that represents the unique Route ID of a feature
#' @param fid A numeric that represents the current feature
#' @param noRID A literal that denotes whether or not a Route ID value was given
#' @keywords internal
#' @return outDF A data frame holding all the convexity data of a feature and its corresponding ID's 
#' 
#'
formatTable <- function(cppMatrix, rid, fid, noRID)
{
  if (noRID)
  {
    
    outDF <- data.frame(RID = rid, cppMatrix)
  }
  else
  {
    outDF<- data.frame(FID = fid, RID = rid, cppMatrix)
    
  }
  
  return(outDF)
}