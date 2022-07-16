//
//  String+Extension.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

extension String {
    func toBase64String() -> String? {
        let plainData = self.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
}
