#include <utility>
#include <typeinfo>
#include <cassert>

struct foo
{
  foo(const foo&) {}
  int bar() const { return 1; }
};

int main()
{
#if 0
  decltype(foo().bar()) a = 5;
#endif
  decltype(std::declval<foo>().bar()) b = 5;

  assert(typeid(b) == typeid(int));
}
