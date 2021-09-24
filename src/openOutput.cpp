#include <Rcpp.h>
using namespace Rcpp;
#include<iostream>
#include<fstream>


//' Open a file for output
//' 
//' Opens a file for writing and writes all of the convexity data taken from the given sf object to the given
//' file.
//' 
//' @param filename A string denoting the name of the file you wish to output convexity data to.
//' @param noRID A boolean that denotes whether the given sf object has an RID column.
//' @keywords internal
// [[Rcpp::export]]
void openOutput(std::string filename, bool noRID)
{
  
  std::ofstream myfile;
  myfile.open(filename.c_str());
  // if the given file opened successfully write to it
  if (myfile.is_open())
  {
    if (noRID)
    {
      // initalize the table headers for the data in the file creating a new RID column since it was not provided
      myfile << "RID MidMeas WindowSize RawConvexity ConvexityIndex Sinuosity Midpoint_X Midpoint_Y\n";
    }
    else
    {
      // RID column was given so initalize the table headers with an added Feature ID row
      myfile << "FID RID MidMeas WindowSize RawConvexity ConvexityIndex Sinuosity Midpoint_X Midpoint_Y\n";
    }
  }
  else
  {
    Rcout << "Error opening file\n";
  }
  myfile.close();
}
