#include <iostream>
#include <vector>
#include <numeric>

int main()
{
  std::vector<int> foo {5, 42, 58};
  std::vector<int> bar;

  std::exclusive_scan(std::begin(foo), std::end(foo), std::back_inserter(bar), 8);

  for (const auto it : bar)
  {
	  std::cout << it << " ";
  }
  std::cout << "\n";
}
 