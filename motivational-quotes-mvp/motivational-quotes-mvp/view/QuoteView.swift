//
//  QuoteView.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import UIKit

class QuoteView: UIView {
    static let maxQuoteViewHeight: CGFloat = 128
    
    var progress: Float = 0
    var content: String = "" {
        didSet {
            contentLabel.text = content
        }
    }
    var author: String = "" {
        didSet {
            authorLabel.text = author
        }
    }
    
    var isActiveShare: Bool = false {
        didSet {
            if isActiveShare {
                if let activeIcon = UIImage(named: "share-active") {
                    shareIconView.image = activeIcon
                }
            } else {
                if let normalIcon = UIImage(named: "share-icon") {
                    shareIconView.image = normalIcon
                }
            }
        }
    }
    
    // UI properties
    private lazy var contentLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        
        v.textColor = .white
        return v
    }()
    
    private lazy var authorLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.textColor = .white
        
        return v
    }()
    
    private lazy var stackView: UIStackView = {
        let views = [contentLabel, authorLabel]
        let v = UIStackView(arrangedSubviews: views)
        v.axis = .vertical
        v.distribution = .equalCentering
        v.alignment = .center
        v.spacing = 4
        return v
    }()
    
    private lazy var shareIconView: UIImageView = {
        let v = UIImageView()
        if let image = UIImage(named: "share-icon") {
            v.image = image
        }
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let progressWidth: CGFloat = 28
    private var progressLayer = CAShapeLayer()
    private lazy var progressView: UIView = {
        let v = UIView()
        v.addSubview(shareIconView)
        shareIconView.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.centerX.centerY.equalTo(v)
        }
        
        return v
    }()
    
    init(content: String, author: String) {
        super.init(frame: .zero)
        
        self.contentLabel.text = content
        self.authorLabel.text = author
        
        setupView()
        setupConstraint()
    }
    
    convenience init() {
        self.init(content: "", author: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(named: "quote-bg-color")
        
        let views = [stackView, progressView]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        views.forEach { addSubview($0) }
        
        
    }
    
    private func setupConstraint() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(26)
            
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(progressWidth)
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
        
        let radius = progressWidth / 2
        createCircularPath(for: progressView, radius: radius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let startProgressViewHeight = progressWidth + 10
        if (frame.height > startProgressViewHeight) {
            let percent = min(1, max(0, frame.height - startProgressViewHeight)/QuoteView.maxQuoteViewHeight)
            progressLayer.strokeEnd = percent
            progressLayer.fillColor = percent == 1 ? UIColor.white.cgColor : UIColor.clear.cgColor
            isActiveShare = percent == 1
            
            progressView.alpha = percent
        }
        progressView.isHidden = startProgressViewHeight > frame.height
        
        let startStackViewHeight = stackView.frame.height
        if (frame.height > startStackViewHeight) {
            let percent = min(1, max(0, frame.height - startStackViewHeight)/QuoteView.maxQuoteViewHeight)
            stackView.alpha = percent
        }
        stackView.isHidden = startStackViewHeight > frame.height
    }
    
    func createCircularPath(for view: UIView, radius: CGFloat) {

        let circleLayer = CAShapeLayer()
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 3/2 * .pi,
            clockwise: true
        )
        
        let lineWidth: CGFloat = 2

        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0

        let anchorLayer = shareIconView.layer
        view.layer.insertSublayer(circleLayer, below: anchorLayer)
        view.layer.insertSublayer(progressLayer, below: anchorLayer)
    }
}
