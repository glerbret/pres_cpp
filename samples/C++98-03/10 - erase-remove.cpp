#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{4, 5, 5, 5, 7, 9, 9, 5};

  foo.erase(std::remove(foo.begin(), foo.end(), 5), foo.end());
  for(size_t i  = 0; i < foo.size(); ++i)
  {
    std::cout << foo[i] << ' ';
  }
  std::cout << '\n';
}
