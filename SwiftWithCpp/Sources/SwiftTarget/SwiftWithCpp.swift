import ObjcTarget

public struct SwiftWithCpp {
    public private(set) var text: String

    public init() {
        let wrapper = CppWrapper()
        text = wrapper.generateHelloWorld()
    }
}
