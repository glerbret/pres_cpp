#include <iostream>
#include <chrono>
#include <format>

int main()
{
  std::cout << std::format("{:%F %T}", std::chrono::utc_clock::now()) << "\n";
  std::cout << std::format("{:%F %T}", std::chrono::gps_clock::now()) << "\n";
  std::cout << std::format("{:%F %T}", std::chrono::tai_clock::now()) << "\n";
  std::cout << std::format("{:%F %T}", std::chrono::file_clock::now()) << "\n";
}
