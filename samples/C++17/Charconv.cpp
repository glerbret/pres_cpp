#include <iostream>
#include <charconv>

int main()
{
  char str[25] = "";
  std::to_chars(std::begin(str), std::end(str), 12.5);
  std::cout << str << "\n";

  double val = 0;
  std::from_chars(std::begin(str), std::end(str), val);
  std::cout << val << "\n";
}
