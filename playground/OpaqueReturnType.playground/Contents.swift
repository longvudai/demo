import UIKit

var greeting = "Hello, playground"

protocol MobileOS {
    associatedtype V
    var version: V { get }
    init(version: V)
}

struct iOS: MobileOS {
    var version: String
}

struct Android: MobileOS {
    var version: String
}

// Solu 1 Protocol type

//Provides strong guarantees of underlying identity by returning a specific type in runtime. The trade off is losing flexibility of returning multiple type of value offered by using protocol as return type.
//The compiler doesn’t preserve the type identity of the returned value when using protocol as return type.
//func buildPreferredOS() -> MobileOS {
//    return iOS(version: "13.1")
//}

// Solution 2 (Returns Concrete Type):
func buildPreferredOS() -> iOS {
    return iOS(version: "13.1")
}

//=> ko hop ly

//Solution 3 (Generic Function Return)
func buildPreferredOS3<T: MobileOS>(version: T.V) -> T {
    return T(version: version)
}
let android: Android = buildPreferredOS3(version: "Jelly Bean")
let ios: iOS = buildPreferredOS3(version: "5.0")


// Final Solution (Opaque Return Type to the rescue 😋:)
func buildPreferredOS4() -> some MobileOS {
    return iOS(version: "13.1")
}


// => Opaque returns types can only return one specific type


// Protocol without associate type
protocol DesktopOS {
}

struct MacOS: DesktopOS {
    let name = "Mac big sur"
}
struct WindowOS: DesktopOS {
    let shit = "shit"
}

func makePreferredDesktopOS() -> DesktopOS {
    return MacOS()
}

makePreferredDesktopOS()




