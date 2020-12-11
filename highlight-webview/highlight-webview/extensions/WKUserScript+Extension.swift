//
//  WKUserScript+Extension.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import WebKit

extension WKUserScript {
    static func injectViewPort() -> WKUserScript {
        let script = """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width');
            meta.setAttribute('initial-scale', '1.0');
            meta.setAttribute('maximum-scale', '1.0');
            meta.setAttribute('minimum-scale', '1.0');
            meta.setAttribute('user-scalable', 'no');
            document.getElementsByTagName('head')[0].appendChild(meta);
        """
        return WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
    }
    
    static func injectCSSBase64(_ data: String) -> WKUserScript {
        let script = """
            javascript:(function() {
            var parent = document.getElementsByTagName('head').item(0);
            var style = document.createElement('style');
            style.type = 'text/css';
            style.innerHTML = window.atob('\(data)');
            parent.appendChild(style)})()
        """
        return WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
    }
    static func injectJSBase64(_ data: String) -> WKUserScript {
        let script = """
            javascript:(function() {
            var parent = document.getElementsByTagName('head').item(0);
            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.innerHTML = window.atob('\(data)');
            parent.appendChild(script)})()
        """
        return WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
    }
    
    static func fromFile(_ filename: String, type: String) -> WKUserScript {
        guard
            let path = Bundle.main.path(forResource: filename, ofType: type),
            let base64 = try? String(contentsOfFile: path).toBase64String()
            else {
            return WKUserScript()
        }
        var script = WKUserScript.injectJSBase64(base64)
        if type == "css" {
            script = WKUserScript.injectCSSBase64(base64)
        }
        return script
    }
}

