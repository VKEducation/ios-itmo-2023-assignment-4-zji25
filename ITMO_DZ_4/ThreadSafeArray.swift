import Foundation

class ThreadSafeArray<T>  {
    private var array: [T] = []
    private var rwLock = pthread_rwlock_t()
    
    init() {
        pthread_rwlock_init(&rwLock, nil)
    }

    deinit {
        pthread_rwlock_destroy(&rwLock)
    }
    
    private func readLock() {
       pthread_rwlock_rdlock(&rwLock)
    }

    private func writeLock() {
        pthread_rwlock_wrlock(&rwLock)
    }

    private func unlock() {
        pthread_rwlock_unlock(&rwLock)
    }
}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T
    
    var startIndex: Index {
        readLock()
        defer { unlock() }
        return array.startIndex
    }

    var endIndex: Index {
        readLock()
        defer { unlock() }
        return array.endIndex
    }
    
    subscript(index: Index) -> Element {
        get {
            readLock()
            defer { unlock() }
            return array[index]
        }
    }

    func index(after i: Index) -> Index {
        readLock()
        defer { unlock() }
        return array.index(after: i)
    }

    func append(_ element: T) {
        writeLock()
        defer { unlock() }
        array.append(element)
    }

}
