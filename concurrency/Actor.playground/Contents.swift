import Foundation
import PlaygroundSupport
import _Concurrency

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

// Actor là reference type
actor ChickenFeeder {
    let food = "worms"
    var numberOfEatingChickens: Int = 0
    
    func chickenStartsEating() {
        numberOfEatingChickens += 1
    }
    
    func chickenStopsEating() {
        numberOfEatingChickens -= 1
    }
    
    // Nonisolated access within Actors
    // Methods in actors are isolated by default.
    // Không phải methods nào cũng truy nhập isolated data. => We can mark our method with the nonisolated keyword to tell the Swift compiler our method is not accessing any isolated data:
    nonisolated func printWhatChickensAreEating() {
        print("Chickens are eating \(food)")
    }
}

// Actor vẫn có thể adopt Protocol. Nhưng không thể kế thừa giống class.
extension ChickenFeeder: CustomStringConvertible {
    // Note that you can use the nonisolated keyword for computed properties as well, which is helpful to conform to protocols like CustomStringConvertible
    nonisolated var description: String {
        "A chicken feeder feeding \(food)"
    }
}

let feeder = ChickenFeeder()

// access immutable data as normal
feeder.food
feeder.printWhatChickensAreEating()

// But can not with mutable data => must use await
Task {
    await feeder.numberOfEatingChickens
    await feeder.chickenStartsEating()
    print(await feeder.numberOfEatingChickens)
}
