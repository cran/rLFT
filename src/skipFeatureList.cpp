#include <Rcpp.h>
using namespace Rcpp;

//' Creates a list of features that have been skipped over
//'
//' Takes in a vector and pushes the feature ID into the vector
//'
//' @param x A NumericVector to hold all the skipped features
//' @param i ID of the skipped feature
//' @keywords internal
// [[Rcpp::export]]
NumericVector skipFeatureList(NumericVector x, int i) {
  x.push_back(i);
  return x;
}
