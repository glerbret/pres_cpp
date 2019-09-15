#include <iostream>
#include <string>
#include <vector>

using namespace std::literals;

template<typename... Args>
bool all(Args... args)
{
  return (... && args);
}

template<typename... Args>
long long sum(Args... args)
{
  return (args + ...);
}

template<typename... Args>
double ldiv(Args... args)
{
  return (... / args);
}

template<typename... Args>
double rdiv(Args... args)
{
  return (args / ...);
}

template<typename ...Args>
void FoldPrint(Args&&... args)
{
  (std::cout << ... << std::forward<Args>(args)) << '\n';
}

template<typename T, typename... Args>
void push_back_vec(std::vector<T>& v, Args&&... args)
{
  (v.push_back(args), ...);
}

int main()
{
  {
    std::cout << std::boolalpha << all(true, true, true, false) << '\n';
  }

  {
    std::cout << sum(1, 2, 3, 4) << '\n';
  }

  {
    std::cout << ldiv(1.0, 2.0, 3.0) << ' ' << rdiv(1.0, 2.0, 3.0) << '\n';
  }

  {
    FoldPrint(10, 'a', "ert"s);
  }

  {
    std::vector<int> foo;
    push_back_vec(foo, 10, 20, 56);

    for(auto i : foo)
    {
      std::cout << i << ' ';
    }
    std::cout << '\n';
  }
}
