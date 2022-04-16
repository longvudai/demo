//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport
import SnapKit
import SwiftUI
import UIKit

struct RotationView: View {
    let colors: [Color] = [.red, .green, .blue]

    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        ProtractorView(
            configuration: .init(
                maxValue: 3,
                minValue: -3,
                stepValue: 0.1
            ),
            size: .init(width: 300, height: 40),
            accentColor: .gray,
            valueChanged: { percent, currentValue in
            }
        )
        .frame(width: 300, height: 40)
    }
}

struct ProtractorView: UIViewRepresentable {
    typealias UIViewType = UIView
    let configuration: Configuration
    let size: CGSize
    let accentColor: UIColor
    var valueChanged: ((Double, Double) -> Void)?
    
    let stepWidth: CGFloat = 10
    private var maxContentSize: CGSize {
        let width = CGFloat(configuration.numberOfSteps) * stepWidth + size.width
        let height: CGFloat = 30
        return CGSize(width: width, height: height)
    }

    private func makeLineViews() -> [UIView] {
        let leftPadding: CGFloat = size.width / 2
        return (0 ..< configuration.numberOfLines).map { i -> UIView in
            let isMainLine = CGFloat(i).truncatingRemainder(dividingBy: 10) == 0
            let height: CGFloat = isMainLine ? 14 : 10
            let y: CGFloat = isMainLine ? 11 : 15
            let frame = CGRect(
                x: leftPadding + CGFloat(i) * stepWidth,
                y: y,
                width: 1,
                height: height
            )
            let v = UIView(frame: frame)
            v.layer.cornerRadius = 2
            v.backgroundColor = isMainLine ? accentColor : accentColor.withAlphaComponent(0.7)
            return v
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        let centerX = round(CGFloat(configuration.numberOfSteps) / 2) * stepWidth + size.width / 2
        
        let scrollView: UIScrollView = {
            let v = UIScrollView()
            v.automaticallyAdjustsScrollIndicatorInsets = false
            v.showsHorizontalScrollIndicator = false
            v.delegate = context.coordinator
            v.backgroundColor = .white
            v.contentSize = maxContentSize
            makeLineViews().forEach { lineView in
                v.addSubview(lineView)
            }
            let indicatorView: UIView = {
                let v = UIView(frame: CGRect(x: centerX - 2, y: 2, width: 5, height: 5))
                v.layer.cornerRadius = 5/2
                v.clipsToBounds = true
                v.backgroundColor = accentColor
                return v
            }()
            v.addSubview(indicatorView)
           
            return v
        }()
        
        let verticalLineView: UIView = {
            let frame = CGRect(x: size.width / 2, y: 11, width: 1, height: size.height - 11 * 2)
            let v = UIView(frame: frame)
            v.backgroundColor = accentColor
            return v
        }()
        
        let v = UIView()
        
        v.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        v.addSubview(verticalLineView)
        scrollView.contentOffset.x = centerX - size.width / 2
        return v
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        private let generator = UISelectionFeedbackGenerator()
        private let parent: ProtractorView
        private var size: CGSize {
            parent.size
        }
        
        private var configuration: Configuration {
            parent.configuration
        }
        
        init(_ view: ProtractorView) {
            self.parent = view
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetX = scrollView.contentOffset.x
            let percent = offsetX / (scrollView.contentSize.width - size.width)
            let currentValue = configuration.minValue + percent * (configuration.maxValue - configuration.minValue)
            parent.valueChanged?(percent, currentValue)
            let remainder = offsetX.truncatingRemainder(dividingBy: 10)
            if remainder == 0 {
                generator.selectionChanged()
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            roundPosition(scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                roundPosition(scrollView)
            }
        }
        
        private func roundPosition(_ scrollView: UIScrollView) {
            let offsetX = scrollView.contentOffset.x
            let remainder = offsetX.truncatingRemainder(dividingBy: 10)
            print("reminder", remainder)
            let stepWidth = parent.stepWidth
            UIView.animate(withDuration: 0.1) {
                let offset = remainder >= stepWidth / 2 ? remainder - stepWidth : remainder
                scrollView.contentOffset.x = offsetX - offset
            }
        }
    }
    
    struct Configuration {
        var maxValue: Double = 1
        var minValue: Double = 0
        var stepValue: Double = 0.1
        
        var numberOfSteps: Int {
            if stepValue <= 0 {
                return 0
            }
            return Int(round((maxValue - minValue) / stepValue))
        }
        
        var numberOfLines: Int {
            numberOfSteps + 1
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(RotationView())
