//
//  ShareQuoteViewController.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import UIKit
import FloatingPanel

class ShareQuoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
}

class ShareQuotePanelLayout: FloatingPanelLayout {
    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring]  {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    var position: FloatingPanelPosition {
        return .bottom
    }

    open func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.15
    }
}
