#include <iostream>
#include <utility>

template<typename T>
using IntPair = std::pair<int, T>;

int main()
{
  IntPair<double> p0{1, 2.0}; 
  IntPair p1{1, 2.0}; 
}
