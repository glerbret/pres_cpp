#include <iostream>

auto foo(auto a, auto b)
{
  return a + b;
};

int main()
{
  std::cout << foo(4, 3) << "\n";
}
