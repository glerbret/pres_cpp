#include <iostream>

static auto bar(int x)
{
  if(x >= 0) return 2 * x;
  else return -2 * x;
}

static auto fact(unsigned int x)
{
  if(x == 0) return 1U;
  else return x * fact(x-1);
}

int main()
{
  {
    std::cout << bar(5) << '\n';
    std::cout << bar(-2) << '\n';
  }

  {
    std::cout << fact(4) << '\n';
  }
}
