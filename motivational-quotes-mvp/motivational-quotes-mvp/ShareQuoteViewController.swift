//
//  ShareQuoteViewController.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import UIKit
import SnapKit
import FloatingPanel

class ShareQuoteViewController: UIViewController {
    private var primaryColor: UIColor = ColorSet.orange.value!
    private var primaryBgColor: UIColor = UIColor(named: "orange-bg")!
    
    private var viewModel: ShareQuoteViewModel
    
    private lazy var closeButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "close"), for: .normal)
        v.contentMode = .scaleToFill
        v.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return v
    }()
    
    private lazy var buttonContainer: UIView = {
        let v = UIView()
        return v
    }()
    
    // start quote content section
    private lazy var openQuoteImageView1: UIImageView = {
        let v = UIImageView(image: UIImage(named: "open-quote"))
        v.contentMode = .scaleToFill
        return v
    }()
    
    private lazy var openQuoteImageView2: UIImageView = {
        let v = UIImageView(image: UIImage(named: "open-quote"))
        v.contentMode = .scaleToFill
        return v
    }()
    
    private lazy var contentLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 0
        v.textColor = primaryColor
        v.font = UIFont.systemFont(ofSize: 26)
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    private lazy var authorLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.textColor = primaryColor.withAlphaComponent(0.5)
        v.font = UIFont.systemFont(ofSize: 14)
        return v
    }()
    
    private lazy var hashtagLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        v.textColor = primaryColor
        v.font = UIFont.systemFont(ofSize: 16)
        return v
    }()
    
    private lazy var quoteView: UIView = {
        let v = UIView()
        v.backgroundColor = primaryBgColor
        v.layer.cornerRadius = 10
        return v
    }()
    
    // end quote content section
    
    //
    private lazy var shareButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = primaryColor
        v.setTitle("Share this Quote", for: .normal)
        v.layer.cornerRadius = 5
        return v
    }()
    
    init(viewModel: ShareQuoteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        contentLabel.text = viewModel.quote.content
        authorLabel.text = viewModel.quote.author
        hashtagLabel.text = viewModel.quote.hashTag

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        // button container
        let buttonContainerViews = [closeButton]
        buttonContainerViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        buttonContainerViews.forEach { buttonContainer.addSubview($0) }
        
        // quote view
        let quoteViews: [UIView] = [openQuoteImageView1, openQuoteImageView2, contentLabel, authorLabel, hashtagLabel]
        quoteViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        quoteViews.forEach { quoteView.addSubview($0) }
        
        let views = [buttonContainer, quoteView, shareButton]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        views.forEach { view.addSubview($0) }
    }
    
    private func setupConstraint() {
        // setup main view constraint
        buttonContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        quoteView.snp.makeConstraints {
            $0.top.equalTo(buttonContainer.snp.bottom).inset(-19)
            $0.bottom.equalTo(shareButton.snp.top).inset(-19)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        // button container
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26.67)
        }
        
        // quote view
        openQuoteImageView1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(155.5)
            $0.width.equalTo(12)
            $0.height.equalTo(24)
        }
        
        openQuoteImageView2.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(155.5)
            $0.width.equalTo(12)
            $0.height.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(openQuoteImageView1.snp.bottom).inset(-22.5)
            $0.leading.trailing.equalToSuperview().inset(32.5)
            $0.height.equalTo(100)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).inset(-8)
            $0.leading.trailing.equalToSuperview().inset(65)
        }
        
        hashtagLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13.5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    @objc
    private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
}

class ShareQuotePanelLayout: FloatingPanelLayout {
    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring]  {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.6, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    var position: FloatingPanelPosition {
        return .bottom
    }

    open func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.15
    }
}

extension ShareQuoteViewController {
    enum ColorSet: String {
        case orange,
        purple,
        blue,
        green,
        red
        
        var value: UIColor? {
            UIColor(named: rawValue)
        }
    }
}
