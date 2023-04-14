#include <iostream>
#include <latch>
#include <thread>

int main()
{
  const size_t nbLatch = 5;
  std::latch l1(nbLatch);
  std::latch l2(1);

  auto work = [&] (int i)
              {
                std::cout << "Entree foo" << i << "\n";
                l1.count_down();
                l2.wait();
                std::cout << "Sortie foo" << i << "\n";
              };

  std::cout << "Demarrage\n";
  std::jthread t[nbLatch];
  for(size_t i = 0; i < nbLatch; ++i)
  {
    t[i] = std::jthread(work, i);
  }

  l1.wait();
  std::cout << "Thread OK\n";
  l2.count_down();
}