#include <iostream>
#include <format>

int main()
{
  std::cout << std::format("{1} et {0}", "a", "b") << "\n";

  std::cout << std::format("'{:6}'", 42) << "\n";
  std::cout << std::format("'{:6}'", 'x') << "\n";
  std::cout << std::format("'{:06}'", 42) << "\n";
  std::cout << std::format("'{:*<6}'", 'x') << "\n";
  std::cout << std::format("'{:*>6}'", 'x') << "\n";
  std::cout << std::format("'{:*^6}'", 'x') << "\n";

  std::cout << std::format("|{0:4}| |{0:12}|", 10) << "\n";
  std::cout << std::format("|{0:4}| |{0:12}|", 1000000) << "\n";
  std::cout << std::format("|{0:{1}}| |{0:{2}}|", 10, 4, 12) << "\n";

  std::cout << std::format("{:.6f}", 392.65) << "\n";
  std::cout << std::format("{:.6}", "azertyuiop") << "\n";

  std::cout << std::format("{0:},{0:+},{0:-},{0: }", 1) << "\n";
  std::cout << std::format("{0:},{0:+},{0:-},{0: }", -1) << "\n";

  std::cout << std::format("{:+06d}", 120) << "\n";

  std::cout << std::format("{:d}", 42) << "\n";
  std::cout << std::format("{:x} {:X}", 42, 42) << "\n";
  std::cout << std::format("{:b}", 42) << "\n";
  std::cout << std::format("{:o}", 42) << "\n";
  std::cout << std::format("{:X}", 'A') << "\n";
  std::cout << std::format("{:c}", 'A') << "\n";
  std::cout << std::format("{:d}", true) << "\n";
  std::cout << std::format("{:s}", true) << "\n";

  std::cout << std::format("{:.6f}", 392.65) << "\n";
  std::cout << std::format("{:.6g}", 392.65) << "\n";
  std::cout << std::format("{:.6e}", 392.65) << "\n";
  std::cout << std::format("{:.6E}", 392.65) << "\n";
  std::cout << std::format("{:.6a}", 42.) << "\n";
  std::cout << std::format("{:s}", "azerty") << "\n";
  std::cout << std::format("{:#x}", 42) << "\n";
  std::cout << std::format("{:#X}", 42) << "\n";
  std::cout << std::format("{:.6g}", 392.65) << "\n";
  std::cout << std::format("{:#.6g}", 392.65) << "\n";
}
