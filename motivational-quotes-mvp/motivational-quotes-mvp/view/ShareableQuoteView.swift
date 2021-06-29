//
//  ShareableQuoteView.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/29/21.
//

import Foundation
import UIKit

class ShareableQuoteView: UIView {
    var quote: Quote? {
        didSet {
            contentLabel.text = quote?.content
            authorLabel.text = quote?.author
            hashtagLabel.text = quote?.hashTag
        }
    }
    private var primaryColor: UIColor = .clear {
        didSet {
            openQuoteImageView.tintColor = primaryColor
            contentLabel.textColor = primaryColor
            authorLabel.textColor = primaryColor.withAlphaComponent(0.5)
            hashtagLabel.textColor = primaryColor
        }
    }
    
    private var primaryBgColor: UIColor = .clear {
        didSet {
            backgroundColor = primaryBgColor
        }
    }
    
    private lazy var openQuoteImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "open-quote"))
        v.contentMode = .scaleToFill
        v.tintColor = primaryColor
        return v
    }()
    
    private lazy var contentLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 0
        v.textColor = primaryColor
        v.font = UIFont.systemFont(ofSize: 26)
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
    
    private lazy var stackView: UIStackView = {
        let views = [contentLabel, authorLabel]
        let v = UIStackView(arrangedSubviews: views)
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .center
        v.spacing = 8
        return v
    }()
    
    // MARK: - Initialization
    init(quote: Quote?) {
        self.quote = quote
        
        super.init(frame: .zero)
        
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = primaryBgColor
        layer.cornerRadius = 10
        
        let quoteViews: [UIView] = [openQuoteImageView, stackView, hashtagLabel]
        quoteViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        quoteViews.forEach { addSubview($0) }
    }
    
    private func setupConstraint() {
        // quote view
        openQuoteImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(stackView.snp.top).inset(-22.5)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview()
            $0.width.equalToSuperview().inset(32.5)
        }
        
        hashtagLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13.5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - api
    func updateColor(primaryColor: UIColor, bgColor: UIColor) {
        self.primaryColor = primaryColor
        self.primaryBgColor = bgColor
    }
}
