#include <array>
#include <iostream>

int main()
{
  {
    auto foo = std::to_array("foo");
    std::cout << foo.size() << "\n";
    for(const auto c : foo)
    {
      std::cout << c << " ";
    }
    std::cout << "\n";
  }

  {
    auto foo = std::to_array({1, 2, 5, 42, 58});
    std::cout << foo.size() << "\n";
    for(const auto c : foo)
    {
      std::cout << c << " ";
    }
    std::cout << "\n";
  }

  {
    long foo[] = {1, 2, 5, 42, 33, 12};
    auto bar = std::to_array(foo);
    std::cout << bar.size() << "\n";
    for(const auto c : bar)
    {
      std::cout << c << " ";
    }
    std::cout << "\n";
  }
}
