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

class ShareQuoteViewController: UIViewController {
    private var color: ColorSet = .orange {
        didSet {
            let primaryColor = color.value
            shareButton.backgroundColor = primaryColor
            quoteView.updateColor(primaryColor: color.value, bgColor: color.bgColor)
        }
    }
    
    private var viewModel: ShareQuoteViewModel
    private var cancellableSet = Set<AnyCancellable>()
    
    // UI property
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
        
    private lazy var quoteView: ShareableQuoteView = {
        let v = ShareableQuoteView(quote: viewModel.quote)
        return v
    }()
    
    private lazy var shareButton: UIButton = {
        let v = UIButton()
        v.setTitle("Share this Quote", for: .normal)
        v.layer.cornerRadius = 5
        v.addTarget(self, action: #selector(handleShareQuote), for: .touchUpInside)
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
    
    // MARK: - Initialization
    init(viewModel: ShareQuoteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
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
    }
    
    @objc
    private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleShareQuote() {
        let scale = UIScreen.main.scale
        let width = 1000 / scale
        let size = CGSize(width: width, height: width)
        let quoteImage = quoteView.renderToImage(size: size)
        let items = [quoteImage]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
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
