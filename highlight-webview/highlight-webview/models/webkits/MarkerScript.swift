//
//  MarkerScript.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import WebKit

enum MarkerScript {
    enum Handler: String {
        case serialize
        case erase
        
        init?(_ message: WKScriptMessage) {
            self.init(rawValue: message.name)
        }
    }
    
    enum Evaluate {
        static func highlightSelectedTextWithColor(_ color: MarkerColor) -> String {
            return "highlightSelectedTextWithColor('\(color.rawValue)')"
        }
        
        static func removeAllHighlights() -> String {
            return "removeAllHighlights()"
        }
        
        static func erase() -> String {
            return "erase()"
        }
        
        static func deserializeData(serialized: String) -> String {
            return "deserializeData('\(serialized)')"
        }
        
        static func clearSelection() -> String {
            return "clearSelection()"
        }
        
        static func removeHighlightById(id: Int) -> String {
            return "removeHighlightById(\(id))"
        }
    }
    
    static func jsScript() -> WKUserScript {
        return WKUserScript.fromFile("marker", type: "js")
    }
    
    static func css() -> WKUserScript {
        return WKUserScript.fromFile("marker", type: "css")
    }
}

