#include <iostream>
#include <chrono>
#include <format>

int main()
{
  std::cout << std::format("{:%F %T}", std::chrono::system_clock::now());
}
