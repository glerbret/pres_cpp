#include <iostream>
#include <barrier>
#include <thread>

int main()
{
  const size_t nb = 5;
  std::barrier b(nb);

  auto work = [&] (int i)
              {
                std::cout << "Entree foo" << i << "\n";
                b.arrive_and_wait();
                std::cout << "Milieu foo" << i << "\n";
                b.arrive_and_wait();
                std::cout << "Sortie foo" << i << "\n";
              };

  std::cout << "Demarrage\n";
  std::jthread t[nb];
  for(size_t i = 0; i < nb; ++i)
  {
    t[i] = std::jthread(work, i);
  }
}
