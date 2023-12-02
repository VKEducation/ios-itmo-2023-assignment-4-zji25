import Foundation

var safeArray = ThreadSafeArray<Int>()
let writeQueue = DispatchQueue(label: "write", attributes: .concurrent)
let writeGroup = DispatchGroup()

for i in 0..<10 {
    writeQueue.async(group: writeGroup) {
        safeArray.append(i)
    }
}

writeGroup.wait()

let readQueue = DispatchQueue(label: "read", attributes: .concurrent)
let readGroup = DispatchGroup()

for i in 0..<safeArray.endIndex {
    readQueue.async(group: readGroup) {
        let element = safeArray[i]
        print("element at index \(i): \(element)")
    }
}

readGroup.wait()
