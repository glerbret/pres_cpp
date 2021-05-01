#include <iostream>

template<typename T>
concept Foo = requires (T x) { x + x; };

template<Foo T>
T foo(T a, T b)
{
  return a + b;
}

int main()
{
  std::cout << foo(5, 2) << "\n";

#if 1
  int *bar, *baz;
  std::cout << foo(bar, baz) << "\n";
#endif
}
