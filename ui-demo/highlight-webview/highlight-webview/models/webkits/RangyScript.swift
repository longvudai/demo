import WebKit

enum RangyScript {
    static func core() -> WKUserScript {
        return WKUserScript.fromFile("rangy-core.min", type: "js")
    }
    
    static func classapplier() -> WKUserScript {
        return WKUserScript.fromFile("rangy-classapplier.min", type: "js")
    }
    
    static func highlighter() -> WKUserScript {
        return WKUserScript.fromFile("rangy-highlighter.min", type: "js")
    }
    
    static func selectionsaverestore() -> WKUserScript {
        return WKUserScript.fromFile("rangy-selectionsaverestore.min", type: "js")
    }
    
    static func textrange() -> WKUserScript {
        return WKUserScript.fromFile("rangy-textrange.min", type: "js")
    }
}
