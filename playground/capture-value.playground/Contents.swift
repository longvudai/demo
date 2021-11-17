import UIKit

// MARK: - Capture list value with
class A {
    var a: Int
    init(a: Int) {
        self.a = a
    }
}

let var1 = 1
let var2 = A(a: 2)
let var3 = 3
let var4 = A(a: 4)

let captureListClosure = { [
    var1,
    unowned var2,
    // alias
    aliasVar3 = var3,
    // alias with self/unowned
    weak aliasVar4 = var4
] in
    return var1 + var2.a + aliasVar3 + (aliasVar4?.a ?? 0)
}
captureListClosure()


// MARK: - Value type
struct Calculator {
    var a: Int
    var b: Int

    var sum: Int {
        return a + b
    }
}

// default variable capture
var calculator1 = Calculator(a: 3, b: 5)
let defaultVariableCaptureclosure = {
    return calculator1.sum
}
// change value outside
calculator1.b = 20

defaultVariableCaptureclosure() // Prints "The result is 23"

// Explicit variable capture
var calculator2 = Calculator(a: 3, b: 5)
let explicitVariableCapture = { [calculator2] in
    return calculator2.sum
}

calculator2.b = 20
explicitVariableCapture()

// MARK: - Reference Type

