#include <Rcpp.h>
using namespace Rcpp;



double getDistance(NumericVector p1, NumericVector p2)
{
  // equation for euclidean distance
  return sqrt(pow((p2[0] - p1[0]), 2) + pow((p2[1] - p1[1]), 2));		
}

NumericVector getMBasedPoint(NumericMatrix feature, double mValue)
{
  
  NumericVector p1;
  NumericVector p2;
  int numRows = feature.nrow();		// assign number of rows in current feature to numRows
  for (int i = 0; i < numRows; i++)
  {
    p1 = feature(i, _);		// assign ith coordinates (x,y,m) to p1
    if ((i + 1) < numRows)
    {
      p2 = feature((i + 1), _);	// assign ith + 1 coordinates (x,y,m) to p2
    }
    
    if (p2[2] >= mValue)  // if the current points m value is greater than or equal to the given m value
    {
      double dRatio = static_cast<double>(std::abs(p1[2] - mValue) / getDistance(p2, p1));
      double pX = (1 - dRatio) * p1[0] + dRatio * p2[0];
      double pY = (1 - dRatio) * p1[1] + dRatio * p2[1];
      NumericVector v = NumericVector::create(pX, pY, mValue);	// create new coordinate v(x,y,m) (this function does not change the m value)
      return (v);
    }
  }
  return 0;
}

int calcOrientation(NumericMatrix circle)
{
  NumericVector p1 = circle(0, _);
  NumericVector p2 = circle(1, _);
  NumericVector p3 = circle(2, _);
  // equation to find the orientation of 3 ordered points
  double n = (p2[1] - p1[1]) * (p3[0] - p2[0]) - (p2[0] - p1[0]) * (p3[1] - p2[1]);
  if (n == 0)
  {
    return 2;	// colinear
  }
  if (n > 0)
  {
    return 0;	// clockwise
  }
  else
  {
    return 1;	// counter clockwise
  }
}


NumericVector calcConvex(NumericMatrix circle, double window)
{
  // assign the values from the circle to p1, p2, and p3
  NumericVector p1 = circle(0, _);
  NumericVector p2 = circle(1, _);
  NumericVector p3 = circle(2, _);    
  
  
  double xDiff = p3[0] - p1[0];
  double yDiff = p3[1] - p1[1];
  
  double n = std::abs(yDiff * p2[0] - xDiff * p2[1] + p3[0] * p1[1] - p3[1] * p1[0]);
  double d = sqrt(pow(yDiff, 2.0) + pow(xDiff, 2.0));
  double c;
  // create these vectors because the function round() only accepts vectors
  NumericVector round1 = NumericVector::create(-(n / d));
  NumericVector round2 = NumericVector::create(n / d);
  
  
  
  if (calcOrientation(circle) == 1)
  {
    // round() returns a vector so retrieve the value from the 0th index
    c = round(round1, 3)[0];
    
  }
  else
  {
    c = round(round2, 3)[0];
    
  }
  NumericVector round3 = NumericVector::create(c / (window / 2));
  NumericVector result = NumericVector::create(c, (round(round3, 3)[0]));
  return result;
}


double calcSinuosity(NumericMatrix circle, double window)
{
  NumericVector p1 = circle(0, _);
  NumericVector p3 = circle(2, _);
  
  NumericVector rounding = NumericVector::create((window / 2) / getDistance(p1, p3));
  return round(rounding, 3)[0];
}


bool isIsland(NumericMatrix feature)
{
  NumericVector p1 = feature(0, _);
  NumericVector plast = feature(feature.nrow() - 1, _);   //get the coordinates (x,y,m) of the last point in the feature
  if (p1[0] == plast[0] && p1[1] == plast[1])   // if the first point is the same as the last the feautre is an island
  {
    return true;
  }
  else
  {
    return false;
  }
}
