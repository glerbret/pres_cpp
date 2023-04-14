#include <iostream>
#include <vector>
#include <algorithm>

static bool is_odd(int i)
{
  return (i%2)==1;
}

int main()
{
  std::vector<int> foo{1, 4, 5, 9, 12};
  std::cout << *std::find_if_not(std::begin(foo), std::end(foo), is_odd) << "\n";
}
