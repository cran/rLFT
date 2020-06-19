#include <Rcpp.h>
using namespace Rcpp;
#include "helper.h"


//' Add M values to given feature
//' 
//' Add measure values to a given linear feature and store them in the m-coordinate of the matrix. Returns
//' the new matrix with added m-values.
//' For more information on m-values and linear referencing see: 
//' \url{http://desktop.arcgis.com/en/arcmap/10.3/guide-books/linear-referencing/what-is-linear-referencing.htm}
//' 
//' @param feature A NumericMatrix that holds the data of a single linear feature taken from a given sf object.
//' 
//' @return matrix
//' 
//' @keywords internal
// [[Rcpp::export]]
NumericMatrix addM(NumericMatrix feature)
{
  
  double m = 0.0;
  NumericMatrix newMat(feature.nrow(), 3);	// creating a new matrix
  // copying all of the (x,y) coordinates of current feature and adding new m values to new matrix
  for (int i = 0; i < feature.nrow(); i++)
  {
    
    NumericVector pt2 = feature(i, _);    // copy the x,y coordinates for the ith point of the current feature
    NumericVector v = NumericVector::create(pt2[0], pt2[1], m); // create new vector of the ith point with added m-values
    if (i == 0)
    {
      newMat(i, _) = v;   // initalize a matrix to store all points of the given feature but with added m values
    }
    else
    {
      NumericVector pt1 = feature((i - 1), _);
      m = m + getDistance(pt1, pt2);	// only changing m values not (x,y)
      
      v[2] = m;
      newMat(i, _) = v;	// add (x, y, updated m) to new matrix
    }
  }
  
  return newMat;
}
