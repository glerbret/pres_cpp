#include <iostream>
#include <typeinfo>

int main()
{
  auto i = 5uz;
  auto j = 5z;

  std::cout << std::boolalpha;
  std::cout << (typeid(i) == typeid(size_t)) << "\n";
  std::cout << (typeid(i) == typeid(int)) << "\n";
  std::cout << (typeid(j) == typeid(size_t)) << "\n";
  std::cout << (typeid(j) == typeid(ptrdiff_t)) << "\n";
}
