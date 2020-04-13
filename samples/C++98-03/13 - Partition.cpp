#include <iostream>
#include <vector>
#include <algorithm>

static bool is_odd(int i)
{
  return (i%2)==1;
}

int main()
{
  {
    std::vector<int> foo{4, 13, 28, 9 , 54};

    std::partition(foo.begin(), foo.end(), is_odd);
    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{4, 13, 28, 9 , 54};

    std::stable_partition(foo.begin(), foo.end(), is_odd);
    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

    std::nth_element(foo.begin(), foo.begin() + 3, foo.end());
    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }
}
