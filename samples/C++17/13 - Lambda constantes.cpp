#include <iostream>

constexpr int AddEleven(int n)
{
  return [n] { return n+11; }();
}

int main()
{
  {
    std::cout << AddEleven(5) << '\n';
  }

  {
    auto ID = [] (int n) constexpr { return n; };
    constexpr int I = ID(3);
    std::cout << I << '\n';
  }

  {
    auto ID = [] (int n) { return n; };
    constexpr int I = ID(3);
    std::cout << I << '\n';
  }

  {
    constexpr auto add = [] (int n, int m)
                            {
                              auto L = [=] { return n; };
                              auto R = [=] { return m; };
                              return [=] { return L() + R(); };
                            };
    std::cout << add(3, 4)() << '\n';
  }
}
