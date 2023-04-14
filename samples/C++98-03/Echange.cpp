#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo (5,10);
  std::vector<int> bar (5,33);

  std::cout << bar[0] << " " << bar[1] << " " << bar[2] << " " << bar[3] << " " << bar[4] << "\n";
  std::swap_ranges(foo.begin() + 1, foo.end() - 1, bar.begin());
  std::cout << bar[0] << " " << bar[1] << " " << bar[2] << " " << bar[3] << " " << bar[4] << "\n";
}
