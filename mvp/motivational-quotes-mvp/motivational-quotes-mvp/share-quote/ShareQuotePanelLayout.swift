//
//  ShareQuotePanelLayout.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/29/21.
//

import Foundation
import FloatingPanel
import UIKit

class ShareQuotePanelLayout: FloatingPanelLayout {
    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring]  {
        let screenWidth = UIScreen.main.bounds.width
        return [
            .half: FloatingPanelLayoutAnchor(absoluteInset: screenWidth + 158 - 32, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    var position: FloatingPanelPosition {
        return .bottom
    }

    open func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.15
    }
}


