#include <iostream>
#include <utility>

int main()
{
  int i = 1;

  if(i > 0)
  {
    std::cout << "OK\n";
  }
  else
  {
    std::unreachable();
    std::cout << "Unreachable\n";
  }
}
