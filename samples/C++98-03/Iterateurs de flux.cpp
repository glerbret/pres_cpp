#include <iostream>
#include <iterator>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{5, 6, 12, 89};
  std::ostream_iterator<int> out_it (std::cout, ", ");

  std::copy(foo.begin(), foo.end(), out_it);
}
