#include <utility>
#include <typeinfo>
#include <cassert>

auto add(int a, int b) -> decltype(a + b) 
{
  return a + b;
}

int main()
{
  auto i = add(1, 3);
  assert(typeid(i) == typeid(int));
}
