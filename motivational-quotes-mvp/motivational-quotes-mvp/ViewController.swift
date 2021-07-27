//
//  ViewController.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import UIKit
import SnapKit
import FloatingPanel
import Combine

class ViewController: UIViewController {
    
    private var cancellableSet = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<MyCollectionView.Section, MyCollectionView.Item>?
    private var listQuote: [Quote] = [] {
        didSet {
            if !listQuote.isEmpty {
                let randomIndex = Int.random(in: 0..<listQuote.count)
                currentQuote = listQuote[randomIndex]
            }
        }
    }
    private var currentQuote: Quote? {
        didSet {
            shareQuoteViewModel.quote = currentQuote
            if let quote = currentQuote {
                quoteView.content = quote.content
                quoteView.author = quote.author
            }
            
            quoteView.isHidden = currentQuote == nil
        }
    }
    
    private lazy var shareQuoteViewModel: ShareQuoteViewModel = {
        return ShareQuoteViewModel()
    }()
    private lazy var shareQuoteViewController: ShareQuoteViewController = {
        let c = ShareQuoteViewController(viewModel: shareQuoteViewModel)
        return c
    }()
    private lazy var fpc: FloatingPanelController = {
        let c = FloatingPanelController()
        c.layout = ShareQuotePanelLayout()
        c.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        c.isRemovalInteractionEnabled = true
        
        c.surfaceView.appearance.cornerRadius = 10
        
        c.set(contentViewController: shareQuoteViewController)
        
        return c
    }()

    private lazy var collectionView: MyCollectionView = {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfig)
        let v = MyCollectionView(frame: .zero, collectionViewLayout: listLayout)
        v.backgroundColor = .gray
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.delegate = self
        
        return v
    }()
    
    private lazy var quoteView: QuoteView = {
        let v = QuoteView()
        return v
    }()

    override func viewDidLoad() {
        log.info("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let views: [UIView] = [collectionView, quoteView]
        views.forEach { view.addSubview($0) }
        setupConstraint()
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MyCollectionView.Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.textProperties.color = UIColor.blue
            content.secondaryText = item.subtitle
            content.image = item.image
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
        
        applyInitialData()
        
        listQuote = Quote.mockListQuote()
        Timer
            .publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .map { [weak self] date -> Quote? in
                guard let weakSelf = self else {
                    return nil
                }
                let calendar = Calendar.current
                if !weakSelf.listQuote.isEmpty {
                    let randomIndex = (calendar.dateComponents([.second], from: date).second ?? 0) % weakSelf.listQuote.count
                    return weakSelf.listQuote[randomIndex]
                } else {
                    return nil
                }
            }
            .assign(to: \.currentQuote, onWeak: self)
            .store(in: &cancellableSet)
    }
    
    private func setupConstraint() {
        quoteView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(0)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func applyInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<MyCollectionView.Section, MyCollectionView.Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(MyCollectionView.fakeMainSectionItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !quoteView.isHidden else { return }
        let offsetY = scrollView.contentOffset.y
        let newHeight = abs(offsetY)
        if (offsetY < 0) {
            quoteView.snp.updateConstraints {
                $0.height.equalTo(newHeight)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if quoteView.isActiveShare && !quoteView.isHidden {
            present(fpc, animated: true, completion: nil)
            log.info("present")
        }
    }
}
