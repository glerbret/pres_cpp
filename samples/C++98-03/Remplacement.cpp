#include <iostream>
#include <vector>
#include <algorithm>

static bool check(int a)
{
  return a >= 7;
}

int main()
{
  {
    std::vector<int> foo{4, 5, 7, 9 ,12, 5};
    std::replace(foo.begin(), foo.end(), 5, 8);
    for(size_t  i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{4, 5, 7, 9 ,12, 5};
    std::replace_if(foo.begin(), foo.end(), check, 8);
    for(size_t  i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{4, 5, 7, 9 ,12, 5};
    std::vector<int> bar;
    std::replace_copy(foo.begin(), foo.end(), std::back_inserter(bar), 5, 8);
    for(size_t  i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';

    for(size_t  i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }
}
