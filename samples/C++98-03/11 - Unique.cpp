#include <iostream>
#include <vector>
#include <algorithm>

static void print(int a)
{
  std::cout << a << ' ';
}

int main()
{
  std::vector<int> foo{4, 5, 5, 5, 7, 9, 9, 5};

  std::vector<int>::iterator it = std::unique(foo.begin(), foo.end());
  std::for_each(foo.begin(), it, print);
  std::cout << '\n';

#if 0
  for(size_t i  = 0; i < foo.size(); ++i)
  {
    std::cout << foo[i] << ' ';
  }
  std::cout << '\n';
#endif
}
