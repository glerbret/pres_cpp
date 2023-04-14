#include <iostream>
#include <string>
#include <tuple>
#include <array>
#include <map>
#include <utility>

using namespace std::literals;

struct Foo
{
  int a;
  long b;
  std::string c;
};

static Foo foo()
{
  return Foo{42, 5L, "Hello"s};
}

static std::tuple<int, std::string> bar()
{
  return std::make_tuple(42, "Hello"s);
}

static std::array<int, 2> baz()
{
  std::array<int, 2> arr{42, 5};
  return arr;
}

int main()
{
  {
    auto [x,y,z] = foo();
    std::cout << x << ' ' << y << ' ' << z << '\n';
  }

  {
    auto [x,y] = bar();
    std::cout << x << ' ' << y << '\n';
  }

  {
    auto [x,y] = baz();
    std::cout << x << ' ' << y << '\n';
  }

  {
    std::map<int, std::string> myMap{{1, "Un"s}, {2, "Deux"s}};

    for(const auto& [k,v] : myMap)
    {
      std::cout << k << " : " << v << '\n';
    }

    if(auto [iter, succeeded] = myMap.insert(std::pair<int, std::string>(3, "Trois"s)); succeeded)
    {
      std::cout << iter->second << '\n';
    }

    for(const auto& [k,v] : myMap)
    {
      std::cout << k << " : " << v << '\n';
    }
  }
}
