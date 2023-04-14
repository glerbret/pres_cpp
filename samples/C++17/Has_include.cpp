#include <iostream>
#if __has_include(<optional>)
#  include <optional>
#  define OPT_ENABLE 1
#endif

int main()
{
  std::cout << OPT_ENABLE << "\n";
}
