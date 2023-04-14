#include <iostream>
#include <string>

template<typename ... T>
typename std::common_type<T...>::type sum(T ... t)
{
  typename std::common_type<T...>::type result{};
  std::initializer_list<int>{ (result += t, 0)... };
  return result;
}

template<typename ... T>
void print(T ... t)
{
  std::initializer_list<int>{ (std::cout << t << " ", 0)... };
}

int main()
{
  std::cout << sum(1, 5, 42, 9) << '\n';
  std::cout << sum(std::string("Un"), std::string("Deux")) << '\n';

  print(1, 2, 3, 5);
}
