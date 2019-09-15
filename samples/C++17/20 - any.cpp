#include <iostream>
#include <any>
#include <utility>
#include <complex>

int main()
{
  {
    std::any a = 1;
    std::cout << std::any_cast<int>(a) << '\n';

    a = 3.14;
    std::cout << std::any_cast<double>(a) << '\n';

    a = true;
    std::cout << std::boolalpha << std::any_cast<bool>(a) << '\n';

#if 0
    std::cout << std::any_cast<int>(a) << '\n';
#endif

    a.emplace<std::complex<double>>(3.0, 4.0);
    std::cout << std::any_cast<std::complex<double>>(a) << '\n';
  }

  {
    std::any a = 1;
    std::cout << std::any_cast<int>(&a) << " - " << *std::any_cast<int>(&a) << '\n';
    std::cout << std::any_cast<double>(&a) << '\n';
  }

  {
    std::any a(std::in_place_type<std::complex<double>>, 3.0, 4.0);
    std::cout << std::any_cast<std::complex<double>>(a) << '\n';
  }

  {
    std::any a = std::make_any<std::complex<double>>(3.0, 4.0);
    std::cout << std::any_cast<std::complex<double>>(a) << '\n';
  }

  {
    std::any a;
    std::cout << std::boolalpha << a.has_value() << '\n';
    a = 5;
    std::cout << std::boolalpha << a.has_value() <<' ' << a.type().name() << '\n';
  }
}
