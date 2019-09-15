#include <iostream>
#include <optional>
#include <utility>
#include <complex>
#include <vector>

static std::optional<int> foo(int a)
{
  if(a > 0)
  {
    return a;
  }
  else
  {
    return std::nullopt;
  }
}

int main()
{
  {
    std::optional<std::complex<double>> bar{std::in_place, 3.0, 4.0};
    std::cout << *bar << '\n';

    auto baz = std::make_optional<std::complex<double>>(5.0, 6.0);
    std::cout << *baz << '\n';
  }

  {
    std::optional<std::vector<int>> bar(std::in_place, {1, 2, 3});
    for(const auto it : *bar)
    {
      std::cout << it << ' ';
    }
    std::cout << '\n';
  }

  {
    std::optional bar = foo(42);
    if(bar)
    {
      std::cout << *bar << '\n';
    }
    else
    {
      std::cout << "vide\n";
    }
  }

  {
    std::optional bar = foo(-2);
    if(bar)
    {
      std::cout << *bar << '\n';
    }
    else
    {
      std::cout << "vide\n";
    }
  }

  {
    std::optional bar = foo(-2);
    try
    {
      std::cout << bar.value() << '\n';
    }
    catch(const std::bad_optional_access& e)
    {
      std::cout << e.what() << '\n';
    }
  }

  {
    std::optional bar = foo(-2);
    std::cout << bar.value_or(42) << '\n';
  }

  {
    std::optional<int> deux(2);
    std::optional<int> dix(10);

    std::cout << std::boolalpha;
    std::cout << (dix > deux) << '\n';	// true
    std::cout << (dix < deux) << '\n';	// false
    std::cout << (dix == 10) << '\n';	  // true
  }

  {
    std::optional<int> none;
    std::optional<int> dix(10);

    std::cout << std::boolalpha;
    std::cout << (dix > none) << '\n';	          // true
    std::cout << (dix < none) << '\n';	          // false
    std::cout << (none == 10) << '\n';	          // false
    std::cout << (none == std::nullopt) << '\n';	// true
  }
}
