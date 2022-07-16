import WebKit

enum JQueryScript {
    static func core() -> WKUserScript {
        return WKUserScript.fromFile("jquery.min", type: "js")
    }
    
    static func jsScript() -> WKUserScript {
        return WKUserScript.fromFile("jquery", type: "js")
    }
    
    enum Handler: String {
        case image
        case handleUrl
        case openSound
        
        init?(_ message: WKScriptMessage) {
            self.init(rawValue: message.name)
        }
    }
    
    enum Evaluate {
        static func scrollToElementBy(_ id: String) -> String {
            return "scrollToElementBy('\(id)')"
        }
    }
}
