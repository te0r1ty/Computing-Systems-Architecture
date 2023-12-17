#include <iostream>
#include <pthread.h>
#include <windows.h>
#include <random>

pthread_mutex_t mutex;
const int threadNumber = 20;

void *Number(void *param) {    //вычисление суммы квадратов в потоке
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> timeRand(1, 7);
    std::uniform_int_distribution<> numRand(1, 20);

    int n = timeRand(gen);
    Sleep(n * 1000);

    pthread_mutex_lock(&mutex);
    int* num = (int*)param;
    std::cout << "Generated #" << *num << " number\n";
    pthread_mutex_unlock(&mutex);

    *num = numRand(gen);

    return nullptr;
}

int main() {
    pthread_mutex_init(&mutex, nullptr);
    srand((unsigned)time(nullptr));
    int nums[threadNumber];
    for (int i = 0; i < threadNumber; ++i) {
        nums[i] = i + 1;
    }
    pthread_t threads[threadNumber];


    for (int i = 0; i < threadNumber; ++i) {
        pthread_create(&threads[i], nullptr, Number, (void *) &nums[i]);
    }




    for (auto thread : threads) {    // ожидание завершения работы дочерних потоков
        pthread_join(thread, nullptr);
    }
    for (int num : nums) {
        std::cout << num << std::endl;
    }
    return 0;
}
