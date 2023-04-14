#include <iostream>

int main()
{
  int bar = 5;

  if(int foo = 42; bar)
  {
    std::cout << foo << '\n';
  }
  else
  {
    std::cout << -foo << '\n';
  }
}
