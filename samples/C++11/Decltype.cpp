#include <typeinfo>
#include <cassert>

int main()
{
  int a;
  long b;

  decltype (a) c;
  decltype (a + b) d;

  assert(typeid(c) == typeid(int));
  assert(typeid(d) == typeid(long));

#if 0
  decltype( (a) ) e;
#endif
}
