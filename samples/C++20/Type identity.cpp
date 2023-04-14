#include <iostream>
#include <type_traits>

template<class T>
#if 1
T foo(T a, std::type_identity_t<T> b)
#else
T foo(T a, T b)
#endif
{
  return a + b;
}

int main()
{
  std::cout << foo(4.2, 3) << "\n";
}
