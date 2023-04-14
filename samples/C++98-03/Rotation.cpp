#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{4, 5, 7, 9, 12};

  std::rotate(foo.begin(), foo.begin() + 2, foo.end());
  for(size_t i = 0; i < foo.size(); ++i)
  {
    std::cout << foo[i] << ' ';
  }
  std::cout << '\n';
}
