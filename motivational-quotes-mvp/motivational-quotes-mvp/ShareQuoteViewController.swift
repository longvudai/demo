//
//  ShareQuoteViewController.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import UIKit
import Combine
import SnapKit
import FloatingPanel

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

class ShareQuoteViewController: UIViewController {
    private var color: ColorSet = .orange {
        didSet {
            let primaryColor = color.value
            shareButton.backgroundColor = primaryColor
            openQuoteImageView.tintColor = primaryColor
            contentLabel.textColor = primaryColor
            authorLabel.textColor = primaryColor.withAlphaComponent(0.5)
            hashtagLabel.textColor = primaryColor
            quoteView.backgroundColor = color.bgColor
        }
    }
    private var primaryColor: UIColor = ColorSet.orange.value
    private var primaryBgColor: UIColor = ColorSet.orange.bgColor
    
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
    
    private lazy var shareButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = primaryColor
        v.setTitle("Share this Quote", for: .normal)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private var colorSelectorDataSource: UICollectionViewDiffableDataSource<ColorSelectorCollectionView.Section, ColorSelectorCollectionView.Item>?
    private lazy var colorSelector: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        v.backgroundColor = .clear
        v.delegate = self
        v.register(ColorSelectorCollectionView.Cell.self, forCellWithReuseIdentifier: ColorSelectorCollectionView.Cell._reuseIdentifier)
        
        return v
    }()
    
    private var cancellableSet = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: ShareQuoteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        contentLabel.text = viewModel.quote.content
        authorLabel.text = viewModel.quote.author
        hashtagLabel.text = viewModel.quote.hashTag
        
        viewModel.quoteColor.receive(on: DispatchQueue.main).assign(to: \.color, onWeak: self).store(in: &cancellableSet)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupView()
        setupConstraint()
        
        colorSelectorDataSource = UICollectionViewDiffableDataSource<ColorSelectorCollectionView.Section, ColorSelectorCollectionView.Item>(collectionView: colorSelector) { [weak self] collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectorCollectionView.Cell._reuseIdentifier, for: indexPath) as? ColorSelectorCollectionView.Cell
            else  { return UICollectionViewCell() }
            cell.color = item.color
            if (item.color == self?.color.value) {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                cell.isSelected = true
            }
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ColorSelectorCollectionView.Section, ColorSelectorCollectionView.Item>()
        snapshot.appendSections([.all])
        snapshot.appendItems(viewModel.items, toSection: .all)
        colorSelectorDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupView() {
        // button container
        let buttonContainerViews = [colorSelector, closeButton]
        buttonContainerViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        buttonContainerViews.forEach { buttonContainer.addSubview($0) }
        
        // quote view
        let quoteViews: [UIView] = [openQuoteImageView, contentLabel, authorLabel, hashtagLabel]
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
            $0.height.equalTo(quoteView.snp.width)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        // button container
        colorSelector.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(closeButton.snp.leading).inset(-16)
            $0.height.equalToSuperview()
        }
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26.67)
        }
        
        // quote view
        openQuoteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(openQuoteImageView.snp.bottom).inset(-22.5)
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

extension ShareQuoteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.changeQuoteColor(index: indexPath.row)
    }
}
