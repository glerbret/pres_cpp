#include <iostream>
#include <vector>
#include <numeric>

using std::begin;
using std::end;

int main()
{
  std::vector<int> foo(5);
  
  std::iota(begin(foo), end(foo), 50);
  for(size_t i = 0; i < foo.size(); ++i)
  {
    std::cout << foo[i] << ' ';
  }
  std::cout << '\n';
}
