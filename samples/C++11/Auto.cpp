#include <iostream>
#include <vector>

auto add(int a, int b) -> decltype(a + b) 
{
  return a + b;
}

int main()
{
  {
    auto i = 2;
    std::cout << i << " " << typeid(i).name() << " " << typeid(int).name() << "\n";
  }

  {
    auto i = static_cast<unsigned long>(2);
    std::cout << i << " " << typeid(i).name() << " " << typeid(unsigned long).name() << "\n";
  }

  {
    auto i = add(1, 3);
    std::cout << i << " " << typeid(i).name() << " " << typeid(int).name() << "\n";
  }
}
