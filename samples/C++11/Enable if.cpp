#include <iostream>
#include <type_traits>

template<class T, typename std::enable_if<std::is_integral<T>::value, T>::type* = nullptr>
void foo(T data)
{
  std::cout << data << "\n";
}

template<class T, typename std::enable_if<!std::is_integral<T>::value, T>::type* = nullptr>
void bar(T)
{
  std::cout << "Generique\n";
}

template<class T,typename std::enable_if<std::is_integral<T>::value, T>::type* = nullptr>
void bar(T)
{
  std::cout << "Entier\n";
}

int main()
{
  foo(42);
#if 0
  foo("azert");
#endif

  bar(42);
  bar("azert");
}