#include <iostream>

consteval int foo(int i)
{
  return i;
}

constexpr int bar(int i)
{
  if consteval
  {
    return foo(i) + 1;
  }
  else
  {
    return 42;
  }
}

int main()
{
  std::cout << bar(5) << "\n";

  constexpr int baz = bar(10);
  std::cout << baz << "\n";
}
