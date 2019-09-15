#include <iostream>
#include <vector>

int main()
{
  {
    std::vector<int> foo{4, 8, 12, 37};
    for(int var : foo)
    {
      std::cout << var << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{4, 8, 12, 37};
    for(auto var : foo)
    {
      std::cout << var << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo(4);
    for(auto& var : foo)
    {
      var = 5;
    }
    for(auto var : foo)
    {
      std::cout << var << ' ';
    }
    std::cout << '\n';
  }
}
