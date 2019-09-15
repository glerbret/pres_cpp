#include <iostream>
#include <string>

// Condition d'arret
template<typename T>
T sum(T val)
{
  return val;
}

template<typename T, typename... Args>
T sum(T val, Args... values)
{
  return val + sum(values...);
}

int main()
{
  std::cout << sum(1, 5, 56, 9) << '\n';
  std::cout << sum(std::string("Un"), std::string("Deux")) << '\n';
}
