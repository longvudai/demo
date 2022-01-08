// https://www.objc.io/blog/2018/12/18/atomic-variables/

import Foundation

var greeting = "Hello, playground"

final class Atomic<A> {
    private let queue = DispatchQueue(label: "Atomic serial queue")
    private var _value: A
    init(_ value: A) {
        self._value = value
    }

    var value: A {
        get {
            return queue.sync { self._value }
        }
        set { // BAD IDEA => vì có thể có thread khác sửa giá trị của biến này giữa lúc read và write.
            queue.sync {
                self._value = newValue
            }
        }
    }
    
    // cách an toàn hơn
    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}

var x = Atomic<Int>(5)
x.value += 1 // nếu có thread khác sửa x.value = 10 thì lệnh này sẽ đưa giá trị x.value quay về 6

print(x.value)

// sử dụng cách an toàn hơn
let y = Atomic<Int>(5)
y.mutate { $0 += 1 }
