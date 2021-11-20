import Foundation
import XCTest
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true

// singleton
class EventLogger {
    private init() {}
    
    static let shared = EventLogger()
    private var logs: [String: String] = [:]
    
    private let serialQueue = DispatchQueue(label: "EventLoggerSerialQueue")
    private let concurrentQueue = DispatchQueue(label: "EventLoggerConcurrentQueue", attributes: .concurrent)
    
    func readLogWithConcurrentQueue(for key: String) -> String? {
        // thread safe by concurrent queue
        concurrentQueue.sync {
            return logs[key]
        }
    }
    
    func readLogWithSerialQueue(for key: String) -> String? {
        // thread safe by serial queue
        serialQueue.sync {
            return logs[key]
        }
    }
    
    func readLog(for key: String) -> String? {
        // Not thread safe
        return logs[key]
    }
    
    func writeLog(key: String, value: String) {
        // Not thread safe
        logs[key] = value
    }
    
    func writeLogWithConcurrentQueue(key: String, value: String) {
        // thread safe by concurrent queue
        concurrentQueue.async(flags: .barrier) {
            self.logs[key] = value
        }
    }
    
    func writeLogWithSerialQueue(key: String, value: String) {
        // thread safe by serial queue
        serialQueue.sync {
            logs[key] = value
        }
    }
}

// Test class
class SingletonThreadSafeTests: XCTestCase {
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    private let maxCount = 10_000
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSingleReadAndWrite() {
        EventLogger.shared.writeLog(key: "k1", value: "v1")
        
        XCTAssert(EventLogger.shared.readLog(for: "k1") == "v1")
    }
    
//    func testRaceCondition() {
//        let expectation = expectation(description: "Multithread access event logs")
//        var currentKey: String = ""
//        let strings = (0..<3000).map { String($0) }
//
//        for key in strings {
//            currentKey = "\(key)"
//            concurrentQueue.async {
//                EventLogger.shared.writeLog(key: currentKey, value: currentKey)
//            }
//        }
//
//        for _ in (0..<3000) {
//            EventLogger.shared.readLog(for: currentKey)
//        }
//
//        expectation.fulfill()
//
//        waitForExpectations(timeout: 5) { error in
//            XCTAssertNil(error, "Failed")
//        }
//    }
    
    func testAvoidRaceConditionBySerialQueue() {
        let expectation = expectation(description: "Multithread access event logs")
        var currentKey: String = ""
        let strings = (0..<maxCount).map { String($0) }
        
        benchmark(name: "testAvoidRaceConditionBySerialQueue") {
            for key in strings {
                currentKey = "\(key)"
                concurrentQueue.async {
                    EventLogger.shared.writeLogWithSerialQueue(key: currentKey, value: currentKey)
                }
            }
            
            for _ in (0..<maxCount) {
                EventLogger.shared.readLogWithSerialQueue(for: currentKey)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Failed")
        }
    }
    
    func testAvoidRaceConditionByConcurrentQueue() {
        let expectation = expectation(description: "Multithread access event logs")
        var currentKey: String = ""
        let strings = (0..<maxCount).map { String($0) }
        
        benchmark(name: "testAvoidRaceConditionByConcurrentQueue") {
            for key in strings {
                currentKey = "\(key)"
                concurrentQueue.async {
                    EventLogger.shared.writeLogWithConcurrentQueue(key: currentKey, value: currentKey)
                }
            }
            
            for _ in (0..<maxCount) {
                EventLogger.shared.readLogWithConcurrentQueue(for: currentKey)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Failed")
        }
    }
}

SingletonThreadSafeTests.defaultTestSuite.run()
