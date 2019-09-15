#include <iostream>
#include <ratio>


int main()
{
  {
    std::ratio<6, 2> r;
    std::cout << r.num << '/' << r.den << '\n';
  }

  {
    std::ratio_add<std::ratio<6, 2>, std::ratio<2, 3>> r;
    std::cout << r.num << '/' << r.den << '\n';
  }

  {
    std::cout << std::boolalpha << std::ratio_less_equal<std::ratio<6, 2>, std::ratio<2, 3>>::value << '\n';
  }
}
