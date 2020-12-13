//
//  Marker.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import Foundation
import WebKit

protocol MarkerLogic {
    func erase()
    func highlight(_ color: MarkerColor)
    func removeAll()
}

class Marker: NSObject {
    weak var webView: WKWebView?
    var serializedObject: SerializedObject?
    private var dataStack = Stack<Highlights>()
}

extension Marker: MarkerLogic {
func highlight(_ color: MarkerColor) {
    let script =
        MarkerScript.Evaluate.highlightSelectedTextWithColor(color)
    webView?.evaluateJavaScript(script)
}
    
    func removeAll() {
        let script = MarkerScript.Evaluate.removeAllHighlights()
        webView?.evaluateJavaScript(script)
        dataStack.push([])
    }
    
    func erase() {
        let script = MarkerScript.Evaluate.erase()
        webView?.evaluateJavaScript(script)
    }
}

// MARK: - WKScriptMessageHandler
extension Marker: WKScriptMessageHandler {
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if let markerHandler = MarkerScript.Handler(message) {
            guard
                let dataString = message.body as? String,
                let data = dataString.data(using: .utf8)
                else { return }
            let decoder = JSONDecoder()
            guard let serialized = try? decoder.decode(
                SerializedObject.self,
                from: data
                ) else { return }
            receiveMarkerMessage(markerHandler, data: serialized)
        }
    }
    func receiveMarkerMessage(_ handler: MarkerScript.Handler, data: SerializedObject) {
        switch handler {
        case .serialize:
            serializedObject = data
            
            // your callback here
            
            let script = MarkerScript.Evaluate.clearSelection()
            webView?.evaluateJavaScript(script)
        case .erase:
            serializedObject = data
            let highlights = data.highlights
            let listId = highlights.map { $0.id }
            guard let top = dataStack.top  else { return }
            let newData = top.filter { listId.contains($0.id) }
            if newData != top {
                dataStack.push(newData)
            }
        }
    }
}
