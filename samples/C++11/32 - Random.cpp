#include <iostream>
#include <random>
#include <chrono>

int main()
{
  {
    std::default_random_engine generator;
    std::uniform_int_distribution<int> distribution(0,9);

    generator.seed(std::chrono::system_clock::now().time_since_epoch().count());
    std::cout << distribution(generator) << '\n';
  }
}
