#include <iostream>
#include <tuple>
#include <string>

class Foo
{
public:
  template <int N> auto& get() const
  {
    if constexpr(N == 0)
    {
      return i;
    }
    else
    {
      return s;
    }
  }

private:
  const int i = 42;
  const std::string s{"Hello"};
};

namespace std
{
  template<>
  struct tuple_size<Foo>
    : std::integral_constant<std::size_t, 2> {};

  template<std::size_t N>
  struct tuple_element<N, Foo>
  {
    using type = decltype(std::declval<Foo>().get<N>());
  };
}

int main()
{
  const auto [ i, s ] = Foo{};
  std::cout << i << ' ' << s << '\n';
}
