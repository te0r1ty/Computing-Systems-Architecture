#include <semaphore.h>

extern std::vector<Pin> buffer;
extern std::vector<Pin> qualifiedBuffer;

extern int straighteners;
extern int sharpers;
extern int qualifiers;
extern int pins;

extern int curved;
extern int dull;
extern int usable;

int sharpened;
int straight;

sem_t straight_pins_sem;
sem_t straight_pins_available;
sem_t sharpened_pins_sem;
sem_t sharpened_pins_available;

std::vector<Pin> straightBuff;
std::vector<Pin> sharpBuff;

pthread_mutex_t straightMutex;
pthread_mutex_t sharpMutex;
pthread_mutex_t qualityMutex;

void* StraightChecker(void* param) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> straightRand(2, 8);
    Sleep(straightRand(gen) * 100);
    
    for (int i = *(int*)param; i < buffer.size(); i += straighteners) {
        if (buffer[i].isStraight()) {
            sem_wait(&straight_pins_available);
            straightBuff.push_back(buffer[i]);
            sem_post(&straight_pins_sem);
            straight++;
            continue;
        }
        curved++;
    }

    pthread_mutex_lock(&straightMutex);
    std::cout << '#' << *(int*)param + 1 << " Straightness checker ended it's job." << std::endl;
    pthread_mutex_unlock(&straightMutex);

    return nullptr;
}

void* Sharpener([[maybe_unused]] void* param) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> straightRand(3, 7);
    Sleep(straightRand(gen) * 100);

    while (pins != curved + sharpened) {
        pthread_mutex_lock(&sharpMutex);
        sem_wait(&straight_pins_sem);

        if (straightBuff.empty()) {
            pthread_mutex_unlock(&sharpMutex);
            continue;
        }

        sem_wait(&sharpened_pins_available);

        Pin tmp = straightBuff[0];
        straightBuff.erase(straightBuff.begin());
        std::uniform_int_distribution<> sharpnessRand(0, 2);
        tmp.setSharpened(sharpnessRand(gen));
        sharpened++;
        sharpBuff.push_back(tmp);

        sem_post(&straight_pins_available);
        sem_post(&sharpened_pins_sem);
        pthread_mutex_unlock(&sharpMutex);
    }

    return nullptr;
}

void* Qualifier([[maybe_unused]] void* param) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> straightRand(4, 6);
    Sleep(straightRand(gen) * 100);

    while (usable + dull + curved != pins) {
        pthread_mutex_lock(&qualityMutex);
        sem_wait(&sharpened_pins_sem);

        if(sharpBuff.empty()) {
            pthread_mutex_unlock(&qualityMutex);
            continue;
        }

        Pin tmp = sharpBuff[0];
        sharpBuff.erase(sharpBuff.begin());

        if (!tmp.isSharpened()) {
            dull++;
            sem_post(&sharpened_pins_available);
            pthread_mutex_unlock(&qualityMutex);
            continue;
        }

        tmp.setUsable(true);
        qualifiedBuffer.push_back(tmp);
        usable++;

        sem_post(&sharpened_pins_available);
        pthread_mutex_unlock(&qualityMutex);
    }

    return nullptr;
}

[[noreturn]] void* Unblocking(void* param){
    sem_t n = *(sem_t*)param;
    while (true)
        sem_post(&n);
}

void* Factory([[maybe_unused]] void *param) {
    sem_init(&straight_pins_sem, 0, 0);
    sem_init(&sharpened_pins_sem, 0, 0);
    sem_init(&straight_pins_available, 0, 1);
    sem_init(&sharpened_pins_available, 0, 1);

    pthread_mutex_init(&straightMutex, nullptr);
    pthread_mutex_init(&sharpMutex, nullptr);
    pthread_mutex_init(&qualityMutex, nullptr);


    int thrNum[3];
    auto* straight_threads = new pthread_t[straighteners];
    for (int i = 0; i < straighteners; ++i) {
        thrNum[i] = i;
        pthread_create(&straight_threads[i], nullptr, StraightChecker, (void*)& thrNum[i]);
    }
    std::cout << std::endl << "All straight checkers started to work" << std::endl;
    Sleep(300);

    auto* sharp_threads = new pthread_t[sharpers];
    for (int i = 0; i < sharpers; ++i) {
        pthread_create(&sharp_threads[i], nullptr, Sharpener, nullptr);
    }
    std::cout << "All sharpeners started to work" << std::endl;
    Sleep(300);
    
    auto* quality_threads = new pthread_t[qualifiers];
    for (int i = 0; i < qualifiers; ++i) {
        pthread_create(&quality_threads[i], nullptr, Qualifier, nullptr);
    }
    std::cout << "All qualifiers started to work" << std::endl << std::endl;
    Sleep(300);


    for (int i = 0; i < straighteners; ++i) {
        pthread_join(straight_threads[i], nullptr);
    }
    std::cout << std::endl << "All straight checkers ended their job." << std::endl;
    pthread_t fixer1;
    pthread_create(&fixer1, nullptr, Unblocking, (void*)& straight_pins_sem);
    Sleep(300);

    for (int i = 0; i < sharpers; ++i) {
        pthread_join(sharp_threads[i], nullptr);
    }
    std::cout << "All sharpeners ended their job." << std::endl;
    pthread_t fixer2;
    pthread_create(&fixer2, nullptr, Unblocking, (void*)& sharpened_pins_sem);
    Sleep(300);

    for (int i = 0; i < qualifiers; ++i) {
        pthread_join(quality_threads[i], nullptr);
    }
    std::cout << "All quality checkers ended their job." << std::endl << std::endl;
    Sleep(300);

    return nullptr;
}
