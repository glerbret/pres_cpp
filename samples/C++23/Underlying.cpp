#include <iostream>
#include <utility>
#include <cstdint>
#include <typeinfo>
#include <cassert>

enum class FOO : uint32_t 
{ 
  A = 0xABCDEF,
};

int main()
{
  auto bar = std::to_underlying(FOO::A);

  assert(typeid(bar) == typeid(uint32_t));
#if 0
  assert(typeid(bar) == typeid(int));
#endif
}
