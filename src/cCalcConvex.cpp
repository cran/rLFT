#include <Rcpp.h>
using namespace Rcpp;
#include<iostream>
#include<fstream>
#include "helper.h"




//' Calculate Boundary Convexity
//' 
//' Cpp function that calculates convexity of a single feature.
//' 
//' Cpp function that takes in a single feature from the given sf object and calculates raw convexity,
//' convexity index, and sinuosity of that feature. It formats convexity data into a NumericMatrix and outputs
//' it.
//' 
//' @param feature A NumericMatrix that holds the data of one feature from the given sf object.
//' @param windowSize A double describing the diameter of the window used to measure convexity.
//' @param stepSize A double describing the distance between measurements along an arc.
//' @param fid An integer that holds the current feature id.
//' @param rid A string that holds the unique route ID for the current feature.
//' @param filename A string denoting the name of the file you wish to output convexity data to.
//' @param noRID A boolean that denotes whether the given sf object has an RID column.
//' 
//' @return matrix
//' 
//' @keywords internal
// [[Rcpp::export]]
NumericMatrix CalcBoundaryConvex(NumericMatrix feature, double windowSize, double stepSize, int fid, std::string rid, std::string filename = "", bool noRID = true)
{
  
  std::ofstream myfile;
  // Open file for writing if its given
  if (!(filename.empty()))
  {
    
    myfile.open(filename.c_str(), std::ios_base::app);
  }
  
  // Initialize variables
  double step = stepSize;
  double window = windowSize;
  double startM = 0.0;
  NumericVector p1, p2, p3, zerop1, zerop2, zerop3;
  double maxM = feature(feature.nrow() - 1, 2);
  int i = 0;
  // allocate output matrix size
  NumericMatrix output(1, 7);
  
  // check if current feature is an island to calculate the point at zero
  if (isIsland(feature))
  {
    while (startM + window / 2.0 <= maxM)
    {

      if (i == 0) // Get the point at zero step size. p2 is given startM (0) and p1 starts behind the max-m.
      {
        zerop1 = getMBasedPoint(feature, maxM - (window / 2));
        zerop2 = getMBasedPoint(feature, startM);
        zerop3 = getMBasedPoint(feature, startM + window / 2);
        
        // use the three m-based points to make up the circle
        double zeroSinStuff;
        NumericMatrix zeroCircle(3);
        zeroCircle(0, _) = zerop1;
        zeroCircle(1, _) = zerop2;
        zeroCircle(2, _) = zerop3;
        
        // use the circle to calculate convexity and sinuosity
        NumericVector zeroConvex = calcConvex(zeroCircle, window);
        zeroSinStuff = calcSinuosity(zeroCircle, window);
        NumericVector zeroTemp = NumericVector::create(round(zerop2[2]), window, zeroConvex[0], zeroConvex[1], zeroSinStuff, zerop2[0], zerop2[1]);
        
        // if there was a file given write the data to the file
        if (!(filename.empty()))
        {
          // if there is no route ID column given create one
          if (noRID)
          {
            myfile << rid << "\t" << std::fixed << std::setprecision(0) << zerop2[2] << "\t" << window << "\t" << std::fixed << std::setprecision(3) << zeroConvex[0] << "\t" << zeroConvex[1]
                   << "\t" << zeroSinStuff << "\t" << std::setprecision(5) << zerop2[0] << "\t" << zerop2[1] << "\n";
          }
          // use the given route ID column and create a feature id column for additional clairty
          else
          {
            myfile << fid << "\t" << rid << "\t" << std::fixed << std::setprecision(0) << zerop2[2] << "\t" << window << "\t"<< std::fixed << std::setprecision(3) << zeroConvex[0] << "\t" << zeroConvex[1]
                   << "\t" << zeroSinStuff << "\t" << std::setprecision(5) << zerop2[0] << "\t" << zerop2[1] << "\n";
          }
        }
        // assign all the data to the output matrix
        output(0, _) = zeroTemp;
        
      } // No else because we still need to calculate the points at startM = 0 with regular p2.
      
      p1 = getMBasedPoint(feature, startM);
      p2 = getMBasedPoint(feature, startM + window / 2);
      if (startM + window <= maxM)  // Check is here so we dont go over the maximum M
      {
        p3 = getMBasedPoint(feature, startM + window);
      }
      else
      {
        p3 = getMBasedPoint(feature, (startM + window) - maxM);
      }
      
      double sinstuff;
      NumericMatrix circle(3);
      circle(0, _) = p1;
      circle(1, _) = p2;
      circle(2, _) = p3;
      
      NumericVector convex = calcConvex(circle, window);
      sinstuff = calcSinuosity(circle, window);
      NumericVector temp = NumericVector::create(round(p2[2]), window, convex[0], convex[1], sinstuff, p2[0], p2[1]);
      // Import rbind function from R
      Function f("rbind");
      temp.attr("dim") = Dimension(1, 7);
      NumericMatrix tempM = as<NumericMatrix>(temp);
      
      if (!(filename.empty()))
      {
        if (noRID)
        {
          myfile << rid << "\t" << std::fixed << std::setprecision(0) << p2[2] << "\t" << window << "\t" << std::fixed << std::setprecision(3) << convex[0] << "\t" << convex[1]
                 << "\t" << sinstuff << "\t" << std::setprecision(5) << p2[0] << "\t" << p2[1] << "\n";
        }
        else
        {
          myfile << fid << "\t" << rid << "\t" << std::fixed << std::setprecision(0) << p2[2] << "\t" << window << "\t" << std::fixed << std::setprecision(3) << convex[0] << "\t" << convex[1]
                 << "\t" << sinstuff << "\t" << std::setprecision(5) << p2[0] << "\t" << p2[1] << "\n";
        }
      }
      
      // rbind probably causes a considerable increase in runtime
      // rbind output matrix to the data matrix
      output = f(output, tempM);
      // increment step size and i
      startM = startM + step;
      i++;
    }		
    
  }
  else
  {
    while (startM + window / 2.0 <= maxM)
    {
      
      p1 = getMBasedPoint(feature, startM);
      p2 = getMBasedPoint(feature, startM + window / 2);
      // dont need to check if we are going over maxM since it is not an island
      p3 = getMBasedPoint(feature, startM + window);
      
      double sinstuff;
      NumericMatrix circle(3);
      circle(0, _) = p1;
      circle(1, _) = p2;
      circle(2, _) = p3;
      
      NumericVector convex = calcConvex(circle, window);
      sinstuff = calcSinuosity(circle, window);
      NumericVector temp = NumericVector::create(p2[2], window, convex[0], convex[1], sinstuff, p2[0], p2[1]);
      Function f("rbind");
      temp.attr("dim") = Dimension(1, 7);
      NumericMatrix tempM = as<NumericMatrix>(temp);
      
      if (!(filename.empty()))
      {
        if (noRID)
        {
          myfile << rid << "\t" << std::fixed << std::setprecision(0) << p2[2] << "\t" << window << "\t" << std::fixed << std::setprecision(3) << convex[0] << "\t" << convex[1]
                 << "\t" << sinstuff << "\t" << std::setprecision(5) << p2[0] << "\t" << p2[1] << "\n";
        }
        else
        {
          myfile << fid << "\t" << rid << "\t" << std::fixed << std::setprecision(0) << p2[2] << "\t" << window << "\t" << std::fixed << std::setprecision(3) << convex[0] << "\t" << convex[1]
                 << "\t" << sinstuff << "\t" << std::setprecision(5) << p2[0] << "\t" << p2[1] << "\n";
        }
      }
      
      if (i == 0)   //if its the first point initalize output matrix with the data from the first point
      {
        output(0, _) = temp;
      }
      else
      {
        // This rbind function probably causes a considerable increase in runtime
        output = f(output, tempM);
      }
      
      startM = startM + step;
      i++;
    }
  }
  if (!(filename.empty()))
  {
    myfile.close();
  }
  
  return output;
}
