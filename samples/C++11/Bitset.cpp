#include <iostream>
#include <bitset>

int main()
{
  std::bitset<5> foo;
  std::cout << std::boolalpha << foo.all() << '\n';

  foo.set(2);
  std::cout << std::boolalpha << foo.all() << '\n';
  std::cout << foo.to_ullong() << '\n';

  foo.set();
  std::cout << std::boolalpha << foo.all() << '\n';
  std::cout << foo.to_ullong() << '\n';
}
