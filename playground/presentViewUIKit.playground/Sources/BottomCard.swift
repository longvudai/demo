import Combine
import UIKit

public extension UIViewController {
    func presentAsBottomCard(for targetViewController: UIViewController, animated: Bool, completionHandler: (() -> Void)? = nil) {
        targetViewController.modalPresentationStyle = .custom
        targetViewController.transitioningDelegate = BottomCardAnimatedTransitioningDelegate.default
        present(targetViewController, animated: animated, completion: completionHandler)
    }
}

private class BottomCardAnimatedTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static var `default`: BottomCardAnimatedTransitioningDelegate = .init()
    
    private override init() {
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardAnimatedTransitioning.dimissing()
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardAnimatedTransitioning.presenting()
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return BottomCardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

private class BottomCardAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    static func presenting() -> BottomCardAnimatedTransitioning {
        return .init(isPresenting: true)
    }
    
    static func dimissing() -> BottomCardAnimatedTransitioning {
        return .init(isPresenting: false)
    }
    
    private init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.21
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            guard let presentingViewController = transitionContext.viewController(forKey: .to) else {
                return
            }
            
            let targetViewFrame = transitionContext.finalFrame(for: presentingViewController)
            transitionContext.containerView.addSubview(presentingViewController.view)
            presentingViewController.view.frame = CGRect(x: targetViewFrame.minX,
                                                         y: transitionContext.containerView.bounds.maxY,
                                                         width: targetViewFrame.width,
                                                         height: targetViewFrame.height)
            
            let animator = UIViewPropertyAnimator(duration: 0.21, controlPoint1: CGPoint(x: 0.05, y: 0.76), controlPoint2: CGPoint(x: 0.42, y: 0.94)) {
                presentingViewController.view.frame = targetViewFrame
            }
            
            animator.addCompletion { position in
                switch position {
                case .end:
                    transitionContext.completeTransition(true)

                case .current, .start:
                    break
                @unknown default:
                    break
                }
            }
            
            animator.startAnimation()
        } else {
            guard let dismissingViewController = transitionContext.viewController(forKey: .from) else {
                return
            }
            
            let dismissingFrame = CGRect(x: dismissingViewController.view.frame.minX,
                                         y: transitionContext.containerView.bounds.maxY,
                                         width: dismissingViewController.view.frame.width,
                                         height: dismissingViewController.view.frame.height)
            
            let animator = UIViewPropertyAnimator(duration: 0.21, controlPoint1: CGPoint(x: 0.05, y: 0.76), controlPoint2: CGPoint(x: 0.42, y: 0.94)) {
                dismissingViewController.view.frame = dismissingFrame
            }
            
            animator.addCompletion { position in
                switch position {
                case .end:
                    transitionContext.completeTransition(true)

                case .current, .start:
                    break
                @unknown default:
                    break
                }
            }
            
            animator.startAnimation()
        }
    }
}

public enum BottomCardPresentationContentSizing {
    case autoLayout
    case preferredContentSize(size: CGSize)
}

public protocol PresentationBehavior {
    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing { get }
}

public protocol BottomCardPresentationControllerDelegate {
    func presentedViewControllerDidDimiss()
}

private class BottomCardPresentationController: UIPresentationController {
    private lazy var backdropView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBackdrop))
        v.addGestureRecognizer(tap)
        return v
    }()
    private lazy var presentingViewSnapshot: UIView? = presentingViewController.view.snapshotView(afterScreenUpdates: true)
    
    private var bottomOffset: CGFloat { 32 }
    private var maximumContentSize: CGSize {
        guard let containerView = self.containerView else {
            return .zero
        }
        
        let maxWidth: CGFloat = 400
        
        return CGSize(width: min(maxWidth, containerView.frame.width - 32),
                      height: containerView.frame.height - bottomOffset)
    }
    
    private var cancellableSet = Set<AnyCancellable>()
    private var keyboardHeight = CurrentValueSubject<CGFloat, Never>(0)
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return .zero
        }
        
        var contentSize: CGSize = .zero
        
        if let presentationBehavior = presentedViewController as? PresentationBehavior {
            let style = presentationBehavior.bottomCardPresentationContentSizing
            switch style {
            case .autoLayout:
                let targetSize = CGSize(
                    width: min(maximumContentSize.width, containerView.frame.width),
                    height: min(maximumContentSize.height, containerView.frame.height)
                )
                
                // make sure we can calculate swiftui view content correctly
                _ = presentedView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                
                contentSize = presentedView?.systemLayoutSizeFitting(
                    targetSize,
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                ) ?? containerView.frame.size
                
            case .preferredContentSize(let preferredContentSize):
                contentSize = CGSize(
                    width: min(maximumContentSize.width, preferredContentSize.width),
                    height: min(maximumContentSize.height, preferredContentSize.height)
                )
            }
        } else {
            contentSize = CGSize(
                width: min(maximumContentSize.width, containerView.frame.width),
                height: min(maximumContentSize.height, presentedViewController.preferredContentSize.height)
            )
        }
        
        let newFrame = CGRect(
            x: containerView.bounds.midX - (contentSize.width / 2),
            y: containerView.bounds.height - contentSize.height - bottomOffset - keyboardHeight.value,
            width: contentSize.width,
            height: min(UIScreen.main.bounds.height, contentSize.height)
        )
        
        return newFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentingViewSnapshot?.frame = containerView?.bounds ?? .zero
        backdropView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else {
            return
        }
        
        if let presentingViewSnapshot = self.presentingViewSnapshot {
            containerView.addSubview(presentingViewSnapshot)
        }
        
        containerView.addSubview(backdropView)
        
        presentingViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.backdropView.alpha = 0.15
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.backdropView.alpha = 0
            }, completion: { [weak self] _ in
                self?.backdropView.removeFromSuperview()
                self?.presentingViewSnapshot?.removeFromSuperview()
                
                if let source = self?.presentingViewController as? BottomCardPresentationControllerDelegate {
                    print("dismissalTransitionWillBegin", source)
                    source.presentedViewControllerDidDimiss()
                }
            })
    }
    
    @objc
    private func handleTapOnBackdrop() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
