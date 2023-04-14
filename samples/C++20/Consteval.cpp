#include <iostream>

consteval int sqr(int n)
{
  return n * n;
}

constexpr int sqr2(int n)
{
  return n * n;
}

int main()
{
  {
    constexpr int foo = sqr(100);
    std::cout << foo << "\n";
  }

  {
    constexpr int x = 10;
    constexpr int foo = sqr(x);
    std::cout << foo << "\n";
  }

#if 0
  {
    int x = 100;
    int foo = sqr(x);
    std::cout << foo << "\n";
  }
#endif

#if 0
  {
    int x = 100;
    int foo = sqr2(x);
    std::cout << foo << "\n";
  }
#endif
}
