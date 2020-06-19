#ifndef HELPERF_H
#define HELPERF_H

#include <Rcpp.h>
using namespace Rcpp;

void openOutput(std::string filename, bool noRID);

double getDistance(NumericVector p1, NumericVector p2);

NumericMatrix addMValues(NumericMatrix feature);

NumericVector getMBasedPoint(NumericMatrix feature, double mValue);

int calcOrientation(NumericMatrix circle);

NumericVector calcConvex(NumericMatrix circle, double window);

double calcSinuosity(NumericMatrix circle, double window);

bool isIsland(NumericMatrix feature);


#endif
  
  
