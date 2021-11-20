import Foundation

public func benchmark(name: String, action: () -> Void) {
    let start = CFAbsoluteTimeGetCurrent()
    // run your work
    action()
    
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("⏱ \(name) Took \(diff) seconds")
}
