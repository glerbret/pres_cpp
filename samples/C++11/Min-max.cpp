#include <iostream>
#include <vector>
#include <algorithm>
#include <utility>

using std::begin;
using std::end;

int main()
{
  std::vector<int> foo{18, 5, 6, 8};
  auto p = std::minmax_element(begin(foo), end(foo));

  std::cout << *(p.first) << " " << *(p.second) << "\n";
}
