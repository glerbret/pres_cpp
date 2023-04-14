#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{5, 26, 7, 12};

  {
    std::vector<int> bar;
    std::copy(foo.begin(), foo.end(), std::back_inserter(bar));
    std::cout << bar[0] << ' ' << bar[1] << ' ' << bar[2] << ' ' << bar[3] << '\n';
  }

  {
    std::vector<int> bar(8);
    std::copy_backward(foo.begin(), foo.end(), bar.end());
    std::cout << bar[0] << ' ' << bar[1] << ' ' << bar[2] << ' ' << bar[3] << '\n';
    std::cout << bar[4] << ' ' << bar[5] << ' ' << bar[6] << ' ' << bar[7] << '\n';
  }
}
