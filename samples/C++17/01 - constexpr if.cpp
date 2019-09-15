#include <iostream>

template <typename T> auto foo(T t)
{
  if constexpr (std::is_pointer_v<T>)
    return *t;
  else
    return t;
}

template<int N>
constexpr int fibo()
{
  if constexpr (N>=2)
    return fibo<N-1>()+fibo<N-2>();
  else return N;
}

int main()
{
  {
    int a = 10, b = 5;
    int* ptr = &b;
    std::cout << foo(a) << ' ' << foo(ptr) << '\n';
  }

  {
    std::cout << fibo<8>() << '\n';
  }
}
