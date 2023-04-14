#include <iostream>
#include <string>
#include <cassert>

using namespace std::literals;

int main()
{
  auto s1 = "Abcd";
  auto s2 = "Abcd"s;

#if 1
  assert(typeid(s1) == typeid(std::string));
#endif
  assert(typeid(s2) == typeid(std::string));
}
