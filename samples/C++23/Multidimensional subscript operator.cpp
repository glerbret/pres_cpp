#include <iostream>
#include <array>

template <typename T, std::size_t Z, std::size_t Y, std::size_t X>
struct Array3d
{
  T& operator[](std::size_t z, std::size_t y, std::size_t x)
  {
    return foo[z * Y * X + y * X + x];
  }

  std::array<T, X * Y * Z> foo;
};
 
int main()
{
  Array3d<int, 4, 3, 2> bar;
  bar[3, 2, 1] = 42;
  std::cout << bar[3, 2, 1] << '\n';
}
