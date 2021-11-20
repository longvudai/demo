import Foundation
import XCTest
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct TodoItem {
    let title: String
    let dueBy: Date?
    
    init(title: String) {
        self.title = title
        self.dueBy = nil
    }
}

class TodoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testTodo() {
        let taskTitle = "finish laundry"
        let todo = TodoItem(title: taskTitle)
        XCTAssertEqual(todo.title, taskTitle)
    }
}

TodoTests.defaultTestSuite.run()
