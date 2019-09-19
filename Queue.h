
#ifndef _QUEUE_H
#define _QUEUE_H

#include <queue>
#include <mutex>

#include "Semaphore.h"

template<class T>
class Queue {
    std::queue<T *> que;
    std::mutex mutQue;
    Semaphore semQue;

public:

    Queue() : semQue(0) {}
    ~Queue() {
        while (this->getQueueSize() > 0) {
            T * elem = this->dequeue();
            delete elem;
        }
    }
    void enqueue(T * elem) {
        mutQue.lock();
        que.push(elem);
        mutQue.unlock();

        semQue.post();
    }
    T * dequeue() {
        T * elem = 0;

        semQue.wait();

        mutQue.lock();
        if(!que.empty()) {
            elem = que.front();
            que.pop();
        }
        mutQue.unlock();

        return elem;
    }
    unsigned long getQueueSize() {
        return que.size();
    }
};

#endif //_QUEUE_H

