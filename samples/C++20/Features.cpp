#include <iostream>

#if 0
#include <numeric>
#endif

int main()
{
#if __has_cpp_attribute(deprecated)
  std::cout << "__has_cpp_attribute(deprecated) " << __has_cpp_attribute(deprecated) << "\n";
#endif

#if __has_cpp_attribute(toto)
  std::cout << "__has_cpp_attribute(toto) " << __has_cpp_attribute(toto) << "\n";
#endif

#if __cpp_attributes
  std::cout << "__cpp_attributes " << __cpp_attributes << "\n";
#endif

#if __cpp_lib_gcd_lcm
  std::cout << "__cpp_lib_gcd_lcm " << __cpp_lib_gcd_lcm << "\n";
#endif
}
