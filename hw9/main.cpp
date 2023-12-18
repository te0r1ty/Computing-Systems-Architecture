#include <iostream>
#include <pthread.h>
#include <windows.h>
#include <random>
#include <vector>

pthread_mutex_t mutex;
pthread_mutex_t sumMutex;
pthread_barrier_t controlBarr;
const int threadNumber = 20;
int sum = 0;
std::vector<int> buffer;

void* Summator([[maybe_unused]] void *param) {
    pthread_mutex_lock(&sumMutex);
    std::cout << "Summing " << buffer[0]<< " and " << buffer[1] << std::endl;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> sleepRand(3, 6);
    Sleep(sleepRand(gen) * 100);
    int tmp1 = buffer[0];
    int tmp2 = buffer[1];
    buffer.erase(buffer.begin());
    buffer.erase(buffer.begin());
    buffer.push_back(tmp1 + tmp2);
    pthread_mutex_unlock(&sumMutex);
    return nullptr;
}

void *Gen(void *param) {    //вычисление суммы квадратов в потоке
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> timeRand(1, 7);
    std::uniform_int_distribution<> numRand(1, 20);

    Sleep(timeRand(gen) * 100);

    pthread_mutex_lock(&mutex);
    int* num = (int*)param;
    std::cout << "Generated #" << *num << " number = ";
    *num = numRand(gen);
    buffer.push_back(*num);
    sum += *num;
    std::cout << *num << std::endl;
    pthread_mutex_unlock(&mutex);

    pthread_barrier_wait(&controlBarr);

    return nullptr;
}

void *Control([[maybe_unused]] void *param) {
    srand((unsigned)time(nullptr));
    int nums[threadNumber];
    for (int i = 0; i < threadNumber; ++i) {
        nums[i] = i + 1;
    }
    pthread_t generators[threadNumber];
    for (int i = 0; i < threadNumber; ++i) {
        pthread_create(&generators[i], nullptr, Gen, (void *) &nums[i]);
    }

    while(buffer.size() < 2) {}

    pthread_t summator[threadNumber - 1];
    for (int i = 0; i < threadNumber - 1; ++i) {
        pthread_create(&summator[i], nullptr, Summator, nullptr);
    }
    for(int i = 0; i < threadNumber - 1; ++i) {
        pthread_join(summator[i], nullptr);
        std::cout << "joined #" << i << " summator thread" << std::endl;
    }

    std::cout << "All summator threads joined" << std::endl;

    for (auto thread : generators) {    // ожидание завершения работы дочерних потоков
        pthread_join(thread, nullptr);
    }

    return nullptr;
}

int main() {
    pthread_mutex_init(&mutex, nullptr);
    pthread_mutex_init(&sumMutex, nullptr);
    pthread_barrier_init(&controlBarr, nullptr, 2);

    pthread_t controller;
    pthread_create(&controller, nullptr, Control, nullptr);

    pthread_join(controller, nullptr);
    std::cout << "Non multi-thread sum = " << sum << std::endl << "Multi-thread sum = " << buffer[0];
    return 0;
}
